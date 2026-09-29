# Machine Learning Training Pipeline & Dataset Strategy

This document details the offline classifier dataset assembly, model training workflow, and dataset curation strategies to maximize real-world computer vision accuracy.

---

## 📌 Current State vs. Production Roadmap

| Phase | Engine | Model Location | Description |
|---|---|---|---|
| **v0.1** | `MockClassifierService` | Memory | Hardcoded circular mock used for initial UI prototyping. |
| **v0.2** | `VisualFeatureClassifierService` | Code (`dart:ui`) | Real-time on-device pixel analysis (HSV chromaticity and botanical morphology). Zero external dependencies, 100% offline. |
| **v0.3 (Production)** | Edge Deep Learning (`.tflite` + Dart Head) | `assets/models/` | MobileNetV2 GAP feature extractor + Dart linear head fine-tuned on real Catalan field photos. **87.1% Top-1, 93.8% Top-3** on 225 field test photos (21 classes, Series 013). |

> **Model Weights Status in `assets/models/`:**  
> The `assets/models/` directory contains the production-calibrated model bundle trained via Google Colab T4 GPU:
> - `mushroom_classifier.tflite` (2.50 MB): Quantized MobileNetV2 backbone (64 layers) outputting 1,280 Global Average Pooling (GAP) features.
> - `mushroom_classifier_head.bin` (107.6 KB): Portable Float32 weight matrix ($21 \times 1280$) and biases evaluated in Dart in $<0.05\text{ ms}$, ensuring 100% cross-platform compatibility across iOS and Android without TFLite opcode version mismatches.
> - `mushroom_labels.txt` (21 classes): Ordered taxonomic label index mapping neural logits to database entity IDs, including Dex #022 *Chroogomphus rutilus*.
> - **Field Validation (Series 013):** Evaluated against 225 real field photos (`test/assets/mushrooms/`), achieving **87.1% Top-1** (196/225) and **93.8% Top-3** (211/225) accuracy.


---

## 🔄 End-to-End ML Pipeline

```
┌─────────────────────────────────────────────────────────────┐
│                 1. iNaturalist Open Data                    │
│   Download research-grade observations (place_id=7525)      │
│   python tools/dataset/download_inat.py                     │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 2. Augmentation & Curation                  │
│   • 360° Rotations (radial symmetry of caps)                │
│   • ColorJitter (canopy shade vs direct sunlight)           │
│   • RandomErasing / Cutout (pine needle & moss occlusion)   │
│   • Hard Negatives & OOD Forest Floor Backgrounds           │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 3. Transfer Learning Training               │
│   MediaPipe Model Maker / PyTorch (EfficientNet-Lite0)      │
│   python tools/training/train_classifier.py                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 4. INT8 Quantization Export                 │
│   TFLite Full Integer Quantization with calibration samples │
│   python tools/export/quantize_export.py                    │
│   Outputs: assets/models/mushroom_classifier.tflite (<18 MB)│
└─────────────────────────────────────────────────────────────┘
```

---

## 📸 How to Improve Model Accuracy: Dataset Strategy

A common assumption in computer vision is: *"To improve accuracy, we just need to download thousands more images."*  
In field mycology, **sheer image count is only one factor—dataset diversity, angle coverage, and lifecycle variation matter far more.**

### 1. Volume Guidelines (The Sweet Spot)
* **Under 100 images/species:** Severe overfitting. The model memorizes individual backgrounds (specific moss or grass patches) rather than morphological features.
* **250–400 images/species:** **The ideal target.** Provides sufficient intra-class variance for transfer learning on EfficientNet-Lite0 without bloating training time or storage.
* **1,000+ images/species:** Diminishing returns. Accuracy gains plateau (<2–3% boost) while training time quadruples. Focus instead on image diversity.

### 2. Mandatory Morphological Angles
Mushrooms **cannot** be reliably classified from a single top-down cap view. The training set must include diverse viewpoints for every species:
* **Top-down view (40%):** Cap color, concentric rings (*Rovelló*), scales (*Apagallums*), viscidity/slime (*Llenega negra*).
* **Underside / Hymenium view (30%):** True gills (*làmines*), false ridges/folds (*Rossinyol*), sponge tubes/pores (*Cep*), spines (*Llengua de bou*).
* **Stem & Base view (20%):** Volval sac at base (*Ou de reig* vs *Amanita phalloides*), stem ring (*anell*), reticulation network (*Cep*).
* **Cross-section / Cut view (10%):** Flesh color changes, latex emission (carrot-orange of *Lactarius deliciosus* vs wine-red of *L. sanguifluus*).

### 3. Lifecycle & Phenological Stages
Fungi undergo dramatic morphological changes between emergence and senescence:
* **Primordium / Button ("Ou") stage:** *Amanita caesarea* begins as a closed white egg before the orange cap erupts.
* **Young / Convex stage:** Hemisphere cap with inrolled margin.
* **Mature / Expanded stage:** Flat, funnel-shaped, or cracked caps.
* **Weathered / Old stage:** Washed-out colors after heavy rain or sun bleaching.
If the training dataset only contains pristine mature specimens, field accuracy on young or weathered mushrooms drops significantly.

