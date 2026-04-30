// Banco de dados local usando Drift (SQLite).
// Execute `dart run build_runner build` para gerar database.g.dart.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// ─── Tabelas ────────────────────────────────────────────────────────────────

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

// ─── Conexão ────────────────────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'lingua_ai.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

// ─── Database ───────────────────────────────────────────────────────────────

@DriftDatabase(tables: [Users, Messages, Corrections, NewWords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(newWords, newWords.definition);
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
