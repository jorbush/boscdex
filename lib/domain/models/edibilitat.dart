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
        return Colors.green;
      case Edibilitat.comestible:
        return Colors.lightGreen;
      case Edibilitat.senseValor:
        return Colors.amber;
      case Edibilitat.toxic:
        return Colors.red;
      case Edibilitat.mortal:
        return const Color(0xFF4A0E0E);
    }
  }

  bool get isEdible =>
      this == Edibilitat.excellent || this == Edibilitat.comestible;

  static Edibilitat fromString(String value) {
    switch (value) {
      case 'excellent':
        return Edibilitat.excellent;
      case 'comestible':
        return Edibilitat.comestible;
      case 'senseValor':
      case 'sense_valor':
        return Edibilitat.senseValor;
      case 'toxic':
        return Edibilitat.toxic;
      case 'mortal':
        return Edibilitat.mortal;
      default:
        return Edibilitat.senseValor;
    }
  }
}
