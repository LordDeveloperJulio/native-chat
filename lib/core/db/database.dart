// Banco de dados local usando Drift (SQLite).
// Execute `dart run build_runner build` para gerar database.g.dart.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ─── Tabelas ─────────────────────────────────────────────────────────────────

@DataClassName('DbUser')
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get level =>
      text().withDefault(const Constant('beginner'))();
  TextColumn get currentMode =>
      text().withDefault(const Constant('casual'))();
  IntColumn get streak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSessionDate => dateTime().nullable()();
}

@DataClassName('DbMessage')
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get role => text()(); // 'user' | 'assistant'
  TextColumn get content => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DbCorrection')
class Corrections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get wrong => text()();
  TextColumn get correct => text()();
  IntColumn get count => integer().withDefault(const Constant(1))();
  DateTimeColumn get lastSeen =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('DbNewWord')
class NewWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get word => text()();
  IntColumn get seenCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  // v2: definição em inglês gerada pela IA e cacheada localmente
  TextColumn get definition => text().nullable()();
}

// v3: decks de flashcards criados pelo usuário com tema escolhido
@DataClassName('DbFlashcardDeck')
class FlashcardDecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  TextColumn get title => text()();
  IntColumn get totalCards => integer()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// v3: cards individuais com dados do algoritmo SM-2
@DataClassName('DbFlashcardItem')
class FlashcardItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deckId => integer()();
  TextColumn get front => text()();
  TextColumn get back => text()();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(1))();
  DateTimeColumn get nextReview => dateTime().nullable()();
}

