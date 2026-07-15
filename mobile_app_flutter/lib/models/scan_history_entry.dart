import 'dart:convert';

import 'risk_level.dart';
import 'scan_result.dart';

enum ScanHistoryKind { link, image }

class ScanHistoryEntry {
  const ScanHistoryEntry({
    required this.id,
    required this.kind,
    required this.targetLabel,
    required this.result,
    required this.createdAt,
  });

  final String id;
  final ScanHistoryKind kind;
  final String targetLabel;
  final ScanResult result;
  final DateTime createdAt;

  RiskAssessment get risk => RiskAssessment.fromScan(result);

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'targetLabel': targetLabel,
        'result': {
          'type': result.type,
          'label': result.label,
          'score': result.score,
          'reason': result.reason,
          'source': result.source,
        },
        'createdAt': createdAt.toIso8601String(),
      };

  factory ScanHistoryEntry.fromJson(Map<String, dynamic> json) {
    final rm = json['result'] as Map<String, dynamic>? ?? {};
    final result = ScanResult(
      type: (rm['type'] ?? 'unknown').toString(),
      label: (rm['label'] ?? 'unknown').toString(),
      score: (rm['score'] as num?)?.toDouble() ?? 0,
      reason: (rm['reason'] ?? '').toString(),
      source: (rm['source'] ?? 'manual').toString(),
    );
    return ScanHistoryEntry(
      id: (json['id'] ?? '').toString(),
      kind: ScanHistoryKind.values.firstWhere(
        (e) => e.name == (json['kind'] ?? 'link'),
        orElse: () => ScanHistoryKind.link,
      ),
      targetLabel: (json['targetLabel'] ?? '').toString(),
      result: result,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  static String encodeList(List<ScanHistoryEntry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());
}
