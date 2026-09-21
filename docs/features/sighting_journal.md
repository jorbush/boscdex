# Offline Sighting Journal ("El Meu Diari")

Catalan *boletaires* are fiercely protective of their secret foraging patches (*les clapes* or *els calaixos*). Boscdex enforces **strict local storage** for all foraging logs.

---

## 🔒 Privacy & Local-First Philosophy

* **Zero Cloud Synchronization:** Sighting coordinates and photographs remain exclusively inside the device's sandbox SQLite database (`app_database.dart`).
* **No Analytics or Telemetry:** No GPS coordinates or sightings are ever transmitted to any remote analytics or central server.
* **Complete Offline Availability:** Entries can be logged, queried, edited, and deleted in mountain areas with zero cellular reception.

---

## 📝 Sighting Record Structure (`Avistament`)

| Field | Type | Description |
|---|---|---|
| `id` | `TEXT (UUID)` | Globally unique identifier generated on-device. |
| `boletId` | `TEXT (FK)` | Reference to the identified species in `bolets`. |
| `timestamp` | `DATETIME` | Exact date and time of the field discovery. |
| `latitude` | `REAL (nullable)` | WGS84 latitude coordinate captured via GPS. |
| `longitude` | `REAL (nullable)` | WGS84 longitude coordinate captured via GPS. |
| `altitude` | `REAL (nullable)` | Meters above sea level. |
| `photoPath` | `TEXT (nullable)` | Local file URI for the captured field photo. |
| `confidenceScore` | `REAL (nullable)` | Machine learning prediction certainty percentage. |
| `notes` | `TEXT (nullable)` | User notes (e.g., habitat details, companion species, weather). |

---

## 📱 Journal Screen UI (`/journal`)

* **Empty State:** Friendly graphic with an encouraging message when no sightings have been logged: *"Encara no tens cap avistament. Escaneja el teu primer bolet!"*.
* **Chronological List:** Cards ordered from newest to oldest, displaying species name, formatted date, confidence indicator, and notes snippet.
* **Manual Entry:** Floating action button (`FAB`) enabling foragers to register specimens discovered without active camera scanning.
