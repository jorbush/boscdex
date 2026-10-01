# Roadmap: Status & Milestones

This document tracks completed features in **Boscdex MVP v1.0** and outlines upcoming objectives for **v1.1** and **v2.0**.

---

## 🟢 Completed in MVP v1.0

### Architecture & Core
- [x] Flutter clean architecture project setup with iOS 15+ and Android API 26+ configurations.
- [x] Material 3 Dark Forest theme (`#0D1B0E`, `#1B4332`, `#E9C46A`).
- [x] GoRouter configuration with ShellRoute (3 persistent tabs + modal routes).
- [x] Type-safe SQLite relational database with Drift, background isolate execution, and auto-seeding migration.

### Taxonomy & Knowledge Base
- [x] Initial seed catalog of **20 Catalan mushrooms** with morphological descriptions, seasonality, and altitudinal data.
- [x] **5 Catalan indicator trees** with bark, foliage, soil, and mutualism data.
- [x] Mycorrhizal associations mapping mushrooms to their symbiotic partner trees.
- [x] Toxic lookalikes mapping dangerous pairs with diagnostic criteria.

### Features & UX
- [x] **Boscdex Album:** Pokédex-style grid displaying dark silhouettes for undiscovered species and colored cards with rarity borders for unlocked taxa.
- [x] **Specimen Detail Sheets:** Morphological breakdown (barret, làmines, peu, làtex), 12-month seasonality strip, and associated trees.
- [x] **Tree Detail Sheets:** Indicator tree guide with associated mushrooms.
- [x] **Mandatory Safety Disclaimer:** Persistent legal gate before entering the field guide.
- [x] **Safety Gates:** Low-confidence alerts (<70%) and prominent red `ALERTA DE CONFUSIÓ PERILLOSA` boxes.
- [x] **Live Scan Viewfinder:** Animated targeting reticle, Bolets/Arbres mode switcher, and candidate result sheet.
- [x] **Offline Journal:** Chronological sighting logbook with notes and confidence ratings.
- [x] **Gamification:** 6 starter badges with real-time SQLite progress tracking and awards.

### ML Tooling & Pipelines
- [x] `tools/dataset/species_list.csv` covering 39 target taxa with iNaturalist IDs.
- [x] `tools/dataset/download_inat.py` for downloading research-grade geo-filtered Catalan specimens.
- [x] `tools/training/train_classifier.py` for EfficientNet-Lite0 fine-tuning via MediaPipe Model Maker.
- [x] `tools/export/quantize_export.py` for INT8 TFLite post-training quantization.

---

## 🟡 In Progress / Completed in v1.1 (Edge ML Production & Camera Stream)

- [x] **Live Camera Stream Integration:** Connect camera hardware feed via native `camera` package with rear lens autofocus, iOS/Android permissions, and gallery photo picker fallback.
- [x] **Real Model Weights Packaging:** Bundled trained `mushroom_classifier.tflite` (2.50 MB), `mushroom_classifier_head.bin` (107.6 KB), and `mushroom_labels.txt` (21 classes) into `assets/models/`.
- [x] **Field-Calibrated Transfer Learning:** Fine-tuned on real Catalan field photographs on Google Colab T4 GPU, reaching **87.1% Top-1** (196/225) and **93.8% Top-3** (211/225) empirical accuracy across 225 photos (Series 013).
- [x] **Decoupled GAP + Dart Classification Head:** Solved mobile TFLite opcode compatibility; sub-0.05 ms linear projection executed in native Dart.
- [x] **Golden Set Regression Test Suite:** Automated on-device benchmark evaluating 225 field photos in <60s (`mushroom_model_real_images_test.dart`).
- [x] **Field Photo Persistence Architecture:** Scanned field photos saved permanently in `<appDocumentsDir>/scans/scan_<uuid>.jpg` with relative path linkage in SQLite `Avistaments`.
- [x] **Sighting Inspection & Export:** Modal detail view (`AvistamentDetailSheet`) featuring `InteractiveViewer` pinch-to-zoom, neural coincidence %, direct gallery export (`ImageGallerySaver`), and system sharing (`share_plus`).
- [x] **"Les Teves Captures" Gallery in Boscdex:** Specimen cards now showcase a personalized horizontal photo carousel of every user scan for that species.
- [x] **Comprehensive Automated Test Suite:** 120+ passing unit, widget, integration, and E2E tests across data, domain, and presentation layers.
- [x] **Pokédex-Style Habitat & Location Inspection with 16-Bit Catalonia Pixel Art Map:** Tap any undiscovered specimen in the Boscdex to inspect its geographic habitat, pulsating regional distribution zones on an authentic 16-bit retro map of Catalonia, associated indicator trees, altitudinal range, and fruiting seasonality with morphological keys and identity veiled until live camera discovery.
- [x] **Dedicated On-Device Indicator Tree TFLite Classifier:** Quantized MobileNetV2 backbone (`tree_classifier.tflite`, 2.50 MB) + linear classification head (`tree_classifier_head.bin`, 25.6 KB) lazy-loaded into memory on demand, classifying 5 indicator tree species (`tree_labels.txt`).
- [x] **Tree Golden Set Empirical Evaluation Suite:** Automated test suite (`tree_model_real_images_test.dart`) benchmarked on 79 real field photographs, achieving **80.0% Top-1** and **96.0% Top-2** accuracy.
- [x] **Domain & Service Architecture English Refactoring:** Refactored domain models (`MushroomClassificationResult`, `TreeClassificationResult`) and service methods (`classifyMushroom`, `classifyTree`) to idiomatic English, eliminating internal language fragmentation while preserving user-facing Catalan text in the UI.
- [x] **Tree Dataset Expansion & Fine-Tuning (Phase 2):** Expanded training dataset to 250 curated field observations (50 per species) trained via Colab GPU pipeline (`boscdex_tree_training_colab.ipynb`) with an expanded 79-photo golden validation set.
- [x] **Schema v3 SQLite Table Migration:** Implemented zero-loss table recreation under `PRAGMA foreign_keys = OFF` to guarantee `bolet_id` nullability in SQLite, resolving constraint errors and supporting indicator tree sightings.
- [x] **Reactive Field Identification for Indicator Trees:** Decoupled tree identification from guide page visits; trees are tracked reactively via the SQLite database stream (`watchIdentifiedArbreIds`), displaying camera prompts (📷) when pending field capture and verified checkmarks (✓) upon logging sightings.
- [x] **Specimen Concealment in Associated Tree Guides:** Veiled undiscovered associated mushrooms in `ArbreDetailScreen` (`#00X ???` + black silhouette) to preserve Pokédex discovery mechanics.
- [x] **Comprehensive Code Review Remediation & Life-Safety Hardening:**
  - Resolved safety gate priority inversion so lethal/toxic species trigger `NivellSeguretat.perill` alerts even at low confidence, failing closed on unknown edibility.
  - Added native GPU texture cleanup (`image.dispose()`, `codec.dispose()`) on classification cycles.
  - Eliminated synchronous file I/O in scrollable lists (`ListView.builder`) across detail screens and journal.
  - Hoisted static viewfinder into `AnimatedBuilder.child` to avoid 60fps camera widget rebuilds during scanning.
  - Added Catalan diacritic normalization to `BoletDao.searchByName` (e.g. `rovello` matches `Rovelló`).
  - Added `KeyAction.setNull` cascade to `Descobriments.firstAvistamentId` to protect against foreign key crashes.
