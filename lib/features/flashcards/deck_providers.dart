import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/gemini_client.dart';
import '../../core/db/database.dart';
import '../home/home_providers.dart';

// ─── SRS helper ───────────────────────────────────────────────────────────────

/// SM-2 simplified: returns (repetitions, easeFactor, intervalDays).
/// quality: 0=Again, 1=Hard, 2=Good, 3=Easy
({int repetitions, double easeFactor, int intervalDays}) computeSRS({
  required int repetitions,
  required double easeFactor,
  required int intervalDays,
  required int quality,
}) {
  switch (quality) {
    case 0: // Again — failed, reset
      return (
        repetitions: 0,
        easeFactor: max(1.3, easeFactor - 0.2),
        intervalDays: 1,
      );
    case 1: // Hard — correct but struggled, keep interval
      return (
        repetitions: repetitions,
        easeFactor: max(1.3, easeFactor - 0.15),
        intervalDays: max(1, intervalDays),
      );
    case 2: // Good — normal progression
      final newReps = repetitions + 1;
      final newInterval = repetitions == 0
          ? 1
          : repetitions == 1
              ? 3
              : (intervalDays * easeFactor).ceil();
      return (
        repetitions: newReps,
        easeFactor: easeFactor,
        intervalDays: newInterval,
      );
    case 3: // Easy — accelerated progression
      final newReps = repetitions + 1;
      final newEF = min(3.0, easeFactor + 0.15);
      final newInterval = repetitions == 0
          ? 3
          : repetitions == 1
              ? 7
              : (intervalDays * newEF * 1.3).ceil();
      return (
        repetitions: newReps,
        easeFactor: newEF,
        intervalDays: newInterval,
      );
    default:
      return (
        repetitions: repetitions,
        easeFactor: easeFactor,
        intervalDays: 1,
      );
  }
}

// ─── Decks list state ─────────────────────────────────────────────────────────

class DecksState {
  final List<DbFlashcardDeck> decks;
  final Map<int, int> dueCounts; // deckId → due count
  final bool isLoading;
  final bool isGenerating;
  final String? error;

  const DecksState({
    this.decks = const [],
    this.dueCounts = const {},
    this.isLoading = true,
    this.isGenerating = false,
    this.error,
  });

  DecksState copyWith({
    List<DbFlashcardDeck>? decks,
    Map<int, int>? dueCounts,
    bool? isLoading,
    bool? isGenerating,
    String? error,
  }) {
    return DecksState(
      decks: decks ?? this.decks,
      dueCounts: dueCounts ?? this.dueCounts,
      isLoading: isLoading ?? this.isLoading,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error,
    );
  }
}

class DecksNotifier extends StateNotifier<DecksState> {
  DecksNotifier({
    required AppDatabase db,
    required GeminiClient client,
    required int userId,
  })  : _db = db,
        _client = client,
        _userId = userId,
        super(const DecksState()) {
    _load();
  }

  final AppDatabase _db;
  final GeminiClient _client;
  final int _userId;

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    final decks = await _db.getDecksForUser(_userId);
    final Map<int, int> due = {};
    for (final d in decks) {
      due[d.id] = await _db.getDueCount(d.id);
    }
    state = state.copyWith(decks: decks, dueCounts: due, isLoading: false);
  }

  Future<void> refresh() => _load();

  Future<void> createDeck(String topic, int cardCount) async {
    state = state.copyWith(isGenerating: true, error: null);
    try {
      final cards = await _client.generateFlashcards(topic, cardCount);
      if (cards.isEmpty) throw Exception('Nenhum card gerado.');

      final deckId = await _db.insertDeck(FlashcardDecksCompanion(
        userId: Value(_userId),
        title: Value(topic),
        totalCards: Value(cards.length),
      ));

      await _db.insertFlashcardItems(
        cards
            .map((c) => FlashcardItemsCompanion(
                  deckId: Value(deckId),
                  front: Value(c['front']!),
                  back: Value(c['back']!),
                ))
            .toList(),
      );

      state = state.copyWith(isGenerating: false);
      await _load();
    } on GeminiException catch (e) {
      state = state.copyWith(isGenerating: false, error: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(isGenerating: false, error: 'Erro ao criar deck.');
      rethrow;
    }
  }

  Future<void> deleteDeck(int deckId) async {
    await _db.deleteDeck(deckId);
    await _load();
  }
}

