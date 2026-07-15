import 'package:flutter/material.dart';

/// Shared screen title style (e.g. Scan Link, Settings header).
abstract final class AppTypography {
  static const Color screenTitleBlue = Color(0xFF4A90E2);

  static const TextStyle screenTitle = TextStyle(
    color: screenTitleBlue,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}
