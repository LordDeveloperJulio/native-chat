// Ajusta automaticamente o nível do usuário com base nas dificuldades recentes.
// Regra: se as últimas 3 dificuldades forem todas < 3 → sobe nível.
//        se as últimas 3 dificuldades forem todas > 8 → desce nível.
class LevelAdapter {
  static const int _windowSize = 3;

  /// Retorna o novo nível se houver mudança, ou null se permanecer igual.
  static String? adaptLevel(
      String currentLevel, List<int> recentDifficulties) {
    if (recentDifficulties.length < _windowSize) return null;

    final last3 = recentDifficulties
        .sublist(recentDifficulties.length - _windowSize);

    final allLow = last3.every((d) => d < 3);
    final allHigh = last3.every((d) => d > 8);

    if (allLow) {
      final next = _increase(currentLevel);
      return next != currentLevel ? next : null;
    }

    if (allHigh) {
      final next = _decrease(currentLevel);
      return next != currentLevel ? next : null;
    }

    return null;
  }

  static String _increase(String level) {
    switch (level) {
      case 'beginner':
        return 'intermediate';
      case 'intermediate':
        return 'advanced';
      default:
        return level;
    }
  }

  static String _decrease(String level) {
    switch (level) {
      case 'advanced':
        return 'intermediate';
      case 'intermediate':
        return 'beginner';
      default:
        return level;
    }
  }
}
