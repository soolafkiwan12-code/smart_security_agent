import 'package:flutter/material.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../services/chat_history_service.dart';
import 'chat_session_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.history,
    this.embedded = false,
  });

  final ChatHistoryService history;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final list = ListenableBuilder(
      listenable: history,
      builder: (context, _) {
        final sessions = history.loadAll();
        if (sessions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                l10n.historyEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final s = sessions[index];
            final subtitle =
                '${l10n.historyMessageCount(s.messages.length)} · ${s.updatedAt.toLocal()}';
            return ListTile(
              title: Text(
                s.preview.isEmpty ? l10n.historyTitleDetail : s.preview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(subtitle, maxLines: 2),
              trailing: IconButton(
                tooltip: l10n.historyDeleteTooltip,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => history.remove(s.id),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChatSessionDetailScreen(
                      session: s,
                      history: history,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    if (embedded) {
      return list;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
      ),
      body: list,
    );
  }
}
