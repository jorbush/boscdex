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

Whenever the classifier generates results, `SafetyGateService` evaluates two distinct hazard conditions:

### 1. The Uncertainty Gate ($\text{Confidence} < 70\%$)
* When top prediction confidence is below $0.70$, the UI injects an alert banner:
  > **⚠️ No es pot identificar amb certesa.**  
  > La qualitat de la imatge o les característiques morfològiques no permeten una determinació segura. Consulta un micòleg humà abans de consumir.

### 2. The Dangerous Lookalike Gate (`ALERTA DE CONFUSIÓ PERILLOSA`)
* If the predicted species has any record in the `toxic_lookalikes` table, an unavoidable high-visibility crimson warning card (`SafetyAlertBox`) is presented:
  > **⚠️ ALERTA DE CONFUSIÓ PERILLOSA**  
  > Aquesta espècie es pot confondre fàcilment amb: **[Nom de l'espècie tòxica / mortal]**.  
  > Fes clic aquí per comparar les diferències clau abans de consumir.
* Tapping the alert:
  * Increments the user's `toxicComparisonViewCount` (fueling the **Micòleg Prudent** and **Sentinella del Bosc** badges).
  * Directs the user to the side-by-side morphological breakdown detailing differences in latex, volva, gills, or stem reticulation.
* **Safety-First Card Exposure:** In [`BoletDetailScreen`](file:///Users/jordi/dev/boscdex/lib/presentation/detail/bolet_detail_screen.dart), toxic lookalike alerts (`ToxicTwinAlert`) are **always prominently visible** even if the target species has not yet been unlocked/discovered in the user's catalog. Field safety strictly takes precedence over gamification veil mechanics.
* **Bidirectional Safety Mapping:** [`BoletDao`](file:///Users/jordi/dev/boscdex/lib/data/database/daos/bolet_dao.dart) and [`SpeciesLocalizer`](file:///Users/jordi/dev/boscdex/lib/core/localization/species_localizer.dart) execute bidirectional lookups: querying either the edible mushroom OR the poisonous counterpart immediately surfaces the reciprocal lookalike warning.

---

## ☠️ Key Confusion Pairs Cataloged in Catalonia (21 Pairs)

| Prized Edible | Dangerous / Toxic Lookalike | Key Diagnostic Difference |
|---|---|---|
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Reig bord** (*Amanita muscaria*) | Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja. |
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Fals rovelló** (*Lactarius chrysorrheus*) | El Fals rovelló té làtex blanc que vira a groc sofre en segons i és picant; el Rovelló té làtex taronja immutable. |
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Cabra / Rovelló bord** (*Lactarius torminosus*) | La Cabra té marge densament llanós i pelut (barbat) i làtex blanc coent; el Rovelló té marge llis i làtex taronja. |
| **Rovelló d'obaga (de sang)** (*Lactarius sanguifluus*) | **Fals rovelló** (*Lactarius chrysorrheus*) | El Fals rovelló té làtex blanc que vira a groc; el Rovelló de sang té làtex vinós/vermell fosc i mai blanc o groc. |
| **Rovelló d'obaga (de sang)** (*Lactarius sanguifluus*) | **Cabra / Rovelló bord** (*Lactarius torminosus*) | La Cabra té marge llanós/pelut i làtex blanc picant; el Rovelló de sang té marge llis i làtex sang fosc. |
| **Cep** (*Boletus edulis*) | **Mataparent de Satanàs** (*Rubroboletus satanas*) | El Mataparent té barret blanquinós, porus vermell sang i blaveja al tall; el Cep té barret marró fosc, porus blancs/grocs i mai blaveja. |
| **Cep negre** (*Boletus aereus*) | **Mataparent de Satanàs** (*Rubroboletus satanas*) | El Mataparent de Satanàs té barret blanquinós/grisenc, porus vermells i blaveja al tall; el Cep negre té barret bronze/xocolata i carn immutable. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Xampinyó groguenc** (*Agaricus xanthodermus*) | El Xampinyó groguenc grogueja intensament a la base del peu i fa forta olor de tinta/fenol; el silvestre mai grogueja a la base. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Cicuta blanca** (*Amanita verna*) ☠️ | La mortal Cicuta blanca té làmines blanques i volva membranosa en sac; el Xampinyó té làmines rosades a xocolata i mai té volva. |
| **Llenega blanca** (*Hygrophorus eburneus*) | **Cicuta blanca** (*Amanita verna*) ☠️ | La Cicuta blanca té làmines lliures, anell i volva en sac; la Llenega blanca té làmines ceroses decurrents, barret viscós i sense anell ni volva. |
| **Palometa** (*Russula virescens*) | **Farinera borda** (*Amanita phalloides*) ☠️ | La Palometa té carn trencadissa com guix, barret clivellat en mosaic i mai té anell ni volva; la Farinera borda té anell, volva i carn fibrosa. |
| **Llora verda / Cuaverda** (*Russula cyanoxantha*) | **Farinera borda** (*Amanita phalloides*) ☠️ | La Farinera borda té anell, volva i làmines fràgils; la Llora verda té làmines lardàcies flexibles (no es trenquen) i mai té anell ni volva. |
| **Apagallums** (*Macrolepiota procera*) | **Farinera borda** (*Amanita phalloides*) ☠️ | L'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva en sac a la base del peu. |
| **Apagallums** (*Macrolepiota procera*) | **Pantera** (*Amanita pantherina*) | L'Apagallums té un anell doble mòbil que llisca pel peu; la Pantera té anell fix i volva dissociada en anells concèntrics al bulb. |
| **Rossinyol** (*Cantharellus cibarius*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix en fusta, té làmines veritables tallants (no plecs) i emet bioluminescència a la foscor. |
| **Gírgola** (*Pleurotus ostreatus*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix sobre fusta i té color taronja intens rovellat, no gris-blavós com la Gírgola comestible. |
| **Ou de reig** (*Amanita caesarea*) | **Reig bord** (*Amanita muscaria*) | L'Ou de reig té làmines i peu grocs daurats (mai blancs), i el barret és taronja llis sense esquames blanques. |
| **Moixernó** (*Calocybe gambosa*) | **Pèrfid** (*Entoloma sinuatum*) | El Pèrfid té esporada rosa i olor de farina rància; el Moixernó té esporada blanca i agradable olor de farina fresca. |
| **Cama de perdiu** (*Chroogomphus rutilus*) | **Cortinari de muntanya** (*Cortinarius orellanus*) ☠️ | La Cama de perdiu té làmines molt decurrents i carn que es torna violàcia/negrosa al foc, sense cortina; el Cortinari mortal té cortina i espores rovell. |
| **Fredolic** (*Tricholoma terreum*) | **Fredolic bord** (*Tricholoma pardinum*) | El Fredolic bord és molt més robust i gros, amb esquames concèntriques amples com teules i peu sòlid; el Fredolic és menut, fràgil i de peu buit. |
| **Múrgola** (*Morchella esculenta*) | **Bolet de greix / Falsa múrgola** (*Gyromitra esculenta*) ☠️ | La Múrgola té cel·les o alvèols regulars com una bresca d'abelles; el Bolet de greix té plecs cerebriformes ondulats com un cervell i és mortal. |
