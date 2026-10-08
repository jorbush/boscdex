# 🍄 Boscdex

**The offline mushroom forager's Pokédex to explore the Catalan forest**

Boscdex is a gamified, 100% offline field guide designed for mushroom foragers (*boletaires*) and hikers in Catalonia. It blends the discovery thrill of a Pokédex (collection milestones, rarity tiers, badges) with critical field-safety protocols (edibility warnings, toxic lookalike alerts) and ecological context (mushrooms connected with their symbiotic host trees).

---

## ✨ Key Features

- **🔌 100% Offline** — Functions completely without an internet connection. On-device computer vision classification and local SQLite data.
- **📸 Mushroom Scanner & High-Res Photo Storage** — Identifies wild mushrooms using real-time edge machine learning (Edge ML) and preserves high-resolution field photos on-device.
- **🛰️ Private Offline GPS Geolocation** — Automatic on-device GPS coordinate capture and altitude logging with zero cloud synchronization, preserving secret foraging spots (*les clapes*).
- **🗺️ Interactive Catalonia Field Map ("Mapa de Camp")** — 16-bit retro Catalonia map visualizing field discoveries with specimen-specific pixel art sprites, pinch-to-zoom (`InteractiveViewer`), category filters (`Tots`, `Bolets`, `Arbres`), and an inspection HUD.
- **🔍 Sighting Detail & Export** — Inspect scanned photos with pinch-to-zoom (`InteractiveViewer`), neural coincidence percentage gauge, 1-tap download to Camera Roll, and native sharing (AirDrop, WhatsApp).
- **🍄 Boscdex Album & "Les Teves Captures"** — Visual discovery album with dark silhouettes, rarity tiers, and personal specimen photo galleries.
- **🌲 Indicator Trees** — Comprehensive guide to Catalonia's key mycorrhizal host trees (oak, beech, chestnut, pine).
- **⚠️ Dangerous Lookalikes** — High-visibility safety alerts highlighting poisonous and deadly twin species.
- **📝 Sighting Journal** — Field log recording discoveries with dual list/map view, real photo thumbnails, confidence pills, and timestamps.
- **🌐 Trilingual Localization** — Full Catalan (*Català*, default), Spanish (*Castellano*), and English support across all UI navigation, on-device settings, species morphology (cap, gills, stem, latex), safety warnings, lookalike comparisons, and 16-bit regional foraging maps.
- **🏆 Badges & Achievements** — Local gamification milestones celebrating field achievements.
- **🎖️ Forager Leveling & Progression System ("Nivell de Boletaire")** — Dynamic 10-tier experience system (*Novell del Bosc* to *Mestre del Bosc*). Accumulates XP from cataloging mushrooms (+100 XP), identifying trees (+75 XP), unlocking badges (+150 XP), and logging journal sightings (+25 XP). Features an interactive retro HUD badge in the Boscdex AppBar, progress bar, XP breakdown modal, and rank roadmap.

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
| Localization | Custom trilingual l10n engine (`ca`, `es`, `en`) |

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
├── core/               # App constants, router, theme, utilities, and localization (ca, es, en)
├── data/               # Data layer (Drift DB, tables, DAOs, seed data)
├── domain/             # Domain models, services (ML, safety gate, badges, Catalonia zones)
├── presentation/       # Feature screens & widgets (Boscdex, Scan, Detail, Journal, Settings)
└── providers/          # Riverpod top-level state providers (database, audio, preferences, locale)

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
