# Edge Machine Learning Architecture

Boscdex executes computer vision classification **strictly on-device** using quantized TensorFlow Lite / LiteRT models.

---

## 🎯 Model Specifications

| Parameter | Specification |
|---|---|
| **Base Architecture** | EfficientNet-Lite0 / MobileNetV4 |
| **Quantization** | Full INT8 Post-Training Quantization (PTQ) |
| **Target Size** | $< 18 \text{ MB}$ (fits easily on budget devices) |
| **Input Resolution** | $224 \times 224 \times 3$ (RGB) or $256 \times 256 \times 3$ |
| **Target Inference Latency** | $< 150 \text{ ms}$ on mid-tier Android (API 26+) / Apple Neural Engine (iOS 15+) |
| **Classes (Target Taxonomy)** | 60–80 prominent Catalan mushroom species |

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
Downscale & Center-Crop to 224x224
       │
       ▼
Intensity Normalization (INT8 [-128, 127] or UInt8 [0, 255])
       │
       ▼
TFLite Interpreter Execution (CoreML/GPU delegate)
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
  Future<List<ClassificacioResult>> classify(Uint8List imageBytes);
  Future<List<ArbreClassificacioResult>> classifyTree(Uint8List imageBytes);
  Future<void> initialize();
  void dispose();
}
```

This decoupled abstraction supports three progressive implementations:
1. **`TfliteClassifierService` (Active in v0.3 Production):** Executes on-device MobileNetV2 GAP feature extraction (`assets/models/boscdex_classifier.tflite`) combined with a high-performance Dart linear classification head (`assets/models/classifier_head.bin`). Verified at **88.8% Top-1** and **97.3% Top-3** accuracy across 188 real Catalan field photos (21 taxa).
2. **`VisualFeatureClassifierService` (Graceful Fallback):** Real-time fallback analyzing camera frames by downscaling to $32 \times 32$ via `dart:ui.instantiateImageCodec`, computing HSV chromatic distribution histograms, and scoring against regional botanical profiles (100% offline, zero native binary dependencies).
3. **`MockClassifierService`:** A deterministic round-robin scenario cycle used for rapid headless UI prototyping and reproducible unit tests.

> **Production Model Bundle in `assets/models/`:**  
> The `assets/models/` directory contains the production-calibrated model bundle fine-tuned on real Catalan field photos + iNaturalist observations:
> - `boscdex_classifier.tflite` (2.50 MB): Hardware-accelerated MobileNetV2 deep learning backbone (64 layers) outputting 1,280 Global Average Pooling (GAP) features.
> - `classifier_head.bin` (107.6 KB): Fast, universal Float32 projection matrix ($21 \times 1280$) and biases evaluated in Dart in $<0.05\text{ ms}$, ensuring 100% platform portability across all iOS/Android TFLite C runtime versions.
> - `labels.txt` (21 classes): Ordered taxonomic label index mapping neural logits to database entity IDs, including Dex #022 *Chroogomphus rutilus*.

---

## 🧪 Golden Set Empirical Evaluation & Model Testing

To evaluate and track model refinement objectively across iterations, the project maintains an on-device **Golden Validation Set**:
- **Test Asset Directory:** `test/assets/` (contains 214 real high-resolution field photographs across all 21 Catalan taxa, including *Hygrophorus latitabundus*, *Lactarius deliciosus*, *Boletus edulis*, *Chroogomphus rutilus*, etc.).
- **Automated Regression Suite:** [`test/unit_tests/domain/model_real_images_test.dart`](file:///Users/jordi/dev/boscdex/test/unit_tests/domain/model_real_images_test.dart).
- **Execution Command:** `flutter test test/unit_tests/domain/model_real_images_test.dart`.
- **Current Benchmark (Series 011):** **86.4% Top-1** (185/214), **93.9% Top-3** (201/214) with 0.0% un-gated safety false negatives. Evaluates all 214 images in under 60 seconds directly in unit testing.

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
