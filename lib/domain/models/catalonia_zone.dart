import 'package:flutter/material.dart';

/// Natural foraging zones and geographic regions of Catalonia.
enum CataloniaZone {
  altPirineu,
  prepirineuCentral,
  transversalMontseny,
  litoralPrelitoral,
  ponent,
  serraladaSudPrades,
  portsTerresEbre,
}

extension CataloniaZoneExtension on CataloniaZone {
  String get id {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'alt_pirineu';
      case CataloniaZone.prepirineuCentral:
        return 'prepirineu_central';
      case CataloniaZone.transversalMontseny:
        return 'transversal_montseny';
      case CataloniaZone.litoralPrelitoral:
        return 'litoral_prelitoral';
      case CataloniaZone.ponent:
        return 'ponent';
      case CataloniaZone.serraladaSudPrades:
        return 'serralada_sud_prades';
      case CataloniaZone.portsTerresEbre:
        return 'ports_terres_ebre';
    }
  }

  String get label => getLabel('ca');

  String getLabel(String languageCode) {
    switch (this) {
      case CataloniaZone.altPirineu:
        switch (languageCode) {
          case 'es':
            return 'Alto Pirineo y Arán';
          case 'en':
            return 'High Pyrenees & Aran';
          case 'ca':
          default:
            return 'Alt Pirineu i Aran';
        }
      case CataloniaZone.prepirineuCentral:
        switch (languageCode) {
          case 'es':
            return 'Prepirineo y Cat. Central';
          case 'en':
            return 'Pre-Pyrenees & Central Cat.';
          case 'ca':
          default:
            return 'Prepirineu i Cat. Central';
        }
      case CataloniaZone.transversalMontseny:
        switch (languageCode) {
          case 'es':
            return 'Cordillera Transversal y Montseny';
          case 'en':
            return 'Transversal Range & Montseny';
          case 'ca':
          default:
            return 'Serralada Transversal i Montseny';
        }
      case CataloniaZone.litoralPrelitoral:
        switch (languageCode) {
          case 'es':
            return 'Litoral y Prelitoral';
          case 'en':
            return 'Coastal & Pre-coastal';
          case 'ca':
          default:
            return 'Litoral i Prelitoral';
        }
      case CataloniaZone.ponent:
        switch (languageCode) {
          case 'es':
            return 'Llanura de Poniente';
          case 'en':
            return 'Western Plain (Ponent)';
          case 'ca':
          default:
            return 'Plana de Ponent';
        }
      case CataloniaZone.serraladaSudPrades:
        switch (languageCode) {
          case 'es':
            return 'Montañas de Prades y Tarragona';
          case 'en':
            return 'Prades Mountains & Tarragona';
          case 'ca':
          default:
            return 'Muntanyes de Prades i Tarragona';
        }
      case CataloniaZone.portsTerresEbre:
        switch (languageCode) {
          case 'es':
            return 'Tierras del Ebro y Los Puertos';
          case 'en':
            return 'Ebre Lands & Els Ports';
          case 'ca':
          default:
            return 'Terres de l\'Ebre i Els Ports';
        }
    }
  }

  String get shortLabel => getShortLabel('ca');

  String getShortLabel(String languageCode) {
    switch (this) {
      case CataloniaZone.altPirineu:
        switch (languageCode) {
          case 'es':
            return 'Alto Pirineo';
          case 'en':
            return 'High Pyrenees';
          case 'ca':
          default:
            return 'Alt Pirineu';
        }
      case CataloniaZone.prepirineuCentral:
        switch (languageCode) {
          case 'es':
            return 'Prepirineo / Central';
          case 'en':
            return 'Pre-Pyrenees / Central';
          case 'ca':
          default:
            return 'Prepirineu / Central';
        }
      case CataloniaZone.transversalMontseny:
        return 'Girona / Montseny';
      case CataloniaZone.litoralPrelitoral:
        switch (languageCode) {
          case 'es':
            return 'Litoral / Prelitoral';
          case 'en':
            return 'Coastal / Pre-coastal';
          case 'ca':
          default:
            return 'Litoral / Prelitoral';
        }
      case CataloniaZone.ponent:
        switch (languageCode) {
          case 'es':
            return 'Poniente';
          case 'en':
            return 'Ponent';
          case 'ca':
          default:
            return 'Ponent';
        }
      case CataloniaZone.serraladaSudPrades:
        return 'Prades / Camp';
      case CataloniaZone.portsTerresEbre:
        switch (languageCode) {
          case 'es':
            return 'Los Puertos / Ebro';
          case 'en':
            return 'Els Ports / Ebre';
          case 'ca':
          default:
            return 'Els Ports / Ebre';
        }
    }
  }

  String get comarques {
    switch (this) {
      case CataloniaZone.altPirineu:
        return 'Val d\'Aran, Pallars Sobirà, Alta Ribagorça, Alt Urgell, Cerdanya';
      case CataloniaZone.prepirineuCentral:
        return 'Berguedà, Solsonès, Ripollès, Osona, Moianès, Lluçanès';
      case CataloniaZone.transversalMontseny:
        return 'Garrotxa, Guilleries, Montseny, Selva, Gironès, Empordà';
      case CataloniaZone.litoralPrelitoral:
        return 'Maresme, Vallès, Garraf, Baix Llobregat, Penedès';
      case CataloniaZone.ponent:
        return 'Segrià, Noguera, Urgell, Pla d\'Urgell, Segarra, Garrigues';
      case CataloniaZone.serraladaSudPrades:
        return 'Priorat, Muntanyes de Prades, Conca de Barberà, Alt/Baix Camp';
      case CataloniaZone.portsTerresEbre:
        return 'Massís dels Ports, Terra Alta, Baix Ebre, Montsià, Ribera d\'Ebre';
    }
  }

  String get habitatDescription => getHabitatDescription('ca');

  String getHabitatDescription(String languageCode) {
    switch (this) {
      case CataloniaZone.altPirineu:
        switch (languageCode) {
          case 'es':
            return 'Pinares de pino negro y albar, hayedos alpinos y prados subalpinos (1000m - 2000m+).';
          case 'en':
            return 'Mountain pine and Scots pine forests, alpine beechwoods, and subalpine meadows (1000m - 2000m+).';
          case 'ca':
          default:
            return 'Pinedes de pi negre i pi roig, fagedes alpines i prats subalpins (1000m - 2000m+).';
        }
      case CataloniaZone.prepirineuCentral:
        switch (languageCode) {
          case 'es':
            return 'Cuna tradicional de los buscadores de setas. Pinares de pino albar, hayedos sombríos y robledales (600m - 1600m).';
          case 'en':
            return 'Traditional cradle of mushroom foraging. Scots pine woods, shady beechwoods, and oak forests (600m - 1600m).';
          case 'ca':
          default:
            return 'Bressol tradicional dels boletaires. Pinedes de pi roig, fagedes ombrívoles i rouredes (600m - 1600m).';
        }
      case CataloniaZone.transversalMontseny:
        switch (languageCode) {
          case 'es':
            return 'Bosques húmedos y silíceos de haya, castaño, encina y alcornocal (200m - 1400m).';
          case 'en':
            return 'Humid, siliceous forests of beech, chestnut, holm oak, and cork oak (200m - 1400m).';
          case 'ca':
          default:
            return 'Boscos humits i silícics de faig, castanyer, alzina i sureda (200m - 1400m).';
        }
      case CataloniaZone.litoralPrelitoral:
        switch (languageCode) {
          case 'es':
            return 'Pinares de pino carrasco mediterráneo, encinares litorales y maquias costeras (0m - 800m).';
          case 'en':
            return 'Mediterranean Aleppo pine forests, coastal holm oaks, and scrublands (0m - 800m).';
          case 'ca':
          default:
            return 'Pinedes de pi blanc mediterrani, alzinars litorals i garrigues costaneres (0m - 800m).';
        }
      case CataloniaZone.ponent:
        switch (languageCode) {
          case 'es':
            return 'Bosques de ribera (alamedas y saucedas), cultivos y pastos continentales (150m - 600m).';
          case 'en':
            return 'Riparian riverside woods (poplars and willows), agricultural fields, and continental pastures (150m - 600m).';
          case 'ca':
          default:
            return 'Boscos de ribera (verdes i salzedes), conreus i pastures continentals (150m - 600m).';
        }
      case CataloniaZone.serraladaSudPrades:
        switch (languageCode) {
          case 'es':
            return 'Sierras litorales y prelitorales con mezcla de suelos calcáreos y silíceos (400m - 1200m).';
          case 'en':
            return 'Coastal and pre-coastal ranges with mixed calcareous and siliceous soils (400m - 1200m).';
          case 'ca':
          default:
            return 'Serres litorals i prelitorals amb barreja de sòls calcaris i silícics (400m - 1200m).';
        }
      case CataloniaZone.portsTerresEbre:
        switch (languageCode) {
          case 'es':
            return 'Hayedos relictos meridionales y pinares calcáreos de los Puertos de Beceite (100m - 1400m).';
          case 'en':
            return 'Relict southern beech forests and limestone pine woods of Els Ports (100m - 1400m).';
          case 'ca':
          default:
            return 'Fagedes relictes meridionals i pinedes calcàries dels Ports de Beseit (100m - 1400m).';
        }
    }
  }

  /// Relative rectangle coordinates (0.0 to 1.0) on the 4:3 regional map of Catalonia.
  Rect get relativeBounds {
    switch (this) {
      case CataloniaZone.altPirineu:
        return const Rect.fromLTWH(0.06, 0.05, 0.44, 0.22);
      case CataloniaZone.prepirineuCentral:
        return const Rect.fromLTWH(0.28, 0.23, 0.34, 0.24);
      case CataloniaZone.transversalMontseny:
        return const Rect.fromLTWH(0.60, 0.18, 0.32, 0.30);
      case CataloniaZone.litoralPrelitoral:
        return const Rect.fromLTWH(0.38, 0.50, 0.32, 0.22);
      case CataloniaZone.ponent:
        return const Rect.fromLTWH(0.03, 0.28, 0.28, 0.38);
      case CataloniaZone.serraladaSudPrades:
        return const Rect.fromLTWH(0.18, 0.64, 0.28, 0.18);
      case CataloniaZone.portsTerresEbre:
        return const Rect.fromLTWH(0.04, 0.77, 0.26, 0.19);
    }
  }

  static CataloniaZone fromString(String str) {
    for (final zone in CataloniaZone.values) {
      if (zone.id == str || zone.name == str) {
        return zone;
      }
    }
    return CataloniaZone.prepirineuCentral;
  }
}
