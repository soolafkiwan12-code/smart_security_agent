import 'chat_message.dart';

class ChatSession {
  const ChatSession({
    required this.id,
    required this.updatedAt,
    required this.preview,
    required this.messages,
  });

  final String id;
  final DateTime updatedAt;
  final String preview;
  final List<ChatMessage> messages;

  Map<String, dynamic> toJson() => {
        'id': id,
        'updatedAt': updatedAt.toIso8601String(),
        'preview': preview,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: (json['id'] ?? '').toString(),
      updatedAt: DateTime.tryParse((json['updatedAt'] ?? '').toString()) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      preview: (json['preview'] ?? '').toString(),
      messages: (json['messages'] as List<dynamic>? ?? [])
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
