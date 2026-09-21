# Machine Learning Training Pipeline

This document explains how the offline classifier dataset is assembled, preprocessed, fine-tuned, and exported into an INT8 TFLite model.

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
│   • RandomErasing / Cutout (simulating pine needle occl.)   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 3. Transfer Learning Training               │
│   MediaPipe Model Maker (EfficientNet-Lite0)                │
│   python tools/training/train_classifier.py                 │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                 4. INT8 Quantization Export                 │
│   TFLite Full Integer Quantization with calibration samples │
│   python tools/export/quantize_export.py                    │
│   Outputs: boscdex_classifier.tflite (<18 MB)               │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Step-by-Step Instructions

### 1. Download Catalan Fungal Observations
Run the automated downloader targeting the 39 priority taxa in `species_list.csv`:

```bash
cd tools/dataset
pip install pyinaturalist requests tqdm pillow
python download_inat.py --species-csv species_list.csv --output-dir ./dataset --place-id 7525
```

### 2. Fine-Tune EfficientNet-Lite0
Using MediaPipe Model Maker:

```bash
cd tools/training
pip install mediapipe-model-maker tensorflow
python train_classifier.py --dataset-dir ../dataset/dataset --output-dir ./export --epochs 15 --batch-size 32
```

### 3. Quantize and Verify Model Size
If training via custom TensorFlow/Keras or PyTorch export:

```bash
cd tools/export
python quantize_export.py \
  --saved-model ../training/export/saved_model \
  --representative-dataset ../dataset/dataset \
  --output ../../assets/models/boscdex_classifier.tflite
```

Verify that the final `.tflite` model size is under the 18 MB budget to ensure fast launch times and light memory footprint on mobile devices.
