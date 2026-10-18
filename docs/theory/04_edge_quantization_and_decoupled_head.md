# 📱 Chapter 4: Edge Quantization & Decoupled Architecture

In traditional cloud machine learning, when a user uploads a photo, it travels across the internet to a massive server farm equipped with multi-thousand-dollar NVIDIA GPUs running Python.

In **Boscdex**, there is **zero cloud**. The user might be deep in a valley in the Montseny or Pyrenees with **no cellular reception, zero internet connection, and airplane mode turned on**.

The entire AI model must run **100% offline directly on the user's phone**. This presents unique constraints that shape how our model is packaged and executed.

---

## 1. Why Can't We Just Run Python on the Phone?

1. **No Python Runtime on Mobile:** Neither iOS (Swift/Objective-C) nor Android (Kotlin/Java) natively ship with Python. Embedding a full Python interpreter inside a mobile app increases app size by hundreds of megabytes, drains battery, and violates Apple App Store execution guidelines.
2. **TensorFlow is Huge:** Standard desktop TensorFlow is a massive library (>500 MB) compiled with complex C++ and CUDA dependencies.

To solve this, Google created **TensorFlow Lite (TFLite) / LiteRT**:
* A tiny, stripped-down C++ inference engine (~1.5 MB runtime).
* Models are saved as binary **FlatBuffers** (`.tflite` files) that can be memory-mapped (`mmap`) directly into RAM without unpacking.
* Directly talks to phone hardware accelerators: **Apple Neural Engine (ANE)** via CoreML on iPhone, and **NNAPI / GPU** on Android.

---

## 2. Quantization: Shrinking Models from Float32 to INT8

In standard Python training on Google Colab, all numbers (weights, biases, activations) are stored as **32-bit Floating Point (`Float32`)**:
* Every single number takes up **4 bytes** (32 bits) of memory.
* An average neural network has millions of numbers, resulting in model files of 50 MB to 200 MB.

### The Quantization Insight
Do we really need 32 bits of precision (like `0.428194829104`) to distinguish a *Cep* from a *Farinera borda*?

**No.** In real life, an 8-bit integer (`INT8`, range `-128` to `+127`, taking only **1 byte**) is more than enough to capture the necessary morphological contrast!

```
    Float32 (32 bits = 4 bytes per weight)      INT8 (8 bits = 1 byte per weight)
    ┌───────────────────────────────┐           ┌───────┐
    │ 0 1 0 0 0 0 1 0 1 1 0 1 0 ... │  ──────►  │ 0 1 1 │ (4x Smaller!)
    └───────────────────────────────┘           └───────┘
```

### The Math of Post-Training Quantization (PTQ)
Quantization maps floating-point numbers to integers using a **Scale Factor ($S$)** and a **Zero Point ($Z$)**:

$$\text{Real Float Value} \approx S \times (q - Z)$$

Where $q \in [-128, 127]$ is the quantized 8-bit integer.

### The Benefits for Mobile Apps:
1. **$4\times$ Storage Reduction:** A model that weighed 10 MB shrinks to **~2.5 MB**! (Fits easily over cellular updates and well under our 18 MB budget).
2. **$4\times$ Memory Bandwidth Reduction:** The phone's CPU/NPU can load the entire model directly into high-speed on-chip cache (L2/L3 cache), eliminating RAM bottlenecks.
3. **Hardware Acceleration:** Mobile CPUs and NPUs execute integer arithmetic ($8\text{-bit integer additions and multiplications}$) **$3\times$ to $6\times$ faster** than 32-bit floating point math, with negligible battery consumption.

---

## 3. The Real-World Mobile Edge Dilemma: Opcode Version Drift

