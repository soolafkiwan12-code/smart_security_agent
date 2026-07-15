import 'package:flutter/material.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/chat_history_service.dart';

class ChatSessionDetailScreen extends StatelessWidget {
  const ChatSessionDetailScreen({
    super.key,
    required this.session,
    required this.history,
  });

  final ChatSession session;
  final ChatHistoryService history;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitleDetail),
        actions: [
          IconButton(
            tooltip: l10n.historyDeleteTooltip,
            onPressed: () async {
              await history.remove(session.id);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: session.messages.length,
        itemBuilder: (context, i) {
          final m = session.messages[i];
          final isUser = m.role == ChatRole.user;
          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.86,
              ),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                m.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        },
      ),
    );
  }
}