### 4. Environmental & Lighting Invariance
* **Lighting:** Forest canopy filtered shade, direct midday sun, overcast dawn.
* **Moisture:** Dry vs water-soaked caps. A rain-soaked *Hygrophorus latitabundus* (Llenega negra) exhibits strong specular reflections that confuse models trained only on dry photographs.
* **Substrate & Clutter:** Pine needles, oak leaves, rocks, limestone, sandy soil, moss.

### 5. Asymmetric Cost & Toxic Lookalikes (Safety-Critical Balancing)
In consumer apps, classifying a dog as a cat is harmless. In mycology, classifying a deadly *Amanita phalloides* as an edible *Amanita caesarea* or *Russula* can be fatal.
* **Oversampling Dangerous Lookalikes:** Toxic species (*Amanita phalloides*, *Amanita muscaria*, *Omphalotus olearius*, *Entoloma sinuatum*) must be oversampled and paired with high-quality comparison observations.
* **Class Weighting:** Apply higher cross-entropy loss penalties when the model confuses a toxic taxon with an edible one.

### 6. Negative & Out-of-Distribution (OOD) Samples ("Forest Floor Noise")
Include a dedicated **"Non-Mushroom / Background"** class (~500–1,000 images):
* Tree bark, pine needles, fallen leaves, bare dirt, hiker fingers/boots.
* **Why?** Without negative classes, if a user points the camera at their boot or a stone, a softmax classifier will force a prediction of a mushroom class with false confidence.

---

## 🛠️ Step-by-Step Training Instructions

### Step 1: Download Regional Catalan Observations
Run the automated downloader targeting the 39 priority taxa in `tools/dataset/species_list.csv`:

```bash
cd tools/dataset
pip install pyinaturalist requests tqdm pillow
python download_inat.py --species-csv species_list.csv --output-dir ./dataset --place-id 7525
```

### Step 2: Fine-Tune with MediaPipe Model Maker
Execute transfer learning on EfficientNet-Lite0:

```bash
cd tools/training
pip install mediapipe-model-maker tensorflow
python train_classifier.py --dataset-dir ../dataset/dataset --output-dir ./export --epochs 20 --batch-size 32
```

### Step 3: Quantize and Package to Mobile Assets
Export the calibrated INT8 model and copy to mobile assets:

```bash
cd tools/export
python quantize_export.py \
  --saved-model ../training/export/saved_model \
  --representative-dataset ../dataset/dataset \
  --output ../../assets/models/mushroom_classifier.tflite

cp ../training/export/labels.txt ../../assets/models/mushroom_labels.txt
```

Verify that the final `.tflite` model size is **under 18 MB** to guarantee rapid inference (<100ms) on mobile Neural Processing Units (Apple ANE / Android NNAPI).

---

## 🌲 Indicator Tree ML Training Pipeline (Phase 2)

Boscdex uses a unified, ultra-lightweight architecture for tree classification:

1. **Shared Feature Extractor:** Employs MobileNetV2 GAP backbone (`assets/models/tree_classifier.tflite` or shared feature extractor) generating 1,280 Float32 features.
2. **Dedicated Binary Head (`tree_classifier_head.bin`):** A compact linear layer ($5 \times 1280$ weights + 5 biases = 25,620 bytes) evaluated in pure Dart in $<0.05\text{ ms}$.
3. **Automated iNaturalist CLI:** Download field training and golden set photos using:
   ```bash
   python tools/dataset/download_trees_inat.py --count 50 --output dataset/trees
   ```
4. **Google Colab 1-Click Cloud Notebook:**
   The training workflow is pre-packaged in [`notebooks/boscdex_tree_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_tree_training_colab.ipynb). Run on a free T4 GPU to:
   - Download tree datasets directly from iNaturalist
   - Extract MobileNetV2 GAP embeddings with data augmentation
   - Train linear head with cosine annealing and L2 regularization
   - Plot confusion matrix and evaluate Top-1/Top-2 metrics
   - Export and download `tree_classifier_head.bin` and `tree_labels.txt` directly to `assets/models/`.
5. **Golden Set Empirical Accuracy:**
   Validated in [`test/unit_tests/domain/tree_model_real_images_test.dart`](file:///Users/jordi/dev/boscdex/test/unit_tests/domain/tree_model_real_images_test.dart) across 79 real Catalan field photos (Phase 2 validation: **80.0% Top-1**, **96.0% Top-2**):
   - *Castanea sativa*: 100% precision, 70% recall (f1: 0.82)
   - *Fagus sylvatica*: 69% precision, 85% recall (f1: 0.76)
   - *Pinus halepensis*: 90% precision, 90% recall (f1: 0.90)
   - *Pinus sylvestris*: 90% precision, 82% recall (f1: 0.86)
   - *Quercus ilex*: 57% precision, 67% recall (f1: 0.62)
