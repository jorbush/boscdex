import 'package:boscdex/core/localization/app_localizations.dart';
import 'package:boscdex/domain/models/edibilitat.dart';
import 'package:boscdex/domain/models/raritat_tier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations Unit Tests', () {
    test('Supported locales are ca, es, en', () {
      const delegate = AppLocalizations.delegate;
      expect(delegate.isSupported(const Locale('ca')), isTrue);
      expect(delegate.isSupported(const Locale('es')), isTrue);
      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
    });

    test('General and App Identity strings across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.appName, equals('Boscdex'));
      expect(es.appName, equals('Boscdex'));
      expect(en.appName, equals('Boscdex'));

      expect(ca.appSubtitle, equals('La Pokédex del boletaire'));
      expect(es.appSubtitle, equals('La Pokédex del buscador de setas'));
      expect(en.appSubtitle, equals("The Forager's Pokédex"));

      expect(ca.offline100, equals('100% Offline'));
      expect(es.offline100, equals('100% Offline'));
      expect(en.offline100, equals('100% Offline'));
    });

    test('Navigation tabs across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.tabBoscdex, equals('Boscdex'));
      expect(ca.tabScan, equals('Escanejar'));
      expect(ca.tabJournal, equals('Diari'));

      expect(es.tabBoscdex, equals('Boscdex'));
      expect(es.tabScan, equals('Escanear'));
      expect(es.tabJournal, equals('Diario'));

      expect(en.tabBoscdex, equals('Boscdex'));
      expect(en.tabScan, equals('Scan'));
      expect(en.tabJournal, equals('Journal'));
    });

    test('Settings strings across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.settingsTitle, equals('Configuració'));
      expect(es.settingsTitle, equals('Configuración'));
      expect(en.settingsTitle, equals('Settings'));

      expect(ca.settingsLanguage, equals("Idioma de l'aplicació"));
      expect(es.settingsLanguage, equals('Idioma de la aplicación'));
      expect(en.settingsLanguage, equals('App Language'));

      expect(ca.currentLanguageDisplayName, equals('Català (Per defecte)'));
      expect(es.currentLanguageDisplayName, equals('Castellano'));
      expect(en.currentLanguageDisplayName, equals('English'));
    });

    test('Edibility and Rarity localized labels', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      // Edibility
      expect(ca.edibilityLabel(Edibilitat.excellent),
          equals('Comestible excel·lent'));
      expect(es.edibilityLabel(Edibilitat.excellent),
          equals('Excelente comestible'));
      expect(
          en.edibilityLabel(Edibilitat.excellent), equals('Excellent edible'));

      expect(ca.edibilityLabel(Edibilitat.mortal), equals('Mortal'));
      expect(es.edibilityLabel(Edibilitat.mortal), equals('Mortal'));
      expect(en.edibilityLabel(Edibilitat.mortal), equals('Deadly'));

      // Rarity
      expect(ca.rarityLabel(RaritatTier.comu), equals('Comú'));
      expect(es.rarityLabel(RaritatTier.comu), equals('Común'));
      expect(en.rarityLabel(RaritatTier.comu), equals('Common'));

      expect(ca.rarityLabel(RaritatTier.llegendari), equals('Llegendari'));
      expect(es.rarityLabel(RaritatTier.llegendari), equals('Legendario'));
      expect(en.rarityLabel(RaritatTier.llegendari), equals('Legendary'));
    });

    test('Badges and Dialogs across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.myBadges, equals('Les Meves Insígnies'));
      expect(es.myBadges, equals('Mis Insignias'));
      expect(en.myBadges, equals('My Badges'));

      expect(ca.badgeUnlocked, equals('Desbloquejat'));
      expect(es.badgeUnlocked, equals('Desbloqueado'));
      expect(en.badgeUnlocked, equals('Unlocked'));
    });

    test('Camera, Scan and Viewfinder guidance across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.focusCapAndGills,
          equals('Enfoca el barret i les làmines del bolet'));
      expect(es.focusCapAndGills,
          equals('Enfoca el sombrero y las láminas de la seta'));
      expect(en.focusCapAndGills,
          equals('Focus on the cap and gills of the mushroom'));

      expect(ca.focusBarkAndLeaves,
          equals("Enfoca l'escorça o les fulles de l'arbre"));
      expect(es.focusBarkAndLeaves,
          equals('Enfoca la corteza o las hojas del árbol'));
      expect(en.focusBarkAndLeaves,
          equals('Focus on the bark or leaves of the tree'));

      expect(ca.startingCamera, equals('Iniciant càmera...'));
      expect(es.startingCamera, equals('Iniciando cámara...'));
      expect(en.startingCamera, equals('Starting camera...'));
    });

    test('Safety and Lookalike alerts across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(
          ca.dangerousLookalikeAlert, equals('ALERTA DE CONFUSIÓ PERILLOSA'));
      expect(
          es.dangerousLookalikeAlert, equals('ALERTA DE CONFUSIÓN PELIGROSA'));
      expect(en.dangerousLookalikeAlert, equals('DANGEROUS LOOKALIKE ALERT'));

      expect(
          ca.attentionLookalikePrefix, equals('ATENCIÓ: Es pot confondre amb'));
      expect(es.attentionLookalikePrefix,
          equals('ATENCIÓN: Se puede confundir con'));
      expect(
          en.attentionLookalikePrefix, equals('WARNING: Can be confused with'));
    });

    test('Location map title, camera error and notes across locales', () {
      const ca = AppLocalizations(Locale('ca'));
      const es = AppLocalizations(Locale('es'));
      const en = AppLocalizations(Locale('en'));

      expect(ca.distributionAreaPokedex, equals('Ubicació'));
      expect(es.distributionAreaPokedex, equals('Ubicación'));
      expect(en.distributionAreaPokedex, equals('Location'));

      expect(ca.noCameraDetected, equals('No s\'ha detectat la càmera'));
      expect(es.noCameraDetected, equals('No se ha detectado la cámara'));
      expect(en.noCameraDetected, equals('No camera detected'));

      expect(ca.notes, equals('Notes'));
      expect(es.notes, equals('Notas'));
      expect(en.notes, equals('Notes'));

      expect(ca.settingsAiCertaintyFilterTitle,
          equals('Filtre de certesa IA (70%)'));
      expect(es.settingsAiCertaintyFilterTitle,
          equals('Filtro de certeza IA (70%)'));
      expect(en.settingsAiCertaintyFilterTitle,
          equals('AI Confidence Filter (70%)'));

      expect(
          ca.settingsOnDeviceNeuralNetwork, equals('Xarxa Neuronal On-Device'));
      expect(
          es.settingsOnDeviceNeuralNetwork, equals('Red Neuronal On-Device'));
      expect(
          en.settingsOnDeviceNeuralNetwork, equals('On-Device Neural Network'));
    });
  });
}