// ─── Conexão ────────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lingua_ai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// ─── Database ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Users, Messages, Corrections, NewWords, FlashcardDecks, FlashcardItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(newWords, newWords.definition);
      }
      if (from < 3) {
        await migrator.createTable(flashcardDecks);
        await migrator.createTable(flashcardItems);
      }
    },
  );

  // ── Usuário ────────────────────────────────────────────────────────────────

  Future<DbUser?> getUser() =>
      (select(users)..limit(1)).getSingleOrNull();

  Future<int> createUser(UsersCompanion user) =>
      into(users).insert(user);

  Future<void> updateUser(UsersCompanion user) =>
      (update(users)..where((u) => u.id.equals(user.id.value)))
          .write(user);

  // ── Mensagens ──────────────────────────────────────────────────────────────

  Future<List<DbMessage>> getAllMessages(int userId) =>
      (select(messages)
            ..where((m) => m.userId.equals(userId))
            ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
          .get();

  /// Retorna as últimas [limit] mensagens em ordem cronológica crescente.
  Future<List<DbMessage>> getRecentMessages(int userId,
      {int limit = 10}) async {
    final rows = await (select(messages)
          ..where((m) => m.userId.equals(userId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit))
        .get();
    return rows.reversed.toList();
  }

  /// Conta mensagens do usuário enviadas hoje (role = 'user') para o freemium.
  Future<int> countTodayMessages(int userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final rows = await (select(messages)
          ..where((m) =>
              m.userId.equals(userId) &
              m.role.equals('user') &
              m.createdAt.isBiggerOrEqualValue(startOfDay)))
        .get();
    return rows.length;
  }

  Future<int> totalMessagesCount(int userId) async {
    final rows = await (select(messages)
          ..where((m) => m.userId.equals(userId) & m.role.equals('user')))
        .get();
    return rows.length;
  }

  Future<int> insertMessage(MessagesCompanion msg) =>
      into(messages).insert(msg);

  // ── Correções ──────────────────────────────────────────────────────────────

  Future<List<DbCorrection>> getTopCorrections(int userId,
      {int limit = 10}) =>
      (select(corrections)
            ..where((c) => c.userId.equals(userId))
            ..orderBy([(c) => OrderingTerm.desc(c.count)])
            ..limit(limit))
          .get();

  Future<void> upsertCorrection(
      int userId, String wrong, String correct) async {
    final existing = await (select(corrections)
          ..where((c) =>
              c.userId.equals(userId) & c.wrong.equals(wrong)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(corrections)
            ..where((c) => c.id.equals(existing.id)))
          .write(CorrectionsCompanion(
        count: Value(existing.count + 1),
        lastSeen: Value(DateTime.now()),
      ));
    } else {
      await into(corrections).insert(CorrectionsCompanion(
        userId: Value(userId),
        wrong: Value(wrong),
        correct: Value(correct),
      ));
    }
  }

  // ── Palavras novas ─────────────────────────────────────────────────────────

  Future<int> totalNewWordsCount(int userId) async {
    final rows = await (select(newWords)
          ..where((w) => w.userId.equals(userId)))
        .get();
    return rows.length;
  }

  Future<void> insertOrIncrementWord(int userId, String word) async {
    final existing = await (select(newWords)
          ..where((w) =>
              w.userId.equals(userId) & w.word.equals(word)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(newWords)
            ..where((w) => w.id.equals(existing.id)))
          .write(NewWordsCompanion(
              seenCount: Value(existing.seenCount + 1)));
    } else {
      await into(newWords).insert(NewWordsCompanion(
        userId: Value(userId),
        word: Value(word),
      ));
    }
  }

  // ── Flashcards ────────────────────────────────────────────────────────────

  Future<List<DbNewWord>> getWordsForFlashcard(int userId) =>
      (select(newWords)
            ..where((w) => w.userId.equals(userId))
            ..orderBy([(w) => OrderingTerm.desc(w.createdAt)]))
          .get();

  Future<void> cacheWordDefinition(int wordId, String definition) =>
      (update(newWords)..where((w) => w.id.equals(wordId)))
          .write(NewWordsCompanion(definition: Value<String?>(definition)));

  // ── Decks de flashcards ────────────────────────────────────────────────────

  Future<List<DbFlashcardDeck>> getDecksForUser(int userId) =>
      (select(flashcardDecks)
            ..where((d) => d.userId.equals(userId))
            ..orderBy([(d) => OrderingTerm.desc(d.createdAt)]))
          .get();

  Future<int> insertDeck(FlashcardDecksCompanion deck) =>
      into(flashcardDecks).insert(deck);

  Future<void> insertFlashcardItems(List<FlashcardItemsCompanion> items) async {
    await batch((b) => b.insertAll(flashcardItems, items));
  }

  Future<List<DbFlashcardItem>> getDeckItems(int deckId) =>
      (select(flashcardItems)..where((i) => i.deckId.equals(deckId))).get();

  Future<List<DbFlashcardItem>> getDueItems(int deckId) {
    final now = DateTime.now();
    return (select(flashcardItems)
          ..where((i) =>
              i.deckId.equals(deckId) &
              (i.nextReview.isNull() | i.nextReview.isSmallerOrEqualValue(now))))
        .get();
  }

  Future<int> getDueCount(int deckId) async {
    final items = await getDueItems(deckId);
    return items.length;
  }

  Future<void> updateItemSRS({
    required int id,
    required int repetitions,
    required double easeFactor,
    required int intervalDays,
    required DateTime nextReview,
  }) =>
      (update(flashcardItems)..where((i) => i.id.equals(id))).write(
        FlashcardItemsCompanion(
          repetitions: Value(repetitions),
          easeFactor: Value(easeFactor),
          intervalDays: Value(intervalDays),
          nextReview: Value(nextReview),
        ),
      );

  Future<void> deleteDeck(int deckId) async {
    await (delete(flashcardItems)..where((i) => i.deckId.equals(deckId))).go();
    await (delete(flashcardDecks)..where((d) => d.id.equals(deckId))).go();
  }

  // ── Progresso semanal ──────────────────────────────────────────────────────

  /// Retorna um mapa {DateTime(dia): quantidade de mensagens} para os últimos 7 dias.
  Future<Map<DateTime, int>> weeklyMessageCounts(int userId) async {
    final now = DateTime.now();
    final Map<DateTime, int> result = {};

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      final nextDay = day.add(const Duration(days: 1));
      final rows = await (select(messages)
            ..where((m) =>
                m.userId.equals(userId) &
                m.role.equals('user') &
                m.createdAt.isBiggerOrEqualValue(day) &
                m.createdAt.isSmallerThanValue(nextDay)))
          .get();
      result[day] = rows.length;
    }

    return result;
  }
}
