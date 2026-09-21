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

## 🟡 Planned for v1.1 (Edge ML Production & Camera Stream)

- [x] **Live Camera Stream Integration:** Connect camera hardware feed via native `camera` package with rear lens autofocus, iOS/Android permissions, and gallery photo picker fallback.
- [ ] **Real Model Weights Packaging:** Bundle trained `boscdex_classifier.tflite` (<18 MB) into `assets/models/`.
- [ ] **Delegate Acceleration:** Enable CoreML delegate for iOS and NNAPI/GPU delegate for Android in the interpreter initialization.
- [ ] **Expanded Taxonomy:** Grow seed database from 20 species to the full 80 Catalan mushrooms and 12 indicator trees.

---

## 🔵 Planned for v2.0 (Advanced Field Guide & Tools)

- [ ] **Private Offline Heatmaps:** Render offline topographic raster tiles with clustered personal sighting points (strictly local, zero cloud sync).
- [ ] **Weather & Solunar Correlation:** Offline rain/temperature estimations based on local sensors and elevation to suggest optimal foraging days.
- [ ] **Audio Chirps & Sounds:** Retro Pokédex sound effects for discoveries and badge awards.
- [ ] **Data Export & Backup:** Export sightings to CSV / GeoJSON or encrypted local backup.
