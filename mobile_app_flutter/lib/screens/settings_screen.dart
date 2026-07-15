import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../core/platform_capabilities.dart';
import '../theme/app_typography.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/automatic_agent_scheduler.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.settings,
    this.scheduler,
    this.auth,
  });

  final SettingsService settings;
  final AutomaticAgentScheduler? scheduler;
  final AuthService? auth;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _urlController = TextEditingController(
    text: widget.settings.baseUrlOverride ?? widget.settings.resolvedBaseUrl,
  );
  late final ApiService _probeApi = ApiService(
    baseUrl: () => widget.settings.resolvedBaseUrl,
  );

  bool _checkingHealth = false;
  String? _healthMessage;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _saveUrl() async {
    final v = _urlController.text.trim();
    await widget.settings.setBaseUrlOverride(v.isEmpty ? null : v);
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: cs.inverseSurface,
          content: Text(
            l10n.settingsUrlSaved,
            style: TextStyle(color: cs.onInverseSurface),
          ),
        ),
      );
    }
  }

  Future<void> _pingHealth() async {
    setState(() {
      _checkingHealth = true;
      _healthMessage = null;
    });
    final l10n = AppLocalizations.of(context)!;
    try {
      final body = await _probeApi.health();
      setState(() {
        _healthMessage = body.isEmpty ? l10n.healthOkEmpty : body.toString();
      });
    } catch (e) {
      setState(() => _healthMessage = e.toString());
    } finally {
      setState(() => _checkingHealth = false);
    }
  }

  Widget _softCard(BuildContext context, {required Widget child}) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final shadowA = t.brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.35)
        : const Color(0xFF64748B).withValues(alpha: 0.08);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: shadowA,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      child: child,
    );
  }

  String _themeMenuLabel(AppThemePreference p, AppLocalizations l10n) {
    switch (p) {
      case AppThemePreference.system:
        return l10n.themeSystem;
      case AppThemePreference.light:
        return l10n.themeLight;
      case AppThemePreference.dark:
        return l10n.themeDark;
    }
  }

  String _fontSizeMenuLabel(AppFontSizePreference p, AppLocalizations l10n) {
    switch (p) {
      case AppFontSizePreference.compact:
        return l10n.fontSizeCompact;
      case AppFontSizePreference.standard:
        return l10n.fontSizeStandard;
      case AppFontSizePreference.comfortable:
        return l10n.fontSizeComfortable;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final onTitle = cs.onSurface;
    final onSub = cs.onSurfaceVariant;

    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: widget.settings,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: AppTypography.screenTitle,
                  ),
                  const SizedBox(height: 20),
                  _softCard(
                    context,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.settingsLanguage,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: onTitle,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.settingsLanguageSubtitle,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: onSub,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: widget.settings.languageCode,
                            borderRadius: BorderRadius.circular(12),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: onSub,
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: onTitle,
                            ),
                              items: [
                                DropdownMenuItem(
                                  value: 'en',
                                  child: Text(l10n.langEnglish),
                                ),
                                DropdownMenuItem(
                                  value: 'ar',
                                  child: Text(l10n.langArabic),
                                ),
                              ],
                              onChanged: (v) async {
                                if (v == null) return;
                                await widget.settings.setLanguageCode(v);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _softCard(
                      context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsTheme,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: onTitle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.settingsThemeSubtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: onSub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<AppThemePreference>(
                              value: widget.settings.themePreference,
                              borderRadius: BorderRadius.circular(12),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: onSub,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: onTitle,
                              ),
                              items: AppThemePreference.values
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(_themeMenuLabel(p, l10n)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) async {
                                if (v == null) return;
                                await widget.settings.setThemePreference(v);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _softCard(
                      context,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.settingsFontSize,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: onTitle,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.settingsFontSizeSubtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.35,
                                    color: onSub,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<AppFontSizePreference>(
                              value: widget.settings.fontSizePreference,
                              borderRadius: BorderRadius.circular(12),
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: onSub,
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: onTitle,
                              ),
                              items: AppFontSizePreference.values
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(_fontSizeMenuLabel(p, l10n)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) async {
                                if (v == null) return;
                                await widget.settings.setFontSizePreference(v);
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.settingsBackend,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: onTitle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _softCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: _urlController,
                            decoration: InputDecoration(
                              labelText: l10n.settingsBaseUrl,
                              hintText: l10n.settingsBaseUrlHint,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: _saveUrl,
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(l10n.settingsSaveUrl),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed:
                                      _checkingHealth ? null : _pingHealth,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(color: cs.outline),
                                  ),
                                  child: _checkingHealth
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(l10n.settingsHealthCheck),
                                ),
                              ),
                            ],
                          ),
                          if (_healthMessage != null) ...[
                            const SizedBox(height: 10),
                            SelectableText(
                              _healthMessage!,
                              style: TextStyle(
                                fontSize: 12,
                                color: onSub,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.settingsPrivacy,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: onTitle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _softCard(
                      context,
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              l10n.settingsSaveChatHistory,
                              style: TextStyle(
                                color: onTitle,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              l10n.settingsSaveChatHistorySubtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: onSub,
                              ),
                            ),
                            value: widget.settings.saveChatHistoryEnabled,
                            onChanged: (v) async {
                              await widget.settings.setSaveChatHistoryEnabled(v);
                              setState(() {});
                            },
                          ),
                          const Divider(height: 20),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              l10n.settingsSaveScanHistory,
                              style: TextStyle(
                                color: onTitle,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              l10n.settingsSaveScanHistorySubtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: onSub,
                              ),
                            ),
                            value: widget.settings.saveScanHistoryEnabled,
                            onChanged: (v) async {
                              await widget.settings.setSaveScanHistoryEnabled(v);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      l10n.settingsAboutPrivacySection,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: onTitle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _softCard(
                      context,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.settingsAboutAppShort,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: onTitle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.settingsPrivacyShort,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: onSub,
                            ),
                          ),
                          if (AppConfig.privacyPolicyUrl.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () async {
                                final uri =
                                    Uri.parse(AppConfig.privacyPolicyUrl.trim());
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              child: Text(l10n.settingsOpenPrivacyPolicy),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.scheduler != null) ...[
                      const SizedBox(height: 22),
                      Text(
                        l10n.settingsAgentMode,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: onTitle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _softCard(
                        context,
                        child: platformSupportsAutomaticAgent
                            ? SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.settingsAutoAgentTitle,
                                  style: TextStyle(
                                    color: onTitle,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  l10n.settingsAutoAgentSubtitleAndroid,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: onSub,
                                  ),
                                ),
                                value: widget
                                    .settings.androidAutomaticAgentEnabled,
                                onChanged: (v) async {
                                  await widget.settings
                                      .setAndroidAutomaticAgentEnabled(v);
                                  widget.scheduler!.syncWithSettings();
                                  setState(() {});
                                },
                              )
                            : ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  l10n.settingsManualOnlyTitle,
                                  style: TextStyle(color: onTitle),
                                ),
                                subtitle: Text(
                                  l10n.settingsManualOnlySubtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: onSub,
                                  ),
                                ),
                              ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    _softCard(
                      context,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n.settingsCopyUrl,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: onTitle,
                          ),
                        ),
                        subtitle: Text(
                          widget.settings.resolvedBaseUrl,
                          style: TextStyle(
                            fontSize: 12,
                            color: onSub,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.copy_outlined),
                          color: cs.primary,
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(
                                text: widget.settings.resolvedBaseUrl,
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: cs.inverseSurface,
                                content: Text(
                                  l10n.settingsCopied,
                                  style: TextStyle(color: cs.onInverseSurface),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (widget.auth != null &&
                        (widget.auth!.isAuthenticated ||
                            widget.auth!.isGuest)) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            await widget.auth!.logout();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cs.error,
                            side: BorderSide(color: cs.error.withValues(alpha: 0.45)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(l10n.logout),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
    );
  }
}
