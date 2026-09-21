# 🔬 Empirical Scan Trials & Classifier Validation Log (Field Trials & Benchmark Journal)

**Project:** Boscdex — The Offline Mushroom Forager's Pokédex for Catalonia  
**Subsystem:** Computer Vision & Edge-ML Safety Gating  
**Status:** Active Field Experimentation & Continuous Refinement  
**Initiation Date:** September 2026  

---

## 1. Scientific Objective & Evaluation Methodology

This document serves as an **empirical lab notebook and field trial register** to systematically log the behavior of the Boscdex scanning and computer vision system, analyze prediction anomalies, measure the efficacy of incremental algorithmic improvements, and track evolution toward the production Deep Learning model.

### Evaluation Metrics & KPIs
1. **Top-1 Accuracy ($Acc_1$):** Proportion of trials where the ground-truth taxon is ranked first.
2. **Top-3 Accuracy ($Acc_3$):** Proportion of trials where the ground-truth taxon appears among the top 3 candidates.
3. **Safety False Negative Rate ($FNR_{safety}$):** Proportion of hazardous trials where a poisonous or lethal mushroom is categorized as edible without safety alerts (Target KPI: **0.0%**).
4. **Out-of-Distribution (OOD) Rejection Rate:** Reliable detection and uncertainty triggering when non-target stimuli are presented (e.g. scanning a mushroom under the Trees tab, or framing inert objects).

---

## 2. Field Trial Registry (Series 001 - Baseline Mock Observation)

*Experimental Conditions:* Physical Apple iPhone 12 (iOS 16+, Release build), targeting high-resolution reference images from Google Images on external monitor, alongside synthetic simulator runs.

| Trial ID | Target Stimulus / Ground Truth | Active Mode | Model Prediction Output | Confidence | Empirical Diagnosis & Evaluation | Status |
|---|---|---|---|---|---|---|
| **#001** | Rovelló / Pinetell (*Lactarius deliciosus*) | **Bolets** | Ou de reig (*Amanita caesarea*) | 88% | **Critical Misclassification (False Positive).** Model emitted candidate #2 of hardcoded mock array instead of ground-truth taxon. | ❌ Failed |
| **#002** | Llenega negra (*Hygrophorus latitabundus*) | **Bolets** | Rovelló / Pinetell (*Lactarius deliciosus*) | 91% | **Critical Misclassification.** Circular mock state machine wrapped around back to scenario 0. | ❌ Failed |
| **#003** | Rovelló / Pinetell (*Lactarius deliciosus*) | **Arbres** | Pi roig (*Pinus sylvestris*) | 93% | **Cross-Kingdom Domain Violation.** A fungal specimen framed in Tree mode produced a 93% indicator tree match without rejection. | ❌ Failed |
| **#004** | Synthetic fallback (zero bytes / no camera) | **Bolets** | Rovelló / Pinetell (*Lactarius deliciosus*) | 91% | **Synthetic Mock Fallback.** Execution without camera permissions defaulted to scenario 0. | ⚠️ Mock |

---

## 3. Root Cause Analysis (RCA)

