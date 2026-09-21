import 'package:flutter/material.dart';

/// Edibility classification for mushroom species.
enum Edibilitat {
  excellent,
  comestible,
  senseValor,
  toxic,
  mortal,
}

extension EdibilitatExtension on Edibilitat {
  String get label {
    switch (this) {
      case Edibilitat.excellent:
        return 'Comestible excel·lent';
      case Edibilitat.comestible:
        return 'Comestible';
      case Edibilitat.senseValor:
        return 'Sense valor culinari';
      case Edibilitat.toxic:
        return 'Tòxic';
      case Edibilitat.mortal:
        return 'Mortal';
    }
  }

  IconData get icon {
    switch (this) {
      case Edibilitat.excellent:
        return Icons.star;
      case Edibilitat.comestible:
        return Icons.restaurant;
      case Edibilitat.senseValor:
        return Icons.block;
      case Edibilitat.toxic:
        return Icons.warning;
      case Edibilitat.mortal:
        return Icons.dangerous;
    }
  }

  Color get color {
    switch (this) {
      case Edibilitat.excellent:
        return const Color(0xFF2D6E44);
      case Edibilitat.comestible:
        return const Color(0xFF4C9A66);
      case Edibilitat.senseValor:
        return const Color(0xFF7E8F84);
      case Edibilitat.toxic:
        return const Color(0xFFD97736);
      case Edibilitat.mortal:
        return const Color(0xFFB3332C);
    }
  }

  bool get isEdible =>
      this == Edibilitat.excellent || this == Edibilitat.comestible;

  bool get isToxic => this == Edibilitat.toxic || this == Edibilitat.mortal;

  /// 100% opaque light background color for high-contrast retro badge rendering.
  ///
  /// Prevents underlying dark comic box shadows from bleeding through transparent layers.
  Color get badgeBackgroundColor {
    switch (this) {
      case Edibilitat.excellent:
        return const Color(0xFFE0EFE4);
      case Edibilitat.comestible:
        return const Color(0xFFE5F4EA);
      case Edibilitat.senseValor:
        return const Color(0xFFECEFEA);
      case Edibilitat.toxic:
        return const Color(0xFFFDF0E4);
      case Edibilitat.mortal:
        return const Color(0xFFFCE8E7);
    }
  }

  /// High-contrast icon color on top of [badgeBackgroundColor].
  Color get badgeIconColor {
    switch (this) {
      case Edibilitat.excellent:
        return const Color(0xFF2D6E44);
      case Edibilitat.comestible:
        return const Color(0xFF2D7B48);
      case Edibilitat.senseValor:
        return const Color(0xFF5E6F64);
      case Edibilitat.toxic:
        return const Color(0xFFC75D1B);
      case Edibilitat.mortal:
        return const Color(0xFFB3332C);
    }
  }

  static Edibilitat? tryFromString(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'excellent':
        return Edibilitat.excellent;
      case 'comestible':
        return Edibilitat.comestible;
      case 'sensevalor':
      case 'sense_valor':
        return Edibilitat.senseValor;
      case 'toxic':
      case 'tòxic':
        return Edibilitat.toxic;
      case 'mortal':
        return Edibilitat.mortal;
      default:
        return null;
    }
  }

  static Edibilitat fromString(String value,
      {Edibilitat fallback = Edibilitat.senseValor}) {
    return tryFromString(value) ?? fallback;
  }
}
