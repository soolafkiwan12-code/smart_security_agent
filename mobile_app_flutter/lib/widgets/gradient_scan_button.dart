import 'package:flutter/material.dart';

/// Primary scan actions: violet → blue gradient.
class GradientScanButton extends StatelessWidget {
  const GradientScanButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.shield_outlined,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool loading;

  static const _gradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF4A90E2)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null || loading;
    final effectiveOpacity = disabled ? 0.55 : 1.0;

    return Material(
      elevation: disabled ? 2 : 6,
      shadowColor: const Color(0xFF4A90E2).withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: _gradient,
          ),
          child: Opacity(
            opacity: effectiveOpacity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withValues(alpha: disabled ? 0.65 : 1),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
