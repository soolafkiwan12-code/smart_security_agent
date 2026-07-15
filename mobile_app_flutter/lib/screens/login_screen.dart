import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:smart_security_agent_app/l10n/app_localizations.dart';

import '../config.dart';
import '../services/api_exception.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.settings,
    required this.auth,
    required this.api,
  });

  final SettingsService settings;
  final AuthService auth;
  final ApiService api;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  static bool _isValidEmailFormat(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  Future<void> _runEmailLogin() async {
    final l10n = AppLocalizations.of(context)!;
    final principal = _email.text.trim();

    setState(() {
      _busy = true;
      _passwordError = null;
      _emailError = null;
    });

    if (principal.isEmpty) {
      if (mounted) {
        setState(() {
          _busy = false;
          _emailError = l10n.loginErrorEnterEmail;
        });
      }
      return;
    }
    if (principal.contains('@') && !_isValidEmailFormat(principal)) {
      if (mounted) {
        setState(() {
          _busy = false;
          _emailError = l10n.loginErrorInvalidEmail;
        });
      }
      return;
    }

    try {
      await widget.auth.loginWithEmailPassword(
        widget.api,
        principal: principal,
        password: _password.text,
      );
    } catch (e) {
      if (!mounted) return;
      if (e is ApiException) {
        if (e.loginFailureKind == LoginFailureKind.accountNotFound) {
          setState(() {
            _emailError = l10n.loginErrorAccountNotFound;
            _passwordError = null;
          });
        } else if (e.loginFailureKind == LoginFailureKind.wrongPassword) {
          setState(() {
            _passwordError = l10n.loginErrorWrongPassword;
            _emailError = null;
          });
        } else {
          setState(() {
            _passwordError = e.message;
            _emailError = null;
          });
        }
      } else {
        setState(() => _passwordError = e.toString());
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runOAuth(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _passwordError = null;
      _emailError = null;
    });
    try {
      await action();
    } catch (e) {
      final msg = e is ApiException ? e.message : e.toString();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _googleLogin() async {
    await _runOAuth(() async {
      final google = GoogleSignIn(
        scopes: const ['email', 'openid'],
      );
      final account = await google.signIn();
      if (account == null) {
        throw const ApiException('Google sign-in cancelled.');
      }
      final ga = await account.authentication;
      final id = ga.idToken;
      if (id == null || id.isEmpty) {
        throw const ApiException(
          'No Google ID token. Check Firebase / OAuth client setup for this app.',
        );
      }
      await widget.auth.loginWithGoogle(widget.api, id);
    });
  }

  Future<void> _appleLogin() async {
    await _runOAuth(() async {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final token = credential.identityToken;
      if (token == null || token.isEmpty) {
        throw const ApiException('Apple did not return an identity token.');
      }
      await widget.auth.loginWithApple(
        widget.api,
        identityToken: token,
        authorizationCode: credential.authorizationCode,
      );
    });
  }

  InputDecoration _outlineFieldDecoration({
    required String labelText,
    required String? errorText,
    required ColorScheme cs,
    Widget? suffixIcon,
  }) {
    final r = BorderRadius.circular(8);
    final hasErr = errorText != null;
    return InputDecoration(
      labelText: labelText,
      errorText: errorText,
      errorMaxLines: 4,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: r),
      enabledBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(
          color: hasErr ? cs.error : cs.outline,
          width: hasErr ? 1.5 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(
          color: hasErr ? cs.error : cs.primary,
          width: hasErr ? 2 : 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: cs.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    final socialOutline = BorderSide(
      color: cs.outline,
      width: 1.6,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              onChanged: (_) => setState(() => _emailError = null),
              decoration: _outlineFieldDecoration(
                labelText: l10n.loginEmailHint,
                errorText: _emailError,
                cs: cs,
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              onChanged: (_) => setState(() => _passwordError = null),
              obscureText: _obscurePassword,
              decoration: _outlineFieldDecoration(
                labelText: l10n.loginPasswordHint,
                errorText: _passwordError,
                cs: cs,
                suffixIcon: IconButton(
                  tooltip: _obscurePassword ? l10n.loginShowPassword : l10n.loginHidePassword,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _busy ? null : _runEmailLogin,
                child: Text(l10n.loginSubmit),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _busy ? null : _googleLogin,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: cs.onSurface,
                  side: socialOutline,
                ),
                child: Text(l10n.loginGoogle),
              ),
            ),
            if (defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.android) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _busy ? null : _appleLogin,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: cs.onSurface,
                    side: socialOutline,
                  ),
                  child: Text(l10n.loginApple),
                ),
              ),
            ],
            if (AppConfig.authGuestAllowed) ...[
              const SizedBox(height: 24),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => widget.auth.continueAsGuest(),
                child: Text(l10n.loginGuest),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Backend auth endpoints: /auth/login, /auth/google, /auth/apple — return JSON with access_token.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
