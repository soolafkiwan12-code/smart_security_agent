class ScanResult {
  final String type;
  final String label;
  final double score;
  final String reason;
  final String source;

  const ScanResult({
    required this.type,
    required this.label,
    required this.score,
    required this.reason,
    required this.source,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    final result = (json['result'] as Map<String, dynamic>? ?? {});
    return ScanResult(
      type: (json['type'] ?? 'unknown').toString(),
      label: (result['label'] ?? 'unknown').toString(),
      score: (result['score'] as num? ?? 0).toDouble(),
      reason: (result['reason'] ?? 'No reason provided').toString(),
      source: (json['source'] ?? 'manual').toString(),
    );
  }
}
