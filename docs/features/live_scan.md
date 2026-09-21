# Live Scan Viewfinder Feature

The **Live Scan** tab (`/scan`) provides the visual viewfinder used for identifying wild specimens directly in the field.

---

## 📷 Viewfinder Interface

* **Targeting Frame:** Centered targeting reticle with animated border scaling to focus the user's attention on diagnostic morphology.
* **Mode Switcher:** Segmented selector at the top switching between:
  * `[ Bolets ]`: Evaluates fungal specimens via `classifier.classify()` and displays `ClassificationResultSheet`.
  * `[ Arbres ]`: Evaluates indicator trees via `classifier.classifyTree()` and displays `TreeClassificationResultSheet`.
* **Clean & Minimalist Viewfinder:** Free of distracting indicators to keep focus entirely on specimen photography.
* **Shutter & Gallery Actions:**
  * Primary circular shutter button triggering immediate frame capture and edge inference.
  * Gallery picker alternative icon for identifying previously captured camera roll photos.

---

## 📊 Fungi Classification Result Sheet (`ClassificationResultSheet`)

Upon scanning a mushroom, the on-device model evaluates the image and presents a modal bottom sheet:

1. **Top Candidate Card:**
   * Catalan vernacular name and scientific binomial.
   * Confidence percentage badge (e.g., `91% coincidència`).
   * Edibility badge with color and icon.
2. **Alternative Candidates (Rank 2 & 3):**
   * Displays the next two runner-up candidate species with relative linear progress bars to guard against misclassification.
3. **Safety Gate Warnings:**
   * Evaluated automatically by `SafetyGateService` (see [Safety and Toxic Lookalikes](safety_and_toxic_lookalikes.md)).
4. **Action CTA ("Registrar a la meva Boscdex"):**
   * Persists a new entry in `Avistaments`.
   * Unlocks the specimen in `Descobriments` if encountering it for the first time.
   * Re-evaluates badge conditions and updates `Insignies`.
   * Displays instant feedback and dismisses the sheet.

---

## 🌲 Tree Classification Result Sheet (`TreeClassificationResultSheet`)

When in **Arbres** mode, scanning an indicator tree presents:

1. **Top Indicator Tree Card:**
   * Catalan and scientific names (e.g., *Pinus sylvestris* - Pi roig).
   * Confidence score badge.
   * Diagnostic botanical traits: needle/leaf type, bark description, and typical soil.
2. **Symbiotic Fungi Section ("Bolets que pots cercar sota aquest arbre"):**
   * Direct chips of associated mushrooms linked via mycorrhizal relations (e.g., Rovelló under Pi roig).
   * Tapping any associated mushroom opens its Boscdex entry.
3. **Habitat & Tree Profile Action:**
   * "Veure fitxa completa de l'arbre" button tracks the tree as visited (contributing towards the "Aliança Silvestre" badge) and navigates to the detailed tree profile (`/arbre/:id`).
