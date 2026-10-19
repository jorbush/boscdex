/// Multi-language species and morphology localizer for Catalan (ca), Spanish (es), and English (en).
///
/// Keeps scientific Latin names universal while providing accurate localized common names,
/// morphology traits (cap, gills, stem, latex), safety warnings, lookalike notes, and tree traits
/// for all 22 mushrooms and 5 indicator trees in the Boscdex catalog.
class SpeciesLocalizer {
  static const Map<String, Map<String, String>> _mushrooms = {
    'lactarius_deliciosus': {
      'ca': 'Rovelló / Pinetell',
      'es': 'Níscalo / Robellón',
      'en': 'Saffron Milk Cap',
    },
    'boletus_edulis': {
      'ca': 'Cep',
      'es': 'Boleto / Hongo calabaza',
      'en': 'Penny Bun / Porcini',
    },
    'cantharellus_cibarius': {
      'ca': 'Rossinyol',
      'es': 'Rebozuelo / Chantarela',
      'en': 'Golden Chanterelle',
    },
    'amanita_caesarea': {
      'ca': 'Ou de reig',
      'es': 'Oronja / Huevo de rey',
      'en': 'Caesar\'s Mushroom',
    },
    'craterellus_cornucopioides': {
      'ca': 'Trompeta de la mort',
      'es': 'Trompeta de los muertos',
      'en': 'Black Trumpet / Horn of Plenty',
    },
    'macrolepiota_procera': {
      'ca': 'Apagallums',
      'es': 'Parasol',
      'en': 'Parasol Mushroom',
    },
    'tricholoma_terreum': {
      'ca': 'Fredolic',
      'es': 'Negrilla',
      'en': 'Grey Knight',
    },
    'calocybe_gambosa': {
      'ca': 'Moixernó',
      'es': 'Seta de San Jorge / Perrechico',
      'en': 'St. George\'s Mushroom',
    },
    'pleurotus_ostreatus': {
      'ca': 'Gírgola',
      'es': 'Seta de ostra',
      'en': 'Oyster Mushroom',
    },
    'hydnum_repandum': {
      'ca': 'Llengua de bou',
      'es': 'Lengua de vaca',
      'en': 'Wood Hedgehog / Sweet Tooth',
    },
    'hygrophorus_latitabundus': {
      'ca': 'Llenega negra',
      'es': 'Higróforo negro / Llanega negra',
      'en': 'Black Slimy Cap',
    },
    'craterellus_lutescens': {
      'ca': 'Camagroc',
      'es': 'Trompeta amarilla / Rebozuelo anaranjado',
      'en': 'Yellow Foot / Trumpet Chanterelle',
    },
    'suillus_luteus': {
      'ca': 'Llenegot',
      'es': 'Boleto anillado / Baboso',
      'en': 'Slippery Jack',
    },
    'russula_cyanoxantha': {
      'ca': 'Llora verda',
      'es': 'Carbonera',
      'en': 'Charcoal Burner',
    },
    'amanita_muscaria': {
      'ca': 'Reig bord',
      'es': 'Matamoscas',
      'en': 'Fly Agaric',
    },
    'omphalotus_olearius': {
      'ca': 'Gírgola d\'olivera',
      'es': 'Seta de olivo',
      'en': 'Jack-o\'-lantern Mushroom',
    },
    'entoloma_sinuatum': {
      'ca': 'Pèrfid',
      'es': 'Pérfida / Engañosa',
      'en': 'Livid Pinkgill',
    },
    'amanita_phalloides': {
      'ca': 'Farinera borda',
      'es': 'Oronja verde / Cicuta verde',
      'en': 'Death Cap',
    },
    'amanita_verna': {
      'ca': 'Cicuta blanca',
      'es': 'Oronja blanca / Cicuta blanca',
      'en': 'Fool\'s Mushroom / Spring Death Cap',
    },
    'cortinarius_orellanus': {
      'ca': 'Cortinari de muntanya',
      'es': 'Cortinario de montaña',
      'en': 'Fool\'s Webcap',
    },
    'lactarius_sanguifluus': {
      'ca': 'Vinader / Rovelló de sang',
      'es': 'Níscalo de sangre',
      'en': 'Bloody Milk Cap',
    },
    'chroogomphus_rutilus': {
      'ca': 'Cama de perdiu',
      'es': 'Pata de perdiz / Piquigrueso',
      'en': 'Copper Spike / Pine Spike',
    },
    'marasmius_oreades': {
      'ca': 'Carrereta / Cama-sec',
      'es': 'Senderuela / Carrerilla',
      'en': 'Fairy Ring Champignon / Scotch Bonnet',
    },
    'lactarius_chrysorrheus': {
      'ca': 'Lleterola de llet groga / Fals rovelló',
      'es': 'Falso níscalo / Lactario de leche dorada',
      'en': 'Yellow-drop Milkcap',
    },
    'lepista_nuda': {
      'ca': 'Pé blau / Pua blava',
      'es': 'Pie azul',
      'en': 'Wood Blewit',
    },
    'rubroboletus_satanas': {
      'ca': 'Mataparent de Satanàs',
      'es': 'Boleto de Satanás',
      'en': 'Satan\'s Bolete',
    },
    'russula_virescens': {
      'ca': 'Palometa / Llora pigada',
      'es': 'Gibelurdiñ / Seta de cura',
      'en': 'Green-cracked Brittlegill',
    },
    'hygrophorus_eburneus': {
      'ca': 'Llenega blanca / Mocosa blanca',
      'es': 'Higróforo blanco / Llanega blanca',
      'en': 'Ivory Woodwax',
    },
    'tricholoma_pardinum': {
      'ca': 'Fredolic bord / Griset bord',
      'es': 'Tricoloma atigrado / Negrilla bastarda',
      'en': 'Poison Knight / Tiger Tricholoma',
    },
    'morchella_esculenta': {
      'ca': 'Múrgola / Rabassola',
      'es': 'Colmenilla / Morchela común',
      'en': 'Morel / Yellow Morel',
    },
    'agaricus_campestris': {
      'ca': 'Xampinyó silvestre / Guisana',
      'es': 'Champiñón silvestre / Campestre',
      'en': 'Field Mushroom / Meadow Mushroom',
    },
    'agaricus_xanthodermus': {
      'ca': 'Xampinyó groguenc / Xampinyó pudent',
      'es': 'Champiñón amarilleante / Nocivo',
      'en': 'Yellow-staining Mushroom',
    },
    'psathyrella_candolleana': {
      'ca': 'Candol·lea / Psatirel·la de Candolle',
      'es': 'Psatirela de Candolle',
      'en': 'Candolle\'s Bonnet',
    },
    'suillus_granulatus': {
      'ca': 'Molleric clapat / Pinetell de pi blanc',
      'es': 'Boleto granulado / Hongo de pino',
      'en': 'Weeping Bolete',
    },
    'hygrophorus_russula': {
      'ca': 'Carlet / Escarlet',
      'es': 'Higróforo escarlata / Carleta',
      'en': 'False Chanterelle / Russula Woodwax',
    },
    'boletus_aereus': {
      'ca': 'Cep negre / Sureny fosc',
      'es': 'Boleto negro / Hongo negro',
      'en': 'Dark Bolete / Queen Bolete',
    },
    'coprinus_comatus': {
      'ca': 'Bolet de tinta / Braguer de vaca',
      'es': 'Coprino barbudo / Barbuda',
      'en': 'Shaggy Mane / Lawyer\'s Wig',
    },
    'lactarius_torminosus': {
      'ca': 'Cabra / Rovelló bord',
      'es': 'Falso níscalo peludo / Lactario de abedul',
      'en': 'Woolly Milkcap',
    },
    'amanita_pantherina': {
      'ca': 'Pantera / Reig bord pigat',
      'es': 'Amanita pantera',
      'en': 'Panther Cap',
    },
    'gyromitra_esculenta': {
      'ca': 'Bolet de greix / Falsa múrgola',
      'es': 'Bonete / Falsa colmenilla',
      'en': 'False Morel / Brain Mushroom',
    },
    'hygrophorus_personii': {
      'ca': 'Llenega d\'alzina / Llanega d\'alzina',
      'es': 'Higróforo de encina / Llanega de encina',
      'en': 'Dark Woodwax / Oak Woodwax',
    },
    'pleurotus_eryngii': {
      'ca': 'Gírgola de panical / Bolet de card',
      'es': 'Seta de cardo',
      'en': 'King Oyster / King Trumpet',
    },
    'lactarius_semisanguifluus': {
      'ca': 'Pinetell de sang / Rovelló de pi negre',
      'es': 'Níscalo semirrojo / Falso níscalo de sangre',
      'en': 'Highland Saffron Milkcap / Half-blood Milkcap',
    },
    'suillus_bellinii': {
      'ca': 'Pinet de pi bord / Molleric de Bellini',
      'es': 'Boleto de Bellini / Hongo de pino blanco',
      'en': 'Bellini\'s Pine Bolete',
    },
    'tricholoma_equestre': {
      'ca': 'Groguet / Verderol / Bolet dels cavallers',
      'es': 'Seta de los caballeros / Verderol',
      'en': 'Yellow Knight / Man on Horseback',
    },
    'amanita_virosa': {
      'ca': 'Farinera pudent / Àngel de la mort',
      'es': 'Cicuta fétida / Ángel de la muerte',
      'en': 'Destroying Angel',
    },
    'galerina_marginata': {
      'ca': 'Galerina mortal / Galerina vironosa',
      'es': 'Galerina mortal / Galerina rebordeada',
      'en': 'Funeral Bell / Deadly Galerina',
    },
    'tuber_melanosporum': {
      'ca': 'Tòfona negra / Trufa negra',
      'es': 'Trufa negra',
      'en': 'Black Truffle / Périgord Truffle',
    },
    'scleroderma_citrinum': {
      'ca': 'Patac d\'ase / Tòfona borda',
      'es': 'Falsa trufa / Patata de tierra',
      'en': 'Common Earthball / Pigskin Poison Puffball',
    },
    'infundibulicybe_geotropa': {
      'ca': 'Pampa / Candela de bruixa / Cap d\'orinal',
      'es': 'Platera / Cabeza de fraile',
      'en': 'Trooping Funnel / Monk\'s Head',
    },
    'clitocybe_nebularis': {
      'ca': 'Pampa de boira / Boira / Burell',
      'es': 'Pardilla / Seta de brezo',
      'en': 'Clouded Agaric / Clouded Funnel',
    },
    'boletus_pinophilus': {
      'ca': 'Cep vermell / Cep de pi / Sureny vermell',
      'es': 'Boleto pinícola / Hongo de pino',
      'en': 'Pine Bolete',
    },
    'neoboletus_luridiformis': {
      'ca': 'Mataparent de peu vermell / Bolet de bou',
      'es': 'Boleto de pie rojo',
      'en': 'Scarletina Bolete / Dotted-Stem Bolete',
    },
    'suillellus_luridus': {
      'ca': 'Mataparent de bou / Fals bolet de bou',
      'es': 'Boleto lúrido',
      'en': 'Lurid Bolete',
    },
    'tylopilus_felleus': {
      'ca': 'Mataparent amarg / Cep amarg',
      'es': 'Boleto amargo / Hongo amargo',
      'en': 'Bitter Bolete',
    },
    'boletus_reticulatus': {
      'ca': 'Cep d\'estiu / Siuró d\'estiu',
      'es': 'Boleto reticulado / Boleto de verano',
      'en': 'Summer Bolete',
    },
    'hygrophorus_marzuolus': {
      'ca': 'Marçot / Bolet de març',
      'es': 'Marzuelo / Seta de marzo',
      'en': 'March Mushroom / Snowdrop Woodwax',
    },
    'russula_aurea': {
      'ca': 'Llora daurada / Cuaverda daurada',
      'es': 'Rúsula dorada',
      'en': 'Gilded Brittlegill',
    },
    'russula_emetica': {
      'ca': 'Rússula emètica / Cua cremosa',
      'es': 'Rúsula emética',
      'en': 'The Sickener / Vomiting Russula',
    },
    'craterellus_tubaeformis': {
      'ca': 'Rossinyol de bosc / Trompeta groga / Rossinyolic',
      'es': 'Trompeta amarilla / Angula de monte',
      'en': 'Trumpet Chanterelle / Yellowfoot',
    },
    'agaricus_arvensis': {
      'ca': 'Bola de neu / Xampinyó d\'anís / Terrerol gros',
      'es': 'Champiñón anisado / Bola de nieve',
      'en': 'Horse Mushroom',
    },
    'hydnum_rufescens': {
      'ca': 'Llengua de bou rogenca / Llengua de gat',
      'es': 'Lengua de vaca rojiza / Gamuza rojiza',
      'en': 'Terracotta Hedgehog / Rufous Wood Hedgehog',
    },
  };

  static const Map<String, Map<String, String>> _trees = {
    'pinus_sylvestris': {
      'ca': 'Pi roig',
      'es': 'Pino silvestre / Pino albar',
      'en': 'Scots Pine',
    },
    'pinus_halepensis': {
      'ca': 'Pi blanc',
      'es': 'Pino carrasco',
      'en': 'Aleppo Pine',
    },
    'quercus_ilex': {
      'ca': 'Alzina',
      'es': 'Encina',
      'en': 'Holm Oak',
    },
    'fagus_sylvatica': {
      'ca': 'Faig',
      'es': 'Haya común',
      'en': 'European Beech',
    },
    'castanea_sativa': {
      'ca': 'Castanyer',
      'es': 'Castaño común',
      'en': 'Sweet Chestnut',
    },
  };

