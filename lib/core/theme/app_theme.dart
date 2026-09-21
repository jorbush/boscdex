import 'package:flutter/material.dart';
import 'retro_decorations.dart';

class AppTheme {
  AppTheme._();

  /// Active retro-cartoon-videogame theme with light Game Boy / GBA aesthetic
  static final ThemeData retroTheme = _buildRetroTheme();

  /// Backward compatible alias for existing references
  static ThemeData get darkTheme => retroTheme;

  static ThemeData _buildRetroTheme() {
    const ink = RetroColors.ink;
    const inkSoft = RetroColors.inkSoft;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: RetroColors.background,
      colorScheme: const ColorScheme.light(
        primary: RetroColors.forestGreen,
        secondary: RetroColors.questAmber,
        tertiary: RetroColors.goldCoin,
        error: RetroColors.arcadeRed,
        surface: RetroColors.surface,
        onPrimary: Colors.white,
        onSecondary: ink,
        onSurface: ink,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: RetroColors.background,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: ink),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
        ),
        titleMedium: TextStyle(
          color: ink,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: ink,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: ink,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: inkSoft,
          fontSize: 12,
        ),
      ),
      cardTheme: CardTheme(
        color: RetroColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: ink, width: 2.2),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: RetroColors.surface,
        selectedItemColor: RetroColors.forestGreen,
        unselectedItemColor: inkSoft,
        elevation: 8,
        selectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      ),
    );
  }
}
