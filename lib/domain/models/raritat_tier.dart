import 'package:flutter/material.dart';

enum RaritatTier {
  comu,
  pocFrequent,
  rar,
  moltRar,
  llegendari,
}

extension RaritatTierExtension on RaritatTier {
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
        return const Color(0xFFCD7F32); // Bronze
      case RaritatTier.pocFrequent:
        return const Color(0xFFC0C0C0); // Silver
      case RaritatTier.rar:
        return const Color(0xFFFFD700); // Gold
      case RaritatTier.moltRar:
        return Colors.purple;
      case RaritatTier.llegendari:
        return Colors.cyanAccent; // Holographic/Rainbow representation
    }
  }

  static RaritatTier fromString(String value) {
    switch (value) {
      case 'comu':
        return RaritatTier.comu;
      case 'pocFrequent':
      case 'poc_frequent':
        return RaritatTier.pocFrequent;
      case 'rar':
        return RaritatTier.rar;
      case 'moltRar':
      case 'molt_rar':
        return RaritatTier.moltRar;
      case 'llegendari':
        return RaritatTier.llegendari;
      default:
        return RaritatTier.comu;
    }
  }
}
