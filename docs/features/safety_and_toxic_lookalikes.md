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
  * Increments the user's `toxicComparisonViewCount` (fueling the **Micòleg Prudent** badge).
  * Directs the user to the side-by-side morphological breakdown detailing differences in latex, volva, gills, or stem reticulation.

---

## ☠️ Key Confusion Pairs Cataloged in Catalonia

| Prized Edible | Dangerous / Toxic Lookalike | Key Diagnostic Difference |
|---|---|---|
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Reig bord** (*Amanita muscaria*) | Tots dos es troben en pinedes, però el Reig bord té un barret vermell brillant amb esquames blanques i mai presenta làtex taronja. |
| **Rossinyol** (*Cantharellus cibarius*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix en fusta i té làmines veritables (no plecs), a més brilla en la foscor (bioluminescència). |
| **Ou de reig** (*Amanita caesarea*) | **Reig bord** (*Amanita muscaria*) | L'Ou de reig té làmines i peu grocs (mai blancs), i el barret és llis sense esquames blanques. |
| **Apagallums** (*Macrolepiota procera*) | **Farinera borda** (*Amanita phalloides*) | L'Apagallums té un anell mòbil i doble, i mai té volva. La Farinera borda té sempre volva a la base del peu. |
| **Gírgola** (*Pleurotus ostreatus*) | **Gírgola d'olivera** (*Omphalotus olearius*) | La Gírgola d'olivera creix sobre fusta d'olivera i té un color taronja intens, no gris-blavós com la Gírgola comestible. |
| **Moixernó** (*Calocybe gambosa*) | **Pèrfid** (*Entoloma sinuatum*) | El Pèrfid té esporada rosa i olor de farina rància, mentre que el Moixernó té esporada blanca i olor agradable de farina fresca. |
