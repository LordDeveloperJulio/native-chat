// Providers Riverpod para a tela de progresso.
// Agrega dados do banco para exibição de métricas e gráficos.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/database.dart';
import '../home/home_providers.dart';

class ProgressData {
  final int totalMessages;
  final int totalNewWords;
  final int streak;
  final Map<DateTime, int> weeklyMessages;
  final List<DbCorrection> topCorrections;

  const ProgressData({
    required this.totalMessages,
    required this.totalNewWords,
    required this.streak,
    required this.weeklyMessages,
    required this.topCorrections,
  });
}

final progressProvider = FutureProvider.autoDispose<ProgressData>((ref) async {
  final db = ref.read(databaseProvider);
  final userAsync = ref.read(userProfileProvider);
  final user = userAsync.valueOrNull;

  if (user == null) {
    return ProgressData(
      totalMessages: 0,
      totalNewWords: 0,
      streak: 0,
      weeklyMessages: {},
      topCorrections: [],
    );
  }

  final results = await Future.wait([
    db.totalMessagesCount(user.id),
    db.totalNewWordsCount(user.id),
    db.weeklyMessageCounts(user.id),
    db.getTopCorrections(user.id, limit: 10),
  ]);

  return ProgressData(
    totalMessages: results[0] as int,
    totalNewWords: results[1] as int,
    streak: user.streak,
    weeklyMessages: results[2] as Map<DateTime, int>,
    topCorrections: results[3] as List<DbCorrection>,
  );
});
