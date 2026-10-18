# 🚀 Google Colab Free-Tier Model Training Guide

This guide walks you through training the **Boscdex on-device classifier** on **Google Colab's Free Tier** using an NVIDIA T4 GPU.

---

## 💡 Why Google Colab Free Tier?

| Feature | Local Laptop (MacBook) | Google Colab (Free Tier) |
|---|---|---|
| **Cost** | Free | **$0.00 (100% Free, No Credit Card)** |
| **Hardware** | Laptop CPU | **NVIDIA Tesla T4 GPU (16 GB VRAM)** |
| **Download Speed** | Home Wi-Fi (15–50 Mbps) | **Google Datacenter (500–1,000 Mbps)** |
| **Training Time** | ~2–4 hours (CPU thermal throttling) | **~15–25 minutes (GPU)** |
| **Local Environment** | Requires Python, TensorFlow, CUDA | **Zero local installation required** |

> **Student / Free Tier Info:**  
> You do **not** need a specialized student program or credit card. Any standard free Google/Gmail account has access to Colab's free T4 GPU tier. If you have a student Google Workspace account, it works just as seamlessly.

---

---

## 📦 Packaging & Uploading Dataset Images to Google Drive

Before training in Colab, you can feed real field photographs from `test/assets/` into the model by packaging them into clean `.zip` archives and uploading them to your Google Drive. The Colab notebooks will automatically detect and ingest them during Step 4.

> [!IMPORTANT]
> The dataset images are split into two separate directories:
> * `test/assets/mushrooms/` (47 mushroom species directories)
> * `test/assets/trees/` (5 indicator tree species directories)
> 
> The archives **must** contain the species directories at the root of the zip (e.g. `amanita_muscaria/image1.jpg` or `pinus_sylvestris/photo1.jpg`), without extra parent directory nesting, and with macOS `.DS_Store` metadata stripped.

### 1. Mushroom Dataset (`boscdex_dataset.zip`)

**Automated shortcut:**
```bash
make zip-mushrooms
```

**Manual shell command:**
```bash
(cd test/assets/mushrooms && zip -r ../../../boscdex_dataset.zip . -x "*.DS_Store" -x "*/.DS_Store" -x ".DS_Store" -x "__MACOSX*")
```

### 2. Indicator Tree Dataset (`tree_dataset.zip`)

**Automated shortcut:**
```bash
make zip-trees
```

**Manual shell command:**
```bash
(cd test/assets/trees && zip -r ../../../tree_dataset.zip . -x "*.DS_Store" -x "*/.DS_Store" -x ".DS_Store" -x "__MACOSX*")
```

*(Tip: You can run `make zip-datasets` to package both at once!)*

