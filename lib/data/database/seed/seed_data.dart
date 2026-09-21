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
              'Neix d\'un volva blanca tancada ("ou"). Obert fa 8-20 cm, llis, de color ataronjat intens o vermell ataronjat, sense restes de volva (sense esquames blanques). Marge estriat.'),
          gillsDescription:
              Value('Lliures, atapeïdes, de color clarament groc.'),
          stemDescription: Value(
              'Cilíndric, de color groc (no blanc), proveït d\'un anell ampli i membranós, penjat, també groc. A la base, hi té un sac blanc ampli (volva) i lliure.'),
          safetyNotes: Value(
              'Possible confusió mortal o perillosa amb Amanita muscaria, que té peu blanc (no groc), làmines blanques (no grogues), marge no estriat i normalment restes blanques sobre el barret.'),
          dexNumber: Value(4),
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
              'Molt gran, fins a 30 cm de diàmetre. Inicialment ovoidal (forma de baqueta de tambor), després s\'obre com un para-sol. De fons clar, cobert d\'esquames concèntriques fosques. Gran monyó central fosc (umbó).'),
          gillsDescription:
              Value('Blanques, amples, toves i lliures respecte del peu.'),
          stemDescription: Value(
              'Molt llarg (pot passar de 30 cm), fibril·lós i tigrat ("serpentí"), acabat en un bulb basal, però SENSE volva en sac. Porta un gran anell doble, gruixut i mòbil (lliscant) com una polsera.'),
          safetyNotes: Value(
              'No confondre amb lepiotes de mida petita (menys de 10 cm) moltes de les quals són mortals. La característica de l\'anell mòbil és fonamental.'),
          dexNumber: Value(6),
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
              'Llargament decurrents fins la base, bastant separades i toves. De color blanquinós a cremós.'),
          stemDescription: Value(
              'Molt curt, completament excèntric (lateral) o gairebé absent, soldat a la fusta on creix.'),
          safetyNotes: Value(
              'Es cria sobre troncs morts. Confusió (tot i ser força diferent) amb Omphalotus olearius, tòxica, que és molt ataronjada i de zones menys fredes.'),
          dexNumber: Value(9),
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
              'Té tubs i porus, que inicialment són coberts per un vel membranós (anell). Són petits i rodons, de color groc que enfosqueix i verda amb l\'edat.'),
          stemDescription: Value(
              'Cilíndric, curt, porta un vistós anell ample que primer és blanc i després vira al lila grisenc o marró violaci.'),
          safetyNotes: Value(
              'Tot i classificar-se com comestible pelant bé la cutícula, té molt poc valor culinari.'),
          dexNumber: Value(13),
        ),
        BoletsCompanion(
          id: Value('russula_cyanoxantha'),
          catalanName: Value('Llora verda'),
          scientificName: Value('Russula cyanoxantha'),
          family: Value('Russulaceae'),
          rarityTier: Value('comu'),
          edibility: Value('sense_valor'),
          fruitingSeason: Value('[6,7,8,9,10]'),
          altitudeMin: Value(200),
          altitudeMax: Value(1400),
          capDescription: Value(
              'Molt variable, en diferents tons clapejats de violeta, rosa-lila i sobretot verd lila, blavós (mai roig viu pur). Fins a 15 cm.'),
          gillsDescription: Value(
              'Blanques. La prova clau per a identificar-la és que la textura de les làmines no és trencadissa, sinó tova (com formatge llescat fi), quan s\'hi passa el dit NO es trenquen.'),
          stemDescription: Value(
              'Blanc, ferm, sense cap anell ni volva, recte i generalment cilíndric. Carn trencadissa.'),
          safetyNotes:
              Value('Es pot consumir, però no s\'aprecia gaire a la cuina.'),
          dexNumber: Value(14),
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
              'Molt robust (fins a 18 cm). Acoloreix blanc grogós o crema cendrós (color camussa), llis, lluent en temps sec.'),
          gillsDescription: Value(
              'Molt espesses i amples. Escotades del marge de la cama. Al principi groguenques, després (això és crucial) virar a color salmó-rosat per la maduració d\'espores rosa.'),
          stemDescription: Value(
              'Massís, blanc, recte però de vegades eixamplat a la base.'),
          safetyNotes: Value(
              'Provoca toxicitat greu intestinal crònica i nàusees agudes. Olor de farina rància, a diferència de la farina fresca del Moixernó (Calocybe gambosa), l\'esporada (la pols que allibera) és rosa, mentre el Moixernó l\'espora és blanca.'),
          dexNumber: Value(17),
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
              'MORTAL. La toxina orrelanina, extremadament perillosa per la seva acció molt retardada (dies o més de 2 setmanes sense símptomes greus per presentar llavors dany renal catastròfic generalment fatal).'),
          dexNumber: Value(20),
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
              'De 5 a 12 cm, convex i després deprimit, de color ocre ataronjat amb tons vinossos o porpres i taques verdes en envellir.'),
          gillsDescription: Value(
              'Atapeïdes, decurrents, de color ocre rosat o vinoso que es taquen de verd fosc.'),
          stemDescription: Value(
              'Curt, cilíndric, atenuat a la base, de color ocre vinós pàl·lid, sovint escrobiculat.'),
          latexDescription:
              Value('De color vermell vinós o sang fosc, de gust dolç o suau.'),
          safetyNotes: Value(
              'Comestible excel·lent, molt apreciat com el pinetell. Es distingeix pel seu làtex de color sang o vi fosc.'),
          dexNumber: Value(21),
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
        ),
        ArbresCompanion(
          id: Value('pinus_halepensis'),
          catalanName: Value('Pi blanc'),
          scientificName: Value('Pinus halepensis'),
          leafType: Value('Agulla'),
          barkDescription: Value('Escorça gris platejada'),
          typicalSoil: Value('Calcari'),
        ),
        ArbresCompanion(
          id: Value('quercus_ilex'),
          catalanName: Value('Alzina'),
          scientificName: Value('Quercus ilex'),
          leafType: Value('Perenne'),
          barkDescription: Value('Escorça fosca clivellada'),
          typicalSoil: Value('Calcari o silici'),
        ),
        ArbresCompanion(
          id: Value('fagus_sylvatica'),
          catalanName: Value('Faig'),
          scientificName: Value('Fagus sylvatica'),
          leafType: Value('Caduca'),
          barkDescription: Value('Escorça llisa gris'),
          typicalSoil: Value('Silici o àcid'),
        ),
        ArbresCompanion(
          id: Value('castanea_sativa'),
          catalanName: Value('Castanyer'),
          scientificName: Value('Castanea sativa'),
          leafType: Value('Caduca'),
          barkDescription: Value('Escorça amb solcs espirals'),
          typicalSoil: Value('Silici, àcid'),
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
        // Inverse relationships for better querying
        ToxicLookalikesCompanion(
          boletId: Value('amanita_muscaria'),
          lookalikeBoletId: Value('lactarius_deliciosus'),
          comparisonNotes: Value(
              'Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('omphalotus_olearius'),
          lookalikeBoletId: Value('cantharellus_cibarius'),
          comparisonNotes: Value(
              'La Gírgola d\'olivera creix en fusta i té làmines veritables (no plecs), a més brilla en la foscor (bioluminescència).'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_muscaria'),
          lookalikeBoletId: Value('amanita_caesarea'),
          comparisonNotes: Value(
              'L\'Ou de reig té làmines i peu grocs (mai blancs), i el barret és llis sense esquames blanques.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('amanita_phalloides'),
          lookalikeBoletId: Value('macrolepiota_procera'),
          comparisonNotes: Value(
              'L\'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva a la base del peu.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('omphalotus_olearius'),
          lookalikeBoletId: Value('pleurotus_ostreatus'),
          comparisonNotes: Value(
              'La Gírgola d\'olivera creix sobre fusta d\'olivera i té un color taronja intens, no gris-blavós com la Gírgola comestible.'),
        ),
        ToxicLookalikesCompanion(
          boletId: Value('entoloma_sinuatum'),
          lookalikeBoletId: Value('calocybe_gambosa'),
          comparisonNotes: Value(
              'El Pèrfid té esporada rosa i olor de farina rància, mentre que el Moixernó té esporada blanca i olor agradable de farina fresca. L\'Entoloma té làmines escotades (pèrfid) i és tòxic.'),
        ),
      ];

  static List<InsigniesCompanion> get insignies => const [
        InsigniesCompanion(id: Value('primer_pas_al_bosc')),
        InsigniesCompanion(id: Value('cacador_de_rovellons')),
        InsigniesCompanion(id: Value('micoleg_prudent')),
        InsigniesCompanion(id: Value('alianca_silvestre')),
        InsigniesCompanion(id: Value('cistell_de_tardor')),
        InsigniesCompanion(id: Value('mestre_boletaire')),
      ];
}
