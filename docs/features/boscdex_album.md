# The Boscdex Album Feature

The **Boscdex Album** (`/boscdex`) is the central gamified field guide modeled after a classic Pokédex.

---

## 🎮 Core Mechanics

### 1. Dual Visual States (Discovered vs. Undiscovered)

* **Undiscovered State:**
  * Displays a dark silhouette card with the specimen's sequential entry number (`#001` to `#080`).
  * Shows a mystery/locked aesthetic.
  * Tapping displays a discreet field hint: *"Encara no has descobert aquest bolet!"*.

* **Discovered State:**
  * Full specimen illustration/photo.
  * Catalan vernacular name prominent at the base.
  * Minimalist circular corner edibility badge (`EdibilityBadge` in `iconOnly` mode).
  * Sequential Dex number.
  * Tapping navigates to the rich specimen detail sheet (`/boscdex/:id`).

---

## 🏆 Rarity Tier System

Each species belongs to one of 5 distinct tiers reflecting encounter probability in Catalonia:

| Tier | Catalan Label | Color Code | Representative Species |
|---|---|---|---|
| **Tier 1** | `Comú` | Bronze (`#CD7F32`) | Rovelló / Pinetell, Fredolic, Rossinyol |
| **Tier 2** | `Poc freqüent` | Silver (`#C0C0C0`) | Cep, Trompeta de la mort, Camagroc |
| **Tier 3** | `Rar` | Gold (`#FFD700`) | Ou de reig, Llenega negra |
| **Tier 4** | `Molt rar` | Purple (`#9B59B6`) | Múrgola, Cep negre (*Boletus aereus*) |
| **Tier 5** | `Llegendari` | Holographic / Cyan (`#00FFFF`) | Trufa negra (*Tuber melanosporum*) |

---

## 🗂️ Dual Sub-Catalog Architecture

Boscdex separates its field guides into two dedicated, ecologically interconnected sub-catalogs accessible via an arcade-style mode selector:

### 1. 🍄 Bolets Sub-Dex (Mushrooms)
* Comprehensive catalog of Catalan wild mushrooms.
* Features discovery silhouettes, dex numbers (`#001` - `#080`), rarity borders, and edibility badges.
* Interactive filters:
  1. **Tots:** All cataloged Catalan mushroom species.
  2. **Comestibles:** Filters strictly for `excellent` and `comestible` taxa.
  3. **Tòxics / Mortals:** Isolates poisonous species (`toxic`, `mortal`) to train the eye on hazards.
  4. **Arbres socis:** Isolates species with documented mycorrhizal associations to indicator trees.

### 2. 🌲 Arbres Sub-Dex (Indicator Trees)
* Dedicated catalog of key Catalan mycorrhizal host trees.
* Displays leaf morphology tags, identification status, and the number of associated mushroom species (`🍄 X bolets socis`).
* Interactive filters:
  1. **Tots:** All cataloged indicator trees.
  2. **Agulla:** Coniferous needle trees (*Pinus sylvestris*, *Pinus halepensis*).
  3. **Caduca:** Deciduous broadleaf trees (*Fagus sylvatica*, *Castanea sativa*).
  4. **Perenne:** Evergreen sclerophyllous trees (*Quercus ilex*).

---

## 🔗 Mutual Ecological Cross-Linking

The two sub-catalogs maintain a symbiotic relationship throughout the UI:
* In any **Bolet detail screen** (`/boscdex/:id`), tapping an associated tree chip opens that tree's full profile in the Arbres dex.
* In any **Arbre detail screen** (`/arbre/:id`), tapping any associated mushroom card navigates directly to its full Boscdex entry.
* In the **Arbres grid**, each tree card displays a badge indicating how many mushroom species fruit in mycorrhizal partnership under its canopy.