  static const Map<String, Map<String, String>> _capDescriptions = {
    'lactarius_deliciosus': {
      'ca':
          'De 5 a 15 cm, convex que s\'aplana i s\'embuta amb l\'edat, ataronjat amb zones concèntriques més clares i fosques. Marge enrotllat inicialment. Es taca de verd en envellir o fer-se malbé.',
      'es':
          'De 5 a 15 cm, convexo que se aplana y embuda con la edad, anaranjado con zonas concéntricas más claras y oscuras. Margen enrollado al principio. Se mancha de verde al envejecer o dañarse.',
      'en':
          '5 to 15 cm, convex flattening and funnel-shaped with age, orange with concentric lighter and darker rings. Inrolled margin when young. Stains green when bruised or aging.',
    },
    'boletus_edulis': {
      'ca':
          'Gran (5-25 cm o més), de color marró clar a fosc, amb un marge sovint més clar, gairebé blanc en exemplars joves. Superfície llisa, lleugerament viscosa en temps humit.',
      'es':
          'Grande (5-25 cm o más), de color marrón claro a oscuro, con margen a menudo más claro, casi blanco en ejemplares jóvenes. Superficie lisa, ligeramente viscosa en tiempo húmedo.',
      'en':
          'Large (5-25 cm or more), light to dark brown, with a paler margin, almost white in young specimens. Smooth surface, slightly greasy when damp.',
    },
    'cantharellus_cibarius': {
      'ca':
          'Petit a mitjà (3-10 cm), tot de color groc rovell d\'ou uniforme. Carn ferma. Té forma d\'embut o copa de vores sinuoses i irregulars.',
      'es':
          'Pequeño a mediano (3-10 cm), de color amarillo yema uniforme. Carne firme. Forma de embudo con bordes sinuosos e irregulares.',
      'en':
          'Small to medium (3-10 cm), uniform egg-yolk yellow. Firm flesh. Funnel-shaped with wavy, irregular margins.',
    },
    'amanita_caesarea': {
      'ca':
          'Neix d\'una volva blanca tancada ("ou"). Obert fa 8-20 cm, llis, de color ataronjat intens o vermell ataronjat, sense restes de volva (sense esquames blanques). Marge estriat.',
      'es':
          'Nace de una volva blanca cerrada ("huevo"). Abierto mide 8-20 cm, liso, de color naranja intenso o rojo anaranjado, sin restos de volva (sin escamas blancas). Margen estriado.',
      'en':
          'Emerges from an enclosed white egg-like volva. Expands to 8-20 cm, smooth, vivid orange to reddish-orange, without white warts. Striate margin.',
    },
    'craterellus_cornucopioides': {
      'ca':
          'En forma d\'embut o cornucòpia profundament buida fins a la base. Color de gris fosc a negre negrós. Marges ondulats.',
      'es':
          'En forma de embudo o cornucopia profundamente hueca hasta la base. Color de gris oscuro a negro negruzco. Márgenes ondulados.',
      'en':
          'Deeply hollow funnel or horn of plenty down to the base. Dark grey to blackish-brown. Wavy, flaring margin.',
    },
    'macrolepiota_procera': {
      'ca':
          'Molt gran, fins a 30 cm de diàmetre. Inicialment ovoidal (forma de baqueta de tambor), després s\'obre com un para-sol. De fons clar, cobert d\'esquames concèntriques fosques. Gran mamelló central fosc (umbó).',
      'es':
          'Muy grande, hasta 30 cm. Inicialmente ovoidal, luego se abre como una sombrilla. Fondo claro cubierto de escamas concéntricas oscuras con mamelón central.',
      'en':
          'Very large, up to 30 cm. Initially egg-shaped (drumstick), opening like a parasol. Pale background covered in concentric dark scales with prominent central umbo.',
    },
    'tricholoma_terreum': {
      'ca':
          'De 3 a 8 cm, convex, sec, amb la superfície coberta de petites esquames fibril·loses que li donen un aspecte vellutat, de color gris ratolí a gris negrós.',
      'es':
          'De 3 a 8 cm, convexo, seco, con superficie cubierta de pequeñas escamas fibrilosas aterciopeladas, gris ratón a gris negruzco.',
      'en':
          '3 to 8 cm, convex, dry, covered in small fibrous scales giving a velvety mouse-grey to dark grey texture.',
    },
    'calocybe_gambosa': {
      'ca':
          'De 5 a 12 cm, carnós, mat i sec. Color de blanc a crema suau o gairebé camussa. Marge sovint molt enrotllat cap a sota quan és jove.',
      'es':
          'De 5 a 12 cm, carnoso, mate y seco. Color blanco a crema suave o gamuza. Margen enrollado hacia abajo cuando es joven.',
      'en':
          '5 to 12 cm, fleshy, matte and dry. White to creamy-buff or biscuit color. Strongly inrolled margin when young.',
    },
    'pleurotus_ostreatus': {
      'ca':
          'Gran (5-20 cm), forma de conquilla o ostra, carnós. Color molt variable, des de blau negrós o gris plom al principi fins a gris clar o marronós. Superfície llisa.',
      'es':
          'Grande (5-20 cm), forma de concha u ostra, carnoso. Color variable, desde azul negruzco o gris plomo hasta gris claro o parduzco. Superficie lisa.',
      'en':
          'Large (5-20 cm), oyster- or fan-shaped, fleshy. Color varies from blue-black/slate-grey when young to pale grey or brownish. Smooth surface.',
    },
    'hydnum_repandum': {
      'ca':
          'De 5 a 15 cm, irregular i lobulat, de color blanquinós, crema a taronja esblaimat o rosat ataronjat. Superfície vellutada seca.',
      'es':
          'De 5 a 15 cm, irregular y lobulado, color blanquecino, crema a naranja pálido o rosado. Superficie aterciopelada seca.',
      'en':
          '5 to 15 cm, irregular and lobed, whitish to pale cream or salmon-buff. Dry, velvety surface.',
    },
    'hygrophorus_latitabundus': {
      'ca':
          'Lleugerament bombat, molt i molt viscós en estat fresc i humit, marró-gris o fosc cap al centre i marge blanquinós. Fins a 15 cm.',
      'es':
          'Ligeramente abombado, muy viscoso con humedad, pardo-grisáceo más oscuro en el centro y margen blanquecino. Hasta 15 cm.',
      'en':
          'Convex, extremely slimy when moist, greyish-brown darker at center with whitish margin. Up to 15 cm.',
    },
    'craterellus_lutescens': {
      'ca':
          'Molt prim, ondulat en embut de petit format (2-5 cm), esquamós de color bru-gris o bru fosc a sobre.',
      'es':
          'Muy delgado, ondulado en embudo pequeño (2-5 cm), escamoso pardo-grisáceo o pardo oscuro por encima.',
      'en':
          'Very thin, wavy funnel-shaped (2-5 cm), scaly grey-brown to dark brown on top.',
    },
    'suillus_luteus': {
      'ca':
          'Hemisfèric i després pla, de color marró-xocolata a groc-marró fosc. En temps humit és completament viscós i enganxós (la cutícula es pot pelar fàcilment).',
      'es':
          'Hemisférico y luego plano, marrón chocolate a pardo oscuro. Muy viscoso y pegajoso con humedad (cutícula fácilmente separable).',
      'en':
          'Hemispherical then flat, chocolate brown to yellowish-brown. Very slimy and sticky when wet (cuticle easily peels off).',
    },
    'russula_cyanoxantha': {
      'ca':
          'Molt variable, en diferents tons clapejats de violeta, rosa-lila i sobretot verd lila, blavós (mai roig viu pur). Fins a 15 cm.',
      'es':
          'Muy variable, en tonos violeta, lila y verde azulado jaspeado (nunca rojo puro). Hasta 15 cm.',
      'en':
          'Highly variable, variegated with violet, purple, and slate-green hues (never bright red). Up to 15 cm.',
    },
    'amanita_muscaria': {
      'ca':
          'Molt vistós i icònic. Color vermell intens amb múltiples "esquames" blanques sobre la superfície (són restes del vel universal).',
      'es':
          'Muy vistoso e icónico. Rojo brillante con numerosas escamas (verrugas) blancas sobre la superficie.',
      'en':
          'Iconic bright scarlet-red cap covered in numerous white pyramidal warts (universal veil remnants).',
    },
    'omphalotus_olearius': {
      'ca':
          'Carnós, de color ataronjat rogenc o bru daurat molt bonic, de vegades infundibuliforme (en forma d\'embut), neix en flotes atapeïdes a les soques.',
      'es':
          'Carnoso, naranja rojizo o pardo dorado, a menudo embudado. Crece en densos ramilletes sobre madera.',
      'en':
          'Fleshy, reddish-orange to golden copper, often funnel-shaped. Grows in dense cespitose clusters on olive/oak stumps.',
    },
    'entoloma_sinuatum': {
      'ca':
          'Molt robust (fins a 18 cm). De color blanc groguenc o crema cendrós (color camussa), llis, lluent en temps sec.',
      'es':
          'Muy robusto (hasta 18 cm). Blanco amarillento o crema ceniciento (color gamuza), liso y brillante en seco.',
      'en':
          'Very robust (up to 18 cm). Ochre-whitish to ash-grey/ivory, smooth, silky when dry.',
    },
    'amanita_phalloides': {
      'ca':
          'Llis, amb forma d\'escut suau, normalment d\'un groc-oliva clar, gris-verd o marró verdós, amb unes venes finíssimes (fibril·les radials). Sense esquames blanques.',
      'es':
          'Liso, convexo, verde oliva claro, gris-verdoso o pardo verdoso, con finas fibrillas radiales oscuras. Sin verrugas blancas.',
      'en':
          'Smooth, pale olive-yellow, greyish-green or metallic bronze-green, with fine radial fibrils. Usually devoid of warts.',
    },
    'amanita_verna': {
      'ca':
          'Superfície totalment llisa d\'un color blanc pur o lleugeríssim crema pàl·lid, fins i tot a la meitat, sovint molt simètric. 5-10 cm.',
      'es':
          'Completamente liso, blanco puro inmaculado o crema muy pálido en el centro. 5-10 cm.',
      'en':
          'Entirely smooth, pure snowy white or faintly ivory at center. 5-10 cm.',
    },
    'cortinarius_orellanus': {
      'ca':
          'Barret campanulat o convex de color terrós rogenc a taronja foc fosc, sec, densament fibril·lós o envellutat en observar-lo de prop.',
      'es':
          'Campanulado a convexo, pardo rojizo a naranja cobrizo oscuro, seco, finamente aterciopelado.',
      'en':
          'Campanulate to convex, reddish-brown to dark copper-orange, dry, finely velvety or fibrous.',
    },
    'lactarius_sanguifluus': {
      'ca':
          'De 5 a 12 cm, convex i després deprimit, de color ocre ataronjat amb tons vinosos o porpres i taques verdes en envellir.',
      'es':
          'De 5 a 12 cm, convexo y luego embudado, ocre anaranjado con tonos vinosos o púrpuras y manchas verdosas.',
      'en':
          '5 to 12 cm, convex then depressed, ochre-orange with vinous or purple tones, staining green with age.',
    },
    'chroogomphus_rutilus': {
      'ca':
          'De 4 a 10 cm, convex o cònic amb un mamelló central molt marcat (umbonat). Cutícula llisa, viscosa amb la humitat i lluent en eixut, de color marró coure o rogenc amb reflexos vinosos.',
      'es':
          'De 4 a 10 cm, convexo con mamelón agudo prominente. Cutícula lisa y viscosa en húmedo, marrón cobrizo o rojizo con reflejos vinosos.',
      'en':
          '4 to 10 cm, convex with a sharp prominent central umbo. Smooth and slimy when wet, copper-brown to reddish with vinous sheen.',
    },
    'marasmius_oreades': {
      'ca':
          'De 2 a 6 cm, campanulat que passa a convex i aplanat amb un mamelló central obtús. Color crema clar a ocre canyella, més pàl·lid en eixut (higròfan). Marge lleugerament estriat per transparència.',
      'es':
          'De 2 a 6 cm, campanulado que pasa a convexo y aplanado con un mamelón central obtuso. Color crema claro a ocre canela, más pálido al secarse (higrófano). Margen ligeramente estriado.',
      'en':
          '2 to 6 cm, campanulate becoming convex and flattened with an obtuse central umbo. Pale cream to cinnamon-buff, fading when dry (hygrophanous). Margins faintly striate.',
    },
    'lactarius_chrysorrheus': {
      'ca':
          'De 4 a 10 cm, convex i després deprimit, de color salmó pàl·lid o ocre rosat amb zones concèntriques de taques més fosques. Marge enrotllat inicialment.',
      'es':
          'De 4 a 10 cm, convexo y luego deprimido, de color salmón pálido u ocre rosado con zonas concéntricas más oscuras. Margen enrollado al principio.',
      'en':
          '4 to 10 cm, convex becoming depressed, pale salmon to pinkish-buff with concentric darker zonate blotches. Initially inrolled margin.',
    },
    'lepista_nuda': {
      'ca':
          'De 6 a 15 cm, convex i després aplanat amb marge ondulat i enrotllat. Color blau violaci o lila viu de jove, que vira a marró bru o lilaci apagat amb l\'edat. Cutícula llisa i separable.',
      'es':
          'De 6 a 15 cm, convexo y luego aplanado con margen ondulado y enrollado. Color azul violáceo o lila vivo de joven, que vira a pardo o liláceo apagado con la edad. Cutícula lisa.',
      'en':
          '6 to 15 cm, convex flattening with a wavy inrolled margin. Bright blue-violet or lilac when young, fading to brownish-lilac with age. Smooth peelable cuticle.',
    },
    'rubroboletus_satanas': {
      'ca':
          'Molt voluminós (10 a 30 cm), robust i massís. Cutícula llisa, de color blanc guix, gris perla o blanquinós brut, mai marró fosc com el cep.',
      'es':
          'Muy voluminoso (10 a 30 cm), robusto y macizo. Cutícula lisa, de color blanco tiza, gris perla o blanquecino sucio, nunca marrón oscuro como el boletus.',
      'en':
          'Very large (10 to 30 cm), thick and massive. Smooth cuticle, chalk-white, pearl-grey or dirty whitish, never dark brown like the Porcini.',
    },
    'russula_virescens': {
      'ca':
          'De 5 a 15 cm, globós i després convex-deprimit. Cutícula seca, de color verd grisenc a verd maragda pàl·lid, típicament clivellada o esquamosa formant un mosaic de petites crostes poligonals.',
      'es':
          'De 5 a 15 cm, globoso y luego convexo-deprimido. Cutícula seca, de color verde grisáceo a verde esmeralda pálido, típicamente cuarteada formando un mosaico de costras poligonales.',
      'en':
          '5 to 15 cm, globose becoming convex-depressed. Dry cuticle, grey-green to pale emerald green, characteristically cracked into a mosaic of polygonal patches.',
    },
    'hygrophorus_eburneus': {
      'ca':
          'De 4 a 10 cm, convex a lleugerament umbonat, tot de color blanc ivori lluent. Cutícula molt mucosa i viscosa en temps humit, lluent quan s\'asseca.',
      'es':
          'De 4 a 10 cm, convexo a ligeramente umbonado, enteramente blanco marfil brillante. Cutícula muy mucosa y viscosa con humedad, brillante al secarse.',
      'en':
          '4 to 10 cm, convex to slightly umbonate, shining ivory-white. Very glutinous and slimy in wet conditions, lustrous when dry.',
    },
    'tricholoma_pardinum': {
      'ca':
          'Molt robust i carnós (6 a 15 cm), campanulat i després aplanat. Cutícula de color gris platejat a gris fosc, coberta d\'esquames concèntriques amples i fosques disposades com teules (aspecte tigrat o de lleopard).',
      'es':
          'Muy robusto y carnoso (6 a 15 cm), campanulado y luego aplanado. Cutícula gris plateada a gris oscura, cubierta de escamas concéntricas anchas y oscuras como tejas (aspecto atigrado).',
      'en':
          'Very robust and fleshy (6 to 15 cm), campanulate becoming plane. Silver-grey to dark grey cuticle covered with broad dark concentric shingle-like scales (tiger/leopard pattern).',
    },
    'morchella_esculenta': {
      'ca':
          'De 4 a 10 cm d\'alçada, ovoide o arrodonit, buit per dins. Superfície formada per alvèols o cel·les profundes i irregulars (com una bresca d\'abelles), de color groc ocre, beix o mel pàl·lid.',
      'es':
          'De 4 a 10 cm de altura, ovoide o redondeado, hueco por dentro. Superficie con alvéolos profundos e irregulares (como un panal de abejas), de color amarillo ocre, beis o miel pálido.',
      'en':
          '4 to 10 cm tall, ovoid or rounded, hollow inside. Surface pitted with deep irregular alveoli (honeycomb-like ridges), pale ochre-yellow, beige or honey-buff.',
    },
    'agaricus_campestris': {
      'ca':
          'De 4 a 10 cm, convex a aplanat, carnós, sec i blanc o blanquinós sedós, de vegades amb fines esquames ocre clar al centre.',
      'es':
          'De 4 a 10 cm, convexo a aplanado, carnoso, seco y blanco o blanquecino sedoso, a veces con finas escamas ocre claro en el centro.',
      'en':
          '4 to 10 cm, convex becoming flattened, fleshy, dry and silky white or pale whitish, occasionally with subtle pale ochre scales at the disc.',
    },
    'agaricus_xanthodermus': {
      'ca':
          'De 5 a 12 cm, inicialment trapezoidal o troncocònic (pla per dalt), després convex. Blanc a grisaci clar, que es taca d\'un groc crom intens al tacte o fregament.',
      'es':
          'De 5 a 12 cm, inicialmente trapezoidal o troncocónico (plano arriba), luego convexo. Blanco a grisáceo claro, tiñéndose de amarillo cromo vivo al roce.',
      'en':
          '5 to 12 cm, initially trapezoidal or flat-topped then convex. White to pale greyish, bruising vibrant chrome-yellow upon scratching or rubbing.',
    },
    'psathyrella_candolleana': {
      'ca':
          'De 3 a 7 cm, fràgil i prim, hemisfèric i després aplanat amb umbó obtús. Higròfan, de color mel pàl·lid, ocre clar o blanquinós en assecar-se. Marge guarnit de flocs i restes blanques del vel parcial festonat.',
      'es':
          'De 3 a 7 cm, frágil y delgado, hemisférico y luego aplanado con umbón obtuso. Higrófano, color miel pálido, ocre claro o blanquecino al secarse. Margen con restos blancos festoneados del velo.',
      'en':
          '3 to 7 cm, thin and fragile, hemispherical becoming convex-expanded with an obtuse umbo. Hygrophanous, pale honey, buff or whitish when dry. Margin fringed with delicate white veil remnants.',
    },
    'suillus_granulatus': {
      'ca':
          'De 5 a 12 cm, convex i després aplanat. Cutícula molt viscosa en temps humit, fàcilment separable de la carn, de color bru groguenc, vermellós o canyella càlid.',
      'es':
          'De 5 a 12 cm, convexo luego aplanado. Cutícula muy viscosa en tiempo húmedo, fácilmente separable, de color pardo amarillento, rojizo o canela cálido.',
      'en':
          '5 to 12 cm, convex then flattened. Very slimy/viscid cuticle in moist weather, easily peeling, yellowish-brown, reddish-tawny or warm cinnamon.',
    },
    'hygrophorus_russula': {
      'ca':
          'De 5 a 15 cm, molt massís i carnós, convex i després aplanat. Color rosa vinós a vermell púrpura amb taques i vetes vinoses sobre fons blanquinós. Cutícula una mica viscosa en humit.',
      'es':
          'De 5 a 15 cm, muy macizo y carnoso, convexo luego aplanado. Color rosa vinoso a rojo púrpura con manchas y vetas vinosas sobre fondo blanquecino. Cutícula algo viscosa en húmedo.',
      'en':
          '5 to 15 cm, very firm and fleshy, convex then flattened. Pinkish-vinaceous to purplish-red streaked with vinous spots over a pale whitish background. Slightly viscid when damp.',
    },
    'boletus_aereus': {
      'ca':
          'De 7 a 20 cm, molt ferm i compacte, hemisfèric i després convex. Cutícula vellutada, de color bru xocolata molt fosc, bronzejat o gairebé negre, sovint amb clapes més clares de color ocre o coure.',
      'es':
          'De 7 a 20 cm, muy firme y compacto, hemisférico luego convexo. Cutícula aterciopelada, pardo chocolate muy oscuro, bronceado o casi negro, a menudo con zonas ocres o cobrizas.',
      'en':
          '7 to 20 cm, very firm and compact, hemispherical to convex. Velvety cuticle, deep dark chocolate-brown, bronze or almost black, often with subtle ochre or coppery patches.',
    },
    'coprinus_comatus': {
      'ca':
          'De 5 a 15 cm d\'alçada, cilíndric o acampanat estret. Superfície blanca coberta d\'esquames blanes, fibroses i llanoses corbades cap amunt. En madurar, el marge es desfà ràpidament en un líquid negre com la tinta (deliquescència).',
      'es':
          'De 5 a 15 cm de altura, cilíndrico o acampanado estrecho. Superficie blanca con escamas blandas y lanosas curvadas hacia arriba. Al madurar, el margen se disuelve rápidamente en tinta negra (delicuescencia).',
      'en':
          '5 to 15 cm tall, tall cylindrical bell-shaped. White surface densely covered in shaggy, fibrous upturned scales. Deliquesces at the margin into black liquid ink as spores mature.',
    },
    'lactarius_torminosus': {
      'ca':
          'De 4 a 12 cm, deprimit al centre amb marge molt enrotllat i cobert d\'una llana o borra abundant de pèls llanosos blanquinosos (barbat). Color rosa maduixa o salmó amb cercles concèntrics més foscos.',
      'es':
          'De 4 a 12 cm, deprimido en el centro con margen muy enrollado y cubierto de abundante vello lanoso blanquecino (barbado). Color rosa fresa o salmón con círculos concéntricos más oscuros.',
      'en':
          '4 to 12 cm, depressed center with strongly inrolled margin covered with a thick shaggy woolly fringe of pale hairs (bearded). Strawberry-pink to salmon with darker concentric rings.',
    },
    'amanita_pantherina': {
      'ca':
          'De 5 a 12 cm, hemisfèric i després convex-estès, de color bru avellana, bru ocre o terrós fosc, amb el marge clarament estriat. Cobert de nombroses berrugues piramidals o escates petites d\'un blanc pur i farinós.',
      'es':
          'De 5 a 12 cm, hemisférico luego convexo-extendido, pardo avellana, ocre o parduzco oscuro, con margen claramente estriado. Cubierto de numerosas verrugas piramidales blanco puro harinosas.',
      'en':
          '5 to 12 cm, hemispherical to expanded-convex, hazel-brown to dark olive-brown with distinctly striate margin. Sprinkled with numerous pure white crumbly pyramidal warts.',
    },
    'gyromitra_esculenta': {
      'ca':
          'De 4 a 10 cm, arrodonit, irregular, buit, amb la superfície fortament plegada i ondulada en lòbuls sinuosos que recorden les circumvolucions d\'un cervell humà. Color bru vermellós fosc, castany o xocolata.',
      'es':
          'De 4 a 10 cm, redondeado, irregular, hueco, con la superficie fuertemente plegada en lóbulos sinuosos que recuerdan las circunvoluciones cerebrales. Color pardo rojizo oscuro, castaño o chocolate.',
      'en':
          '4 to 10 cm, irregular, rounded, hollow, with deeply convoluted, brain-like folded lobes resembling human brain tissue. Dark reddish-brown, chestnut or chocolate.',
    },
  };