- [x] **Photo Persistence & Container UUID Normalization:** Relative path storage (`scans/scan_<uuid>.jpg`), dynamic runtime resolution in `PhotoExportService`, and automatic SQLite legacy recovery migration across app versions.
- [x] **Android Build Toolchain & Java 17 Compatibility:** AGP 7.1.2 + Kotlin 1.8.22 + Java 17 Corretto configuration, verifying clean standalone release APK builds (`app-release.apk`, 101.9 MB).
- [x] **Expanded Test Suite (147 Passing Tests):** Achieved 100% pass rate across 147 automated unit, widget, integration, and E2E tests (`flutter test --exclude-tags ml_benchmark`).

---

## 🟡 Milestone v1.2: Pre-Store Experience & Field Tools (Current Focus)

Prioritized features before the initial public store release:

1. **Retro 8-Bit Audio System (`SoundEffectService`):**
   - [x] Implement lightweight offline audio engine for retro 8-bit sound effects (`audioplayers` 4.1.0).
   - [x] Species discovery fanfare (unveiling a new Boscdex card from silhouette).
   - [x] Tree identification jingle for indicator trees.
   - [x] Badge award triumph chime (`achievement_unlocked.wav`).
   - [x] Camera scan / shutter sound effect (`camera_shutter.wav`).
   - [x] Audio toggle in `SettingsScreen` (enable/disable sound effects with SharedPreferences persistence and reactive sound provider).
   - [x] Resolved native iOS share sheet presentation, anchor origin, and MIME type in sightings detail (`AvistamentDetailSheet`).

2. **Personal Sightings GPS Map in Diari (`JournalMapView`):**
   - [ ] Interactive offline field sightings map visualizing the user's geolocated finds across Catalonia.
   - [ ] Distinct markers for mushrooms (🍄) and indicator trees (🌲) with confidence & date indicators.
   - [ ] Sighting card inspection preview sheet upon tapping map pins.
   - [ ] Mode toggle in Diari between chronological list view and geographic map view.
   - [ ] 100% offline operation respecting zero-cloud privacy guarantee.

---

## 🚀 Milestone v1.3: Store Release (App Store & Google Play)

- [ ] **Android App Bundle (.aab):** Generate optimized release bundle for Google Play Console dynamic delivery (~25 MB).
- [ ] **iOS Archive (.ipa):** Create signed App Store release archive for TestFlight distribution.
- [ ] **App Assets & Icons:** Finalize adaptive launcher icons (`ic_launcher` / `AppIcon`) with pixel-art Boscdex identity across all density buckets.
- [ ] **Store Metadata & ASO:** Store listings in Catalan, Spanish, and English with screenshots highlighting 100% offline edge ML inference and safety gates.

---

## 🔵 Planned for v2.0 (Taxonomy Expansion & Advanced Tools)

- [ ] **Expanded Taxonomy:** Grow seed database from 20 species to the full 80 Catalan mushrooms and 12 indicator trees.
- [ ] **Tree Classifier Head Refinement:** Further fine-tune leaves vs bark accuracy with expanded multi-season training set.
- [ ] **Weather & Solunar Correlation:** Offline rain/temperature estimations based on local elevation and seasonality to suggest optimal foraging windows.
- [ ] **Data Export & Backup:** Export sightings to CSV / GeoJSON and complete encrypted backup (database + scan photos).

