import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0D1B0E), // Dark bark
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF1B4332), // Deep forest green
        secondary: Color(0xFFD4A574), // Mushroom amber
        tertiary: Color(0xFFE9C46A), // Accent/Ochre
        error: Color(0xFFDC2626), // Alert red
        surface: Color(0xFF1A2F1A), // Moss
        onPrimary: Color(0xFFF5F0E8),
        onSecondary: Color(0xFF0D1B0E),
        onSurface: Color(0xFFF5F0E8),
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFF5F0E8)),
        displayMedium: TextStyle(color: Color(0xFFF5F0E8)),
        bodyLarge: TextStyle(color: Color(0xFFF5F0E8)),
        bodyMedium: TextStyle(color: Color(0xFFF5F0E8)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A2F1A),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0D1B0E),
        selectedItemColor: Color(0xFFE9C46A),
        unselectedItemColor: Colors.white54,
      ),
    );
  }
}
