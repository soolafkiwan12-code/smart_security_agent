import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../models/ai_chat_response.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../services/chat_history_service.dart';
import '../services/settings_service.dart';

class AgentChatScreen extends StatefulWidget {
  const AgentChatScreen({
    super.key,
    required this.settings,
    required this.api,
    required this.history,
  });

  final SettingsService settings;
  final ApiService api;
  final ChatHistoryService history;

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  final TextEditingController _input = TextEditingController();
  final List<ChatMessage> _history = [];
  final ScrollController _scroll = ScrollController();
  bool _sending = false;
  String? _error;
  String? _sessionId;
  late String _localSessionId;
  final _timeFmt = DateFormat.jm();

  @override
  void initState() {
    super.initState();
    _localSessionId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<ChatMessage> _messagesForApi() {
    return _history
        .where((m) => m.role == ChatRole.user || m.role == ChatRole.assistant)
        .toList();
  }

  String _buildPreview() {
    for (final m in _history) {
      if (m.role == ChatRole.user) {
        final t = m.content.trim();
        if (t.isEmpty) continue;
        return t.length > 80 ? '${t.substring(0, 80)}…' : t;
      }
    }
    return '';
  }

  Future<void> _persistSession() async {
    if (!widget.settings.saveChatHistoryEnabled) return;
    if (_history.isEmpty) return;
    await widget.history.upsert(
      ChatSession(
        id: _localSessionId,
        updatedAt: DateTime.now(),
        preview: _buildPreview(),
        messages: List<ChatMessage>.from(_history),
      ),
    );
  }

  Future<void> _completeAssistantReply(AiChatResponse res) async {
    if (res.sessionId != null) {
      _sessionId = res.sessionId;
    }
    setState(() {
      _history.add(ChatMessage(
        role: ChatRole.assistant,
        content: res.reply,
        sentAt: DateTime.now(),
      ));
    });
    await _persistSession();
  }

  Future<void> _sendNewMessage() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _error = null;
      _sending = true;
      _history.add(ChatMessage(
        role: ChatRole.user,
        content: text,
        sentAt: DateTime.now(),
      ));
      _input.clear();
    });
    _scrollToBottom();

    try {
      final res = await widget.api.chat(
        messages: _messagesForApi(),
        source: widget.settings.sourceManual,
        sessionId: _sessionId,
      );
      await _completeAssistantReply(res);
    } catch (e) {
      setState(() {
        _error = e is ApiException ? e.message : e.toString();
        if (_history.isNotEmpty && _history.last.role == ChatRole.user) {
          _history.removeLast();
        }
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }

  Future<void> _regenerateLast() async {
    if (_sending) return;
    if (_history.isEmpty || _history.last.role != ChatRole.assistant) {
      return;
    }

    setState(() {
      _error = null;
      _sending = true;
      _history.removeLast();
    });
    _scrollToBottom();

    try {
      final res = await widget.api.chat(
        messages: _messagesForApi(),
        source: widget.settings.sourceManual,
        sessionId: _sessionId,
      );
      await _completeAssistantReply(res);
    } catch (e) {
      setState(() {
        _error = e is ApiException ? e.message : e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _sending = false);
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final typing = _sending && (_history.isEmpty || _history.last.role == ChatRole.user);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: [
          if (_history.isNotEmpty && _history.last.role == ChatRole.assistant)
            IconButton(
              tooltip: l10n.regenerate,
              onPressed: _sending ? null : _regenerateLast,
              icon: const Icon(Icons.refresh),
            ),
          IconButton(
            tooltip: l10n.chatClearTooltip,
            onPressed: _sending
                ? null
                : () => setState(() {
                      _history.clear();
                      _sessionId = null;
                      _error = null;
                      _localSessionId =
                          DateTime.now().millisecondsSinceEpoch.toString();
                    }),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_error != null)
            MaterialBanner(
              content: Text(_error!, maxLines: 4),
              actions: [
                TextButton(
                  onPressed: () => setState(() => _error = null),
                  child: Text(l10n.chatDismiss),
                ),
              ],
            ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: _history.length,
              itemBuilder: (context, i) {
                final m = _history[i];
                final isUser = m.role == ChatRole.user;
                final ts = m.sentAt != null ? _timeFmt.format(m.sentAt!.toLocal()) : '';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * 0.86,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Material(
                          color: isUser
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              m.content,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (ts.isNotEmpty)
                              Text(
                                ts,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              tooltip: l10n.copyMessage,
                              icon: const Icon(Icons.copy, size: 18),
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: m.content),
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.messageCopied)),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (typing)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.typingIndicator,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendNewMessage(),
                      decoration: InputDecoration(
                        hintText: l10n.chatHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sending ? null : _sendNewMessage,
                    child: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
