# Live Scan Viewfinder Feature

The **Live Scan** tab (`/scan`) provides the visual viewfinder used for identifying wild specimens directly in the field.

---

## 📷 Viewfinder Interface

* **Targeting Frame:** Centered targeting reticle with animated border scaling to focus the user's attention on diagnostic mushroom features (cap, gills, stem base).
* **Mode Switcher:** Segmented selector at the top switching between:
  * `[ Bolets ]`: Configures classifier targeting fungal morphology.
  * `[ Arbres ]`: Configures classifier targeting bark structure, foliage, and needles.
* **100% Offline Indicator:** Prominent pill badge (`OfflineIndicator`) reassuring the user that no internet connection or roaming signal is needed.
* **Shutter & Gallery Actions:**
  * Primary circular shutter button triggering immediate frame capture and edge inference.
  * Gallery picker alternative icon for identifying previously captured camera roll photos.

---

## 📊 Classification Result Sheet (`ClassificationResultSheet`)

Upon trigger, the on-device model evaluates the image and presents a modal bottom sheet:

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
