# 🍄 Boscdex Documentation Index

Welcome to the official technical and product documentation for **Boscdex**, the offline-first field guide and Pokédex for mushroom foragers (*boletaires*) in Catalonia.

---

## 📚 Documentation Structure

### 1. Architecture
* [**System Overview**](architecture/overview.md) — 100% offline-first architecture, clean layered design, state management with Riverpod, and on-device runtime.
* [**Data Models & Relational Schema**](architecture/data_models.md) — Drift SQLite tables, relational entities, DAOs, and seed data.
* [**Edge Machine Learning**](architecture/edge_ml.md) — On-device computer vision engine, INT8 quantization, input/output tensors, and hardware acceleration delegates.

### 2. Features
* [**The Boscdex Album**](features/boscdex_album.md) — Pokédex discovery grid, silhouettes, 5 rarity tiers, and edibility indicators.
* [**Live Scan Viewfinder**](features/live_scan.md) — Real-time camera viewfinder, Edge-ML inference, candidate confidence sheet, and registration.
* [**Safety Gates & Toxic Lookalikes**](features/safety_and_toxic_lookalikes.md) — Confidence thresholds, "Confusió Perillosa" alerts, and side-by-side morphological checks.
* [**Indicator Trees Companion Guide**](features/indicator_trees.md) — Symbiotic host trees of Catalonia (*Pi roig, Alzina, Faig...*) and mycorrhizal partnerships.
* [**Offline Sighting Journal**](features/sighting_journal.md) — Private, non-cloud GPS logbook ("El Meu Diari" / "Les Meves Clapes").
* [**Gamification & Badges**](features/gamification_badges.md) — 6 starter badges, SQLite-backed progress evaluation, and milestones.

### 3. Workflows
* [**Scan-to-Log Workflow**](workflows/scan_to_log.md) — Complete user journey from camera detection to Boscdex unlock and journal record.
* [**Safety Gate Decision Flow**](workflows/safety_gate_flow.md) — Verification decision tree protecting foragers against poisonous specimens.
* [**ML Training Pipeline**](workflows/ml_training_pipeline.md) — Dataset gathering from iNaturalist, Catalan geographical filtering, augmentations, and quantization export.
* [**Google Colab Training Guide**](workflows/colab_training_guide.md) — Step-by-step guide to train the INT8 TFLite model on Google Colab's free T4 GPU tier.

### 4. Roadmap
* [**Status & Milestones**](roadmap/status_and_milestones.md) — Detailed assessment of what is completed in MVP v1.0 and what is planned for v1.1 and v2.0.

### 5. Research & Benchmarks
* [**Empirical Scan Trials & Classifier Validation**](research/empirical_scan_trials.md) — Real-world field trials on physical devices (iPhone 12), prediction diagnosis, RCA, and benchmark evolution log.

### 6. Theory & Machine Learning Foundations
* [**Machine Learning & Computer Vision Theory**](theory/README.md) — Complete foundational curriculum explaining how computers see images, convolutions, MobileNetV2 transfer learning, backpropagation, and edge TFLite quantization from first principles.