### 3. Upload to Google Drive
1. Open [Google Drive](https://drive.google.com).
2. Upload `boscdex_dataset.zip` and/or `tree_dataset.zip` to:
   * Your Drive root: `MyDrive/boscdex_dataset.zip` (or `MyDrive/tree_dataset.zip`)
   * OR inside a `boscdex` folder: `MyDrive/boscdex/boscdex_dataset.zip`
3. When you run the Colab notebook, Step 4 will automatically find and unpack the archive!

---

## 🛠️ Step-by-Step Instructions

### Step 1: Open the Target Notebook in Google Colab
1. Open your browser and navigate to [**colab.research.google.com**](https://colab.research.google.com/).
2. In the modal, click the **Upload** tab.
3. Select and upload the appropriate notebook from your local Boscdex repository:
   * **Mushrooms:** [`notebooks/boscdex_mushroom_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_mushroom_training_colab.ipynb)
   * **Indicator Trees:** [`notebooks/boscdex_tree_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_tree_training_colab.ipynb)

### Step 2: Ensure GPU is Enabled
1. In the Colab top menu, click **Runtime** > **Change runtime type**.
2. Under **Hardware accelerator**, select **T4 GPU**.
3. Click **Save**.

### Step 3: Run the Training Pipeline
1. Click **Runtime** > **Run all** (or press `Cmd + F9` / `Ctrl + F9`).
2. When prompted in Step 4, grant Google Drive permission to mount your Drive.
3. The notebook will automatically execute:
   * **Step 1:** Verify the NVIDIA T4 GPU.
   * **Step 2:** Install dependencies (`pyinaturalist`, `requests`, `tqdm`, `pillow`, `tensorflow`).
   * **Step 3:** Mount Google Drive.
   * **Step 4:** Ingest `boscdex_dataset.zip` or `tree_dataset.zip` from Drive.
   * **Step 5:** Concurrently download verified research-grade observations from iNaturalist using explicit Fungi kingdom taxon IDs (preventing non-fungal data corruption).
   * **Step 6:** Fine-tune **MobileNetV2** backbone with AdamW optimizer ($1\times 10^{-4}$ weight decay), label smoothing ($\alpha = 0.10$), frozen BatchNormalization layers, and safety-priority inverse-frequency class weighting ($1.20\times$ multiplier on lethal species).
   * **Step 7:** Export the quantized **INT8 TFLite model** and standalone Dart classification head (`mushroom_classifier_head.bin`, 240.8 KB).
   * **Step 8:** Automatically package and download the output artifacts.

### Step 4: Drop Output Files into Boscdex
Once the training finishes:
* **For Mushrooms:**
  1. Copy `mushroom_classifier.tflite` to `assets/models/mushroom_classifier.tflite`.
  2. Copy `mushroom_classifier_head.bin` to `assets/models/mushroom_classifier_head.bin`.
  3. Copy `mushroom_labels.txt` to `assets/models/mushroom_labels.txt`.
  4. Verify with on-device Golden Set evaluation:
     ```bash
     flutter test test/unit_tests/domain/mushroom_model_real_images_test.dart
     ```

* **For Trees:**
  1. Copy `tree_classifier.tflite` to `assets/models/tree_classifier.tflite`.
  2. Copy `tree_classifier_head.bin` to `assets/models/tree_classifier_head.bin`.
  3. Copy `tree_labels.txt` to `assets/models/tree_labels.txt`.
  4. Verify with on-device Golden Set evaluation:
     ```bash
     flutter test test/unit_tests/domain/tree_model_real_images_test.dart
     ```

---

## 📊 Verified Real-World Performance (Series 017 Benchmark)

When trained on the curated dataset (`boscdex_dataset.zip` + verified Catalan iNaturalist observations) with 3-View Test-Time Augmentation (TTA), the 47-species model achieves:

* **Training Duration:** ~15–20 minutes on Colab T4 GPU.
* **Top-1 Accuracy:** **85.1%** (530 / 623 real field photos).
* **Top-3 Accuracy:** **96.3%** (600 / 623 real field photos).
* **Lethal Species Safety Recall:** **98.4%** (60 / 61 photos correctly detected in top candidates across *Amanita phalloides*, *Amanita verna*, *Amanita virosa*, *Galerina marginata*, *Cortinarius orellanus*).
* **Standout Taxa (100% Top-1):** *Amanita caesarea*, *Amanita muscaria*, *Amanita verna*, *Chroogomphus rutilus*, *Coprinus comatus*, *Cortinarius orellanus*, *Craterellus cornucopioides*, *Craterellus lutescens*, *Lactarius sanguifluus*, *Macrolepiota procera*, *Marasmius oreades*, *Morchella esculenta*.
* **Model Footprint:** ~2.50 MB TFLite backbone + 240.8 KB classification head (vastly below the 18 MB mobile budget).

---

## ❓ Troubleshooting: `/bin/bash: line 1: nvidia-smi: command not found`

If you encounter this error when executing the first cell in VS Code:

### Why this happens:
1. **VS Code Kernel set to Local macOS (Most Common):**  
   Even if you have the Colab extension installed, VS Code's kernel picker (top-right of the notebook window) often defaults to your local Mac interpreter (`Python 3.x / Darwin`). macOS does not have NVIDIA hardware or `nvidia-smi`.
2. **Colab Connected to CPU instead of GPU:**  
   Google Colab provisions standard CPU instances by default unless **T4 GPU** is explicitly requested. Colab CPU runtimes do not have NVIDIA drivers installed.

### How to resolve:

#### Option A: Use Google Colab Web Browser Directly (Recommended & Foolproof)
Running directly in Chrome or Safari eliminates local kernel and port-forwarding issues:
1. Open [**colab.research.google.com**](https://colab.research.google.com/).
2. Click **Upload** > Select `notebooks/boscdex_mushroom_training_colab.ipynb`.
3. In the top navigation: **Runtime > Change runtime type > Hardware accelerator: T4 GPU** > **Save**.
4. Click **Runtime > Run all**.

#### Option B: Configure VS Code Kernel Properly
If you prefer running inside VS Code:
1. Look at the **top-right corner** of the notebook in VS Code.
2. Click on the kernel button (e.g., `Select Kernel` or `Python 3.x.x`).
3. Select **Google Colab** (or `Existing Jupyter Server`).
4. Ensure you authenticate and connect to a runtime that has **T4 GPU** enabled (via the Colab extension status bar or command palette: `Colab: Connect to Colab`).

---

## ❓ Troubleshooting: `Getting requirements to build wheel did not run successfully`

### Why this happens:
`mediapipe-model-maker` is a legacy package that only supported Python 3.9–3.11 and has been deprecated by Google. When installed on modern environments running Python 3.12 or 3.13, pip attempts to compile outdated C-extensions (`tf-models-official`, `pyyaml`, etc.) from source, which triggers build errors.

### Resolution:
We updated `notebooks/boscdex_mushroom_training_colab.ipynb` to use **pure native TensorFlow / Keras Transfer Learning** with `MobileNetV2`. Native TensorFlow provides pre-compiled PyPI wheels for all modern Python versions (including Python 3.13 on Linux x86_64), eliminating the need for `mediapipe-model-maker` and avoiding all wheel compilation issues.


