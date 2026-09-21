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

## 🔍 Interactive Filtering

The album includes horizontal filter chips allowing instant query slicing:
1. **Tots:** All cataloged Catalan species.
2. **Comestibles:** Filters strictly for `excellent` and `comestible` taxa.
3. **Tòxics / Mortals:** Isolates poisonous species (`toxic`, `mortal`) to train the eye on hazards.
4. **Arbres socis:** Filters species linked to key indicator trees.
