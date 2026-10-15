# Safety First & Toxic Lookalikes

Foraging wild mushrooms carries inherent risks of lethal poisoning (such as mycetism caused by amatoxins in *Amanita phalloides*). Boscdex enforces **rigorous safety-first UX gates** across all identification flows.

---

## 🛑 Mandatory First-Launch Disclaimer Gate

Before any core feature is unlocked, users must pass through the `DisclaimerScreen`:
* Clear educational advisory explaining that computer vision AI can make mistakes and can never substitute an experienced human mycologist.
* Active checkbox acknowledgement: *"He llegit i accepto les condicions d'avisos de seguretat"*.
* Persisted in `SharedPreferences`. Returning users bypass the screen directly to `/boscdex`.

---

## ⚡ The Safety Gate Algorithm (`SafetyGateService`)

Whenever the classifier generates results, `SafetyGateService` evaluates multi-layered hazard conditions:

### 1. The Zero-Tolerance Lethal Gate (Threshold $\ge 10\%$) ☠️
* Catalogs the 6 lethal Catalan taxa containing amatoxins, gyromitrin, or orellanine:
  * *Amanita phalloides* (Farinera borda)
  * *Amanita verna* (Farinera vernal / Cicuta blanca)
  * *Amanita virosa* (Farinera pudent / Àngel de la mort)
  * *Cortinarius orellanus* (Cortinari de muntanya / Cortinari orellà)
  * *Galerina marginata* (Galerina mortal / Galerina vironosa)
  * *Gyromitra esculenta* (Bolet de greix / Falsa múrgola)
* If **ANY** candidate in the top-3 predictions is a lethal taxon with confidence $\ge 10\%$, the result is immediately escalated to **Danger (`NivellSeguretat.perill`)**, overriding any high edible confidence. Low-confidence lethal predictions can never be suppressed or hidden by gamification.

### 2. The Uncertainty Gate ($\text{Confidence} < 70\%$)
* When top prediction confidence is below $0.70$, the UI injects an alert banner:
  > **⚠️ No es pot identificar amb certesa.**  
  > La qualitat de la imatge o les característiques morfològiques no permeten una determinació segura. Consulta un micòleg humà abans de consumir.

