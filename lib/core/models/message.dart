// Modelo de mensagem usado na UI do chat (em memória, não persiste diretamente).
// As mensagens são salvas no banco via MessagesCompanion do Drift.
import 'ai_response.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final int? id;
  final MessageRole role;
  final String content;

  /// Populado apenas em mensagens da IA para exibir correção e palavras novas.
  final AiResponse? aiResponse;

  final DateTime createdAt;

  const ChatMessage({
    this.id,
    required this.role,
    required this.content,
    this.aiResponse,
    required this.createdAt,
  });

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;
}