  static const Map<String, Map<String, String>> _gillsDescriptions = {
    'lactarius_deliciosus': {
      'ca':
          'Adnades a lleugerament decurrents, juntes, de color taronja viu. Es taquen de verd quan es toquen o trenquen.',
      'es':
          'Adnadas a ligeramente decurrentes, apretadas, de color naranja vivo. Se manchan de verde al tocarse o romperse.',
      'en':
          'Adnate to slightly decurrent, crowded, vivid orange. Stains green when handled or broken.',
    },
    'boletus_edulis': {
      'ca':
          'Tubs i porus fins al revers del barret (no làmines). Blancs al principi, passant a groc verdós amb l\'edat. No blavegen al toc.',
      'es':
          'Tubos y poros finos bajo el sombrero (no láminas). Blancos al principio, pasando a amarillo verdoso con la edad. No azulean al roce.',
      'en':
          'Tubes and fine pores under the cap (no gills). White at first, becoming greenish-yellow with age. Does not bruise blue.',
    },
    'cantharellus_cibarius': {
      'ca':
          'No té làmines veritables, sinó plecs gruixuts, bifurcats i decurrents (que baixen per la cama) del mateix color que la resta.',
      'es':
          'No tiene láminas verdaderas, sino pliegues gruesos, bifurcados y decurrentes del mismo color que el resto.',
      'en':
          'Lacks true gills, featuring thick, forked, decurrent ridges or folds of the same yellow color.',
    },
    'amanita_caesarea': {
      'ca': 'Lliures, atapeïdes, de color clarament groc.',
      'es': 'Libres, apretadas, de color netamente amarillo.',
      'en': 'Free, crowded, distinctly golden-yellow.',
    },
    'craterellus_cornucopioides': {
      'ca':
          'Sense làmines ni plecs marcats; la superfície externa (l\'himeni) és gairebé llisa, lleugerament arrugada o venada, de color gris cendra.',
      'es':
          'Sin láminas ni pliegues marcados; la superficie fértil externa es casi lisa, ligeramente arrugada o venada, gris ceniza.',
      'en':
          'Without gills or distinct folds; outer spore-bearing surface is nearly smooth to slightly wrinkled, ash-grey.',
    },
    'macrolepiota_procera': {
      'ca': 'Blanques, amples, toves i lliures respecte del peu.',
      'es': 'Blancas, anchas, blandas y libres respecto al pie.',
      'en': 'White, broad, soft, and completely free from the stem.',
    },
    'tricholoma_terreum': {
      'ca': 'Escotades, desiguals, fràgils, de color blanc grisenc clar.',
      'es': 'Escotadas, desiguales, frágiles, de color blanco grisáceo claro.',
      'en': 'Notched (sinuate), uneven, fragile, pale greyish-white.',
    },
    'calocybe_gambosa': {
      'ca':
          'Molt atapeïdes, estretes i decurrents en dent (escotades). Blanc-crema, esporen en blanc.',
      'es':
          'Muy apretadas, estrechas y escotadas. Blanco-crema, esporada blanca.',
      'en':
          'Very crowded, narrow, sinuate to notched. Creamy white with white spore print.',
    },
    'pleurotus_ostreatus': {
      'ca':
          'Llargament decurrents fins a la base, bastant separades i toves. De color blanquinós a cremós.',
      'es':
          'Ampliamente decurrentes hasta la base, separadas y blandas. De color blanquecino a crema.',
      'en':
          'Deeply decurrent down the stem base, fairly distant and soft. Whitish to cream.',
    },
    'hydnum_repandum': {
      'ca':
          'L\'himeni (part de sota) no està format per làmines ni tubs, sinó per agulles clares, blanquinoses o de color crema que es desprenen amb molta facilitat en raspar.',
      'es':
          'El himenio está formado por espinas o aguijones blanquecinos o crema que se desprenden con facilidad al frotar (sin láminas ni poros).',
      'en':
          'Hymenium consists of fragile, crowded spines (teeth) that detach easily when rubbed, rather than gills or pores.',
    },
    'hygrophorus_latitabundus': {
      'ca':
          'Gruixudes, espaiades i una mica decurrents, llustroses i ceroses, de color blanc.',
      'es':
          'Gruesas, espaciadas y algo decurrentes, cerosas y de color blanco puro.',
      'en': 'Thick, distant, slightly decurrent, waxy and pure white.',
    },
    'craterellus_lutescens': {
      'ca':
          'La part de sota del barret és totalment groga ataronjada, pràcticament llisa al principi i de mica en mica amb lleugers plecs o venes ramificades, però SENSE làmines ben definides.',
      'es':
          'La parte inferior es amarillo-anaranjada viva, lisa o con venas poco marcadas, SIN láminas verdaderas.',
      'en':
          'Underside is vivid orange-yellow, smooth at first then developing slight wrinkles or veins, WITHOUT true gills.',
    },
    'suillus_luteus': {
      'ca':
          'Té tubs i porus, que inicialment són coberts per un vel membranós (anell). Són petits i rodons, de color groc que enfosqueix i enverdeix amb l\'edat.',
      'es':
          'Tubos y poros cubiertos al inicio por velo membranoso (anillo). Poros pequeños amarillos que oscurecen con la edad.',
      'en':
          'Tubes and pores covered by a membranous veil (ring) when young. Small, yellow pores darkening with age.',
    },
    'russula_cyanoxantha': {
      'ca':
          'Blanques. La prova clau per a identificar-la és que la textura de les làmines no és trencadissa, sinó tova (com formatge llescat fi), quan s\'hi passa el dit NO es trenquen.',
      'es':
          'Blancas. Prueba clave: láminas flexibles y grasientas al tacto, NO se rompen al pasar el dedo por ellas.',
      'en':
          'White. Key test: gills are flexible and greasy (lardaceous) to the touch, NOT brittle when rubbed.',
    },
    'amanita_muscaria': {
      'ca': 'Lliures, amples, netament blanques.',
      'es': 'Libres, anchas, netamente blancas.',
      'en': 'Free, broad, crowded, pure white.',
    },
    'omphalotus_olearius': {
      'ca':
          'Decurrents, unides, freqüentment es ramifiquen o forquen. De color taronja o rovell. Poden tenir una feble luminescència (brillen verdós al fosc).',
      'es':
          'Decurrentes, apretadas, anaranjadas o herrumbre. Poseen débil bioluminiscencia en la oscuridad.',
      'en':
          'Decurrent, crowded, bright orange to saffron. Exhibiting faint green bioluminescence in total darkness.',
    },
    'entoloma_sinuatum': {
      'ca':
          'Molt espesses i amples. Escotades del marge de la cama. Al principi groguenques, després (això és crucial) viren a color salmó-rosat per la maduració d\'espores rosa.',
      'es':
          'Espesas, anchas, escotadas. Amarillentas al inicio, virando a rosa salmón al madurar las esporas rosadas.',
      'en':
          'Broad, crowded, sinuate/notched. Pale yellowish at first, turning salmon-pink with mature pink spores.',
    },
    'amanita_phalloides': {
      'ca':
          'Lliures (no toquen el peu), atapeïdes i d\'un color completament blanc.',
      'es': 'Libres, muy apretadas y de color completamente blanco.',
      'en': 'Free from stem, crowded, pure white.',
    },
    'amanita_verna': {
      'ca': 'Totalment blanques, atapeïdes, fràgils i lliures.',
      'es': 'Completamente blancas, apretadas, frágiles y libres.',
      'en': 'Pure white, crowded, delicate, and free.',
    },
    'cortinarius_orellanus': {
      'ca':
          'De gruixudes i distanciades, de color groc taronja o òxid viu. A mida que maduren prenen el color rovell intens del fons de les espores.',
      'es':
          'Gruesas, espaciadas, amarillo-anaranjadas que viran a pardo herrumbre con la maduración de las esporas.',
      'en':
          'Thick, distant, saffron-yellow turning bright rust-brown as spores mature.',
    },
    'lactarius_sanguifluus': {
      'ca':
          'Atapeïdes, decurrents, de color ocre rosat o vinós que es taquen de verd fosc.',
      'es':
          'Apretadas, decurrentes, ocre rosado a vinoso que manchan de verde oscuro.',
      'en':
          'Crowded, decurrent, pinkish-ochre to wine-colored, staining dark green.',
    },
    'chroogomphus_rutilus': {
      'ca':
          'Clarament decurrents, gruixudes, espaiades i arquejades, d\'un color inicialment ocre ataronjat que enfosqueix a marró purpuri o negrós en madurar les espores.',
      'es':
          'Fuertemente decurrentes, gruesas y espaciadas, ocre anaranjadas oscureciendo a pardo púrpura negruzco con esporas oscuras.',
      'en':
          'Deeply decurrent, thick, distant and arched, orange-ochre turning dark purple-brown/blackish as spores mature.',
    },
    'marasmius_oreades': {
      'ca':
          'Lliures o lleugerament adnades, amples, força separades entre elles, intercalades amb lamel·lules, de color blanquinós a crema ocraci clar.',
      'es':
          'Libres o ligeramente adnadas, anchas, bastante separadas entre sí, intercaladas con lamelulas, de color blanquecino a crema ocráceo claro.',
      'en':
          'Free or slightly adnate, broad, distant and well spaced, interspersed with lamellulae, whitish to pale cream-buff.',
    },
    'lactarius_chrysorrheus': {
      'ca':
          'Atapeïdes, lleugerament decurrents, de color crema pàl·lid a ocre rosat amb l\'edat.',
      'es':
          'Apretadas, ligeramente decurrentes, de color crema pálido a ocre rosado con la edad.',
      'en': 'Crowded, slightly decurrent, pale cream to pinkish-buff with age.',
    },
    'lepista_nuda': {
      'ca':
          'Atapeïdes, sinuades a escotades, d\'un color blau violaci o lavanda molt viu, fàcilment separables de la carn del barret.',
      'es':
          'Apretadas, sinuadas a escotadas, de un color azul violáceo o lavanda muy vivo, fácilmente separables de la carne del sombrero.',
      'en':
          'Crowded, sinuate to emarginate, vibrant lilac-violet to lavender, easily separable from the cap flesh.',
    },
    'rubroboletus_satanas': {
      'ca':
          'Tubs grocs i porus molt fins, inicialment groguencs que ràpidament passen a vermell sang o carmí intens. Blavegen lleugerament a la pressió.',
      'es':
          'Tubos amarillos y poros muy finos, inicialmente amarillentos que pronto pasan a rojo sangre o carmín intenso. Azulean suavemente a la presión.',
      'en':
          'Yellow tubes and very fine pores, starting yellowish then rapidly turning deep blood-red or carmine. Bruising faintly blue on pressure.',
    },
    'russula_virescens': {
      'ca':
          'Lliures o adnades, atapeïdes, blanques o crema clar, molt fràgils i trencadisses com el guix (típic del gènere Russula).',
      'es':
          'Libres o adnadas, apretadas, blancas o crema claro, muy frágiles y quebradizas como tiza (típico del género Russula).',
      'en':
          'Free or adnate, crowded, white to pale cream, very brittle and chalky (characteristic of genus Russula).',
    },
    'hygrophorus_eburneus': {
      'ca':
          'Decurrents, espaiades, gruixudes i dures, d\'un color blanc pur immutable que pot groguejar molt lleugerament amb l\'edat.',
      'es':
          'Decurrentes, espaciadas, gruesas y duras, de un blanco puro inmutable que puede amarillear ligeramente con la edad.',
      'en':
          'Decurrent, distant, thick and waxy, pure unchanging white, rarely yellowing faintly with age.',
    },
    'tricholoma_pardinum': {
      'ca':
          'Escotades, juntes, blanquinoses amb reflexos groguencs o verdosos en envellir, sovint suant petites gotetes d\'aigua en temps humit.',
      'es':
          'Escotadas, apretadas, blanquecinas con reflejos amarillentos o verdosos al envejecer, a menudo exudando pequeñas gotitas de agua con humedad.',
      'en':
          'Emarginate, crowded, whitish with yellowish or greenish tints when old, often weeping water droplets in wet weather.',
    },
    'morchella_esculenta': {
      'ca':
          'No té làmines; la part fèrtil (himeni) recobreix l\'interior de les cel·les alvelolars del barret.',
      'es':
          'No tiene láminas; el himenio fértil tapiza el interior de los alvéolos del sombrero.',
      'en':
          'Lacks gills; fertile hymenium lines the interior of the honeycomb alveoli on the cap.',
    },
    'agaricus_campestris': {
      'ca':
          'Lliures, atapeïdes, inicialment d\'un bell color rosa viu o salmó delicat, que amb la maduració de les espores esdevenen marró xocolata fosc o negroses.',
      'es':
          'Libres, apretadas, inicialmente de un hermoso color rosa vivo o salmón delicado, volviéndose marrón chocolate oscuro a negruzco al madurar.',
      'en':
          'Free, crowded, initially bright flesh-pink to delicate salmon, turning dark chocolate-brown to blackish with spore maturity.',
    },
    'agaricus_xanthodermus': {
      'ca':
          'Lliures, serrades, inicialment blanquinoses o rosa molt pàl·lid brut, virant després a bru xocolata grisós fosc.',
      'es':
          'Libres, apretadas, inicialmente blanquecinas o rosa muy pálido sucio, pasando después a pardo chocolate grisáceo oscuro.',
      'en':
          'Free, crowded, initially whitish to pale dull greyish-pink, darkening to dark greyish chocolate-brown.',
    },
    'psathyrella_candolleana': {
      'ca':
          'Adnates, molt atapeïdes, inicialment blanquinoses, passant a lila grisenc pàl·lid i finalment bru porpra fosc.',
      'es':
          'Adnadas, muy apretadas, inicialmente blanquecinas, pasando a lila grisáceo pálido y finalmente pardo púrpura oscuro.',
      'en':
          'Adnate, very crowded, initially whitish, becoming pale greyish-lilac and finally dark purple-brown.',
    },
    'suillus_granulatus': {
      'ca':
          'Format per tubs i porus fins (no làmines), de color groc pàl·lid a groc viu, que en exemplars joves degoten gotetes d\'un líquid lletós blanquinós.',
      'es':
          'Formado por tubos y poros finos (no láminas), amarillo pálido a amarillo vivo, que en ejemplares jóvenes exudan gotitas lechosas blanquecinas.',
      'en':
          'Pores and fine tubes (no gills), pale yellow to bright yellow, exuding tiny milky droplets in young specimens.',
    },
    'hygrophorus_russula': {
      'ca':
          'Subdecurrents a decurrents, una mica ceroses i espaiades, blanques al principi i amb taques vinòs-vermelloses característiques en madurar.',
      'es':
          'Subdecurrentes a decurrentes, algo cerosas y espaciadas, blancas al principio y con manchas vinoso-rojizas características al madurar.',
      'en':
          'Subdecurrent to decurrent, slightly waxy and distant, white initially and developing characteristic vinous-reddish spots with maturity.',
    },
    'boletus_aereus': {
      'ca':
          'Porus fins i arrodonits (tubs), molt atapeïts, de color blanc immaculat en joventut, passant a groc ocre en madurar, sense blavejar al tacte.',
      'es':
          'Poros finos y redondeados (tubos), muy apretados, blanco inmaculado en juventud, pasando a amarillo ocre al madurar, sin azulear.',
      'en':
          'Fine round pores (tubes), very dense, pristine white when young, turning ochre-yellow with age, never staining blue.',
    },
    'coprinus_comatus': {
      'ca':
          'Molt atapeïdes, lliures, amples, inicialment d\'un blanc pur, després rosades des de baix i ràpidament es tornen negres i líquides.',
      'es':
          'Muy apretadas, libres, anchas, inicialmente blanco puro, luego rosadas desde abajo y rápidamente negras y líquidas.',
      'en':
          'Very crowded, free, broad, pure white initially, becoming pinkish from the base and rapidly turning into black liquid ink.',
    },
    'lactarius_torminosus': {
      'ca':
          'Decurrents, juntes, pàl·lides de color crema a rosa blanquinós. En trencar-se exsuden un làtex blanc abundant, immutable a l\'aire i d\'un gust extremadament coent i picant.',
      'es':
          'Decurrentes, apretadas, crema pálido a rosa blanquecino. Al cortarse brota abundante látex blanco inmutable, de sabor extremadamente acre y picante.',
      'en':
          'Decurrent, crowded, pale cream to pinkish-white. Exudes abundant unchanging white latex that is fiercely acrid and peppery.',
    },
    'amanita_pantherina': {
      'ca': 'Lliures, atapeïdes, desiguals, d\'un color blanc pur immutable.',
      'es': 'Libres, apretadas, desiguales, de un blanco puro inmutable.',
      'en': 'Free, crowded, unequal, pure unchanging white.',
    },
    'gyromitra_esculenta': {
      'ca':
          'Sense làmines; l\'himeni fèrtil recobreix tota la superfície externa dels plecs cerebriformes del barret.',
      'es':
          'Sin láminas; el himenio fértil recubre toda la superficie externa de los pliegues cerebriformes del sombrero.',
      'en':
          'No gills; the fertile hymenium lines the entire outer surface of the brain-like convoluted cap folds.',
    },
  };

