enum ChatRole { user, assistant, system }

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.id,
    this.sentAt,
  });

  final ChatRole role;
  final String content;
  final String? id;
  final DateTime? sentAt;

  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
        if (id != null) 'id': id,
        if (sentAt != null) 'sentAt': sentAt!.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final roleName = (json['role'] ?? 'user').toString();
    final role = ChatRole.values.firstWhere(
      (e) => e.name == roleName,
      orElse: () => ChatRole.user,
    );
    return ChatMessage(
      role: role,
      content: (json['content'] ?? '').toString(),
      id: json['id'] as String?,
      sentAt: DateTime.tryParse((json['sentAt'] ?? '').toString()),
    );
  }
}
