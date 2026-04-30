// Providers Riverpod para a tela Home.
// Gerencia o perfil do usuário e o modo de conversação selecionado.
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../../core/models/user_profile.dart';

// ─── Database provider ───────────────────────────────────────────────────────

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ─── User profile ────────────────────────────────────────────────────────────

class UserProfileNotifier
    extends StateNotifier<AsyncValue<UserProfile?>> {
  UserProfileNotifier(this._db) : super(const AsyncValue.loading()) {
    _load();
  }

  final AppDatabase _db;

  Future<void> _load() async {
    try {
      final dbUser = await _db.getUser();
      if (dbUser == null) {
        // Primeira execução: cria usuário padrão
        final id = await _db.createUser(const UsersCompanion(
          name: Value('Student'),
        ));
        state = AsyncValue.data(UserProfile(
          id: id,
          name: 'Student',
          level: 'beginner',
          currentMode: 'casual',
          streak: 0,
        ));
      } else {
        state = AsyncValue.data(_fromDb(dbUser));
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMode(String mode) async {
    final profile = state.valueOrNull;
    if (profile == null) return;
    await _db.updateUser(UsersCompanion(
      id: Value(profile.id),
      currentMode: Value(mode),
    ));
    state = AsyncValue.data(profile.copyWith(currentMode: mode));
  }

  /// Atualiza o streak ao iniciar uma sessão de chat.
  Future<void> recordSession() async {
    final profile = state.valueOrNull;
    if (profile == null) return;

    final now = DateTime.now();
    final last = profile.lastSessionDate;
    int newStreak = profile.streak;

    if (last == null) {
      newStreak = 1;
    } else {
      final today = DateTime(now.year, now.month, now.day);
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 1) {
        newStreak = profile.streak + 1;
      } else if (diff > 1) {
        newStreak = 1; // streak quebrado
      }
      // diff == 0 → mesmo dia, não altera
    }

    await _db.updateUser(UsersCompanion(
      id: Value(profile.id),
      streak: Value(newStreak),
      lastSessionDate: Value(now),
    ));

    state = AsyncValue.data(
        profile.copyWith(streak: newStreak, lastSessionDate: now));
  }

  Future<void> updateLevel(String level) async {
    final profile = state.valueOrNull;
    if (profile == null) return;
    await _db.updateUser(UsersCompanion(
      id: Value(profile.id),
      level: Value(level),
    ));
    state = AsyncValue.data(profile.copyWith(level: level));
  }

  UserProfile _fromDb(DbUser u) => UserProfile(
        id: u.id,
        name: u.name,
        level: u.level,
        currentMode: u.currentMode,
        streak: u.streak,
        lastSessionDate: u.lastSessionDate,
      );
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>(
        (ref) => UserProfileNotifier(ref.read(databaseProvider)));
