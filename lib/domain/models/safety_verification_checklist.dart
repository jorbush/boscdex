/// Botanical verification checklist model and registry for high-risk mushroom species.
///
/// Provides field-tested, multi-language botanical verification items to prompt
/// foragers before confirming sightings of species with dangerous lookalikes.
class BotanicalCheckItem {
  final String id;
  final String questionCa;
  final String questionEs;
  final String questionEn;
  final String detailCa;
  final String detailEs;
  final String detailEn;

  const BotanicalCheckItem({
    required this.id,
    required this.questionCa,
    required this.questionEs,
    required this.questionEn,
    required this.detailCa,
    required this.detailEs,
    required this.detailEn,
  });

  String getQuestion(String lang) {
    if (lang == 'es') return questionEs;
    if (lang == 'en') return questionEn;
    return questionCa;
  }

  String getDetail(String lang) {
    if (lang == 'es') return detailEs;
    if (lang == 'en') return detailEn;
    return detailCa;
  }
}

class BotanicalSafetyChecklist {
  final String speciesId;
  final List<BotanicalCheckItem> items;

  const BotanicalSafetyChecklist({
    required this.speciesId,
    required this.items,
  });

  /// Retrieves the tailored botanical checklist for [speciesId], or a general safety checklist if not specialized.
  static BotanicalSafetyChecklist getChecklist(String speciesId) {
    return _registry[speciesId] ?? _generalChecklist(speciesId);
  }

  static BotanicalSafetyChecklist _generalChecklist(String speciesId) {
    return BotanicalSafetyChecklist(
      speciesId: speciesId,
      items: const [
        BotanicalCheckItem(
          id: 'general_base_volva',
          questionCa:
              'Has comprovat la base del peu per descartar volva o anell d\'Amanita?',
          questionEs:
              '¿Has comprobado la base del pie para descartar volva o anillo de Amanita?',
          questionEn:
              'Did you check the stem base to rule out an Amanita volva or ring?',
          detailCa:
              'Les espècies mortals (Amanita phalloides, verna, virosa) tenen volva membranosa en sac.',
          detailEs:
              'Las especies mortales (Amanita phalloides, verna, virosa) tienen volva membranosa en saco.',
          detailEn:
              'Deadly species (Amanita phalloides, verna, virosa) have a distinct saccate volva.',
        ),
        BotanicalCheckItem(
          id: 'general_comparison_reviewed',
          questionCa:
              'Has revisat les diferències a la fitxa d\'alerta de confusió perillosa?',
          questionEs:
              '¿Has revisado las diferencias en la ficha de alerta de confusión peligrosa?',
          questionEn:
              'Have you reviewed the key differences in the dangerous lookalike card?',
          detailCa:
              'Compara làmines, color d\'esporada, consistència de la carn i hàbitat.',
          detailEs:
              'Compara láminas, color de esporada, consistencia de la carne y hábitat.',
          detailEn:
              'Compare gills, spore print color, flesh consistency, and tree habitat.',
        ),
      ],
    );
  }

