import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat_session.dart';

const _kSessionsKey = 'agent_ab_chat_sessions_v1';
const _kMaxSessions = 40;

/// Local persisted list of AI chat sessions for the History tab.
class ChatHistoryService extends ChangeNotifier {
  ChatHistoryService(this._prefs);

  final SharedPreferences _prefs;

  List<ChatSession> loadAll() {
    final raw = _prefs.getString(_kSessionsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final sessions = list
          .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return sessions;
    } catch (_) {
      return [];
    }
  }

  Future<void> upsert(ChatSession session) async {
    var all = loadAll()..removeWhere((s) => s.id == session.id);
    all = [session, ...all];
    if (all.length > _kMaxSessions) {
      all = all.sublist(0, _kMaxSessions);
    }
    await _prefs.setString(
      _kSessionsKey,
      jsonEncode(all.map((s) => s.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> remove(String id) async {
    final all = loadAll()..removeWhere((s) => s.id == id);
    await _prefs.setString(
      _kSessionsKey,
      jsonEncode(all.map((s) => s.toJson()).toList()),
    );
    notifyListeners();
  }
}