During the development of Boscdex (documented in [Series 002 and 003 of our Research Trials](file:///Users/jordi/dev/boscdex/docs/research/empirical_scan_trials.md)), we discovered a major real-world friction point in mobile edge ML:

1. **Modern Training Frameworks (Colab / TF 2.16+):**  
   When TensorFlow converts an end-to-end model with a Dense layer to TFLite, it uses the newest TFLite operator specifications: `FULLY_CONNECTED` **Opcode Version 12**, equipped with per-channel (per-axis) dynamic scaling.
2. **Mobile App C Runtimes (`tflite_flutter`):**  
   The underlying C shared libraries compiled into Flutter plugins (TFLite C Runtime v2.12) only support `FULLY_CONNECTED` up to **Opcode Version 9**.

When the mobile app attempted to run the end-to-end model:
* On some devices, the app threw a registration failure: `Didn't find op for builtin opcode 'FULLY_CONNECTED' version '12'`.
* On other devices, the TFLite runtime silently skipped the matrix multiplication ($W \cdot x = 0$), outputting only the raw biases—causing the infamous **"Camagroc 5%" bug** where every scan predicted Camagroc!

How did we solve this permanently?

---

## 4. The Boscdex Solution: The Decoupled GAP Architecture

Instead of fighting TFLite runtime C-library version mismatches, Boscdex uses an elegant architectural pattern: **The Decoupled Classifier**.

We split the model into two specialized pieces:

```
                      CAMERA FRAME (224x224x3)
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ PART 1: Hardware-Accelerated Feature Extractor                  │
│ Asset: assets/models/mushroom_classifier.tflite (2.50 MB)       │
│ Engine: TFLite C Interpreter (MobileNetV2, 64 Conv Layers)      │
│ Output: 1,280 Global Average Pooling (GAP) Float32 Features     │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                 1,280 Features (GAP Float32 Vector)
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│ PART 2: Portable Linear Classification Head                     │
│ Asset: assets/models/mushroom_classifier_head.bin (240.8 KB)    │
│ Engine: Pure Native Dart in TfliteClassifierService             │
│ Operation: Dot Product (W • x + b)                              │
│ Latency: < 0.05 ms (< 50 microseconds!)                         │
│ Output: 47 Species Logits -> Numerically Stable Softmax         │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
                   TOP-3 CANDIDATE PREDICTIONS
```

### How Part 1 Works (`mushroom_classifier.tflite`):
In [`notebooks/boscdex_mushroom_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_mushroom_training_colab.ipynb), we slice the trained model right at the output of the GAP layer:

```python
gap_model = tf.keras.Model(inputs=model.input, outputs=model.get_layer("gap_features").output)
converter = tf.lite.TFLiteConverter.from_keras_model(gap_model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_gap = converter.convert()
```
Because this model contains only convolutional and pooling operations (which have been standardized in TFLite since v1.0), it is **100% compatible with every mobile operating system, iOS version, and Android phone on earth**.

### How Part 2 Works (`mushroom_classifier_head.bin`):
We export the Dense layer's weights and biases into a tiny raw binary file:
* **47 Biases:** 47 float32s $\times$ 4 bytes = 188 bytes.
* **Weights Matrix:** 47 classes $\times$ 1,280 features $\times$ 4 bytes = 240,640 bytes.
* **Total File Size:** Exactly **240,828 bytes (~240.8 KB)**.

In [`lib/domain/services/tflite_classifier_service.dart`](file:///Users/jordi/dev/boscdex/lib/domain/services/tflite_classifier_service.dart), the classification dot product runs directly in native Dart:

```dart
final logits = List<double>.generate(numClasses, (i) {
  double sum = _biases![i];
  final rowOffset = i * _featureDim;
  for (int j = 0; j < _featureDim; j++) {
    sum += _weights![rowOffset + j] * gapFeatures[j];
  }
  return sum;
});
```

### Advanced On-Device Inference: 3-View Test-Time Augmentation (TTA)
In production, instead of passing a single camera frame through Part 1, `TfliteClassifierService` generates **3 complementary views** in memory:
1. Full Frame ($0.55$)
2. Horizontal Mirror ($0.25$) — exploiting basidiocarp radial symmetry
3. 80% Central Macro Crop ($0.20$) — suppressing peripheral forest floor clutter

The three 1,280-D vectors are fused into a single representation before projecting through Part 2. See [Chapter 6: Modern Optimization & TTA](06_modern_optimization_and_tta.md) for full mathematical formulation.

### Why This Architecture is a Masterstroke:
1. **Ultra-Fast Execution:** Computing 60,160 floating-point multiplications in Dart takes less than **0.05 milliseconds** ($< 50 \mu\text{s}$). It is completely imperceptible to the human eye.
2. **Zero Version Incompatibility:** Dart runs everywhere Flutter runs. No C++ FlatBuffer opcode incompatibilities can ever break the classification head.
3. **Instant Model Calibrations:** If we ever want to fine-tune the classifier head on new species or adjust biases for safety lookalikes, we only need to update a tiny 240.8 KB file rather than re-exporting and re-validating the entire TFLite graph!
