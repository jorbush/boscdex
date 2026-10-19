class CulinaryRecipe {
  final String speciesId;
  final String dishNameCa;
  final String dishNameEs;
  final String dishNameEn;
  final String descriptionCa;
  final String descriptionEs;
  final String descriptionEn;
  final String methodCa;
  final String methodEs;
  final String methodEn;
  final String tipCa;
  final String tipEs;
  final String tipEn;
  final String winePairingCa;
  final String winePairingEs;
  final String winePairingEn;

  const CulinaryRecipe({
    required this.speciesId,
    required this.dishNameCa,
    required this.dishNameEs,
    required this.dishNameEn,
    required this.descriptionCa,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.methodCa,
    required this.methodEs,
    required this.methodEn,
    required this.tipCa,
    required this.tipEs,
    required this.tipEn,
    required this.winePairingCa,
    required this.winePairingEs,
    required this.winePairingEn,
  });

  String getDishName(String languageCode) {
    switch (languageCode) {
      case 'es':
        return dishNameEs;
      case 'en':
        return dishNameEn;
      case 'ca':
      default:
        return dishNameCa;
    }
  }

  String getDescription(String languageCode) {
    switch (languageCode) {
      case 'es':
        return descriptionEs;
      case 'en':
        return descriptionEn;
      case 'ca':
      default:
        return descriptionCa;
    }
  }

  String getMethod(String languageCode) {
    switch (languageCode) {
      case 'es':
        return methodEs;
      case 'en':
        return methodEn;
      case 'ca':
      default:
        return methodCa;
    }
  }

  String getTip(String languageCode) {
    switch (languageCode) {
      case 'es':
        return tipEs;
      case 'en':
        return tipEn;
      case 'ca':
      default:
        return tipCa;
    }
  }

  String getWinePairing(String languageCode) {
    switch (languageCode) {
      case 'es':
        return winePairingEs;
      case 'en':
        return winePairingEn;
      case 'ca':
      default:
        return winePairingCa;
    }
  }

  static const Set<String> gourmetSpeciesIds = {
    'tuber_melanosporum',
    'infundibulicybe_geotropa',
    'boletus_pinophilus',
    'neoboletus_luridiformis',
    'boletus_reticulatus',
    'hygrophorus_marzuolus',
    'russula_aurea',
    'craterellus_tubaeformis',
    'agaricus_arvensis',
    'hydnum_rufescens',
    'boletus_edulis',
    'boletus_aereus',
    'amanita_caesarea',
    'cantharellus_cibarius',
    'craterellus_cornucopioides',
    'craterellus_lutescens',
  };

  static CulinaryRecipe? forSpecies(String speciesId) {
    return _recipes[speciesId];
  }

  static const Map<String, CulinaryRecipe> _recipes = {
    'tuber_melanosporum': CulinaryRecipe(
      speciesId: 'tuber_melanosporum',
      dishNameCa: 'Ous ferrats amb tòfona negra de Vic',
      dishNameEs: 'Huevos fritos con trufa negra de Vic',
      dishNameEn: 'Fried Farm Eggs with Shaved Black Truffle',
      descriptionCa:
          'El clàssic per excel·lència de la cuina d\'Osona: rovells melosos perfumats al moment amb làmines fines de tòfona negra fresca.',
      descriptionEs:
          'El clásico por excelencia de la cocina catalana: yemas melosas perfumadas al momento con láminas de trufa negra fresca.',
      descriptionEn:
          'The quintessential pairing: runny farm egg yolks infused with freshly shaved black truffle and flaky sea salt.',
      methodCa:
          'Fregiu ous de pagès en oli d\'oliva verge extra. Serviu-los ben calents i ratlleu o lamineu la tòfona directament al damunt amb una mica de flor de sal.',
      methodEs:
          'Fríe huevos de corral en AOVE. Sírvelos muy calientes y lamina la trufa directamente encima con escamas de sal.',
      methodEn:
          'Fry farm-fresh eggs in extra virgin olive oil. Serve piping hot and shave truffle directly on top with flaky sea salt.',
      tipCa:
          'Guardeu la tòfona en un pot hermètic amb els ous crus durant 48 hores: la closca porosa n\'absorbirà tota l\'aroma abans de coure\'ls.',
      tipEs:
          'Guarda la trufa en un tarro hermético con los huevos crudos 48 horas: la cáscara porosa absorberá todo el aroma.',
      tipEn:
          'Store the truffle in an airtight jar with whole uncooked eggs for 48 hours to infuse the yolks through the porous shells.',
      winePairingCa:
          'Vi negre amb cos de la DO Empordà o un cava brut nature gran reserva.',
      winePairingEs:
          'Tinto con cuerpo DO Empordà o un cava brut nature gran reserva.',
      winePairingEn: 'Full-bodied Empordà red or a vintage Brut Nature Cava.',
    ),
    'infundibulicybe_geotropa': CulinaryRecipe(
      speciesId: 'infundibulicybe_geotropa',
      dishNameCa: 'Fricandó d\'Osona amb pampes',
      dishNameEs: 'Fricandó tradicional con plateras',
      dishNameEn: 'Catalan Veal Stew with Monk\'s Head Mushrooms',
      descriptionCa:
          'Guisat tradicional català de vedella amb suc espès i picada d\'ametlles, on la carn ferma de la pampa absorbeix els sabors del sofregit.',
      descriptionEs:
          'Guiso tradicional catalán de ternera con salsa espesa y picada de almendras, donde la platera absorbe todo el sofrito.',
      descriptionEn:
          'Traditional Catalan slow-cooked veal stew with rich reduction, almond picada, and meaty Monk\'s Head mushrooms.',
      methodCa:
          'Marqueu la carn enfarinada, feu un sofregit lent de ceba i tomàquet, afegiu-hi les pampes netes a trossos i deixeu fer xup-xup lentament amb brou i vi blanc.',
      methodEs:
          'Dora la carne enharinada, sofrito lento de cebolla y tomate, añade las plateras troceadas y cocina a fuego lento con caldo y vino blanco.',
      methodEn:
          'Sear floured veal slices, make a slow sofrito, add chopped mushrooms and simmer slowly with rich broth and white wine.',
      tipCa:
          'Aprofiteu sobretot el barret carnós; descarteu la part més fibrosa del peu si és un exemplar gros.',
      tipEs:
          'Usa sobre todo el sombrero carnoso; descarta la base fibrosa del pie en ejemplares grandes.',
      tipEn:
          'Use mainly the thick fleshy caps; trim fibrous lower stems on mature specimens.',
      winePairingCa: 'Vi negre de la DO Pla de Bages o Costers del Segre.',
      winePairingEs: 'Tinto DO Pla de Bages o Costers del Segre.',
      winePairingEn: 'Pla de Bages red wine or Costers del Segre.',
    ),
    'boletus_pinophilus': CulinaryRecipe(
      speciesId: 'boletus_pinophilus',
      dishNameCa: 'Carpaccio de cep vermell amb pinyons i oli d\'arbequina',
      dishNameEs: 'Carpaccio de boleto pinícola con piñones y aceite arbequina',
      dishNameEn: 'Pine Bolete Carpaccio with Toasted Pine Nuts',
      descriptionCa:
          'Presentació delicada i purista que destaca la textura cruixent i el sabor intensament dolç i avellanat del cep de pi jove.',
      descriptionEs:
          'Presentación delicada que resalta la textura crujiente y sabor dulce a fruto seco del boleto joven.',
      descriptionEn:
          'A pure and delicate dish highlighting the crunchy texture and sweet nutty aroma of firm young pine boletes.',
      methodCa:
          'Talleu el barret molt prim amb mandolina. Col·loqueu les làmines en un plat fred, amaniu amb oli d\'oliva verge extra arbequina, sal Maldon i pinyons torrats.',
      methodEs:
          'Corta láminas muy finas con mandolina, aliña con AOVE arbequina, sal Maldon y piñones tostados.',
      methodEn:
          'Slice caps thinly with a mandoline. Arrange on a chilled plate, drizzle with arbequina extra virgin olive oil, flaky salt, and toasted pine nuts.',
      tipCa:
          'Consumiu en cru únicament exemplars joves, ferms i sans sense cap paràsit.',
      tipEs:
          'Consumir en crudo únicamente ejemplares jóvenes, sanos y bien firmes.',
      tipEn:
          'Consume raw only if using pristine, firm young caps without any insect damage.',
      winePairingCa:
          'Vi blanc fresc i mineral de la DO Terra Alta (Garnatxa blanca).',
      winePairingEs: 'Garnacha blanca DO Terra Alta.',
      winePairingEn: 'Terra Alta Garnatxa Blanca.',
    ),
    'neoboletus_luridiformis': CulinaryRecipe(
      speciesId: 'neoboletus_luridiformis',
      dishNameCa: 'Saltat de peu vermell amb all, julivert i cansalada ibèrica',
      dishNameEs: 'Salteado de pie rojo con panceta ibérica',
      dishNameEn: 'Sautéed Scarletina Bolete with Pancetta',
      descriptionCa:
          'Bolet de carn molt ferma i groguenca que manté una consistència excel·lent a la cassola un cop cuinat adequadament.',
      descriptionEs:
          'Seta de carne muy firme que conserva una textura excelente tras una cocción completa.',
      descriptionEn:
          'A hearty mushroom with firm golden flesh that holds exceptional texture once thoroughly cooked.',
      methodCa:
          'Talleu a daus i salteu a foc viu amb all picat, julivert fresc i daus daurats de cansalada ibèrica fins que quedi ben daurat i tendre.',
      methodEs:
          'Corta a dados y saltea a fuego vivo con ajo picado, perejil y dados de panceta crujiente.',
      methodEn:
          'Dice and sauté over medium-high heat with minced garlic, fresh parsley, and crispy pancetta.',
      tipCa:
          '⚠️ IMPORTANT: Exigeix cocció perllongada (mínim 15-20 minuts). És tòxic si es menja cru o poc cuit.',
      tipEs:
          '⚠️ Cocción prolongada obligatoria (15-20 min). Tóxico en crudo o semicrudo.',
      tipEn:
          '⚠️ Thorough cooking required (15-20 min minimum). Toxic if eaten raw or undercooked.',
      winePairingCa: 'Vi negre jove afruitat del Montsant.',
      winePairingEs: 'Tinto joven de Montsant.',
      winePairingEn: 'Fruity young Montsant red.',
    ),
    'boletus_reticulatus': CulinaryRecipe(
      speciesId: 'boletus_reticulatus',
      dishNameCa: 'Arrossejat de muntanya amb cep d\'estiu i conill',
      dishNameEs: 'Arroz de montaña con boleto de verano y conejo',
      dishNameEn: 'Mountain Rice with Summer Bolete & Rabbit',
      descriptionCa:
          'Arròs sec de caça i bosc típic dels Pirineus catalans, perfumat amb l\'aroma dolça i penetrant del cep d\'estiu.',
      descriptionEs:
          'Arroz seco de monte típico pirenaico perfumado con el aroma dulce del boleto de verano.',
      descriptionEn:
          'Dry mountain rice with rabbit and the intensely fragrant sweet notes of summer boletes.',
      methodCa:
          'Enrossiu el conill, sofregiu la ceba, tomàquet i ceps a làmines, afegiu l\'arròs bomba, mulleu amb brou de carn ben calent i acabeu al forn.',
      methodEs:
          'Dora el conejo, sofrito de cebolla, tomate y setas, añade el arroz y caldo bien caliente.',
      methodEn:
          'Brown rabbit, cook sofrito with sliced boletes, toast Bomba rice and simmer with hot rich stock.',
      tipCa:
          'El cep d\'estiu és molt aromàtic però propens als corcs; comproveu sempre la consistència del peu.',
      tipEs:
          'Muy aromático pero propenso a gusanos; revisar siempre la firmeza del pie.',
      tipEn:
          'Intensely fragrant but prone to insects in warm weather; check stem firmness.',
      winePairingCa:
          'Vi negre criança de la DO Conca de Barberà (Trepat o Ull de llebre).',
      winePairingEs: 'Tinto crianza DO Conca de Barberà.',
      winePairingEn: 'Conca de Barberà red wine.',
    ),
    'hygrophorus_marzuolus': CulinaryRecipe(
      speciesId: 'hygrophorus_marzuolus',
      dishNameCa: 'Guisat de marçots amb costella de porc i carxofes',
      dishNameEs: 'Guiso de marzuelos con costilla y alcachofas',
      dishNameEn: 'March Mushroom Stew with Ribs & Artichokes',
      descriptionCa:
          'L\'avançada de la primavera a la taula: combina el gust fi i suau del marçot amb les carxofes fresques de març.',
      descriptionEs:
          'El despertar de la primavera en la mesa con el sabor fino del marzuelo y alcachofas frescas.',
      descriptionEn:
          'Springtime forest feast combining delicate, buttery March mushrooms with fresh spring artichokes.',
      methodCa:
          'Enrossiu la costella, incorporeu els cors de carxofa i els marçots tallats per la meitat. Tapeu i coeu a foc lent amb un raig de moscatell o vi blanc ranci.',
      methodEs:
          'Dora la costilla, incorpora alcachofas y marzuelos. Guisa a fuego lento con vino blanco.',
      methodEn:
          'Brown pork ribs, add halved March mushrooms and artichoke hearts. Braise gently with aged white wine.',
      tipCa:
          'Renteu amb cura de no trencar-ne la carn, traient la pinassa que sol quedar adherida al barret.',
      tipEs:
          'Limpiar con cuidado retirando las acículas de pino adheridas al sombrero.',
      tipEn:
          'Clean gently with a soft brush to remove pine needles embedded in the cap.',
      winePairingCa: 'Vi blanc criat en bota de la DO Penedès.',
      winePairingEs: 'Blanco con barrica DO Penedès.',
      winePairingEn: 'Oak-aged Penedès white.',
    ),
    'russula_aurea': CulinaryRecipe(
      speciesId: 'russula_aurea',
      dishNameCa: 'Truita suculenta de llora daurada i alls tendres',
      dishNameEs: 'Tortilla de rúsula dorada y ajetes tiernos',
      dishNameEn: 'Golden Brittlegill & Wild Garlic Omelette',
      descriptionCa:
          'Plat senzill i lluminós on el color groc daurat intens del bolet i la seva carn dolça eleven la truita a nivell gurmet.',
      descriptionEs:
          'Plato sencillo y luminoso donde el color amarillo y carne dulce elevan la tortilla a nivel gourmet.',
      descriptionEn:
          'A vibrant dish where the brilliant golden hue and nutty sweet flesh elevate a classic omelette.',
      methodCa:
          'Salteu els alls tendres amb els barrets de llora a tires fines. Bateu els ous amb un pessic de sal, aboqueu-los a la paella i qualleu la truita ben sucosa.',
      methodEs:
          'Saltea ajetes tiernos con la rúsula en tiras. Bate huevos y cuaja la tortilla jugosa.',
      methodEn:
          'Sauté young garlic shoots with sliced caps. Whisk eggs, fold gently, and leave center soft and runny.',
      tipCa:
          'Comproveu sempre el color groc daurat de làmines i peu per no confondre-la amb la rússula emètica de làmines blanques.',
      tipEs:
          'Comprueba siempre el color amarillo de láminas y pie para evitar confusiones con la rúsula blanca.',
      tipEn:
          'Always verify the golden yellow gills and stem to confirm distinction from white-gilled acrid russulas.',
      winePairingCa: 'Vi rosat fresc i aromàtic de la DO Catalunya.',
      winePairingEs: 'Rosado fresco DO Catalunya.',
      winePairingEn: 'Crisp DO Catalunya Rosé.',
    ),
    'craterellus_tubaeformis': CulinaryRecipe(
      speciesId: 'craterellus_tubaeformis',
      dishNameCa: 'Fideuà de muntanya amb trompetes grogues i botifarra negra',
      dishNameEs: 'Fideuá de montaña con trompetas amarillas y butifarra negra',
      dishNameEn: 'Mountain Fideuà with Yellowfeet & Black Sausage',
      descriptionCa:
          'Fideus rossos i torrats amb el toc boscà i afruitat de les trompetes grogues i la profunditat de la botifarra negra.',
      descriptionEs:
          'Fideos tostados con el toque afrutado de la trompeta amarilla y la potencia de la butifarra negra.',
      descriptionEn:
          'Toasted noodles infused with rich mushroom stock, fruity yellowfeet, and traditional Catalan blood sausage.',
      methodCa:
          'Enrossiu els fideus amb oli. A part feu un sofregit amb la botifarra i els bolets sencers. Ajunteu, cobriu amb brou de bolets calent i gratineu 5 minuts amb all-i-oli.',
      methodEs:
          'Tuesta los fideos, sofrito con butifarra y trompetas enteras. Caldo hirviendo y hornea con alioli.',
      methodEn:
          'Toast fideuà noodles in olive oil, toss with sautéed black sausage and whole trumpet chanterelles, add mushroom stock, and broil with garlic alioli.',
      tipCa:
          'No cal tallar-los: posar-los sencers aporta una textura elàstica i visual fantàstica al plat.',
      tipEs:
          'Úsalos enteros: aportan una textura elástica y vistosa inmejorable.',
      tipEn:
          'Cook whole without chopping: their hollow trumpet shape provides fantastic bouncy texture.',
      winePairingCa: 'Vi negre jove del Priorat o Montsant.',
      winePairingEs: 'Tinto joven de Priorat.',
      winePairingEn: 'Priorat or Montsant red.',
    ),
    'agaricus_arvensis': CulinaryRecipe(
      speciesId: 'agaricus_arvensis',
      dishNameCa: 'Xampinyons anisats a la brasa amb pernil i formatge de tupí',
      dishNameEs: 'Bolas de nieve a la brasa con queso tupí y jamón ibérico',
      dishNameEn: 'Grilled Horse Mushrooms with Tupí Cheese & Jamón',
      descriptionCa:
          'Barrets gegants fets al caliu del foc de llenya amb un farcit cremós i salat que contrasta amb les aromes d\'anís.',
      descriptionEs:
          'Grandes sombreros a la brasa con relleno cremoso que contrasta con el toque anisado del hongo.',
      descriptionEn:
          'Jumbo caps roasted over olive wood embers stuffed with Catalan mountain cheese and cured ham.',
      methodCa:
          'Netegeu els barrets, poseu-los de cap per avall a la graella amb unes gotes d\'oli. Farcit amb daus de pernil ibèric i una cullerada de formatge de tupí fos.',
      methodEs:
          'Asa los sombreros boca arriba en la parrilla con AOVE, jamón y queso fundido.',
      methodEn:
          'Place caps gill-side up on the grill with olive oil, then top with diced Iberian ham and melted aged cheese.',
      tipCa:
          'Assegureu-vos que fa bona olor d\'anís i que les làmines no són blanques pures (descarta amanites blanques).',
      tipEs:
          'Asegurar olor a anís y láminas no blancas para descartar amanitas mortales.',
      tipEn:
          'Ensure sweet anise scent and non-white gills to definitively rule out deadly white amanitas.',
      winePairingCa: 'Cava Reserva Brut Nature de l\'Alt Penedès.',
      winePairingEs: 'Cava Reserva Brut Nature.',
      winePairingEn: 'Alt Penedès Reserva Cava.',
    ),
    'hydnum_rufescens': CulinaryRecipe(
      speciesId: 'hydnum_rufescens',
      dishNameCa: 'Estofat de senglar amb llengua de bou i herbes del bosc',
      dishNameEs: 'Estofado de jabalí con lengua de vaca rojiza',
      dishNameEn: 'Wild Boar Stew with Terracotta Hedgehog Mushrooms',
      descriptionCa:
          'Plat fort de caça major on la textura carnosa i ferma de la llengua aguanta hores de cassola sense desfer-se.',
      descriptionEs:
          'Plato de caza mayor donde la textura firme de la seta aguanta horas de cocción lenta.',
      descriptionEn:
          'Robust wild game stew where the firm hedgehog flesh retains perfect bite through hours of slow braising.',
      methodCa:
          'Marineu el senglar amb vi negre i herbes del bosc 12 hores. Estofeu lentament amb verdures i afegiu les llengües de bou saltades la darrera hora de cocció.',
      methodEs:
          'Marina el jabalí 12 horas, estofa con verduras y añade las setas salteadas en la última hora.',
      methodEn:
          'Marinate boar with red wine and rosemary. Braise until fork-tender and add sautéed hedgehog mushrooms in the final hour.',
      tipCa:
          'Rapeu suaument les agulles de sota el barret si l\'exemplar és molt madur per suavitzar l\'amargor.',
      tipEs:
          'Raspar las púas inferiores en ejemplares viejos para suavizar el amargor.',
      tipEn:
          'Scrape off underside spines on mature caps to eliminate any slight bitterness.',
      winePairingCa: 'Vi negre robust del Montsant o Priorat.',
      winePairingEs: 'Tinto potente del Priorat o Montsant.',
      winePairingEn: 'Robust Montsant or Priorat red.',
    ),
    'boletus_edulis': CulinaryRecipe(
      speciesId: 'boletus_edulis',
      dishNameCa: 'Ceps a la brasa amb all i julivert',
      dishNameEs: 'Boletus a la brasa con ajo y perejil',
      dishNameEn: 'Grilled Porcini with Garlic and Parsley',
      descriptionCa:
          'La màxima expressió del cep: barrets carnosos daurats a la graella amb un toc suau d\'all i julivert.',
      descriptionEs:
          'La máxima expresión del boletus: sombreros carnosos a la parrilla con un toque suave de ajo y perejil.',
      descriptionEn:
          'The ultimate porcini experience: thick caps seared over hot coals with garlic and parsley.',
      methodCa:
          'Talleu els ceps a trossos gruixuts. Coeu-los a la brasa 3-4 minuts per banda, amanint al final amb all picat, julivert i sal gruixuda.',
      methodEs:
          'Corta los boletus en trozos gruesos. Cocina a la brasa 3-4 minutos por lado con ajo, perejil y sal gruesa.',
      methodEn:
          'Slice thickly. Grill for 3-4 minutes per side over hot coals, finishing with minced garlic, parsley, and sea salt.',
      tipCa:
          'No renteu mai els ceps amb aigua abundant; netegeu-los sempre amb un drap humit o pinzell.',
      tipEs:
          'Nunca laves los boletus con agua abundante; límpialos con un paño húmedo o pincel.',
      tipEn:
          'Never submerge porcini in water; wipe gently with a damp cloth or mushroom brush.',
      winePairingCa: 'Vi negre de la DO Costers del Segre o Empordà.',
      winePairingEs: 'Tinto DO Costers del Segre o Empordà.',
      winePairingEn: 'Costers del Segre or Empordà red wine.',
    ),
    'cantharellus_cibarius': CulinaryRecipe(
      speciesId: 'cantharellus_cibarius',
      dishNameCa: 'Vedella amb rossinyols (fricandó tradicional)',
      dishNameEs: 'Ternera con rebozuelos (fricandó tradicional)',
      dishNameEn: 'Catalan Veal with Golden Chanterelles',
      descriptionCa:
          'El guisat més estimat de la cuina catalana de tardor, amb rossinyols que aporten el seu inconfusible perfum d\'albercoc.',
      descriptionEs:
          'El guiso más representativo del otoño catalán, con rebozuelos que aportan su toque afrutado.',
      descriptionEn:
          'Catalonia\'s most celebrated autumn comfort dish, with golden chanterelles contributing apricot notes.',
      methodCa:
          'Enrossiu els talls de vedella, sofregiu ceba i tomàquet, afegiu-hi els rossinyols i deixeu coure lentament amb brou i una bona picada d\'ametlles.',
      methodEs:
          'Dora la ternera, sofrito de cebolla y tomate, añade rebozuelos y cocina lento con caldo y picada.',
      methodEn:
          'Sear veal, make a sofrito, add chanterelles and simmer gently with rich stock and an almond-garlic picada.',
      tipCa:
          'Els rossinyols no solen tenir corcs, cosa que els fa ideals per a guisats de llarga cocció.',
      tipEs:
          'Los rebozuelos no suelen tener gusanos, lo que los hace ideales para guisos lentos.',
      tipEn:
          'Chanterelles rarely harbor insects, making them ideal for long, gentle stews.',
      winePairingCa: 'Vi negre criança del Montsant o Terra Alta.',
      winePairingEs: 'Tinto crianza de Montsant o Terra Alta.',
      winePairingEn: 'Montsant or Terra Alta red wine.',
    ),
    'amanita_caesarea': CulinaryRecipe(
      speciesId: 'amanita_caesarea',
      dishNameCa:
          'Carpaccio d\'ou de reig amb oli verge d\'arbequina i parmesà',
      dishNameEs: 'Carpaccio de oronja con aceite arbequina y parmesano',
      dishNameEn: 'Caesar\'s Mushroom Carpaccio with Parmigiano',
      descriptionCa:
          'La reina indiscutible del bosc: la seva carn groga i aroma exquisida es gaudeixen millor en cru.',
      descriptionEs:
          'La reina indiscutible del bosque: su carne amarilla y aroma exquisito se disfrutan mejor en crudo.',
      descriptionEn:
          'The undisputed queen of wild mushrooms: its delicate nutty flavor is at its absolute best served raw.',
      methodCa:
          'Lamineu finament el barret tancat o semi-obert. Amaniu amb oli verge extra arbequina, unes gotes de llimona, encenalls de parmesà i flor de sal.',
      methodEs:
          'Lamina finamente el sombrero. Aliña con AOVE arbequina, unas gotas de limón, virutas de parmesano y flor de sal.',
      methodEn:
          'Slice thinly. Dress with arbequina extra virgin olive oil, drops of lemon juice, shaved Parmigiano-Reggiano, and sea salt.',
      tipCa:
          'Consumiu el mateix dia de collita: la seva frescor i textura perden qualitat molt ràpidament.',
      tipEs:
          'Consumir el mismo día de recolección: pierde textura y frescura con rapidez.',
      tipEn:
          'Enjoy on the day of harvest: flavor and crisp texture fade rapidly.',
      winePairingCa: 'Cava Gran Reserva Brut Nature o xampany francès.',
      winePairingEs: 'Cava Gran Reserva Brut Nature.',
      winePairingEn: 'Gran Reserva Brut Nature Cava.',
    ),
    'craterellus_cornucopioides': CulinaryRecipe(
      speciesId: 'craterellus_cornucopioides',
      dishNameCa: 'Arròs negre de trompetes de la mort amb calamarsets',
      dishNameEs: 'Arroz negro de trompetas de los muertos con calamares',
      dishNameEn: 'Black Trumpet Rice with Baby Squid',
      descriptionCa:
          'Un arròs intens i elegant on el negre profund prové tant de les trompetes com de la tinta natural del calamar.',
      descriptionEs:
          'Un arroz intenso donde el negro procede de las trompetas y la tinta de calamar.',
      descriptionEn:
          'A dramatic and fragrant black rice dish flavored with intense Black Trumpets and baby squid.',
      methodCa:
          'Salteu els calamarsets, prepareu un sofregit fosc de ceba caramel·litzada i trompetes, nacreu l\'arròs i mulleu amb brou de peix i trompeta.',
      methodEs:
          'Saltea calamares, sofrito de cebolla caramelizada y trompetas, arroz y caldo de pescado.',
      methodEn:
          'Sauté baby squid, make a deeply caramelized onion sofrito with trumpets, toast rice and simmer with seafood stock.',
      tipCa:
          'Les trompetes es poden assecar i moldre fàcilment: són la coneguda "tòfona dels pobres" per condimentar carns i salses.',
      tipEs:
          'Se pueden secar y moler fácilmente como especia aromática para carnes y salsas.',
      tipEn:
          'Easily dried and ground into powder: known as the "poor man\'s truffle" seasoning.',
      winePairingCa: 'Vi blanc mineral de la DO Empordà o Priorat blanc.',
      winePairingEs: 'Blanco mineral DO Empordà o Priorat.',
      winePairingEn: 'Mineral DO Empordà white or white Priorat.',
    ),
    'boletus_aereus': CulinaryRecipe(
      speciesId: 'boletus_aereus',
      dishNameCa:
          'Carpaccio de cep negre amb oli verge d\'arbequina i formatge del Cadí',
      dishNameEs: 'Carpaccio de boleto negro con AOVE y queso del Cadí',
      dishNameEn: 'Bronze Bolete Carpaccio with Olive Oil and Aged Cheese',
      descriptionCa:
          'El cep més perfumat de l\'alzinar mediterrani, degustat en cru per apreciar la seva textura cruixent i dolçor d\'avellana.',
      descriptionEs:
          'El boleto más aromático del encinar mediterráneo, servido en crudo para apreciar su textura firme y toque de avellana.',
      descriptionEn:
          'The most aromatic Mediterranean bolete, sliced raw to savor its crisp texture and hazelnut finish.',
      methodCa:
          'Lamineu finament el barret jove i sa amb mandolina. Disposeu les làmines en un plat fred, amaniu amb oli d\'oliva verge extra d\'arbequina, flor de sal i encenalls molt fins de formatge curat del Cadí.',
      methodEs:
          'Lamina finamente con mandolina. Emplata con AOVE arbequina, escamas de sal y virutas finas de queso curado.',
      methodEn:
          'Shave thinly with a mandoline. Arrange on a cold plate, drizzle with arbequina extra virgin olive oil, flaky sea salt, and shaved aged mountain cheese.',
      tipCa:
          'Utilitzeu exclusivament exemplars joves, ferms i immaculats, collits el mateix matí.',
      tipEs: 'Utiliza únicamente ejemplares jóvenes, firmes y frescos del día.',
      tipEn: 'Use exclusively pristine young buttons harvested the same day.',
      winePairingCa:
          'Vi blanc criança del Penedès (Xarel·lo en bota) o Cava Brut Nature.',
      winePairingEs: 'Blanco crianza del Penedès o Cava Brut Nature.',
      winePairingEn: 'Barrel-aged Penedès Xarel·lo or Brut Nature Cava.',
    ),
    'craterellus_lutescens': CulinaryRecipe(
      speciesId: 'craterellus_lutescens',
      dishNameCa: 'Ous remenats amb camagrocs i botifarra negra del Berguedà',
      dishNameEs: 'Revuelto de rebozuelos anaranjados con butifarra negra',
      dishNameEn:
          'Scrambled Farm Eggs with Yellowfoot Chanterelles and Black Sausage',
      descriptionCa:
          'El gran clàssic de tardor: camagrocs daurats saltejats que aporten un perfum afruitat inconfusible a uns ous cremosos.',
      descriptionEs:
          'Clásico otoñal catalán: trompeta amarilla salteada con butifarra negra en revuelto meloso.',
      descriptionEn:
          'Autumn forest staple: golden chanterelles tossed with rustic black sausage in velvety scrambled eggs.',
      methodCa:
          'Salteu els camagrocs en una paella amb una mica d\'oli fins que evapori l\'aigua. Afegiu daus de botifarra negra desfeta i incorporeu els ous batuts, remenant suaument a foc molt baix fins que quedi melós.',
      methodEs:
          'Saltea las setas hasta evaporar el agua, añade la butifarra y los huevos batidos, cuajando a fuego muy suave.',
      methodEn:
          'Sauté mushrooms until dry, toss with crumbled black sausage, then fold in whisked eggs over low heat until gently custardy.',
      tipCa:
          'Els camagrocs són ideals per assecar en garlandes: un cop deshidratats concentren una aroma intensa de préssec i fruita de bosc.',
      tipEs:
          'Excelentes para deshidratar: concentran un perfume intenso de albaricoque y bosque.',
      tipEn:
          'Superb for drying: dehydrated caps develop an intense fruity dried-apricot aroma.',
      winePairingCa: 'Vi negre jove del Pla de Bages o Costers del Segre.',
      winePairingEs: 'Tinto joven de Pla de Bages.',
      winePairingEn: 'Young fruity Pla de Bages red.',
    ),
  };
}
