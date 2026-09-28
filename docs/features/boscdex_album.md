# The Boscdex Album Feature

The **Boscdex Album** (`/boscdex`) is the central gamified field guide modeled after a classic Pokédex.

---

## 🎮 Core Mechanics

### 1. Dual Visual States (Discovered vs. Undiscovered)

* **Undiscovered State (Pokédex Habitat & Location Mode):**
  * Displays a dark silhouette card with the specimen's sequential entry number (`#001 ???`).
  * Tapping navigates directly to the detailed sheet in **Pokédex Area / Habitat Inspection mode** (`/boscdex/:id`):
    * **Veiled Identity:** Dark silhouette image, `#001 ???` title, `Espècie per catalogar` scientific subtitle, and mystery locked status (`🔒 No descobert`).
    * **Visible Location & Habitat ("On trobar-lo"):** Associated indicator trees (interactive chips linking to tree profiles), 12-month fruiting season calendar, and altitudinal elevation range.
    * **Locked Morphology & Safety:** Cap, gills, stem, latex, and toxic twins remain sealed behind a retro lock card until field discovery.
    * **Expedition CTA:** Quick button to open the live camera scanner (`/scan`).

* **Discovered State:**
  * Full specimen illustration/photo with edibility accent color.
  * Catalan vernacular name prominent at the base.
  * Minimalist circular corner edibility badge (`EdibilityBadge` in `iconOnly` mode).
  * Sequential Dex number.
  * Tapping navigates to the rich specimen detail sheet (`/boscdex/:id`) with full morphology, captures gallery, and safety keys revealed.

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

---

## 📸 Specimen Detail Sheet & "Les Teves Captures" Gallery

When a user taps an unlocked mushroom card from the Boscdex grid, the **Specimen Detail Screen** (`BoletDetailScreen`) provides a rich field profile:

1. **Header & Badges:** Full-bleed hero image area, Catalan vernacular name, italicized botanical binomial, rarity tier badge, and large edibility pill.
2. **"Les Teves Captures" (Your Captures Gallery):**
   * A dedicated horizontal photo carousel displaying every scan the user has personally photographed of that species.
   * Each card features the real field photograph with retro borders, scan date (e.g. `25 Set`), and neural confidence score (`🎯 89%`).
   * Tapping any capture opens the **Sighting Detail Sheet** with zoom, coincidence analytics, and photo download/sharing options.
   * If 0 scans exist for that taxon, an encouraging retro card invites the user to photograph it in the wild with a 1-tap shortcut to the Scanner (`/scan`).
3. **Safety & Toxic Lookalikes:** High-priority warning cards ([`toxic_twin_alert.dart`](file:///Users/jordi/dev/boscdex/lib/presentation/detail/toxic_twin_alert.dart)) highlighting perilous visual cousins with diagnostic field keys.
4. **Phenological Seasonality:** 12-month calendar strip highlighting peak Catalan fruiting months.
5. **Altitudinal Distribution:** Altitude range bar indicating typical Catalan terrain elevation (meters above sea level).
6. **Botanical Morphology:** Expandable sections detailing cap (*barret*), gills/pores (*làmines/tubs*), stem (*peu*), and latex (*làtex*).
7. **Associated Host Trees:** Interactive chips linking directly to mycorrhizal partner trees.
8. **Àrea de Distribució (Mapa Pokédex):**
   * A retro 16-bit pixel-art regional map of Catalonia displaying the geographic foraging zones where the species naturally thrives.
   * Active zones pulse with radar animations (`RetroColors.arcadeRed`), mimicking the classic handheld Pokédex "Area" screen.
   * Interactive zone selector chips allow exploring the comarques, terrain types, and altitudinal habits of each natural region.

---

## 🗺️ Pokémon-Style Undiscovered Species & Habitat Location

In true classic Pokédex tradition, undiscovered mushrooms in the Boscdex are not completely locked away or inaccessible:

1. **Undiscovered Card Tap:** Tapping an undiscovered card in the Boscdex grid opens the **Mystery Specimen Screen**.
2. **Veiled Identity:** The mushroom's name, photograph, morphology, and edibility remain confidential (`#001 ???`, `Espècie per catalogar`, `No descobert`).
3. **Habitat & Location Clues:** The hunter can inspect where and when to find the species in Catalonia:
   * **16-bit Catalonia Pixel Map:** Displays the pulsating natural regions where the unknown bolet grows.
   * **Symbiotic Indicator Trees:** Direct links to the mycorrhizal host trees under which the species fruits.
   * **Fruiting Altitude & Seasonality:** Elevation bounds and active months.
4. **Direct Camera Call-to-Action:** A prominent button (`Cercar amb la càmera`) takes the forager directly to the AI scanner to search for and unlock the specimen.


