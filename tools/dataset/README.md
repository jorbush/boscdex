# Boscdex ML Dataset Assembly Guide

## Overview

This directory contains tools for assembling the training dataset for the Boscdex mushroom classifier. The model targets 60–80 Catalan mushroom species using a fine-tuned EfficientNet-Lite0 architecture.

## Dataset Sources

### Primary: iNaturalist Open Data
- **Coverage:** 100% of target species with thousands of geo-tagged images in Spain/Catalonia
- **Quality:** Research-grade observations verified by community experts
- **Access:** Public API via `pyinaturalist` + AWS S3 bucket (`s3://inaturalist-open-data`)
- **Place IDs:** Catalonia = 7525, Spain = 6774

### Supplementary: Danish Fungi Dataset (DF20)
- **Coverage:** ~55–58 of 80 target species (excellent for Eurosiberian species)
- **Gap:** Missing key Mediterranean species (*Amanita caesarea*, *Lactarius sanguifluus*, *Hygrophorus latitabundus*, *Pleurotus eryngii*)
- **Download:** [Kaggle - DF20-Mini](https://www.kaggle.com/datasets/picekl/danish-fungi-2020) (~5.6 GB, max 300px)

### Supplementary: FungiCLEF / FungiTastic
- **Coverage:** 5,000+ species, strong on European fungi
- **Advantage:** Includes asymmetric cost matrices penalizing toxic/edible confusion
- **Download:** [Hugging Face - BVRA](https://huggingface.co/BVRA) or [Kaggle](https://www.kaggle.com/datasets/picekl/fungitastic)

## Quick Start

### 1. Install Dependencies

```bash
pip install pyinaturalist requests tqdm pillow
```

### 2. Download from iNaturalist

```bash
# Download targeting Catalonia first, falling back to Spain/Europe
python download_inat.py --species-csv species_list.csv --output-dir ./dataset

# Customize place ID (e.g., broader Spain)
python download_inat.py --species-csv species_list.csv --output-dir ./dataset --place-id 6774
```

### 3. Download DF20-Mini (optional supplement)

```bash
# Download from Kaggle (requires kaggle CLI)
kaggle datasets download -d picekl/danish-fungi-2020 -p ./df20
unzip ./df20/danish-fungi-2020.zip -d ./df20
```

### 4. Merge Datasets

```bash
python merge_datasets.py --inat-dir ./dataset --df20-dir ./df20 --output-dir ./merged
```

## Target Dataset Structure

```
dataset/
├── lactarius_deliciosus/
│   ├── 12345.jpg
│   ├── 12346.jpg
│   └── ...  (250-400 images)
├── boletus_edulis/
│   └── ...
├── amanita_phalloides/
│   └── ...
└── ... (one folder per species)
```

## Image Requirements for Training

| Aspect | Requirement |
|---|---|
| **Images per species** | Minimum 150, target 250–400 |
| **Resolution** | 256×256 px (resized during download) |
| **Format** | JPEG, RGB |
| **Angle diversity** | Top-down, underside, lateral views |
| **Stage diversity** | Young buttons, mature, senescent |

## Data Augmentation Recipe

Applied during training (not during download):

- Random 360° rotation (caps have radial symmetry)
- ColorJitter / Random Color Temperature (canopy shade vs direct sun)
- RandomErasing / CutOut (simulates pine needle & moss occlusion)
- Horizontal flip
- Random crop (224×224 from 256×256)

## Licensing Notes

⚠️ iNaturalist images are individually licensed (CC-BY, CC-BY-NC, CC0). The download script respects API rate limits. For commercial model training, filter for CC-BY or CC0 licensed images only.
