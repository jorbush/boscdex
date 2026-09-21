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
│  • AppDatabase (Auto-seeded with 20 bolets + 5 trees)  │
│  • DAOs (Bolet, Arbre, Avistament, Descobriment, etc.) │
│  • SharedPreferences (Disclaimer acceptance, counters) │
└────────────────────────────────────────────────────────┘
```

---

## 🧱 Layer Responsibilities

### 1. Data Layer (`lib/data/`)
* **SQLite Engine:** Implemented via **Drift** (`drift`, `drift/native.dart`). Runs queries on a background isolate, eliminating UI jank.
* **Auto-Seeding Migration:** The database seeds initial taxonomy companions on first creation (`MigrationStrategy.onCreate`), guaranteeing immediate availability of all 20 Catalan mushrooms, 5 indicator trees, toxic lookalike associations, and 6 starter badges without external network downloads.
* **Local Persistence:** Uses `SharedPreferences` solely for low-overhead configuration flags (e.g., legal disclaimer acceptance, lookalike comparison counter).

### 2. Domain Layer (`lib/domain/`)
* **Independence:** Pure Dart entities with zero UI or framework dependencies.
* **Services:**
  * `SafetyGateService`: Enforces safety algorithms (evaluating confidence scores and cross-checking known toxic lookalikes).
  * `BadgeService`: Re-evaluates player achievements whenever discoveries or user actions occur.
  * `ClassifierService`: Abstract interface decoupled from the underlying inference engine.

### 3. Presentation Layer (`lib/presentation/`)
* **State Management:** **Flutter Riverpod** without code-generation to maintain strict compatibility with Dart 2.18 / Flutter 3.3.3.
* **Navigation:** **GoRouter** with `ShellRoute` delivering a persistent bottom navigation bar across the 3 primary tabs (`/boscdex`, `/scan`, `/journal`) and modal push routes for detail views (`/boscdex/:id`, `/arbre/:id`, `/disclaimer`).
* **Design Language:** Dark forest theme inspired by Catalan mountain woodland palettes:
  * Dark bark background (`#0D1B0E`)
  * Deep forest green surfaces (`#1B4332`)
  * Warm ochre accents (`#E9C46A`)
  * Alert red for toxic lookalikes (`#DC2626`)
  * Deep purple-black for deadly species (`#4A0E0E`)
