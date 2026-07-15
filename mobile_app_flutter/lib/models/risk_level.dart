import 'scan_result.dart';

enum RiskLevel { low, medium, high }

/// Maps backend label + score into a simple risk tier for UI and alerts.
class RiskAssessment {
  const RiskAssessment({
    required this.level,
    required this.summary,
  });

  final RiskLevel level;
  final String summary;

  static RiskAssessment fromScan(ScanResult r, {String suspiciousLabel = 'suspicious'}) {
    final label = r.label.toLowerCase();
    final isBadLabel = label == suspiciousLabel.toLowerCase() ||
        label.contains('mal') ||
        label.contains('phish');

    if (isBadLabel && r.score >= 0.75) {
      return const RiskAssessment(
        level: RiskLevel.high,
        summary: 'High risk — avoid opening or sharing this content.',
      );
    }
    if (isBadLabel && r.score >= 0.45) {
      return const RiskAssessment(
        level: RiskLevel.medium,
        summary: 'Medium risk — verify the source before proceeding.',
      );
    }
    if (isBadLabel || r.score >= 0.85) {
      return const RiskAssessment(
        level: RiskLevel.high,
        summary: 'High risk — treat this as untrusted.',
      );
    }
    if (r.score >= 0.55) {
      return const RiskAssessment(
        level: RiskLevel.medium,
        summary: 'Elevated score — exercise caution.',
      );
    }
    return const RiskAssessment(
      level: RiskLevel.low,
      summary: 'Low risk based on current signals (still verify sensitive actions).',
    );
  }

  static String levelName(RiskLevel l) {
    switch (l) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }

  static String buildShareReport(ScanResult r, RiskAssessment a) {
    final buf = StringBuffer()
      ..writeln('Agent Ab security report')
      ..writeln('Type: ${r.type}')
      ..writeln('Source: ${r.source}')
      ..writeln('Label: ${r.label}')
      ..writeln('Score: ${r.score.toStringAsFixed(3)}')
      ..writeln('Risk: ${levelName(a.level)}')
      ..writeln('Assessment: ${a.summary}')
      ..writeln('Reason: ${r.reason}');
    return buf.toString();
  }
}