  static final Map<String, BotanicalSafetyChecklist> _registry = {
    // 1. Rovellons (Lactarius deliciosus, sanguifluus, semisanguifluus)
    'lactarius_deliciosus': const BotanicalSafetyChecklist(
      speciesId: 'lactarius_deliciosus',
      items: [
        BotanicalCheckItem(
          id: 'latex_orange',
          questionCa:
              'El làtex és de color taronja viu (NO blanc que grogueja)?',
          questionEs:
              '¿El látex es de color naranja vivo (NO blanco que amarillea)?',
          questionEn:
              'Is the latex bright orange (NOT white turning sulfur-yellow)?',
          detailCa:
              'El Fals rovelló tòxic (Lactarius chrysorrheus) té llet blanca que es torna groga ràpidament.',
          detailEs:
              'El Falso níscalo tóxico (Lactarius chrysorrheus) tiene látex blanco que vira a amarillo rápidamente.',
          detailEn:
              'The toxic False Milkcap (Lactarius chrysorrheus) has white milk that quickly turns yellow.',
        ),
        BotanicalCheckItem(
          id: 'margin_smooth',
          questionCa:
              'El marge del barret és llis (NO té pèls llanosos abundants)?',
          questionEs:
              '¿El margen del sombrero es liso (NO tiene pelos lanosos abundantes)?',
          questionEn:
              'Is the cap margin smooth (NOT densely hairy or bearded)?',
          detailCa:
              'La Cabra / Rovelló bord (Lactarius torminosus) té el marge molt pelut i és tòxica.',
          detailEs:
              'El Falso níscalo peludo (Lactarius torminosus) tiene el margen muy barbado y es tóxico.',
          detailEn:
              'The Woolly Milkcap (Lactarius torminosus) has a bearded shaggy margin and is toxic.',
        ),
      ],
    ),
    'lactarius_sanguifluus': const BotanicalSafetyChecklist(
      speciesId: 'lactarius_sanguifluus',
      items: [
        BotanicalCheckItem(
          id: 'latex_wine_red',
          questionCa:
              'El làtex és de color sang/vinós fosc immediatament al tall?',
          questionEs:
              '¿El látex es de color sangre/vinoso oscuro de inmediato al corte?',
          questionEn:
              'Is the latex dark wine-red / bloody immediately upon cutting?',
          detailCa:
              'El Rovelló de sang té làtex roig fosc; les lleteroles tòxiques tenen llet blanca picant.',
          detailEs:
              'El Níscalo de sangre tiene látex rojo oscuro; los lactarios tóxicos tienen leche blanca picante.',
          detailEn:
              'Bloody milkcap has immediate dark red milk; toxic milkcaps have acrid white milk.',
        ),
        BotanicalCheckItem(
          id: 'margin_smooth',
          questionCa: 'El marge del barret és llis i arrodonit, sense pèls?',
          questionEs: '¿El margen del sombrero es liso y curvado, sin pelos?',
          questionEn: 'Is the cap margin smooth and curved, without hairs?',
          detailCa:
              'Descarta la Cabra tòxica (Lactarius torminosus) de marge densament llanós.',
          detailEs:
              'Descarta el Falso níscalo peludo tóxico de margen densamente lanoso.',
          detailEn:
              'Rules out toxic Woolly Milkcap with bearded shaggy margin.',
        ),
      ],
    ),
    'lactarius_semisanguifluus': const BotanicalSafetyChecklist(
      speciesId: 'lactarius_semisanguifluus',
      items: [
        BotanicalCheckItem(
          id: 'latex_orange_to_wine',
          questionCa:
              'El làtex surt taronja i es torna vi negre/porpra en pocs minuts?',
          questionEs:
              '¿El látex brota naranja y vira a vino tinto/púrpura en pocos minutos?',
          questionEn:
              'Does the latex flow orange and turn dark wine-purple in minutes?',
          detailCa:
              'Aquest canvi cromàtic és exclusiu del Pinetell de sang comestible.',
          detailEs:
              'Este cambio cromático es exclusivo del Níscalo semirrojo comestible.',
          detailEn:
              'This color transition is unique to the edible Highland Saffron Milkcap.',
        ),
        BotanicalCheckItem(
          id: 'verdigris_green',
          questionCa:
              'El barret presenta taques o zones verdoses (verdet) amb l\'edat?',
          questionEs:
              '¿El sombrero presenta manchas o zonas verdosas con la edad?',
          questionEn:
              'Does the cap show verdigris green oxidation patches with age?',
          detailCa:
              'Els falsos rovellons tòxics mai presenten aquesta forta oxidació verdosa.',
          detailEs:
              'Los falsos níscalos tóxicos nunca presentan esta fuerte oxidación verdosa.',
          detailEn: 'Toxic false milkcaps never show strong green oxidation.',
        ),
      ],
    ),

    // 2. Xampinyons (Agaricus campestris)
    'agaricus_campestris': const BotanicalSafetyChecklist(
      speciesId: 'agaricus_campestris',
      items: [
        BotanicalCheckItem(
          id: 'no_volva',
          questionCa:
              'Has desenterrat el peu per comprovar que NO hi ha volva en sac a la base?',
          questionEs:
              '¿Has desenterrado el pie para comprobar que NO hay volva en saco en la base?',
          questionEn:
              'Did you unearth the stem base to verify there is NO saccate volva?',
          detailCa:
              'La presència de volva indica una Amanita mortal (Amanita verna, virosa, phalloides).',
          detailEs:
              'La presencia de volva indica una Amanita mortal (Amanita verna, virosa, phalloides).',
          detailEn: 'The presence of a volva indicates a deadly white Amanita.',
        ),
        BotanicalCheckItem(
          id: 'gills_pink_not_white',
          questionCa: 'Les làmines són rosades a marrons (MAI blanques pures)?',
          questionEs:
              '¿Las láminas son rosadas a marrones (NUNCA blancas puras)?',
          questionEn:
              'Are the gills pink to chocolate brown (NEVER pure white)?',
          detailCa:
              'Totes les Amanites mortals tenen làmines blanques immutables.',
          detailEs:
              'Todas las Amanitas mortales tienen láminas blancas inmutables.',
          detailEn:
              'All deadly white Amanitas have pure white permanent gills.',
        ),
        BotanicalCheckItem(
          id: 'no_yellow_staining',
          questionCa:
              'En rascar la base del peu, NO es taca de groc crom ni fa olor de fenol/tinta?',
          questionEs:
              '¿Al raspar la base del pie, NO se tiñe de amarillo cromo ni huele a fenol/tinta?',
          questionEn:
              'When scratching the stem base, does it NOT turn yellow nor smell like ink?',
          detailCa:
              'El Xampinyó groguenc tòxic (Agaricus xanthodermus) grogueja intensament i fa pudor química.',
          detailEs:
              'El Champiñón amarilleante tóxico amarillea intensamente y huele a químico.',
          detailEn:
              'Toxic Yellow-staining mushroom turns chrome yellow and smells of phenol.',
        ),
      ],
    ),

    // 3. Moixernó (Calocybe gambosa)
    'calocybe_gambosa': const BotanicalSafetyChecklist(
      speciesId: 'calocybe_gambosa',
      items: [
        BotanicalCheckItem(
          id: 'gills_crowded_white',
          questionCa:
              'Les làmines són molt juntes, blanques/crema i MAI rosades?',
          questionEs:
              '¿Las láminas son muy apretadas, blancas/crema y NUNCA rosadas?',
          questionEn: 'Are the gills crowded, white/cream, and NEVER pink?',
          detailCa:
              'El Pèrfid tòxic (Entoloma sinuatum) té espores i làmines madures de color salmó rosat.',
          detailEs:
              'La Pérfida tóxica (Entoloma sinuatum) tiene esporas y láminas maduras de color salmón rosado.',
          detailEn:
              'Toxic Livid Pinkgill (Entoloma sinuatum) has mature salmon-pink gills.',
        ),
        BotanicalCheckItem(
          id: 'flour_scent',
          questionCa: 'Fa una forta i agradable olor de farina fresca?',
          questionEs: '¿Desprende un fuerte y agradable olor a harina fresca?',
          questionEn: 'Does it have a strong, pleasant fresh flour aroma?',
          detailCa:
              'L\'olor és inconfusible; el Pèrfid fa olor farinosa però rància i desagradable de vell.',
          detailEs:
              'El olor es inconfundible; la Pérfida huele a harina pero rancia y desagradable.',
          detailEn:
              'Distinctive fresh meal odor; toxic Entoloma smells rancid and nauseating when old.',
        ),
      ],
    ),

    // 4. Apagallums (Macrolepiota procera)
    'macrolepiota_procera': const BotanicalSafetyChecklist(
      speciesId: 'macrolepiota_procera',
      items: [
        BotanicalCheckItem(
          id: 'movable_double_ring',
          questionCa:
              'L\'anell és doble, membranós i es pot desplaçar lliurement per la cama?',
          questionEs:
              '¿El anillo es doble, membranoso y se puede desplazar libremente por el pie?',
          questionEn:
              'Is the ring double, membranous, and freely movable along the stem?',
          detailCa:
              'Les lepiotes petites mortals i les Amanites tenen anell fix que no llisca.',
          detailEs:
              'Las lepiotas pequeñas mortales y las Amanitas tienen anillo fijo que no se desliza.',
          detailEn:
              'Deadly small Lepiota species and Amanitas have a fixed, non-movable ring.',
        ),
        BotanicalCheckItem(
          id: 'large_size_snakeskin',
          questionCa:
              'El barret fa més de 10-15 cm i la cama té dibuix tigrat en ziga-zaga?',
          questionEs:
              '¿El sombrero mide más de 10-15 cm y el pie tiene dibujo atigrado en zigzag?',
          questionEn:
              'Is the cap larger than 10-15 cm and does the stem have a snakeskin pattern?',
          detailCa:
              'MAI recolliu lepiotes petites de menys de 10 cm (moltes són mortals com Lepiota brunneoincarnata).',
          detailEs:
              'NUNCA recolectéis lepiotas pequeñas de menos de 10 cm (muchas son mortales).',
          detailEn:
              'NEVER harvest small lepiotas under 10 cm (several are lethal like Lepiota brunneoincarnata).',
        ),
      ],
    ),

    // 5. Fredolic (Tricholoma terreum)
    'tricholoma_terreum': const BotanicalSafetyChecklist(
      speciesId: 'tricholoma_terreum',
      items: [
        BotanicalCheckItem(
          id: 'stem_fragile_hollow',
          questionCa:
              'La cama és prima, fràgil i buida/trencadissa (NO rabassuda ni sòlida)?',
          questionEs:
              '¿El pie es delgado, frágil y hueco/quebradizo (NO robusto ni sólido)?',
          questionEn:
              'Is the stem slender, fragile, and hollow (NOT stout and solid)?',
          detailCa:
              'El Fredolic bord tòxic (Tricholoma pardinum) té el peu molt gruixut, dur i massís.',
          detailEs:
              'El Tricoloma atigrado tóxico (Tricholoma pardinum) tiene el pie muy grueso y macizo.',
          detailEn:
              'Toxic Tiger Tricholoma (Tricholoma pardinum) has a thick, bulbous, solid stem.',
        ),
        BotanicalCheckItem(
          id: 'cap_fibrous_not_shingled',
          questionCa:
              'El barret té fibres fines com pèls, sense esquames amples com teules?',
          questionEs:
              '¿El sombrero tiene fibras finas, sin escamas anchas como tejas?',
          questionEn:
              'Does the cap have fine radiating fibrils, without large shingle scales?',
          detailCa:
              'El Fredolic bord té esquames fosques molt marcades concèntriques.',
          detailEs:
              'El Tricoloma atigrado tiene escamas oscuras concéntricas muy evidentes.',
          detailEn:
              'Toxic Tiger Tricholoma has heavy concentric dark shingle scales.',
        ),
      ],
    ),

    // 6. Ceps (Boletus edulis / aereus)
    'boletus_edulis': const BotanicalSafetyChecklist(
      speciesId: 'boletus_edulis',
      items: [
        BotanicalCheckItem(
          id: 'pores_white_yellow',
          questionCa:
              'Els porus són blancs o groc-verdants (MAI vermells sang)?',
          questionEs:
              '¿Los poros son blancos o amarillo-verdosos (NUNCA rojo sangre)?',
          questionEn:
              'Are the pores white or yellowish-olive (NEVER blood-red)?',
          detailCa:
              'El Mataparent de Satanàs tòxic (Rubroboletus satanas) té porus vermells vius.',
          detailEs:
              'El Boleto de Satanás tóxico (Rubroboletus satanas) tiene poros rojos vivos.',
          detailEn:
              'Toxic Satan\'s Bolete (Rubroboletus satanas) has vivid carmine-red pores.',
        ),
        BotanicalCheckItem(
          id: 'flesh_immutable',
          questionCa:
              'La carn roman blanca o immutable en tallar-la (NO blaveja)?',
          questionEs:
              '¿La carne permanece blanca o inmutable al corte (NO azulea)?',
          questionEn:
              'Does the flesh remain white/unchanged upon cutting (does NOT blue)?',
          detailCa: 'El Cep noble mai blaveja al tall.',
          detailEs: 'El Boleto comestible nunca azulea al corte.',
          detailEn: 'True Penny Bun porcini flesh never blues upon bruising.',
        ),
      ],
    ),
    'boletus_aereus': const BotanicalSafetyChecklist(
      speciesId: 'boletus_aereus',
      items: [
        BotanicalCheckItem(
          id: 'pores_white_yellow',
          questionCa:
              'Els porus són blancs o groc-verdants (MAI vermells sang)?',
          questionEs:
              '¿Los poros son blancos o amarillo-verdosos (NUNCA rojo sangre)?',
          questionEn:
              'Are the pores white or yellowish-olive (NEVER blood-red)?',
          detailCa:
              'El Mataparent de Satanàs tòxic (Rubroboletus satanas) té porus vermells vius.',
          detailEs:
              'El Boleto de Satanás tóxico (Rubroboletus satanas) tiene poros rojos vivos.',
          detailEn:
              'Toxic Satan\'s Bolete (Rubroboletus satanas) has vivid carmine-red pores.',
        ),
        BotanicalCheckItem(
          id: 'flesh_immutable',
          questionCa:
              'La carn roman immutablement blanca en tallar-la (NO blaveja)?',
          questionEs:
              '¿La carne permanece blanca inmutable al corte (NO azulea)?',
          questionEn:
              'Does the flesh remain white/unchanged upon cutting (does NOT blue)?',
          detailCa: 'El Cep negre manté sempre la carn blanca pura.',
          detailEs: 'El Boleto negro mantiene siempre la carne blanca pura.',
          detailEn: 'Queen bolete flesh remains strictly white upon cutting.',
        ),
      ],
    ),

    // 7. Múrgola (Morchella esculenta) vs Gyromitra esculenta (mortal)
    'morchella_esculenta': const BotanicalSafetyChecklist(
      speciesId: 'morchella_esculenta',
      items: [
        BotanicalCheckItem(
          id: 'morchella_cap_hollow',
          questionCa:
              'El barret és completament buit per dins, formant una sola cavitat contínua amb la cama?',
          questionEs:
              '¿El sombrero está completamente hueco por dentro, formando una sola cavidad continua con el pie?',
          questionEn:
              'Is the cap completely hollow inside, forming a single continuous chamber with the stem?',
          detailCa:
              'La Falsa múrgola mortal (Gyromitra esculenta) té l\'interior massís o compartimentat en cambres irregulars.',
          detailEs:
              'La Falsa colmenilla mortal (Gyromitra esculenta) tiene el interior macizo o compartimentado en cámaras.',
          detailEn:
              'Deadly False Morel (Gyromitra esculenta) is solid or chambered inside rather than a single hollow cavity.',
        ),
        BotanicalCheckItem(
          id: 'morchella_honeycomb_pits',
          questionCa:
              'La superfície del barret té alvèols regulars com una bresca d\'abelles (NO plecs sinuosos com un cervell)?',
          questionEs:
              '¿La superficie del sombrero tiene alvéolos regulares como un panal (NO pliegues sinuosos de cerebro)?',
          questionEn:
              'Does the cap surface have regular honeycomb-like pits (NOT brain-like convoluted folds)?',
          detailCa:
              'Gyromitra té plecs cerebriformes irregulars i conté giromitrina mortal.',
          detailEs:
              'Gyromitra tiene pliegues cerebriformes y contiene giromitrina mortal.',
          detailEn:
              'Gyromitra has irregular brain-like lobes and contains lethal cumulative gyromitrin.',
        ),
      ],
    ),

    // 8. Rossinyol (Cantharellus cibarius) vs Omphalotus olearius (tòxic)
    'cantharellus_cibarius': const BotanicalSafetyChecklist(
      speciesId: 'cantharellus_cibarius',
      items: [
        BotanicalCheckItem(
          id: 'cantharellus_false_gills',
          questionCa:
              'Té plecs o venes gruixudes bifurcades decurrents (MAI làmines vertaderes fines i tallants)?',
          questionEs:
              '¿Tiene pliegues o venas gruesas bifurcadas decurrentes (NUNCA láminas verdaderas finas y cortantes)?',
          questionEn:
              'Does it have thick, blunt, fork-veined false ridges (NEVER sharp, thin true gills)?',
          detailCa:
              'La Gírgola d\'olivera tòxica (Omphalotus olearius) té làmines vertaderes fines i tallants molt atapeïdes.',
          detailEs:
              'La Seta de olivo tóxica (Omphalotus olearius) tiene láminas verdaderas finas y apretadas.',
          detailEn:
              'Toxic Jack-o\'Lantern (Omphalotus olearius) has blade-like, thin, crowded true gills.',
        ),
        BotanicalCheckItem(
          id: 'cantharellus_ground_habitat',
          questionCa:
              'Neix a terra del bosc (NO directament en feixos sobre soques o fusta d\'olivera/alzina)?',
          questionEs:
              '¿Nace en el suelo del bosque (NO en densos ramos sobre tocones o madera de olivo/encina)?',
          questionEn:
              'Does it grow on woodland soil (NOT in clumps directly on tree stumps or wood)?',
          detailCa:
              'Omphalotus creix cespitós directament sobre fusta i és fortament emètic.',
          detailEs:
              'Omphalotus crece en densos grupos cespitosos sobre madera y es fuertemente emético.',
          detailEn:
              'Omphalotus grows in dense clusters on wood and causes severe gastrointestinal poisoning.',
        ),
      ],
    ),

    // 9. Pampa / Pimpinella morada (Lepista nuda) vs Cortinarius orellanus (mortal)
    'lepista_nuda': const BotanicalSafetyChecklist(
      speciesId: 'lepista_nuda',
      items: [
        BotanicalCheckItem(
          id: 'lepista_no_cortina',
          questionCa:
              'La cama i el marge estan nets de cortina filamentosa o restes de teranyina rovellada?',
          questionEs:
              '¿El pie y el margen están limpios de cortina filamentosa o restos de telaraña oxidada?',
          questionEn:
              'Are the stem and margin free of cobwebby cortina veil threads or rusty filaments?',
          detailCa:
              'Els Cortinaris mortals o tòxics tenen cortina filamentosa i dipòsit d\'espores rovellades.',
          detailEs:
              'Los Cortinarios mortales tienen cortina como telaraña y esporas herrumbrosas.',
          detailEn:
              'Deadly Cortinarius species have a fibrous spider-web cortina and rusty-brown spores.',
        ),
        BotanicalCheckItem(
          id: 'lepista_spore_odor',
          questionCa:
              'Fa una olor perfumada aromàtica agradable i té esporada blanquinosa-rosada (MAI marró rovell)?',
          questionEs:
              '¿Desprende un olor perfumado agradable y tiene esporada blanquecina-rosada (NUNCA pardo herrumbroso)?',
          questionEn:
              'Does it have a pleasant fruity/aromatic odor and pale spore print (NEVER rusty brown)?',
          detailCa:
              'L\'esporada bruna rovellada és exclusiva del gènere Cortinarius.',
          detailEs:
              'La esporada pardo-rojiza es exclusiva del género Cortinarius.',
          detailEn:
              'Rusty-cinnamon spore deposit is the trademark of dangerous Cortinarius species.',
        ),
      ],
    ),

    // 10. Cama-sec / Carrereta (Marasmius oreades) vs Clitocybes blancs tòxics
    'marasmius_oreades': const BotanicalSafetyChecklist(
      speciesId: 'marasmius_oreades',
      items: [
        BotanicalCheckItem(
          id: 'marasmius_stem_elasticity',
          questionCa:
              'La cama és summament elàstica i es pot torçar sobre si mateixa sense trencar-se?',
          questionEs:
              '¿El pie es muy elástico y se puede retorcer sobre sí mismo sin romperse?',
          questionEn:
              'Is the stem highly pliable and elastic, twisting without easily snapping?',
          detailCa:
              'Els clitocibes i inòcibes blancs verinosos tenen la cama fràgil i trencadissa.',
          detailEs:
              'Los clitocibes e inócibes blancos venenosos tienen el pie quebradizo.',
          detailEn:
              'Toxic white Clitocybe and Inocybe species have brittle, fragile stems.',
        ),
        BotanicalCheckItem(
          id: 'marasmius_pasture_gills',
          questionCa:
              'Té làmines amples molt espaiades i creix a prats formant erols o rotllanes?',
          questionEs:
              '¿Tiene láminas anchas y muy espaciadas, y crece en praderas formando corros de brujas?',
          questionEn:
              'Does it have broad, distant gills and grow in grassland fairy rings?',
          detailCa:
              'Descarta clitocibes tòxics de bosc amb làmines decurrents molt atapeïdes.',
          detailEs:
              'Descarta clitocibes tóxicos de bosque con láminas decurrentes apretadas.',
          detailEn:
              'Rules out forest toxic clitocybes with crowded decurrent gills.',
        ),
      ],
    ),

    // 11. Ou de reig (Amanita caesarea) vs Amanita muscaria (tòxica)
    'amanita_caesarea': const BotanicalSafetyChecklist(
      speciesId: 'amanita_caesarea',
      items: [
        BotanicalCheckItem(
          id: 'caesarea_cap_smooth_orange',
          questionCa:
              'El barret és d\'un taronja daurat viu, llis i despullat (sense berrugues blanques piramidals)?',
          questionEs:
              '¿El sombrero es de un naranja dorado vivo, liso y desnudo (sin verrugas blancas piramidales)?',
          questionEn:
              'Is the cap bright golden-orange, smooth and bare (without white pyramidal warts)?',
          detailCa:
              'El Reig bord tòxic (Amanita muscaria) és vermell escarlata i cobert de berrugues blanques.',
          detailEs:
              'La falsa oronja tóxica (Amanita muscaria) es roja viva y cubierta de verrugas blancas.',
          detailEn:
              'Toxic Fly Agaric (Amanita muscaria) has a red cap covered in white flaky warts.',
        ),
        BotanicalCheckItem(
          id: 'caesarea_yellow_gills_stem',
          questionCa:
              'Les làmines, la cama i l\'anell són de color groc rovell d\'ou intens (MAI blancs)?',
          questionEs:
              '¿Las láminas, el pie y el anillo son de color amarillo yema intenso (NUNCA blancos)?',
          questionEn:
              'Are the gills, stem, and ring intense egg-yolk yellow (NEVER pure white)?',
          detailCa:
              'Amanita muscaria té les làmines i el peu sempre d\'un blanc immaculat.',
          detailEs:
              'Amanita muscaria tiene láminas y pie de un blanco puro inmutable.',
          detailEn:
              'Amanita muscaria always has permanent pure white gills and stem.',
        ),
        BotanicalCheckItem(
          id: 'caesarea_saccate_volva',
          questionCa:
              'La base del peu té una volva blanca membranosa molt gran en forma de sac lliure?',
          questionEs:
              '¿La base del pie tiene una volva membranosa blanca muy grande en forma de saco libre?',
          questionEn:
              'Does the stem base sit in a large, thick, white saccate volva resembling an open eggshell?',
          detailCa:
              'La volva blanca envoltant el peu groc és el tret inconfusible de l\'Ou de reig.',
          detailEs:
              'La volva blanca en forma de cáscara de huevo es exclusiva de la Oronja.',
          detailEn:
              'The white eggshell-like volva surrounding a yellow stem is unique to Caesar\'s Mushroom.',
        ),
      ],
    ),

    // 12. Groguet (Tricholoma equestre) - Advertència de toxicitat
    'tricholoma_equestre': const BotanicalSafetyChecklist(
      speciesId: 'tricholoma_equestre',
      items: [
        BotanicalCheckItem(
          id: 'equestre_toxicity_caution',
          questionCa:
              'Ets conscient que el Groguet es considera TÒXIC (risc greu de rabdomiòlisi per consum reiterat)?',
          questionEs:
              '¿Eres consciente de que la Seta de los caballeros se considera TÓXICA (riesgo de rabdomiólisis)?',
          questionEn:
              'Are you aware that the Yellow Knight is classified as TOXIC (risk of rhabdomyolysis)?',
          detailCa:
              'El consum reiterat o abundant pot provocar lesions musculars greus. No s\'ha de consumir.',
          detailEs:
              'El consumo reiterado causa rabdomiólisis grave. No se debe consumir bajo ningún concepto.',
          detailEn:
              'Repeated or excessive consumption can induce severe muscle necrosis. Strictly not for eating.',
        ),
        BotanicalCheckItem(
          id: 'equestre_bright_yellow',
          questionCa:
              'El barret, les làmines i el peu són completament grocs sofre, sense anell ni volva?',
          questionEs:
              '¿El sombrero, láminas y pie son completamente amarillo azufre, sin anillo ni volva?',
          questionEn:
              'Are cap, gills, and stem entirely sulfur-yellow, without any ring or volva?',
          detailCa:
              'Distingeix el groguet d\'Amanites grogues que presenten volva a la base o anell.',
          detailEs: 'Distingue esta especie de Amanitas con anillo o volva.',
          detailEn:
              'Distinguishes the specimen from ringed or volvate yellow Amanita species.',
        ),
      ],
    ),

    // 13. Reconeixement de seguretat per a bolets mortals i tòxics
    'amanita_phalloides': const BotanicalSafetyChecklist(
      speciesId: 'amanita_phalloides',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que la Farinera borda (Amanita phalloides) és MORTAL i que el seu consum és fatal?',
          questionEs:
              '¿Entiendes que la Cicuta verde (Amanita phalloides) es MORTAL y su consumo es letal?',
          questionEn:
              'Do you acknowledge that the Death Cap (Amanita phalloides) is DEADLY and fatal if eaten?',
          detailCa:
              'Conté amatoxines que causen necrosi hepàtica fulminant irreversible.',
          detailEs:
              'Contiene amatoxinas que causan necrosis hepática fulminante irreversible.',
          detailEn:
              'Contains amatoxins causing irreversible, fulminant liver and kidney necrosis.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'No manipulis l\'exemplar juntament amb bolets comestibles al cistell.',
          detailEs:
              'No manipules el ejemplar junto a setas comestibles en la cesta.',
          detailEn:
              'Never place toxic or deadly specimens in the same basket with edible mushrooms.',
        ),
      ],
    ),
    'amanita_verna': const BotanicalSafetyChecklist(
      speciesId: 'amanita_verna',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que la Cicuta blanca (Amanita verna) és MORTAL i conté amatoxines fulminants?',
          questionEs:
              '¿Entiendes que la Oronja blanca (Amanita verna) es MORTAL y contiene amatoxinas fulminantes?',
          questionEn:
              'Do you acknowledge that the Spring Amanita (Amanita verna) is DEADLY and contains lethal amatoxins?',
          detailCa:
              'Una sola dosi pot ser fatal; provoca destrucció cel·lular hepàtica i renal.',
          detailEs:
              'Una sola dosis es letal; provoca destrucción celular hepática y renal.',
          detailEn:
              'A single cap is lethal; destroys hepatic and renal cellular structures.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'Mai manipulis exemplars mortals barrejats amb comestibles.',
          detailEs:
              'Nunca manipules ejemplares mortales mezclados con comestibles.',
          detailEn:
              'Never handle deadly specimens alongside edible collections.',
        ),
      ],
    ),
    'amanita_virosa': const BotanicalSafetyChecklist(
      speciesId: 'amanita_virosa',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que la Farinera pudent (Amanita virosa) és MORTAL i el seu consum és fatal?',
          questionEs:
              '¿Entiendes que la Cicuta fétida (Amanita virosa) es MORTAL y su consumo es letal?',
          questionEn:
              'Do you acknowledge that the Destroying Angel (Amanita virosa) is DEADLY and fatal if eaten?',
          detailCa:
              'Conté amatoxines mortals que produeixen fallada hepàtica irreversible.',
          detailEs:
              'Contiene amatoxinas mortales que producen fallo hepático irreversible.',
          detailEn:
              'Contains deadly amatoxins causing irreversible fulminant liver failure.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'Tingues la màxima precaució: mantén allunyat del cistell de consum.',
          detailEs:
              'Extrema la precaución: mantén alejado de la cesta de consumo.',
          detailEn:
              'Exercise extreme care: keep strictly separate from harvest baskets.',
        ),
      ],
    ),
    'cortinarius_orellanus': const BotanicalSafetyChecklist(
      speciesId: 'cortinarius_orellanus',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que el Cortinari de muntanya és MORTAL i conté orellanina?',
          questionEs:
              '¿Entiendes que el Cortinario de montaña es MORTAL y contiene orellanina?',
          questionEn:
              'Do you acknowledge that the Fool\'s Webcap is DEADLY and contains orellanine?',
          detailCa:
              'L\'orellanina té un període de latència de fins a 14 dies i destrueix irreversiblement els ronyons.',
          detailEs:
              'La orellanina tiene latencia de hasta 14 días y destruye de forma irreversible los riñones.',
          detailEn:
              'Orellanine has an incubation period of up to 14 days and causes irreversible renal destruction.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa: 'Espècie protegida i estrictament no comestible.',
          detailEs:
              'Especie estrictamente no comestible para observación botánica.',
          detailEn:
              'Strictly inedible species intended solely for botanical monitoring.',
        ),
      ],
    ),
    'galerina_marginata': const BotanicalSafetyChecklist(
      speciesId: 'galerina_marginata',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que la Galerina mortal és MORTAL i conté les mateixes amatoxines que l\'Amanita phalloides?',
          questionEs:
              '¿Entiendes que la Galerina marginata es MORTAL y contiene amatoxinas letales?',
          questionEn:
              'Do you acknowledge that the Funeral Bell is DEADLY and contains lethal amatoxins?',
          detailCa:
              'Creix sobre fusta de coníferes i una petita quantitat pot causar la mort.',
          detailEs:
              'Crece sobre madera de coníferas y una pequeña cantidad causa la muerte.',
          detailEn:
              'Grows on conifer stumps and small amounts can cause fatal liver necrosis.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'Perill extrem de confusió amb carreretes o gírgoles de soca.',
          detailEs:
              'Peligro extremo de confusión con setas de tocón comestibles.',
          detailEn:
              'Extreme hazard of confusion with edible lignicolous stump clusters.',
        ),
      ],
    ),
    'gyromitra_esculenta': const BotanicalSafetyChecklist(
      speciesId: 'gyromitra_esculenta',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que el Bolet de greix / Falsa múrgola és MORTAL i conté giromitrina?',
          questionEs:
              '¿Entiendes que la Falsa colmenilla es MORTAL y contiene giromitrina?',
          questionEn:
              'Do you acknowledge that the False Morel is DEADLY and contains gyromitrin?',
          detailCa:
              'La giromitrina es metabolitza en monometilhidrazina, destruint fetge i ronyons.',
          detailEs:
              'La giromitrina se metaboliza en monometilhidrazina, destruyendo hígado y riñones.',
          detailEn:
              'Gyromitrin metabolizes into monomethylhydrazine, destroying red blood cells, liver, and kidneys.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa: 'MAI s\'ha de consumir ni tan sols assecat o bullit.',
          detailEs: 'NUNCA se debe consumir ni siquiera hervida o seca.',
          detailEn:
              'NEVER consume this species even after parboiling or drying.',
        ),
      ],
    ),
    'paxillus_involutus': const BotanicalSafetyChecklist(
      speciesId: 'paxillus_involutus',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que el Paxil·le involut és MORTAL i provoca la síndrome paxíl·lica autoimmune?',
          questionEs:
              '¿Entiendes que el Paxilo enrollado es MORTAL y causa el síndrome paxílico autoinmune?',
          questionEn:
              'Do you acknowledge that the Brown Roll-Rim is DEADLY and causes autoimmune Paxillus syndrome?',
          detailCa:
              'El consum reiterat sensibilitza l\'organisme i desencadena una hemòlisi intravascular aguda massiva que col·lapsa els ronyons.',
          detailEs:
              'El consumo reiterado provoca una hemólisis intravascular aguda masiva con colapso renal potencialmente fatal.',
          detailEn:
              'Repeated ingestion triggers massive autoimmune hemolysis and acute renal failure.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'Antigament considerat comestible bullit, avui la ciència el classifica com a potencialment mortal.',
          detailEs:
              'Antiguamente consumido hervido, hoy la ciencia lo cataloga como potencialmente mortal.',
          detailEn:
              'Historically cooked in some regions, modern toxicology classifies it as potentially lethal.',
        ),
      ],
    ),
    'inocybe_erubescens': const BotanicalSafetyChecklist(
      speciesId: 'inocybe_erubescens',
      items: [
        BotanicalCheckItem(
          id: 'deadly_acknowledgement',
          questionCa:
              'Entens que l\'Inòcibe de Patouillard és MORTAL i conté altes dosis de muscarina?',
          questionEs:
              '¿Entiendes que el Inocibe de Patouillard es MORTAL y contiene altas dosis de muscarina?',
          questionEn:
              'Do you acknowledge that the Red-Staining Inocybe is DEADLY and contains lethal muscarine levels?',
          detailCa:
              'La muscarina provoca síndrome colinèrgic greu amb bradicàrdia severa, xoc i aturada cardíaca en pocs minuts.',
          detailEs:
              'La muscarina provoca choque colinérgico severo, bradicardia extrema y parada cardiorrespiratoria.',
          detailEn:
              'High muscarine concentration causes cholinergic shock, severe bradycardia, and cardiac arrest.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa:
              'A la primavera es confon tràgicament amb el moixernó; té barret cònic i s\'enrogeix en fregar-lo.',
          detailEs:
              'En primavera se confunde con la seta de San Jorge; tiene sombrero cónico y enrojece fuertemente al roce.',
          detailEn:
              'Tragically confused with spring edible St. George\'s mushroom; has a conical cap and stains brick-red.',
        ),
      ],
    ),

    // 14. Cua de cavall / Vinosa (Amanita rubescens) - Comestible amb cocció forta
    'amanita_rubescens': const BotanicalSafetyChecklist(
      speciesId: 'amanita_rubescens',
      items: [
        BotanicalCheckItem(
          id: 'rubescens_vinous_bruising',
          questionCa:
              'La carn, el peu i les ferides prenen taques vinoses o vermelloses amb l\'aire o al frec?',
          questionEs:
              '¿La carne, el pie y las heridas toman tonos vinosos o rojizos al corte o roce?',
          questionEn:
              'Does the flesh, stipe, and any damaged area bruise distinctly wine-red / vinous?',
          detailCa:
              'La Pantera molt tòxica (Amanita pantherina) té la carn sempre immaculadament blanca (mai enrogeix).',
          detailEs:
              'La Pantera muy tóxica (Amanita pantherina) tiene carne permanentemente blanca (nunca enrojece).',
          detailEn:
              'Highly toxic Panther Cap (Amanita pantherina) has immutable, pure white flesh that never turns red.',
        ),
        BotanicalCheckItem(
          id: 'rubescens_striate_ring',
          questionCa:
              'L\'anell és ampli, membranós i clarament estriat/solcat a la cara superior?',
          questionEs:
              '¿El anillo es amplio, membranoso y claramente estriado en la cara superior?',
          questionEn:
              'Is the hanging membranous ring distinctly grooved/striated on its upper surface?',
          detailCa:
              'Amanita pantherina té l\'anell llis (no estriat) i volva circuncisa esglaonada.',
          detailEs:
              'Amanita pantherina tiene anillo liso y volva circuncisa en burletes escalonados.',
          detailEn:
              'Amanita pantherina has a smooth (non-striate) ring and stepped volva gutters at the base.',
        ),
        BotanicalCheckItem(
          id: 'rubescens_cook_mandatory',
          questionCa:
              'Ets conscient que és TÒXICA EN CRU i que s\'ha de coure a fons (>70 °C durant més de 15 minuts)?',
          questionEs:
              '¿Eres consciente de que es TÓXICA EN CRUDO y debe cocinarse a fondo (>70 °C más de 15 minutos)?',
          questionEn:
              'Do you acknowledge it is TOXIC RAW and must be thoroughly cooked (>70 °C for over 15 minutes)?',
          detailCa:
              'Conté rubescenslisina que destrueix els glòbuls vermells; la calor sostinguda la desactiva per complet.',
          detailEs:
              'Contiene hemolisinas termolábiles destructoras de hematíes; el calor intenso las destruye totalmente.',
          detailEn:
              'Contains thermolabile hemolysins destroyed only by sustained, thorough boiling or sautéing.',
        ),
      ],
    ),

    // 15. Tòfones (Tuber melanosporum & Tuber aestivum) vs Scleroderma citrinum
    'tuber_melanosporum': const BotanicalSafetyChecklist(
      speciesId: 'tuber_melanosporum',
      items: [
        BotanicalCheckItem(
          id: 'truffle_harvest_gleba',
          questionCa:
              'És un fong subterrani amb peridi negre berrugós i gleba interna marbrada de venes blanques?',
          questionEs:
              '¿Es un hongo subterráneo con piel negra verrugosa y gleba veteada de blanco?',
          questionEn:
              'Is it an underground truffle with black warty peridium and white-marbled gleba?',
          detailCa:
              'El Patac d\'ase tòxic (Scleroderma citrinum) creix a la superfície i té l\'interior negre massís uniforme.',
          detailEs:
              'El falso pedo de lobo tóxico crece en superficie y tiene interior negro uniforme sin vetas.',
          detailEn:
              'Toxic Earthball grows on the soil surface with a solid, unmarbled coal-black interior.',
        ),
        BotanicalCheckItem(
          id: 'truffle_intense_aroma',
          questionCa:
              'Desprèn una intensa i refinada aroma fúngica i d\'humus (NO olor desagradable metàl·lica/química)?',
          questionEs:
              '¿Desprende un intenso y refinado aroma fúngico (NO olor desagradable a goma/químico)?',
          questionEn:
              'Does it have an intense, refined truffle perfume (NOT an unpleasant metallic or rubber smell)?',
          detailCa: 'Scleroderma fa una olor desagradable de cuir vell o gas.',
          detailEs: 'Scleroderma huele de forma desagradable a gas o caucho.',
          detailEn:
              'Earthball smells unpleasantly of gas, rubber, or pungent chemicals.',
        ),
      ],
    ),
    'tuber_aestivum': const BotanicalSafetyChecklist(
      speciesId: 'tuber_aestivum',
      items: [
        BotanicalCheckItem(
          id: 'truffle_summer_pyramidal',
          questionCa:
              'El peridi té grans berrugues piramidals negres i la gleba és marró avellana vetejada de blanc?',
          questionEs:
              '¿La piel tiene grandes verrugas piramidales y la gleba es pardo avellana con vetas blancas?',
          questionEn:
              'Does the skin have large black pyramidal warts and pale hazelnut interior marbled with white veins?',
          detailCa:
              'El Patac d\'ase té pell groguenca i gleba negra homogènia sense venes.',
          detailEs:
              'El falso pedo de lobo tiene piel amarillenta y gleba negra uniforme sin vetas.',
          detailEn:
              'Toxic Earthball has yellowish skin and solid black interior lacking veins.',
        ),
        BotanicalCheckItem(
          id: 'truffle_underground_dog',
          questionCa:
              'Ha estat trobada sota terra a l\'estiu o principis de tardor?',
          questionEs:
              '¿Ha sido recolectada bajo tierra en verano o principios de otoño?',
          questionEn:
              'Was it foraged underground during summer or early autumn?',
          detailCa:
              'Les tòfones són fongs hipogeus que maduren sota la fullaraca o sota terra.',
          detailEs: 'Las trufas son hongos hipogeos que maduran bajo tierra.',
          detailEn:
              'True truffles fruit and mature strictly hypogeously beneath the topsoil.',
        ),
      ],
    ),

    // 16. Rovelló de sang vinosa (Lactarius vinosus)
    'lactarius_vinosus': const BotanicalSafetyChecklist(
      speciesId: 'lactarius_vinosus',
      items: [
        BotanicalCheckItem(
          id: 'latex_wine_beetroot',
          questionCa:
              'El làtex és de color vi negre fosc o remolatxa intensa (MAI blanc que grogueja)?',
          questionEs:
              '¿El látex es de color vino tinto oscuro o remolacha intensa (NUNCA blanco que amarillea)?',
          questionEn:
              'Is the latex deep wine-red / beetroot-purple (NEVER white turning yellow)?',
          detailCa:
              'El Fals rovelló tòxic (Lactarius chrysorrheus) té llet blanca que es torna groga ràpidament.',
          detailEs:
              'El Falso níscalo tóxico (Lactarius chrysorrheus) tiene látex blanco que vira a amarillo rápidamente.',
          detailEn:
              'Toxic False Milkcap (Lactarius chrysorrheus) has white milk that quickly turns yellow.',
        ),
        BotanicalCheckItem(
          id: 'margin_smooth_vinosus',
          questionCa:
              'El marge del barret és llis (NO té pèls llanosos abundants com la Cabra)?',
          questionEs:
              '¿El margen del sombrero es liso (NO tiene pelos lanosos como el falso níscalo barbudo)?',
          questionEn:
              'Is the cap margin smooth (NOT densely bearded/shaggy like the Woolly Milkcap)?',
          detailCa:
              'La Cabra tòxica (Lactarius torminosus) té el marge molt pelut i llet blanca coent.',
          detailEs:
              'El Falso níscalo barbado (Lactarius torminosus) tiene margen peludo y látex blanco picante.',
          detailEn:
              'Toxic Woolly Milkcap (Lactarius torminosus) has shaggy bearded margins and acrid white milk.',
        ),
      ],
    ),

    // 17. Fredolic d'anís (Tricholoma portentosum)
    'tricholoma_portentosum': const BotanicalSafetyChecklist(
      speciesId: 'tricholoma_portentosum',
      items: [
        BotanicalCheckItem(
          id: 'portentosum_streaked_cap',
          questionCa:
              'El barret és gris sutge amb fibril·les radials fosques i reflexos groguencs (sense esquames teulades)?',
          questionEs:
              '¿El sombrero es gris hollín con fibrillas oscuras y reflejos amarillos (sin escamas de tejas)?',
          questionEn:
              'Is the cap soot-grey with dark radiating streaks and yellowish tints (without coarse shingle scales)?',
          detailCa:
              'El Fredolic bord tòxic (Tricholoma pardinum) té esquames concèntriques grosses com teules.',
          detailEs:
              'El Tricoloma atigrado tóxico tiene escamas concéntricas gruesas como tejas.',
          detailEn:
              'Toxic Tiger Tricholoma (Tricholoma pardinum) has heavy concentric shingle-like scales.',
        ),
        BotanicalCheckItem(
          id: 'portentosum_anise_scent',
          questionCa:
              'Fa una suau olor de farina i anís (NO olor de sabó de rentar la roba ni detergent)?',
          questionEs:
              '¿Tiene un suave olor a harina y anís (NO olor a jabón de lavar la ropa ni detergente)?',
          questionEn:
              'Does it have a delicate fresh flour and anise aroma (NOT laundry soap or detergent smell)?',
          detailCa:
              'El Bolet de sabó tòxic (Tricholoma saponaceum) fa una forta olor de sabó i té la base rosa.',
          detailEs:
              'El Tricoloma jabonoso tóxico huele intensamente a jabón de lavandería y tiene base rosada.',
          detailEn:
              'Toxic Soapy Knight (Tricholoma saponaceum) smells strongly of laundry detergent with a pinkish base.',
        ),
      ],
    ),

    // 18. Farinera groga / Reig de la mort fals (Amanita citrina)
    'amanita_citrina': const BotanicalSafetyChecklist(
      speciesId: 'amanita_citrina',
      items: [
        BotanicalCheckItem(
          id: 'citrina_toxic_acknowledgement',
          questionCa:
              'Entens que la Farinera groga (Amanita citrina) és TÒXICA (conté bufotenina) i té alt risc de confusió amb la mortal Amanita phalloides?',
          questionEs:
              '¿Entiendes que la Falsa oronja (Amanita citrina) es TÓXICA (contiene bufotenina) y se confunde fácilmente con la mortal Amanita phalloides?',
          questionEn:
              'Do you acknowledge that the False Death Cap (Amanita citrina) is TOXIC (contains bufotenine) and is easily confused with deadly Amanita phalloides?',
          detailCa:
              'La Farinera groga té bulb marginat abrupte i olor de patata crua; la mortal Farinera borda té volva en sac membranós lliure.',
          detailEs:
              'La Falsa oronja tiene bulbo marginado y olor a patata cruda; la mortal Oronja verde tiene volva en saco libre.',
          detailEn:
              'False Death Cap has a margined bulb and raw potato odor; deadly Death Cap has a loose saccate volva.',
        ),
        BotanicalCheckItem(
          id: 'study_only_confirmation',
          questionCa:
              'Confirmes que aquest registre és exclusivament per a estudi botànic i conservació?',
          questionEs:
              '¿Confirmas que este registro es exclusivamente para estudio botánico y conservación?',
          questionEn:
              'Do you confirm this sighting is recorded solely for botanical study and biodiversity conservation?',
          detailCa: 'Mai recolliu cap Amanita groga o blanca per al consum.',
          detailEs:
              'Nunca recolectéis ninguna Amanita amarilla o blanca para el consumo.',
          detailEn:
              'Never harvest any yellow or white Amanita species for consumption.',
        ),
      ],
    ),
  };
}
