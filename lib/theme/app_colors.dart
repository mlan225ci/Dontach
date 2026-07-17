import 'package:flutter/material.dart';

/// Shared palette — [brandGreen] matches logo / splash (#00775B).
abstract final class AppColors {
  static const activeGreen = Color(0xFF2E7D32);
  static const brandGreen = Color(0xFF00775B);
  static const scaffoldDark = Color(0xFF121212);

  static LinearGradient activeGreenGradient({AlignmentGeometry? begin, AlignmentGeometry? end}) {
    return LinearGradient(
      begin: begin ?? Alignment.topLeft,
      end: end ?? Alignment.bottomRight,
      colors: [
        Color.lerp(activeGreen, Colors.black, 0.18)!,
        activeGreen,
        Color.lerp(activeGreen, Colors.white, 0.12)!,
      ],
    );
  }

  static LinearGradient brandGreenGradient({AlignmentGeometry? begin, AlignmentGeometry? end}) {
    return LinearGradient(
      begin: begin ?? Alignment.topLeft,
      end: end ?? Alignment.bottomRight,
      colors: [
        Color.lerp(brandGreen, Colors.black, 0.15)!,
        brandGreen,
        Color.lerp(brandGreen, Colors.white, 0.14)!,
      ],
    );
  }

  static List<BoxShadow> activeGreenShadow({double blur = 20, double spread = 1}) {
    return [
      BoxShadow(
        color: activeGreen.withValues(alpha: 0.42),
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.28),
        blurRadius: blur * 0.6,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> brandGreenShadow({double blur = 20, double spread = 1}) {
    return [
      BoxShadow(
        color: brandGreen.withValues(alpha: 0.45),
        blurRadius: blur,
        spreadRadius: spread,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.28),
        blurRadius: blur * 0.6,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
