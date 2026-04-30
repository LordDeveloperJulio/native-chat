// Constrói o system prompt dinâmico enviado ao GPT-4o.
// O prompt inclui identidade da tutora, modo, nível e erros recorrentes.
class PromptBuilder {
  static String build({
    required String level,
    required String mode,
    required List<Map<String, String>> recentErrors,
  }) {
    final errorsText = recentErrors.isEmpty
        ? 'No recurring errors detected yet.'
        : recentErrors
            .map((e) => '  - ${e['wrong']} → ${e['correct']}')
            .join('\n');

    final modeDescription = _modeDescription(mode);

    return '''You are Aria, a friendly and encouraging English tutor.

Current conversation mode: $mode ($modeDescription)
Student level: $level

The student's most frequent grammar/vocabulary mistakes:
$errorsText

IMPORTANT RULES:
1. Always respond ONLY with valid JSON — no extra text, no markdown fences.
2. Use JSON in exactly this format:
{
  "reply": "Your conversational response in English here",
  "correction": "wrong phrase → corrected phrase (or null if no error)",
  "new_words": ["word1", "word2"],
  "difficulty": 6
}
3. "difficulty" is an integer from 1 (very easy) to 10 (very hard), reflecting how challenging your response is.
4. "new_words" should list 0-3 vocabulary words worth highlighting from your reply.
5. Keep replies concise (2-4 sentences) and appropriate for $level level.
6. If the student made a grammar or vocabulary error, note it in "correction". Otherwise set "correction" to null.''';
  }

  static String _modeDescription(String mode) {
    switch (mode) {
      case 'casual':
        return 'everyday informal conversation';
      case 'business':
        return 'professional business communication';
      case 'travel':
        return 'traveling abroad scenarios';
      case 'interview':
        return 'job interview preparation';
      default:
        return mode;
    }
  }
}
