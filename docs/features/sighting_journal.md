# Offline Sighting Journal ("El Meu Diari")

Catalan *boletaires* are fiercely protective of their secret foraging patches (*les clapes* or *els calaixos*). Boscdex enforces **strict local storage** for all foraging logs.

---

## 🔒 Privacy & Local-First Philosophy

* **Zero Cloud Synchronization:** Sighting coordinates and photographs remain exclusively inside the device's sandbox SQLite database (`app_database.dart`).
* **No Analytics or Telemetry:** No GPS coordinates or sightings are ever transmitted to any remote analytics or central server.
* **Complete Offline Availability:** Entries can be logged, queried, edited, and deleted in mountain areas with zero cellular reception.

---

## 📝 Sighting Record Structure (`Avistament` Schema v3)

> **Schema v3 SQLite Table Migration:**  
> In SQLite, column nullability constraints cannot be dropped via `ALTER TABLE`. Schema v3 performs a zero-loss table recreation under `PRAGMA foreign_keys = OFF` (creating `avistaments_new`, copying all legacy rows, dropping `avistaments`, and renaming). This guarantees `boletId` is strictly nullable across all existing devices, preventing SQLite constraint failures when saving indicator tree observations.

| Field | Type | Description |
|---|---|---|
| `id` | `TEXT (UUID)` | Globally unique identifier generated on-device. |
| `boletId` | `TEXT (FK, nullable)` | Reference to the identified mushroom in `bolets` (null for tree sightings). |
| `arbreId` | `TEXT (FK, nullable)` | Reference to the identified indicator tree in `arbres` (null for mushroom sightings). |
| `timestamp` | `DATETIME` | Exact date and time of the field discovery. |
| `latitude` | `REAL (nullable)` | WGS84 latitude coordinate captured via GPS. |
| `longitude` | `REAL (nullable)` | WGS84 longitude coordinate captured via GPS. |
| `altitude` | `REAL (nullable)` | Meters above sea level. |
| `photoPath` | `TEXT (nullable)` | Local file URI for the captured field photo. |
| `confidenceScore` | `REAL (nullable)` | Machine learning prediction certainty percentage. |
| `notes` | `TEXT (nullable)` | User notes (e.g., habitat details, companion species, weather). |

---

## 📱 Journal Screen UI (`/journal`)

* **Dual View Mode Switcher:** Segmented selector at the top switching smoothly between:
  * `[ 📜 Llista ]`: Chronological feed of all recorded expeditions.
  * `[ 🗺️ Mapa ]`: Interactive geographic map visualizing geolocated discoveries across Catalonia.
* **Empty State:** Friendly graphic with an encouraging message when no sightings have been logged: *"Encara no tens cap avistament. Escaneja el teu primer bolet o arbre!"*.
* **Chronological List:** Cards ordered from newest to oldest (`AvistamentDao.getAllAvistaments()`), dynamically prioritizing real field photo thumbnails with retro ink borders over generic pixel art.
* **Unified Mushroom & Tree Support:** Sightings display either the mushroom or indicator tree name. Tree sightings feature a prominent `[ ARBRE ]` badge and pixel tree fallback.
* **Confidence Badge:** Each entry displays an inline confidence pill (e.g. `[ 89% ]` in forest green if $\ge 70\%$, or amber if $< 70\%$).
* **Tap to Inspect:** Tapping any sighting card immediately opens the interactive **Sighting Detail Sheet** (`AvistamentDetailSheet`).
* **100% Neural AI Captured:** All sightings originate exclusively through Boscdex Edge AI scans via the live camera or photo picker, ensuring verified entries with on-device photo captures and neural confidence metrics.

---

## 🗺️ Interactive Catalonia Field Map ("Mapa de Camp")

The map mode (`JournalMapView`) plots the user's field discoveries on top of an authentic 16-bit retro pixel map of Catalonia:

1. **Pixel Art Map Canvas & Gesture Controls:**
   - Base map rendered from `assets/maps/catalonia_pixel_map.png` preserving crisp retro edges (`FilterQuality.none`).
   - Seamless pinch-to-zoom and pan via `InteractiveViewer` with scale constraints from `1.0x` (overview of all Catalonia) to `4.5x` (local foraging valleys).
   - Dedicated "Centrar mapa" FAB button with smooth reset animation.
2. **Equirectangular Coordinate Projection (`JournalMapProjection`):**
   - Projects WGS84 GPS coordinates (spanning $40.5^\circ\text{N} - 42.9^\circ\text{N}$ latitude and $0.15^\circ\text{E} - 3.35^\circ\text{E}$ longitude) into normalized 2D canvas coordinates.
   - Formats GPS coordinates for display in Catalan format (e.g., `42.18° N, 1.85° E`).
3. **Specimen-Specific 16-Bit Pixel Art Pins (`JournalMapMarker`):**
   - Instead of generic emojis, each map marker renders the exact specimen's 16-bit sprite:
     - Mushrooms: `assets/images/mushrooms/{boletId}.png` (e.g. Rovelló, Cep, Rossinyol).
     - Indicator Trees: `assets/images/trees/{arbreId}.png` (e.g. Pi roig, Alzina, Faig).
   - Rendered on a circular white coin badge with arcade borders (`RetroColors.arcadeRed` for bolets, `RetroColors.forestGreen` for arbres), a triangular pointer tip, a tiny confidence percentage pill, and an animated pulsating gold aura when selected.
4. **Retro Pixel Art Filter Chips:**
   - Horizontal filtering bar allowing users to isolate finds:
     - `Tots (N)`
     - `[PixelBoletIcon] Bolets (N)`
     - `[PixelArbreIcon] Arbres (N)`
   - Non-GPS indicator pill displaying the count of observations made without GPS.
5. **Preview Inspection HUD:**
   - Tapping any pin anchors the selection and opens an elevated inspection HUD at the bottom.
   - Displays species thumbnail (falling back to specific pixel art sprite if no camera photo was saved), confidence badge, timestamp, exact GPS coordinates, altitude, and a "Veure Detall" button opening the full `AvistamentDetailSheet`.
6. **No-GPS Empty State Overlay:**
   - If the user has logged sightings but none contain GPS coordinates, displays an informative retro dialog explaining that findings will appear automatically once GPS is captured.

---

## 🔍 Sighting Detail Sheet (`AvistamentDetailSheet`)

Tapping any sighting from the Journal or from the Boscdex captures gallery opens a dedicated inspection sheet (comfortably positioned below the iOS status bar with swipe-to-dismiss drag handle):

1. **High-Resolution Zoomable Photo:** Uses Flutter's `InteractiveViewer` to allow foragers to pinch-to-zoom and pan across the cap, gills, stipe, bark, or foliage to re-verify diagnostic traits.
2. **AI Coincidence Gauge:** Displays the exact confidence score (e.g. `89% de coincidència neural`), a visual progress bar, and a safety status note (validating against the Series 011 edge models).
4. **Expedition Metadata:** Formatted date and time, altitude above sea level, GPS coordinates (if available), and custom user notes.
5. **Action Toolbar:**
   * 💾 **Descarregar Foto:** Directly writes the image to the device's native photo library/camera roll via [`PhotoExportService`](file:///Users/jordi/dev/boscdex/lib/domain/services/photo_export_service.dart) (`image_gallery_saver`).
   * 📤 **Compartir:** Opens the operating system's native share sheet via `share_plus` (AirDrop, WhatsApp, Save to Files, Messages).
   * 🗑️ **Eliminar:** Prompts a confirmation dialog before permanently deleting the sighting record from SQLite and unlinking the physical JPEG file from disk.
