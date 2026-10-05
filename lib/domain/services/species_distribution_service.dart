import '../models/catalonia_zone.dart';

/// Ecological geographic distribution service for Catalan mushroom species.
/// Maps each mushroom specimen to its natural distribution zones across Catalonia.
class SpeciesDistributionService {
  const SpeciesDistributionService();

  static const Map<String, List<CataloniaZone>> _speciesZones = {
    'lactarius_deliciosus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'boletus_edulis': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'cantharellus_cibarius': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'amanita_caesarea': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'craterellus_cornucopioides': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'macrolepiota_procera': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.ponent,
      CataloniaZone.serraladaSudPrades,
    ],
    'tricholoma_terreum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'calocybe_gambosa': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
    ],
    'pleurotus_ostreatus': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.ponent,
      CataloniaZone.serraladaSudPrades,
    ],
    'hydnum_repandum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'hygrophorus_latitabundus': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'craterellus_lutescens': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'suillus_luteus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
    ],
    'russula_cyanoxantha': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'amanita_muscaria': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'omphalotus_olearius': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
      CataloniaZone.ponent,
    ],
    'entoloma_sinuatum': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'amanita_phalloides': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'amanita_verna': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'cortinarius_orellanus': [
      CataloniaZone.altPirineu,
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
    ],
    'lactarius_sanguifluus': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'chroogomphus_rutilus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
  };

  static const Map<String, List<CataloniaZone>> _treeZones = {
    'pinus_sylvestris': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
    ],
    'pinus_halepensis': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
      CataloniaZone.ponent,
    ],
    'quercus_ilex': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.prepirineuCentral,
    ],
    'fagus_sylvatica': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.altPirineu,
      CataloniaZone.portsTerresEbre,
    ],
    'castanea_sativa': [
      CataloniaZone.transversalMontseny,
    ],
  };

  /// Returns the cataloged natural zones for a given mushroom species.
  /// If unknown, defaults to Prepirineu and Transversal (the primary mushroom foraging belt).
  static List<CataloniaZone> getZonesForSpecies(String boletId) {
    return _speciesZones[boletId] ??
        const [
          CataloniaZone.prepirineuCentral,
          CataloniaZone.transversalMontseny,
        ];
  }

  /// Returns the cataloged natural zones for a given indicator tree.
  static List<CataloniaZone> getZonesForTree(String arbreId) {
    return _treeZones[arbreId] ??
        const [
          CataloniaZone.transversalMontseny,
          CataloniaZone.prepirineuCentral,
        ];
  }
}
