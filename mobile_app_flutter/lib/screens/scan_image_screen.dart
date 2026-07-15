import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

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

class ScanImageScreen extends StatefulWidget {
  const ScanImageScreen({
    super.key,
    required this.settings,
    required this.api,
    required this.scanHistory,
  });

  final SettingsService settings;
  final ApiService api;
  final ScanHistoryService scanHistory;

  @override
  State<ScanImageScreen> createState() => _ScanImageScreenState();
}

class _ScanImageScreenState extends State<ScanImageScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _picked;
  bool _loading = false;
  String? _error;
  ScanResult? _result;

  Future<void> _maybeSave(ScanResult r, String label) async {
    if (!widget.settings.saveScanHistoryEnabled) return;
    await widget.scanHistory.add(
      ScanHistoryEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        kind: ScanHistoryKind.image,
        targetLabel: label,
        result: r,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 88);
      if (file == null) return;
      setState(() {
        _picked = file;
        _error = null;
        _result = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  void _openChooser() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.pickGallery),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.pickCamera),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyze() async {
    final file = _picked;
    if (file == null) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await widget.api.scanImageUpload(
        file,
        source: widget.settings.sourceManual,
      );
      setState(() => _result = r);
      await _maybeSave(r, file.name);
    } catch (e) {
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final risk = _result != null ? RiskAssessment.fromScan(_result!) : null;
    final report = _result != null && risk != null
        ? RiskAssessment.buildShareReport(_result!, risk)
        : null;

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
                      l10n.scanImageScreenTitle,
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.scanImageScreenSubtitle,
                      style: TextStyle(
                        fontSize: 15,
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _loading ? null : _openChooser,
                        borderRadius: BorderRadius.circular(16),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cs.outline,
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                              horizontal: 16,
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 36,
                                  color: cs.onSurfaceVariant,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  l10n.scanChooseImageOrCamera,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _picked?.name ?? l10n.scanNoFileChosen,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _picked == null
                                        ? cs.onSurfaceVariant
                                        : cs.onSurface.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GradientScanButton(
                      label: l10n.scanAnalyzeAction,
                      icon: Icons.shield_outlined,
                      loading: _loading,
                      onPressed: (_loading || _picked == null) ? null : _analyze,
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
                            l10n.scanAnalyzingImage,
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
