/// Normalized AI reply from your backend (flexible JSON).
class AiChatResponse {
  const AiChatResponse({
    required this.reply,
    this.sessionId,
    this.raw,
  });

  final String reply;
  final String? sessionId;
  final Map<String, dynamic>? raw;

  factory AiChatResponse.fromJson(Map<String, dynamic> json) {
    String reply = '';
    if (json['reply'] != null) {
      reply = json['reply'].toString();
    } else if (json['message'] is Map) {
      final m = json['message'] as Map<String, dynamic>;
      reply = (m['content'] ?? m['text'] ?? '').toString();
    } else if (json['content'] != null) {
      reply = json['content'].toString();
    } else if (json['choices'] is List && (json['choices'] as List).isNotEmpty) {
      final first = (json['choices'] as List).first;
      if (first is Map && first['message'] is Map) {
        reply = ((first['message'] as Map)['content'] ?? '').toString();
      }
    }
    return AiChatResponse(
      reply: reply.isEmpty ? 'Empty response from server.' : reply,
      sessionId: json['session_id']?.toString() ?? json['sessionId']?.toString(),
      raw: json,
    );
  }
}
