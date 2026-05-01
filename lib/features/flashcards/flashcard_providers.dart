import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/gemini_client.dart';
import '../../core/db/database.dart';
import '../home/home_providers.dart';

// ─── State ────────────────────────────────────────────────────────────────────

class FlashcardState {
  final List<DbNewWord> deck;
  final int totalOriginal;
  final bool isLoadingDefinition;
  final int knewCount;
  final int didntKnowCount;
  final bool isDone;
  final String? error;

  const FlashcardState({
    this.deck = const [],
    this.totalOriginal = 0,
    this.isLoadingDefinition = false,
    this.knewCount = 0,
    this.didntKnowCount = 0,
    this.isDone = false,
    this.error,
  });

  bool get isEmpty => deck.isEmpty && !isDone;
  DbNewWord? get current => deck.isNotEmpty ? deck.first : null;

  FlashcardState copyWith({
    List<DbNewWord>? deck,
    int? totalOriginal,
    bool? isLoadingDefinition,
    int? knewCount,
    int? didntKnowCount,
    bool? isDone,
    String? error,
  }) {
    return FlashcardState(
      deck: deck ?? this.deck,
      totalOriginal: totalOriginal ?? this.totalOriginal,
      isLoadingDefinition: isLoadingDefinition ?? this.isLoadingDefinition,
      knewCount: knewCount ?? this.knewCount,
      didntKnowCount: didntKnowCount ?? this.didntKnowCount,
      isDone: isDone ?? this.isDone,
      error: error,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class FlashcardNotifier extends StateNotifier<FlashcardState> {
  FlashcardNotifier({
    required AppDatabase db,
    required GeminiClient client,
    required int userId,
  })  : _db = db,
        _client = client,
        _userId = userId,
        super(const FlashcardState()) {
    _load();
  }

  final AppDatabase _db;
  final GeminiClient _client;
  final int _userId;

  Future<void> _load() async {
    final words = await _db.getWordsForFlashcard(_userId);
    words.shuffle();
    state = state.copyWith(
      deck: words,
      totalOriginal: words.length,
      isDone: false,
      knewCount: 0,
      didntKnowCount: 0,
    );
  }

  /// Chamado quando o card é virado para o verso.
  /// Busca a definição da API se ainda não estiver cacheada.
  Future<void> fetchDefinitionIfNeeded() async {
    final word = state.current;
    if (word == null || word.definition != null) return;

    state = state.copyWith(isLoadingDefinition: true, error: null);
    try {
      final definition = await _client.getWordDefinition(word.word);
      await _db.cacheWordDefinition(word.id, definition);

      final updatedDeck = [
        word.copyWith(definition: Value<String?>(definition)),
        ...state.deck.skip(1),
      ];
      state = state.copyWith(
        deck: updatedDeck,
        isLoadingDefinition: false,
      );
    } on GeminiException catch (e) {
      state = state.copyWith(
        isLoadingDefinition: false,
        error: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLoadingDefinition: false,
        error: 'Erro ao carregar definição.',
      );
    }
  }

  /// [knew] = true → remove card (aprendida).
  /// [knew] = false → move para o final do deck (revisar depois).
  void answer(bool knew) {
    if (state.deck.isEmpty) return;

    final List<DbNewWord> newDeck;
    if (knew) {
      newDeck = state.deck.skip(1).toList();
    } else {
      newDeck = [...state.deck.skip(1), state.deck.first];
    }

    state = state.copyWith(
      deck: newDeck,
      knewCount: knew ? state.knewCount + 1 : state.knewCount,
      didntKnowCount: knew ? state.didntKnowCount : state.didntKnowCount + 1,
      isDone: newDeck.isEmpty,
      isLoadingDefinition: false,
      error: null,
    );
  }

  void restart() => _load();
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final flashcardProvider =
    StateNotifierProvider.autoDispose<FlashcardNotifier, FlashcardState>((ref) {
  final db = ref.read(databaseProvider);
  final client = ref.read(_geminiClientProvider);
  final userId = ref.read(userProfileProvider).valueOrNull?.id ?? 0;
  return FlashcardNotifier(db: db, client: client, userId: userId);
});

final _geminiClientProvider = Provider<GeminiClient>((_) => GeminiClient());