### 3. The Dangerous Lookalike Gate (`ALERTA DE CONFUSIÓ PERILLOSA`)
* If the predicted species has any record in the `toxic_lookalikes` table, an unavoidable high-visibility warning card (`SafetyAlertBox`) is presented:
  > **⚠️ ALERTA DE CONFUSIÓ PERILLOSA**  
  > Aquesta espècie es pot confondre fàcilment amb: **[Nom de l'espècie tòxica / mortal]**.  
  > Fes clic aquí per comparar les diferències clau abans de consumir.
* Tapping the alert:
  * Increments the user's `toxicComparisonViewCount` (fueling the **Micòleg Prudent** and **Sentinella del Bosc** badges).
  * Directs the user to the side-by-side morphological breakdown detailing differences in latex, volva, gills, or stem reticulation.
* **Safety-First Card Exposure:** In [`BoletDetailScreen`](file:///Users/jordi/dev/boscdex/lib/presentation/detail/bolet_detail_screen.dart), toxic lookalike alerts (`ToxicTwinAlert`) are **always prominently visible** even if the target species has not yet been unlocked/discovered in the user's catalog. Field safety strictly takes precedence over gamification veil mechanics.
* **Bidirectional Safety Mapping:** [`BoletDao`](file:///Users/jordi/dev/boscdex/lib/data/database/daos/bolet_dao.dart) and [`SpeciesLocalizer`](file:///Users/jordi/dev/boscdex/lib/core/localization/species_localizer.dart) execute bidirectional lookups: querying either the edible mushroom OR the poisonous counterpart immediately surfaces the reciprocal lookalike warning.

### 4. Interactive Botanical Verification Checklist (`BotanicalSafetyCheckDialog`) 🛡️
* **Unified Registration Gate:** Before saving any sighting to the journal, if the scan is **NOT certified `NivellSeguretat.segur`** (e.g. low confidence $<70\%$, secondary toxic runner-up $\ge 15\%$), has documented toxic lookalikes, carries lethal risk, or is itself toxic/mortal, the interactive modal checklist is mandatory.
* Tailored diagnostic items exist for high-risk foraged groups:
  * *Lactarius deliciosus / sanguifluus / semisanguifluus*: orange/wine latex vs yellow staining, smooth margin vs bearded woolly margin.
  * *Agaricus campestris*: pink-to-brown gills, absence of saccate volva, no yellow-staining with ink odor.
  * *Calocybe gambosa*: crowded white gills, strong fresh flour aroma vs salmon-pink spores of *Entoloma*.
  * *Macrolepiota procera*: movable double ring, snakeskin stem pattern, cap $>10\text{ cm}$.
  * *Tricholoma terreum*: fragile hollow stem, fibrous non-shingled cap.
  * *Boletus edulis / aereus*: white/yellow pores, immutable non-bluing flesh upon cutting.
  * *Morchella esculenta*: continuous hollow single chamber, honeycomb pits vs *Gyromitra* brain folds.
  * *Cantharellus cibarius*: thick blunt bifurcated false ridges, terrestrial woodland soil growth vs *Omphalotus*.
  * *Lepista nuda*: absence of cobwebby cortina veil, pale pinkish spore print vs rusty *Cortinarius*.
  * *Marasmius oreades*: highly elastic twistable stem, distant gills in pasture fairy rings.
  * *Amanita caesarea*: golden-orange smooth cap, egg-yolk yellow gills/stem, large white eggshell saccate volva.
  * *Tricholoma equestre*: explicit caution regarding rhabdomyolysis toxicity risk.
  * *Toxic & Mortal Species Recognition*: explicit scientific/botanical study confirmation and acknowledgment that consumption is strictly prohibited.
* Users must physically inspect and confirm each diagnostic trait before registration is permitted. If the user selects "Tinc dubtes / Cancel·lar", registration is aborted and nothing is saved.

---

## ☠️ Key Confusion Pairs Cataloged in Catalonia (28 Pairs)

| Prized Edible | Dangerous / Toxic Lookalike | Key Diagnostic Difference |
|---|---|---|
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Reig bord** (*Amanita muscaria*) | Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja. |
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Fals rovelló** (*Lactarius chrysorrheus*) | El Fals rovelló té làtex blanc que vira a groc sofre en segons i és picant; el Rovelló té làtex taronja immutable. |
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Cabra / Rovelló bord** (*Lactarius torminosus*) | La Cabra té marge densament llanós i pelut (barbat) i làtex blanc coent; el Rovelló té marge llis i làtex taronja. |
| **Rovelló d'obaga (de sang)** (*Lactarius sanguifluus*) | **Fals rovelló** (*Lactarius chrysorrheus*) | El Fals rovelló té làtex blanc que vira a groc; el Rovelló de sang té làtex vinós/vermell fosc i mai blanc o groc. |
| **Rovelló d'obaga (de sang)** (*Lactarius sanguifluus*) | **Cabra / Rovelló bord** (*Lactarius torminosus*) | La Cabra té marge llanós/pelut i làtex blanc picant; el Rovelló de sang té marge llis i làtex sang fosc. |
| **Pinetell de sang** (*Lactarius semisanguifluus*) | **Fals rovelló** (*Lactarius chrysorrheus*) | El Pinetell de sang té làtex taronja que ràpidament es torna vi negre/porpra i s'oxida a verd; el Fals rovelló tòxic té làtex blanc que vira a groc sofre. |
| **Pinetell de sang** (*Lactarius semisanguifluus*) | **Cabra / Rovelló bord** (*Lactarius torminosus*) | La Cabra té marge barbós molt pelut i làtex blanc acre immutable; el Pinetell de sang té marge llis i làtex vinós. |
| **Cep** (*Boletus edulis*) | **Mataparent de Satanàs** (*Rubroboletus satanas*) | El Mataparent té barret blanquinós, porus vermell sang i blaveja al tall; el Cep té barret marró fosc, porus blancs/grocs i mai blaveja. |
| **Cep negre** (*Boletus aereus*) | **Mataparent de Satanàs** (*Rubroboletus satanas*) | El Mataparent de Satanàs té barret blanquinós/grisenc, porus vermells i blaveja al tall; el Cep negre té barret bronze/xocolata i carn immutable. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Xampinyó groguenc** (*Agaricus xanthodermus*) | El Xampinyó groguenc grogueja intensament a la base del peu i fa forta olor de tinta/fenol; el silvestre mai grogueja a la base. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Cicuta blanca** (*Amanita verna*) ☠️ | La mortal Cicuta blanca té làmines blanques i volva membranosa en sac; el Xampinyó té làmines rosades a xocolata i mai té volva. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Farinera pudent / Àngel de la mort** (*Amanita virosa*) ☠️ | La mortal Farinera pudent té làmines blanques pures i volva en sac; el Xampinyó silvestre té làmines rosades a marró xocolata i mai té volva. |
| **Llenega blanca** (*Hygrophorus eburneus*) | **Cicuta blanca** (*Amanita verna*) ☠️ | La Cicuta blanca té làmines lliures, anell i volva en sac; la Llenega blanca té làmines ceroses decurrents, barret viscós i sense anell ni volva. |
| **Llenega blanca** (*Hygrophorus eburneus*) | **Farinera pudent / Àngel de la mort** (*Amanita virosa*) ☠️ | La mortal Farinera pudent té anell i volva prominent en sac a la base; la Llenega blanca té làmines ceroses decurrents, barret viscós i mai té anell ni volva. |
| **Llenega d'alzina** (*Hygrophorus personii*) | **Farinera borda** (*Amanita phalloides*) ☠️ | La mortal Farinera borda té làmines lliures, anell i volva membranosa en sac; la Llenega d'alzina té làmines gruixudes ceroses i beina viscosa tigrada sense volva. |
| **Palometa** (*Russula virescens*) | **Farinera borda** (*Amanita phalloides*) ☠️ | La Palometa té carn trencadissa com guix, barret clivellat en mosaic i mai té anell ni volva; la Farinera borda té anell, volva i carn fibrosa. |
| **Llora verda / Cuaverda** (*Russula cyanoxantha*) | **Farinera borda** (*Amanita phalloides*) ☠️ | La Farinera borda té anell, volva i làmines fràgils; la Llora verda té làmines lardàcies flexibles (no es trenquen) i mai té anell ni volva. |
| **Llora verda / Cuaverda** (*Russula cyanoxantha*) | **Groguet** (*Tricholoma equestre*) | El Groguet té làmines groc sofre i carn fibrosa; la Llora verda té làmines blanques lardàcies i carn trencadissa com guix. |
| **Apagallums** (*Macrolepiota procera*) | **Farinera borda** (*Amanita phalloides*) ☠️ | L'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva en sac a la base del peu. |
| **Apagallums** (*Macrolepiota procera*) | **Pantera** (*Amanita pantherina*) | L'Apagallums té un anell doble mòbil que llisca pel peu; la Pantera té anell fix i volva dissociada en anells concèntrics al bulb. |
| **Rossinyol** (*Cantharellus cibarius*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix en fusta, té làmines veritables tallants (no plecs) i emet bioluminescència a la foscor. |
| **Gírgola** (*Pleurotus ostreatus*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix sobre fusta i té color taronja intens rovellat, no gris-blavós com la Gírgola comestible. |
| **Gírgola** (*Pleurotus ostreatus*) | **Galerina mortal / Galerina vironosa** (*Galerina marginata*) ☠️ | La mortal Galerina vironosa és petita, ocre-marró, té anell membranós i espores marró rovell; la Gírgola és molt més gran, gris-blavosa, sense anell i amb esporada blanca. |
| **Gírgola de panical** (*Pleurotus eryngii*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix en soques i té color taronja viu amb làmines fines molt decurrents; la Gírgola de panical creix en arrels de panical a terra i té peu molt gruixut blanc. |
| **Ou de reig** (*Amanita caesarea*) | **Reig bord** (*Amanita muscaria*) | L'Ou de reig té làmines i peu grocs daurats (mai blancs), i el barret és taronja llis sense esquames blanques. |
| **Moixernó** (*Calocybe gambosa*) | **Pèrfid** (*Entoloma sinuatum*) | El Pèrfid té esporada rosa i olor de farina rància; el Moixernó té esporada blanca i agradable olor de farina fresca. |
| **Moixernó** (*Calocybe gambosa*) | **Farinera pudent / Àngel de la mort** (*Amanita virosa*) ☠️ | La mortal Farinera pudent té anell penjant al peu, volva en sac a la base i làmines lliures blanques; el Moixernó té làmines juntes sense anell ni volva i agradable olor de farina. |
| **Cama de perdiu** (*Chroogomphus rutilus*) | **Cortinari de muntanya** (*Cortinarius orellanus*) ☠️ | La Cama de perdiu té làmines molt decurrents i carn que es torna violàcia/negrosa al foc, sense cortina; el Cortinari mortal té cortina i espores rovell. |
| **Fredolic** (*Tricholoma terreum*) | **Fredolic bord** (*Tricholoma pardinum*) | El Fredolic bord és molt més robust i gros, amb esquames concèntriques amples com teules i peu sòlid; el Fredolic és menut, fràgil i de peu buit. |
| **Múrgola** (*Morchella esculenta*) | **Bolet de greix / Falsa múrgola** (*Gyromitra esculenta*) ☠️ | La Múrgola té cel·les o alvèols regulars com una bresca d'abelles; el Bolet de greix té plecs cerebriformes ondulats com un cervell i és mortal. |
| **Molleric clapat** (*Suillus granulatus*) | **Pinet de pi bord** (*Suillus bellinii*) | El Molleric clapat té barret marró-vermellós fosc i porus que ploren gotes de llet; el Suillus bellinii té barret blanc d'ivori amb taques marrons i porus groc sofre. |
