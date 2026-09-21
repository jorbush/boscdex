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
| **Rovelló / Pinetell** (*Lactarius deliciosus*) | **Lleterola de llet groga** (*Lactarius chrysorrheus*) | White latex quickly turning bright sulphur-yellow vs. immutable carrot-orange latex. |
| **Ou de reig** (*Amanita caesarea*) | **Reig bord** (*Amanita muscaria*) | Yellow stem, yellow gills, striate margin vs. pure white stem, white gills, non-striate margin. |
| **Rossinyol** (*Cantharellus cibarius*) | **Gírgola d'olivera** (*Omphalotus olearius*) | Blunt ridges/folds growing on soil vs. true sharp knife-edge gills growing clustered on wood/roots. |
| **Cep** (*Boletus edulis*) | **Mataparent amarg** (*Tylopilus felleus*) | White/olive-yellow pores with faint white reticle vs. pinkish pores with dark coarse brown reticle and intense bitter taste. |
| **Fredolic** (*Tricholoma terreum*) | **Pèrfid** (*Entoloma sinuatum*) | Thin hollow stem and grey gills vs. robust yellowish-pink gills and strong floury odor. |
| **Xampinyó silvestre** (*Agaricus campestris*) | **Farinera borda** (*Amanita phalloides*) | Pink-to-chocolate brown gills, no volva vs. pure white gills, persistent white volva and ring. |
