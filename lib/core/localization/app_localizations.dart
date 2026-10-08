import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/models/edibilitat.dart';
import '../../domain/models/raritat_tier.dart';

/// App localization strings supporting Catalan (`ca` - default), Spanish (`es`), and English (`en`).
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ca'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get languageCode => locale.languageCode;

  // --- General & App Identity ---
  String get appName => 'Boscdex';

  String get appTagline {
    switch (languageCode) {
      case 'es':
        return 'La Pokédex micológica de Cataluña';
      case 'en':
        return 'The Mycological Pokédex of Catalonia';
      case 'ca':
      default:
        return 'La Pokédex micològica de Catalunya';
    }
  }

  String get appSubtitle {
    switch (languageCode) {
      case 'es':
        return 'La Pokédex del buscador de setas';
      case 'en':
        return 'The Forager\'s Pokédex';
      case 'ca':
      default:
        return 'La Pokédex del boletaire';
    }
  }

  String get splashSubtitle {
    switch (languageCode) {
      case 'es':
        return 'La Pokédex del buscador de setas para explorar el bosque catalán';
      case 'en':
        return 'The forager\'s Pokédex to explore the Catalan forest';
      case 'ca':
      default:
        return 'La Pokédex del boletaire per explorar el bosc català';
    }
  }

  String get offline100 => '100% Offline';

  // --- Navigation Tabs ---
  String get tabBoscdex => 'Boscdex';

  String get tabScan {
    switch (languageCode) {
      case 'es':
        return 'Escanear';
      case 'en':
        return 'Scan';
      case 'ca':
      default:
        return 'Escanejar';
    }
  }

  String get tabJournal {
    switch (languageCode) {
      case 'es':
        return 'Diario';
      case 'en':
        return 'Journal';
      case 'ca':
      default:
        return 'Diari';
    }
  }

  // --- Settings Screen ---
  String get settingsTitle {
    switch (languageCode) {
      case 'es':
        return 'Configuración';
      case 'en':
        return 'Settings';
      case 'ca':
      default:
        return 'Configuració';
    }
  }

  String get settingsAppPreferences {
    switch (languageCode) {
      case 'es':
        return 'PREFERENCIAS DE LA APLICACIÓN';
      case 'en':
        return 'APP PREFERENCES';
      case 'ca':
      default:
        return 'PREFERÈNCIES DE L\'APLICACIÓ';
    }
  }

  String get settingsLanguage {
    switch (languageCode) {
      case 'es':
        return 'Idioma de la aplicación';
      case 'en':
        return 'App Language';
      case 'ca':
      default:
        return 'Idioma de l\'aplicació';
    }
  }

  String get settingsSelectLanguage {
    switch (languageCode) {
      case 'es':
        return 'Seleccionar idioma';
      case 'en':
        return 'Select Language';
      case 'ca':
      default:
        return 'Selecciona l\'idioma';
    }
  }

  String get languageNameCatalan => 'Català (Per defecte)';
  String get languageNameSpanish => 'Castellano';
  String get languageNameEnglish => 'English';

  String get currentLanguageDisplayName {
    switch (languageCode) {
      case 'es':
        return languageNameSpanish;
      case 'en':
        return languageNameEnglish;
      case 'ca':
      default:
        return languageNameCatalan;
    }
  }

  String get settingsSoundTitle {
    switch (languageCode) {
      case 'es':
        return 'Efectos de sonido retro 8-bit';
      case 'en':
        return '8-bit Retro Sound Effects';
      case 'ca':
      default:
        return 'Efectes de so retro 8-bit';
    }
  }

  String get settingsSoundSubtitle {
    switch (languageCode) {
      case 'es':
        return 'Sonidos de obturador, fanfarria de descubrimiento y medallas';
      case 'en':
        return 'Shutter sounds, discovery fanfare and badges';
      case 'ca':
      default:
        return 'Sons de disparador, fanfàrria de descobriment i medalles';
    }
  }

  String get settingsHapticTitle {
    switch (languageCode) {
      case 'es':
        return 'Respuesta háptica (Vibración)';
      case 'en':
        return 'Haptic Feedback (Vibration)';
      case 'ca':
      default:
        return 'Resposta hàptica (Vibració)';
    }
  }

  String get settingsHapticSubtitle {
    switch (languageCode) {
      case 'es':
        return 'Respuesta táctil al pulsar botones y descubrir especies';
      case 'en':
        return 'Tactile feedback when pressing buttons and discovering species';
      case 'ca':
      default:
        return 'Feedback tàctil en prémer botons i descobrir espècies';
    }
  }

  String get settingsSafetySection {
    switch (languageCode) {
      case 'es':
        return 'SEGURIDAD Y AVISO LEGAL';
      case 'en':
        return 'SAFETY & LEGAL NOTICE';
      case 'ca':
      default:
        return 'SEGURETAT I AVÍS LEGAL';
    }
  }

  String get settingsLegalDisclaimerTitle {
    switch (languageCode) {
      case 'es':
        return 'Aviso legal y descargo';
      case 'en':
        return 'Legal notice and disclaimer';
      case 'ca':
      default:
        return 'Avís legal i descàrrec';
    }
  }

  String get settingsLegalDisclaimerSubtitle {
    switch (languageCode) {
      case 'es':
        return 'Revisa los términos legales y avisos de consumo';
      case 'en':
        return 'Review legal terms and consumption notices';
      case 'ca':
      default:
        return 'Revisa els termes legals i avisos de consum';
    }
  }

  String get settingsConsultExpertTitle {
    switch (languageCode) {
      case 'es':
        return 'Consulta siempre a un experto';
      case 'en':
        return 'Always consult an expert';
      case 'ca':
      default:
        return 'Consulta sempre un expert';
    }
  }

  String get settingsConsultExpertSubtitle {
    switch (languageCode) {
      case 'es':
        return 'La IA es una ayuda orientativa y puede equivocarse. ¡Nunca consumas setas sin validación humana experta!';
      case 'en':
        return 'AI is only a guiding tool and can make mistakes. Never consume wild mushrooms without expert human validation!';
      case 'ca':
      default:
        return 'La IA és una ajuda orientativa i pot equivocar-se. Mai consumeixis bolets sense validació humana experta!';
    }
  }

  String get settingsStatsSection {
    switch (languageCode) {
      case 'es':
        return 'ESTADÍSTICAS DEL BUSCADOR';
      case 'en':
        return 'FORAGER STATISTICS';
      case 'ca':
      default:
        return 'ESTADÍSTIQUES DEL BOLETAIRE';
    }
  }

  String get settingsSpeciesDiscovered {
    switch (languageCode) {
      case 'es':
        return 'Especies descubiertas';
      case 'en':
        return 'Discovered species';
      case 'ca':
      default:
        return 'Espècies descobertes';
    }
  }

  String get settingsTotalSightings {
    switch (languageCode) {
      case 'es':
        return 'Avistamientos registrados';
      case 'en':
        return 'Logged sightings';
      case 'ca':
      default:
        return 'Avistaments registrats';
    }
  }

  String get settingsDiagnosticsSection {
    switch (languageCode) {
      case 'es':
        return 'DIAGNÓSTICO DEL SISTEMA OFFLINE';
      case 'en':
        return 'OFFLINE SYSTEM DIAGNOSTICS';
      case 'ca':
      default:
        return 'DIAGNÒSTIC DEL SISTEMA OFFLINE';
    }
  }

  String get settingsTfliteModel {
    switch (languageCode) {
      case 'es':
        return 'Modelo de IA (TFLite)';
      case 'en':
        return 'AI Model (TFLite)';
      case 'ca':
      default:
        return 'Model d\'IA (TFLite)';
    }
  }

  String get settingsDatabase {
    switch (languageCode) {
      case 'es':
        return 'Base de datos SQLite';
      case 'en':
        return 'SQLite Database';
      case 'ca':
      default:
        return 'Base de dades SQLite';
    }
  }

  String get settingsAudioEngine {
    switch (languageCode) {
      case 'es':
        return 'Motor de sonido 8-bit';
      case 'en':
        return '8-bit Audio Engine';
      case 'ca':
      default:
        return 'Motor de so 8-bit';
    }
  }

  String get settingsClose {
    switch (languageCode) {
      case 'es':
        return 'Cerrar';
      case 'en':
        return 'Close';
      case 'ca':
      default:
        return 'Tancar';
    }
  }

  String get settingsAiCertaintyFilterTitle {
    switch (languageCode) {
      case 'es':
        return 'Filtro de certeza IA (70%)';
      case 'en':
        return 'AI Confidence Filter (70%)';
      case 'ca':
      default:
        return 'Filtre de certesa IA (70%)';
    }
  }

  String get settingsAiCertaintyFilterSubtitle {
    switch (languageCode) {
      case 'es':
        return 'Cualquier coincidencia con certeza inferior al 70% o con riesgo de confusión tóxica activa la alerta roja.';
      case 'en':
        return 'Any match with confidence below 70% or with toxic lookalike risk triggers the red alert.';
      case 'ca':
      default:
        return 'Qualsevol coincidència amb certesa inferior al 70% o amb risc de confusió tòxica activa l\'alerta vermella.';
    }
  }

  String get settingsDataAndAiEngine {
    switch (languageCode) {
      case 'es':
        return 'DATOS Y MOTOR IA LOCAL';
      case 'en':
        return 'LOCAL DATA & AI ENGINE';
      case 'ca':
      default:
        return 'DADES I MOTOR IA LOCAL';
    }
  }

  String get settingsOnDeviceNeuralNetwork {
    switch (languageCode) {
      case 'es':
        return 'Red Neuronal On-Device';
      case 'en':
        return 'On-Device Neural Network';
      case 'ca':
      default:
        return 'Xarxa Neuronal On-Device';
    }
  }

  String get settingsOnDeviceNeuralNetworkDesc {
    switch (languageCode) {
      case 'es':
        return 'Modelo INT8 cuantizado (~2.5 MB) integrado en la app. Ejecución 100% autónoma sin conexión a internet.';
      case 'en':
        return 'Quantized INT8 model (~2.5 MB) bundled in the app. 100% autonomous execution without internet connection.';
      case 'ca':
      default:
        return 'Model INT8 quantitzat (~2.5 MB) integrat a l\'app. Execució 100% autònoma sense connexió a internet.';
    }
  }

  String get settingsSqliteDatabase {
    switch (languageCode) {
      case 'es':
        return 'Catálogo Relacional SQLite';
      case 'en':
        return 'SQLite Relational Catalog';
      case 'ca':
      default:
        return 'Catàleg Relacional SQLite';
    }
  }

  String get settingsExpeditionStatus {
    switch (languageCode) {
      case 'es':
        return 'Estado de Tu Expedición';
      case 'en':
        return 'Your Expedition Status';
      case 'ca':
      default:
        return 'Estat de la Teva Expedició';
    }
  }

  String get settingsAboutBoscdex {
    switch (languageCode) {
      case 'es':
        return 'SOBRE BOSCDEX';
      case 'en':
        return 'ABOUT BOSCDEX';
      case 'ca':
      default:
        return 'SOBRE BOSCDEX';
    }
  }

  String get settingsPrivacyCommitment {
    switch (languageCode) {
      case 'es':
        return 'Compromiso de Privacidad';
      case 'en':
        return 'Privacy Commitment';
      case 'ca':
      default:
        return 'Compromís de Privacitat';
    }
  }

  String get settingsPrivacyCommitmentDesc {
    switch (languageCode) {
      case 'es':
        return 'Boscdex está diseñada para funcionar en las profundidades del bosque sin cobertura. Todas las fotografías, datos GPS y análisis de imagen se quedan estrictamente en tu dispositivo.';
      case 'en':
        return 'Boscdex is designed to work in the depths of the forest without coverage. All photos, GPS data, and image analyses stay strictly on your device.';
      case 'ca':
      default:
        return 'Boscdex està dissenyada per funcionar a les profunditats del bosc sense cobertura. Totes les fotografies, dades GPS i anàlisis d\'imatge es queden estrictament al teu dispositiu.';
    }
  }

  // --- Boscdex Screen & Filters ---
  String get filterAll {
    switch (languageCode) {
      case 'es':
        return 'Todos';
      case 'en':
        return 'All';
      case 'ca':
      default:
        return 'Tots';
    }
  }

  String get filterBolets {
    switch (languageCode) {
      case 'es':
        return 'Setas';
      case 'en':
        return 'Mushrooms';
      case 'ca':
      default:
        return 'Bolets';
    }
  }

  String get filterArbres {
    switch (languageCode) {
      case 'es':
        return 'Árboles';
      case 'en':
        return 'Trees';
      case 'ca':
      default:
        return 'Arbres';
    }
  }

  String get filterEdibles {
    switch (languageCode) {
      case 'es':
        return 'Comestibles';
      case 'en':
        return 'Edible';
      case 'ca':
      default:
        return 'Comestibles';
    }
  }

  String get filterToxics {
    switch (languageCode) {
      case 'es':
        return 'Tóxicos/mortales';
      case 'en':
        return 'Toxic/deadly';
      case 'ca':
      default:
        return 'Tòxics/mortals';
    }
  }

  String get filterTreePartners {
    switch (languageCode) {
      case 'es':
        return 'Árboles socios';
      case 'en':
        return 'Partner trees';
      case 'ca':
      default:
        return 'Arbres socis';
    }
  }

  String discoveredRatio(int discovered, int total) {
    switch (languageCode) {
      case 'es':
        return '$discovered/$total descubiertos';
      case 'en':
        return '$discovered/$total discovered';
      case 'ca':
      default:
        return '$discovered/$total descoberts';
    }
  }

  String get notDiscoveredYet {
    switch (languageCode) {
      case 'es':
        return '¡Aún no has descubierto esta especie!';
      case 'en':
        return 'You haven\'t discovered this species yet!';
      case 'ca':
      default:
        return 'Encara no has descobert aquesta espècie!';
    }
  }

  // --- Journal & Map View ---
  String get journalTitle {
    switch (languageCode) {
      case 'es':
        return 'Mi Diario';
      case 'en':
        return 'My Journal';
      case 'ca':
      default:
        return 'El Meu Diari';
    }
  }

  String get journalEmptyPrompt {
    switch (languageCode) {
      case 'es':
        return 'Aún no tienes ningún avistamiento. ¡Escanea tu primera seta o árbol!';
      case 'en':
        return 'No sightings yet. Scan your first mushroom or tree!';
      case 'ca':
      default:
        return 'Encara no tens cap avistament. Escaneja el teu primer bolet o arbre!';
    }
  }

  String get journalNoGpsBadge {
    switch (languageCode) {
      case 'es':
        return 'sin GPS';
      case 'en':
        return 'without GPS';
      case 'ca':
      default:
        return 'sense GPS';
    }
  }

  String get viewDetail {
    switch (languageCode) {
      case 'es':
        return 'Ver Detalle';
      case 'en':
        return 'View Detail';
      case 'ca':
      default:
        return 'Veure Detall';
    }
  }

  String findingItemOfTotal(int current, int total) {
    switch (languageCode) {
      case 'es':
        return 'Hallazgo $current de $total en este punto';
      case 'en':
        return 'Finding $current of $total at this point';
      case 'ca':
      default:
        return 'Troballa $current de $total en aquest punt';
    }
  }

  String get sightingDetailTitle {
    switch (languageCode) {
      case 'es':
        return 'DETALLE DEL AVISTAMIENTO';
      case 'en':
        return 'SIGHTING DETAILS';
      case 'ca':
      default:
        return 'DETALL DE L\'AVISTAMENT';
    }
  }

  String get categoryBolet {
    switch (languageCode) {
      case 'es':
        return 'SETA';
      case 'en':
        return 'MUSHROOM';
      case 'ca':
      default:
        return 'BOLET';
    }
  }

  String get categoryArbre {
    switch (languageCode) {
      case 'es':
        return 'ÁRBOL';
      case 'en':
        return 'TREE';
      case 'ca':
      default:
        return 'ARBRE';
    }
  }

  // --- Safety & Disclaimer ---
  String get dangerousLookalikeAlert {
    switch (languageCode) {
      case 'es':
        return 'ALERTA DE CONFUSIÓN PELIGROSA';
      case 'en':
        return 'DANGEROUS LOOKALIKE ALERT';
      case 'ca':
      default:
        return 'ALERTA DE CONFUSIÓ PERILLOSA';
    }
  }

  String get compareWithTwin {
    switch (languageCode) {
      case 'es':
        return 'Comparar con el gemelo tóxico';
      case 'en':
        return 'Compare with toxic twin';
      case 'ca':
      default:
        return 'Comparar amb el bessó tòxic';
    }
  }

  String get safeIdentification {
    switch (languageCode) {
      case 'es':
        return 'Identificación segura';
      case 'en':
        return 'Safe identification';
      case 'ca':
      default:
        return 'Identificació segura';
    }
  }

  String get possibleConfusion {
    switch (languageCode) {
      case 'es':
        return 'Posible confusión';
      case 'en':
        return 'Possible confusion';
      case 'ca':
      default:
        return 'Confusió possible';
    }
  }

  String get uncertainIdentification {
    switch (languageCode) {
      case 'es':
        return 'Identificación incierta';
      case 'en':
        return 'Uncertain identification';
      case 'ca':
      default:
        return 'Identificació incerta';
    }
  }

  // --- Dual-Dex Sections & Filters ---
  String get sectionBolets {
    switch (languageCode) {
      case 'es':
        return 'Setas';
      case 'en':
        return 'Mushrooms';
      case 'ca':
      default:
        return 'Bolets';
    }
  }

  String get sectionArbres {
    switch (languageCode) {
      case 'es':
        return 'Árboles';
      case 'en':
        return 'Trees';
      case 'ca':
      default:
        return 'Arbres';
    }
  }

  String get filterNeedle {
    switch (languageCode) {
      case 'es':
        return 'Aguja';
      case 'en':
        return 'Needle';
      case 'ca':
      default:
        return 'Agulla';
    }
  }

  String get filterDeciduous {
    switch (languageCode) {
      case 'es':
        return 'Caduca';
      case 'en':
        return 'Deciduous';
      case 'ca':
      default:
        return 'Caduca';
    }
  }

  String get filterEvergreen {
    switch (languageCode) {
      case 'es':
        return 'Perenne';
      case 'en':
        return 'Evergreen';
      case 'ca':
      default:
        return 'Perenne';
    }
  }

  String identifiedTreesRatio(int visited, int total) {
    switch (languageCode) {
      case 'es':
        return '$visited/$total identificados';
      case 'en':
        return '$visited/$total identified';
      case 'ca':
      default:
        return '$visited/$total identificats';
    }
  }

  String get myBadges {
    switch (languageCode) {
      case 'es':
        return 'Mis Insignias';
      case 'en':
        return 'My Badges';
      case 'ca':
      default:
        return 'Les Meves Insígnies';
    }
  }

  // --- Forager Level & Gamification ---
  String get foragerLevelHeader {
    switch (languageCode) {
      case 'es':
        return 'Nivel de Recolector';
      case 'en':
        return 'Forager Level';
      case 'ca':
      default:
        return 'Nivell de Boletaire';
    }
  }

  String levelBadge(int level) => 'LVL $level';

  String levelWithTitle(int level, String title) {
    switch (languageCode) {
      case 'es':
        return 'Nivel $level: $title';
      case 'en':
        return 'Level $level: $title';
      case 'ca':
      default:
        return 'Nivell $level: $title';
    }
  }

  String xpPoints(int xp) => '$xp XP';

  String xpProgressFraction(int current, int target) => '$current / $target XP';

  String xpNeededForNext(int needed, int nextLevel) {
    switch (languageCode) {
      case 'es':
        return '$needed XP para el Nivel $nextLevel';
      case 'en':
        return '$needed XP to Level $nextLevel';
      case 'ca':
      default:
        return '$needed XP per al Nivell $nextLevel';
    }
  }

  String get maxLevelAchieved {
    switch (languageCode) {
      case 'es':
        return '¡Nivel máximo alcanzado! Maestro absoluto del bosque.';
      case 'en':
        return 'Max level reached! Absolute Master of the Forest.';
      case 'ca':
      default:
        return 'Nivell màxim assolit! Mestre absolut del bosc.';
    }
  }

  String get xpBreakdownTitle {
    switch (languageCode) {
      case 'es':
        return 'Fuentes de Experiencia';
      case 'en':
        return 'Experience Sources';
      case 'ca':
      default:
        return "Fonts d'Experiència";
    }
  }

  String get xpBreakdownMushrooms {
    switch (languageCode) {
      case 'es':
        return 'Setas catalogadas';
      case 'en':
        return 'Mushrooms cataloged';
      case 'ca':
      default:
        return 'Bolets catalogats';
    }
  }

  String get xpBreakdownTrees {
    switch (languageCode) {
      case 'es':
        return 'Árboles identificados';
      case 'en':
        return 'Trees identified';
      case 'ca':
      default:
        return 'Arbres identificats';
    }
  }

  String get xpBreakdownBadges {
    switch (languageCode) {
      case 'es':
        return 'Insignias conseguidas';
      case 'en':
        return 'Badges unlocked';
      case 'ca':
      default:
        return 'Insígnies assolides';
    }
  }

  String get xpBreakdownSightings {
    switch (languageCode) {
      case 'es':
        return 'Avistamientos en el diario';
      case 'en':
        return 'Journal sightings';
      case 'ca':
      default:
        return 'Avistaments al diari';
    }
  }

  String get ranksRoadmapTitle {
    switch (languageCode) {
      case 'es':
        return 'Escala de Rangos';
      case 'en':
        return 'Ranks Roadmap';
      case 'ca':
      default:
        return 'Escala de Rànquings';
    }
  }

  String get currentRankTag {
    switch (languageCode) {
      case 'es':
        return 'ACTUAL';
      case 'en':
        return 'CURRENT';
      case 'ca':
      default:
        return 'ACTUAL';
    }
  }

  // --- Edibilitat & Raresa ---
  String edibilityLabel(Edibilitat edibilitat) {
    switch (edibilitat) {
      case Edibilitat.excellent:
        switch (languageCode) {
          case 'es':
            return 'Excelente comestible';
          case 'en':
            return 'Excellent edible';
          case 'ca':
          default:
            return 'Comestible excel·lent';
        }
      case Edibilitat.comestible:
        switch (languageCode) {
          case 'es':
            return 'Comestible';
          case 'en':
            return 'Edible';
          case 'ca':
          default:
            return 'Comestible';
        }
      case Edibilitat.senseValor:
        switch (languageCode) {
          case 'es':
            return 'Sin valor culinario';
          case 'en':
            return 'Inedible';
          case 'ca':
          default:
            return 'Sense valor culinari';
        }
      case Edibilitat.toxic:
        switch (languageCode) {
          case 'es':
            return 'Tóxico';
          case 'en':
            return 'Toxic';
          case 'ca':
          default:
            return 'Tòxic';
        }
      case Edibilitat.mortal:
        switch (languageCode) {
          case 'es':
            return 'Mortal';
          case 'en':
            return 'Deadly';
          case 'ca':
          default:
            return 'Mortal';
        }
    }
  }

  String rarityLabel(RaritatTier tier) {
    switch (tier) {
      case RaritatTier.comu:
        switch (languageCode) {
          case 'es':
            return 'Común';
          case 'en':
            return 'Common';
          case 'ca':
          default:
            return 'Comú';
        }
      case RaritatTier.pocFrequent:
        switch (languageCode) {
          case 'es':
            return 'Poco frecuente';
          case 'en':
            return 'Uncommon';
          case 'ca':
          default:
            return 'Poc freqüent';
        }
      case RaritatTier.rar:
        switch (languageCode) {
          case 'es':
            return 'Raro';
          case 'en':
            return 'Rare';
          case 'ca':
          default:
            return 'Rar';
        }
      case RaritatTier.moltRar:
        switch (languageCode) {
          case 'es':
            return 'Muy raro';
          case 'en':
            return 'Very rare';
          case 'ca':
          default:
            return 'Molt rar';
        }
      case RaritatTier.llegendari:
        switch (languageCode) {
          case 'es':
            return 'Legendario';
          case 'en':
            return 'Legendary';
          case 'ca':
          default:
            return 'Llegendari';
        }
    }
  }

  // --- Journal & Map View ---
  String get journalAdventureDiary {
    switch (languageCode) {
      case 'es':
        return 'DIARIO DE AVENTURAS';
      case 'en':
        return 'ADVENTURE JOURNAL';
      case 'ca':
      default:
        return 'DIARI D\'AVENTURES';
    }
  }

  String get journalTabList {
    switch (languageCode) {
      case 'es':
        return 'Lista';
      case 'en':
        return 'List';
      case 'ca':
      default:
        return 'Llista';
    }
  }

  String get journalTabMap {
    switch (languageCode) {
      case 'es':
        return 'Mapa';
      case 'en':
        return 'Map';
      case 'ca':
      default:
        return 'Mapa';
    }
  }

  String get mapNoGpsTitle {
    switch (languageCode) {
      case 'es':
        return 'SIN COORDENADAS GPS';
      case 'en':
        return 'NO GPS COORDINATES';
      case 'ca':
      default:
        return 'SENSE COORDENADES GPS';
    }
  }

  String get mapNoGpsMessage {
    switch (languageCode) {
      case 'es':
        return 'Avistamientos registrados, pero ninguno con datos GPS para mostrar en el mapa.';
      case 'en':
        return 'Sightings recorded, but none with GPS coordinates to plot on the map.';
      case 'ca':
      default:
        return 'Avistaments registrats, però cap amb dades GPS per dibuixar al mapa.';
    }
  }

  String get mapEmptyPrompt {
    switch (languageCode) {
      case 'es':
        return 'Aún no tienes ningún avistamiento registrado en tu diario.';
      case 'en':
        return 'No sightings recorded in your journal yet.';
      case 'ca':
      default:
        return 'Encara no tens cap avistament registrat al teu diari.';
    }
  }

  String get mapResetZoom {
    switch (languageCode) {
      case 'es':
        return 'Centrar Mapa';
      case 'en':
        return 'Center Map';
      case 'ca':
      default:
        return 'Centrar Mapa';
    }
  }

  String get unknownSpecies {
    switch (languageCode) {
      case 'es':
        return 'Desconocido';
      case 'en':
        return 'Unknown';
      case 'ca':
      default:
        return 'Desconegut';
    }
  }

  // --- Sighting Detail Sheet ---
  String get fieldCapture {
    switch (languageCode) {
      case 'es':
        return 'Captura de Campo';
      case 'en':
        return 'Field Capture';
      case 'ca':
      default:
        return 'Captura de Camp';
    }
  }

  String get neuralCoincidence {
    switch (languageCode) {
      case 'es':
        return 'Coincidencia Neural IA';
      case 'en':
        return 'Neural AI Match';
      case 'ca':
      default:
        return 'Coincidència Neural AI';
    }
  }

  String get highConfidenceNote {
    switch (languageCode) {
      case 'es':
        return '✅ Alta concordancia morfológica con los patrones del modelo (Series 011).';
      case 'en':
        return '✅ High morphological match with model patterns (Series 011).';
      case 'ca':
      default:
        return '✅ Alta concordança morfològica amb els patrons del model (Series 011).';
    }
  }

  String get moderateConfidenceNote {
    switch (languageCode) {
      case 'es':
        return '⚠️ Coincidencia moderada. Verifica siempre el himenio (láminas/tubos) y la base del pie.';
      case 'en':
        return '⚠️ Moderate match. Always inspect the hymenium (gills/pores) and stem base.';
      case 'ca':
      default:
        return '⚠️ Coincidència moderada. Verifica sempre l\'himeni (làmines/tubs) i la base del peu.';
    }
  }

  String get viewFullBoletCard {
    switch (languageCode) {
      case 'es':
        return 'Ver ficha completa en la Boscdex';
      case 'en':
        return 'View full entry in Boscdex';
      case 'ca':
      default:
        return 'Veure fitxa completa a la Boscdex';
    }
  }

  String get viewFullTreeCard {
    switch (languageCode) {
      case 'es':
        return 'Ver ficha completa del árbol';
      case 'en':
        return 'View full tree profile';
      case 'ca':
      default:
        return 'Veure fitxa completa de l\'arbre';
    }
  }

  String get expeditionData {
    switch (languageCode) {
      case 'es':
        return 'Datos de la expedición';
      case 'en':
        return 'Expedition details';
      case 'ca':
      default:
        return 'Dades de l\'expedició';
    }
  }

  String altitudeMeters(int alt) {
    switch (languageCode) {
      case 'es':
        return '$alt m sobre el nivel del mar';
      case 'en':
        return '$alt m above sea level';
      case 'ca':
      default:
        return '$alt m sobre el nivell del mar';
    }
  }

  String get gpsCoordinates {
    switch (languageCode) {
      case 'es':
        return 'Coordenadas GPS';
      case 'en':
        return 'GPS Coordinates';
      case 'ca':
      default:
        return 'Coordenades GPS';
    }
  }

  String get fieldNotes {
    switch (languageCode) {
      case 'es':
        return 'Notas de campo';
      case 'en':
        return 'Field notes';
      case 'ca':
      default:
        return 'Notes de camp';
    }
  }

  String get share {
    switch (languageCode) {
      case 'es':
        return 'Compartir';
      case 'en':
        return 'Share';
      case 'ca':
      default:
        return 'Compartir';
    }
  }

  String get downloadPhoto {
    switch (languageCode) {
      case 'es':
        return 'Descargar Foto';
      case 'en':
        return 'Download Photo';
      case 'ca':
      default:
        return 'Descarregar Foto';
    }
  }

  String get deleteSighting {
    switch (languageCode) {
      case 'es':
        return 'Eliminar avistamiento';
      case 'en':
        return 'Delete sighting';
      case 'ca':
      default:
        return 'Eliminar avistament';
    }
  }

  String get confirmDeletionTitle {
    switch (languageCode) {
      case 'es':
        return '¿Eliminar avistamiento?';
      case 'en':
        return 'Delete sighting?';
      case 'ca':
      default:
        return 'Eliminar avistament?';
    }
  }

  String get confirmDeletionMessage {
    switch (languageCode) {
      case 'es':
        return '¿Seguro que deseas eliminar este avistamiento permanentemente?';
      case 'en':
        return 'Are you sure you want to permanently delete this sighting?';
      case 'ca':
      default:
        return 'Estàs segur que vols eliminar aquest avistament permanentment?';
    }
  }

  String get cancel {
    switch (languageCode) {
      case 'es':
        return 'Cancelar';
      case 'en':
        return 'Cancel';
      case 'ca':
      default:
        return 'Cancel·lar';
    }
  }

  String get delete {
    switch (languageCode) {
      case 'es':
        return 'Eliminar';
      case 'en':
        return 'Delete';
      case 'ca':
      default:
        return 'Eliminar';
    }
  }

  String get photoSavedSnackbar {
    switch (languageCode) {
      case 'es':
        return 'Foto guardada en la galería';
      case 'en':
        return 'Photo saved to gallery';
      case 'ca':
      default:
        return 'Foto desada a la galeria';
    }
  }

  String get photoSaveErrorSnackbar {
    switch (languageCode) {
      case 'es':
        return 'Error al guardar la imagen';
      case 'en':
        return 'Error saving image';
      case 'ca':
      default:
        return 'Error en desar la imatge';
    }
  }

  // --- Scan & Camera Screen ---
  String get cameraPermissionRequired {
    switch (languageCode) {
      case 'es':
        return 'Permiso de cámara necesario';
      case 'en':
        return 'Camera permission required';
      case 'ca':
      default:
        return 'Permís de càmera necessari';
    }
  }

  String get cameraPermissionDeniedMessage {
    switch (languageCode) {
      case 'es':
        return 'Boscdex necesita la cámara para identificar setas en el bosque.';
      case 'en':
        return 'Boscdex needs the camera to identify mushrooms in the forest.';
      case 'ca':
      default:
        return 'Boscdex necessita la càmera per identificar bolets al bosc.';
    }
  }

  String get cameraPermissionPermanentMessage {
    switch (languageCode) {
      case 'es':
        return 'Activa el permiso desde los Ajustes de tu iPhone para escanear.';
      case 'en':
        return 'Enable permission in iPhone Settings to scan.';
      case 'ca':
      default:
        return 'Activa el permís des dels Paràmetres del teu iPhone per escanejar.';
    }
  }

  String get openSettings {
    switch (languageCode) {
      case 'es':
        return 'Abrir Ajustes';
      case 'en':
        return 'Open Settings';
      case 'ca':
      default:
        return 'Obrir Paràmetres';
    }
  }

  String get requestPermission {
    switch (languageCode) {
      case 'es':
        return 'Pedir permiso';
      case 'en':
        return 'Request permission';
      case 'ca':
      default:
        return 'Demanar permís';
    }
  }

  String get noCameraDetected {
    switch (languageCode) {
      case 'es':
        return 'No se ha detectado la cámara';
      case 'en':
        return 'No camera detected';
      case 'ca':
      default:
        return 'No s\'ha detectat la càmera';
    }
  }

  String get noCameraPrompt {
    switch (languageCode) {
      case 'es':
        return 'Usa la Galería o pulsa el Disparador para probar la identificación.';
      case 'en':
        return 'Use Gallery or tap Shutter to test identification.';
      case 'ca':
      default:
        return 'Fes servir la Galeria o prem Disparador per provar la identificació.';
    }
  }

  String get identifyingProgress {
    switch (languageCode) {
      case 'es':
        return 'ANALIZANDO CON EDGE-AI...';
      case 'en':
        return 'ANALYZING WITH EDGE-AI...';
      case 'ca':
      default:
        return 'ANALITZANT AMB EDGE-AI...';
    }
  }

  String get startingCamera {
    switch (languageCode) {
      case 'es':
        return 'Iniciando cámara...';
      case 'en':
        return 'Starting camera...';
      case 'ca':
      default:
        return 'Iniciant càmera...';
    }
  }

  String get openPhotoGallery {
    switch (languageCode) {
      case 'es':
        return 'Abrir galería de fotos';
      case 'en':
        return 'Open photo gallery';
      case 'ca':
      default:
        return 'Obrir galeria de fotos';
    }
  }

  String errorCapturingPhoto(String error) {
    switch (languageCode) {
      case 'es':
        return 'Error al capturar la foto: $error';
      case 'en':
        return 'Error capturing photo: $error';
      case 'ca':
      default:
        return 'Error en capturar la foto: $error';
    }
  }

  String errorLoadingGalleryImage(String error) {
    switch (languageCode) {
      case 'es':
        return 'Error al cargar la imagen de la galería: $error';
      case 'en':
        return 'Error loading gallery image: $error';
      case 'ca':
      default:
        return 'Error en carregar la imatge de la galeria: $error';
    }
  }

  String errorDuringAnalysis(String error) {
    switch (languageCode) {
      case 'es':
        return 'Error durante el análisis: $error';
      case 'en':
        return 'Error during analysis: $error';
      case 'ca':
      default:
        return 'Error durant l\'anàlisi: $error';
    }
  }

  // --- Classification Result Sheets ---
  String get registerToJournal {
    switch (languageCode) {
      case 'es':
        return 'Registrar hallazgo en el Diario';
      case 'en':
        return 'Save sighting to Journal';
      case 'ca':
      default:
        return 'Registrar troballa al Diari';
    }
  }

  String get registerToBoscdex {
    switch (languageCode) {
      case 'es':
        return 'Registrar en mi Boscdex';
      case 'en':
        return 'Save to my Boscdex';
      case 'ca':
      default:
        return 'Registrar a la meva Boscdex';
    }
  }

  String get sightingRegistered {
    switch (languageCode) {
      case 'es':
        return 'Hallazgo registrado en el Diario';
      case 'en':
        return 'Sighting saved to Journal';
      case 'ca':
      default:
        return 'Troballa registrada al Diari';
    }
  }

  String get otherPossibleSpecies {
    switch (languageCode) {
      case 'es':
        return 'Otras posibles especies:';
      case 'en':
        return 'Other possible species:';
      case 'ca':
      default:
        return 'Altres possibles espècies:';
    }
  }

  String get gpsLocationCaptured {
    switch (languageCode) {
      case 'es':
        return 'Ubicación GPS capturada';
      case 'en':
        return 'GPS location captured';
      case 'ca':
      default:
        return 'Ubicació GPS capturada';
    }
  }

  // --- Specimen Detail Screens ---
  String get notFoundTitle {
    switch (languageCode) {
      case 'es':
        return 'No encontrado';
      case 'en':
        return 'Not found';
      case 'ca':
      default:
        return 'No trobat';
    }
  }

  String yourCaptures(int count) {
    switch (languageCode) {
      case 'es':
        return 'Tus Capturas ($count)';
      case 'en':
        return 'Your Captures ($count)';
      case 'ca':
      default:
        return 'Les Teves Captures ($count)';
    }
  }

  String get newPhoto {
    switch (languageCode) {
      case 'es':
        return 'Nueva foto';
      case 'en':
        return 'New photo';
      case 'ca':
      default:
        return 'Nova foto';
    }
  }

  String get seasonAndHabitat {
    switch (languageCode) {
      case 'es':
        return 'Temporada y Hábitat';
      case 'en':
        return 'Season & Habitat';
      case 'ca':
      default:
        return 'Temporada i Hàbitat';
    }
  }

  String get associatedTrees {
    switch (languageCode) {
      case 'es':
        return 'Árboles asociados';
      case 'en':
        return 'Associated trees';
      case 'ca':
      default:
        return 'Arbres associats';
    }
  }

  String get associatedBolets {
    switch (languageCode) {
      case 'es':
        return 'Setas asociadas';
      case 'en':
        return 'Associated mushrooms';
      case 'ca':
      default:
        return 'Bolets associats';
    }
  }

  String get morphologyTitle {
    switch (languageCode) {
      case 'es':
        return 'Morfología de la seta';
      case 'en':
        return 'Mushroom morphology';
      case 'ca':
      default:
        return 'Morfologia del bolet';
    }
  }

  String get safetyTraitsTitle {
    switch (languageCode) {
      case 'es':
        return 'Rasgos distintivos de seguridad';
      case 'en':
        return 'Safety identification traits';
      case 'ca':
      default:
        return 'Trets distintius de seguretat';
    }
  }

  String get toxicLookalikesTitle {
    switch (languageCode) {
      case 'es':
        return 'Riesgo de confusión tóxica';
      case 'en':
        return 'Risk of toxic lookalikes';
      case 'ca':
      default:
        return 'Risc de confusió tòxica';
    }
  }

  String get attentionLookalikePrefix {
    switch (languageCode) {
      case 'es':
        return 'ATENCIÓN: Se puede confundir con';
      case 'en':
        return 'WARNING: Can be confused with';
      case 'ca':
      default:
        return 'ATENCIÓ: Es pot confondre amb';
    }
  }

  // --- Disclaimer Screen ---
  String get legalNoticeTitle {
    switch (languageCode) {
      case 'es':
        return 'Aviso Legal Importante';
      case 'en':
        return 'Important Legal Notice';
      case 'ca':
      default:
        return 'Avís Legal Important';
    }
  }

  String get legalNoticeBody {
    switch (languageCode) {
      case 'es':
        return 'Esta aplicación es una guía orientativa y educativa. La inteligencia artificial puede cometer errores. Nunca consumas ninguna seta silvestre sin la validación de un experto micólogo humano. El uso de esta aplicación no sustituye el conocimiento experto. El equipo de Boscdex no se hace responsable de ninguna intoxicación o daño derivado del uso incorrecto de la información proporcionada.';
      case 'en':
        return 'This application is an educational and advisory guide. Artificial intelligence can make mistakes. Never consume wild mushrooms without validation from a human mycological expert. Using this app does not replace expert knowledge. The Boscdex team is not liable for any poisoning or harm arising from the improper use of the provided information.';
      case 'ca':
      default:
        return 'Aquesta aplicació és una guia orientativa i educativa. La intel·ligència artificial pot cometre errors. Mai consumeixis cap bolet sense la validació d\'un expert micòleg humà. L\'ús d\'aquesta aplicació no substitueix el coneixement expert. L\'equip de Boscdex no es fa responsable de cap intoxicació o dany derivat de l\'ús incorrecte de la informació proporcionada.';
    }
  }

  String get legalNoticeAcceptCheckbox {
    switch (languageCode) {
      case 'es':
        return 'He leído y acepto las condiciones de avisos de seguridad';
      case 'en':
        return 'I have read and accept the safety notice conditions';
      case 'ca':
      default:
        return 'He llegit i accepto les condicions d\'avisos de seguretat';
    }
  }

  String get legalNoticeStartButton {
    switch (languageCode) {
      case 'es':
        return 'Empezar a explorar';
      case 'en':
        return 'Start exploring';
      case 'ca':
      default:
        return 'Començar a explorar';
    }
  }

  // --- Badges & Trophies Dialog ---
  String get badgeUnlocked {
    switch (languageCode) {
      case 'es':
        return 'Desbloqueado';
      case 'en':
        return 'Unlocked';
      case 'ca':
      default:
        return 'Desbloquejat';
    }
  }

  String badgeProgress(int current, int target) {
    switch (languageCode) {
      case 'es':
        return 'Progreso: $current de $target';
      case 'en':
        return 'Progress: $current of $target';
      case 'ca':
      default:
        return 'Progrés: $current de $target';
    }
  }

  String badgeName(String id) {
    switch (id) {
      case 'primer_pas_al_bosc':
        switch (languageCode) {
          case 'es':
            return 'Primer paso en el bosque';
          case 'en':
            return 'First Step in the Forest';
          case 'ca':
          default:
            return 'Primer pas al bosc';
        }
      case 'cacador_de_rovellons':
        switch (languageCode) {
          case 'es':
            return 'Cazador de níscalos';
          case 'en':
            return 'Milk Cap Hunter';
          case 'ca':
          default:
            return 'Caçador de rovellons';
        }
      case 'micoleg_prudent':
        switch (languageCode) {
          case 'es':
            return 'Micólogo prudente';
          case 'en':
            return 'Prudent Mycologist';
          case 'ca':
          default:
            return 'Micòleg prudent';
        }
      case 'alianca_silvestre':
        switch (languageCode) {
          case 'es':
            return 'Alianza silvestre';
          case 'en':
            return 'Wild Alliance';
          case 'ca':
          default:
            return 'Aliança silvestre';
        }
      case 'cistell_de_tardor':
        switch (languageCode) {
          case 'es':
            return 'Cesta de otoño';
          case 'en':
            return 'Autumn Basket';
          case 'ca':
          default:
            return 'Cistell de tardor';
        }
      case 'mestre_boletaire':
        switch (languageCode) {
          case 'es':
            return 'Maestro buscador';
          case 'en':
            return 'Master Forager';
          case 'ca':
          default:
            return 'Mestre boletaire';
        }
      default:
        return id;
    }
  }

  String badgeDescription(String id) {
    switch (id) {
      case 'primer_pas_al_bosc':
        switch (languageCode) {
          case 'es':
            return 'Registra tu primer avistamiento en el diario.';
          case 'en':
            return 'Log your first sighting in the journal.';
          case 'ca':
          default:
            return 'Registra el teu primer avistament al diari.';
        }
      case 'cacador_de_rovellons':
        switch (languageCode) {
          case 'es':
            return 'Encuentra e identifica tanto el níscalo común como el de sangre.';
          case 'en':
            return 'Find and identify both Saffron and Bloody Milk Caps.';
          case 'ca':
          default:
            return 'Troba i identifica tant el rovelló com el pinetell de sang.';
        }
      case 'micoleg_prudent':
        switch (languageCode) {
          case 'es':
            return 'Consulta 5 advertencias de confusión tóxica.';
          case 'en':
            return 'Check 5 toxic lookalike comparison warnings.';
          case 'ca':
          default:
            return 'Consulta 5 alertes de confusió tòxica.';
        }
      case 'alianca_silvestre':
        switch (languageCode) {
          case 'es':
            return 'Descubre una seta y visita su árbol indicador asociado.';
          case 'en':
            return 'Discover a mushroom and visit its associated indicator tree.';
          case 'ca':
          default:
            return 'Descobreix un bolet i visita el seu arbre soci associat.';
        }
      case 'cistell_de_tardor':
        switch (languageCode) {
          case 'es':
            return 'Descubre 15 especies diferentes en la Boscdex.';
          case 'en':
            return 'Discover 15 distinct species in the Boscdex.';
          case 'ca':
          default:
            return 'Descobreix 15 espècies diferents a la Boscdex.';
        }
      case 'mestre_boletaire':
        switch (languageCode) {
          case 'es':
            return 'Completa el catálogo descubriendo 50 especies.';
          case 'en':
            return 'Complete the catalog by discovering 50 species.';
          case 'ca':
          default:
            return 'Completa el catàleg descobrint 50 espècies.';
        }
      default:
        return '';
    }
  }

  String get badgeSubtitle {
    switch (languageCode) {
      case 'es':
        return 'Hitos de colección y reconocimiento de campo del buscador.';
      case 'en':
        return 'Collection milestones and field achievements for foragers.';
      case 'ca':
      default:
        return 'Fites de col·lecció i reconeixement de camp del boletaire.';
    }
  }

  String get dangerMortalAlertTitle {
    switch (languageCode) {
      case 'es':
        return 'ATENCIÓN: ESPECIE MORTAL';
      case 'en':
        return 'WARNING: DEADLY SPECIES';
      case 'ca':
      default:
        return 'ATENCIÓ: ESPÈCIE MORTAL';
    }
  }

  String get dangerToxicAlertTitle {
    switch (languageCode) {
      case 'es':
        return 'ATENCIÓN: ESPECIE TÓXICA';
      case 'en':
        return 'WARNING: TOXIC SPECIES';
      case 'ca':
      default:
        return 'ATENCIÓ: ESPÈCIE TÒXICA';
    }
  }

  String get dangerAlertDescription {
    switch (languageCode) {
      case 'es':
        return 'Esta seta es venenosa o mortal. No la consumas nunca.';
      case 'en':
        return 'This mushroom is poisonous or deadly. Never consume it.';
      case 'ca':
      default:
        return 'Aquest bolet és verinós o mortal. No el consumeixis mai.';
    }
  }

  String get lowConfidenceWarning {
    switch (languageCode) {
      case 'es':
        return 'No se puede identificar con certeza. Consulta a un experto micólogo antes de consumir.';
      case 'en':
        return 'Cannot be identified with certainty. Consult an expert mycologist before consuming.';
      case 'ca':
      default:
        return 'No es pot identificar amb certesa. Consulta un micòleg humà abans de consumir.';
    }
  }

  String get searchingGpsSignal {
    switch (languageCode) {
      case 'es':
        return 'Buscando señal GPS...';
      case 'en':
        return 'Searching GPS signal...';
      case 'ca':
      default:
        return 'Cercant senyal GPS...';
    }
  }

  String get savingProgress {
    switch (languageCode) {
      case 'es':
        return 'Registrando...';
      case 'en':
        return 'Saving...';
      case 'ca':
      default:
        return 'Registrant...';
    }
  }

  String get savingTreeProgress {
    switch (languageCode) {
      case 'es':
        return 'Registrando hallazgo...';
      case 'en':
        return 'Saving sighting...';
      case 'ca':
      default:
        return 'Registrant troballa...';
    }
  }

  String get analysisResult {
    switch (languageCode) {
      case 'es':
        return 'Resultado del análisis';
      case 'en':
        return 'Analysis Result';
      case 'ca':
      default:
        return 'Resultat de l\'anàlisi';
    }
  }

  String get treeAnalysisResult {
    switch (languageCode) {
      case 'es':
        return 'Resultado del árbol';
      case 'en':
        return 'Tree Result';
      case 'ca':
      default:
        return 'Resultat d\'arbre';
    }
  }

  String matchConfidence(int pct) {
    switch (languageCode) {
      case 'es':
        return '$pct% coincidencia';
      case 'en':
        return '$pct% match';
      case 'ca':
      default:
        return '$pct% coincidència';
    }
  }

  String get noClassificationResults {
    switch (languageCode) {
      case 'es':
        return 'No se han obtenido resultados de identificación.';
      case 'en':
        return 'No identification results obtained.';
      case 'ca':
      default:
        return 'No s\'han obtingut resultats d\'identificació.';
    }
  }

  String get noTreeClassificationResults {
    switch (languageCode) {
      case 'es':
        return 'No se han obtenido resultados de árbol.';
      case 'en':
        return 'No tree results obtained.';
      case 'ca':
      default:
        return 'No s\'han obtingut resultats d\'arbre.';
    }
  }

  String get newSightingSaved {
    switch (languageCode) {
      case 'es':
        return '¡Nuevo avistamiento registrado en tu diario!';
      case 'en':
        return 'New sighting recorded in your journal!';
      case 'ca':
      default:
        return 'Nou avistament registrat al teu diari!';
    }
  }

  String get newBoletUnlocked {
    switch (languageCode) {
      case 'es':
        return '🎉 ¡Nueva seta desbloqueada en tu Boscdex!';
      case 'en':
        return '🎉 New mushroom unlocked in your Boscdex!';
      case 'ca':
      default:
        return '🎉 Nou bolet desbloquejat a la teva Boscdex!';
    }
  }

  String get newBadgeUnlockedBanner {
    switch (languageCode) {
      case 'es':
        return '🏆 ¡Enhorabuena! ¡Has desbloqueado una nueva insignia!';
      case 'en':
        return '🏆 Congratulations! You unlocked a new badge!';
      case 'ca':
      default:
        return '🏆 Enhorabona! Has desbloquejat una nova insígnia!';
    }
  }

  String treeSightingSaved(String treeName) {
    switch (languageCode) {
      case 'es':
        return '¡Hallazgo de $treeName registrado en el diario! 🌲';
      case 'en':
        return 'Sighting of $treeName recorded in your journal! 🌲';
      case 'ca':
      default:
        return 'Troballa de $treeName registrada al diari! 🌲';
    }
  }

  String get leafTrait {
    switch (languageCode) {
      case 'es':
        return 'Hoja';
      case 'en':
        return 'Leaf';
      case 'ca':
      default:
        return 'Fulla';
    }
  }

  String get barkTrait {
    switch (languageCode) {
      case 'es':
        return 'Corteza';
      case 'en':
        return 'Bark';
      case 'ca':
      default:
        return 'Escorça';
    }
  }

  String get soilTrait {
    switch (languageCode) {
      case 'es':
        return 'Suelo típico';
      case 'en':
        return 'Typical soil';
      case 'ca':
      default:
        return 'Sòl típic';
    }
  }

  String get searchMushroomsUnderTree {
    switch (languageCode) {
      case 'es':
        return 'Setas que puedes buscar bajo este árbol:';
      case 'en':
        return 'Mushrooms you can look for under this tree:';
      case 'ca':
      default:
        return 'Bolets que pots cercar sota aquest arbre:';
    }
  }

  String get noAssociatedBolets {
    switch (languageCode) {
      case 'es':
        return 'Sin setas asociadas catalogadas.';
      case 'en':
        return 'No cataloged partner mushrooms.';
      case 'ca':
      default:
        return 'Sense bolets associats catalogats.';
    }
  }

  String associatedBoletsCount(int count) {
    switch (languageCode) {
      case 'es':
        return '$count setas socias';
      case 'en':
        return '$count partner mushrooms';
      case 'ca':
      default:
        return '$count bolets socis';
    }
  }

  String get unregisteredSpecies {
    switch (languageCode) {
      case 'es':
        return 'Especie por catalogar';
      case 'en':
        return 'Species to catalog';
      case 'ca':
      default:
        return 'Espècie per catalogar';
    }
  }

  String get notDiscoveredBadge {
    switch (languageCode) {
      case 'es':
        return 'No descubierto';
      case 'en':
        return 'Undiscovered';
      case 'ca':
      default:
        return 'No descobert';
    }
  }

  String get edibilityUnknown {
    switch (languageCode) {
      case 'es':
        return 'Comestibilidad: ???';
      case 'en':
        return 'Edibility: ???';
      case 'ca':
      default:
        return 'Comestibilitat: ???';
    }
  }

  String get habitatAndDistribution {
    switch (languageCode) {
      case 'es':
        return 'Hábitat y Distribución';
      case 'en':
        return 'Habitat & Distribution';
      case 'ca':
      default:
        return 'Hàbitat i Distribució';
    }
  }

  String get explorationClues {
    switch (languageCode) {
      case 'es':
        return 'Pistas de exploración para localizar esta seta en el bosque';
      case 'en':
        return 'Exploration clues to locate this mushroom in the forest';
      case 'ca':
      default:
        return 'Pistes d\'exploració per localitzar aquest bolet al bosc';
    }
  }

  String get mycorrhizalNotice {
    switch (languageCode) {
      case 'es':
        return 'Forma micorrizas con estas especies. Busca bosques donde abunden:';
      case 'en':
        return 'Forms mycorrhizae with these species. Search forests where they thrive:';
      case 'ca':
      default:
        return 'Forma micorrizes amb aquestes espècies. Cerca boscos on abundin:';
    }
  }

  String get fruitingAltitude {
    switch (languageCode) {
      case 'es':
        return 'Altitud de fructificación';
      case 'en':
        return 'Fruiting altitude';
      case 'ca':
      default:
        return 'Altitud de fructificació';
    }
  }

  String get lockedMorphologyTitle {
    switch (languageCode) {
      case 'es':
        return 'Claves Morfológicas Bloqueadas';
      case 'en':
        return 'Locked Morphological Keys';
      case 'ca':
      default:
        return 'Claus Morfològiques Bloquejades';
    }
  }

  String get lockedMorphologyDescription {
    switch (languageCode) {
      case 'es':
        return 'Las características anatómicas detalladas (sombrero, láminas, pie y látex) están protegidas. Escanea un ejemplar vivo en el bosque para desvelar las claves de identificación botánica.';
      case 'en':
        return 'Detailed anatomical traits (cap, gills, stem, and latex) are locked. Scan a live specimen in the forest to reveal botanical identification keys.';
      case 'ca':
      default:
        return 'Les característiques anatòmiques detallades (barret, làmines, peu i làtex) estan protegides. Escaneja un exemplar viu al bosc per desvelar les claus d\'identificació botànica.';
    }
  }

  String get readyForExpedition {
    switch (languageCode) {
      case 'es':
        return '¿Listo para la expedición?';
      case 'en':
        return 'Ready for the expedition?';
      case 'ca':
      default:
        return 'A punt per a l\'expedició?';
    }
  }

  String get expeditionPrompt {
    switch (languageCode) {
      case 'es':
        return 'Visita los bosques y altitudes indicados durante la temporada para encontrarlo y catalogarlo en tu Boscdex.';
      case 'en':
        return 'Visit the indicated forests and elevations during season to find and catalog it in your Boscdex.';
      case 'ca':
      default:
        return 'Visita els boscos i altituds indicats durant la temporada per trobar-lo i catalogar-lo a la teva Boscdex.';
    }
  }

  String get searchWithCamera {
    switch (languageCode) {
      case 'es':
        return 'Buscar con la cámara';
      case 'en':
        return 'Search with camera';
      case 'ca':
      default:
        return 'Cercar amb la càmera';
    }
  }

  String get noCapturesYet {
    switch (languageCode) {
      case 'es':
        return 'Sin capturas registradas';
      case 'en':
        return 'No captures logged';
      case 'ca':
      default:
        return 'Cap captura registrada';
    }
  }

  String get noCapturesPrompt {
    switch (languageCode) {
      case 'es':
        return '¡Encuentra esta seta en el bosque y escanéala para añadir tu foto!';
      case 'en':
        return 'Find this mushroom in the forest and scan it to add your photo!';
      case 'ca':
      default:
        return 'Troba aquest bolet al bosc i escaneja\'l per afegir la teva foto!';
    }
  }

  String get noTreeCapturesYet {
    switch (languageCode) {
      case 'es':
        return 'Sin fotografías de campo';
      case 'en':
        return 'No field photographs';
      case 'ca':
      default:
        return 'Sense fotografies de camp';
    }
  }

  String get noTreeCapturesPrompt {
    switch (languageCode) {
      case 'es':
        return 'Escanea este árbol en el bosque para añadirlo a tu diario.';
      case 'en':
        return 'Scan this tree in the forest to add it to your journal.';
      case 'ca':
      default:
        return 'Escaneja aquest arbre al bosc per afegir-lo al teu diari.';
    }
  }

  String get morphology {
    switch (languageCode) {
      case 'es':
        return 'Morfología';
      case 'en':
        return 'Morphology';
      case 'ca':
      default:
        return 'Morfologia';
    }
  }

  String get cap {
    switch (languageCode) {
      case 'es':
        return 'Sombrero';
      case 'en':
        return 'Cap';
      case 'ca':
      default:
        return 'Barret';
    }
  }

  String get gills {
    switch (languageCode) {
      case 'es':
        return 'Láminas';
      case 'en':
        return 'Gills';
      case 'ca':
      default:
        return 'Làmines';
    }
  }

  String get stem {
    switch (languageCode) {
      case 'es':
        return 'Pie';
      case 'en':
        return 'Stem';
      case 'ca':
      default:
        return 'Peu';
    }
  }

  String get latex {
    switch (languageCode) {
      case 'es':
        return 'Látex';
      case 'en':
        return 'Latex';
      case 'ca':
      default:
        return 'Làtex';
    }
  }

  String get season {
    switch (languageCode) {
      case 'es':
        return 'Temporada';
      case 'en':
        return 'Season';
      case 'ca':
      default:
        return 'Temporada';
    }
  }

  String fruitingSeasonSemantics(String months) {
    switch (languageCode) {
      case 'es':
        return 'Temporada de fructificación: $months';
      case 'en':
        return 'Fruiting season: $months';
      case 'ca':
      default:
        return 'Temporada de fructificació: $months';
    }
  }

  List<String> get monthNames {
    switch (languageCode) {
      case 'es':
        return const [
          'Ene',
          'Feb',
          'Mar',
          'Abr',
          'May',
          'Jun',
          'Jul',
          'Ago',
          'Sep',
          'Oct',
          'Nov',
          'Dic',
        ];
      case 'en':
        return const [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
      case 'ca':
      default:
        return const [
          'Gen',
          'Feb',
          'Mar',
          'Abr',
          'Mai',
          'Jun',
          'Jul',
          'Ag',
          'Set',
          'Oct',
          'Nov',
          'Des',
        ];
    }
  }

  String canBeConfusedWith(String species) {
    switch (languageCode) {
      case 'es':
        return 'Se puede confundir fácilmente con: $species';
      case 'en':
        return 'Can be easily confused with: $species';
      case 'ca':
      default:
        return 'Es pot confondre fàcilment amb: $species';
    }
  }

  String get tapToCompare {
    switch (languageCode) {
      case 'es':
        return 'Toca para comparar';
      case 'en':
        return 'Tap to compare';
      case 'ca':
      default:
        return 'Toca per comparar';
    }
  }

  String get notes {
    switch (languageCode) {
      case 'es':
        return 'Notas';
      case 'en':
        return 'Notes';
      case 'ca':
      default:
        return 'Notes';
    }
  }

  String get noBoletsFound {
    switch (languageCode) {
      case 'es':
        return 'Ninguna seta encontrada.';
      case 'en':
        return 'No mushrooms found.';
      case 'ca':
      default:
        return 'Cap bolet trobat.';
    }
  }

  String get noTreesFound {
    switch (languageCode) {
      case 'es':
        return 'Ningún árbol encontrado.';
      case 'en':
        return 'No trees found.';
      case 'ca':
      default:
        return 'Cap arbre trobat.';
    }
  }

  String get boletNotFoundMessage {
    switch (languageCode) {
      case 'es':
        return 'Esta seta no existe.';
      case 'en':
        return 'This mushroom does not exist.';
      case 'ca':
      default:
        return 'Aquest bolet no existeix.';
    }
  }

  String get arbreNotFoundMessage {
    switch (languageCode) {
      case 'es':
        return 'Este árbol no existe.';
      case 'en':
        return 'This tree does not exist.';
      case 'ca':
      default:
        return 'Aquest arbre no existeix.';
    }
  }

  String get back {
    switch (languageCode) {
      case 'es':
        return 'Atrás';
      case 'en':
        return 'Back';
      case 'ca':
      default:
        return 'Enrere';
    }
  }

  String elevationRange(int min, int max) {
    switch (languageCode) {
      case 'es':
        return '$min m - $max m sobre el nivel del mar';
      case 'en':
        return '$min m - $max m above sea level';
      case 'ca':
      default:
        return '$min m - $max m sobre el nivell del mar';
    }
  }

  String get distributionAreaPokedex {
    switch (languageCode) {
      case 'es':
        return 'Ubicación';
      case 'en':
        return 'Location';
      case 'ca':
      default:
        return 'Ubicació';
    }
  }

  String zonesCount(int active, int total) {
    switch (languageCode) {
      case 'es':
        return '$active / $total zonas';
      case 'en':
        return '$active / $total zones';
      case 'ca':
      default:
        return '$active / $total zones';
    }
  }

  String get habitualPresence {
    switch (languageCode) {
      case 'es':
        return 'Presencia habitual';
      case 'en':
        return 'Regular presence';
      case 'ca':
      default:
        return 'Presència habitual';
    }
  }

  String get noPresence {
    switch (languageCode) {
      case 'es':
        return 'Sin presencia';
      case 'en':
        return 'No presence';
      case 'ca':
      default:
        return 'Sense presència';
    }
  }

  String countiesLabel(String counties) {
    switch (languageCode) {
      case 'es':
        return 'Comarcas: $counties';
      case 'en':
        return 'Counties: $counties';
      case 'ca':
      default:
        return 'Comarques: $counties';
    }
  }

  String get noSeasonDefined {
    switch (languageCode) {
      case 'es':
        return 'Sin temporada definida';
      case 'en':
        return 'No defined season';
      case 'ca':
      default:
        return 'Sense temporada definida';
    }
  }

  String get focusCapAndGills {
    switch (languageCode) {
      case 'es':
        return 'Enfoca el sombrero y las láminas de la seta';
      case 'en':
        return 'Focus on the cap and gills of the mushroom';
      case 'ca':
      default:
        return 'Enfoca el barret i les làmines del bolet';
    }
  }

  String get focusBarkAndLeaves {
    switch (languageCode) {
      case 'es':
        return 'Enfoca la corteza o las hojas del árbol';
      case 'en':
        return 'Focus on the bark or leaves of the tree';
      case 'ca':
      default:
        return 'Enfoca l\'escorça o les fulles de l\'arbre';
    }
  }

  String get photoAndIdentifyBolet {
    switch (languageCode) {
      case 'es':
        return 'Fotografiar e identificar seta';
      case 'en':
        return 'Photograph and identify mushroom';
      case 'ca':
      default:
        return 'Fotografiar i identificar bolet';
    }
  }

  String get photoAndIdentifyTree {
    switch (languageCode) {
      case 'es':
        return 'Fotografiar e identificar árbol';
      case 'en':
        return 'Photograph and identify tree';
      case 'ca':
      default:
        return 'Fotografiar i identificar arbre';
    }
  }

  String get noPhotoToDownload {
    switch (languageCode) {
      case 'es':
        return 'No hay ningún archivo de foto para descargar.';
      case 'en':
        return 'No photo file to download.';
      case 'ca':
      default:
        return 'No hi ha cap fitxer de foto per descarregar.';
    }
  }

  String get noPhotoToShare {
    switch (languageCode) {
      case 'es':
        return 'No hay ningún archivo de foto para compartir.';
      case 'en':
        return 'No photo file to share.';
      case 'ca':
      default:
        return 'No hi ha cap fitxer de foto per compartir.';
    }
  }

  String get imageNotFoundOnDevice {
    switch (languageCode) {
      case 'es':
        return 'No se ha encontrado la imagen en el dispositivo.';
      case 'en':
        return 'Image not found on device.';
      case 'ca':
      default:
        return 'No s\'ha trobat la imatge al dispositiu.';
    }
  }

  String get shareMenuError {
    switch (languageCode) {
      case 'es':
        return 'No se pudo abrir el menú para compartir.';
      case 'en':
        return 'Could not open share menu.';
      case 'ca':
      default:
        return 'No s\'ha pogut obrir el menú per compartir.';
    }
  }

  String get sightingDeletedFromJournal {
    switch (languageCode) {
      case 'es':
        return 'Avistamiento eliminado de tu diario.';
      case 'en':
        return 'Sighting deleted from your journal.';
      case 'ca':
      default:
        return 'Avistament eliminat del teu diari.';
    }
  }

  String get imageLoadError {
    switch (languageCode) {
      case 'es':
        return 'Error al cargar la imagen';
      case 'en':
        return 'Error loading image';
      case 'ca':
      default:
        return 'Error en carregar la imatge';
    }
  }

  String get noAttachedPhoto {
    switch (languageCode) {
      case 'es':
        return 'Sin fotografía adjunta';
      case 'en':
        return 'No photo attached';
      case 'ca':
      default:
        return 'Sense fotografia adjunta';
    }
  }

  String get indicatorTreeLabel {
    switch (languageCode) {
      case 'es':
        return 'Árbol indicador';
      case 'en':
        return 'Indicator tree';
      case 'ca':
      default:
        return 'Arbre indicador';
    }
  }

  String get sightingIdentifiedWithAI {
    switch (languageCode) {
      case 'es':
        return 'Avistamiento identificado con Boscdex AI';
      case 'en':
        return 'Sighting identified with Boscdex AI';
      case 'ca':
      default:
        return 'Avistament identificat amb Boscdex AI';
    }
  }

  String shareSightingText(String name, String icon) {
    switch (languageCode) {
      case 'es':
        return '¡Mira este ejemplar de $name identificado con Boscdex AI $icon!';
      case 'en':
        return 'Look at this specimen of $name identified with Boscdex AI $icon!';
      case 'ca':
      default:
        return 'Mireu aquest exemplar de $name identificat amb Boscdex AI $icon';
    }
  }

  String shareSightingSubject(String name) {
    switch (languageCode) {
      case 'es':
        return 'Boscdex - Identificación de $name';
      case 'en':
        return 'Boscdex - Identification of $name';
      case 'ca':
      default:
        return 'Boscdex - Identificació de $name';
    }
  }

  String get madeWithLoveForForagers {
    switch (languageCode) {
      case 'es':
        return 'Hecho con 🌲 para los buscadores de setas de Cataluña';
      case 'en':
        return 'Made with 🌲 for the foragers of Catalonia';
      case 'ca':
      default:
        return 'Fet amb 🌲 per als boletaires de Catalunya';
    }
  }

  String get aiSafetyRuleDescription {
    switch (languageCode) {
      case 'es':
        return 'Cualquier coincidencia con certeza inferior al 70% o con riesgo de confusión tóxica activa la alerta micológica de precaución.';
      case 'en':
        return 'Any match with confidence below 70% or with toxic lookalike risk triggers the mycological safety alert.';
      case 'ca':
      default:
        return 'Qualsevol coincidència amb certesa inferior al 70% o amb risc de confusió tòxica activa l\'alerta micològica de precaució.';
    }
  }

  String get databaseDescription {
    switch (languageCode) {
      case 'es':
        return '20 setas y 5 árboles indicadores de Cataluña con claves morfológicas y red micorrízica.';
      case 'en':
        return '20 mushrooms and 5 indicator trees of Catalonia with morphological keys and mycorrhizal network.';
      case 'ca':
      default:
        return '20 bolets i 5 arbres indicadors de Catalunya amb claus morfològiques i xarxa micorrízica.';
    }
  }

  String speciesCatalogedStats(int discovered, int max, int photos) {
    switch (languageCode) {
      case 'es':
        return '$discovered / $max setas catalogadas • $photos fotos personales en el diario.';
      case 'en':
        return '$discovered / $max mushrooms cataloged • $photos personal photos in the journal.';
      case 'ca':
      default:
        return '$discovered / $max bolets catalogats • $photos fotos personals al diari.';
    }
  }

  String get offlineConnectionSemantics {
    switch (languageCode) {
      case 'es':
        return 'Estado de la conexión: 100% sin conexión';
      case 'en':
        return 'Connection status: 100% offline';
      case 'ca':
      default:
        return 'Estat de la connexió: 100% fora de línia';
    }
  }

  String get insertCoinToExplore {
    switch (languageCode) {
      case 'es':
        return '★ CARGANDO EL BOSQUE ★';
      case 'en':
        return '★ LOADING FOREST ★';
      case 'ca':
      default:
        return '★ CARREGANT EL BOSC ★';
    }
  }

  String get loadingForest => insertCoinToExplore;

  String boletNumberNotDiscovered(String dexNum) {
    switch (languageCode) {
      case 'es':
        return 'Seta número $dexNum no descubierta. Toca para ver hábitat y ubicación';
      case 'en':
        return 'Mushroom #$dexNum undiscovered. Tap to view habitat and distribution';
      case 'ca':
      default:
        return 'Bolet número $dexNum no descobert. Toca per veure hàbitat i ubicació';
    }
  }

  String treeCardSemantics(String displayName, String scientificName,
      String leafType, bool isVisited, int boletsCount) {
    switch (languageCode) {
      case 'es':
        return '$displayName ($scientificName), hoja $leafType, ${isVisited ? "identificado" : "no explorado"}, $boletsCount setas socias';
      case 'en':
        return '$displayName ($scientificName), leaf $leafType, ${isVisited ? "identified" : "unexplored"}, $boletsCount partner mushrooms';
      case 'ca':
      default:
        return '$displayName ($scientificName), fulla $leafType, ${isVisited ? "identificat" : "no explorat"}, $boletsCount bolets socis';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ca', 'es', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
