# Edge Machine Learning Architecture

Boscdex executes computer vision classification **strictly on-device** using quantized TensorFlow Lite / LiteRT models.

---

## 🎯 Model Specifications

| Parameter | Specification |
|---|---|
| **Base Architecture** | MobileNetV2 GAP Feature Extractor + Native Dart Linear Head |
| **Quantization** | Full INT8 Post-Training Quantization (PTQ) |
| **Target Size** | $< 18 \text{ MB}$ (Current: 2.41 MB backbone + 375.3 KB head) |
| **Input Resolution** | $224 \times 224 \times 3$ (RGB) with 3-View Test-Time Augmentation (TTA) |
| **Target Inference Latency** | $< 150 \text{ ms}$ on mid-tier Android (API 26+) / Apple Neural Engine (iOS 15+) |
| **Classes (Target Taxonomy)** | 75 cataloged Catalan mushroom species (Series 020) |

---

## ⚡ Hardware Acceleration Delegates

1. **iOS (Apple CoreML Delegate):**
   * Automatically delegates convolutional layers to the Apple Neural Engine (ANE) on A11+ Bionic chips.
   * Negligible battery drain during continuous scanning sessions.

2. **Android (NNAPI / GPU Delegate):**
   * Uses Android Neural Networks API (NNAPI) fallback or Qualcomm Adreno / ARM Mali GPU delegates for sub-100ms classification times.

---

## 🛡️ Inference Pipeline & Safety Gating

```
Raw Camera Frame (YUV420 / RGBA)
       │
       ▼
3-View Test-Time Augmentation (TTA):
   ├─ View 1 (55%): Full Frame Center-Crop (224x224)
   ├─ View 2 (25%): Horizontal Mirror Flip (224x224)
   └─ View 3 (20%): 80% Central Macro-Crop (224x224)
       │
       ▼
Intensity Normalization (INT8 [-128, 127] or UInt8 [0, 255])
       │
       ▼
TFLite Interpreter Execution (CoreML/GPU delegate)
MobileNetV2 Feature Extractor -> GAP Embeddings
       │
       ▼
TTA Weighted Feature Embedding Fusion:
F_fused = 0.55 * F_full + 0.25 * F_flip + 0.20 * F_macro
       │
       ▼
Native Dart Linear Head Dot-Product (240.8 KB head.bin):
Score_i = Sum(F_fused_j * W_i,j) + B_i  (<0.05 ms)
       │
       ▼
Softmax Top-3 Candidates Extraction
       │
       ▼
SafetyGateService Evaluation:
   ├─ If Top-1 Confidence < 0.70:
   │     ⚠️ Trigger "Incert" Low-Confidence Alert
   │
   └─ If Top-1 has toxic_lookalikes in SQLite:
         ⚠️ Trigger "Alerta de Confusió Perillosa" Safety Box
```

---

## 🔄 Decoupled Service Architecture

The Flutter codebase interacts with the computer vision subsystem via an abstract `ClassifierService` contract:

```dart
abstract class ClassifierService {
  /// Classifies a mushroom image and returns ranked candidate predictions.
  Future<List<MushroomClassificationResult>> classifyMushroom(
      Uint8List imageBytes);

  /// Backwards-compatible alias for [classifyMushroom].
  Future<List<MushroomClassificationResult>> classify(Uint8List imageBytes);

  /// Classifies an indicator tree image and returns ranked candidate predictions.
  Future<List<TreeClassificationResult>> classifyTree(Uint8List imageBytes);

  Future<void> initialize();
  void dispose();
}
```

This decoupled abstraction supports three progressive implementations:
1. **`TfliteClassifierService` (Active in v1.5 Production):** Executes on-device MobileNetV2 GAP feature extraction combined with high-performance Dart linear classification heads for both mushrooms and indicator trees.
   * **Mushroom Neural Classifier:** Evaluated on 75 taxa using `assets/models/mushroom_classifier.tflite` + `assets/models/mushroom_classifier_head.bin` with 3-View TTA and Proximal Head Calibration. Verified at **94.9% Top-1** (996/1,049) and **99.0% Top-3** (1,038/1,049) accuracy across 1,049 real field photos (Series 021), and **100.0% Top-1 & Top-3** (75/75) across all 75 canonical botanical reference photos (`assets/images/reference/`).
   * **Tree Neural Classifier:** Evaluated on 5 indicator tree taxa using `assets/models/tree_classifier.tflite` + `assets/models/tree_classifier_head.bin`. Lazy-loaded on first tree scan request to conserve RAM. Verified at **80.0% Top-1** and **96.0% Top-2** accuracy across 79 real field photos.
2. **`VisualFeatureClassifierService` (Graceful Fallback):** Real-time fallback analyzing camera frames by downscaling to $32 \times 32$ via `dart:ui.instantiateImageCodec`, computing HSV chromatic distribution histograms, and scoring against regional botanical profiles (100% offline, zero native binary dependencies).
3. **`MockClassifierService`:** A deterministic round-robin scenario cycle used for rapid headless UI prototyping and reproducible unit tests.

