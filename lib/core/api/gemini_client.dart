import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

import '../models/ai_response.dart';

class GeminiClient {
  static const String _model = 'gemini-2.5-flash';

  Future<AiResponse> chat({
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: _model,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(maxOutputTokens: 600),
    );

    // Convert history to Gemini Content objects; last entry is the new user message
    final chatHistory = history.length > 1
        ? history.sublist(0, history.length - 1).map((msg) {
            final role = msg['role'] == 'user' ? 'user' : 'model';
            return Content(role, [TextPart(msg['content']!)]);
          }).toList()
        : <Content>[];

    final lastContent = history.isNotEmpty ? history.last['content']! : '';

    try {
      final chat = model.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.text(lastContent));

      final content = response.text ?? '';
      final parsed = AiResponse.tryParse(content);
      if (parsed != null) return parsed;

      return AiResponse(reply: content, newWords: const [], difficulty: 5);
    } catch (e) {
      throw GeminiException('Erro ao conectar com a IA: $e');
    }
  }

  Future<List<Map<String, String>>> generateFlashcards(
      String topic, int count) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: _model,
      generationConfig: GenerationConfig(maxOutputTokens: 3000),
    );

    final prompt = '''Generate exactly $count English learning flashcards about: "$topic".

Return ONLY a valid JSON array. Each item must have exactly two keys:
- "front": a short question or concept (1-2 sentences)
- "back": a clear explanation with one example sentence

Example:
[
  {"front": "When do we use Past Simple?", "back": "We use Past Simple for completed actions in the past. Example: She visited Paris last year."},
  {"front": "How do we form the negative in Past Simple?", "back": "Use: subject + did not (didn't) + base verb. Example: He didn't study yesterday."}
]

Topic: $topic
Number of cards: $count

Return ONLY the JSON array. No explanations, no markdown, no extra text.''';

    try {
      final response =
          await model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '[]';

      final start = text.indexOf('[');
      final end = text.lastIndexOf(']');
      if (start == -1 || end == -1 || end <= start) return [];

      final List<dynamic> parsed = jsonDecode(text.substring(start, end + 1));
      return parsed
          .cast<Map<String, dynamic>>()
          .map((item) => {
                'front': (item['front'] as String? ?? '').trim(),
                'back': (item['back'] as String? ?? '').trim(),
              })
          .where((item) =>
              item['front']!.isNotEmpty && item['back']!.isNotEmpty)
          .toList();
    } catch (e) {
      throw GeminiException('Erro ao gerar flashcards: $e');
    }
  }

  Future<String> getWordDefinition(String word) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: _model,
      systemInstruction: Content.system(
        'You are a dictionary for English learners. For the given word, write a simple English definition (1-2 sentences) then one short example sentence. Format exactly: "Definition. Example: sentence." Reply ONLY with that — no extra text.',
      ),
      generationConfig: GenerationConfig(maxOutputTokens: 120),
    );

    try {
      final response = await model.generateContent([Content.text(word)]);
      return response.text?.trim() ?? 'Definition not available.';
    } catch (e) {
      throw GeminiException('Erro ao buscar definição: $e');
    }
  }
}

class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);

  @override
  String toString() => message;
}
