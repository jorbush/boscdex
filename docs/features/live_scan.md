# Live Scan Viewfinder Feature

The **Live Scan** tab (`/scan`) provides the visual viewfinder used for identifying wild specimens directly in the field using on-device computer vision and native camera hardware.

---

## 📷 Viewfinder & Hardware Architecture

* **Native Camera Controller (`camera` package):**
  * Automatically detects and initializes the primary rear camera (`CameraLensDirection.back`) with high-resolution capture (`ResolutionPreset.high`).
  * Live camera feed rendered through `CameraPreview` inside the retro-styled 270x270 targeting frame with rounded corners and comic-style ink borders.
  * Custom retro vector overlay (`_CornerBracketPainter`) drawing arcade targeting brackets and center reticle.
* **Lifecycle Management (`WidgetsBindingObserver`):**
  * Pauses and disposes the camera sensor when the app enters `AppLifecycleState.inactive` or background to preserve battery life and release device resources.
  * Automatically re-initializes upon `AppLifecycleState.resumed`.
* **Mode Switcher:** Segmented selector at the top switching between:
  * `[ Bolets ]`: Evaluates fungal specimens via `classifier.classifyMushroom()` and displays `ClassificationResultSheet`.
  * `[ Arbres ]`: Evaluates indicator trees via `classifier.classifyTree()` and displays `TreeClassificationResultSheet`.
* **Shutter Action:**
  * Circular 3D retro arcade shutter button triggering `_cameraController.takePicture()`.
  * Extracts captured image bytes (`Uint8List`) and pipes them into edge AI inference with visual scanline animation (`ANALITZANT AMB EDGE-AI...`).
* **Gallery Photo Picker (`image_picker` package):**
  * Retro cartridge icon on the bottom left allowing the user to select existing field photos from the device camera roll / photo library.
* **Permission Fallbacks:**
  * When camera permissions are denied, displays a friendly retro prompt explaining why the permission is needed with a "Demanar permís" CTA.
  * When permanently denied, provides a direct "Obrir Paràmetres" button linking to system settings (`openAppSettings()`).
  * On simulators or devices without camera sensors, gracefully falls back to mock inference and gallery picking without crashing.

---

## 🔐 Platform Permissions Architecture

### iOS (`ios/Runner/Info.plist` & `ios/Podfile`)
* **Privacy Descriptions in `Info.plist`:**
  * `NSCameraUsageDescription`: Required for real-time live viewfinder and specimen photography.
  * `NSPhotoLibraryUsageDescription`: Required for picking photos from the user's photo album.
  * `NSPhotoLibraryAddUsageDescription`: Required for saving scanned field photos to the user's Camera Roll / Photo Library.
  * `NSMicrophoneUsageDescription`: Declared to satisfy AVFoundation video frameworks.
  * `NSLocationWhenInUseUsageDescription`: Required for GPS coordinates in sighting journal.
  * `NSLocationAlwaysAndWhenInUseUsageDescription`: Required for location services on iOS.
* **CocoaPods Preprocessor Flags (`ios/Podfile`):**
  * `permission_handler` on iOS uses conditional compilation. The `post_install` hook defines:
    ```ruby
    config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
      '$(inherited)',
      'PERMISSION_CAMERA=1',
      'PERMISSION_PHOTOS=1',
      'PERMISSION_LOCATION=1',
    ]
    ```
    This ensures native permission requests trigger iOS's system dialog and register toggles in the iPhone Settings app.

### Android (`android/app/src/main/AndroidManifest.xml`)
* **Permissions & Features:**
  * `android.permission.CAMERA`: Required for camera access.
  * `android.hardware.camera` & `android.hardware.camera.autofocus` (`required="false"`): Allows app installation on devices without autofocus hardware.
  * `android.permission.ACCESS_FINE_LOCATION` & `ACCESS_COARSE_LOCATION`: For GPS tagging in sighting logs.
  * `android.permission.READ_EXTERNAL_STORAGE` (`maxSdkVersion="32"`) & `android.permission.READ_MEDIA_IMAGES`: Dual support for legacy Android and Android 13+ (API 33+) photo picking.

---

## 📊 Fungi Classification Result Sheet (`ClassificationResultSheet`)

Upon scanning a mushroom, the on-device model evaluates the image and presents a modal bottom sheet:

1. **Top Candidate Card:**
   * Catalan vernacular name and scientific binomial.
   * Confidence percentage badge (e.g., `91% coincidència`).
   * Edibility badge with color and icon.
2. **Alternative Candidates (Rank 2 & 3):**
   * Displays the next two runner-up candidate species with relative linear progress bars to guard against misclassification.
3. **Safety Gate Warnings:**
   * Evaluated automatically by `SafetyGateService` (see [Safety and Toxic Lookalikes](safety_and_toxic_lookalikes.md)).
4. **Live GPS Coordinates Pill:**
   * Shows real-time WGS84 coordinates (e.g., `42.18° N, 1.85° E`) and altitude (`850 m`), or `Sense senyal GPS` if unavailable.
5. **Action CTA ("Registrar a la meva Boscdex"):**
   * Persists the captured high-resolution photograph to local device storage at `<appDocumentsDir>/scans/scan_<uuid>.jpg`.
   * Inserts a new sighting into SQLite `Avistaments` linking the exact `photoPath`, `confidenceScore`, and GPS coordinates (`latitude`, `longitude`, `altitude`).
   * Unlocks the specimen in `Descobriments` if encountering it for the first time.
   * Re-evaluates badge conditions and updates `Insignies`.
   * Synchronizes the new capture with both **El Meu Diari** (`/journal`) and the species' **"Les Teves Captures"** gallery in **La Boscdex** (`/boscdex/:id`).
   * Displays instant feedback and dismisses the sheet.

---

## 🌲 Tree Classification Result Sheet (`TreeClassificationResultSheet`)

When in **Arbres** mode, scanning an indicator tree presents:

1. **Top Indicator Tree Card:**
   * Catalan and scientific names (e.g., *Pinus sylvestris* - Pi roig).
   * Confidence score badge.
   * Diagnostic botanical traits: needle/leaf type, bark description, and typical soil.
2. **Symbiotic Fungi Section ("Bolets que pots cercar sota aquest arbre"):**
   * Direct chips of associated mushrooms linked via mycorrhizal relations (e.g., Rovelló under Pi roig).
   * Tapping any associated mushroom opens its Boscdex entry.
3. **Live GPS Coordinates Pill:**
   * Displays real-time field coordinates and altitude.
4. **Registration Action ("Registrar troballa al Diari"):**
   * Persists tree observation into `Avistaments` with photo, confidence, and GPS coordinates (`latitude`, `longitude`, `altitude`).
5. **Habitat & Tree Profile Action:**
   * "Veure fitxa completa de l'arbre" button tracks the tree as visited (contributing towards the "Aliança Silvestre" badge) and navigates to the detailed tree profile (`/arbre/:id`).
