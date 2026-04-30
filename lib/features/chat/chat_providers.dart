// Providers Riverpod para a tela de chat.
// ChatNotifier coordena: envio de mensagem, chamada à OpenAI, persistência
// no banco, adaptação de nível e controle do limite freemium.
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/level_adapter.dart';
import '../../core/api/openai_client.dart';
import '../../core/api/prompt_builder.dart';
import '../../core/db/database.dart';
import '../../core/models/message.dart';
import '../../core/models/user_profile.dart';
import '../home/home_providers.dart';

// ─── Limite diário gratuito ───────────────────────────────────────────────────

const int kFreeMessagesPerDay = 10;

// ─── Estado do chat ───────────────────────────────────────────────────────────

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final int dailyMessageCount;
  final List<int> recentDifficulties; // últimas N pontuações de dificuldade
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isTyping = false,
    this.dailyMessageCount = 0,
    this.recentDifficulties = const [],
    this.error,
  });

  bool get isFreemiumLimitReached => dailyMessageCount >= kFreeMessagesPerDay;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    int? dailyMessageCount,
    List<int>? recentDifficulties,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      dailyMessageCount: dailyMessageCount ?? this.dailyMessageCount,
      recentDifficulties: recentDifficulties ?? this.recentDifficulties,
      error: error,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier({
    required AppDatabase db,
    required OpenAIClient client,
    required Ref ref,
    required UserProfile user,
  })  : _db = db,
        _client = client,
        _ref = ref,
        _userId = user.id,
        _level = user.level,
        _mode = user.currentMode,
        super(const ChatState()) {
    _initialize();
  }

  final AppDatabase _db;
  final OpenAIClient _client;
  final Ref _ref;
  final int _userId;
  String _level;
  final String _mode;
  bool _isPremium = false;

  void setIsPremium(bool value) => _isPremium = value;

  Future<void> _initialize() async {
    if (_userId <= 0) return;
    final dbMessages = await _db.getAllMessages(_userId);
    final messages = dbMessages
        .map((m) => ChatMessage(
              id: m.id,
              role: m.role == 'user' ? MessageRole.user : MessageRole.assistant,
              content: m.content,
              createdAt: m.createdAt,
            ))
        .toList();

    final dailyCount = await _db.countTodayMessages(_userId);

    state = state.copyWith(
      messages: messages,
      dailyMessageCount: dailyCount,
    );
  }

  Future<void> sendMessage(String text) async {
    if (_userId <= 0 || (!_isPremium && state.isFreemiumLimitReached) || text.trim().isEmpty) return;

    final trimmed = text.trim();
    final userMsg = ChatMessage(
      role: MessageRole.user,
      content: trimmed,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      dailyMessageCount: state.dailyMessageCount + 1,
      error: null,
    );

    // Salva mensagem do usuário no banco
    await _db.insertMessage(MessagesCompanion(
      userId: Value(_userId),
      role: const Value('user'),
      content: Value(trimmed),
    ));

    try {
      // Constrói o system prompt com erros recorrentes do banco
      final corrections = await _db.getTopCorrections(_userId, limit: 5);
      final recentErrors = corrections
          .map((c) => {'wrong': c.wrong, 'correct': c.correct})
          .toList();

      final systemPrompt = PromptBuilder.build(
        level: _level,
        mode: _mode,
        recentErrors: recentErrors,
      );

      // Histórico das últimas 10 mensagens como contexto
      final history = (await _db.getRecentMessages(_userId))
          .map((m) => {'role': m.role, 'content': m.content})
          .toList();

      final aiResponse = await _client.chat(
        systemPrompt: systemPrompt,
        history: history,
      );

      // Salva resposta da IA no banco
      await _db.insertMessage(MessagesCompanion(
        userId: Value(_userId),
        role: const Value('assistant'),
        content: Value(aiResponse.reply),
      ));

      // Persiste correção se houver
      if (aiResponse.correction != null) {
        final parts = aiResponse.correction!.split('→');
        if (parts.length == 2) {
          await _db.upsertCorrection(
            _userId,
            parts[0].trim(),
            parts[1].trim(),
          );
        }
      }

      // Persiste palavras novas
      for (final word in aiResponse.newWords) {
        await _db.insertOrIncrementWord(_userId, word.trim());
      }

      // Adapta nível se necessário
      final newDiffs = [...state.recentDifficulties, aiResponse.difficulty];
      final adaptedLevel = LevelAdapter.adaptLevel(_level, newDiffs);
      if (adaptedLevel != null) {
        _level = adaptedLevel;
        await _ref
            .read(userProfileProvider.notifier)
            .updateLevel(adaptedLevel);
      }

      final assistantMsg = ChatMessage(
        role: MessageRole.assistant,
        content: aiResponse.reply,
        aiResponse: aiResponse,
        createdAt: DateTime.now(),
      );

      // Mantém no máximo 20 dificuldades em memória
      final trimmedDiffs = newDiffs.length > 20
          ? newDiffs.sublist(newDiffs.length - 20)
          : newDiffs;

      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isTyping: false,
        recentDifficulties: trimmedDiffs,
      );
    } on OpenAIException catch (e) {
      state = state.copyWith(isTyping: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Erro inesperado. Tente novamente.',
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

// ─── Provider ────────────────────────────────────────────────────────────────

final openAIClientProvider = Provider<OpenAIClient>((_) => OpenAIClient());

final chatProvider =
    StateNotifierProvider.autoDispose<ChatNotifier, ChatState>((ref) {
  final db = ref.read(databaseProvider);
  final client = ref.read(openAIClientProvider);
  // ref.watch garante que o provider se recria quando userProfileProvider
  // termina de carregar (IndexedStack constrói ChatScreen antes do load).
  final user = ref.watch(userProfileProvider).valueOrNull ??
      const UserProfile(
        id: 0,
        name: 'Student',
        level: 'beginner',
        currentMode: 'casual',
        streak: 0,
      );
  return ChatNotifier(db: db, client: client, ref: ref, user: user);
});
