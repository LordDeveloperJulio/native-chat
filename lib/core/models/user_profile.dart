// Wrapper sobre os dados do usuário vindos do Drift.
// Usado em toda a UI para acessar nível, modo e streak de forma tipada.
class UserProfile {
  final int id;
  final String name;
  final String level; // beginner | intermediate | advanced
  final String currentMode; // casual | business | travel | interview
  final int streak;
  final DateTime? lastSessionDate;

  const UserProfile({
    required this.id,
    required this.name,
    required this.level,
    required this.currentMode,
    required this.streak,
    this.lastSessionDate,
  });

  UserProfile copyWith({
    String? name,
    String? level,
    String? currentMode,
    int? streak,
    DateTime? lastSessionDate,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      level: level ?? this.level,
      currentMode: currentMode ?? this.currentMode,
      streak: streak ?? this.streak,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }

  String get levelDisplay {
    switch (level) {
      case 'beginner':
        return 'Iniciante';
      case 'intermediate':
        return 'Intermediário';
      case 'advanced':
        return 'Avançado';
      default:
        return level;
    }
  }

  String get modeDisplay {
    switch (currentMode) {
      case 'casual':
        return 'Casual';
      case 'business':
        return 'Negócios';
      case 'travel':
        return 'Viagem';
      case 'interview':
        return 'Entrevista';
      default:
        return currentMode;
    }
  }
}