  static const Map<String, Map<String, String>> _stemDescriptions = {
    'lactarius_deliciosus': {
      'ca':
          'Cilíndric, de color taronja sovint amb escrobícules (petits forats o taques) més fosques. Buit amb l\'edat.',
      'es':
          'Cilíndrico, de color naranja a menudo con escrobículas (pequeñas fositas o manchas) más oscuras. Hueco con la edad.',
      'en':
          'Cylindrical, orange often with darker scrobicules (shallow pits or spots). Hollow with age.',
    },
    'boletus_edulis': {
      'ca':
          'De gruixut i bulbós a cilíndric, de color marró pàl·lid, cobert per un reticle (xarxa) blanquinós evident especialment a la part superior.',
      'es':
          'De grueso y bulboso a cilíndrico, de color marrón pálido, cubierto por un retículo (red) blanquecino evidente en la parte superior.',
      'en':
          'Thick and bulbous to cylindrical, pale brown, covered with a distinct whitish reticulation (netting) especially near the top.',
    },
    'cantharellus_cibarius': {
      'ca':
          'Ple, carnós i llis, aprimant-se cap a la base, del mateix color groc que la resta del bolet.',
      'es':
          'Macizo, carnoso y liso, estrechándose hacia la base, del mismo color amarillo que el resto.',
      'en':
          'Solid, fleshy, and smooth, tapering towards the base, same yellow color as the rest of the fruiting body.',
    },
    'amanita_caesarea': {
      'ca':
          'Cilíndric, de color groc (no blanc), proveït d\'un anell ampli i membranós, penjat, també groc. A la base, hi té un sac blanc ampli (volva) i lliure.',
      'es':
          'Cilíndrico, de color amarillo (no blanco), con anillo amplio membranoso y colgante, también amarillo. En la base, volva blanca amplia en saco.',
      'en':
          'Cylindrical, yellow (not white), with a wide, hanging yellow skirt-like ring. Large, white, sack-like volva at the base.',
    },
    'craterellus_cornucopioides': {
      'ca':
          'Pràcticament inexistent com a estructura separada, és simplement la part inferior de l\'embut, negrenca i buida.',
      'es':
          'Prácticamente inexistente como estructura separada, es la parte inferior del embudo, negruzca y hueca.',
      'en':
          'Indistinct stem, simply the lower tapered portion of the hollow trumpet, blackish and hollow.',
    },
    'macrolepiota_procera': {
      'ca':
          'Molt llarg (pot passar de 30 cm), fibril·lós i tigrat ("serpentí"), acabat en un bulb basal, però SENSE volva en sac. Porta un gran anell doble, gruixut i mòbil (lliscant) com una polsera.',
      'es':
          'Muy largo (hasta más de 30 cm), fibroso y atigrado, con bulbo basal pero SIN volva. Anillo doble, grueso y móvil como un brazalete.',
      'en':
          'Very tall (over 30 cm), fibrous with snakeskin-like zig-zag pattern, bulbous base WITHOUT volva. Features a thick, double, sliding ring.',
    },
    'tricholoma_terreum': {
      'ca':
          'Cilíndric, fibril·lós, generalment blanc a grisenc molt clar, recte i fràgil.',
      'es':
          'Cilíndrico, fibriloso, blanco a grisáceo muy claro, recto y frágil.',
      'en': 'Cylindrical, fibrous, white to pale grey, straight and brittle.',
    },
    'calocybe_gambosa': {
      'ca':
          'Gruixut, robust, massís i generalment curt. Del mateix color del barret o més blanc.',
      'es':
          'Grueso, robusto, macizo y generalmente corto. Del mismo color del sombrero o más blanco.',
      'en':
          'Thick, stout, solid, and typically short. Concolorous with cap or whiter.',
    },
    'pleurotus_ostreatus': {
      'ca':
          'Molt curt, completament excèntric (lateral) o gairebé absent, soldat a la fusta on creix.',
      'es':
          'Muy corto, excéntrico (lateral) o casi ausente, insertado en la madera donde crece.',
      'en':
          'Very short, eccentric (lateral) or almost absent, attached directly to wood.',
    },
    'hydnum_repandum': {
      'ca': 'Gruixut, curt, normalment excèntric i blanquinós.',
      'es': 'Grueso, corto, normalmente excéntrico y blanquecino.',
      'en': 'Thick, stout, usually off-center and whitish.',
    },
    'hygrophorus_latitabundus': {
      'ca':
          'Cilíndric, de color blanc, molt viscós a la meitat inferior fins al naixement (que forma un cert anell viscós limitador, dalt es queda sec).',
      'es':
          'Cilíndrico, blanco, muy viscoso en la mitad inferior hasta una zona anular delimitada (seco arriba).',
      'en':
          'Cylindrical, white, heavily glutinous on lower half up to a distinct slimy annular zone (dry above).',
    },
    'craterellus_lutescens': {
      'ca':
          'Llarg, tubular, fi i buit, d\'un color groc ataronjat molt viu i cridaner.',
      'es':
          'Largo, tubular, fino y hueco, de color amarillo anaranjado muy llamativo.',
      'en': 'Slender, tubular, hollow, bright orange-yellow and eye-catching.',
    },
    'suillus_luteus': {
      'ca':
          'Cilíndric, curt, porta un vistós anell ample que primer és blanc i després vira al lila grisenc o marró violaci.',
      'es':
          'Cilíndrico, corto, con anillo amplio vistoso blanco que vira a violáceo o parduzco.',
      'en':
          'Cylindrical, short, bearing a prominent broad white ring that turns purplish-brown.',
    },
    'russula_cyanoxantha': {
      'ca':
          'Blanc, ferm, sense cap anell ni volva, recte i generalment cilíndric. Carn trencadissa.',
      'es':
          'Blanco, firme, sin anillo ni volva, recto. Carne quebradiza como tiza.',
      'en': 'White, firm, without ring or volva. Brittle, chalk-like flesh.',
    },
    'amanita_muscaria': {
      'ca':
          'Blanc pur. Té un gran anell penjant blanc. La base del peu és bulbosa, normalment voltada de fileres d\'esquames o verrugues blanques, restes de la volva.',
      'es':
          'Blanco puro con gran anillo membranoso colgante. Base bulbosa rodeada de anillos concéntricos de verrugas.',
      'en':
          'Pure white with a large hanging membranous white ring. Bulbous base circled by concentric rings of white warts.',
    },
    'omphalotus_olearius': {
      'ca':
          'Color igual al barret o més fosc, generalment s\'atenua al peu o neix unit a un mateix substrat amb d\'altres (creixement cespitós).',
      'es':
          'Mismo color que el sombrero o más oscuro, estrechándose hacia la base, unidos en ramilletes sobre madera.',
      'en':
          'Concolorous with cap or darker, tapered towards base, joined in dense clusters directly on wood.',
    },
    'entoloma_sinuatum': {
      'ca': 'Massís, blanc, recte però de vegades eixamplat a la base.',
      'es': 'Macizo, blanco, recto pero a menudo engrosado en la base.',
      'en': 'Solid, stout, white, often bulbous at the base.',
    },
    'amanita_phalloides': {
      'ca':
          'Blanc a lleugerament atigrat groc verdós, anell prim blanc en faldilleta penjant, i una volva a la base completament blanca, membranosa, tancada o esberlada formant un sac ampli que no s\'enganxa al bulb.',
      'es':
          'Blanco con dibujo cebrado verdoso, anillo colgante blanco y gran volva membranosa blanca en saco envolvente en la base.',
      'en':
          'White with greenish zig-zag markings, delicate white skirt ring, and a prominent loose white sack-like volva at the base.',
    },
    'amanita_verna': {
      'ca':
          'Tot blanc. Amb un anell blanc penjant fi i, a la base, una gran volva en forma de sac, lliure de la cama i força resistent.',
      'es':
          'Enteramente blanco, con anillo membranoso fino y gran volva blanca en saco en la base.',
      'en':
          'Entirely white, with a delicate white ring and a prominent white sack-like volva at the base.',
    },
    'cortinarius_orellanus': {
      'ca':
          'De color groc i, atenció a aquest tret que el distingeix d\'altres similars, capes de filaments (la cortina) en comptes d\'un autèntic vel al peu; coloració fibril·lar oxidada.',
      'es':
          'Amarillento con fibrillas rojizas y cortina filamentosa fugaz en lugar de anillo membranoso.',
      'en':
          'Yellowish with rust fibrils and a wispy cobweb-like cortina instead of a true ring.',
    },
    'lactarius_sanguifluus': {
      'ca':
          'Curt, cilíndric, atenuat a la base, de color ocre vinós pàl·lid, sovint escrobiculat.',
      'es':
          'Corto, cilíndrico, atenuado en la base, ocre vinoso pálido, a menudo con escrobículas.',
      'en':
          'Short, cylindrical, tapered at base, pale wine-ochre, often with scrobicules.',
    },
    'chroogomphus_rutilus': {
      'ca':
          'De 5 a 10 cm, cilíndric i afilat cap a la base (d\'on rep el nom popular de cama de perdiu). Fibrós, ocre ataronjat o salmó, sovint amb miceli groc llimona a la punta inferior.',
      'es':
          'De 5 a 10 cm, cilíndrico y afilado hacia la base (pata de perdiz). Ocre anaranjado con micelio amarillo limón en la base.',
      'en':
          '5 to 10 cm, cylindrical tapering to a pointed base (partridge leg). Ochre-salmon, often with lemon-yellow mycelium at base.',
    },
    'marasmius_oreades': {
      'ca':
          'De 3 a 7 cm de llarg, molt prim (3-5 mm), cilíndric, tenaç i elàstic (es pot cargolar sobre ell mateix sense trencar-se). Del mateix color que el barret o més clar.',
      'es':
          'De 3 a 7 cm de largo, muy delgado (3-5 mm), cilíndrico, tenaz y elástico (se puede retorcer sobre sí mismo sin romperse). Del mismo color del sombrero o más claro.',
      'en':
          '3 to 7 cm long, very slender (3-5 mm), cylindrical, tough and pliant (can be twisted without breaking). Buff or paler than the cap.',
    },
    'lactarius_chrysorrheus': {
      'ca':
          'Cilíndric, curt, llis, blanquinós a salmó clar, sense escrobícules apreciables.',
      'es':
          'Cilíndrico, corto, liso, blanquecino a salmón claro, sin escrobículas visibles.',
      'en':
          'Cylindrical, short, smooth, whitish to pale salmon, without noticeable scrobicules.',
    },
    'lepista_nuda': {
      'ca':
          'Robust, cilíndric amb base bulbosa coberta de miceli blavós, fibrós, del mateix color violaci que les làmines.',
      'es':
          'Robusto, cilíndrico con base bulbosa cubierta de micelio azulado, fibroso, del mismo color violáceo que las láminas.',
      'en':
          'Robust, cylindrical with a swollen base covered in violet mycelial down, fibrous, violet like the gills.',
    },
    'rubroboletus_satanas': {
      'ca':
          'Molt gros, inflat, obès o esfèric a la base. Groc a la part alta i vermell carmí o porpra al centre i base, cobert d\'un reticle fi.',
      'es':
          'Muy grueso, hinchado, obeso o esférico en la base. Amarillo en la parte alta y rojo carmín o púrpura al centro y base, con fino retículo.',
      'en':
          'Very stout, bulbous, swollen or spherical at base. Yellow near top, carmine or purple-red in middle and base, adorned with a fine net.',
    },
    'russula_virescens': {
      'ca':
          'Robust, cilíndric, massís, blanc pur, rugós, que es trenca netament com una barra de guix.',
      'es':
          'Robusto, cilíndrico, macizo, blanco puro, rugoso, que se rompe netamente como una barra de tiza.',
      'en':
          'Robust, cylindrical, solid, pure white, rugged, snapping cleanly like a stick of chalk.',
    },
    'hygrophorus_eburneus': {
      'ca':
          'De 5 a 10 cm, cilíndric, atenuat cap a la base, blanc, molt viscós com el barret, amb petites granulacions a la part superior.',
      'es':
          'De 5 a 10 cm, cilíndrico, atenuado hacia la base, blanco, muy viscoso como el sombrero, con finas granulaciones en el ápice.',
      'en':
          '5 to 10 cm, cylindrical, tapering towards the base, white, very slimy like the cap, with fine granules at the apex.',
    },
    'tricholoma_pardinum': {
      'ca':
          'Gruixut, massís, blanc a ocre clar, atenuat o bulbós cap a la base, molt més gros i sòlid que el del fredolic comú.',
      'es':
          'Grueso, macizo, blanco a ocre claro, atenuado o bulboso hacia la base, mucho más grueso y sólido que el de la negrilla común.',
      'en':
          'Thick, solid, white to pale buff, tapering or swollen at base, much stouter and firmer than the grey knight.',
    },
    'morchella_esculenta': {
      'ca':
          'De 3 a 8 cm, blanc a crema clar, cilíndric, engruixit a la base, buit per dins en continuïtat directa amb el barret.',
      'es':
          'De 3 a 8 cm, blanco a crema claro, cilíndrico, engrosado en la base, hueco por dentro en continuidad directa con el sombrero.',
      'en':
          '3 to 8 cm, white to pale cream, cylindrical, enlarged at base, hollow inside in direct continuity with the cap.',
    },
    'agaricus_campestris': {
      'ca':
          'De 3 a 7 cm, cilíndric, blanc, atenuat a la base, amb un anell membranós simple, fràgil i fugaç que sovint desapareix en envellir.',
      'es':
          'De 3 a 7 cm, cilíndrico, blanco, atenuado en la base, con anillo membranoso simple, frágil y fugaz que a menudo desaparece al envejecer.',
      'en':
          '3 to 7 cm, cylindrical, white, tapering at the base, with a delicate single membranous ring that often collapses or falls away with age.',
    },
    'agaricus_xanthodermus': {
      'ca':
          'De 6 a 12 cm, blanc, esvelt, amb un anell doble i ample en faldó. La base té un bulb prominent que al tall o rascada es tenyeix immediatament de groc sofre o crom elèctric molt intens.',
      'es':
          'De 6 a 12 cm, blanco, esbelto, con anillo doble y amplio en falda. La base bulbosa se tiñe inmediatamente de amarillo cromo eléctrico al corte o roce.',
      'en':
          '6 to 12 cm, white, slender, with a broad skirt-like double ring. The bulbous base stains intensely chrome-yellow immediately when cut or scratched.',
    },
    'psathyrella_candolleana': {
      'ca':
          'De 4 a 9 cm, molt prim (3-6 mm), blanc sedós, buit, cilíndric, extremadament trencadís i delicat, sense anell persistent.',
      'es':
          'De 4 a 9 cm, muy delgado (3-6 mm), blanco sedoso, hueco, cilíndrico, sumamente quebradizo y delicado, sin anillo persistente.',
      'en':
          '4 to 9 cm, very slender (3-6 mm), silky white, hollow, cylindrical, extremely brittle and fragile, without persistent ring.',
    },
    'suillus_granulatus': {
      'ca':
          'De 4 a 8 cm, cilíndric, massís, groguenc, sense anell. Presenta característiques granulacions o punts petits de color marró ocre a la part superior.',
      'es':
          'De 4 a 8 cm, cilíndrico, macizo, amarillento, sin anillo. Presenta granulaciones o punteaduras características de color pardo ocre en la parte superior.',
      'en':
          '4 to 8 cm, cylindrical, solid, yellowish, ringless. Dotted at the apex with characteristic fine brownish-orange granules (glandular dots).',
    },
    'hygrophorus_russula': {
      'ca':
          'De 4 a 9 cm, curt, robust, massís, atenuat a la base, blanc tacat o pigat de vermell vinós a la part mitjana i inferior.',
      'es':
          'De 4 a 9 cm, corto, robusto, macizo, atenuado en la base, blanco manchado o moteado de rojo vinoso en la parte media e inferior.',
      'en':
          '4 to 9 cm, stout, robust, solid, tapering at base, white flecked or mottled with vinous-red spots on the lower half.',
    },
    'boletus_aereus': {
      'ca':
          'De 6 a 14 cm, molt corpulent, ventrut o bulbós, de color bru canyella clar o ocre daurat, cobert d\'un fi reticle blanc a la part superior.',
      'es':
          'De 6 a 14 cm, muy corpulento, ventrudo o bulboso, pardo canela claro u ocre dorado, cubierto de un fino retículo blanco en la parte superior.',
      'en':
          '6 to 14 cm, very stout, ventricose or bulbous, pale cinnamon-brown to golden-ochre, covered with a delicate white network (reticulum) above.',
    },
    'coprinus_comatus': {
      'ca':
          'De 8 a 20 cm, esvelt, buit, fibrós, blanc sedós, atenuat cap a dalt amb un bulb basal i un petit anell mòbil que sovint cau a la base.',
      'es':
          'De 8 a 20 cm, esbelto, hueco, fibroso, blanco sedoso, atenuado arriba con bulbo basal y un pequeño anillo móvil que a menudo cae hacia la base.',
      'en':
          '8 to 20 cm, tall, slender, hollow, fibrous, silky white with a bulbous base and a narrow movable white ring that often slides down.',
    },
    'lactarius_torminosus': {
      'ca':
          'De 3 a 7 cm, cilíndric, buit, dur, de color rosa pàl·lid o groguenc clar, sovint amb petits clotets foscos (escrobícules).',
      'es':
          'De 3 a 7 cm, cilíndrico, hueco, duro, rosa pálido o amarillento claro, a menudo con pequeñas fositas oscuras (escrobículas).',
      'en':
          '3 to 7 cm, cylindrical, hollow, firm, pale pink to light yellowish, often pitted with small shallow dark spots (scrobiculate).',
    },
    'amanita_pantherina': {
      'ca':
          'De 6 a 12 cm, cilíndric, blanc, atenuat cap amunt. Té un anell membranós blanc baix i penjant, i una base bulbosa arrodonida envoltada per 1 o 2 anells concèntrics o rodetes helicoïdals (volva dissociada en collarets).',
      'es':
          'De 6 a 12 cm, cilíndrico, blanco, atenuado hacia arriba. Posee anillo membranoso bajo y colgante, y base bulbosa rodeada de 1 o 2 rodetes helicoidales concéntricos (volva en collares).',
      'en':
          '6 to 12 cm, cylindrical, white, tapering upward. Features a low hanging white membranous ring and a swollen base encircled by 1-2 distinct stepped rim gutters (volva collars).',
    },
    'gyromitra_esculenta': {
      'ca':
          'De 3 a 6 cm, curt, gruixut, buit, irregularment arrugat, de color blanc a ocre groguenc pàl·lid.',
      'es':
          'De 3 a 6 cm, corto, grueso, hueco, irregularmente arrugado, de color blanco a ocre amarillento pálido.',
      'en':
          '3 to 6 cm, short, stout, hollow, irregularly grooved/wrinkled, whitish to pale yellowish-ochre.',
    },
    'hygrophorus_personii': {
      'ca':
          'Esvelt, cilíndric i atenuat a la base. Blanc a la part superior i cobert d\'una beina viscosa amb dibuix tigrat bru olivaci per sota.',
      'es':
          'Esbelto, cilíndrico atenuado en la base. Blanco arriba y cubierto por una vaina viscosa atigrada pardo-olivácea abajo.',
      'en':
          'Slender, cylindrical tapering at base. White at apex, covered below in a viscid olive-brown snake-skin sheath.',
    },
    'pleurotus_eryngii': {
      'ca':
          'Gruixut, robust, massís, sovint excèntric, blanc a blanquinós atenuat a la base.',
      'es':
          'Grueso, robusto, macizo, a menudo excéntrico, blanco a blanquecino atenuado en la base.',
      'en':
          'Thick, stout, solid, often eccentric, white to off-white tapering at base.',
    },
    'lactarius_semisanguifluus': {
      'ca':
          'Curt, cilíndric, ataronjat amb petites escrobícules vinoses, buit amb l\'edat.',
      'es':
          'Corto, cilíndrico, anaranjado con pequeñas escrobículas vinosas, hueco de adulto.',
      'en':
          'Short, cylindrical, orange with small vinaceous pits, hollow when mature.',
    },
    'suillus_bellinii': {
      'ca':
          'Curt, rabassut, cilíndric, blanquinós cobert de granulacions i punts vermellosos/carmí molt evidents. Sense anell.',
      'es':
          'Corto, robusto, blanquecino densamente cubierto de granulaciones y puntos rojizo-carmín. Sin anillo.',
      'en':
          'Short, stout, off-white densely covered in crimson-brown glandular dots. Ringless.',
    },
    'tricholoma_equestre': {
      'ca':
          'Robust, sòlid, cilíndric, del mateix color groc que les làmines o lleugerament més pàl·lid, sense anell.',
      'es':
          'Robusto, macizo, cilíndrico, del mismo amarillo que las láminas o algo más pálido, sin anillo.',
      'en':
          'Stout, solid, cylindrical, sulfur-yellow like the gills, without any ring.',
    },
    'amanita_virosa': {
      'ca':
          'Alt, esvelt, blanc, cobert d\'esquames llanoses o flocoses marcades, amb un anell blanc estriat penjant i volva en sac a la base.',
      'es':
          'Alto, esbelto, blanco, cubierto de escamas lanosas muy visibles, con anillo membranoso colgante y volva en saco.',
      'en':
          'Tall, slender, white, covered in shaggy floccose scales, with a hanging ragged ring and saccate volva.',
    },
    'galerina_marginata': {
      'ca':
          'Prim, fibril·lós, bru fosc amb fibril·les blanquinoses a la part inferior i un anell membranós fugaç estret a la part superior.',
      'es':
          'Delgado, fibrilloso, pardo oscuro con fibrillas plateadas abajo y un anillo membranoso estrecho arriba.',
      'en':
          'Slender, fibrous, dark brown with silvery fibrils below and a delicate narrow membranous ring above.',
    },
  };

