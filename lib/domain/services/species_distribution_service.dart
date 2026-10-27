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
    'marasmius_oreades': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.ponent,
    ],
    'lactarius_chrysorrheus': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'lepista_nuda': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'rubroboletus_satanas': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'russula_virescens': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'hygrophorus_eburneus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'tricholoma_pardinum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
    ],
    'morchella_esculenta': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'agaricus_campestris': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.ponent,
      CataloniaZone.serraladaSudPrades,
    ],
    'agaricus_xanthodermus': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.ponent,
    ],
    'psathyrella_candolleana': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
    ],
    'suillus_granulatus': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
    ],
    'hygrophorus_russula': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.prepirineuCentral,
    ],
    'boletus_aereus': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'coprinus_comatus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.ponent,
    ],
    'lactarius_torminosus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'amanita_pantherina': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
    ],
    'gyromitra_esculenta': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
    ],
    'hygrophorus_personii': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.prepirineuCentral,
    ],
    'pleurotus_eryngii': [
      CataloniaZone.ponent,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.prepirineuCentral,
    ],
    'lactarius_semisanguifluus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
    ],
    'suillus_bellinii': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'tricholoma_equestre': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'amanita_virosa': [
      CataloniaZone.altPirineu,
      CataloniaZone.transversalMontseny,
    ],
    'galerina_marginata': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'tuber_melanosporum': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'infundibulicybe_geotropa': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'boletus_pinophilus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'neoboletus_luridiformis': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'boletus_reticulatus': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'hygrophorus_marzuolus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'russula_aurea': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.litoralPrelitoral,
    ],
    'craterellus_tubaeformis': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'agaricus_arvensis': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.altPirineu,
      CataloniaZone.transversalMontseny,
      CataloniaZone.ponent,
    ],
    'hydnum_rufescens': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'scleroderma_citrinum': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
    ],
    'clitocybe_nebularis': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'tylopilus_felleus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'suillellus_luridus': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
    ],
    'russula_emetica': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'cyclocybe_aegerita': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.ponent,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.prepirineuCentral,
    ],
    'tricholoma_portentosum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'tuber_aestivum': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'amanita_rubescens': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.altPirineu,
      CataloniaZone.serraladaSudPrades,
    ],
    'imleria_badia': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'lactarius_vinosus': [
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
      CataloniaZone.prepirineuCentral,
    ],
    'cantharellus_subpruinosus': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.prepirineuCentral,
    ],
    'leccinum_aurantiacum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'hypholoma_fasciculare': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
      CataloniaZone.portsTerresEbre,
    ],
    'paxillus_involutus': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
    ],
    'amanita_citrina': [
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.serraladaSudPrades,
    ],
    'tricholoma_saponaceum': [
      CataloniaZone.altPirineu,
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.serraladaSudPrades,
    ],
    'inocybe_erubescens': [
      CataloniaZone.prepirineuCentral,
      CataloniaZone.transversalMontseny,
      CataloniaZone.litoralPrelitoral,
      CataloniaZone.serraladaSudPrades,
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
