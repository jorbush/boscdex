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
      fontFamily: RetroFonts.pixel,
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
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: ink),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        titleMedium: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodyMedium: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodySmall: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: inkSoft,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: ink,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        labelSmall: TextStyle(
          fontFamily: RetroFonts.pixel,
          color: inkSoft,
          fontSize: 10,
          fontWeight: FontWeight.w600,
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
        selectedLabelStyle: TextStyle(
          fontFamily: RetroFonts.pixel,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: RetroFonts.pixel,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