  static const Map<String, Map<String, String>> _latexDescriptions = {
    'lactarius_deliciosus': {
      'ca':
          'Abundant, de color pastanaga clar, immutablement taronja. Amb gust suau o lleugerament acre.',
      'es':
          'Abundante, de color zanahoria claro, inmutablemente naranja. Sabor suave o ligeramente acre.',
      'en':
          'Abundant, bright carrot-orange, unchanging. Mild to slightly acrid taste.',
    },
    'lactarius_sanguifluus': {
      'ca': 'De color vermell vinós o sang fosc, de gust dolç o suau.',
      'es': 'De color rojo vinoso o sangre oscuro, de sabor dulce o suave.',
      'en': 'Deep wine-red or bloody dark red, mild or pleasant taste.',
    },
    'lactarius_chrysorrheus': {
      'ca':
          'Làtex blanc abundant que vira a groc sofre intens en pocs segons. Molt picant i amarg.',
      'es':
          'Látex blanco abundante que vira a amarillo azufre intenso en pocos segundos. Muy picante y amargo.',
      'en':
          'Abundant white latex rapidly turning bright sulfur-yellow within seconds. Very acrid and peppery.',
    },
    'lactarius_torminosus': {
      'ca':
          'Làtex blanc abundant, immutable a l\'aire, d\'un gust extremadament coent, picant i acre.',
      'es':
          'Látex blanco abundante, inmutable al aire, de sabor extremadamente acre y picante.',
      'en':
          'Abundant white latex, unchanging in air, fiercely acrid, burning and peppery.',
    },
  };

