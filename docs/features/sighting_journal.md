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
* **Chronological List:** Cards ordered from newest to oldest (`AvistamentDao.getAllAvistaments()`), dynamically prioritizing real field photo thumbnails with retro ink borders over generic pixel art.
* **Confidence Badge:** Each entry displays an inline confidence pill (e.g. `[ 89% ]` in forest green if $\ge 70\%$, or amber if $< 70\%$).
* **Tap to Inspect:** Tapping any sighting card immediately opens the interactive **Sighting Detail Sheet** (`AvistamentDetailSheet`).
* **100% Neural AI Captured:** All sightings originate exclusively through Boscdex Edge AI scans via the live camera or photo picker, ensuring verified entries with on-device photo captures and neural confidence metrics.

---

## 🔍 Sighting Detail Sheet (`AvistamentDetailSheet`)

Tapping any sighting from the Journal or from the Boscdex captures gallery opens a dedicated inspection sheet (comfortably positioned below the iOS status bar with swipe-to-dismiss drag handle):

1. **High-Resolution Zoomable Photo:** Uses Flutter's `InteractiveViewer` to allow foragers to pinch-to-zoom and pan across the cap, gills, or stipe to re-verify diagnostic traits.
2. **AI Coincidence Gauge:** Displays the exact confidence score (e.g. `89% de coincidència neural`), a visual progress bar, and a safety status note (validating against the Series 011 edge model).
3. **Species Card & Botanical Link:** Shows the Catalan common name, scientific binomial, and edibility badge, along with a direct button to navigate to the full botanical entry in the Boscdex (`/boscdex/:id`).
4. **Expedition Metadata:** Formatted date and time, altitude above sea level, GPS coordinates (if available), and custom user notes.
5. **Action Toolbar:**
   * 💾 **Descarregar Foto:** Directly writes the image to the device's native photo library/camera roll via [`PhotoExportService`](file:///Users/jordi/dev/boscdex/lib/domain/services/photo_export_service.dart) (`image_gallery_saver`).
   * 📤 **Compartir:** Opens the operating system's native share sheet via `share_plus` (AirDrop, WhatsApp, Save to Files, Messages).
   * 🗑️ **Eliminar:** Prompts a confirmation dialog before permanently deleting the sighting record from SQLite and unlinking the physical JPEG file from disk.
