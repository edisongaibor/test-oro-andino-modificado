import 'package:flutter/material.dart';

/// Paleta de colores tomada del diseño de Oro Andino.
class AppColors {
  AppColors._();

  static const Color gold = Color(0xFFE9B11F);
  static const Color goldDark = Color(0xFF9A7000);
  static const Color goldLight = Color(0xFFFFDE59);
  static const Color goldSoft = Color(0xFFFFF4D1);
  static const Color ink = Color(0xFF1B1B1B);
  static const Color muted = Color(0xFF5B6573);
  static const Color subtle = Color(0xFF6B7280);
  static const Color border = Color(0xFFE6E8EC);
  static const Color field = Color(0xFFFAFAFA);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerSoft = Color(0xFFFDECEA);
  static const Color warningSoft = Color(0xFFFFF8E1);
}

ThemeData buildAppTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: AppColors.gold,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.gold,
    onPrimary: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.goldDark,
    ),
  );
}
