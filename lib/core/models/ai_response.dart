// Modelo para a resposta estruturada retornada pelo GPT-4o.
// O modelo é instruído a responder SOMENTE em JSON com este schema.
import 'dart:convert';

class AiResponse {
  final String reply;
  final String? correction; // "wrong → correct" ou null
  final List<String> newWords;
  final int difficulty; // 1-10

  const AiResponse({
    required this.reply,
    this.correction,
    required this.newWords,
    required this.difficulty,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    final correctionRaw = json['correction'];
    return AiResponse(
      reply: json['reply'] as String? ?? '',
      correction: (correctionRaw == null || correctionRaw == 'null')
          ? null
          : correctionRaw as String?,
      newWords: (json['new_words'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      difficulty: (json['difficulty'] as num?)?.toInt() ?? 5,
    );
  }

  /// Extrai o JSON da resposta bruta da API, tolerando texto extra ao redor.
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
