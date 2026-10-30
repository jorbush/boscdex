import 'package:drift/drift.dart';
import '../app_database.dart';

class SeedData {
  static List<BoletsCompanion> get bolets => const [
        BoletsCompanion(
          id: Value('lactarius_deliciosus'),
          catalanName: Value('Rovelló / Pinetell'),
          scientificName: Value('Lactarius deliciosus'),
          family: Value('Russulaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 5 a 15 cm, convex que s\'aplana i s\'embuta amb l\'edat, ataronjat amb zones concèntriques més clares i fosques. Marge enrotllat inicialment. Es taca de verd en envellir o fer-se malbé.'),
          gillsDescription: Value(
              'Adnades a lleugerament decurrents, juntes, de color taronja viu. Es taquen de verd quan es toquen o trenquen.'),
          stemDescription: Value(
              'Cilíndric, de color taronja sovint amb escrobícules (petits forats o taques) més fosques. Buit amb l\'edat.'),
          latexDescription: Value(
              'Abundant, de color pastanaga clar, immutablement taronja. Amb gust suau o lleugerament acre.'),
          safetyNotes: Value(
              'Atenció: diferent dels falsos rovellons tòxics com el Lactarius chrysorrheus (de làtex blanc que es torna groc) i d\'espècies similars però menys valorades (L. sanguifluus, L. semisanguifluus).'),
          dexNumber: Value(1),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_deliciosus.png'),
        ),
        BoletsCompanion(
          id: Value('boletus_edulis'),
          catalanName: Value('Cep'),
          scientificName: Value('Boletus edulis'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(600),
          altitudeMax: Value(1800),
          capDescription: Value(
              'Gran (5-25 cm o més), de color marró clar a fosc, amb un marge sovint més clar, gairebé blanc en exemplars joves. Superfície llisa, lleugerament viscosa en temps humit.'),
          gillsDescription: Value(
              'Tubs i porus fins al revers del barret (no làmines). Blancs al principi, passant a groc verdós amb l\'edat. No blavegen al toc.'),
          stemDescription: Value(
              'De gruixut i bulbós a cilíndric, de color marró pàl·lid, cobert per un reticle (xarxa) blanquinós evident especialment a la part superior.'),
          safetyNotes: Value(
              'Pot confondre\'s amb el mataparent amarg (Tylopilus felleus), que té porus rosats de gran i un reticle molt marcat, a més d\'un gust extremadament amarg.'),
          dexNumber: Value(2),
          imageAssetPath: Value('assets/images/mushrooms/boletus_edulis.png'),
        ),
        BoletsCompanion(
          id: Value('cantharellus_cibarius'),
          catalanName: Value('Rossinyol'),
          scientificName: Value('Cantharellus cibarius'),
          family: Value('Cantharellaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[6,7,8,9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1500),
          capDescription: Value(
              'Petit a mitjà (3-10 cm), tot de color groc rovell d\'ou uniforme. Carn ferma. Té forma d\'embut o copa de vores sinuoses i irregulars.'),
          gillsDescription: Value(
              'No té làmines veritables, sinó plecs gruixuts, bifurcats i decurrents (que baixen per la cama) del mateix color que la resta.'),
          stemDescription: Value(
              'Ple, carnós i llis, aprimant-se cap a la base, del mateix color groc que la resta del bolet.'),
          safetyNotes: Value(
              'Precaució de no confondre amb la Gírgola d\'olivera (Omphalotaceae), que és tòxica, creix sobre fusta i té làmines de veritat fines en lloc de plecs gruixuts.'),
          dexNumber: Value(3),
          imageAssetPath:
              Value('assets/images/mushrooms/cantharellus_cibarius.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_caesarea'),
          catalanName: Value('Ou de reig'),
          scientificName: Value('Amanita caesarea'),
          family: Value('Amanitaceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1000),
          capDescription: Value(
              'Neix d\'una volva blanca tancada ("ou"). Obert fa 8-20 cm, llis, de color ataronjat intens o vermell ataronjat, sense restes de volva (sense esquames blanques). Marge estriat.'),
          gillsDescription:
              Value('Lliures, atapeïdes, de color clarament groc.'),
          stemDescription: Value(
              'Cilíndric, de color groc (no blanc), proveït d\'un anell ampli i membranós, penjat, també groc. A la base, hi té un sac blanc ampli (volva) i lliure.'),
          safetyNotes: Value(
              'Possible confusió mortal o perillosa amb Amanita muscaria, que té peu blanc (no groc), làmines blanques (no grogues), marge no estriat i normalment restes blanques sobre el barret.'),
          dexNumber: Value(4),
          imageAssetPath: Value('assets/images/mushrooms/amanita_caesarea.png'),
        ),
        BoletsCompanion(
          id: Value('craterellus_cornucopioides'),
          catalanName: Value('Trompeta de la mort'),
          scientificName: Value('Craterellus cornucopioides'),
          family: Value('Cantharellaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1400),
          capDescription: Value(
              'En forma d\'embut o cornucòpia profundament buida fins a la base. Color de gris fosc a negre negrós. Marges ondulats.'),
          gillsDescription: Value(
              'Sense làmines ni plecs marcats; la superfície externa (l\'himeni) és gairebé llisa, lleugerament arrugada o venada, de color gris cendra.'),
          stemDescription: Value(
              'Pràcticament inexistent com a estructura separada, és simplement la part inferior de l\'embut, negrenca i buida.'),
          safetyNotes: Value(
              'Molt característic, difícil de confondre, sobretot en el seu estat fresc o assecat.'),
          dexNumber: Value(5),
          imageAssetPath:
              Value('assets/images/mushrooms/craterellus_cornucopioides.png'),
        ),
        BoletsCompanion(
          id: Value('macrolepiota_procera'),
          catalanName: Value('Apagallums'),
          scientificName: Value('Macrolepiota procera'),
          family: Value('Agaricaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1200),
          capDescription: Value(
              'Molt gran, fins a 30 cm de diàmetre. Inicialment ovoidal (forma de baqueta de tambor), després s\'obre com un para-sol. De fons clar, cobert d\'esquames concèntriques fosques. Gran mamelló central fosc (umbó).'),
          gillsDescription:
              Value('Blanques, amples, toves i lliures respecte del peu.'),
          stemDescription: Value(
              'Molt llarg (pot passar de 30 cm), fibril·lós i tigrat ("serpentí"), acabat en un bulb basal, però SENSE volva en sac. Porta un gran anell doble, gruixut i mòbil (lliscant) com una polsera.'),
          safetyNotes: Value(
              'No confondre amb lepiotes de mida petita (menys de 10 cm) moltes de les quals són mortals. La característica de l\'anell mòbil és fonamental.'),
          dexNumber: Value(6),
          imageAssetPath:
              Value('assets/images/mushrooms/macrolepiota_procera.png'),
        ),
        BoletsCompanion(
          id: Value('tricholoma_terreum'),
          catalanName: Value('Fredolic'),
          scientificName: Value('Tricholoma terreum'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 3 a 8 cm, convex, sec, amb la superfície coberta de petites esquames fibril·loses que li donen un aspecte vellutat, de color gris ratolí a gris negrós.'),
          gillsDescription: Value(
              'Escotades, desiguals, fràgils, de color blanc grisenc clar.'),
          stemDescription: Value(
              'Cilíndric, fibril·lós, generalment blanc a grisenc molt clar, recte i fràgil.'),
          safetyNotes: Value(
              'Fàcilment confusible amb altres Tricholoma grisos, alguns dels quals són lleugerament tòxics (com el T. pardinum) que solen ser molt més robustos. Important fixar-se en l\'aspecte de "ratolí" i fragilitat general.'),
          dexNumber: Value(7),
          imageAssetPath:
              Value('assets/images/mushrooms/tricholoma_terreum.png'),
        ),
        BoletsCompanion(
          id: Value('calocybe_gambosa'),
          catalanName: Value('Moixernó'),
          scientificName: Value('Calocybe gambosa'),
          family: Value('Lyophyllaceae'),
          rarityTier: Value('rar'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[4,5,6]'),
          altitudeMin: Value(600),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 5 a 12 cm, carnós, mat i sec. Color de blanc a crema suau o gairebé camussa. Marge sovint molt enrotllat cap a sota quan és jove.'),
          gillsDescription: Value(
              'Molt atapeïdes, estretes i decurrents en dent (escotades). Blanc-crema, esporen en blanc.'),
          stemDescription: Value(
              'Gruixut, robust, massís i generalment curt. Del mateix color del barret o més blanc.'),
          safetyNotes: Value(
              'Olor inconfusible a farina fresca. Vigilar amb bolets primaverals mortals blancs (Entoloma, algunes Inocybe) que generalment no tenen l\'olor a farina o esporen en altres colors (el pèrfid espora en rosa).'),
          dexNumber: Value(8),
          imageAssetPath: Value('assets/images/mushrooms/calocybe_gambosa.png'),
        ),
        BoletsCompanion(
          id: Value('pleurotus_ostreatus'),
          catalanName: Value('Gírgola'),
          scientificName: Value('Pleurotus ostreatus'),
          family: Value('Pleurotaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12,1,2]'),
          altitudeMin: Value(0),
          altitudeMax: Value(1200),
          capDescription: Value(
              'Gran (5-20 cm), forma de conquilla o ostra, carnós. Color molt variable, des de blau negrós o gris plom al principi fins a gris clar o marronós. Superfície llisa.'),
          gillsDescription: Value(
              'Llargament decurrents fins a la base, bastant separades i toves. De color blanquinós a cremós.'),
          stemDescription: Value(
              'Molt curt, completament excèntric (lateral) o gairebé absent, soldat a la fusta on creix.'),
          safetyNotes: Value(
              'Es cria sobre troncs morts. Confusió (tot i ser força diferent) amb Omphalotus olearius, tòxica, que és molt ataronjada i de zones menys fredes.'),
          dexNumber: Value(9),
          imageAssetPath:
              Value('assets/images/mushrooms/pleurotus_ostreatus.png'),
        ),
        BoletsCompanion(
          id: Value('hydnum_repandum'),
          catalanName: Value('Llengua de bou'),
          scientificName: Value('Hydnum repandum'),
          family: Value('Hydnaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 5 a 15 cm, irregular i lobulat, de color blanquinós, crema a taronja esblaimat o rosat ataronjat. Superfície vellutada seca.'),
          gillsDescription: Value(
              'L\'himeni (part de sota) no està format per làmines ni tubs, sinó per agulles clares, blanquinoses o de color crema que es desprenen amb molta facilitat en raspar.'),
          stemDescription:
              Value('Gruixut, curt, normalment excèntric i blanquinós.'),
          safetyNotes: Value(
              'Pràcticament inconfusible per la presència d\'agulles (fiblons) inferiors fàcilment desprenibles i el color general.'),
          dexNumber: Value(10),
          imageAssetPath: Value('assets/images/mushrooms/hydnum_repandum.png'),
        ),
        BoletsCompanion(
          id: Value('hygrophorus_latitabundus'),
          catalanName: Value('Llenega negra'),
          scientificName: Value('Hygrophorus latitabundus'),
          family: Value('Hygrophoraceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1200),
          capDescription: Value(
              'Lleugerament bombat, molt i molt viscós en estat fresc i humit, marró-gris o fosc cap al centre i marge blanquinós. Fins a 15 cm.'),
          gillsDescription: Value(
              'Gruixudes, espaiades i una mica decurrents, llustroses i ceroses, de color blanc.'),
          stemDescription: Value(
              'Cilíndric, de color blanc, molt viscós a la meitat inferior fins al naixement (que forma un cert anell viscós limitador, dalt es queda sec).'),
          safetyNotes: Value(
              'És la varietat reina de les llenegues; excel·lent per cuinar.'),
          dexNumber: Value(11),
          imageAssetPath:
              Value('assets/images/mushrooms/hygrophorus_latitabundus.png'),
        ),
        BoletsCompanion(
          id: Value('craterellus_lutescens'),
          catalanName: Value('Camagroc'),
          scientificName: Value('Craterellus lutescens'),
          family: Value('Cantharellaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1600),
          capDescription: Value(
              'Molt prim, ondulat en embut de petit format (2-5 cm), esquamós de color bru-gris o bru fosc a sobre.'),
          gillsDescription: Value(
              'La part de sota del barret és totalment groga ataronjada, pràcticament llisa al principi i de mica en mica amb lleugers plecs o venes ramificades, però SENSE làmines ben definides.'),
          stemDescription: Value(
              'Llarg, tubular, fi i buit, d\'un color groc ataronjat molt viu i cridaner.'),
          safetyNotes: Value(
              'Surt a milers on apareix, no hi ha espècies perilloses similars amb cama groga i fina sense autèntiques làmines.'),
          dexNumber: Value(12),
          imageAssetPath:
              Value('assets/images/mushrooms/craterellus_lutescens.png'),
        ),
        BoletsCompanion(
          id: Value('suillus_luteus'),
          catalanName: Value('Llenegot'),
          scientificName: Value('Suillus luteus'),
          family: Value('Suillaceae'),
          rarityTier: Value('comu'),
          edibility: Value('sense_valor'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'Hemisfèric i després pla, de color marró-xocolata a groc-marró fosc. En temps humit és completament viscós i enganxós (la cutícula es pot pelar fàcilment).'),
          gillsDescription: Value(
              'Té tubs i porus, que inicialment són coberts per un vel membranós (anell). Són petits i rodons, de color groc que enfosqueix i enverdeix amb l\'edat.'),
          stemDescription: Value(
              'Cilíndric, curt, porta un vistós anell ample que primer és blanc i després vira al lila grisenc o marró violaci.'),
          safetyNotes: Value(
              'Tot i classificar-se com comestible pelant bé la cutícula, té molt poc valor culinari.'),
          dexNumber: Value(13),
          imageAssetPath: Value('assets/images/mushrooms/suillus_luteus.png'),
        ),
        BoletsCompanion(
          id: Value('russula_cyanoxantha'),
          catalanName: Value('Llora verda'),
          scientificName: Value('Russula cyanoxantha'),
          family: Value('Russulaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[6,7,8,9,10]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1400),
          capDescription: Value(
              'Molt variable, en diferents tons clapejats de violeta, rosa-lila i sobretot verd lila, blavós (mai roig viu pur). Fins a 15 cm.'),
          gillsDescription: Value(
              'Blanques. La prova clau per a identificar-la és que la textura de les làmines no és trencadissa, sinó tova (com formatge llescat fi), quan s\'hi passa el dit NO es trenquen.'),
          stemDescription: Value(
              'Blanc, ferm, sense cap anell ni volva, recte i generalment cilíndric. Carn trencadissa.'),
          safetyNotes: Value(
              'Bon comestible; cal assegurar-se que les làmines són flexibles i no trencadisses i que no té volva ni anell per no confondre les formes verdoses amb la mortal Farinera borda (Amanita phalloides).'),
          dexNumber: Value(14),
          imageAssetPath:
              Value('assets/images/mushrooms/russula_cyanoxantha.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_muscaria'),
          catalanName: Value('Reig bord'),
          scientificName: Value('Amanita muscaria'),
          family: Value('Amanitaceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'Molt vistós i icònic. Color vermell intens amb múltiples "esquames" blanques sobre la superfície (són restes del vel universal).'),
          gillsDescription: Value('Lliures, amples, netament blanques.'),
          stemDescription: Value(
              'Blanc pur. Té un gran anell penjant blanc. La base del peu és bulbosa, normalment voltada de fileres d\'esquames o verrugues blanques, restes de la volva.'),
          safetyNotes: Value(
              'Molt tòxic, té efectes psicoactius, al·lucinògens, nàusees fortes i vòmits intensos. Possible confusió amb l\'ou de reig quan les pluges en renten els punts blancs, però la muscaria manté làmines blanques (no grogues).'),
          dexNumber: Value(15),
          imageAssetPath: Value('assets/images/mushrooms/amanita_muscaria.png'),
        ),
        BoletsCompanion(
          id: Value('omphalotus_olearius'),
          catalanName: Value('Gírgola d\'olivera'),
          scientificName: Value('Omphalotus olearius'),
          family: Value('Omphalotaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(0),
          altitudeMax: Value(800),
          capDescription: Value(
              'Carnós, de color ataronjat rogenc o bru daurat molt bonic, de vegades infundibuliforme (en forma d\'embut), neix en flotes atapeïdes a les soques.'),
          gillsDescription: Value(
              'Decurrents, unides, freqüentment es ramifiquen o forquen. De color taronja o rovell. Poden tenir una feble luminescència (brillen verdós al fosc).'),
          stemDescription: Value(
              'Color igual al barret o més fosc, generalment s\'atenua al peu o neix unit a un mateix substrat amb d\'altres (creixement cespitós).'),
          safetyNotes: Value(
              'Molt tòxic, especialment del tracte gastrointestinal, si es confon amb el rossinyol (C. cibarius), del qual es distingeix per viure en fusta, color fosc i làmines veritables, no plecs.'),
          dexNumber: Value(16),
          imageAssetPath:
              Value('assets/images/mushrooms/omphalotus_olearius.png'),
        ),
        BoletsCompanion(
          id: Value('entoloma_sinuatum'),
          catalanName: Value('Pèrfid'),
          scientificName: Value('Entoloma sinuatum'),
          family: Value('Entolomataceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1200),
          capDescription: Value(
              'Molt robust (fins a 18 cm). De color blanc groguenc o crema cendrós (color camussa), llis, lluent en temps sec.'),
          gillsDescription: Value(
              'Molt espesses i amples. Escotades del marge de la cama. Al principi groguenques, després (això és crucial) viren a color salmó-rosat per la maduració d\'espores rosa.'),
          stemDescription: Value(
              'Massís, blanc, recte però de vegades eixamplat a la base.'),
          safetyNotes: Value(
              'Provoca toxicitat greu intestinal crònica i nàusees agudes. Olor de farina rància, a diferència de la farina fresca del Moixernó (Calocybe gambosa), l\'esporada (la pols que allibera) és rosa, mentre el Moixernó l\'espora és blanca.'),
          dexNumber: Value(17),
          imageAssetPath:
              Value('assets/images/mushrooms/entoloma_sinuatum.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_phalloides'),
          catalanName: Value('Farinera borda'),
          scientificName: Value('Amanita phalloides'),
          family: Value('Amanitaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1400),
          capDescription: Value(
              'Llis, amb forma d\'escut suau, normalment d\'un groc-oliva clar, gris-verd o marró verdós, amb unes venes finíssimes (fibril·les radials). Sense esquames blanques.'),
          gillsDescription: Value(
              'Lliures (no toquen el peu), atapeïdes i d\'un color completament blanc.'),
          stemDescription: Value(
              'Blanc a lleugerament atigrat groc verdós, anell prim blanc en faldilleta penjant, i una volva a la base completament blanca, membranosa, tancada o esberlada formant un sac ampli que no s\'enganxa al bulb.'),
          safetyNotes: Value(
              'MORTAL. Conté amatoxines; la dosi d\'un sol bolet petit destrueix el fetge i produeix la mort en diversos dies després d\'un període sense símptomes d\'unes hores.'),
          dexNumber: Value(18),
          imageAssetPath:
              Value('assets/images/mushrooms/amanita_phalloides.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_verna'),
          catalanName: Value('Cicuta blanca'),
          scientificName: Value('Amanita verna'),
          family: Value('Amanitaceae'),
          rarityTier: Value('rar'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[4,5,6]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1000),
          capDescription: Value(
              'Superfície totalment llisa d\'un color blanc pur o lleugeríssim crema pàl·lid, fins i tot a la meitat, sovint molt simètric. 5-10 cm.'),
          gillsDescription:
              Value('Totalment blanques, atapeïdes, fràgils i lliures.'),
          stemDescription: Value(
              'Tot blanc. Amb un anell blanc penjant fi i, a la base, una gran volva en forma de sac, lliure de la cama i força resistent.'),
          safetyNotes: Value(
              'MORTAL. Surt a la primavera (vernal). Similar a l\'A. phalloides però tota de blanc integral, s\'assembla erròniament a molts xampinyons bords o bolets de prat comestibles joves (però aquests no tenen volva en sac).'),
          dexNumber: Value(19),
          imageAssetPath: Value('assets/images/mushrooms/amanita_verna.png'),
        ),
        BoletsCompanion(
          id: Value('cortinarius_orellanus'),
          catalanName: Value('Cortinari de muntanya'),
          scientificName: Value('Cortinarius orellanus'),
          family: Value('Cortinariaceae'),
          rarityTier: Value('rar'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1400),
          capDescription: Value(
              'Barret campanulat o convex de color terrós rogenc a taronja foc fosc, sec, densament fibril·lós o envellutat en observar-lo de prop.'),
          gillsDescription: Value(
              'De gruixudes i distanciades, de color groc taronja o òxid viu. A mida que maduren prenen el color rovell intens del fons de les espores.'),
          stemDescription: Value(
              'De color groc i, atenció a aquest tret que el distingeix d\'altres similars, capes de filaments (la cortina) en comptes d\'un autèntic vel al peu; coloració fibril·lar oxidada.'),
          safetyNotes: Value(
              'MORTAL. La toxina orellanina, extremadament perillosa per la seva acció molt retardada (dies o més de 2 setmanes sense símptomes greus per presentar llavors dany renal catastròfic generalment fatal).'),
          dexNumber: Value(20),
          imageAssetPath:
              Value('assets/images/mushrooms/cortinarius_orellanus.png'),
        ),
        BoletsCompanion(
          id: Value('lactarius_sanguifluus'),
          catalanName: Value('Rovelló d\'obaga'),
          scientificName: Value('Lactarius sanguifluus'),
          family: Value('Russulaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 5 a 12 cm, convex i després deprimit, de color ocre ataronjat amb tons vinosos o porpres i taques verdes en envellir.'),
          gillsDescription: Value(
              'Atapeïdes, decurrents, de color ocre rosat o vinós que es taquen de verd fosc.'),
          stemDescription: Value(
              'Curt, cilíndric, atenuat a la base, de color ocre vinós pàl·lid, sovint escrobiculat.'),
          latexDescription:
              Value('De color vermell vinós o sang fosc, de gust dolç o suau.'),
          safetyNotes: Value(
              'Comestible excel·lent, molt apreciat com el pinetell. Es distingeix pel seu làtex de color sang o vi fosc.'),
          dexNumber: Value(21),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_sanguifluus.png'),
        ),
        BoletsCompanion(
          id: Value('chroogomphus_rutilus'),
          catalanName: Value('Cama de perdiu'),
          scientificName: Value('Chroogomphus rutilus'),
          family: Value('Gomphidiaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 4 a 10 cm, convex o cònic amb un mamelló central molt marcat (umbonat). Cutícula llisa, viscosa amb la humitat i lluent en eixut, de color marró coure o rogenc amb reflexos vinosos.'),
          gillsDescription: Value(
              'Clarament decurrents, gruixudes, espaiades i arquejades, d\'un color inicialment ocre ataronjat que enfosqueix a marró purpuri o negrós en madurar les espores.'),
          stemDescription: Value(
              'De 5 a 10 cm, cilíndric i afilat cap a la base (d\'on rep el nom popular de cama de perdiu). Fibrós, ocre ataronjat o salmó, sovint amb miceli groc llimona a la punta inferior.'),
          safetyNotes: Value(
              'Comestible de bon gust. La seva carn de color salmó es torna d\'un color violaci o porpra molt fosc i característic en cuinar-se. Es distingeix dels cortinaris verinosos per les seves làmines fortament decurrents i per no tenir cortina.'),
          dexNumber: Value(22),
          imageAssetPath:
              Value('assets/images/mushrooms/chroogomphus_rutilus.png'),
        ),
        BoletsCompanion(
          id: Value('marasmius_oreades'),
          catalanName: Value('Carrereta / Cama-sec'),
          scientificName: Value('Marasmius oreades'),
          family: Value('Marasmiaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[5,6,9,10,11]'),
          altitudeMin: Value(300),
          altitudeMax: Value(2000),
          capDescription: Value(
              'De 2 a 6 cm, campanulat que passa a convex i aplanat amb un mamelló central obtús. Color crema clar a ocre canyella, més pàl·lid en eixut (higròfan). Marge lleugerament estriat per transparència.'),
          gillsDescription: Value(
              'Lliures o lleugerament adnades, amples, força separades entre elles, intercalades amb lamel·lules, de color blanquinós a crema ocraci clar.'),
          stemDescription: Value(
              'De 3 a 7 cm de llarg, molt prim (3-5 mm), cilíndric, tenaç i elàstic (es pot cargolar sobre ell mateix sense trencar-se). Del mateix color que el barret o més clar.'),
          safetyNotes: Value(
              'Excel·lent comestible, clau en el fricandó tradicional. Atenció: no confondre amb clitocibes blancs tòxics de prat (Clitocybe dealbata, C. rivulosa), que tenen làmines molt juntes i decurrents i cama fràgil no elàstica.'),
          dexNumber: Value(23),
          imageAssetPath:
              Value('assets/images/mushrooms/marasmius_oreades.png'),
        ),
        BoletsCompanion(
          id: Value('lactarius_chrysorrheus'),
          catalanName: Value('Lleterola de llet groga / Fals rovelló'),
          scientificName: Value('Lactarius chrysorrheus'),
          family: Value('Russulaceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 4 a 10 cm, convex i després deprimit, de color salmó pàl·lid o ocre rosat amb zones concèntriques de taques més fosques. Marge enrotllat inicialment.'),
          gillsDescription: Value(
              'Atapeïdes, lleugerament decurrents, de color crema pàl·lid a ocre rosat amb l\'edat.'),
          stemDescription: Value(
              'Cilíndric, curt, llis, blanquinós a salmó clar, sense escrobícules apreciables.'),
          latexDescription: Value(
              'Làtex blanc abundant que, en contacte amb l\'aire, vira a groc sofre intens en pocs segons. Molt picant i amarg.'),
          safetyNotes: Value(
              'TÒXIC. Provoca trastorns gastrointestinals severs. És la confusió més freqüent amb el rovelló (L. deliciosus); es distingeix fàcilment perquè el seu làtex és blanc i es torna groc sofre, mai taronja ni vinós.'),
          dexNumber: Value(24),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_chrysorrheus.png'),
        ),
        BoletsCompanion(
          id: Value('lepista_nuda'),
          catalanName: Value('Pé blau / Pua blava'),
          scientificName: Value('Lepista nuda'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 6 a 15 cm, convex i després aplanat amb marge ondulat i enrotllat. Color blau violaci o lila viu de jove, que vira a marró bru o lilaci apagat amb l\'edat. Cutícula llisa i separable.'),
          gillsDescription: Value(
              'Atapeïdes, sinuades a escotades, d\'un color blau violaci o lavanda molt viu, fàcilment separables de la carn del barret.'),
          stemDescription: Value(
              'Robust, cilíndric amb base bulbosa coberta de miceli blavós, fibrós, del mateix color violaci que les làmines.'),
          safetyNotes: Value(
              'Bon comestible prèvia cocció (tòxic en cru com molts bolets). Té una forta olor afruitada o anisada agradable. Es diferencia dels cortinaris violacis per la seva esporada blanca-rosada i per l\'absència total de cortina.'),
          dexNumber: Value(25),
          imageAssetPath: Value('assets/images/mushrooms/lepista_nuda.png'),
        ),
        BoletsCompanion(
          id: Value('rubroboletus_satanas'),
          catalanName: Value('Mataparent de Satanàs'),
          scientificName: Value('Rubroboletus satanas'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[7,8,9,10]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1100),
          capDescription: Value(
              'Molt voluminós (10 a 30 cm), robust i massís. Cutícula llisa, de color blanc guix, gris perla o blanquinós brut, mai marró fosc com el cep.'),
          gillsDescription: Value(
              'Tubs grocs i porus molt fins, inicialment groguencs que ràpidament passen a vermell sang o carmí intens. Blavegen lleugerament a la pressió.'),
          stemDescription: Value(
              'Molt gros, inflat, obès o esfèric a la base. Groc a la part alta i vermell carmí o porpra al centre i base, cobert d\'un reticle fi.'),
          safetyNotes: Value(
              'TÒXIC. Causa intoxicacions gastrointestinals severes amb vòmits i deshidratació. Olor desagradable a carronya en envellir. Confusió perillosa amb el cep (Boletus edulis); es diferencia pel barret blanquinós i els porus vermell sang.'),
          dexNumber: Value(26),
          imageAssetPath:
              Value('assets/images/mushrooms/rubroboletus_satanas.png'),
        ),
        BoletsCompanion(
          id: Value('russula_virescens'),
          catalanName: Value('Palometa / Llora pigada'),
          scientificName: Value('Russula virescens'),
          family: Value('Russulaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[6,7,8,9,10]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1300),
          capDescription: Value(
              'De 5 a 15 cm, globós i després convex-deprimit. Cutícula seca, de color verd grisenc a verd maragda pàl·lid, típicament clivellada o esquamosa formant un mosaic de petites crostes poligonals.'),
          gillsDescription: Value(
              'Lliures o adnades, atapeïdes, blanques o crema clar, molt fràgils i trencadisses com el guix (típic del gènere Russula).'),
          stemDescription: Value(
              'Robust, cilíndric, massís, blanc pur, rugós, que es trenca netament com una barra de guix.'),
          safetyNotes: Value(
              'Excel·lent comestible, una de les millors llores de Catalunya. ALERTA VITAL: cal no confondre amb la farinera borda (Amanita phalloides), que també pot tenir el barret verdós, però la farinera té anell, volva i carn fibrosa (mai trencadissa com el guix).'),
          dexNumber: Value(27),
          imageAssetPath:
              Value('assets/images/mushrooms/russula_virescens.png'),
        ),
        BoletsCompanion(
          id: Value('hygrophorus_eburneus'),
          catalanName: Value('Llenega blanca / Mocosa blanca'),
          scientificName: Value('Hygrophorus eburneus'),
          family: Value('Hygrophoraceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 4 a 10 cm, convex a lleugerament umbonat, tot de color blanc ivori lluent. Cutícula molt mucosa i viscosa en temps humit, lluent quan s\'asseca.'),
          gillsDescription: Value(
              'Decurrents, espaiades, gruixudes i dures, d\'un color blanc pur immutable que pot groguejar molt lleugerament amb l\'edat.'),
          stemDescription: Value(
              'De 5 a 10 cm, cilíndric, atenuat cap a la base, blanc, molt viscós com el barret, amb petites granulacions a la part superior.'),
          safetyNotes: Value(
              'Comestible tradicional molt apreciat a les comarques interiors, germana de la llenega negra (H. latitabundus). Olor característica suau i agradable. Es renta la cutícula viscosa abans de cuinar.'),
          dexNumber: Value(28),
          imageAssetPath:
              Value('assets/images/mushrooms/hygrophorus_eburneus.png'),
        ),
        BoletsCompanion(
          id: Value('tricholoma_pardinum'),
          catalanName: Value('Fredolic bord / Griset bord'),
          scientificName: Value('Tricholoma pardinum'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('rar'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[8,9,10,11]'),
          altitudeMin: Value(800),
          altitudeMax: Value(1900),
          capDescription: Value(
              'Molt robust i carnós (6 a 15 cm), campanulat i després aplanat. Cutícula de color gris platejat a gris fosc, coberta d\'esquames concèntriques amples i fosques disposades com teules (aspecte tigrat o de lleopard).'),
          gillsDescription: Value(
              'Escotades, juntes, blanquinoses amb reflexos groguencs o verdosos en envellir, sovint suant petites gotetes d\'aigua en temps humit.'),
          stemDescription: Value(
              'Gruixut, massís, blanc a ocre clar, atenuat o bulbós cap a la base, molt més gros i sòlid que el del fredolic comú.'),
          safetyNotes: Value(
              'TÒXIC GRAU. Causa greus gastroenteritis amb vòmits incoercibles i forta deshidratació. Gran perill de confusió amb el fredolic (T. terreum); es diferencia per ser molt més massís i gran, amb esquames gruixudes concèntriques i peu no buit i fràgil.'),
          dexNumber: Value(29),
          imageAssetPath:
              Value('assets/images/mushrooms/tricholoma_pardinum.png'),
        ),
        BoletsCompanion(
          id: Value('morchella_esculenta'),
          catalanName: Value('Múrgola / Rabassola'),
          scientificName: Value('Morchella esculenta'),
          family: Value('Morchellaceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[3,4,5]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 4 a 10 cm d\'alçada, ovoide o arrodonit, buit per dins. Superfície formada per alvèols o cel·les profundes i irregulars (com una bresca d\'abelles), de color groc ocre, beix o mel pàl·lid.'),
          gillsDescription: Value(
              'No té làmines; la part fèrtil (himeni) recobreix l\'interior de les cel·les alvelolars del barret.'),
          stemDescription: Value(
              'De 3 a 8 cm, blanc a crema clar, cilíndric, engruixit a la base, buit per dins en continuïtat directa amb el barret.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE PRIMAVERAL molt cotitzat. ATENCIÓ: és tòxica en cru (conté hemolisines); cal coure-la bé o assecar-la abans del consum. Compte amb el bolet de greix (Gyromitra esculenta), que té plecs cerebriformes (no alvèols) i és altament perillós.'),
          dexNumber: Value(30),
          imageAssetPath:
              Value('assets/images/mushrooms/morchella_esculenta.png'),
        ),
        BoletsCompanion(
          id: Value('agaricus_campestris'),
          catalanName: Value('Xampinyó silvestre / Guisana'),
          scientificName: Value('Agaricus campestris'),
          family: Value('Agaricaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[5,6,9,10,11]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 4 a 10 cm, convex a aplanat, carnós, sec i blanc o blanquinós sedós, de vegades amb fines esquames ocre clar al centre.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, inicialment d\'un bell color rosa viu o salmó delicat, que amb la maduració de les espores esdevenen marró xocolata fosc o negroses.'),
          stemDescription: Value(
              'De 3 a 7 cm, cilíndric, blanc, atenuat a la base, amb un anell membranós simple, fràgil i fugaç que sovint desapareix en envellir.'),
          safetyNotes: Value(
              'Molt bon comestible tradicional dels prats i clarianes de bosc. ATENCIÓ: no confondre amb el xampinyó groguenc (A. xanthodermus), que grogueja intensament a la base del peu i fa olor de tinta/fenol, ni amb les amanites blanques mortals (A. verna, A. phalloides), que tenen sempre làmines blanques i volva a la base.'),
          dexNumber: Value(31),
          imageAssetPath:
              Value('assets/images/mushrooms/agaricus_campestris.png'),
        ),
        BoletsCompanion(
          id: Value('agaricus_xanthodermus'),
          catalanName: Value('Xampinyó groguenc / Xampinyó pudent'),
          scientificName: Value('Agaricus xanthodermus'),
          family: Value('Agaricaceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[5,6,9,10,11]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 5 a 12 cm, inicialment trapezoidal o troncocònic (pla per dalt), després convex. Blanc a grisaci clar, que es taca d\'un groc crom intens al tacte o fregament.'),
          gillsDescription: Value(
              'Lliures, serrades, inicialment blanquinoses o rosa molt pàl·lid brut, virant després a bru xocolata grisós fosc.'),
          stemDescription: Value(
              'De 6 a 12 cm, blanc, esvelt, amb un anell doble i ample en faldó. La base té un bulb prominent que al tall o rascada es tenyeix immediatament de groc sofre o crom elèctric molt intens.'),
          safetyNotes: Value(
              'TÒXIC GASTROINTESTINAL. Causa nàusees, vòmits i dolors abdominals aguts. Es reconeix infal·liblement pel fort viratge a groc crom de la base del peu i per una olor penetrant i desagradable de tinta, iode o àcid fènol, que s\'intensifica fortament en coure\'s.'),
          dexNumber: Value(32),
          imageAssetPath:
              Value('assets/images/mushrooms/agaricus_xanthodermus.png'),
        ),
        BoletsCompanion(
          id: Value('psathyrella_candolleana'),
          catalanName: Value('Candol·lea / Psatirel·la de Candolle'),
          scientificName: Value('Candolleomyces candolleanus'),
          family: Value('Psathyrellaceae'),
          rarityTier: Value('comu'),
          edibility: Value('sense_valor'),
          fruitingSeason: Value('[4,5,6,9,10,11]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 3 a 7 cm, fràgil i prim, hemisfèric i després aplanat amb umbó obtús. Higròfan, de color mel pàl·lid, ocre clar o blanquinós en assecar-se. Marge guarnit de flocs i restes blanques del vel parcial festonat.'),
          gillsDescription: Value(
              'Adnates, molt atapeïdes, inicialment blanquinoses, passant a lila grisenc pàl·lid i finalment bru porpra fosc.'),
          stemDescription: Value(
              'De 4 a 9 cm, molt prim (3-6 mm), blanc sedós, buit, cilíndric, extremadament trencadís i delicat, sense anell persistent.'),
          safetyNotes: Value(
              'Sense interès culinari per la seva carn prima i fràgil, tot i que no és tòxica. Creix sovint en flotes nombroses vora soques podrides, fusta enterrada o prats sota pins (Pinus halepensis) i planifolis.'),
          dexNumber: Value(33),
          imageAssetPath:
              Value('assets/images/mushrooms/psathyrella_candolleana.png'),
        ),
        BoletsCompanion(
          id: Value('suillus_granulatus'),
          catalanName: Value('Molleric clapat / Pinetell de pi blanc'),
          scientificName: Value('Suillus granulatus'),
          family: Value('Suillaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[5,6,9,10,11,12]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1200),
          capDescription: Value(
              'De 5 a 12 cm, convex i després aplanat. Cutícula molt viscosa en temps humit, fàcilment separable de la carn, de color bru groguenc, vermellós o canyella càlid.'),
          gillsDescription: Value(
              'Format per tubs i porus fins (no làmines), de color groc pàl·lid a groc viu, que en exemplars joves degoten gotetes d\'un líquid lletós blanquinós.'),
          stemDescription: Value(
              'De 4 a 8 cm, cilíndric, massís, groguenc, sense anell. Presenta característiques granulacions o punts petits de color marró ocre a la part superior.'),
          safetyNotes: Value(
              'Comestible apreciat si es pela la cutícula viscosa (que té efectes lleugerament laxants) i s\'eliminen els tubs tous. És el molleric més abundant i característic dels boscos de pi blanc (Pinus halepensis) a tot el litoral i prelitoral català.'),
          dexNumber: Value(34),
          imageAssetPath:
              Value('assets/images/mushrooms/suillus_granulatus.png'),
        ),
        BoletsCompanion(
          id: Value('hygrophorus_russula'),
          catalanName: Value('Carlet / Escarlet'),
          scientificName: Value('Hygrophorus russula'),
          family: Value('Hygrophoraceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1100),
          capDescription: Value(
              'De 5 a 15 cm, molt massís i carnós, convex i després aplanat. Color rosa vinós a vermell púrpura amb taques i vetes vinoses sobre fons blanquinós. Cutícula una mica viscosa en humit.'),
          gillsDescription: Value(
              'Subdecurrents a decurrents, una mica ceroses i espaiades, blanques al principi i amb taques vinòs-vermelloses característiques en madurar.'),
          stemDescription: Value(
              'De 4 a 9 cm, curt, robust, massís, atenuat a la base, blanc tacat o pigat de vermell vinós a la part mitjana i inferior.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE TRADICIONAL molt valorat a la cuina catalana ("el rei de la cassola"), ideal per a guisats de carn. Olor suau fúngica i gust lleugerament amargant que s\'esvaeix amb una bona cocció. Creix en alzinars i rouredes tèbies.'),
          dexNumber: Value(35),
          imageAssetPath:
              Value('assets/images/mushrooms/hygrophorus_russula.png'),
        ),
        BoletsCompanion(
          id: Value('boletus_aereus'),
          catalanName: Value('Cep negre / Sureny fosc'),
          scientificName: Value('Boletus aereus'),
          family: Value('Boletaceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[6,7,9,10,11]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1000),
          capDescription: Value(
              'De 7 a 20 cm, molt ferm i compacte, hemisfèric i després convex. Cutícula vellutada, de color bru xocolata molt fosc, bronzejat o gairebé negre, sovint amb clapes més clares de color ocre o coure.'),
          gillsDescription: Value(
              'Porus fins i arrodonits (tubs), molt atapeïts, de color blanc immaculat en joventut, passant a groc ocre en madurar, sense blavejar al tacte.'),
          stemDescription: Value(
              'De 6 a 14 cm, molt corpulent, ventrut o bulbós, de color bru canyella clar o ocre daurat, cobert d\'un fi reticle blanc a la part superior.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE DE MÀXIMA QUALITAT, considerat per molts boletaires el millor dels ceps per la seva carn blanca, dura i intensament aromàtica. Termòfil, típic dels alzinars, suredes i rouredes mediterrànies.'),
          dexNumber: Value(36),
          imageAssetPath: Value('assets/images/mushrooms/boletus_aereus.png'),
        ),
        BoletsCompanion(
          id: Value('coprinus_comatus'),
          catalanName: Value('Bolet de tinta / Braguer de vaca'),
          scientificName: Value('Coprinus comatus'),
          family: Value('Agaricaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[4,5,9,10,11]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1700),
          capDescription: Value(
              'De 5 a 15 cm d\'alçada, cilíndric o acampanat estret. Superfície blanca coberta d\'esquames blanes, fibroses i llanoses corbades cap amunt. En madurar, el marge es desfà ràpidament en un líquid negre com la tinta (deliquescència).'),
          gillsDescription: Value(
              'Molt atapeïdes, lliures, amples, inicialment d\'un blanc pur, després rosades des de baix i ràpidament es tornen negres i líquides.'),
          stemDescription: Value(
              'De 8 a 20 cm, esvelt, buit, fibrós, blanc sedós, atenuat cap a dalt amb un bulb basal i un petit anell mòbil que sovint cau a la base.'),
          safetyNotes: Value(
              'DELICIÓS COMESTIBLE QUAN ÉS JOVE (quan les làmines són completament blanques). S\'ha de cuinar ràpidament després de la collita abans que comenci a liquefactar-se. A diferència del coprí gris (Coprinopsis atramentaria), aquest NO conté coprina i es pot consumir amb alcohol amb moderació.'),
          dexNumber: Value(37),
          imageAssetPath: Value('assets/images/mushrooms/coprinus_comatus.png'),
        ),
        BoletsCompanion(
          id: Value('lactarius_torminosus'),
          catalanName: Value('Cabra / Rovelló bord'),
          scientificName: Value('Lactarius torminosus'),
          family: Value('Russulaceae'),
          rarityTier: Value('rar'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 4 a 12 cm, deprimit al centre amb marge molt enrotllat i cobert d\'una llana o borra abundant de pèls llanosos blanquinosos (barbat). Color rosa maduixa o salmó amb cercles concèntrics més foscos.'),
          gillsDescription: Value(
              'Decurrents, juntes, pàl·lides de color crema a rosa blanquinós. En trencar-se exsuden un làtex blanc abundant, immutable a l\'aire i d\'un gust extremadament coent i picant.'),
          stemDescription: Value(
              'De 3 a 7 cm, cilíndric, buit, dur, de color rosa pàl·lid o groguenc clar, sovint amb petits clotets foscos (escrobícules).'),
          safetyNotes: Value(
              'TÒXIC GRAU. Provoca còlics dolorosos, nàusees i gastroenteritis severa (síndrome resinoidiana). Es distingeix clarament del rovelló (L. deliciosus) pel seu marge abundantment llanós i pel làtex blanc i extremadament picant (mai taronja).'),
          dexNumber: Value(38),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_torminosus.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_pantherina'),
          catalanName: Value('Pantera / Reig bord pigat'),
          scientificName: Value('Amanita pantherina'),
          family: Value('Amanitaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[6,7,9,10,11]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 5 a 12 cm, hemisfèric i després convex-estès, de color bru avellana, bru ocre o terrós fosc, amb el marge clarament estriat. Cobert de nombroses berrugues piramidals o escates petites d\'un blanc pur i farinós.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, desiguals, d\'un color blanc pur immutable.'),
          stemDescription: Value(
              'De 6 a 12 cm, cilíndric, blanc, atenuat cap amunt. Té un anell membranós blanc baix i penjant, i una base bulbosa arrodonida envoltada per 1 o 2 anells concèntrics o rodetes helicoïdals (volva dissociada en collarets).'),
          safetyNotes: Value(
              'MOLT TÒXIC I PERILLÓS (síndrome panterínica o anticolinèrgica per àcid ibotènic i muscimol). Provoca deliris, convulsions, al·lucinacions i coma. Perill de confusió amb la cua de cavall comestible (Amanita rubescens), que enrogeix a la carn i té marge no estriat.'),
          dexNumber: Value(39),
          imageAssetPath:
              Value('assets/images/mushrooms/amanita_pantherina.png'),
        ),
        BoletsCompanion(
          id: Value('gyromitra_esculenta'),
          catalanName: Value('Bolet de greix / Falsa múrgola'),
          scientificName: Value('Gyromitra esculenta'),
          family: Value('Discinaceae'),
          rarityTier: Value('rar'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[3,4,5]'),
          altitudeMin: Value(600),
          altitudeMax: Value(2000),
          capDescription: Value(
              'De 4 a 10 cm, arrodonit, irregular, buit, amb la superfície fortament plegada i ondulada en lòbuls sinuosos que recorden les circumvolucions d\'un cervell humà. Color bru vermellós fosc, castany o xocolata.'),
          gillsDescription: Value(
              'Sense làmines; l\'himeni fèrtil recobreix tota la superfície externa dels plecs cerebriformes del barret.'),
          stemDescription: Value(
              'De 3 a 6 cm, curt, gruixut, buit, irregularment arrugat, de color blanc a ocre groguenc pàl·lid.'),
          safetyNotes: Value(
              'MORTAL. Conté giromitrina, una toxina acumulativa que a l\'organisme es degrada en monometilhidrazina (combustible de coets), destruint glòbuls vermells i causant greus danys hepàtics i renals sovint mortals. Gran perill de confusió a la primavera amb la múrgola (Morchella esculenta), que té alvèols regulars tipus bresca i mai plecs cerebriformes.'),
          dexNumber: Value(40),
          imageAssetPath:
              Value('assets/images/mushrooms/gyromitra_esculenta.png'),
        ),
        BoletsCompanion(
          id: Value('hygrophorus_personii'),
          catalanName: Value('Llenega d\'alzina / Llanega d\'alzina'),
          scientificName: Value('Hygrophorus personii'),
          family: Value('Hygrophoraceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1200),
          capDescription: Value(
              'De 4 a 10 cm, de convex a aplanat amb un umbó central més fosc. Cutícula molt viscosa en temps humit, de color bru olivaci a marró castany.'),
          gillsDescription: Value(
              'Adnades o decurrents, gruixudes, ceroses, espaiades, blanques o amb tons crema.'),
          stemDescription: Value(
              'Esvelt, cilíndric i atenuat a la base. Blanc a la part superior i cobert d\'una beina viscosa amb dibuix tigrat bru olivaci per sota.'),
          safetyNotes: Value(
              'Comestible excel·lent típic d\'alzinars. Atenció a no confondre amb la Farinera borda mortal (Amanita phalloides), que té volva i anell membranós lliure.'),
          dexNumber: Value(41),
          imageAssetPath:
              Value('assets/images/mushrooms/hygrophorus_personii.png'),
        ),
        BoletsCompanion(
          id: Value('pleurotus_eryngii'),
          catalanName: Value('Gírgola de panical / Bolet de card'),
          scientificName: Value('Pleurotus eryngii'),
          family: Value('Pleurotaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11,12,3,4,5]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 4 a 12 cm, convex a deprimit, de color bru grisenc a marró ocre, amb el marge enrotllat inicialment.'),
          gillsDescription: Value(
              'Molt decurrents, espaiades, blanquinoses que passen a crema o gris pàl·lid.'),
          stemDescription: Value(
              'Gruixut, robust, massís, sovint excèntric, blanc a blanquinós atenuat a la base.'),
          safetyNotes: Value(
              'Excel·lent comestible que creix en pastures i erms associat a les arrels del panical (Eryngium campestre). Diferenciar de la tòxica Gírgola d\'olivera.'),
          dexNumber: Value(42),
          imageAssetPath:
              Value('assets/images/mushrooms/pleurotus_eryngii.png'),
        ),
        BoletsCompanion(
          id: Value('lactarius_semisanguifluus'),
          catalanName: Value('Pinetell de sang / Rovelló de pi negre'),
          scientificName: Value('Lactarius semisanguifluus'),
          family: Value('Russulaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11]'),
          altitudeMin: Value(800),
          altitudeMax: Value(2000),
          capDescription: Value(
              'De 4 a 10 cm, de convex a embutat, ataronjat amb tons rosats i zones concèntriques, que ràpidament s\'oxida i es taca de verdet intens.'),
          gillsDescription: Value(
              'Apretades, decurrents, de color taronja que ràpidament s\'enrogeixen i es taquen de verd fosc.'),
          stemDescription: Value(
              'Curt, cilíndric, ataronjat amb petites escrobícules vinoses, buit amb l\'edat.'),
          latexDescription: Value(
              'Taronja clar inicialment que en menys de 5-10 minuts vira a color vi negre/porpra intens.'),
          safetyNotes: Value(
              'Excel·lent comestible molt apreciat a les comarques pirinenques. Diferenciar del Fals rovelló (L. chrysorrheus) de llet blanca que es torna groga.'),
          dexNumber: Value(43),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_semisanguifluus.png'),
        ),
        BoletsCompanion(
          id: Value('suillus_bellinii'),
          catalanName: Value('Pinet de pi bord / Molleric de Bellini'),
          scientificName: Value('Suillus bellinii'),
          family: Value('Suillaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(0),
          altitudeMax: Value(800),
          capDescription: Value(
              'De 5 a 12 cm, molt viscós i brillant en temps humit, de color blanquinós a crema marbrenc amb taques avellana.'),
          gillsDescription: Value(
              'Tubs curts i porus groc sofre viu que es tornen groc olivaci. Gotetes lleteres de jove.'),
          stemDescription: Value(
              'Curt, rabassut, cilíndric, blanquinós cobert de granulacions i punts vermellosos/carmí molt evidents. Sense anell.'),
          safetyNotes: Value(
              'Comestible de pi blanc i pinedes litorals. Cal treure la cutícula viscosa abans de coure per evitar efectes laxants.'),
          dexNumber: Value(44),
          imageAssetPath: Value('assets/images/mushrooms/suillus_bellinii.png'),
        ),
        BoletsCompanion(
          id: Value('tricholoma_equestre'),
          catalanName: Value('Groguet / Verderol / Bolet dels cavallers'),
          scientificName: Value('Tricholoma equestre'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 5 a 12 cm, convex a aplanat, viscós en temps humit, de color groc viu a groc verdós amb el centre marronós i fibril·lós.'),
          gillsDescription: Value(
              'Escotades, atapeïdes, de color groc sofre intens i immutable.'),
          stemDescription: Value(
              'Robust, sòlid, cilíndric, del mateix color groc que les làmines o lleugerament més pàl·lid, sense anell.'),
          safetyNotes: Value(
              'TÒXIC / SOSPITÓS: Tradicionalment consumit però actualment prohibit el seu consum i venda per risc de rabdomiòlisi greu (destrucció muscular) per consums repetits.'),
          dexNumber: Value(45),
          imageAssetPath:
              Value('assets/images/mushrooms/tricholoma_equestre.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_virosa'),
          catalanName: Value('Farinera pudent / Àngel de la mort'),
          scientificName: Value('Amanita virosa'),
          family: Value('Amanitaceae'),
          rarityTier: Value('rar'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[7,8,9,10]'),
          altitudeMin: Value(700),
          altitudeMax: Value(1900),
          capDescription: Value(
              'De 5 a 10 cm, cònic o campanulat asimètric, blanc pur lluent, llis, lleugerament viscós en temps humit.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, blanques immutables, amb nombroses lamel·lules intercalades.'),
          stemDescription: Value(
              'Alt, esvelt, blanc, cobert d\'esquames llanoses o flocoses marcades, amb un anell blanc estriat penjant i volva en sac a la base.'),
          safetyNotes: Value(
              'MORTAL. Conté amatoxines letals que causen necrosi hepàtica fulminant irreversible. Diferenciar del Moixernó i Xampinyons per la presència de volva i làmines blanques.'),
          dexNumber: Value(46),
          imageAssetPath: Value('assets/images/mushrooms/amanita_virosa.png'),
        ),
        BoletsCompanion(
          id: Value('galerina_marginata'),
          catalanName: Value('Galerina mortal / Galerina vironosa'),
          scientificName: Value('Galerina marginata'),
          family: Value('Hymenogastraceae'),
          rarityTier: Value('comu'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[8,9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1900),
          capDescription: Value(
              'De 1.5 a 4 cm, convex a aplanat, higròfan, de color bru groguenc a ocre mel amb el marge estriat per transparència quan és humit.'),
          gillsDescription: Value(
              'Adnades a lleugerament decurrents, juntes, inicialment ocre pàl·lid que passen a marró rovell amb les espores madures.'),
          stemDescription: Value(
              'Prim, fibril·lós, bru fosc amb fibril·les blanquinoses a la part inferior i un anell membranós fugaç estret a la part superior.'),
          safetyNotes: Value(
              'MORTAL. Conté amatoxines idèntiques a la Farinera borda. Creix sobre fusta de coníferes. MAI confondre amb la Gírgola ni amb la Carrereta.'),
          dexNumber: Value(47),
          imageAssetPath:
              Value('assets/images/mushrooms/galerina_marginata.png'),
        ),
        BoletsCompanion(
          id: Value('tuber_melanosporum'),
          catalanName: Value('Tòfona negra / Trufa negra'),
          scientificName: Value('Tuber melanosporum'),
          family: Value('Tuberaceae'),
          rarityTier: Value('llegendari'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[11,12,1,2,3]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1400),
          capDescription: Value(
              'Bolet subterrani (hipogeu) de 2 a 10 cm, globular o arrodonit de forma irregular. Peridi (pell externa) negre carbó o bru fosc, cobert de berrugues piramidals poligonals molt dures.'),
          gillsDescription: Value(
              'No té làmines ni porus. Gleba (massa interna) sòlida, ferma, compacta, de color marró-negre a violaci fosc, densament marbrejada de fines venes blanques ramificades.'),
          stemDescription: Value(
              'Massa fúngica sense peu ni tija, unida al sòl calcari per un petit cordó miceliar basal.'),
          safetyNotes: Value(
              'Excel·lentíssim comestible de màxima categoria gastronòmica. ATENCIÓ: No confondre amb el Patac d\'ase (Scleroderma citrinum), tòxic, de pell groguenca berrugosa i interior negre sense venes blanques.'),
          dexNumber: Value(48),
          imageAssetPath:
              Value('assets/images/mushrooms/tuber_melanosporum.png'),
        ),
        BoletsCompanion(
          id: Value('infundibulicybe_geotropa'),
          catalanName: Value('Pampa / Candela de bruixa'),
          scientificName: Value('Infundibulicybe geotropa'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1500),
          capDescription: Value(
              'Gran i imponent (10-25 cm), convex d\'inici que s\'embuta profundament amb l\'edat, amb un característic mugró o bony central prominent. De color beix ocre pàl·lid, camussa o cafè amb llet clar.'),
          gillsDescription: Value(
              'Molt decurrents (baixen molt pel peu), atapeïdes, del mateix color crema blanquinós que el barret.'),
          stemDescription: Value(
              'Robust, alt (10-20 cm), fibril·lós, del mateix color que el barret, engruixit i cotonós a la base.'),
          safetyNotes: Value(
              'Estrella del fricandó i dels guisats tradicionals catalans per la seva carn ferma i aromàtica. No confondre amb la Pampa de boira (Clitocybe nebularis), tòxica en cru i sovint indigesta, de barret gris cendrós sense mugró central.'),
          dexNumber: Value(49),
          imageAssetPath:
              Value('assets/images/mushrooms/infundibulicybe_geotropa.png'),
        ),
        BoletsCompanion(
          id: Value('boletus_pinophilus'),
          catalanName: Value('Cep vermell / Cep de pi'),
          scientificName: Value('Boletus pinophilus'),
          family: Value('Boletaceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[8,9,10,11]'),
          altitudeMin: Value(800),
          altitudeMax: Value(2100),
          capDescription: Value(
              'Massís i corpulent (8-25 cm), convex, de color caoba fosc, bru rogenc o coure vermellós amb reflexos granats, amb una superfície rugosa finament vellutada.'),
          gillsDescription: Value(
              'Tubs i porus fins, inicialment blancs immaculats, que passen a groc daurat i finalment a verd oliva en madurar. No blavegen al toc.'),
          stemDescription: Value(
              'Molt gruixut, ventrut o bulbós, de color canyella pàl·lid o ocre rogenc, amb un reticle fi blanquinós a la part superior.'),
          safetyNotes: Value(
              'Excel·lent comestible de primera classe (el tercer cep reial català). Es pot menjar cru en carpaccio o a la brasa. Compte amb el Mataparent amarg (Tylopilus felleus), de porus rosats i sabor insuportablement amarg.'),
          dexNumber: Value(50),
          imageAssetPath:
              Value('assets/images/mushrooms/boletus_pinophilus.png'),
        ),
        BoletsCompanion(
          id: Value('neoboletus_luridiformis'),
          catalanName: Value('Mataparent de peu vermell'),
          scientificName: Value('Neoboletus luridiformis'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[7,8,9,10,11]'),
          altitudeMin: Value(600),
          altitudeMax: Value(1900),
          capDescription: Value(
              'De 6 a 20 cm, hemisfèric a convex, vellutat, de color marró xocolata fosc, marró vellut o bru sutge.'),
          gillsDescription: Value(
              'Porus petits, rodons, de color vermell sang viu o vermell ataronjat, que blavegen intensament al mínim frec o pressió.'),
          stemDescription: Value(
              'Gruixut, robust, groc de fons però densament pigallat de granulacions o punts vermells (MAI amb reticle o xarxa).'),
          safetyNotes: Value(
              'BON COMESTIBLE UN COP CUIT. Tòxic en cru: conté hemolisines termolàbils que es destrueixen completament amb una cocció perllongada d\'almenys 15-20 minuts. Mai s\'ha de consumir cru o poc fet. DIFERENCIACIÓ CLAU: El perillós Mataparent de Satanàs té barret blanquinós i peu reticulat; el Mataparent de bou (S. luridus) té reticle al peu i és tòxic en cru.'),
          dexNumber: Value(51),
          imageAssetPath:
              Value('assets/images/mushrooms/neoboletus_luridiformis.png'),
        ),
        BoletsCompanion(
          id: Value('boletus_reticulatus'),
          catalanName: Value('Cep d\'estiu / Siuró d\'estiu'),
          scientificName: Value('Boletus reticulatus'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[5,6,7,8,9,10]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 7 a 22 cm, convex, sec, finament vellutat, de color beix ocre clar, avellana o cafè amb llet, sovint clivellat en petits mosaics en temps sec.'),
          gillsDescription: Value(
              'Tubs i porus blancs en exemplars joves, que es tornen groguencs i verdosos amb l\'edat. No canvien de color al tacte.'),
          stemDescription: Value(
              'Robust, cilíndric o bombat a la base, marró clar, cobert de dalt a baix per una xarxa o reticle blanquinós molt marcat i evident.'),
          safetyNotes: Value(
              'Excel·lent comestible d\'olor intensament afruitada i dolça d\'avellana. És el primer cep en aparèixer a la primavera i estiu sota roures, alzines i castanyers.'),
          dexNumber: Value(52),
          imageAssetPath:
              Value('assets/images/mushrooms/boletus_reticulatus.png'),
        ),
        BoletsCompanion(
          id: Value('hygrophorus_marzuolus'),
          catalanName: Value('Marçot / Bolet de març'),
          scientificName: Value('Hygrophorus marzuolus'),
          family: Value('Hygrophoraceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[2,3,4]'),
          altitudeMin: Value(700),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 4 a 12 cm, carnós, irregularment convex, de color gris plom, gris cendra fosc a negre sutge, sovint clapat de blanquinós en estar enterrat sota la pinassa.'),
          gillsDescription: Value(
              'Làmines ceroses, una mica espaiades, adnades a lleugerament decurrents, blanques al principi i grisoses en envellir.'),
          stemDescription: Value(
              'Curt, robust, massís, blanc a grisenc, fibril·lós, sovint corbat per la pressió de la pinassa.'),
          safetyNotes: Value(
              'Excel·lent comestible molt buscat. És el bolet més primerenc de Catalunya: surt a finals d\'hivern i principis de primavera just després del desglaç sota pins i faigs.'),
          dexNumber: Value(53),
          imageAssetPath:
              Value('assets/images/mushrooms/hygrophorus_marzuolus.png'),
        ),
        BoletsCompanion(
          id: Value('russula_aurea'),
          catalanName: Value('Llora daurada / Cuaverda daurada'),
          scientificName: Value('Russula aurea'),
          family: Value('Russulaceae'),
          rarityTier: Value('rar'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[6,7,8,9,10]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 5 a 10 cm, convex que s\'aplana, de color vermell vermelló viu amb taques groc daurat o crom llimona característiques, especialment al marge.'),
          gillsDescription: Value(
              'Lliures o adnades, fràgils, de color groc llimona a daurat viu molt cridaner (mai blanques), amb les arestes més intensament grogues.'),
          stemDescription: Value(
              'Cilíndric, carnós, blanc tacat o completament tenyit de groc llimona daurat.'),
          safetyNotes: Value(
              'Excel·lent comestible de sabor dolç d\'avellana. Es distingeix de les rússules vermelles tòxiques (com la Rússula emètica) perquè aquesta té les làmines i el peu de color groc daurat, i no pica.'),
          dexNumber: Value(54),
          imageAssetPath: Value('assets/images/mushrooms/russula_aurea.png'),
        ),
        BoletsCompanion(
          id: Value('craterellus_tubaeformis'),
          catalanName: Value('Rossinyol de bosc / Trompeta groga'),
          scientificName: Value('Craterellus tubaeformis'),
          family: Value('Cantharellaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 2 a 6 cm, en forma d\'embut o trompeta perforada al centre fins a l\'interior buit del peu. De color marró fosc, bru groguenc o bistre amb vores ondulades.'),
          gillsDescription: Value(
              'No té làmines veritables, sinó plecs gruixuts, espaiats, ramificats i decurrents, de color groc grisenc a groc lila.'),
          stemDescription: Value(
              'Prim, buit, aplanat i solcat longitudinalment, de color groc or o groc ataronjat brillant molt cridaner.'),
          safetyNotes: Value(
              'Molt bon comestible, germà tardorí del Camagroc. Ideal per assecar, per fer arrossos de muntanya, saltats de pasta i remenats d\'ous.'),
          dexNumber: Value(55),
          imageAssetPath:
              Value('assets/images/mushrooms/craterellus_tubaeformis.png'),
        ),
        BoletsCompanion(
          id: Value('agaricus_arvensis'),
          catalanName: Value('Bola de neu / Xampinyó d\'anís'),
          scientificName: Value('Agaricus arvensis'),
          family: Value('Agaricaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[5,6,9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1700),
          capDescription: Value(
              'Gros i corpulent (8-20 cm), globós de jove (forma de bola de neu) que s\'aplana a convex. De color blanc pur a blanc groguenc, que es taca suaument de groc ocre en fregar-lo.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, blanquinoses o rosa molt pàl·lid d\'inici, passant a marró xocolata fosques amb la maduració de les espores.'),
          stemDescription: Value(
              'Robust, cilíndric, blanc, amb un anell doble membranós molt característic amb forma d\'engranatge o estrella (roda dentada) a la cara inferior.'),
          safetyNotes: Value(
              'Excel·lent comestible d\'aroma agradable d\'anís o ametlles. DIFERENCIACIÓ VITAL: El tòxic Xampinyó groguenc (A. xanthodermus) grogueja immediatament amb groc crom intens a la base del peu i fa forta olor desagradable de tinta o fenol.'),
          dexNumber: Value(56),
          imageAssetPath:
              Value('assets/images/mushrooms/agaricus_arvensis.png'),
        ),
        BoletsCompanion(
          id: Value('hydnum_rufescens'),
          catalanName: Value('Llengua de bou rogenca'),
          scientificName: Value('Hydnum rufescens'),
          family: Value('Hydnaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1700),
          capDescription: Value(
              'De 3 a 8 cm, irregular, convex a pla, de color ataronjat rogenc, terracota o bru albercoc pàl·lid, més petit i prim que H. repandum.'),
          gillsDescription: Value(
              'Himeni format per agulles (fibres còniques descendents) molt denses i fràgils, de color crema ataronjat, adnades a decurrents.'),
          stemDescription: Value(
              'Cilíndric, prim, del mateix color ataronjat clar o blanquinós que el barret, sovint una mica descentrat.'),
          safetyNotes: Value(
              'Bon comestible de carn ferma i gust agradable lleugerament picant. Convé coure\'l bé per eliminar l\'amargor residual en exemplars vells. Molt bo en conserva d\'oli i vinagre o estofat.'),
          dexNumber: Value(57),
          imageAssetPath: Value('assets/images/mushrooms/hydnum_rufescens.png'),
        ),
        BoletsCompanion(
          id: Value('scleroderma_citrinum'),
          catalanName: Value('Patac d\'ase / Tòfona borda'),
          scientificName: Value('Scleroderma citrinum'),
          family: Value('Sclerodermataceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[8,9,10,11,12]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 3 a 10 cm, globular o arrodonit deprimit, amb una pell (peridi) molt gruixuda, coriàcia i dura, de color groguenc ocre o terrós pàl·lid, coberta de berrugues i clivelles escamoses.'),
          gillsDescription: Value(
              'Interior (gleba) completament massís, inicialment blanc grisenc que ràpidament passa a negre violaci o negre blavós fosc sense cap veta blanca de marbrejat.'),
          stemDescription: Value(
              'No té peu real; només presenta un feix de filaments miceliars curts a la base que el fixen al terra.'),
          safetyNotes: Value(
              'TÒXIC. Provoca intoxicacions gastrointestinals severes amb vòmits, diarrees intenses i marejos. CONFUSIÓ PERILLOSA: Es pot confondre amb la Tòfona negra, però té la pell coriàcia groguenca i l\'interior negre sense vetes blanques.'),
          dexNumber: Value(58),
          imageAssetPath:
              Value('assets/images/mushrooms/scleroderma_citrinum.png'),
        ),
        BoletsCompanion(
          id: Value('clitocybe_nebularis'),
          catalanName: Value('Pampa de boira / Boira'),
          scientificName: Value('Clitocybe nebularis'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[10,11,12]'),
          altitudeMin: Value(300),
          altitudeMax: Value(1600),
          capDescription: Value(
              'De 7 a 18 cm, carnós, convex a pla amb el marge enrotllat, de color gris cendrós, gris boira o fum, sense mugró central.'),
          gillsDescription: Value(
              'Molt atapeïdes, decurrents, de color crema pàl·lid a groguenc, que es desprenen fàcilment de la carn del barret amb el dit.'),
          stemDescription: Value(
              'Robust, claviforme (engruixit a la base), fibril·lós, del mateix color gris blanquinós que el barret.'),
          safetyNotes: Value(
              'TÒXIC en cru i sovint INDIGEST fins i tot cuinat; conté nebularina i provoca nàusees i trastorns gàstrics a moltes persones. CONFUSIÓ: Es distingeix de la Pampa bona (I. geotropa) perquè no té mugró central i fa olor dolcenca enfarfegosa.'),
          dexNumber: Value(59),
          imageAssetPath:
              Value('assets/images/mushrooms/clitocybe_nebularis.png'),
        ),
        BoletsCompanion(
          id: Value('tylopilus_felleus'),
          catalanName: Value('Mataparent amarg / Cep amarg'),
          scientificName: Value('Tylopilus felleus'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('sense_valor'),
          fruitingSeason: Value('[7,8,9,10,11]'),
          altitudeMin: Value(500),
          altitudeMax: Value(1700),
          capDescription: Value(
              'De 6 a 15 cm, convex a pla, llis, sec, de color marró clar, beix avellana o ocre camussa, idèntic al barret d\'un Cep jove.'),
          gillsDescription: Value(
              'Tubs i porus blancs inicialment, que adquireixen un inconfusible to ROSAT o rosa brut en madurar. No blavegen.'),
          stemDescription: Value(
              'Robust, bulbós a cilíndric, ocre pàl·lid, cobert per un reticle (xarxa) molt marcat i en relleu de color marró fosc o negrenc.'),
          safetyNotes: Value(
              'NO COMESTIBLE PER EXTREMA AMARGOR. No és mortal ni verinós greu, però un sol trosset arruïna completament una cassola o paella sencera de ceps. DIFERÈNCIA: Els ceps bons tenen porus grocs/oliva i reticle blanc; aquest té porus rosats i reticle marró fosc.'),
          dexNumber: Value(60),
          imageAssetPath:
              Value('assets/images/mushrooms/tylopilus_felleus.png'),
        ),
        BoletsCompanion(
          id: Value('suillellus_luridus'),
          catalanName: Value('Mataparent de bou / Fals bolet de bou'),
          scientificName: Value('Suillellus luridus'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[6,7,8,9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 7 a 20 cm, convex, sec, finament vellutat, de color marró olivaci fosc, ocre terrós o gamussa brut.'),
          gillsDescription: Value(
              'Porus petits, rodons, de color vermell ataronjat a vermell maó, que blavegen immediatament a la pressió.'),
          stemDescription: Value(
              'Robust, cilíndric o eixamplat a la base, groc-ataronjat, cobert per una xarxa o RETICLE vermell molt marcat amb malles allargades.'),
          safetyNotes: Value(
              'TÒXIC en cru i especialment TÒXIC SI ES CONSUMEIX AMB ALCOHOL (síndrome coprinià amb sufocacions, taquicàrdia i vòmits). Es diferencia del Mataparent de peu vermell perquè aquest té un reticle evident a la cama, mentre que el peu vermell només té punts o pigues.'),
          dexNumber: Value(61),
          imageAssetPath:
              Value('assets/images/mushrooms/suillellus_luridus.png'),
        ),
        BoletsCompanion(
          id: Value('russula_emetica'),
          catalanName: Value('Rússula emètica / Cua cremosa'),
          scientificName: Value('Russula emetica'),
          family: Value('Russulaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[7,8,9,10,11]'),
          altitudeMin: Value(500),
          altitudeMax: Value(1900),
          capDescription: Value(
              'De 4 a 9 cm, convex que s\'aplana i es deprimeix al centre, lluent, viscós en temps humit, de color vermell cirera o escarlata molt viu i uniforme.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, molt trencadisses, de color blanc pur immaculat (MAI grogues).'),
          stemDescription: Value(
              'Cilíndric, fràgil, buit amb l\'edat, blanc pur brillant sense cap tint groguenc.'),
          safetyNotes: Value(
              'TÒXIC. Provoca vòmits violents i gastroenteritis aguda per la seva forta toxicitat. Té un gust extremadament coent i picant que crema la llengua en tastar una engruna. Es distingeix de la Llora daurada perquè les làmines i el peu són completament blancs.'),
          dexNumber: Value(62),
          imageAssetPath: Value('assets/images/mushrooms/russula_emetica.png'),
        ),
        BoletsCompanion(
          id: Value('cyclocybe_aegerita'),
          catalanName: Value('Pollancró / Bolet de pollanc'),
          scientificName: Value('Cyclocybe aegerita'),
          family: Value('Strophariaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[4,5,6,7,8,9,10,11]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1200),
          capDescription: Value(
              'De 4 a 14 cm, hemisfèric i marró avellana de jove, després convex-aplanat amb el centre més fosc i el marge ondulat i blanquinós.'),
          gillsDescription: Value(
              'Adenyades o lleugerament decurrents, molt atapeïdes, blanquinoses que passen a ocre rogenc o canyella per les espores.'),
          stemDescription: Value(
              'Llarg, corbat, fibrós i tenaç, blanc o bru clar, amb un anell membranós persistent molt evident situat a la part alta.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE molt apreciat a la cuina catalana. Creix en feixos densos sobre troncs i soques de pollancres, àlbers, salzes i figueres. Cal no confondre\'l amb el tòxic Bolet de pi amarg (Hypholoma fasciculare, de làmines verdoses i gust molt amarg) ni amb la mortal Galerina marginata (que creix sobre coníferes).'),
          dexNumber: Value(63),
          imageAssetPath:
              Value('assets/images/mushrooms/cyclocybe_aegerita.png'),
        ),
        BoletsCompanion(
          id: Value('tricholoma_portentosum'),
          catalanName:
              Value('Fredolic d\'anís / Tortell d\'anís / Griset de cavall'),
          scientificName: Value('Tricholoma portentosum'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(700),
          altitudeMax: Value(1900),
          capDescription: Value(
              'De 5 a 12 cm, convex a aplanat amb un umbó obtús, una mica viscós en temps humit, de color gris cendra a gris sutge amb reflexos groguencs i fibril·les radials fosques.'),
          gillsDescription: Value(
              'Escotades, amples, espaiades, blanques amb reflexos groc llimona molt característics en madurar.'),
          stemDescription: Value(
              'Robust, cilíndric, blanc o amb suaus reflexos groguencs, massís i estriat longitudinalment.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE d\'alta muntanya, superior al fredolic comú per la seva carn ferma i suau aroma de farina fresca i anís. Molt buscat al Pirineu a les pinedes de pi roig i pi negre. Cal no confondre\'l amb el tòxic Fredolic bord (Tricholoma pardinum, de barret esquamós) ni amb el Bolet de sabó (Tricholoma saponaceum, d\'olor desagradable de sabó de rentar).'),
          dexNumber: Value(64),
          imageAssetPath:
              Value('assets/images/mushrooms/tricholoma_portentosum.png'),
        ),
        BoletsCompanion(
          id: Value('tuber_aestivum'),
          catalanName: Value('Tòfona d\'estiu / Trufa d\'estiu'),
          scientificName: Value('Tuber aestivum'),
          family: Value('Tuberaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[5,6,7,8,9]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1300),
          capDescription: Value(
              'Cos subterrani arrodonit o lobulat de 2 a 10 cm, amb peridi negre o bru molt fosc recobert de berrugues piramidals grosses, anguloses i dures.'),
          gillsDescription: Value(
              'Gleba interna massissa, inicialment blanquinosa i després marró avellana o ocre clar, travessada per un dens reticle de venes blanques ramificades.'),
          stemDescription: Value(
              'Mancat de peu visible. Es recol·lecta sota terra amb ajuda de gossos tofoners a poca fondària sota roures, alzines, avellaners i faigs.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE. D\'aroma més suau que la tòfona negra d\'hivern, té una agradable olor d\'avellana i fong fresc ideal per laminar en cru. Es diferencia del Patac d\'ase (Scleroderma citrinum) perquè aquest té l\'interior negre carbó sense venes blanques i és de pell groguenca amarga i tòxica.'),
          dexNumber: Value(65),
          imageAssetPath: Value('assets/images/mushrooms/tuber_aestivum.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_rubescens'),
          catalanName: Value('Cua de cavall / Vinosa'),
          scientificName: Value('Amanita rubescens'),
          family: Value('Amanitaceae'),
          rarityTier: Value('comu'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[5,6,7,8,9,10,11]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1500),
          capDescription: Value(
              'De 6 a 18 cm, globós que passa a convex-aplanat, de color terrós rogenc a bru rosat, cobert de restes de vel en forma de berrugues farinoses irregulars gris-rosades.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, blanques que s\'enrogeixen i prenen taques vinoses o vermelloses amb l\'edat o en fregar-les.'),
          stemDescription: Value(
              'Cilíndric, atenuat cap amunt amb base bulbosa arrodonida, blanc-rosat que pren tons vinosos a la base, amb un gran anell membranós estriat a la part superior.'),
          safetyNotes: Value(
              'COMESTIBLE DE QUALITAT ÚNICAMENT SI ES CUINA A FONS (>70 °C durant més de 15 minuts). TÒXICA EN CRU per presència d\'hemolisines que destrueixen els glòbuls vermells i que es destrueixen completament amb la calor. ALERTA MÀXIMA DE CONFUSIÓ amb la molt tòxica Pantera (Amanita pantherina); la Vinosa enrogeix clarament a qualsevol ferida i no té la volva circuncisa esglaonada de la Pantera.'),
          dexNumber: Value(66),
          imageAssetPath:
              Value('assets/images/mushrooms/amanita_rubescens.png'),
        ),
        BoletsCompanion(
          id: Value('imleria_badia'),
          catalanName: Value('Bolet de baia / Cep de baia / Molleric de baia'),
          scientificName: Value('Imleria badia'),
          family: Value('Boletaceae'),
          rarityTier: Value('comu'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[8,9,10,11]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 5 a 15 cm, hemisfèric a convex, vellutat de jove i viscós en temps humit, de color marró castany fosc, xocolata o bru vermellós.'),
          gillsDescription: Value(
              'Porus petits i angulosos, de color crema pàl·lid que viren ràpidament a groc-verdós i blavegen de forma intensa en prémer-los.'),
          stemDescription: Value(
              'Cilíndric o lleugerament ventrut, de color ocre o bru clar amb fines fibril·les longitudinals marronoses, SENSE cap reticle ni xarxa.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE. Molt consumit a Catalunya com a substitut del cep en arrossos, saltats i deshidratat. Cal diferenciar-lo del Mataparent amarg (Tylopilus felleus), que té porus rosats de madur, reticle evident i un gust amarg repugnant.'),
          dexNumber: Value(67),
          imageAssetPath: Value('assets/images/mushrooms/imleria_badia.png'),
        ),
        BoletsCompanion(
          id: Value('lactarius_vinosus'),
          catalanName: Value('Rovelló de sang vinosa / Lleterola vinosa'),
          scientificName: Value('Lactarius vinosus'),
          family: Value('Russulaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1000),
          capDescription: Value(
              'De 5 a 12 cm, convex amb el centre deprimit, de color lila vinós a vermell fosc amb reflexos grisencs o verds de vell, amb cercles concèntrics suaus.'),
          gillsDescription: Value(
              'Adenyades o una mica decurrents, atapeïdes, de color vermell vinós a porpra amb reflexos lilosos.'),
          latexDescription: Value(
              'Escàs, espès, de color vi negre fosc o remolatxa intensa, immutable o que s\'enfosqueix lentament, de gust suau no picant.'),
          stemDescription: Value(
              'Curt, cilíndric, massís i després buit, de color vinós pàl·lid cobert d\'un tovallol blanc.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE. Reconegut ràpidament pel seu làtex espès de color vi negre o remolatxa fosca (no pas taronja com el rovelló comú). Típic de les pinedes mediterrànies litorals i prelitorals sobre terreny calcari. No es pot confondre amb cap espècie perillosa.'),
          dexNumber: Value(68),
          imageAssetPath:
              Value('assets/images/mushrooms/lactarius_vinosus.png'),
        ),
        BoletsCompanion(
          id: Value('cantharellus_subpruinosus'),
          catalanName: Value('Rossinyol blanc / Rossinyol de roure'),
          scientificName: Value('Cantharellus subpruinosus'),
          family: Value('Cantharellaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('excellent'),
          fruitingSeason: Value('[5,6,9,10,11]'),
          altitudeMin: Value(150),
          altitudeMax: Value(1200),
          capDescription: Value(
              'De 4 a 12 cm, carnós, convex i després en embut amb el marge ondulat, de color groc rovell d\'ou cobert d\'una capa pruïnosa blanquinosa o platejada molt visible.'),
          gillsDescription: Value(
              'Format per plecs o venes decurrents bifurcades (no pas làmines), espaiades i gruixudes, de color groc daurat viu.'),
          stemDescription: Value(
              'Curt, massís, atenuat a la base, del mateix color groc que els plecs.'),
          safetyNotes: Value(
              'EXCEL·LENT COMESTIBLE, encara més carnós i compacte que el rossinyol comú, amb una intensa olor afruitada d\'albercoc. Molt fidel a les rouredes i alzinars mediterranis. Atenció a no confondre\'l amb la Gírgola d\'olivera (Omphalotus olearius, molt tòxica, amb làmines veritables fines i que creix sobre soques).'),
          dexNumber: Value(69),
          imageAssetPath:
              Value('assets/images/mushrooms/cantharellus_subpruinosus.png'),
        ),
        BoletsCompanion(
          id: Value('leccinum_aurantiacum'),
          catalanName: Value('Cep vermelló / Pell de taronja / Bolet vermell'),
          scientificName: Value('Leccinum aurantiacum'),
          family: Value('Boletaceae'),
          rarityTier: Value('poc_frequent'),
          edibility: Value('comestible'),
          fruitingSeason: Value('[6,7,8,9,10]'),
          altitudeMin: Value(400),
          altitudeMax: Value(1700),
          capDescription: Value(
              'De 6 a 20 cm, robust, hemisfèric a convex, sec, finament vellutat, d\'un color vermell ataronjat intens molt vistós que recorda la pell de taronja.'),
          gillsDescription: Value(
              'Tubs llargs i porus fins i rodons, de color blanc grisenc que prenen tons ocres i enfosqueixen en tocar-los.'),
          stemDescription: Value(
              'Molt llarg, robust i fibrós, eixamplat cap a la base, blanc i cobert de nombroses esquàmules o aspreses fosques (marronoses a negres).'),
          safetyNotes: Value(
              'BON COMESTIBLE UN COP BEN CUIT (TÒXIC EN CRU O POC FET: requereix cocció completa d\'almenys 15-20 minuts per evitar trastorns gastrointestinals). La carn és blanca però en tallar-la vira ràpidament a gris violaci i després a negre carbó; en cuinar-lo la carn es torna fosca però conserva un excel·lent sabor i textura ferma. El peu és fibrós i convé descartar-lo si és vell.'),
          dexNumber: Value(70),
          imageAssetPath:
              Value('assets/images/mushrooms/leccinum_aurantiacum.png'),
        ),
        BoletsCompanion(
          id: Value('hypholoma_fasciculare'),
          catalanName:
              Value('Bolet de pi amarg / Fals pollancró / Bolet de sofre'),
          scientificName: Value('Hypholoma fasciculare'),
          family: Value('Strophariaceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[4,5,6,7,8,9,10,11,12]'),
          altitudeMin: Value(50),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 2 a 7 cm, convex a pla-convex, llis, de color groc sofre molt brillant amb el centre ataronjat o vermellós.'),
          gillsDescription: Value(
              'Molt atapeïdes, adnates, inicialment grogues de sofre que viren ràpidament a verd oliva o verd fosc amb l\'esporada marró porpra.'),
          stemDescription: Value(
              'Prim, flexuós, buit, groc sofre a dalt i bru rovellat a la base, sense anell membranós però amb cortina fugaç fosca.'),
          safetyNotes: Value(
              'TÒXIC. Provoca greus trastorns gastrointestinals (gastroenteritis aguda, vòmits i rampes) que comencen entre 5 i 10 hores després de la ingesta. Té un sabor extremadament amarg i persistent. ALERTA: Sovint confós per boletaires novells amb el Pollancró (Cyclocybe aegerita) o les carreretes de soca; les seves làmines olivàcies i el gust amarg el delaten immediatament.'),
          dexNumber: Value(71),
          imageAssetPath:
              Value('assets/images/mushrooms/hypholoma_fasciculare.png'),
        ),
        BoletsCompanion(
          id: Value('paxillus_involutus'),
          catalanName:
              Value('Paxil·le / Fals rovelló d\'olor / Bolet enrotllat'),
          scientificName: Value('Paxillus involutus'),
          family: Value('Paxillaceae'),
          rarityTier: Value('comu'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[8,9,10,11]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 5 a 15 cm, convex que es deprimeix al centre en forma d\'embut ample, viscós en temps humit, de color ocre olivaci a marró terrós, amb el marge fortament ENROTLLAT cap a dins i vellutat.'),
          gillsDescription: Value(
              'Decurrents, bifurcades a la base prop del peu, groc ocre que s\'enfosqueixen i prenen taques marró rovellat molt fosques de seguida que es toquen.'),
          stemDescription: Value(
              'Curt, massís, cilíndric o atenuat a la base, del mateix color que el barret o més clar, llis.'),
          safetyNotes: Value(
              'MORTAL / GRAUMENT TÒXIC (Síndrome paxil·lià). Antigament consumit cuit, avui se sap que provoca una reacció autoimmune retardada potencialment mortal (hemòlisi intravascular aguda amb col·lapse renal) després de consums repetits. MAI S\'HA DE CONSUMIR. Els boletaires inexperts el poden confondre amb rovellons o ceps vells, però no té làtex i les làmines s\'oxiden a marró fosc.'),
          dexNumber: Value(72),
          imageAssetPath:
              Value('assets/images/mushrooms/paxillus_involutus.png'),
        ),
        BoletsCompanion(
          id: Value('amanita_citrina'),
          catalanName: Value('Farinera groga / Reig de la mort fals'),
          scientificName: Value('Amanita citrina'),
          family: Value('Amanitaceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[8,9,10,11,12]'),
          altitudeMin: Value(100),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 5 a 10 cm, hemisfèric a convex-aplanat, de color groc llimona pàl·lid, groc verdós o blanquinós, cobert de grans plaques membranoses irregulars de color bru grisenc.'),
          gillsDescription: Value(
              'Lliures, atapeïdes, de color blanc immaculat o lleugerament groguenques a la vora.'),
          stemDescription: Value(
              'Esvelt, blanc-groguenc, amb un anell membranós penjant groc pàl·lid i una base terminada en un bulb molt gros, globós i arrodonit amb un marge o vora tallada molt neta (bulb marginat).'),
          safetyNotes: Value(
              'TÒXIC (conté bufotenina i triptamines) I SENSE VALOR CULINARI. Té una forta i desagradable olor de patata crua o rave. ALERTA MÀXIMA DE CONFUSIÓ: La seva semblança superficial amb la mortal Farinera borda (Amanita phalloides), la Cicuta blanca (Amanita verna) o l\'Ou de reig (Amanita caesarea) la fa un bolet d\'alt risc. La Farinera borda té volva en sac i no fa olor de patata.'),
          dexNumber: Value(73),
          imageAssetPath: Value('assets/images/mushrooms/amanita_citrina.png'),
        ),
        BoletsCompanion(
          id: Value('tricholoma_saponaceum'),
          catalanName: Value('Bolet de sabó / Fredolic de sabó'),
          scientificName: Value('Tricholoma saponaceum'),
          family: Value('Tricholomataceae'),
          rarityTier: Value('comu'),
          edibility: Value('toxic'),
          fruitingSeason: Value('[9,10,11,12]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1800),
          capDescription: Value(
              'De 4 a 10 cm, convex a aplanat amb marge ondulat, llis, molt variable de color: gris verdós, bru olivaci o ocre pàl·lid.'),
          gillsDescription: Value(
              'Escotades, amples, espaiades, de color blanc verdós o crema que sovint prenen taques vermelloses o salmó de velles.'),
          stemDescription: Value(
              'Robust, sovint corbat i atenuat o radicant a la base, blanquinós amb una tonalitat rosa o salmó característica a la base del peu.'),
          safetyNotes: Value(
              'TÒXIC. Provoca nàusees i trastorns gastrointestinals. Té una fortíssima i inconfusible olor de sabó de rentar la roba o detergent que augmenta en coure\'s, i un gust amarg desagradable. Es pot confondre amb el Fredolic comú (Tricholoma terreum) o el Fredolic d\'anís (Tricholoma portentosum), però l\'olor de sabó i la base rosa el delaten.'),
          dexNumber: Value(74),
          imageAssetPath:
              Value('assets/images/mushrooms/tricholoma_saponaceum.png'),
        ),
        BoletsCompanion(
          id: Value('inocybe_erubescens'),
          catalanName: Value('Inòcibe de Patouillard'),
          scientificName: Value('Inocybe erubescens'),
          family: Value('Inocybaceae'),
          rarityTier: Value('rar'),
          edibility: Value('mortal'),
          fruitingSeason: Value('[4,5,6,7]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1400),
          capDescription: Value(
              'De 3 a 9 cm, cònic o acampanat amb un umbó central marcat i punxegut, blanc o crema pàl·lid que s\'esquerda radialment en fibril·les sedoses i que pren ràpidament TAQUES VERMELL-MAÓ intenses on es toca o envelleix.'),
          gillsDescription: Value(
              'Lliures o adnates, atapeïdes, inicialment blanquinoses que passen a canyella olivaci amb taques vermelloses vives.'),
          stemDescription: Value(
              'Robust, cilíndric amb base lleugerament bulbosa, blanc i finament estriat, que s\'enrogeix intensament a qualsevol pressió.'),
          safetyNotes: Value(
              'MORTAL (Síndrome muscarínic greu). Conté dosis molt elevades de muscarina. Provoca sudoració massiva, hipersecreció, bradicàrdia severa i xoc en menys d\'una hora. ALERTA DE PRIMAVERA: Freqüent a la primavera sota faigs i roures, es pot confondre fatalment amb el Moixernó (Calocybe gambosa) o les carreretes; el seu envermelliment vermell maó i barret cònic són claus vitals de seguretat.'),
          dexNumber: Value(75),
          imageAssetPath:
              Value('assets/images/mushrooms/inocybe_erubescens.png'),
        ),
      ];

  static List<ArbresCompanion> get arbres => const [
        ArbresCompanion(
          id: Value('pinus_sylvestris'),
          catalanName: Value('Pi roig'),
          scientificName: Value('Pinus sylvestris'),
          leafType: Value('Agulla'),
          barkDescription: Value('Tronc superior ataronjat'),
          typicalSoil: Value('Silici o àcid'),
          imageAssetPath: Value('assets/images/trees/pinus_sylvestris.png'),
        ),
        ArbresCompanion(
          id: Value('pinus_halepensis'),
          catalanName: Value('Pi blanc'),
          scientificName: Value('Pinus halepensis'),
          leafType: Value('Agulla'),
          barkDescription: Value('Escorça gris platejada'),
          typicalSoil: Value('Calcari'),
          imageAssetPath: Value('assets/images/trees/pinus_halepensis.png'),
        ),
        ArbresCompanion(
          id: Value('quercus_ilex'),
          catalanName: Value('Alzina'),
          scientificName: Value('Quercus ilex'),
          leafType: Value('Perenne'),
          barkDescription: Value('Escorça fosca clivellada'),
          typicalSoil: Value('Calcari o silici'),
          imageAssetPath: Value('assets/images/trees/quercus_ilex.png'),
        ),
        ArbresCompanion(
          id: Value('fagus_sylvatica'),
          catalanName: Value('Faig'),
          scientificName: Value('Fagus sylvatica'),
          leafType: Value('Caduca'),
          barkDescription: Value('Escorça llisa gris'),
          typicalSoil: Value('Silici o àcid'),
          imageAssetPath: Value('assets/images/trees/fagus_sylvatica.png'),
        ),
        ArbresCompanion(
          id: Value('castanea_sativa'),
          catalanName: Value('Castanyer'),
          scientificName: Value('Castanea sativa'),
          leafType: Value('Caduca'),
          barkDescription: Value('Escorça amb solcs espirals'),
          typicalSoil: Value('Silici, àcid'),
          imageAssetPath: Value('assets/images/trees/castanea_sativa.png'),
        ),
      ];

  static List<BoletArbreAssociationsCompanion> get associations => const [
        // lactarius_deliciosus -> pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_deliciosus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_deliciosus'),
            arbreId: Value('pinus_halepensis')),
        // lactarius_sanguifluus -> pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_sanguifluus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_sanguifluus'),
            arbreId: Value('pinus_halepensis')),
        // chroogomphus_rutilus -> pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('chroogomphus_rutilus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('chroogomphus_rutilus'),
            arbreId: Value('pinus_halepensis')),
        // boletus_edulis -> fagus_sylvatica, castanea_sativa, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_edulis'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_edulis'),
            arbreId: Value('castanea_sativa')),
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_edulis'), arbreId: Value('quercus_ilex')),
        // cantharellus_cibarius -> fagus_sylvatica, quercus_ilex, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('cantharellus_cibarius'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('cantharellus_cibarius'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('cantharellus_cibarius'),
            arbreId: Value('castanea_sativa')),
        // amanita_caesarea -> quercus_ilex, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_caesarea'), arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_caesarea'),
            arbreId: Value('castanea_sativa')),
        // craterellus_cornucopioides -> fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_cornucopioides'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_cornucopioides'),
            arbreId: Value('quercus_ilex')),
        // tricholoma_terreum -> pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_terreum'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_terreum'),
            arbreId: Value('pinus_halepensis')),
        // calocybe_gambosa -> quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('calocybe_gambosa'), arbreId: Value('quercus_ilex')),
        // pleurotus_ostreatus -> fagus_sylvatica (saprobic on dead wood)
        BoletArbreAssociationsCompanion(
            boletId: Value('pleurotus_ostreatus'),
            arbreId: Value('fagus_sylvatica')),
        // hydnum_repandum -> fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('hydnum_repandum'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hydnum_repandum'), arbreId: Value('quercus_ilex')),
        // hygrophorus_latitabundus -> pinus_halepensis, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_latitabundus'),
            arbreId: Value('pinus_halepensis')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_latitabundus'),
            arbreId: Value('pinus_sylvestris')),
        // craterellus_lutescens -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_lutescens'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_lutescens'),
            arbreId: Value('fagus_sylvatica')),
        // suillus_luteus -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('suillus_luteus'),
            arbreId: Value('pinus_sylvestris')),
        // russula_cyanoxantha -> fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_cyanoxantha'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_cyanoxantha'),
            arbreId: Value('quercus_ilex')),
        // amanita_muscaria -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_muscaria'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_muscaria'),
            arbreId: Value('fagus_sylvatica')),
        // omphalotus_olearius -> quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('omphalotus_olearius'),
            arbreId: Value('quercus_ilex')),
        // entoloma_sinuatum -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('entoloma_sinuatum'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('entoloma_sinuatum'),
            arbreId: Value('fagus_sylvatica')),
        // amanita_phalloides -> quercus_ilex, fagus_sylvatica, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_phalloides'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_phalloides'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_phalloides'),
            arbreId: Value('castanea_sativa')),
        // amanita_verna -> quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_verna'), arbreId: Value('quercus_ilex')),
        // cortinarius_orellanus -> fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('cortinarius_orellanus'),
            arbreId: Value('fagus_sylvatica')),
        // lactarius_chrysorrheus -> quercus_ilex, pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_chrysorrheus'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_chrysorrheus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_chrysorrheus'),
            arbreId: Value('pinus_halepensis')),
        // rubroboletus_satanas -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('rubroboletus_satanas'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('rubroboletus_satanas'),
            arbreId: Value('fagus_sylvatica')),
        // russula_virescens -> quercus_ilex, fagus_sylvatica, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_virescens'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_virescens'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_virescens'),
            arbreId: Value('castanea_sativa')),
        // hygrophorus_eburneus -> fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_eburneus'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_eburneus'),
            arbreId: Value('quercus_ilex')),
        // tricholoma_pardinum -> fagus_sylvatica, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_pardinum'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_pardinum'),
            arbreId: Value('pinus_sylvestris')),
        // lepista_nuda -> pinus_sylvestris, fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('lepista_nuda'), arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lepista_nuda'), arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('lepista_nuda'), arbreId: Value('quercus_ilex')),
        // morchella_esculenta -> fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('morchella_esculenta'),
            arbreId: Value('fagus_sylvatica')),
        // agaricus_campestris -> pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('agaricus_campestris'),
            arbreId: Value('pinus_halepensis')),
        // agaricus_xanthodermus -> pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('agaricus_xanthodermus'),
            arbreId: Value('pinus_halepensis')),
        // psathyrella_candolleana -> pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('psathyrella_candolleana'),
            arbreId: Value('pinus_halepensis')),
        // suillus_granulatus -> pinus_halepensis, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('suillus_granulatus'),
            arbreId: Value('pinus_halepensis')),
        BoletArbreAssociationsCompanion(
            boletId: Value('suillus_granulatus'),
            arbreId: Value('pinus_sylvestris')),
        // hygrophorus_russula -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_russula'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_russula'),
            arbreId: Value('fagus_sylvatica')),
        // boletus_aereus -> quercus_ilex, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_aereus'), arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_aereus'),
            arbreId: Value('castanea_sativa')),
        // lactarius_torminosus -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_torminosus'),
            arbreId: Value('pinus_sylvestris')),
        // amanita_pantherina -> pinus_halepensis, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_pantherina'),
            arbreId: Value('pinus_halepensis')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_pantherina'),
            arbreId: Value('quercus_ilex')),
        // gyromitra_esculenta -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('gyromitra_esculenta'),
            arbreId: Value('pinus_sylvestris')),
        // hygrophorus_personii -> quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_personii'),
            arbreId: Value('quercus_ilex')),
        // lactarius_semisanguifluus -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_semisanguifluus'),
            arbreId: Value('pinus_sylvestris')),
        // suillus_bellinii -> pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('suillus_bellinii'),
            arbreId: Value('pinus_halepensis')),
        // tricholoma_equestre -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_equestre'),
            arbreId: Value('pinus_sylvestris')),
        // amanita_virosa -> fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_virosa'),
            arbreId: Value('fagus_sylvatica')),
        // galerina_marginata -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('galerina_marginata'),
            arbreId: Value('pinus_sylvestris')),
        // tuber_melanosporum -> quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('tuber_melanosporum'),
            arbreId: Value('quercus_ilex')),
        // infundibulicybe_geotropa -> quercus_ilex, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('infundibulicybe_geotropa'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('infundibulicybe_geotropa'),
            arbreId: Value('pinus_sylvestris')),
        // boletus_pinophilus -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_pinophilus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_pinophilus'),
            arbreId: Value('fagus_sylvatica')),
        // neoboletus_luridiformis -> fagus_sylvatica, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('neoboletus_luridiformis'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('neoboletus_luridiformis'),
            arbreId: Value('pinus_sylvestris')),
        // boletus_reticulatus -> quercus_ilex, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_reticulatus'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('boletus_reticulatus'),
            arbreId: Value('castanea_sativa')),
        // hygrophorus_marzuolus -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_marzuolus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hygrophorus_marzuolus'),
            arbreId: Value('fagus_sylvatica')),
        // russula_aurea -> castanea_sativa, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_aurea'), arbreId: Value('castanea_sativa')),
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_aurea'), arbreId: Value('quercus_ilex')),
        // craterellus_tubaeformis -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_tubaeformis'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('craterellus_tubaeformis'),
            arbreId: Value('fagus_sylvatica')),
        // agaricus_arvensis -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('agaricus_arvensis'),
            arbreId: Value('pinus_sylvestris')),
        // hydnum_rufescens -> pinus_sylvestris, pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('hydnum_rufescens'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hydnum_rufescens'),
            arbreId: Value('pinus_halepensis')),
        // scleroderma_citrinum -> quercus_ilex, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('scleroderma_citrinum'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('scleroderma_citrinum'),
            arbreId: Value('pinus_sylvestris')),
        // clitocybe_nebularis -> fagus_sylvatica, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('clitocybe_nebularis'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('clitocybe_nebularis'),
            arbreId: Value('pinus_sylvestris')),
        // tylopilus_felleus -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('tylopilus_felleus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tylopilus_felleus'),
            arbreId: Value('fagus_sylvatica')),
        // suillellus_luridus -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('suillellus_luridus'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('suillellus_luridus'),
            arbreId: Value('fagus_sylvatica')),
        // russula_emetica -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('russula_emetica'),
            arbreId: Value('pinus_sylvestris')),
        // cyclocybe_aegerita -> castanea_sativa, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('cyclocybe_aegerita'),
            arbreId: Value('castanea_sativa')),
        BoletArbreAssociationsCompanion(
            boletId: Value('cyclocybe_aegerita'),
            arbreId: Value('fagus_sylvatica')),
        // tricholoma_portentosum -> pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_portentosum'),
            arbreId: Value('pinus_sylvestris')),
        // tuber_aestivum -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('tuber_aestivum'), arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tuber_aestivum'),
            arbreId: Value('fagus_sylvatica')),
        // amanita_rubescens -> castanea_sativa, quercus_ilex, fagus_sylvatica, pinus_sylvestris
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_rubescens'),
            arbreId: Value('castanea_sativa')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_rubescens'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_rubescens'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_rubescens'),
            arbreId: Value('pinus_sylvestris')),
        // imleria_badia -> pinus_sylvestris, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('imleria_badia'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('imleria_badia'), arbreId: Value('castanea_sativa')),
        // lactarius_vinosus -> pinus_halepensis
        BoletArbreAssociationsCompanion(
            boletId: Value('lactarius_vinosus'),
            arbreId: Value('pinus_halepensis')),
        // cantharellus_subpruinosus -> quercus_ilex, castanea_sativa
        BoletArbreAssociationsCompanion(
            boletId: Value('cantharellus_subpruinosus'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('cantharellus_subpruinosus'),
            arbreId: Value('castanea_sativa')),
        // leccinum_aurantiacum -> quercus_ilex, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('leccinum_aurantiacum'),
            arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('leccinum_aurantiacum'),
            arbreId: Value('fagus_sylvatica')),
        // hypholoma_fasciculare -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('hypholoma_fasciculare'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('hypholoma_fasciculare'),
            arbreId: Value('fagus_sylvatica')),
        // paxillus_involutus -> pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('paxillus_involutus'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('paxillus_involutus'),
            arbreId: Value('fagus_sylvatica')),
        // amanita_citrina -> quercus_ilex, pinus_sylvestris, fagus_sylvatica
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_citrina'), arbreId: Value('quercus_ilex')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_citrina'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('amanita_citrina'),
            arbreId: Value('fagus_sylvatica')),
        // tricholoma_saponaceum -> fagus_sylvatica, pinus_sylvestris, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_saponaceum'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_saponaceum'),
            arbreId: Value('pinus_sylvestris')),
        BoletArbreAssociationsCompanion(
            boletId: Value('tricholoma_saponaceum'),
            arbreId: Value('quercus_ilex')),
        // inocybe_erubescens -> fagus_sylvatica, quercus_ilex
        BoletArbreAssociationsCompanion(
            boletId: Value('inocybe_erubescens'),
            arbreId: Value('fagus_sylvatica')),
        BoletArbreAssociationsCompanion(
            boletId: Value('inocybe_erubescens'),
            arbreId: Value('quercus_ilex')),
      ];

  static List<ToxicLookalikesCompanion> get toxicLookalikes => const [
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_deliciosus'),
          lookalikeBoletId: Value('amanita_muscaria'),
          comparisonNotes: Value(
              'Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('cantharellus_cibarius'),
          lookalikeBoletId: Value('omphalotus_olearius'),
          comparisonNotes: Value(
              'La Gírgola d\'olivera creix en fusta i té làmines veritables (no plecs), a més brilla en la foscor (bioluminescència).'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_caesarea'),
          lookalikeBoletId: Value('amanita_muscaria'),
          comparisonNotes: Value(
              'L\'Ou de reig té làmines i peu grocs (mai blancs), i el barret és llis sense esquames blanques.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('macrolepiota_procera'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'L\'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva a la base del peu.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('pleurotus_ostreatus'),
          lookalikeBoletId: Value('omphalotus_olearius'),
          comparisonNotes: Value(
              'La Gírgola d\'olivera creix sobre fusta d\'olivera i té un color taronja intens, no gris-blavós com la Gírgola comestible.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('calocybe_gambosa'),
          lookalikeBoletId: Value('entoloma_sinuatum'),
          comparisonNotes: Value(
              'El Pèrfid té esporada rosa i olor de farina rància, mentre que el Moixernó té esporada blanca i olor agradable de farina fresca. L\'Entoloma té làmines escotades (pèrfid) i és tòxic.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('chroogomphus_rutilus'),
          lookalikeBoletId: Value('cortinarius_orellanus'),
          comparisonNotes: Value(
              'La Cama de perdiu té làmines molt decurrents i carn que es torna violàcia/negrosa al foc, sense cortina; el Cortinari mortal té làmines adnates/escotades de color rovell i cortina filamentosa.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_deliciosus'),
          lookalikeBoletId: Value('lactarius_chrysorrheus'),
          comparisonNotes: Value(
              'El Fals rovelló o Lleterola té làtex blanc que es torna groc sofre intens en segons i és molt picant, mentre que el Rovelló té làtex ataronjat immutable.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('boletus_edulis'),
          lookalikeBoletId: Value('rubroboletus_satanas'),
          comparisonNotes: Value(
              'El Mataparent de Satanàs té barret blanquinós o gris perla, porus vermell sang i blaveja al tall, mentre que el Cep té barret marró fosc, porus blancs o groguencs i no blaveja mai.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tricholoma_terreum'),
          lookalikeBoletId: Value('tricholoma_pardinum'),
          comparisonNotes: Value(
              'El Fredolic bord és molt més robust i gros, amb esquames concèntriques amples com teules i peu sòlid, mentre que el Fredolic és menut, fràgil i té peu buit.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('russula_virescens'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'La Palometa té carn trencadissa com el guix, barret verd clivellat en mosaic i mai té anell ni volva; la Farinera borda és mortal i té sempre anell, volva i carn fibrosa.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_campestris'),
          lookalikeBoletId: Value('agaricus_xanthodermus'),
          comparisonNotes: Value(
              'El Xampinyó groguenc grogueja intensament a la base del peu en tallar-lo o rascar-lo i fa una forta olor desagradable de tinta o fenol; el Xampinyó silvestre mai grogueja a la base i fa bona olor d\'anís o ametlla.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('morchella_esculenta'),
          lookalikeBoletId: Value('gyromitra_esculenta'),
          comparisonNotes: Value(
              'La Múrgola té cel·les o alvèols regulars com una bresca d\'abelles, mentre que el Bolet de greix té plecs cerebriformes ondulats com un cervell i és mortal.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_deliciosus'),
          lookalikeBoletId: Value('lactarius_torminosus'),
          comparisonNotes: Value(
              'La Cabra o Rovelló bord té el marge del barret molt llanós i pelut (barbat) i exsuda làtex blanc molt coent; el Rovelló té el marge llis i làtex sempre ataronjat.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('macrolepiota_procera'),
          lookalikeBoletId: Value('amanita_pantherina'),
          comparisonNotes: Value(
              'L\'Apagallums té un anell doble mòbil que llisca pel peu i mai té volva; la Pantera és molt tòxica, té un anell fix i una volva dissociada en anells concèntrics a la base del peu.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_sanguifluus'),
          lookalikeBoletId: Value('lactarius_chrysorrheus'),
          comparisonNotes: Value(
              'El Fals rovelló o Lleterola té làtex blanc que en pocs segons vira a groc sofre intens i és molt picant; el Rovelló d\'obaga (de sang) té làtex vinós o vermell fosc i mai exsuda llet blanca o groga.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_sanguifluus'),
          lookalikeBoletId: Value('lactarius_torminosus'),
          comparisonNotes: Value(
              'La Cabra o Rovelló bord té el marge del barret densament llanós i pelut (barbat) i exsuda làtex blanc molt coent; el Rovelló d\'obaga (de sang) té el marge llis i làtex de color sang vinós.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_campestris'),
          lookalikeBoletId: Value('amanita_verna'),
          comparisonNotes: Value(
              'La mortal Cicuta blanca té làmines sempre d\'un blanc immaculat i una volva membranosa en sac a la base; el Xampinyó silvestre té làmines rosades de jove que enfosqueixen a xocolata i mai té volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('boletus_aereus'),
          lookalikeBoletId: Value('rubroboletus_satanas'),
          comparisonNotes: Value(
              'El Mataparent de Satanàs té barret blanquinós o grisenc, porus vermells i blaveja ràpidament al tall; el Cep negre té barret bronze o xocolata fosc, porus blancs o groguencs i carn immutable que no blaveja mai.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('hygrophorus_eburneus'),
          lookalikeBoletId: Value('amanita_verna'),
          comparisonNotes: Value(
              'La mortal Cicuta blanca té làmines lliures, anell penjant al peu i volva prominent en sac a la base; la Llenega blanca té làmines ceroses decurrents, barret molt viscós i mai té anell ni volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('russula_cyanoxantha'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'La mortal Farinera borda té anell al peu, volva membranosa en sac a la base i làmines fràgils; la Llora verda o Cuaverda mai té anell ni volva i les seves làmines són flexibles i lardàcies (no es trenquen en passar-hi el dit).'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('calocybe_gambosa'),
          lookalikeBoletId: Value('amanita_virosa'),
          comparisonNotes: Value(
              'La mortal Farinera pudent té anell penjant al peu, volva en sac a la base i làmines lliures blanques; el Moixernó té làmines juntes sense anell ni volva i agradable olor de farina.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_campestris'),
          lookalikeBoletId: Value('amanita_virosa'),
          comparisonNotes: Value(
              'La mortal Farinera pudent té làmines blanques pures i volva en sac; el Xampinyó silvestre té làmines rosades a marró xocolata i mai té volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('hygrophorus_eburneus'),
          lookalikeBoletId: Value('amanita_virosa'),
          comparisonNotes: Value(
              'La mortal Farinera pudent té anell i volva prominent en sac a la base; la Llenega blanca té làmines ceroses decurrents, barret viscós i mai té anell ni volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('pleurotus_ostreatus'),
          lookalikeBoletId: Value('galerina_marginata'),
          comparisonNotes: Value(
              'La mortal Galerina vironosa és petita, ocre-marró, té anell membranós i espores marró rovell; la Gírgola és molt més gran, gris-blavosa, sense anell i amb esporada blanca.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_semisanguifluus'),
          lookalikeBoletId: Value('lactarius_chrysorrheus'),
          comparisonNotes: Value(
              'El Pinetell de sang té làtex taronja que ràpidament es torna vi negre/porpra i s\'oxida a verd; el Fals rovelló tòxic té làtex blanc que vira a groc sofre.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_semisanguifluus'),
          lookalikeBoletId: Value('lactarius_torminosus'),
          comparisonNotes: Value(
              'La Cabra té marge barbós molt pelut i làtex blanc acre immutable; el Pinetell de sang té marge llis i làtex vinós.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('hygrophorus_personii'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'La mortal Farinera borda té làmines lliures, anell i volva membranosa en sac; la Llenega d\'alzina té làmines gruixudes ceroses i beina viscosa tigrada sense volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('russula_cyanoxantha'),
          lookalikeBoletId: Value('tricholoma_equestre'),
          comparisonNotes: Value(
              'El Groguet té làmines groc sofre i carn fibrosa; la Llora verda té làmines blanques lardàcies i carn trencadissa com guix.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tuber_melanosporum'),
          lookalikeBoletId: Value('scleroderma_citrinum'),
          comparisonNotes: Value(
              'La Tòfona negra és subterrània i aromàtica amb gleba negrosa marbrada per venes blanques; el Patac d\'ase té pell dura berrugosa groga i gleba negra homogènia sense vetes blanques.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('infundibulicybe_geotropa'),
          lookalikeBoletId: Value('clitocybe_nebularis'),
          comparisonNotes: Value(
              'La Pampa és de color beix ocre amb un mamelló central prominent (umbó); la Pampa de boira té un barret pla o deprimit gris cendra sense mamelló i és tòxica/indigesta.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('boletus_edulis'),
          lookalikeBoletId: Value('tylopilus_felleus'),
          comparisonNotes: Value(
              'El Mataparent amarg té porus rosats a la maduresa i un reticle marró fosc prominent al peu; a més té un sabor extremadament amarg que arruïna qualsevol guisat.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('boletus_pinophilus'),
          lookalikeBoletId: Value('tylopilus_felleus'),
          comparisonNotes: Value(
              'El Mataparent amarg té porus rosats de madur i reticle fosc marcat al peu, a diferència dels porus groguencs-oliva del Cep vermell, i és immensament amarg.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('neoboletus_luridiformis'),
          lookalikeBoletId: Value('suillellus_luridus'),
          comparisonNotes: Value(
              'El Mataparent de peu vermell té peu puntejat de grans vermells sense reticle; el Mataparent de bou (tòxic en cru i amb alcohol) té una xarxa vermella molt marcada sobre fons groc.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('russula_aurea'),
          lookalikeBoletId: Value('russula_emetica'),
          comparisonNotes: Value(
              'La Llora daurada té làmines i peu d\'un groc daurat lluminós i carn dolça; la Rússula emètica té làmines i peu d\'un blanc immaculat i és extremadament picant i tòxica.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_arvensis'),
          lookalikeBoletId: Value('agaricus_xanthodermus'),
          comparisonNotes: Value(
              'La Bola de neu fa olor suau d\'anís i té anell en roda dentada; el Xampinyó groguenc grogueja a l\'instant a la base del peu i fa una forta olor de tinta o fenol.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_arvensis'),
          lookalikeBoletId: Value('amanita_verna'),
          comparisonNotes: Value(
              'La mortal Cicuta blanca té làmines sempre d\'un blanc pur i volva membranosa en sac; la Bola de neu té làmines que passen de gris-rosat a xocolata i no té mai volva.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('clitocybe_nebularis'),
          lookalikeBoletId: Value('entoloma_sinuatum'),
          comparisonNotes: Value(
              'El molt tòxic Pèrfid té làmines groguenques a rosades escotades i olor de farina rància; la Pampa de boira té làmines blanquinoses decurrents i forta olor de fenc/boira.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_arvensis'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'En fase de botó, la mortal Farinera borda es pot confondre amb el jove xampinyó, però l\'Amanita té volva membranosa en sac a la base i làmines sempre blanques pures.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('agaricus_arvensis'),
          lookalikeBoletId: Value('amanita_virosa'),
          comparisonNotes: Value(
              'La mortal Farinera pudent és completament blanca, té peu llanós-esquamós, anell penjant i volva en sac; la Bola de neu mai té volva i les làmines enfosqueixen a xocolata.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('boletus_reticulatus'),
          lookalikeBoletId: Value('tylopilus_felleus'),
          comparisonNotes: Value(
              'El Mataparent amarg té porus rosats de madur i un reticle marró fosc amb malles amples al peu; a diferència del reticle blanc fi del Cep d\'estiu, és insuportablement amarg.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('neoboletus_luridiformis'),
          lookalikeBoletId: Value('rubroboletus_satanas'),
          comparisonNotes: Value(
              'El molt tòxic Mataparent de Satanàs té barret blanquinós-grisenc i reticle vermell al peu; el Mataparent de peu vermell té barret marró xocolata vellutat i peu pigallat de puntets sense xarxa.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('cyclocybe_aegerita'),
          lookalikeBoletId: Value('hypholoma_fasciculare'),
          comparisonNotes: Value(
              'El tòxic Bolet de pi amarg té làmines groc-verdoses i carn intensament amarga; el Pollancró té làmines blanquinoses a canyella, olor agradable d\'avellana i anell membranós persistent.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('cyclocybe_aegerita'),
          lookalikeBoletId: Value('galerina_marginata'),
          comparisonNotes: Value(
              'La mortal Galerina marginata creix sobre fusta de coníferes i és més petita; el Pollancró creix en feixos densos sobre fusta de ribera (pollancres, salzes) amb barrets carnosos.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tricholoma_portentosum'),
          lookalikeBoletId: Value('tricholoma_pardinum'),
          comparisonNotes: Value(
              'El molt tòxic Fredolic bord té el barret cobert d\'esquames concèntriques grosses i carn sense reflexos grocs; el Fredolic d\'anís té barret llis fibril·lós amb reflexos groc llimona a les làmines.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tricholoma_portentosum'),
          lookalikeBoletId: Value('tricholoma_saponaceum'),
          comparisonNotes: Value(
              'El tòxic Bolet de sabó fa una forta olor de detergent de rentar la roba i té la base del peu tenyida de rosa; el Fredolic d\'anís fa una suau olor de farina i anís.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_rubescens'),
          lookalikeBoletId: Value('amanita_pantherina'),
          comparisonNotes: Value(
              'La molt tòxica Pantera té la carn sempre blanca immutable, anell llis no estriat i volva circuncisa en anells esglaonats; la Vinosa té carn que s\'enrogeix clarament a les ferides i anell estriat.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_rubescens'),
          lookalikeBoletId: Value('amanita_citrina'),
          comparisonNotes: Value(
              'La Farinera groga fa forta olor de patata crua i té un bulb marginat molt abrupte sense enrogiment; la Vinosa no té bulb marginat i s\'enrogeix ràpidament amb l\'edat.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tuber_aestivum'),
          lookalikeBoletId: Value('scleroderma_citrinum'),
          comparisonNotes: Value(
              'El tòxic Patac d\'ase té pell groguenca amb berrugues fosques i interior negre massís sense venes; la Tòfona d\'estiu té peridi negre amb berrugues piramidals i interior avellana vetejat de blanc.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('cantharellus_subpruinosus'),
          lookalikeBoletId: Value('omphalotus_olearius'),
          comparisonNotes: Value(
              'La molt tòxica Gírgola d\'olivera creix en troncs i té làmines veritables fines i atapeïdes; el Rossinyol blanc creix a terra sota roures i té plecs venosos gruixuts amb barret pruïnós.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('calocybe_gambosa'),
          lookalikeBoletId: Value('inocybe_erubescens'),
          comparisonNotes: Value(
              'El mortal Inòcibe de Patouillard té barret cònic amb umbó agut i s\'enrogeix intensament (vermell maó) en fregar-lo; el Moixernó té barret convex massís que mai enrogeix i forta olor de farina.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('marasmius_oreades'),
          lookalikeBoletId: Value('inocybe_erubescens'),
          comparisonNotes: Value(
              'El mortal Inòcibe de Patouillard és més robust, té làmines marronoses i s\'enrogeix amb taques vermelloses vives; la Carrereta mai enrogeix i té peu molt elàstic i tenaç que es pot cargolar.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_deliciosus'),
          lookalikeBoletId: Value('paxillus_involutus'),
          comparisonNotes: Value(
              'El mortal Paxil·le té marge fortament enrotllat, làmines que s\'oxiden a marró fosc i mai desprèn làtex taronja; el Rovelló raja sempre làtex taronja viu i té carn massissa immutable a taronja.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('imleria_badia'),
          lookalikeBoletId: Value('tylopilus_felleus'),
          comparisonNotes: Value(
              'El Mataparent amarg té porus de color rosa brut en madurar i un reticle marró fosc molt evident al peu; el Bolet de baia té porus grocs que blavegen i peu fibrós sense reticle.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('tricholoma_terreum'),
          lookalikeBoletId: Value('tricholoma_saponaceum'),
          comparisonNotes: Value(
              'El tòxic Bolet de sabó fa una forta olor de detergent de rentar la roba o sabó i té la base del peu tenyida de rosa; el Fredolic fa olor suau fúngica i no té mai tons rosats al peu.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_citrina'),
          lookalikeBoletId: Value('amanita_phalloides'),
          comparisonNotes: Value(
              'La Farinera groga té un bulb marginat molt abrupte i fa forta olor de patata crua; la mortal Farinera borda té volva membranosa en sac lliure, barret verd oliva fibril·lós i olor agradable de mel de jove.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_caesarea'),
          lookalikeBoletId: Value('amanita_citrina'),
          comparisonNotes: Value(
              'L\'Ou de reig té barret taronja viu, làmines i peu groc daurat lluminós; la Farinera groga té barret groc llimona pàl·lid amb plaques fosques, làmines blanques i forta olor de patata crua.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_vinosus'),
          lookalikeBoletId: Value('lactarius_chrysorrheus'),
          comparisonNotes: Value(
              'El Fals rovelló o Lleterola té làtex blanc que en pocs segons vira a groc sofre intens i és molt picant; el Rovelló de sang vinosa té làtex fosc color vi negre o remolatxa de gust dolç.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_vinosus'),
          lookalikeBoletId: Value('lactarius_torminosus'),
          comparisonNotes: Value(
              'La Cabra o Rovelló bord té el marge del barret densament barbós i pelut i exsuda làtex blanc acre; el Rovelló de sang vinosa té marge llis no barbat i làtex fosc vi negre.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lactarius_vinosus'),
          lookalikeBoletId: Value('paxillus_involutus'),
          comparisonNotes: Value(
              'El mortal Paxil·le té marge fortament enrotllat, làmines que s\'oxiden a bru en fregar-les i no té làtex; el Rovelló de sang vinosa raja làtex color vi negre fosc o remolatxa.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('lepista_nuda'),
          lookalikeBoletId: Value('cortinarius_orellanus'),
          comparisonNotes: Value(
              'El Peu blau té làmines i peu violacis, esporada blanquinosa-rosada i mai té cortina; els Cortinaris mortals tenen cortina com teranyina i esporada marró rovell.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('pleurotus_eryngii'),
          lookalikeBoletId: Value('omphalotus_olearius'),
          comparisonNotes: Value(
              'La Gírgola de panical creix a terra d\'erms i pastures sobre arrels de panical amb làmines blanquinoses; la tòxica Gírgola d\'olivera és taronja viu i creix en feixos sobre soques de fusta.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_citrina'),
          lookalikeBoletId: Value('amanita_verna'),
          comparisonNotes: Value(
              'Les formes blanques de la Farinera groga tenen bulb marginat abrupte i forta olor de patata crua; la mortal Cicuta blanca té volva en sac membranós lliure i no fa olor de patata.'),
        ),
      ];

  static List<InsigniesCompanion> get insignies => const [
        InsigniesCompanion(id: Value('primer_pas_al_bosc')),
        InsigniesCompanion(id: Value('cacador_de_rovellons')),
        InsigniesCompanion(id: Value('micoleg_prudent')),
        InsigniesCompanion(id: Value('alianca_silvestre')),
        InsigniesCompanion(id: Value('cistell_de_tardor')),
        InsigniesCompanion(id: Value('mestre_boletaire')),
        InsigniesCompanion(id: Value('senyor_dels_ceps')),
        InsigniesCompanion(id: Value('gourmet_del_bosc')),
        InsigniesCompanion(id: Value('amic_dels_arbres')),
        InsigniesCompanion(id: Value('esperit_de_primavera')),
        InsigniesCompanion(id: Value('sentinella_toxic')),
        InsigniesCompanion(id: Value('quadern_de_camp')),
        InsigniesCompanion(id: Value('cartograf_del_bosc')),
        InsigniesCompanion(id: Value('gran_enciclopedia')),
        InsigniesCompanion(id: Value('joies_de_la_cuina')),
        InsigniesCompanion(id: Value('mestre_tofoner')),
        InsigniesCompanion(id: Value('cuina_sense_ensurts')),
      ];
}
