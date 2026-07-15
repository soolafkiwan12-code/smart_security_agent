import 'package:flutter/material.dart';

import 'package:smart_security_agent_app/l10n/app_localizations.dart';
import 'package:smart_security_agent_app/theme/app_typography.dart';

import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/settings_service.dart';

/// Root widget: wires settings + auth refresh and supplies a stable [ApiService].
class AppBootstrap extends StatefulWidget {
  const AppBootstrap({
    super.key,
    required this.settings,
    required this.auth,
  });

  final SettingsService settings;
  final AuthService auth;

  @override
  State<AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<AppBootstrap> {
  late final ApiService _api = ApiService(
    baseUrl: () => widget.settings.resolvedBaseUrl,
    getToken: () => widget.auth.accessToken,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.settings, widget.auth]),
      builder: (context, _) {
        return AgentAbApp(
          settings: widget.settings,
          auth: widget.auth,
          api: _api,
        );
      },
    );
  }
}

class AgentAbApp extends StatelessWidget {
  const AgentAbApp({
    super.key,
    required this.settings,
    required this.auth,
    required this.api,
  });

  final SettingsService settings;
  final AuthService auth;
  final ApiService api;

  /// Dark blue palette (compact, low “padding feel” via tighter component theme).
  static const Color _bgDeep = Color(0xFF0A1628);
  static const Color _surface = Color(0xFF132337);
  static const Color _surfaceVariant = Color(0xFF1B2E4A);
  static const Color _accent = Color(0xFF4DA3FF);

  static final ThemeData _lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final base = ThemeData(brightness: Brightness.light, useMaterial3: true);
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1A237E),
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: scheme.copyWith(onSurface: Colors.black),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.screenTitle,
        toolbarTextStyle: AppTypography.screenTitle,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          minimumSize: const Size(0, 48),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        labelStyle: const TextStyle(color: Colors.black87),
        hintStyle: TextStyle(color: Colors.black.withValues(alpha: 0.45)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    );
  }

  static final ThemeData _darkTheme = _buildDarkTheme();

  static ThemeData _buildDarkTheme() {
    const scheme = ColorScheme.dark(
      primary: _accent,
      onPrimary: Color(0xFF061018),
      primaryContainer: Color(0xFF1E3A5F),
      onPrimaryContainer: Color(0xFFD4E8FF),
      secondary: Color(0xFF7EB6FF),
      onSecondary: _bgDeep,
      surface: _surface,
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFFB0BCC9),
      surfaceContainerHighest: _surfaceVariant,
      error: Color(0xFFFF8A80),
      onError: _bgDeep,
      errorContainer: Color(0xFF5C2B2B),
      onErrorContainer: Color(0xFFFFDAD6),
      outline: Color(0xFF3D5166),
    );
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _bgDeep,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surface,
        foregroundColor: Color(0xFFE8EEF4),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTypography.screenTitle,
        toolbarTextStyle: AppTypography.screenTitle,
      ),
      colorScheme: scheme,
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _surface,
        indicatorColor: _accent.withValues(alpha: 0.22),
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      cardTheme: const CardThemeData(
        color: _surfaceVariant,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          minimumSize: const Size(0, 48),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          minimumSize: const Size(0, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: _surfaceVariant,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.45)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF3D5166)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: _accent,
        selectionColor: Color(0x664DA3FF),
        selectionHandleColor: _accent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: settings.materialThemeMode,
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        final platform = mq.textScaler.scale(1.0);
        final combined = TextScaler.linear(platform * settings.textSizeFactor);
        return MediaQuery(
          data: mq.copyWith(textScaler: combined),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: auth.canUseApp
          ? HomeShell(
              settings: settings,
              auth: auth,
              api: api,
            )
          : LoginScreen(
              settings: settings,
              auth: auth,
              api: api,
            ),
    );
  }
}