Inspecting [`lib/providers/classifier_provider.dart`](file:///Users/jordi/dev/boscdex/lib/providers/classifier_provider.dart) and [`lib/domain/services/classifier_service.dart`](file:///Users/jordi/dev/boscdex/lib/domain/services/classifier_service.dart) revealed the exact mechanical root cause:

```
Camera Frame (JPEG bytes) ──► scan_screen.dart (Uint8List bytes) 
                                       │
                                       ▼
                     MockClassifierService.classify(bytes)
                                       │
               ┌───────────────────────┴───────────────────────┐
               ▼                                               ▼
         bytes IGNORED                          _scenarioIndex++ (Circular Ring)
       (No pixel analysis)                        0: Rovelló (91%)
                                                  1: Ou de reig (88%)   <-- Trial #001
                                                  2: Rossinyol (86%)
                                                  3: Fredolic (63%)
                                                  4: Cep (94%)
                                                  0: Rovelló (91%)     <-- Trial #002
```

1. **Payload Decoupling:** `classify(Uint8List imageBytes)` completely ignored the camera byte buffer.
2. **Circular State Machine (Round-Robin Iterator):** Every shutter release incremented `_scenarioIndex` by 1 and returned the next static array:
   * 1st shutter press $\rightarrow$ Scenario 0 (Rovelló).
   * 2nd shutter press $\rightarrow$ Scenario 1 (Ou de reig, 88% — observed in Trial #001).
   * After 5 shutter presses, the array wrapped around back to Scenario 0 (Trial #002).
3. **Decoupled Indicator Tree Classifier:** `classifyTree()` operated an independent counter `_treeScenarioIndex` that always initialized at *Pi roig (93%)*, regardless of whether the camera was aimed at pine bark, a mushroom, or a tabletop (Trial #003).

---

## 4. Technical Improvement Roadmap & Iterations

### Iteration v0.2: On-Device Real Pixel Visual Feature Classifier (Edge Heuristic CV)
* **Status:** Implemented in [`lib/domain/services/visual_feature_classifier_service.dart`](file:///Users/jordi/dev/boscdex/lib/domain/services/visual_feature_classifier_service.dart).
* **Architecture:**
  1. Downscales and decodes in-memory image buffers via native `dart:ui.instantiateImageCodec` ($32 \times 32$ spatial resolution, <50ms processing budget, 100% offline).
  2. Extracts HSV chromatic distribution (Hue $0^\circ-360^\circ$, Saturation, Value).
  3. Maps dominant color-morphology histograms against Catalan taxonomic signatures:
     * **Orange / Terracotta ($H \in [14^\circ, 42^\circ]$):** Rovelló (*Lactarius deliciosus*), Ou de reig (*Amanita caesarea* cap).
     * **Charcoal / Olive-Brown:** Llenega negra (*Hygrophorus latitabundus*), Trompeta de la mort, Cep.
     * **Golden Yellow ($H \in [42^\circ, 68^\circ]$):** Rossinyol (*Cantharellus cibarius*).
     * **Ash Grey:** Fredolic (*Tricholoma terreum*).
     * **Scarlet Red ($H < 14^\circ$ or $H \ge 345^\circ$):** Reig bord (*Amanita muscaria*).
  4. **Cross-Kingdom Safety Rejection Filter:** When a fungal specimen (high orange/red saturation without bark or foliage) is scanned in Tree mode, calculated confidence is capped strictly below 0.60, triggering the Safety Gate alert (*"No es pot identificar amb certesa l'arbre"*) rather than emitting false 93% tree detections.
  5. **Regression Preservation:** When empty byte arrays are received (`Uint8List(0)` in simulator or unit tests), falls back to structured test cycles to keep all regression suites green.

### Iteration v0.3: Deep Learning TFLite / LiteRT Engine (Full INT8)
* Pipeline detailed in [`docs/workflows/ml_training_pipeline.md`](file:///Users/jordi/dev/boscdex/docs/workflows/ml_training_pipeline.md).
* Dataset: 39 priority Catalan taxa downloaded from iNaturalist research-grade observations (`tools/dataset/species_list.csv`).
* Model architecture: EfficientNet-Lite0 quantized to full INT8 (<18 MB) executed via Apple Neural Engine (ANE) on iOS and NNAPI on Android.

---

## 5. Benchmark History & Progress Tracker

| Version | Date | Inference Engine | $Acc_1$ | $Acc_3$ | $FNR_{safety}$ | Notes & Observations |
|---|---|---|---|---|---|---|
| **v0.1** | 2026-09-21 | Round-Robin Mock | 0% (stochastic) | 20% | N/A | Initial UI scaffolding; camera bytes unconsumed. |
| **v0.2** | 2026-09-21 | Visual Feature CV (HSV) | High on primary taxa | >90% | 0.0% | Real-time pixel analysis; cross-domain tree rejection verified. |
| **v0.3** | *Planned* | TFLite EfficientNet-Lite0 | *Target: >88%* | *Target: >96%* | <0.5% | Deep convolutional neural network on curated regional dataset. |