final decksProvider =
    StateNotifierProvider<DecksNotifier, DecksState>((ref) {
  final db = ref.read(databaseProvider);
  final client = GeminiClient();
  final userId = ref.read(userProfileProvider).valueOrNull?.id ?? 0;
  return DecksNotifier(db: db, client: client, userId: userId);
});

// ─── Study session state ──────────────────────────────────────────────────────

class StudyState {
  final List<DbFlashcardItem> queue; // cards left in this session
  final int totalSession;            // cards when session started
  final int againCount;
  final int hardCount;
  final int goodCount;
  final int easyCount;
  final bool isDone;

  const StudyState({
    this.queue = const [],
    this.totalSession = 0,
    this.againCount = 0,
    this.hardCount = 0,
    this.goodCount = 0,
    this.easyCount = 0,
    this.isDone = false,
  });

  DbFlashcardItem? get current => queue.isNotEmpty ? queue.first : null;

  int get reviewed => againCount + hardCount + goodCount + easyCount;

  double get progress =>
      totalSession > 0 ? reviewed / totalSession : 0.0;

  StudyState copyWith({
    List<DbFlashcardItem>? queue,
    int? totalSession,
    int? againCount,
    int? hardCount,
    int? goodCount,
    int? easyCount,
    bool? isDone,
  }) {
    return StudyState(
      queue: queue ?? this.queue,
      totalSession: totalSession ?? this.totalSession,
      againCount: againCount ?? this.againCount,
      hardCount: hardCount ?? this.hardCount,
      goodCount: goodCount ?? this.goodCount,
      easyCount: easyCount ?? this.easyCount,
      isDone: isDone ?? this.isDone,
    );
  }
}

class StudyNotifier extends StateNotifier<StudyState> {
  StudyNotifier({required AppDatabase db, required int deckId})
      : _db = db,
        _deckId = deckId,
        super(const StudyState()) {
    _load();
  }

  final AppDatabase _db;
  final int _deckId;

  Future<void> _load() async {
    final due = await _db.getDueItems(_deckId);
    state = StudyState(queue: due, totalSession: due.length);
  }

  /// quality: 0=Again, 1=Hard, 2=Good, 3=Easy
  Future<void> rate(int quality) async {
    final card = state.current;
    if (card == null) return;

    final srs = computeSRS(
      repetitions: card.repetitions,
      easeFactor: card.easeFactor,
      intervalDays: card.intervalDays,
      quality: quality,
    );

    final nextReview =
        DateTime.now().add(Duration(days: srs.intervalDays));

    await _db.updateItemSRS(
      id: card.id,
      repetitions: srs.repetitions,
      easeFactor: srs.easeFactor,
      intervalDays: srs.intervalDays,
      nextReview: nextReview,
    );

    List<DbFlashcardItem> newQueue;
    if (quality == 0) {
      // Again → vai para o final da fila desta sessão
      newQueue = [...state.queue.skip(1), card];
    } else {
      newQueue = state.queue.skip(1).toList();
    }

    state = state.copyWith(
      queue: newQueue,
      againCount: quality == 0 ? state.againCount + 1 : state.againCount,
      hardCount: quality == 1 ? state.hardCount + 1 : state.hardCount,
      goodCount: quality == 2 ? state.goodCount + 1 : state.goodCount,
      easyCount: quality == 3 ? state.easyCount + 1 : state.easyCount,
      isDone: newQueue.isEmpty,
    );
  }
}

final deckStudyProvider = StateNotifierProvider.autoDispose
    .family<StudyNotifier, StudyState, int>((ref, deckId) {
  final db = ref.read(databaseProvider);
  return StudyNotifier(db: db, deckId: deckId);
});