  static const Map<String, Map<String, String>> _safetyNotes = {
    'lactarius_deliciosus': {
      'ca':
          'Atenció: diferent dels falsos rovellons tòxics com el Lactarius chrysorrheus (de làtex blanc que es torna groc) i d\'espècies similars però menys valorades (L. sanguifluus, L. semisanguifluus).',
      'es':
          'Atención: diferente de los falsos níscalos tóxicos como el Lactarius chrysorrheus (látex blanco que vira a amarillo) y de especies afines comestibles (L. sanguifluus, L. semisanguifluus).',
      'en':
          'Warning: distinguished from toxic false milk caps like Lactarius chrysorrheus (white latex turning yellow) and edible relatives (L. sanguifluus, L. semisanguifluus).',
    },
    'boletus_edulis': {
      'ca':
          'Pot confondre\'s amb el mataparent amarg (Tylopilus felleus), que té porus rosats de gran i un reticle molt marcat, a més d\'un gust extremadament amarg.',
      'es':
          'Puede confundirse con el boleto amargo (Tylopilus felleus), que tiene poros rosados al madurar, un retículo muy marcado y un sabor extremadamente amargo.',
      'en':
          'Can be confused with the bitter bolete (Tylopilus felleus), which has pinkish pores when mature, prominent brown netting, and an extremely bitter taste.',
    },
    'cantharellus_cibarius': {
      'ca':
          'Precaució de no confondre amb la Gírgola d\'olivera (Omphalotaceae), que és tòxica, creix sobre fusta i té làmines de veritat fines en lloc de plecs gruixuts.',
      'es':
          'Precaución de no confundir con la seta de olivo (Omphalotus olearius), que es tóxica, crece sobre madera y tiene láminas verdaderas y finas en lugar de pliegues.',
      'en':
          'Caution: do not confuse with the toxic Jack-o\'-lantern (Omphalotus olearius), which grows on wood and has true, sharp gills rather than blunt folds.',
    },
    'amanita_caesarea': {
      'ca':
          'Possible confusió mortal o perillosa amb Amanita muscaria, que té peu blanc (no groc), làmines blanques (no grogues), marge no estriat i normalment restes blanques sobre el barret.',
      'es':
          'Peligro de confusión con la matamoscas (Amanita muscaria), que tiene pie blanco, láminas blancas, margen no estriado y escamas blancas sobre el sombrero.',
      'en':
          'Dangerous confusion with Fly Agaric (Amanita muscaria), which has white stem, white gills, non-striate margin, and white warts on the cap.',
    },
    'craterellus_cornucopioides': {
      'ca':
          'Molt característic, difícil de confondre, sobretot en el seu estat fresc o assecat.',
      'es':
          'Muy característico, difícil de confundir, especialmente en estado fresco o deshidratado.',
      'en': 'Highly distinctive and unmistakable, both fresh and dried.',
    },
    'macrolepiota_procera': {
      'ca':
          'No confondre amb lepiotes de mida petita (menys de 10 cm) moltes de les quals són mortals. La característica de l\'anell mòbil és fonamental.',
      'es':
          'No confundir con lepiotas pequeñas (menos de 10 cm), muchas de las cuales son mortales. El anillo móvil y deslizante es fundamental.',
      'en':
          'Never confuse with small Lepiota species (under 10 cm), many of which are deadly. The sliding ring is an essential field identification key.',
    },
    'tricholoma_terreum': {
      'ca':
          'Fàcilment confusible amb altres Tricholoma grisos, alguns dels quals són lleugerament tòxics (com el T. pardinum) que solen ser molt més robustos. Important fixar-se en l\'aspecte de "ratolí" i fragilitat general.',
      'es':
          'Fácilmente confundible con otros Tricholoma grises tóxicos como T. pardinum (mucho más robusto). Fijarse en el aspecto de "ratón" y fragilidad.',
      'en':
          'Easily confused with other grey Tricholoma, including the toxic T. pardinum (much more robust). Note the mouse-fur texture and fragile flesh.',
    },
    'calocybe_gambosa': {
      'ca':
          'Olor inconfusible a farina fresca. Vigilar amb bolets primaverals mortals blancs (Entoloma, algunes Inocybe) que generalment no tenen l\'olor a farina o esporen en altres colors (el pèrfid espora en rosa).',
      'es':
          'Olor inconfundible a harina fresca. Cuidado con setas primaverales tóxicas blancas (Entoloma, Inocybe) que no huelen a harina o tienen esporada rosada.',
      'en':
          'Unmistakable strong fresh meal (floury) odor. Beware of toxic spring species (Entoloma, Inocybe) which lack meal aroma and have pink/brown spores.',
    },
    'pleurotus_ostreatus': {
      'ca':
          'Es cria sobre troncs morts. Confusió (tot i ser força diferent) amb Omphalotus olearius, tòxica, que és molt ataronjada i de zones menys fredes.',
      'es':
          'Crece sobre troncos muertos. Posible confusión con Omphalotus olearius (tóxica), que es naranja intenso y crece en ambientes más cálidos.',
      'en':
          'Grows on dead logs. Possible confusion with toxic Omphalotus olearius, which is bright orange-yellow and warm-climate oriented.',
    },
    'hydnum_repandum': {
      'ca':
          'Pràcticament inconfusible per la presència d\'agulles (fiblons) inferiors fàcilment desprenibles i el color general.',
      'es':
          'Prácticamente inconfundible por sus espinas o púas inferiores fácilmente desprendibles.',
      'en':
          'Virtually unmistakable due to fragile under-cap spines (teeth) that detach readily.',
    },
    'hygrophorus_latitabundus': {
      'ca': 'És la varietat reina de les llenegues; excel·lent per cuinar.',
      'es':
          'La reina de las llanegas; excelente comestible muy apreciado en guisos.',
      'en':
          'The prized black slimy cap; highly esteemed edible mushroom in Catalan cuisine.',
    },
    'craterellus_lutescens': {
      'ca':
          'Surt a milers on apareix, no hi ha espècies perilloses similars amb cama groga i fina sense autèntiques làmines.',
      'es':
          'Aparece en grandes grupos; no existen especies peligrosas similares con pie amarillo fino y sin láminas verdaderas.',
      'en':
          'Abundant in pine needle litter; no dangerous lookalikes sharing the bright yellow hollow stem and vein-like hymenium.',
    },
    'suillus_luteus': {
      'ca':
          'Tot i classificar-se com comestible pelant bé la cutícula, té molt poc valor culinari.',
      'es':
          'Comestible si se retira la cutícula viscosa (laxante), pero de escaso valor culinario.',
      'en':
          'Edible after peeling the slimy skin (which is laxative), but of mediocre culinary value.',
    },
    'russula_cyanoxantha': {
      'ca': 'Es pot consumir, però no s\'aprecia gaire a la cuina.',
      'es':
          'Comestible de buena calidad; asegurarse de que las láminas son flexibles y no quebradizas.',
      'en':
          'Good edible; ensure gills are flexible and non-brittle to confirm identity.',
    },
    'amanita_muscaria': {
      'ca':
          'Molt tòxic, té efectes psicoactius, al·lucinògens, nàusees fortes i vòmits intensos. Possible confusió amb l\'ou de reig quan les pluges en renten els punts blancs, però la muscaria manté làmines blanques (no grogues).',
      'es':
          'Tóxica (efectos neurotóxicos y gastrointestinales severos). Peligro de confusión con la oronja cuando la lluvia lava las verrugas (pero tiene láminas blancas, no amarillas).',
      'en':
          'Toxic (causes severe gastrointestinal distress and neurotoxic delirium). Danger of confusion with Caesar\'s mushroom when rain washes off white spots (gills remain white, not yellow).',
    },
    'omphalotus_olearius': {
      'ca':
          'Molt tòxic, especialment del tracte gastrointestinal, si es confon amb el rossinyol (C. cibarius), del qual es distingeix per viure en fusta, color fosc i làmines veritables, no plecs.',
      'es':
          'Gravemente tóxica (severa intoxicación gastrointestinal). Diferenciar del rebozuelo: crece sobre madera y tiene láminas verdaderas.',
      'en':
          'Severely toxic (causes violent vomiting and stomach cramps). Distinct from chanterelles: grows on wood and has true sharp gills.',
    },
    'entoloma_sinuatum': {
      'ca':
          'Provoca toxicitat greu intestinal crònica i nàusees agudes. Olor de farina rància, a diferència de la farina fresca del Moixernó (Calocybe gambosa), l\'esporada (la pols que allibera) és rosa, mentre el Moixernó l\'espora és blanca.',
      'es':
          'Provoca intoxicación gastrointestinal grave. Huele a harina rancia (no fresca como la seta de San Jorge) y tiene esporada rosa, no blanca.',
      'en':
          'Causes severe poisoning with intense gastrointestinal syndrome. Odor is rancid flour (unlike fresh meal of Calocybe gambosa); spore print is pink, not white.',
    },
    'amanita_phalloides': {
      'ca':
          'MORTAL. Conté amatoxines; la dosi d\'un sol bolet petit destrueix el fetge i produeix la mort en diversos dies després d\'un període sense símptomes d\'unes hores.',
      'es':
          'MORTAL. Contiene amatoxinas; un solo ejemplar destruye el hígado causando fallo multiorgánico tras horas de latencia.',
      'en':
          'DEADLY. Contains lethal amatoxins; a single cap causes fatal liver and kidney destruction after a deceptive latency period.',
    },
    'amanita_verna': {
      'ca':
          'MORTAL. Surt a la primavera (vernal). Similar a l\'A. phalloides però tota de blanc integral, s\'assembla erròniament a molts xampinyons bords o bolets de prat comestibles joves (però aquests no tenen volva en sac).',
      'es':
          'MORTAL. Fructifica en primavera. Peligro extremo de confusión con champiñones silvestres jóvenes (estos carecen de volva).',
      'en':
          'DEADLY. Fruits in spring. Lethal risk of confusion with young field mushrooms/champignons (which never have a basal sack volva).',
    },
    'cortinarius_orellanus': {
      'ca':
          'MORTAL. La toxina orellanina, extremadament perillosa per la seva acció molt retardada (dies o més de 2 setmanes sense símptomes greus per presentar llavors dany renal catastròfic generalment fatal).',
      'es':
          'MORTAL. Contiene orellanina; causa fallo renal fulminante tras un periodo de incubación prolongado de hasta dos semanas.',
      'en':
          'DEADLY. Contains orellanine; destroys kidneys after a severe delayed incubation of several days to over two weeks.',
    },
    'lactarius_sanguifluus': {
      'ca':
          'Comestible excel·lent, molt apreciat com el pinetell. Es distingeix pel seu làtex de color sang o vi fosc.',
      'es':
          'Comestible excelente, muy apreciado en Cataluña. Se distingue por su látex de color sangre o vino tinto.',
      'en':
          'Choice edible, highly prized. Distinguished by its deep blood-red or dark wine latex.',
    },
    'chroogomphus_rutilus': {
      'ca':
          'Comestible de bon gust. La seva carn de color salmó es torna d\'un color violaci o porpra molt fosc i característic en cuinar-se. Es distingeix dels cortinaris verinosos per les seves làmines fortament decurrents i per no tenir cortina.',
      'es':
          'Comestible apreciado. Su carne salmón vira a morado oscuro característico al cocinarse. Se diferencia de cortinarios tóxicos por sus láminas muy decurrentes y ausencia de cortina.',
      'en':
          'Good edible. Salmon flesh turns distinct dark violet-purple upon cooking. Distinguished from toxic Cortinarius by deeply decurrent gills and lack of cortina.',
    },
    'marasmius_oreades': {
      'ca':
          'Excel·lent comestible, clau en el fricandó tradicional. Atenció: no confondre amb clitocibes blancs tòxics de prat (Clitocybe dealbata, C. rivulosa), que tenen làmines molt juntes i decurrents i cama fràgil no elàstica.',
      'es':
          'Excelente comestible, esencial en guisos tradicionales. Atención: no confundir con clitocibes blancos tóxicos de prado (Clitocybe dealbata, C. rivulosa), de láminas apretadas y decurrentes y pie frágil.',
      'en':
          'Excellent edible, cherished in traditional Catalan fricandó. Caution: do not confuse with toxic white lawn clitocybes (Clitocybe dealbata, C. rivulosa), which have crowded decurrent gills and brittle stems.',
    },
    'lactarius_chrysorrheus': {
      'ca':
          'TÒXIC. Provoca trastorns gastrointestinals severs. És la confusió més freqüent amb el rovelló (L. deliciosus); es distingeix fàcilment perquè el seu làtex és blanc i es torna groc sofre, mai taronja ni vinós.',
      'es':
          'TÓXICO. Provoca trastornos gastrointestinales severos. Es la confusión más frecuente con el níscalo (L. deliciosus); se distingue porque su látex es blanco y vira a amarillo azufre, nunca naranja.',
      'en':
          'TOXIC. Causes acute gastrointestinal distress. It is the most common toxic lookalike of the saffron milk cap (L. deliciosus); distinguished easily by its white latex turning sulfur-yellow, never orange.',
    },
    'lepista_nuda': {
      'ca':
          'Bon comestible prèvia cocció (tòxic en cru com molts bolets). Té una forta olor afruitada o anisada agradable. Es diferencia dels cortinaris violacis per la seva esporada blanca-rosada i per l\'absència total de cortina.',
      'es':
          'Buen comestible previa cocción (tóxico en crudo). Agradable olor afrutado. Se diferencia de los cortinarios violetas por su esporada blanquecina-rosada y por la ausencia total de cortina.',
      'en':
          'Good edible when well cooked (toxic raw). Pleasant fruity fragrance. Distinguished from violet webcaps by pale pinkish-white spores and complete lack of a cortina.',
    },
    'rubroboletus_satanas': {
      'ca':
          'TÒXIC. Causa intoxicacions gastrointestinals severes amb vòmits i deshidratació. Olor desagradable a carronya en envellir. Confusió perillosa amb el cep (Boletus edulis); es diferencia pel barret blanquinós i els porus vermell sang.',
      'es':
          'TÓXICO. Causa severa intoxicación gastrointestinal con vómitos intensos. Olor desagradable al envejecer. Peligrosa confusión con el boletus (B. edulis); se distingue por el sombrero blanquecino y poros rojo sangre.',
      'en':
          'TOXIC. Causes severe gastroenteritis with heavy vomiting. Unpleasant cadaverous odor when old. Dangerous confusion with Porcini (B. edulis); recognized by its pale chalky cap and vivid blood-red pores.',
    },
    'russula_virescens': {
      'ca':
          'Excel·lent comestible, una de les millors llores de Catalunya. ALERTA VITAL: cal no confondre amb la farinera borda (Amanita phalloides), que també pot tenir el barret verdós, però la farinera té anell, volva i carn fibrosa (mai trencadissa com el guix).',
      'es':
          'Excelente comestible, una de las mejores rúsulas. ALERTA VITAL: no confundir con la mortal oronja verde (Amanita phalloides), que también tiene sombrero verdoso pero posee anillo, volva y carne fibrosa (nunca quebradiza).',
      'en':
          'Choice edible, one of the finest brittlegills. CRITICAL WARNING: do not confuse with the deadly Death Cap (Amanita phalloides), which may have a greenish cap but always has a ring, volva, and fibrous non-crumbly flesh.',
    },
    'hygrophorus_eburneus': {
      'ca':
          'Comestible tradicional molt apreciat a les comarques interiors, germana de la llenega negra (H. latitabundus). Olor característica suau i agradable. Es renta la cutícula viscosa abans de cuinar.',
      'es':
          'Comestible tradicional apreciado en comarcas interiores, hermana de la llanega negra (H. latitabundus). Agradable olor suave. Se retira la viscosidad antes de cocinar.',
      'en':
          'Traditional edible prized alongside the black slimy cap (H. latitabundus). Subtle pleasant scent. Viscid cuticle is wiped or washed before culinary preparation.',
    },
    'tricholoma_pardinum': {
      'ca':
          'TÒXIC GRAU. Causa greus gastroenteritis amb vòmits incoercibles i forta deshidratació. Gran perill de confusió amb el fredolic (T. terreum); es diferencia per ser molt més massís i gran, amb esquames gruixudes concèntriques i peu no buit i fràgil.',
      'es':
          'TÓXICO GRAVE. Causa severa gastroenteritis con vómitos incoercibles. Gran peligro de confusión con la negrilla (T. terreum); se diferencia por ser mucho más macizo y grande, con escamas concéntricas y pie robusto.',
      'en':
          'SEVERELY TOXIC. Causes intense gastrointestinal distress with violent vomiting. Dangerous confusion with grey knight (T. terreum); distinguished by its massive robust stature, prominent concentric scales, and solid stem.',
    },
    'morchella_esculenta': {
      'ca':
          'EXCEL·LENT COMESTIBLE PRIMAVERAL molt cotitzat. ATENCIÓ: és tòxica en cru (conté hemolisines); cal coure-la bé o assecar-la abans del consum. Compte amb el bolet de greix (Gyromitra esculenta), que té plecs cerebriformes (no alvèols) i és altament perillós.',
      'es':
          'EXCELENTE COMESTIBLE PRIMAVERAL muy cotizado. ATENCIÓN: tóxica en crudo (contiene hemolisinas); debe cocinarse a fondo o desecarse. Cuidado con la falsa colmenilla (Gyromitra esculenta), de pliegues cerebriformes y muy peligrosa.',
      'en':
          'CHOICE SPRING EDIBLE highly prized. CAUTION: toxic when raw (contains hemolysins); must be thoroughly cooked or dried before consumption. Beware of false morels (Gyromitra esculenta), which have brain-like folds and are toxic.',
    },
    'agaricus_campestris': {
      'ca':
          'Molt bon comestible tradicional dels prats i clarianes de bosc. ATENCIÓ: no confondre amb el xampinyó groguenc (A. xanthodermus), que grogueja intensament a la base del peu i fa olor de tinta/fenol, ni amb les amanites blanques mortals (A. verna, A. phalloides), que tenen sempre làmines blanques i volva a la base.',
      'es':
          'Muy buen comestible tradicional de prados y claros de bosque. ATENCIÓN: no confundir con el champiñón amarilleante (A. xanthodermus), que amarillea intensamente en la base y huele a tinta/fenol, ni con amanitas blancas mortales (A. verna, A. phalloides), de láminas blancas y volva.',
      'en':
          'Choice traditional edible of meadows and grassy forest clearings. CAUTION: do not confuse with yellow-stainer (A. xanthodermus), which stains bright chrome-yellow at base and smells of phenol/ink, nor with deadly white amanitas (A. verna, A. phalloides), which always have pure white gills and a basal volva.',
    },
    'agaricus_xanthodermus': {
      'ca':
          'TÒXIC GASTROINTESTINAL. Causa nàusees, vòmits i dolors abdominals aguts. Es reconeix infal·liblement pel fort viratge a groc crom de la base del peu i per una olor penetrant i desagradable de tinta, iode o àcid fènol, que s\'intensifica fortament en coure\'s.',
      'es':
          'TÓXICO GASTROINTESTINAL. Causa náuseas, vómitos y fuertes dolores abdominales. Se reconoce por el rápido viraje a amarillo cromo en la base del pie y por su penetrante olor a tinta o fenol, que se intensifica al calentarse.',
      'en':
          'GASTROINTESTINALLY TOXIC. Causes nausea, vomiting and acute abdominal cramps. Infallibly identified by the instant chrome-yellow bruising at the base of the stipe and an unpleasant carbolic/ink odor that intensifies when heated.',
    },
    'psathyrella_candolleana': {
      'ca':
          'Sense interès culinari per la seva carn prima i fràgil, tot i que no és tòxica. Creix sovint en flotes nombroses vora soques podrides, fusta enterrada o prats sota pins (Pinus halepensis) i planifolis.',
      'es':
          'Sin valor culinario por su carne delgada y frágil, aunque no es tóxica. Crece en grupos numerosos sobre madera enterrada o bajo pinos (Pinus halepensis) y frondosas.',
      'en':
          'Inedible / no culinary value due to thin, fragile flesh, though not toxic. Frequently grows in dense clusters on buried wood or lawns under pines (Pinus halepensis) and broadleaf trees.',
    },
    'suillus_granulatus': {
      'ca':
          'Comestible apreciat si es pela la cutícula viscosa (que té efectes lleugerament laxants) i s\'eliminen els tubs tous. És el molleric més abundant i característic dels boscos de pi blanc (Pinus halepensis) a tot el litoral i prelitoral català.',
      'es':
          'Comestible apreciado retirando la cutícula viscosa (ligeramente laxante) y los tubos blandos. Es el boleto más abundante y característico de los pinares de pino carrasco (Pinus halepensis) en el litoral y prelitoral.',
      'en':
          'Prized edible when the slimy cuticle (which has mild laxative effects) is peeled away and spongy tubes removed. The classic companion of Aleppo pine (Pinus halepensis) across the Mediterranean coast.',
    },
    'hygrophorus_russula': {
      'ca':
          'EXCEL·LENT COMESTIBLE TRADICIONAL molt valorat a la cuina catalana ("el rei de la cassola"), ideal per a guisats de carn. Olor suau fúngica i gust lleugerament amargant que s\'esvaeix amb una bona cocció. Creix en alzinars i rouredes tèbies.',
      'es':
          'EXCELENTE COMESTIBLE TRADICIONAL muy apreciado en la cocina catalana ("el rei de la cassola"), ideal para guisados. Olor fúngico suave y sabor ligeramente amargo que desaparece con la cocción. Crece en encinares y robledales.',
      'en':
          'TRADITIONAL CHOICE EDIBLE highly celebrated in Catalan cuisine ("king of the casserole"), ideal for hearty stews. Mild mushroom aroma and pleasantly bitter taste that turns savory with thorough cooking. Grows in warm oak forests.',
    },
    'boletus_aereus': {
      'ca':
          'EXCEL·LENT COMESTIBLE DE MÀXIMA QUALITAT, considerat per molts boletaires el millor dels ceps per la seva carn blanca, dura i intensament aromàtica. Termòfil, típic dels alzinars, suredes i rouredes mediterrànies.',
      'es':
          'EXCELENTE COMESTIBLE DE MÁXIMA CALIDAD, considerado por muchos el mejor de los boletus por su carne blanca, dura e intensamente aromática. Termófilo, típico de encinares, alcornocales y robledales.',
      'en':
          'PRIME QUALITY CHOICE EDIBLE, revered as the finest of all Porcini boletes for its dense, firm white flesh and extraordinary aroma. Thermophilic, characteristic of Mediterranean oak and cork woods.',
    },
    'coprinus_comatus': {
      'ca':
          'DELICIÓS COMESTIBLE QUAN ÉS JOVE (quan les làmines són completament blanques). S\'ha de cuinar ràpidament després de la collita abans que comenci a liquefactar-se. A diferència del coprí gris (Coprinopsis atramentaria), aquest NO conté coprina i es pot consumir amb alcohol amb moderació.',
      'es':
          'DELICIOSO COMESTIBLE JOVEN (mientras las láminas permanezcan completamente blancas). Cocinar poco después de cosechar antes de que licúe. A diferencia del coprino antialcohólico, NO contiene coprina.',
      'en':
          'DELICIOUS EDIBLE WHEN YOUNG (while gills remain pure white). Must be prepared soon after foraging before it deliquesces into black ink. Unlike the inky cap, this species does NOT contain coprine and is safe with alcohol.',
    },
    'lactarius_torminosus': {
      'ca':
          'TÒXIC GRAU. Provoca còlics dolorosos, nàusees i gastroenteritis severa (síndrome resinoidiana). Es distingeix clarament del rovelló (L. deliciosus) pel seu marge abundantment llanós i pel làtex blanc i extremadament picant (mai taronja).',
      'es':
          'TÓXICO GRAVE. Provoca cólicos dolorosos, náuseas y gastroenteritis severa (síndrome resinoidiano). Se distingue del níscalo (L. deliciosus) por su margen densamente lanoso y látex blanco muy picante.',
      'en':
          'SEVERELY TOXIC. Causes painful gastrointestinal poisoning with vomiting and colic. Distinctly separated from Saffron Milk Cap (L. deliciosus) by its shaggy woolly margin and burning white latex (never orange).',
    },
    'amanita_pantherina': {
      'ca':
          'MOLT TÒXIC I PERILLÓS (síndrome panterínica o anticolinèrgica per àcid ibotènic i muscimol). Provoca deliris, convulsions, al·lucinacions i coma. Perill de confusió amb la cua de cavall comestible (Amanita rubescens), que enrogeix a la carn i té marge no estriat.',
      'es':
          'MUY TÓXICO Y PELIGROSO (síndrome panterínico por ácido iboténico y muscimol). Provoca delirios, convulsiones y coma. Peligro de confusión con la amanita rojiza (A. rubescens), de carne enrojeciente y margen no estriado.',
      'en':
          'HIGHLY TOXIC AND DANGEROUS (pantherina syndrome via ibotenic acid and muscimol). Causes severe neurological symptoms, delirium, and coma. Confusable with edible Blusher (A. rubescens), which bruises wine-red and has non-striate margins.',
    },
    'gyromitra_esculenta': {
      'ca':
          'MORTAL. Conté giromitrina, una toxina acumulativa que a l\'organisme es degrada en monometilhidrazina (combustible de coets), destruint glòbuls vermells i causant greus danys hepàtics i renals sovint mortals. Gran perill de confusió a la primavera amb la múrgola (Morchella esculenta), que té alvèols regulars tipus bresca i mai plecs cerebriformes.',
      'es':
          'MORTAL. Contiene giromitrina, toxina acumulativa que se transforma en monometilhidrazina, destruyendo hematíes y causando fallo hepático y renal fulminante. Gran peligro de confusión primaveral con la colmenilla (Morchella esculenta).',
      'en':
          'DEADLY POISONOUS. Contains gyromitrin, a cumulative toxin metabolised into monomethylhydrazine, destroying red blood cells and inducing lethal liver and kidney failure. Dangerous spring lookalike to edible true Morels (Morchella esculenta).',
    },
  };