> **Production Model Bundles in `assets/models/`:**  
> The `assets/models/` directory contains production-calibrated edge assets fine-tuned on real field photos + iNaturalist observations:
> - **Mushroom Backbone & Head:**
>   - `mushroom_classifier.tflite` (2.41 MB): MobileNetV2 feature extractor (1,280 GAP features).
>   - `mushroom_classifier_head.bin` (375.3 KB / 384,300 bytes): Float32 projection matrix ($75 \times 1280$) and biases evaluated in $<0.05\text{ ms}$.
>   - `mushroom_labels.txt` (75 classes): Ordered taxonomic label index mapping neural logits to entity IDs.
> - **Indicator Tree Backbone & Head:**
>   - `tree_classifier.tflite` (2.50 MB): MobileNetV2 backbone for tree foliage/bark feature extraction.
>   - `tree_classifier_head.bin` (25.6 KB): Calibrated Float32 projection matrix ($5 \times 1280$) and biases for the 5 indicator tree species.
>   - `tree_labels.txt` (5 classes): Ordered tree taxonomic labels (`pinus_sylvestris`, `pinus_halepensis`, `quercus_ilex`, `fagus_sylvatica`, `castanea_sativa`).

---

## 🧪 Golden Set Empirical Evaluation & Model Testing

To evaluate and track model refinement objectively across iterations, the project maintains on-device **Golden Validation Sets**:
- **Mushroom Field Golden Set:** `test/assets/mushrooms/` (1,049 real high-resolution field photographs across all 75 Catalan taxa).
  - Regression Test: [`test/unit_tests/domain/mushroom_model_real_images_test.dart`](file:///Users/jordi/dev/boscdex/test/unit_tests/domain/mushroom_model_real_images_test.dart).
  - Benchmark (Series 021): **94.9% Top-1** (996/1,049), **99.0% Top-3** (1,038/1,049).
  - Execution Command: `flutter test test/unit_tests/domain/mushroom_model_real_images_test.dart`.
- **Botanical Reference Photos Benchmark:** `assets/images/reference/` (75 curated open-licensed CC botanical reference photos displayed in the app).
  - Regression Test: [`test/unit_tests/domain/mushroom_model_reference_images_test.dart`](file:///Users/jordi/dev/boscdex/boscdex/test/unit_tests/domain/mushroom_model_reference_images_test.dart).
  - Benchmark (Series 021): **100.0% Top-1** (75/75), **100.0% Top-3** (75/75).
  - Execution Command: `flutter test test/unit_tests/domain/mushroom_model_reference_images_test.dart`.
- **Tree Golden Set:** `test/assets/trees/` (79 real field photographs across all 5 indicator tree species).
  - Regression Test: [`test/unit_tests/domain/tree_model_real_images_test.dart`](file:///Users/jordi/dev/boscdex/test/unit_tests/domain/tree_model_real_images_test.dart).
  - Benchmark: **80.0% Top-1**, **96.0% Top-2** (Phase 2 validation).
  - Execution Command: `flutter test test/unit_tests/domain/tree_model_real_images_test.dart`.

---

## 📸 Field Photo Persistence & Inspection System

Whenever an inference scan is performed (via camera or photo picker) and registered by the user:
1. **Physical Image Persistence:** High-resolution image bytes are preserved permanently in the local filesystem at `<appDocumentsDir>/scans/scan_<uuid>.jpg` with atomic writes.
2. **Database Schema Linkage:** The SQLite `Avistaments` record stores the relative/absolute `photoPath` alongside the neural network's `confidenceScore` and UTC timestamp, ordered descending in `AvistamentDao`.
3. **El Meu Diari (Chronological Feed):** Each journal card dynamically prioritizes real field photo thumbnails over stock pixel art, displaying real-time confidence pills (e.g. `[ 89% ]`) with color coding.
4. **La Boscdex (Species Album Integration):** Each specimen sheet ([`bolet_detail_screen.dart`](file:///Users/jordi/dev/boscdex/lib/presentation/detail/bolet_detail_screen.dart)) features a dedicated **"Les Teves Captures"** horizontal photo gallery displaying all user-scanned specimens of that species with dates and confidence badges.
5. **Interactive Sighting Sheet ([`avistament_detail_sheet.dart`](file:///Users/jordi/dev/boscdex/lib/presentation/journal/avistament_detail_sheet.dart)):**
   - **Interactive Zoom:** Pinch-to-zoom and pan via `InteractiveViewer`.
   - **Neural Confidence Breakdown:** Progress gauge, confidence score %, and safety advisory.
   - **Download to Photos:** Exports the photo directly to the device's camera roll/gallery using [`PhotoExportService`](file:///Users/jordi/dev/boscdex/lib/domain/services/photo_export_service.dart) via `image_gallery_saver`.
   - **System Sharing:** Native iOS/Android share sheet integration via `share_plus` (AirDrop, WhatsApp, Save to Files).
   - **Safe Deletion:** Cascading removal of both the database record and local disk file.
