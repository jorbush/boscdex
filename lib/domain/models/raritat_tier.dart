import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';

enum RaritatTier {
  comu,
  pocFrequent,
  rar,
  moltRar,
  llegendari,
}

extension RaritatTierExtension on RaritatTier {
  /// Localized rarity label respecting the user's selected language.
  String localizedLabel(BuildContext context) {
    return AppLocalizations.of(context).rarityLabel(this);
  }

  String get label {
    switch (this) {
      case RaritatTier.comu:
        return 'Comú';
      case RaritatTier.pocFrequent:
        return 'Poc freqüent';
      case RaritatTier.rar:
        return 'Rar';
      case RaritatTier.moltRar:
        return 'Molt rar';
      case RaritatTier.llegendari:
        return 'Llegendari';
    }
  }

  Color get color {
    switch (this) {
      case RaritatTier.comu:
        return const Color(0xFF7D6B58); // Earthy bronze
      case RaritatTier.pocFrequent:
        return const Color(0xFF4A7C6D); // Pine teal
      case RaritatTier.rar:
        return const Color(0xFFD4922A); // Vintage amber gold
      case RaritatTier.moltRar:
        return const Color(0xFF7E528F); // Mystic plum
      case RaritatTier.llegendari:
        return const Color(0xFF2B7A78); // Deep jade
    }
  }

  static RaritatTier? tryFromString(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'comu':
      case 'comú':
        return RaritatTier.comu;
      case 'pocfrequent':
      case 'poc_frequent':
        return RaritatTier.pocFrequent;
      case 'rar':
        return RaritatTier.rar;
      case 'moltrar':
      case 'molt_rar':
        return RaritatTier.moltRar;
      case 'llegendari':
        return RaritatTier.llegendari;
      default:
        return null;
    }
  }

  static RaritatTier fromString(String value,
      {RaritatTier fallback = RaritatTier.comu}) {
    return tryFromString(value) ?? fallback;
  }
}
