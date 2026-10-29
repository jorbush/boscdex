# 🧠 Machine Learning & Computer Vision Theory for Boscdex

Welcome to the **Theory** section of Boscdex. This guide is written for engineers, developers, and curious mushroom foragers (*boletaires*) who want to understand the foundational principles behind training an on-device deep learning image classifier—**without skipping the basics**.

Whether you have never written a line of machine learning code or want a refresher on the math and architecture powering modern mobile vision, this module walks step-by-step through how a smartphone camera transforms photons into a species prediction.

---

## 🗺️ Learning Pathway

```
┌────────────────────────────────────────────────────────────────────────┐
│                        LEARNING CURRICULUM                             │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│   Chapter 1: Foundations of Computer Vision                            │
│   ├─ What is a digital image? (Pixels, channels, tensors)             │
│   ├─ Why traditional algorithms fail on images                         │
│   └─ Convolutions, kernels, feature maps & pooling                     │
│                                                                        │
│   Chapter 2: Transfer Learning & The MobileNetV2 Backbone              │
│   ├─ Why we don't train from scratch (The ImageNet superpower)         │
│   ├─ Deep CNN feature hierarchies (Edges → Textures → Parts → Taxa)    │
│   ├─ MobileNetV2 innovations: Depthwise Separable Convolutions         │
│   └─ Global Average Pooling (GAP): Condensing to 1,280 features        │
│                                                                        │
│   Chapter 3: Training Mechanics, Loss & Optimization                   │
│   ├─ The Classification Head: Logits and Softmax                       │
│   ├─ The Loss Function: Categorical Cross-Entropy                      │
│   ├─ Gradient Descent, Backpropagation & Learning Rates                │
│   ├─ Two-Phase Training (Head Warmup vs Deep Fine-Tuning)              │
│   └─ Data Augmentation: Teaching radial symmetry and shade invariance  │
│                                                                        │
│   Chapter 4: Edge Quantization & Decoupled Architecture                │
│   ├─ From Cloud Python to Offline Mobile: The TFLite engine            │
│   ├─ Float32 vs INT8 Quantization (Why 100MB shrinks to 2.5MB)         │
│   └─ The Boscdex Decoupled Head Pattern (TFLite GAP + Native Dart)     │
│                                                                        │
│   Chapter 5: The Unique Mycological Challenges of CV                   │
│   ├─ Intra-class variance (Buttons vs weathered mature caps)           │
│   ├─ Inter-class morphological mimics & Toxic Lookalikes               │
│   └─ Asymmetric cost: Why a classifier must never guess on toxicity    │
│                                                                        │
│   Chapter 6: Modern Optimization, Data Curation & 3-View TTA           │
│   ├─ Taxonomic Ground-Truth Curation (100% Verified Kingdom Fungi)     │
│   ├─ Label Smoothing Loss: Calibrating Edge Probabilities              │
│   ├─ Safety-Priority Inverse-Frequency Class Weighting                 │
│   ├─ AdamW Optimization & Frozen BatchNormalization                    │
│   ├─ On-Device 3-View Test-Time Augmentation (TTA Feature Fusion)      │
│   └─ Proximal 3-View TTA Linear Head Calibration (100% Ref Top-1)      │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 📑 Chapters Directory

1. [**01. Foundations of Computer Vision**](01_foundations_computer_vision.md)  
   Pixels, tensors, spatial dimensions, normalization, convolutions, and feature maps.
2. [**02. Transfer Learning & The MobileNetV2 Backbone**](02_transfer_learning_and_backbones.md)  
   How pre-trained models work, depthwise separable convolutions, inverted residuals, and Global Average Pooling.
3. [**03. Training Mechanics, Loss & Optimization**](03_training_optimization_and_loss.md)  
   Forward pass, logits, softmax, categorical cross-entropy, backpropagation, learning rates, and data augmentation.
4. [**04. Edge Quantization & Decoupled Architecture**](04_edge_quantization_and_decoupled_head.md)  
   TFLite format, post-training quantization, and why Boscdex splits the feature extractor from the classification head.
5. [**05. Mycological Challenges in Computer Vision**](05_mycology_cv_challenges.md)  
   Phenological stages, environmental noise, Moiré effects, and asymmetric safety risk.
6. [**06. Modern Optimization, Data Curation & Test-Time Augmentation (TTA)**](06_modern_optimization_and_tta.md)  
   Taxonomic data curation, label smoothing loss ($\alpha = 0.10$), safety class weights, `AdamW`, frozen BatchNorm, on-device 3-View TTA, and Proximal TTA Head Calibration reaching **96.9% Top-1 / 99.3% Top-3** across 1,041 field images and **100.0% Top-1** on all 75 botanical reference photos.

---

## 🎯 Quick Vocabulary Glossary

| Term | Simple Definition | Role in Boscdex |
|---|---|---|
| **Tensor** | A multi-dimensional array of numbers. | An image is a 3D tensor: `[Height, Width, Color Channels]`. |
| **Kernel / Filter** | A small grid of numbers ($3\times3$) that slides across an image to detect specific visual patterns. | Detects mushroom gills, cap edges, or scales. |
| **Backbone** | A deep pre-trained neural network used to extract visual features. | MobileNetV2 turns an image into 1,280 numbers. |
| **GAP** | Global Average Pooling: collapses spatial dimensions into a single vector. | Extracts the 1,280 feature fingerprint. |
| **Logit** | The raw, unnormalized score a neural network outputs for each class. | 75 real numbers; higher means more confident. |
| **Softmax** | A mathematical function that converts logits into percentages summing to 100%. | Produces candidate probabilities in the UI. |
| **Label Smoothing** | Regularization technique softening one-hot targets with a uniform distribution. | Prevents overconfidence and bounds logit dynamic range ($\alpha = 0.10$). |
| **Loss** | A score measuring how wrong the model's prediction is. | The optimizer tweaks weights to minimize this score. |
| **AdamW** | Adaptive optimizer with decoupled weight decay. | Prevents overfitting during deep backbone fine-tuning. |
| **TTA** | Test-Time Augmentation: evaluating multiple augmented views of a single input. | Fuses Full Frame, Horizontal Flip, and Macro Crop for robust on-device inference. |
| **Epoch** | One complete pass through the entire training dataset. | We train for 15 epochs in Phase 1 and up to 25 epochs in Phase 2 with early stopping. |
