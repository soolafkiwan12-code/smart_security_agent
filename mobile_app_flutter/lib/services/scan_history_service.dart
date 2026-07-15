import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scan_history_entry.dart';

const _kScanHistoryKey = 'agent_ab_scan_history_v1';
const _kMaxEntries = 100;

class ScanHistoryService extends ChangeNotifier {
  ScanHistoryService(this._prefs);

  final SharedPreferences _prefs;

  List<ScanHistoryEntry> loadAll() {
    final raw = _prefs.getString(_kScanHistoryKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ScanHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> add(ScanHistoryEntry entry) async {
    var all = loadAll()..removeWhere((e) => e.id == entry.id);
    all = [entry, ...all];
    if (all.length > _kMaxEntries) {
      all = all.sublist(0, _kMaxEntries);
    }
    await _prefs.setString(
      _kScanHistoryKey,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
    notifyListeners();
  }

  Future<void> clear() async {
    await _prefs.remove(_kScanHistoryKey);
    notifyListeners();
  }
}
