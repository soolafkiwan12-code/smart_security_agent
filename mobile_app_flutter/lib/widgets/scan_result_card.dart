import 'package:flutter/material.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../models/risk_level.dart';
import '../models/scan_result.dart';

/// Result block that follows the active app theme (light / dark).
class ScanResultCard extends StatelessWidget {
  const ScanResultCard({super.key, required this.result, required this.risk});

  final ScanResult result;
  final RiskAssessment risk;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final t = Theme.of(context);
    final isSuspicious = result.label.toLowerCase() == 'suspicious';
    final levelName = RiskAssessment.levelName(risk.level);
    final accent = isSuspicious ? cs.error : cs.primary;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outline.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: t.brightness == Brightness.dark ? 0.28 : 0.06,
            ),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 28,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.riskLevel(levelName),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              risk.summary,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: cs.onSurfaceVariant,
              ),
            ),
            Divider(height: 22, color: cs.outline.withValues(alpha: 0.35)),
            _row(context, l10n.scanType(result.type)),
            _row(context, l10n.scanSource(result.source)),
            Text(
              l10n.scanLabelLine(result.label.toUpperCase()),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: isSuspicious ? cs.error : cs.primary,
              ),
            ),
            _row(context, l10n.scanScore(result.score.toStringAsFixed(3))),
            const SizedBox(height: 6),
            Text(
              l10n.scanReason(result.reason),
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String text) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: muted),
      ),
    );
  }
}
