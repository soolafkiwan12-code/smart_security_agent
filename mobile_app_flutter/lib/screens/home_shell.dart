import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../core/platform_capabilities.dart';
import '../core/url_safety.dart';
import '../models/risk_level.dart';
import '../models/scan_history_entry.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/automatic_agent_scheduler.dart';
import '../services/chat_history_service.dart';
import '../services/notification_service.dart';
import '../services/scan_history_service.dart';
import '../services/settings_service.dart';
import 'agent_chat_screen.dart';
import 'history_hub_screen.dart';
import 'scan_image_screen.dart';
import 'scan_link_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    super.key,
    required this.settings,
    required this.auth,
    required this.api,
  });

  final SettingsService settings;
  final AuthService auth;
  final ApiService api;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with WidgetsBindingObserver {
  int _index = 0;
  late final AutomaticAgentScheduler _scheduler = AutomaticAgentScheduler(
    settings: widget.settings,
    api: widget.api,
  );
  late final ChatHistoryService _chatHistory =
      ChatHistoryService(widget.settings.preferences);
  late final ScanHistoryService _scanHistory =
      ScanHistoryService(widget.settings.preferences);
  String? _lastClipboardUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.settings.addListener(_onSettingsChanged);
    _scheduler.syncWithSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.settings.removeListener(_onSettingsChanged);
    _scheduler.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_clipboardAutoScan());
    }
  }

  void _onSettingsChanged() {
    _scheduler.syncWithSettings();
    setState(() {});
  }

  Future<void> _clipboardAutoScan() async {
    if (!platformSupportsAutomaticAgent) return;
    if (!widget.settings.androidAutomaticAgentEnabled) return;
    if (!mounted) return;

    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return;

    UrlValidationResult vr = UrlSafety.validateHttpUrl(text);
    if (vr is UrlInvalid) {
      final extracted = UrlSafety.firstHttpUrlIn(text);
      if (extracted == null) return;
      vr = UrlSafety.validateHttpUrl(extracted);
    }
    if (vr is! UrlValid) return;

    final url = vr.normalizedUrl;
    if (url == _lastClipboardUrl) return;
    _lastClipboardUrl = url;

    try {
      final result = await widget.api.scanLink(
        url,
        source: widget.settings.sourceAuto,
      );
      final risk = RiskAssessment.fromScan(result);
      final suspicious = result.label.toLowerCase() == 'suspicious';
      final alert = risk.level == RiskLevel.high ||
          (suspicious && result.score >= 0.45);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;

      if (alert) {
        await NotificationService.instance.showSecurityAlert(
          title: l10n.highRiskTitle,
          body: l10n.highRiskBody,
        );
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.scanFromClipboardTitle),
            content: SingleChildScrollView(
              child: Text(RiskAssessment.buildShareReport(result, risk)),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.scanFromClipboardDismiss),
              ),
            ],
          ),
        );
      }

      if (widget.settings.saveScanHistoryEnabled) {
        await _scanHistory.add(
          ScanHistoryEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            kind: ScanHistoryKind.link,
            targetLabel: url,
            result: result,
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      // Silent: clipboard path must not crash the app.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Link → Image → History → AI → Settings
    final pages = <Widget>[
      ScanLinkScreen(
        settings: widget.settings,
        api: widget.api,
        scanHistory: _scanHistory,
      ),
      ScanImageScreen(
        settings: widget.settings,
        api: widget.api,
        scanHistory: _scanHistory,
      ),
      HistoryHubScreen(
        settings: widget.settings,
        chatHistory: _chatHistory,
        scanHistory: _scanHistory,
      ),
      AgentChatScreen(
        settings: widget.settings,
        api: widget.api,
        history: _chatHistory,
      ),
      SettingsScreen(
        settings: widget.settings,
        scheduler: _scheduler,
        auth: widget.auth,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.link_outlined),
            selectedIcon: const Icon(Icons.link),
            label: l10n.navScanLink,
          ),
          NavigationDestination(
            icon: const Icon(Icons.image_outlined),
            selectedIcon: const Icon(Icons.image),
            label: l10n.navScanImage,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            selectedIcon: const Icon(Icons.history),
            label: l10n.navHistory,
          ),
          NavigationDestination(
            icon: const Icon(Icons.smart_toy_outlined),
            selectedIcon: const Icon(Icons.smart_toy),
            label: l10n.navAgent,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
