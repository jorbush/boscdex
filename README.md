# 🍄 Boscdex

**The offline mushroom forager's Pokédex to explore the Catalan forest**

Boscdex is a gamified, 100% offline field guide designed for mushroom foragers (*boletaires*) and hikers in Catalonia. It blends the discovery thrill of a Pokédex (collection milestones, rarity tiers, badges) with critical field-safety protocols (edibility warnings, toxic lookalike alerts) and ecological context (mushrooms connected with their symbiotic host trees).

---

## ✨ Key Features

- **🔌 100% Offline** — Functions completely without an internet connection. On-device computer vision classification and local SQLite data.
- **📸 Mushroom Scanner** — Identifies wild mushrooms using real-time edge machine learning (Edge ML).
- **🌲 Indicator Trees** — Comprehensive guide to Catalonia's key mycorrhizal host trees (oak, beech, chestnut, pine).
- **⚠️ Dangerous Lookalikes** — High-visibility safety alerts highlighting poisonous and deadly twin species.
- **📖 Boscdex Album** — Visual discovery album with silhouettes, rarity tiers, and collection statistics.
- **📝 Sighting Journal** — Field log recording discoveries with timestamps, photos, and GPS coordinates.
- **🏆 Badges & Achievements** — Local gamification milestones celebrating field achievements.

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| Framework | Flutter (Dart `>=2.18.0 <4.0.0`) |
| ML Inference | TFLite / LiteRT on-device inference |
| Database | SQLite via Drift (reactive, type-safe) |
| State Management | Riverpod 2.x |
| Navigation | GoRouter |
| Location | Geolocator (offline GPS coordinates) |

---

## 📱 Minimum Requirements

- **iOS:** 15.0+
- **Android:** API 26+ (Android 8.0 Oreo)

---

## 🚀 Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Run code generation (Drift DB schema & queries)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

### Automation with Make

```bash
# Format code
make format

# Run linter
make lint

# Run all test tiers (unit, integration, e2e)
make test

# Full CI validation check
make check
```

---

## 🌿 Project Structure

```
lib/
├── app.dart            # Main MaterialApp and theme configuration
├── main.dart           # App entrypoint with dependency initialization
├── core/               # App constants, router, theme, and utility helpers
├── data/               # Data layer (Drift DB, tables, DAOs, seed data)
├── domain/             # Domain models, services (ML, safety gate, badges)
├── presentation/       # Feature screens & widgets (Boscdex, Scan, Detail, Journal)
└── providers/          # Riverpod top-level state providers

test/
├── unit_tests/         # Tier 1: Domain services, models, and isolated widget tests
├── integration_tests/  # Tier 2: Drift SQLite database, DAOs, and Riverpod integration
└── e2e_tests/          # Tier 3: Complete user flows from splash to discovery logging

tools/                  # ML training and dataset pipeline (not bundled into the app)
├── dataset/            # Dataset acquisition and Mediterranean filtering scripts
├── training/           # Model training and fine-tuning scripts
└── export/             # Quantization (INT8) and TFLite model export
```

---

## ⚠️ Safety & Legal Disclaimer

> This application is intended as an educational field guide and navigational aid. Machine learning models are probabilistic and may produce incorrect classifications. **Never consume any wild mushroom without prior in-person validation from a qualified human mycologist.**

---

## 📄 License

Copyright © 2026 Boscdex. All rights reserved.
