import 'package:flutter_test/flutter_test.dart';
import 'package:boscdex/domain/models/forager_level.dart';

void main() {
  group('ForagerLevel Model & Progression Tests', () {
    test('Initial user with 0 stats begins at Level 1 with 0 XP', () {
      final level = ForagerLevel.calculate(
        discoveredBolets: 0,
        identifiedArbres: 0,
        awardedBadges: 0,
        totalSightings: 0,
      );

      expect(level.level, equals(1));
      expect(level.totalXp, equals(0));
      expect(level.currentLevelXp, equals(0));
      expect(level.nextLevelXpRequired, equals(100));
      expect(level.progress, equals(0.0));
      expect(level.isMaxLevel, isFalse);
      expect(level.titleCa, equals('Novell del Bosc'));
      expect(level.titleEs, equals('Novato del Bosque'));
      expect(level.titleEn, equals('Forest Rookie'));
    });

    test('XP multipliers accurately credit individual activities', () {
      final level = ForagerLevel.calculate(
        discoveredBolets: 2, // 2 * 100 = 200 XP
        identifiedArbres: 1, // 1 * 75 = 75 XP
        awardedBadges: 1, // 1 * 150 = 150 XP
        totalSightings: 3, // 3 * 25 = 75 XP
      );

      expect(level.xpFromBolets, equals(200));
      expect(level.xpFromArbres, equals(75));
      expect(level.xpFromBadges, equals(150));
      expect(level.xpFromSightings, equals(75));
      expect(level.totalXp, equals(500));
      expect(level.level, equals(4)); // 500 XP is threshold for Level 4
    });

    test('Mid-level progress calculation is proportional', () {
      // Level 2 spans 100 to 250 XP (span = 150 XP)
      // With 175 XP, inLevel is 75 XP -> progress is 75 / 150 = 0.5 (50%)
      final level = ForagerLevel.calculate(
        discoveredBolets: 1, // 100
        identifiedArbres: 1, // 75
        awardedBadges: 0,
        totalSightings: 0,
      );

      expect(level.totalXp, equals(175));
      expect(level.level, equals(2));
      expect(level.currentLevelBaseXp, equals(100));
      expect(level.nextLevelThresholdXp, equals(250));
      expect(level.currentLevelXp, equals(75));
      expect(level.nextLevelXpRequired, equals(150));
      expect(level.progress, closeTo(0.5, 0.001));
    });

    test('Reaching 4600+ XP unlocks Level 10 (Master of the Forest)', () {
      final level = ForagerLevel.calculate(
        discoveredBolets: 22, // 2200
        identifiedArbres: 5, // 375
        awardedBadges: 6, // 900
        totalSightings: 50, // 1250 -> Total = 4725 XP
      );

      expect(level.totalXp, equals(4725));
      expect(level.level, equals(10));
      expect(level.isMaxLevel, isTrue);
      expect(level.progress, equals(1.0));
      expect(level.nextLevelThresholdXp, isNull);
      expect(level.title('ca'), equals('Mestre del Bosc'));
      expect(level.title('es'), equals('Maestro del Bosque'));
      expect(level.title('en'), equals('Master of the Forest'));
    });

    test('Negative numbers fail safely to 0 stats', () {
      final level = ForagerLevel.calculate(
        discoveredBolets: -5,
        identifiedArbres: -2,
        awardedBadges: -1,
        totalSightings: -10,
      );

      expect(level.level, equals(1));
      expect(level.totalXp, equals(0));
      expect(level.progress, equals(0.0));
    });

    test('ForagerLevel.initial() factory provides pristine beginner state', () {
      final initial = ForagerLevel.initial();
      expect(initial.level, equals(1));
      expect(initial.totalXp, equals(0));
      expect(initial.isMaxLevel, isFalse);
      expect(initial.progress, equals(0.0));
      expect(initial.discoveredBolets, equals(0));
      expect(initial.identifiedArbres, equals(0));
      expect(initial.awardedBadges, equals(0));
      expect(initial.totalSightings, equals(0));
    });

    test('All 10 level definitions have strictly ascending XP thresholds', () {
      expect(ForagerLevel.allLevels.length, equals(10));
      for (int i = 0; i < ForagerLevel.allLevels.length - 1; i++) {
        final current = ForagerLevel.allLevels[i];
        final next = ForagerLevel.allLevels[i + 1];
        expect(current.level + 1, equals(next.level));
        expect(next.xpThreshold, greaterThan(current.xpThreshold));
      }
    });

    test('Threshold boundary transitions operate with exact precision', () {
      // 99 XP -> Level 1 (requires 100 XP for Level 2)
      final lvl1Max = ForagerLevel.calculate(
        discoveredBolets: 0,
        identifiedArbres: 0,
        awardedBadges: 0,
        totalSightings: 3, // 75 XP
      );
      expect(lvl1Max.level, equals(1));

      // 100 XP -> exactly Level 2
      final lvl2Exact = ForagerLevel.calculate(
        discoveredBolets: 1, // 100 XP
        identifiedArbres: 0,
        awardedBadges: 0,
        totalSightings: 0,
      );
      expect(lvl2Exact.level, equals(2));
      expect(lvl2Exact.currentLevelBaseXp, equals(100));
      expect(lvl2Exact.currentLevelXp, equals(0));

      // 4600 XP -> exactly Level 10
      final lvl10Exact = ForagerLevel.calculate(
        discoveredBolets: 20, // 2000
        identifiedArbres: 0,
        awardedBadges: 6, // 900
        totalSightings: 68, // 1700 -> 4600 XP
      );
      expect(lvl10Exact.level, equals(10));
      expect(lvl10Exact.isMaxLevel, isTrue);
      expect(lvl10Exact.nextLevelThresholdXp, isNull);
    });

    test('Trilingual title helper returns appropriate locale strings', () {
      final def = ForagerLevel.allLevels[2]; // Level 3
      expect(def.title('ca'), equals('Rastrejador Silvestre'));
      expect(def.title('es'), equals('Rastreador Silvestre'));
      expect(def.title('en'), equals('Wilderness Tracker'));
      expect(def.title('unknown'), equals('Rastrejador Silvestre'));
    });
  });
}
