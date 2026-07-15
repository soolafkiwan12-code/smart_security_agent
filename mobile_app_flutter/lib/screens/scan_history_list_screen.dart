import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../models/risk_level.dart';
import '../services/scan_history_service.dart';
import '../services/settings_service.dart';

class ScanHistoryListScreen extends StatelessWidget {
  const ScanHistoryListScreen({
    super.key,
    required this.settings,
    required this.scanHistory,
  });

  final SettingsService settings;
  final ScanHistoryService scanHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: Listenable.merge([scanHistory, settings]),
      builder: (context, _) {
        final entries = scanHistory.loadAll();

        if (!settings.saveScanHistoryEnabled) {
          return Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                l10n.scanHistoryEmpty,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (entries.isEmpty) {
          return Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                l10n.scanHistoryEmpty,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => scanHistory.clear(),
                child: Text(l10n.scanHistoryClear),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final e = entries[i];
                  final risk = e.risk;
                  final levelName = RiskAssessment.levelName(risk.level);
                  final report = RiskAssessment.buildShareReport(e.result, risk);
                  return ListTile(
                    title: Text(
                      e.targetLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${l10n.riskLevel(levelName)} · ${e.kind.name} · ${e.createdAt.toLocal()}',
                      maxLines: 3,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'share') {
                          await Share.share(report);
                        } else if (v == 'copy') {
                          await Clipboard.setData(ClipboardData(text: report));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.reportCopied)),
                            );
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'share', child: Text(l10n.shareReport)),
                        PopupMenuItem(value: 'copy', child: Text(l10n.copyReport)),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (ctx) => Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.riskLevel(levelName),
                                style: Theme.of(ctx).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(risk.summary),
                              const SizedBox(height: 8),
                              Text(l10n.scanReason(e.result.reason)),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
