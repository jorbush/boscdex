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
    final trans = _lookalikeComparisons[key];
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
