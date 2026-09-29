# Indicator Trees Companion Guide

A unique strength of Boscdex is connecting fungal taxonomy with **forest ecology**. Many prized culinary mushrooms are mycorrhizal symbionts that only fruit in association with specific tree roots.

---

## 🌲 The Indicator Tree Concept

An indicator tree is a botanical beacon in the forest. By recognizing tree species and soil geology, a *boletaire* can predict which mushrooms might fruit nearby:

```
[ Pi roig / Pinus sylvestris ]  ──>  Rovellons, Pinetells, Camagrocs
[ Alzina / Quercus ilex ]       ──>  Ou de reig, Carlets, Llora verda
[ Faig / Fagus sylvatica ]      ──>  Ceps d'estiu, Trompetes de la mort
[ Suro / Quercus suber ]        ──>  Ou de reig, Cep negre
```

---

## 🌿 Cataloged Catalan Indicator Trees

### 1. Pi roig (*Pinus sylvestris*)
* **Characteristics:** Distinctive reddish-orange peeling bark in the upper trunk, needle pairs 3–7 cm long.
* **Habitat:** Montane forests between 800 and 2,100 m.
* **Symbiotic Fungi:** *Lactarius deliciosus* (Pinetell), *Lactarius sanguifluus* (Rovelló), *Suillus luteus*, *Tricholoma terreum* (Fredolic).

### 2. Alzina (*Quercus ilex*)
* **Characteristics:** Dense evergreen oak with dark deeply fissured bark and leathery spiny-toothed leaves.
* **Habitat:** Lowland and sub-Mediterranean hills up to 1,400 m.
* **Symbiotic Fungi:** *Amanita caesarea* (Ou de reig), *Boletus aereus* (Cep negre), *Hygrophorus russula* (Carlet).

### 3. Faig (*Fagus sylvatica*)
* **Characteristics:** Tall deciduous tree with smooth silver-grey bark and oval wavy-margined leaves.
* **Habitat:** Humid northern aspects and mountain valleys (Montseny, Ripollès, Garrotxa).
* **Symbiotic Fungi:** *Boletus edulis* (Cep), *Craterellus cornucopioides* (Trompeta de la mort), *Hydnum repandum* (Llengua de bou).

### 4. Alzina surera (*Quercus suber*)
* **Characteristics:** Thick spongy cork bark harvested commercially in Girona (Gavarres, Selva, Empordà).
* **Habitat:** Siliceous acid soils near coastal Mediterranean zones.
* **Symbiotic Fungi:** *Amanita caesarea*, *Cantharellus cibarius* (Rossinyol).

### 5. Roure martinenc (*Quercus pubescens*)
* **Characteristics:** Deciduous oak whose withered leaves often cling to branches throughout winter (*marcescència*).
* **Habitat:** Sub-Mediterranean transition slopes.
* **Symbiotic Fungi:** *Boletus edulis*, *Cantharellus cibarius*, *Russula cyanoxantha*.

---

## 📱 Arbres Boscdex & Navigation Integration

Indicator trees are first-class citizens in the app with their own dedicated **Arbres Boscdex** within the Boscdex tab:

1. **Sub-Catalog Selector:** The Boscdex screen features a selector toggle (`🍄 Bolets` | `🌲 Arbres`) to seamlessly switch between the fungi and tree catalogs.
2. **Arbre Cards & Field Identification:** Tree cards display leaf type tags (`Agulla`, `Caduca`, `Perenne`), dynamic counters for symbiotic mushroom species (`🍄 X bolets socis`), and field identification badges. Identification is tracked reactively via the SQLite database: cards show a camera icon (📷) when field capture is pending, and a green checkmark (✓) once photographed and registered in the journal (`watchIdentifiedArbreIds`).
3. **Detail, Cross-Linking & Specimen Masking:** Each tree detail screen (`/arbre/:id`) displays bark and foliage morphology, typical soil conditions, and an interactive grid of associated mushrooms. To preserve the Pokédex discovery experience, associated mushrooms not yet discovered by the user are veiled with black silhouette sprites and `#00X ???` labels. Tapping any mushroom navigates to its Boscdex entry (mystery location sheet if undiscovered, full morphology if discovered).
4. **Live Scanning & Edge ML Classifier:** The camera viewfinder has a dedicated **Arbres** mode. Tree frames are evaluated on-device using a MobileNetV2 deep learning classifier (`tree_classifier.tflite` + `tree_classifier_head.bin`) lazy-loaded into RAM on demand.
5. **Empirical Accuracy:** Validated against real Catalan field photographs in `test/unit_tests/domain/tree_model_real_images_test.dart` at **80.0% Top-1** and **96.0% Top-2** accuracy across all 5 indicator tree species (Series 012).
6. **Sighting Journal Integration:** Scanned trees can be instantly saved to **El Meu Diari** via the *"Registrar troballa al Diari"* button in the `TreeClassificationResultSheet`. The sighting stores the captured JPEG photo, neural confidence score, timestamp, and optional field notes in the local SQLite `Avistaments` table (`arbreId != null`), automatically updating the tree's identified status and main header counter (`X/5 identificats`).
7. **User Captures Gallery:** `ArbreDetailScreen` includes a *"Les Teves Captures"* photo carousel showcasing all field captures of that tree species with dates, confidence tags, and full-screen inspection sheets (`AvistamentDetailSheet`).
8. **Colab Training Pipeline:** Fast 1-click cloud fine-tuning notebook located at [`notebooks/boscdex_tree_training_colab.ipynb`](file:///Users/jordi/dev/boscdex/notebooks/boscdex_tree_training_colab.ipynb) paired with the automated iNaturalist photo downloader [`tools/dataset/download_trees_inat.py`](file:///Users/jordi/dev/boscdex/tools/dataset/download_trees_inat.py).