  static const Map<String, Map<String, String>> _lookalikeComparisons = {
    'lactarius_deliciosus:amanita_muscaria': {
      'ca':
          'Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja.',
      'es':
          'Ambos se encuentran en pinares, pero la falsa oronja tiene sombrero rojo brillante con escamas blancas y nunca presenta látex naranja.',
      'en':
          'Both occur in pine woods, but the Fly Agaric has a bright red cap with white warts and never exudes orange latex.',
    },
    'cantharellus_cibarius:omphalotus_olearius': {
      'ca':
          'La Gírgola d\'olivera creix en fusta i té làmines veritables (no plecs), a més brilla en la foscor (bioluminescència).',
      'es':
          'La seta de olivo crece sobre madera y tiene láminas verdaderas (no pliegues), además de emitir bioluminiscencia en la oscuridad.',
      'en':
          'The Jack-o\'-lantern grows on wood and has true sharp gills (not blunt folds), and glows faintly green in the dark.',
    },
    'amanita_caesarea:amanita_muscaria': {
      'ca':
          'L\'Ou de reig té làmines i peu grocs (mai blancs), i el barret és llis sense esquames blanques.',
      'es':
          'La oronja tiene láminas y pie amarillos (nunca blancos), y el sombrero es liso sin escamas blancas.',
      'en':
          'Caesar\'s mushroom has yellow gills and stem (never white), and a smooth orange cap without white warts.',
    },
    'macrolepiota_procera:amanita_phalloides': {
      'ca':
          'L\'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva a la base del peu.',
      'es':
          'El parasol tiene un anillo móvil doble y carece de volva. La oronja verde siempre tiene volva envolvente en la base.',
      'en':
          'The parasol has a sliding double ring and never has a volva. The Death Cap always has a prominent sack-like volva at its base.',
    },
    'pleurotus_ostreatus:omphalotus_olearius': {
      'ca':
          'La Gírgola d\'olivera creix sobre fusta d\'olivera i té un color taronja intens, no gris-blavós com la Gírgola comestible.',
      'es':
          'La seta de olivo crece sobre madera y tiene color naranja intenso, no grisáceo-azulado como la seta de ostra comestible.',
      'en':
          'The toxic Jack-o\'-lantern has a deep orange color, unlike the slate-grey or brownish edible oyster mushroom.',
    },
    'calocybe_gambosa:entoloma_sinuatum': {
      'ca':
          'El Pèrfid té esporada rosa i olor de farina rància, mentre que el Moixernó té esporada blanca i olor agradable de farina fresca. L\'Entoloma té làmines escotades (pèrfid) i és tòxic.',
      'es':
          'La engañosa tiene esporada rosa y olor a harina rancia, mientras que el perrechico tiene esporada blanca y agradable olor a harina fresca. El Entoloma es tóxico.',
      'en':
          'The toxic Pinkgill produces pink spores and smells of rancid flour, while St. George\'s mushroom has white spores and a pleasant fresh meal aroma. Entoloma is toxic.',
    },
    'chroogomphus_rutilus:cortinarius_orellanus': {
      'ca':
          'La Cama de perdiu té làmines molt decurrents i carn que es torna violàcia/negrosa al foc, sense cortina; el Cortinari mortal té làmines adnates/escotades de color rovell i cortina filamentosa.',
      'es':
          'La pata de perdiz tiene láminas muy decurrentes y carne que vira a violácea al cocinar, sin cortina; el cortinario mortal tiene láminas oxidadas y cortina filamentosa.',
      'en':
          'The pine spike has deeply decurrent gills and flesh turning purple upon cooking, with no cortina; the deadly webcap has rusty adnate gills and a fibrous cortina.',
    },
    'lactarius_deliciosus:lactarius_chrysorrheus': {
      'ca':
          'El Fals rovelló o Lleterola té làtex blanc que es torna groc sofre intens en segons i és molt picant, mentre que el Rovelló té làtex ataronjat immutable.',
      'es':
          'El falso níscalo tiene látex blanco que vira a amarillo azufre intenso en segundos y es muy picante, mientras que el níscalo tiene látex naranja inmutable.',
      'en':
          'The yellow-drop milkcap has white latex that turns bright sulfur-yellow within seconds and is strongly acrid, whereas the saffron milkcap has unchanging orange milk.',
    },
    'boletus_edulis:rubroboletus_satanas': {
      'ca':
          'El Mataparent de Satanàs té barret blanquinós o gris perla, porus vermell sang i blaveja al tall, mentre que el Cep té barret marró fosc, porus blancs o groguencs i no blaveja mai.',
      'es':
          'El boleto de Satanás tiene sombrero blanquecino o gris perla, poros rojo sangre y azulea al corte, mientras que el boletus tiene sombrero marrón oscuro, poros blancos o amarillos y nunca azulea.',
      'en':
          'Satan\'s bolete has a chalky-white cap, blood-red pores and stains blue on cutting, whereas Porcini has a dark brown cap, white/yellow pores and never turns blue.',
    },
    'tricholoma_terreum:tricholoma_pardinum': {
      'ca':
          'El Fredolic bord és molt més robust i gros, amb esquames concèntriques amples com teules i peu sòlid, mentre que el Fredolic és menut, fràgil i té peu buit.',
      'es':
          'La negrilla bastarda es mucho más robusta y grande, con escamas concéntricas como tejas y pie sólido, mientras que la negrilla común es pequeña, frágil y de pie hueco.',
      'en':
          'The poison knight is much larger and stockier, with broad concentric scales like tiles and a solid stem, while the true grey knight is small, brittle, and hollow-stemmed.',
    },
    'russula_virescens:amanita_phalloides': {
      'ca':
          'La Palometa té carn trencadissa com el guix, barret verd clivellat en mosaic i mai té anell ni volva; la Farinera borda és mortal i té sempre anell, volva i carn fibrosa.',
      'es':
          'La seta de cura tiene carne quebradiza como tiza, sombrero verde cuarteado en mosaico y carece de anillo y volva; la oronja verde es mortal y siempre tiene anillo, volva y carne fibrosa.',
      'en':
          'The green-cracked brittlegill has crumbly chalk-like flesh, a cracked green mosaic cap, and never has a ring or volva; the deadly death cap always has a ring, volva, and fibrous flesh.',
    },
    'agaricus_campestris:agaricus_xanthodermus': {
      'ca':
          'El Xampinyó groguenc grogueja intensament a la base del peu en tallar-lo o rascar-lo i fa una forta olor desagradable de tinta o fenol; el Xampinyó silvestre mai grogueja a la base i fa bona olor d\'anís o ametlla.',
      'es':
          'El champiñón amarilleante amarillea intensamente en la base del pie al corte y desprende fuerte olor a tinta o fenol; el champiñón silvestre nunca amarillea en la base y huele agradablemente.',
      'en':
          'The yellow-stainer stains bright chrome-yellow at the stipe base upon cutting and smells strongly of ink/carbolic acid; the field mushroom never stains yellow at the base and has a pleasant sweet scent.',
    },
    'morchella_esculenta:gyromitra_esculenta': {
      'ca':
          'La Múrgola té cel·les o alvèols regulars com una bresca d\'abelles, mentre que el Bolet de greix té plecs cerebriformes ondulats com un cervell i és mortal.',
      'es':
          'La colmenilla tiene celdas regulares como un panal de abejas, mientras que la falsa colmenilla tiene pliegues cerebriformes como un cerebro y es mortal.',
      'en':
          'The true Morel has a pitted cap with neat honeycomb alveoli, whereas the False Morel has brain-like lobed convolutions and is lethally toxic.',
    },
    'lactarius_deliciosus:lactarius_torminosus': {
      'ca':
          'La Cabra o Rovelló bord té el marge del barret molt llanós i pelut (barbat) i exsuda làtex blanc molt coent; el Rovelló té el marge llis i làtex sempre ataronjat.',
      'es':
          'El falso níscalo peludo tiene el margen del sombrero lanoso y barbado y exuda látex blanco muy picante; el níscalo tiene margen liso y látex siempre naranja.',
      'en':
          'The Woolly Milkcap has a strongly bearded, woolly fringed cap margin and burning acrid white milk; the Saffron Milk Cap has a smooth margin and orange milk.',
    },
    'macrolepiota_procera:amanita_pantherina': {
      'ca':
          'L\'Apagallums té un anell doble mòbil que llisca pel peu i mai té volva; la Pantera és molt tòxica, té un anell fix i una volva dissociada en anells concèntrics a la base del peu.',
      'es':
          'El parasol tiene un anillo doble móvil que se desliza por el pie y carece de volva; la pantera es muy tóxica, tiene anillo fijo y volva en anillos concéntricos en la base.',
      'en':
          'The Parasol has a sliding movable double ring and never has a volva; the toxic Panther Cap has an attached ring and distinct stepped volva collars at the base.',
    },
    'lactarius_sanguifluus:lactarius_chrysorrheus': {
      'ca':
          'El Fals rovelló o Lleterola té làtex blanc que en pocs segons vira a groc sofre intens i és molt picant; el Rovelló d\'obaga (de sang) té làtex vinós o vermell fosc i mai exsuda llet blanca o groga.',
      'es':
          'El falso níscalo tiene látex blanco que vira a amarillo azufre en segundos y es muy picante; el níscalo de sangre tiene látex vinoso o rojo púrpura y nunca blanco.',
      'en':
          'The yellow-drop milkcap exudes white latex rapidly turning sulfur-yellow and is strongly acrid; the bloody milkcap has wine-red or purplish latex and never white or yellow milk.',
    },
    'lactarius_sanguifluus:lactarius_torminosus': {
      'ca':
          'La Cabra o Rovelló bord té el marge del barret densament llanós i pelut (barbat) i exsuda làtex blanc molt coent; el Rovelló d\'obaga (de sang) té el marge llis i làtex de color sang vinós.',
      'es':
          'El falso níscalo peludo tiene el margen del sombrero lanoso y barbado con látex blanco ardiente; el níscalo de sangre tiene margen glabro y látex rojo vinoso.',
      'en':
          'The Woolly Milkcap has a heavily bearded, shaggy-haired margin and burning white latex; the bloody milkcap has a smooth margin and deep wine-red latex.',
    },
    'agaricus_campestris:amanita_verna': {
      'ca':
          'La mortal Cicuta blanca té làmines sempre d\'un blanc immaculat i una volva membranosa en sac a la base; el Xampinyó silvestre té làmines rosades de jove que enfosqueixen a xocolata i mai té volva.',
      'es':
          'La mortal cicuta blanca tiene láminas siempre blancas y una volva membranosa en la base; el champiñón silvestre tiene láminas rosadas que viran a chocolate y carece de volva.',
      'en':
          'The deadly Spring Amanita has pure white gills and a distinct sack-like basal volva; the field mushroom has delicate pink gills turning chocolate-brown and lacks a volva.',
    },
    'boletus_aereus:rubroboletus_satanas': {
      'ca':
          'El Mataparent de Satanàs té barret blanquinós o grisenc, porus vermells i blaveja ràpidament al tall; el Cep negre té barret bronze o xocolata fosc, porus blancs o groguencs i carn immutable que no blaveja mai.',
      'es':
          'El boleto de Satanás tiene sombrero blanquecino, poros rojo sangre y azulea al corte; el boleto negro tiene sombrero bronce oscuro, poros blancos o amarillos y carne blanca inmutable.',
      'en':
          'Satan\'s bolete has a chalky-white cap, blood-red pores and stains blue on bruising; the Dark Bolete has a dark bronze-brown cap, white to yellowish pores and unchanging white flesh.',
    },
    'hygrophorus_eburneus:amanita_verna': {
      'ca':
          'La mortal Cicuta blanca té làmines lliures, anell penjant al peu i volva prominent en sac a la base; la Llenega blanca té làmines ceroses decurrents, barret molt viscós i mai té anell ni volva.',
      'es':
          'La mortal cicuta blanca tiene láminas libres, anillo en el pie y volva membranosa; la llanega blanca (babosa blanca) tiene láminas decurrentes cerosas, sombrero muy viscoso y carece de anillo y volva.',
      'en':
          'The deadly Spring Amanita has free gills, a stem ring, and a prominent sack volva; the Ivory Woodwax has waxy decurrent gills, a very slimy cap, and lacks both ring and volva.',
    },
    'russula_cyanoxantha:amanita_phalloides': {
      'ca':
          'La mortal Farinera borda té anell al peu, volva membranosa en sac a la base i làmines fràgils; la Llora verda o Cuaverda mai té anell ni volva i les seves làmines són flexibles i lardàcies (no es trenquen en passar-hi el dit).',
      'es':
          'La mortal oronja verde tiene anillo, volva membranosa en saco y láminas frágiles; la carbonera carece de anillo y volva y sus láminas son flexibles y grasientas al tacto (no se rompen).',
      'en':
          'The deadly Death Cap has a stem ring, sack-like volva, and brittle gills; the Charcoal Burner lacks both ring and volva and possesses lardaceous flexible gills that bend without breaking.',
    },
    'amanita_virosa:calocybe_gambosa': {
      'ca':
          'La mortal Farinera pudent té anell penjant al peu, volva en sac a la base i làmines lliures blanques; el Moixernó té làmines juntes sense anell ni volva i agradable olor de farina.',
      'es':
          'La mortal cicuta fétida tiene anillo, volva en saco y láminas libres; la seta de San Jorge carece de anillo y volva y huele a harina fresca.',
      'en':
          'Deadly Destroying Angel has a stem ring, saccate volva, and free gills; edible St. George mushroom lacks both ring and volva and smells of fresh meal.',
    },
    'amanita_virosa:agaricus_campestris': {
      'ca':
          'La mortal Farinera pudent té làmines blanques pures i volva en sac; el Xampinyó silvestre té làmines rosades a marró xocolata i mai té volva.',
      'es':
          'El mortal ángel de la muerte tiene láminas blancas puras y volva en saco; el champiñón silvestre tiene láminas rosadas a chocolate y carece de volva.',
      'en':
          'Deadly Destroying Angel has pure white gills and a saccate volva; Field mushroom has pink to chocolate gills and never has a volva.',
    },
    'galerina_marginata:pleurotus_ostreatus': {
      'ca':
          'La mortal Galerina vironosa és petita, ocre-marró, té anell membranós i espores marró rovell; la Gírgola és molt més gran, gris-blavosa, sense anell i amb esporada blanca.',
      'es':
          'La mortal Galerina marginata es pequeña, pardo-ocre, con anillo membranoso y esporada marrón óxido; la Seta de ostra es grisácea, sin anillo y esporada blanca.',
      'en':
          'Deadly Funeral Bell is small, ochre-brown, with a ring and rusty brown spores; Oyster mushroom is greyish, ringless, and has white spores.',
    },
    'lactarius_semisanguifluus:lactarius_chrysorrheus': {
      'ca':
          'El Pinetell de sang té làtex taronja que ràpidament es torna vi negre/porpra i s\'oxida a verd; el Fals rovelló tòxic té làtex blanc que vira a groc sofre.',
      'es':
          'El Níscalo semirrojo tiene látex naranja que vira a vino tinto y se mancha de verde; el Falso níscalo tóxico tiene látex blanco que vira a amarillo.',
      'en':
          'Highland Saffron Milkcap has orange milk turning wine-purple and bruising green; toxic False Milkcap has white milk turning yellow.',
    },
    'lactarius_semisanguifluus:lactarius_torminosus': {
      'ca':
          'La Cabra té marge barbós molt pelut i làtex blanc acre immutable; el Pinetell de sang té marge llis i làtex vinós.',
      'es':
          'El falso níscalo barbudo tiene margen muy lanoso/peludo y látex blanco acre; el níscalo semirrojo tiene margen liso y látex vinoso.',
      'en':
          'Woolly Milkcap has a heavily bearded margin and acrid white milk; Highland Saffron Milkcap has a smooth margin and vinaceous milk.',
    },
    'hygrophorus_personii:amanita_phalloides': {
      'ca':
          'La mortal Farinera borda té làmines lliures, anell i volva membranosa en sac; la Llenega d\'alzina té làmines gruixudes ceroses i beina viscosa tigrada sense volva.',
      'es':
          'La mortal Oronja verde tiene láminas libres, anillo y volva; el Higróforo de encina tiene láminas cerosas decurrentes y vaina viscosa sin volva.',
      'en':
          'Deadly Death Cap has free gills, a ring, and a sack volva; Dark Woodwax has thick waxy decurrent gills and a slimy sheath without a volva.',
    },
    'russula_cyanoxantha:tricholoma_equestre': {
      'ca':
          'El Groguet té làmines groc sofre i carn fibrosa; la Llora verda té làmines blanques lardàcies i carn trencadissa com guix.',
      'es':
          'La seta de los caballeros tiene láminas amarillo azufre y carne fibrosa; la carbonera tiene láminas blancas grasientas y carne quebradiza.',
      'en':
          'Yellow Knight has sulfur-yellow gills and fibrous flesh; Charcoal Burner has white flexible lardaceous gills and brittle chalky flesh.',
    },
    'tuber_melanosporum:scleroderma_citrinum': {
      'ca':
          'La Tòfona negra és subterrània i aromàtica amb gleba negrosa marbrada per venes blanques; el Patac d\'ase té pell dura berrugosa groga i gleba negra homogènia sense vetes blanques.',
      'es':
          'La trufa negra es subterránea y muy aromática con interior veteado de blanco; la falsa trufa o patata de tierra tiene piel correosa amarillenta y gleba negra uniforme sin vetas, siendo muy tóxica.',
      'en':
          'The Black Truffle grows underground and has marbled black flesh with white veins; the toxic Common Earthball grows on the surface with a tough yellowish warty skin and solid black interior without veins.',
    },
    'infundibulicybe_geotropa:clitocybe_nebularis': {
      'ca':
          'La Pampa és de color beix ocre amb un mamelló central prominent (umbó); la Pampa de boira té un barret pla o deprimit gris cendra sense mamelló i és tòxica/indigesta.',
      'es':
          'La platera tiene color ocre claro con un mamelón central muy evidente; la pardilla tiene sombrero gris ceniza sin mamelón y resulta indigesta o tóxica para muchas personas.',
      'en':
          'The Trooping Funnel is buff-ochre with a prominent central nipple (umbo); the Clouded Funnel has a flat or depressed ash-grey cap without a central nipple and is indigestible or toxic.',
    },
    'boletus_edulis:tylopilus_felleus': {
      'ca':
          'El Mataparent amarg té porus rosats a la maduresa i un reticle marró fosc prominent al peu; a més té un sabor extremadament amarg que arruïna qualsevol guisat.',
      'es':
          'El boleto amargo tiene poros que viran a rosa y un retículo pardo oscuro muy marcado en el pie; su sabor es intensamente amargo y estropea cualquier plato.',
      'en':
          'The Bitter Bolete has pores that turn dirty pink with age and a dark coarse mesh on the stem; its intensely bitter taste ruins any dish.',
    },
    'boletus_pinophilus:tylopilus_felleus': {
      'ca':
          'El Mataparent amarg té porus rosats de madur i reticle fosc marcat al peu, a diferència dels porus groguencs-oliva del Cep vermell, i és immensament amarg.',
      'es':
          'El boleto amargo presenta poros rosados de adulto y retículo oscuro en el pie a diferencia de los poros amarillo-oliva del boleto pinícola, y es incomible por amargo.',
      'en':
          'The Bitter Bolete shows pinkish mature pores and a coarse dark net on the stipe, unlike the yellowish-olive pores of the Pine Bolete, and is intolerably bitter.',
    },
    'neoboletus_luridiformis:suillellus_luridus': {
      'ca':
          'El Mataparent de peu vermell té peu puntejat de grans vermells sense reticle; el Mataparent de bou (tòxic en cru i amb alcohol) té una xarxa vermella molt marcada sobre fons groc.',
      'es':
          'El boleto de pie rojo tiene el pie punteado de gránulos rojos sin red; el boleto lúrido (tóxico en crudo y con alcohol) presenta una red o retículo rojo muy visible en relieve sobre fondo amarillo.',
      'en':
          'Scarletina Bolete has red dots/granules on its stem without a mesh; Lurid Bolete (toxic raw and with alcohol) has a prominent crimson net/mesh pattern over yellow.',
    },
    'russula_aurea:russula_emetica': {
      'ca':
          'La Llora daurada té làmines i peu d\'un groc daurat lluminós i carn dolça; la Rússula emètica té làmines i peu d\'un blanc immaculat i és extremadament picant i tòxica.',
      'es':
          'La rúsula dorada tiene láminas y pie de un amarillo dorado luminoso y carne dulce; la rúsula emética tiene láminas y pie de un blanco puro inmaculado y es intensamente picante y vomitiva.',
      'en':
          'Gilded Brittlegill has brilliant golden-yellow gills and stem with mild sweet flesh; the Sickener has pure white gills and stem, burning acrid taste, and causes vomiting.',
    },
    'agaricus_arvensis:agaricus_xanthodermus': {
      'ca':
          'La Bola de neu fa olor suau d\'anís i té anell en roda dentada; el Xampinyó groguenc grogueja a l\'instant a la base del peu i fa una forta olor de tinta o fenol.',
      'es':
          'La bola de nieve huele agradablemente a anís y tiene anillo en rueda dentada; el champiñón amarilleante vira a amarillo cromo instantáneo en la base del pie y huele fuertemente a tinta o fenol.',
      'en':
          'Horse Mushroom smells sweetly of anise and has a cogwheel ring; Yellow-staining Mushroom stains vivid chrome yellow instantly at the base and smells of phenol/ink.',
    },
    'agaricus_arvensis:amanita_verna': {
      'ca':
          'La mortal Cicuta blanca té làmines sempre d\'un blanc pur i volva membranosa en sac; la Bola de neu té làmines que passen de gris-rosat a xocolata i no té mai volva.',
      'es':
          'La mortal cicuta blanca tiene láminas siempre blancas y volva envolvente en saco; la bola de nieve tiene láminas que oscurecen a rosadas y chocolate y carece de volva.',
      'en':
          'Deadly Spring Amanita has permanently pure white gills and a sack-like basal volva; Horse Mushroom has gills maturing from pinkish-grey to chocolate brown and lacks a volva.',
    },
    'clitocybe_nebularis:entoloma_sinuatum': {
      'ca':
          'El molt tòxic Pèrfid té làmines groguenques a rosades escotades i olor de farina rància; la Pampa de boira té làmines blanquinoses decurrents i forta olor de fenc/boira.',
      'es':
          'La engañosa (muy tóxica) tiene láminas escotadas que viran a rosa y olor a harina rancia; la pardilla tiene láminas decurrentes blanquecinas y olor fuerte a moho/paja.',
      'en':
          'The highly toxic Pinkgill has notched yellowish-pink gills and rancid flour odor; the Clouded Agaric has decurrent whitish gills and a strong pungent clouded odor.',
    },
    'agaricus_arvensis:amanita_phalloides': {
      'ca':
          'En fase de botó, la mortal Farinera borda es pot confondre amb el jove xampinyó, però l\'Amanita té volva membranosa en sac a la base i làmines sempre blanques pures.',
      'es':
          'En estado de botón, la mortal oronja verde puede confundirse con el champiñón joven, pero la Amanita tiene volva basal en saco y láminas permanentemente blancas.',
      'en':
          'In button stage, the deadly Death Cap can resemble young horse mushrooms, but the Amanita has a sack-like basal volva and permanently pure white gills.',
    },
    'agaricus_arvensis:amanita_virosa': {
      'ca':
          'La mortal Farinera pudent és completament blanca, té peu llanós-esquamós, anell penjant i volva en sac; la Bola de neu mai té volva i les làmines enfosqueixen a xocolata.',
      'es':
          'La mortal cicuta fétida es enteramente blanca, con pie lanoso-escamoso, anillo colgante y volva en saco; la bola de nieve no tiene volva y sus láminas oscurecen.',
      'en':
          'The deadly Destroying Angel is completely white with a shaggy stem, pendulous ring, and basal volva; Horse Mushroom never has a volva and its gills darken to chocolate.',
    },
    'boletus_reticulatus:tylopilus_felleus': {
      'ca':
          'El Mataparent amarg té porus rosats de madur i un reticle marró fosc amb malles amples al peu; a diferència del reticle blanc fi del Cep d\'estiu, és insuportablement amarg.',
      'es':
          'El boleto amargo tiene poros que viran a rosa sucio y un retículo oscuro de malla ancha; a diferencia del fino retículo blanco del boleto estival, es intocablemente amargo.',
      'en':
          'The Bitter Bolete develops dirty pink pores and a coarse dark mesh on the stem; unlike the fine white net of the Summer Bolete, it is completely inedible due to extreme bitterness.',
    },
    'neoboletus_luridiformis:rubroboletus_satanas': {
      'ca':
          'El molt tòxic Mataparent de Satanàs té barret blanquinós-grisenc i reticle vermell al peu; el Mataparent de peu vermell té barret marró xocolata vellutat i peu pigallat de puntets sense xarxa.',
      'es':
          'El muy tóxico boleto de Satanás tiene sombrero blanquecino-ceniza y retículo rojo en el pie; el boleto de pie rojo tiene sombrero marrón terciopelo y pie punteado sin red.',
      'en':
          'The highly toxic Satan\'s Bolete has a chalky whitish-grey cap and red stem reticulation; Scarletina Bolete has a velvety chocolate-brown cap and a punctate dotted stem without a mesh.',
    },
  };

