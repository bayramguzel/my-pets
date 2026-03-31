import 'package:flutter/material.dart';

class AppGradientBackground extends StatelessWidget {
  final Widget child;

  const AppGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primary = scheme.primary;
    final surface = scheme.surface;

    final Color top = Color.lerp(primary, Colors.white, isDark ? 0.25 : 0.7)!;
    final Color bottom = Color.lerp(
      surface,
      Colors.white,
      isDark ? 0.1 : 0.55,
    )!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, bottom],
        ),
      ),
      child: child,
    );
  }
}
