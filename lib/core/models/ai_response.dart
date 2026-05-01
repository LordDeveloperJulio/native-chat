import 'dart:convert';

class AiResponse {
  final String reply;
  final String? correction;   // "wrong phrase → corrected form"
  final String? grammarNote;  // explains the rule behind the correction
  final List<String> newWords;
  final int difficulty; // 1-10

  const AiResponse({
    required this.reply,
    this.correction,
    this.grammarNote,
    required this.newWords,
    required this.difficulty,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    final correctionRaw = json['correction'];
    final grammarNoteRaw = json['grammar_note'];
    return AiResponse(
      reply: json['reply'] as String? ?? '',
      correction: (correctionRaw == null || correctionRaw == 'null')
          ? null
          : correctionRaw as String?,
      grammarNote: (grammarNoteRaw == null || grammarNoteRaw == 'null')
          ? null
          : grammarNoteRaw as String?,
      newWords: (json['new_words'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 5,
    );
  }

  /// Extracts JSON from raw API response, tolerating extra surrounding text.
  static AiResponse? tryParse(String raw) {
    try {
      final start = raw.indexOf('{');
      final end = raw.lastIndexOf('}');
      if (start == -1 || end == -1) return null;
      final jsonStr = raw.substring(start, end + 1);
      return AiResponse.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
