import 'package:flutter/material.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../services/chat_history_service.dart';
import '../services/scan_history_service.dart';
import '../services/settings_service.dart';
import 'history_screen.dart';
import 'scan_history_list_screen.dart';

/// Bottom-nav “History” entry: chats + optional on-device scan log.
class HistoryHubScreen extends StatefulWidget {
  const HistoryHubScreen({
    super.key,
    required this.settings,
    required this.chatHistory,
    required this.scanHistory,
  });

  final SettingsService settings;
  final ChatHistoryService chatHistory;
  final ScanHistoryService scanHistory;

  @override
  State<HistoryHubScreen> createState() => _HistoryHubScreenState();
}

class _HistoryHubScreenState extends State<HistoryHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    widget.settings.addListener(_onSettings);
  }

  @override
  void dispose() {
    widget.settings.removeListener(_onSettings);
    _tabs.dispose();
    super.dispose();
  }

  void _onSettings() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.historyTabChat),
            Tab(text: l10n.historyTabScans),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          HistoryScreen(history: widget.chatHistory, embedded: true),
          ScanHistoryListScreen(
            settings: widget.settings,
            scanHistory: widget.scanHistory,
          ),
        ],
      ),
    );
  }
}
