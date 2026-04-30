import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/ai_response.dart';

class OpenAIClient {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static const String _model = 'gpt-4o';
  static const int _maxTokens = 600;

  late final Dio _dio;

  OpenAIClient() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));
  }

  /// Envia o [systemPrompt] e o [history] de mensagens para o GPT-4o.
  /// [history] deve estar em ordem cronológica crescente.
  Future<AiResponse> chat({
    required String systemPrompt,
    required List<Map<String, String>> history,
  }) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

    if (apiKey.isEmpty || apiKey == 'your_key_here') {
      throw const OpenAIException(
          'OPENAI_API_KEY não configurada. Edite o arquivo .env.');
    }

    try {
      final response = await _dio.post(
        '/chat/completions',
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},
        ),
        data: {
          'model': _model,
          'max_tokens': _maxTokens,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            ...history,
          ],
        },
      );

      final content =
          response.data['choices'][0]['message']['content'] as String;

      final parsed = AiResponse.tryParse(content);
      if (parsed != null) return parsed;

      // Fallback: retorna a resposta bruta como texto
      return AiResponse(
        reply: content,
        newWords: const [],
        difficulty: 5,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// Retorna uma definição simples em inglês + frase de exemplo para [word].
  /// O resultado é cacheado no banco pelo chamador.
  Future<String> getWordDefinition(String word) async {
    final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
    if (apiKey.isEmpty || apiKey == 'your_key_here') {
      throw const OpenAIException('OPENAI_API_KEY não configurada.');
    }

    try {
      final response = await _dio.post(
        '/chat/completions',
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},
        ),
        data: {
          'model': _model,
          'max_tokens': 120,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a dictionary for English learners. For the given word, write a simple English definition (1-2 sentences) then one short example sentence. Format exactly: "Definition. Example: sentence." Reply ONLY with that — no extra text.',
            },
            {'role': 'user', 'content': word},
          ],
        },
      );
      final content =
          response.data['choices'][0]['message']['content'] as String;
      return content.trim();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  OpenAIException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const OpenAIException(
          'Tempo limite atingido. Verifique sua conexão.');
    }
    if (e.response?.statusCode == 429) {
      return const OpenAIException(
          'Limite de requisições atingido. Aguarde um momento.');
    }
    if (e.response?.statusCode == 401) {
      return const OpenAIException(
          'Chave de API inválida. Verifique o arquivo .env.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return const OpenAIException('Sem conexão com a internet.');
    }
    return OpenAIException(
        'Erro inesperado: ${e.response?.statusCode ?? e.message}');
  }
}

class OpenAIException implements Exception {
  final String message;
  const OpenAIException(this.message);

  @override
  String toString() => message;
}
