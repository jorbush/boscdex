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

## 🛠️ Step-by-Step Instructions

### Step 1: Open the Notebook in Google Colab
1. Open your browser and navigate to [**colab.research.google.com**](https://colab.research.google.com/).
2. In the modal, click the **Upload** tab.
3. Select and upload [`notebooks/boscdex_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_training_colab.ipynb) from your local Boscdex repository.

### Step 2: Ensure GPU is Enabled
1. In the Colab top menu, click **Runtime** > **Change runtime type**.
2. Under **Hardware accelerator**, select **T4 GPU**.
3. Click **Save**.

### Step 3: Run the Training Pipeline
1. Click **Runtime** > **Run all** (or press `Cmd + F9` / `Ctrl + F9`).
2. The notebook will automatically execute:
   * **Step 1:** Verify the NVIDIA T4 GPU.
   * **Step 2:** Install dependencies (`pyinaturalist`, `requests`, `tqdm`, `pillow`, `tensorflow`).
   * **Step 3 & 4:** Concurrently download research-grade Catalan mushroom observations from iNaturalist.
   * **Step 5:** Fine-tune **MobileNetV2** using native TensorFlow / Keras transfer learning with data augmentation.
   * **Step 6:** Export the quantized **INT8 TFLite model** (`boscdex_classifier.tflite`) and verify it is under the 18 MB budget (~3.5 MB).
   * **Step 7:** Automatically trigger a browser download for the output files.

### Step 4: Drop Output Files into Boscdex
Once the browser finishes downloading:
1. Copy `boscdex_classifier.tflite` to `boscdex/assets/models/boscdex_classifier.tflite`.
2. Copy `classifier_head.bin` to `boscdex/assets/models/classifier_head.bin`.
3. Copy `labels.txt` to `boscdex/assets/models/labels.txt`.
4. Verify the files are present:
   ```bash
   ls -lh assets/models/
   # Should display:
   # -rw-r--r-- boscdex_classifier.tflite (~2.5 MB)
   # -rw-r--r-- classifier_head.bin (~102.5 KB)
   # -rw-r--r-- labels.txt (~1 KB)
   ```
5. Run the on-device Golden Set verification:
   ```bash
   flutter test test/unit_tests/domain/model_real_images_test.dart
   ```

---

## 📊 Verified Real-World Performance (Series 008 Benchmark)

When trained on the hybrid dataset (`boscdex_dataset.zip` + iNaturalist Catalan top-up), the 21-species model achieves:

* **Training Duration:** ~10–15 minutes on Colab T4 GPU.
* **Top-1 Accuracy:** **88.8%** (167 / 188 real field photos).
* **Top-3 Accuracy:** **97.3%** (183 / 188 real field photos).
* **Standout Taxa:** *Chroogomphus rutilus* (100% Top-1), *Boletus edulis* (100% Top-1), *Hydnum repandum* (100% Top-1), *Amanita caesarea* (100% Top-1), *Amanita muscaria* (100% Top-1), *Amanita verna* (100% Top-1), *Cantharellus cibarius* (100% Top-1), *Craterellus cornucopioides* (100% Top-1), *Pleurotus ostreatus* (100% Top-1), *Omphalotus olearius* (100% Top-1), *Hygrophorus latitabundus* (93% Top-1), *Tricholoma terreum* (90% Top-1 / 100% Top-3), *Lactarius deliciosus* (100% Top-3).
* **Model Footprint:** ~2.5 MB TFLite backbone + 107.6 KB classification head (vastly below the 18 MB mobile budget).

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
2. Click **Upload** > Select `notebooks/boscdex_training_colab.ipynb`.
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
We updated `notebooks/boscdex_training_colab.ipynb` to use **pure native TensorFlow / Keras Transfer Learning** with `MobileNetV2`. Native TensorFlow provides pre-compiled PyPI wheels for all modern Python versions (including Python 3.13 on Linux x86_64), eliminating the need for `mediapipe-model-maker` and avoiding all wheel compilation issues.


