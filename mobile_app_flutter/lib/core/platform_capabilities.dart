import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Android: automatic + manual agent modes are allowed.
/// iOS: manual only (Apple background/automation limits).
bool get platformSupportsAutomaticAgent {
  if (kIsWeb) return false;
  try {
    return Platform.isAndroid;
  } catch (_) {
    return false;
  }
}

bool get platformIsAndroid {
  if (kIsWeb) return false;
  try {
    return Platform.isAndroid;
  } catch (_) {
    return false;
  }
}

bool get platformIsIos {
  if (kIsWeb) return false;
  try {
    return Platform.isIOS;
  } catch (_) {
    return false;
  }
}
