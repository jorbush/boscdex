# System Architecture Overview

Boscdex is designed from the ground up as a **100% offline-first, client-only mobile application**. Remote mountain valleys and deep pine forests in Catalonia frequently suffer from complete network dead zones; any dependence on cloud APIs or remote servers would make the guide unusable in the field.

---

## 🏛️ High-Level Architecture Diagram

```
┌────────────────────────────────────────────────────────┐
│                   Presentation Layer                   │
│  (Material 3 Theme, GoRouter, Riverpod UI Consumers)   │
├────────────────────────────────────────────────────────┤
│    Boscdex Tab    │    Scan Tab     │    Diari Tab     │
│   (Grid/Silh.)    │   (Edge-ML)     │  (Sightings)     │
└─────────┬─────────┴────────┬────────┴────────┬─────────┘
          │                  │                 │
          ▼                  ▼                 ▼
┌────────────────────────────────────────────────────────┐
│                      Domain Layer                      │
│     (Pure Dart Models, Service Business Logic)         │
├────────────────────────────────────────────────────────┤
│  • SafetyGateService    • BadgeService                 │
│  • ClassifierService    • Domain Entities (Bolet, etc.)│
└─────────┬──────────────────┬─────────────────┬─────────┘
          │                  │                 │
          ▼                  ▼                 ▼
┌────────────────────────────────────────────────────────┐
│                       Data Layer                       │
│    (Type-Safe SQLite via Drift, Local Key-Value)       │
├────────────────────────────────────────────────────────┤
│  • AppDatabase (Auto-seeded with 47 bolets + 5 trees)  │
│  • DAOs (Bolet, Arbre, Avistament, Descobriment, etc.) │
│  • SharedPreferences (Disclaimer acceptance, counters) │
└────────────────────────────────────────────────────────┘
```

---

## 🧱 Layer Responsibilities

### 1. Data Layer (`lib/data/`)
* **SQLite Engine:** Implemented via **Drift** (`drift`, `drift/native.dart`). Runs queries on a background isolate, eliminating UI jank.
* **Auto-Seeding Migration:** The database seeds initial taxonomy companions on first creation (`MigrationStrategy.onCreate`), guaranteeing immediate availability of all 47 Catalan mushrooms, 5 indicator trees, toxic lookalike associations, and 14 achievement badges without external network downloads.
* **Local Persistence:** Uses `SharedPreferences` solely for low-overhead configuration flags (e.g., legal disclaimer acceptance, lookalike comparison counter).

### 2. Domain Layer (`lib/domain/`)
* **Independence:** Pure Dart entities with zero UI or framework dependencies.
* **Services:**
  * `SafetyGateService`: Enforces safety algorithms (evaluating confidence scores and cross-checking known toxic lookalikes).
  * `BadgeService`: Re-evaluates player achievements whenever discoveries or user actions occur.
  * `ClassifierService` & `TfliteClassifierService`: Decoupled Edge-ML inference engine combining a quantized MobileNetV2 Global Average Pooling feature extractor (`mushroom_classifier.tflite`, 1,280-D embeddings) with a pure-Dart linear classification head (`mushroom_classifier_head.bin`, 47 classes). Uses **3-View Test-Time Augmentation (TTA)** (55% Full Frame + 25% Horizontal Flip + 20% Central 80% Macro Crop) and resolves localized display names via `SpeciesLocalizer`.

### 3. Presentation Layer (`lib/presentation/`)
* **State Management:** **Flutter Riverpod** without code-generation to maintain strict compatibility with Dart 2.18 / Flutter 3.3.3.
* **Navigation:** **GoRouter** with `ShellRoute` delivering a persistent bottom navigation bar across the 3 primary tabs (`/boscdex`, `/scan`, `/journal`) and modal push routes for detail views (`/boscdex/:id`, `/arbre/:id`, `/disclaimer`).
* **Design Language:** Dark forest theme inspired by Catalan mountain woodland palettes:
  * Dark bark background (`#0D1B0E`)
  * Deep forest green surfaces (`#1B4332`)
  * Warm ochre accents (`#E9C46A`)
  * Alert red for toxic lookalikes (`#DC2626`)
  * Deep purple-black for deadly species (`#4A0E0E`)

### 4. Core & Localization Layer (`lib/core/localization/`)
* **Trilingual Architecture:** Self-contained, zero-cloud localization engine providing runtime language switching across Catalan (`ca`, default), Spanish (`es`), and English (`en`).
* **`AppLocalizations`:** Type-safe localization delegate providing UI labels, tab navigation, camera viewfinder cues, settings options, and warning banners.
* **`SpeciesLocalizer`:** Curated multilingual catalog translating common names, detailed morphology traits (cap, gills, stem, latex), safety disclaimers, toxic lookalike comparative keys, and host tree traits for all 47 mushrooms and 5 indicator trees.
* **Reactive Persistence:** Active language selection persisted via `SharedPreferences` and propagated across the widget tree with Riverpod's `appLocaleProvider`.