  static const Map<String, Map<String, String>> _treeBarks = {
    'pinus_sylvestris': {
      'ca': 'Tronc superior ataronjat',
      'es': 'Tronco superior anaranjado',
      'en': 'Upper trunk orange-ochre',
    },
    'pinus_halepensis': {
      'ca': 'Escorça gris platejada',
      'es': 'Corteza gris plateada',
      'en': 'Silvery-grey bark',
    },
    'quercus_ilex': {
      'ca': 'Escorça fosca clivellada',
      'es': 'Corteza oscura agrietada',
      'en': 'Dark fissured bark',
    },
    'fagus_sylvatica': {
      'ca': 'Escorça llisa gris',
      'es': 'Corteza lisa grisácea',
      'en': 'Smooth grey bark',
    },
    'castanea_sativa': {
      'ca': 'Escorça amb solcs espirals',
      'es': 'Corteza con surcos espirales',
      'en': 'Bark with spiral furrows',
    },
  };

  static const Map<String, Map<String, String>> _treeLeaves = {
    'pinus_sylvestris': {
      'ca': 'Agulla',
      'es': 'Aguja',
      'en': 'Needle',
    },
    'pinus_halepensis': {
      'ca': 'Agulla',
      'es': 'Aguja',
      'en': 'Needle',
    },
    'quercus_ilex': {
      'ca': 'Perenne',
      'es': 'Perenne',
      'en': 'Evergreen',
    },
    'fagus_sylvatica': {
      'ca': 'Caduca',
      'es': 'Caduca',
      'en': 'Deciduous',
    },
    'castanea_sativa': {
      'ca': 'Caduca',
      'es': 'Caduca',
      'en': 'Deciduous',
    },
  };

  static const Map<String, Map<String, String>> _treeSoils = {
    'pinus_sylvestris': {
      'ca': 'Silici o àcid',
      'es': 'Silíceo o ácido',
      'en': 'Siliceous or acidic',
    },
    'pinus_halepensis': {
      'ca': 'Calcari',
      'es': 'Calcáreo',
      'en': 'Calcareous / Limestone',
    },
    'quercus_ilex': {
      'ca': 'Calcari o silici',
      'es': 'Calcáreo o silíceo',
      'en': 'Calcareous or siliceous',
    },
    'fagus_sylvatica': {
      'ca': 'Silici o àcid',
      'es': 'Silíceo o ácido',
      'en': 'Siliceous or acidic',
    },
    'castanea_sativa': {
      'ca': 'Silici, àcid',
      'es': 'Silíceo, ácido',
      'en': 'Siliceous, acidic',
    },
  };

  /// Resolves the localized name for a mushroom species given its [id] and target [languageCode].
  static String getMushroomName(
    String? id, {
    String languageCode = 'ca',
    String? fallbackName,
  }) {
    if (id == null) return fallbackName ?? 'Bolet';
    if (languageCode == 'ca' &&
        fallbackName != null &&
        fallbackName.isNotEmpty) {
      return fallbackName;
    }
    final translations = _mushrooms[id];
    if (translations != null) {
      return translations[languageCode] ??
          translations['ca'] ??
          fallbackName ??
          id;
    }
    return fallbackName ?? id;
  }

  /// Resolves the localized name for an indicator tree given its [id] and target [languageCode].
  static String getTreeName(
    String? id, {
    String languageCode = 'ca',
    String? fallbackName,
  }) {
    if (id == null) return fallbackName ?? 'Arbre indicador';
    if (languageCode == 'ca' &&
        fallbackName != null &&
        fallbackName.isNotEmpty) {
      return fallbackName;
    }
    final translations = _trees[id];
    if (translations != null) {
      return translations[languageCode] ??
          translations['ca'] ??
          fallbackName ??
          id;
    }
    return fallbackName ?? id;
  }

  /// Resolves the localized cap (barret) description for a mushroom.
  static String getCapDescription(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _capDescriptions[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves the localized gills (làmines) description for a mushroom.
  static String getGillsDescription(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _gillsDescriptions[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves the localized stem (peu) description for a mushroom.
  static String getStemDescription(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _stemDescriptions[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves the localized latex (làtex) description for a mushroom (if present).
  static String? getLatexDescription(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback;
    final trans = _latexDescriptions[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback;
    }
    return fallback;
  }

  /// Resolves localized safety notes for a mushroom.
  static String? getSafetyNotes(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback;
    final trans = _safetyNotes[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback;
    }
    return fallback;
  }

  /// Resolves localized comparison notes between a mushroom and its toxic lookalike.
  static String getComparisonNotes(
    String? boletId,
    String? lookalikeId, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (boletId == null || lookalikeId == null) return fallback ?? '';
    final key = '$boletId:$lookalikeId';
    final reverseKey = '$lookalikeId:$boletId';
    final trans =
        _lookalikeComparisons[key] ?? _lookalikeComparisons[reverseKey];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves localized tree bark description.
  static String getTreeBark(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _treeBarks[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves localized tree leaf type.
  static String getTreeLeafType(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _treeLeaves[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }

  /// Resolves localized tree typical soil.
  static String getTreeSoil(
    String? id, {
    String languageCode = 'ca',
    String? fallback,
  }) {
    if (id == null) return fallback ?? '';
    final trans = _treeSoils[id];
    if (trans != null) {
      return trans[languageCode] ?? trans['ca'] ?? fallback ?? '';
    }
    return fallback ?? '';
  }
}
