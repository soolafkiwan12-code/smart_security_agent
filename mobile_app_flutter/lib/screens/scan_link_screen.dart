import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/platform_capabilities.dart';
import '../core/url_safety.dart';
import '../models/risk_level.dart';
import '../models/scan_history_entry.dart';
import '../models/scan_result.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../services/scan_history_service.dart';
import '../services/settings_service.dart';
import '../theme/app_typography.dart';
import '../widgets/gradient_scan_button.dart';
import '../widgets/scan_result_card.dart';

class ScanLinkScreen extends StatefulWidget {
  const ScanLinkScreen({
    super.key,
    required this.settings,
    required this.api,
    required this.scanHistory,
  });

  final SettingsService settings;
  final ApiService api;
  final ScanHistoryService scanHistory;

  @override
  State<ScanLinkScreen> createState() => _ScanLinkScreenState();
}

class _ScanLinkScreenState extends State<ScanLinkScreen> {
  final TextEditingController _url = TextEditingController();
  bool _loading = false;
  String? _error;
  ScanResult? _result;
  String? _lastScannedUrl;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _maybeSave(ScanResult r, String url) async {
    if (!widget.settings.saveScanHistoryEnabled) return;
    await widget.scanHistory.add(
      ScanHistoryEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        kind: ScanHistoryKind.link,
        targetLabel: url,
        result: r,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _runScan() async {
    final l10n = AppLocalizations.of(context)!;
    final raw = _url.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = l10n.scanErrorUrl);
      return;
    }

    final vr = UrlSafety.validateHttpUrl(raw);
    if (vr is UrlInvalid) {
      setState(() => _error = vr.reason);
      return;
    }
    final normalized = (vr as UrlValid).normalizedUrl;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await widget.api.scanLink(
        normalized,
        source: widget.settings.sourceManual,
      );
      setState(() {
        _result = r;
        _lastScannedUrl = normalized;
      });
      await _maybeSave(r, normalized);
    } catch (e) {
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmOpenLink(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context)!;
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.scanOpenLinkDialogTitle),
        content: SingleChildScrollView(
          child: Text(l10n.scanOpenLinkDialogBody),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.scanOpenLinkDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.scanOpenLinkDialogOpen),
          ),
        ],
      ),
    );
    if (go != true || !context.mounted) return;
    final uri = Uri.parse(url);
    final cs = Theme.of(context).colorScheme;
    if (!await canLaunchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: cs.inverseSurface,
            content: Text(
              l10n.scanCouldNotOpenLink,
              style: TextStyle(color: cs.onInverseSurface),
            ),
          ),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _copyScannedUrlToClipboard(BuildContext context, String url) async {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        backgroundColor: cs.inverseSurface,
        content: Text(
          l10n.scanUrlCopiedWithWarning,
          style: TextStyle(color: cs.onInverseSurface),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final risk = _result != null ? RiskAssessment.fromScan(_result!) : null;
    final report = _result != null && risk != null
        ? RiskAssessment.buildShareReport(_result!, risk)
        : null;

    final autoNote = platformSupportsAutomaticAgent &&
            widget.settings.androidAutomaticAgentEnabled
        ? l10n.scanNoteAndroidAuto
        : l10n.scanNoteManual;

    final t = Theme.of(context);
    final cs = t.colorScheme;
    final shadowStrong = t.brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.35)
        : const Color(0xFF64748B).withValues(alpha: 0.1);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                autoNote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: shadowStrong,
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.scanLinkScreenTitle,
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.scanLinkScreenSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: _url,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: l10n.scanSuspiciousUrlLabel,
                        hintText: 'https://…',
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientScanButton(
                      label: l10n.scanLinkAction,
                      loading: _loading,
                      onPressed: _loading ? null : _runScan,
                    ),
                    if (_loading) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            l10n.scanAnalyzingLink,
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: cs.error.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: cs.onErrorContainer,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
              if (_result != null && risk != null) ...[
                const SizedBox(height: 18),
                ScanResultCard(result: _result!, risk: risk),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: report == null
                            ? null
                            : () => Share.share(report),
                        icon: const Icon(Icons.share_outlined, size: 18),
                        label: Text(l10n.shareReport),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.onSurface,
                          side: BorderSide(color: cs.outline),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: report == null
                            ? null
                            : () async {
                                await Clipboard.setData(
                                  ClipboardData(text: report),
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: cs.inverseSurface,
                                      content: Text(
                                        l10n.reportCopied,
                                        style: TextStyle(
                                          color: cs.onInverseSurface,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        label: Text(l10n.copyReport),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cs.onSurface,
                          side: BorderSide(color: cs.outline),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_lastScannedUrl != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              _confirmOpenLink(context, _lastScannedUrl!),
                          icon: const Icon(Icons.open_in_browser_outlined,
                              size: 18),
                          label: Text(l10n.scanOpenLinkInBrowser),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.onSurface,
                            side: BorderSide(color: cs.outline),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyScannedUrlToClipboard(
                            context,
                            _lastScannedUrl!,
                          ),
                          icon: const Icon(Icons.link, size: 18),
                          label: Text(l10n.scanCopyLinkAddress),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.onSurface,
                            side: BorderSide(color: cs.outline),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
