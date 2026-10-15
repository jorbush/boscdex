# Gamification & Badges Feature

Boscdex gamifies field exploration without requiring a remote server or social network backend. All achievement triggers run locally on database events.

---

## 🎖️ The 14 Achievement Badges

Boscdex features 14 achievement badges spanning collection milestones, symbiotic pairings, culinary classics, safety vigilance, and field journaling:

| Badge ID | Catalan Title | Target | Unlock Condition |
|---|---|:---:|---|
| `primer_pas_al_bosc` | **Primer Pas al Bosc** | 1 | Register your very first specimen in the Boscdex. |
| `cacador_de_rovellons` | **Caçador de Rovellons** | 2 | Register both *Lactarius deliciosus* (Pinetell) and *Lactarius sanguifluus* (Rovelló de sang). |
| `micoleg_prudent` | **Micòleg Prudent** | 5 | Tap into the "Confusió Perillosa" comparison screen 5 times (encourages safety). |
| `alianca_silvestre` | **Aliança Silvestre** | 1 | Discover both a mushroom and its associated indicator tree. |
| `cistell_de_tardor` | **Cistell de Tardor** | 15 | Register at least 15 different species in the Boscdex. |
| `mestre_boletaire` | **Mestre Boletaire** | 20 | Register 20 different species in the Boscdex. |
| `senyor_dels_ceps` | **Senyor dels Ceps** | 2 | Discover both the noble King Bolete (*Boletus edulis*) and Dark Cep (*Boletus aereus*). |
| `gourmet_del_bosc` | **Gourmet del Bosc** | 4 | Discover 4 culinary stars: Cep, Ou de reig, Rossinyol, and Trompeta de la mort. |
| `amic_dels_arbres` | **Amic dels Arbres** | 5 | Identify all 5 indicator trees of Catalonia (Pi roig, Pi blanc, Alzina, Faig, Castanyer). |
| `esperit_de_primavera` | **Esperit de Primavera** | 3 | Discover 3 iconic spring mushrooms: Múrgola, Moixernó, and Carrereta. |
| `sentinella_toxic` | **Sentinella del Bosc** | 15 | Review 15 toxic lookalike alerts to sharpen field safety vigilance. |
| `quadern_de_camp` | **Quadern de Camp** | 10 | Record 10 sightings in your offline field journal. |
| `cartograf_del_bosc` | **Cartògraf del Bosc** | 5 | Record 5 sightings with GPS coordinates to map your field observations. |
| `gran_enciclopedia` | **Gran Enciclopèdia** | 47 | Complete the catalog by discovering all 47 mushrooms in the Boscdex! |

---

## ⚙️ Trigger Evaluation Engine (`BadgeService` & `BadgeProgressionService`)

Badge evaluation runs seamlessly in the background whenever the user:
1. **Registers a specimen from the scan sheet:** Triggers checks for discovery-based badges (`primer_pas_al_bosc`, `cacador_de_rovellons`, `senyor_dels_ceps`, `gourmet_del_bosc`, `esperit_de_primavera`, `cistell_de_tardor`, `mestre_boletaire`, `gran_enciclopedia`).
2. **Inspects a toxic lookalike comparison card:** Increments `toxicComparisonViewCount` and evaluates `micoleg_prudent` (5) and `sentinella_toxic` (15).
3. **Visits an indicator tree:** Triggers checks for `alianca_silvestre` and `amic_dels_arbres` (5 trees).
4. **Logs journal observations with coordinates:** Triggers checks for `quadern_de_camp` (10 sightings) and `cartograf_del_bosc` (5 GPS sightings).

The pure domain logic is evaluated by `BadgeService` and coordinated with SQLite persistence via `BadgeProgressionService`:

```dart
await BadgeProgressionService().syncBadgeProgression(
  db: db,
  toxicComparisonViewCount: toxicViews,
  visitedTreeIds: visitedTrees,
);
```

---

## 🏆 Insignies Dialog UI (`InsigniesDialog`)

Tapping the trophy icon in the Boscdex AppBar displays the badges modal:
* Top summary counter displaying awarded badges (e.g., `2/14`).
* **Locked Badges:** Muted cards displaying current progress bar (e.g., `3/5 comparacions`).
* **Awarded Badges:** Green surface highlight, themed medal icon, and golden border with `DESBLOQUEJAT` tag.
* **Level Navigation Banner:** Tappable pill banner linking directly to the Forager Level dialog.

---

## 🌲 Forager Leveling System ("Nivell de Boletaire")

Beyond individual trophy badges, Boscdex features an integrated player progression system that dynamically computes the user's forager rank, total experience points (XP), and progress towards subsequent titles based entirely on on-device field achievements.

### 1. Activity Experience (XP) Multipliers

XP is awarded transparently across core foraging milestones:

| Activity | XP Awarded | Description |
|---|:---:|---|
| **Mushroom Cataloged** | `+100 XP` | Unlocking a new species in the Boscdex (`discoveryCount`). |
| **Indicator Tree Identified** | `+75 XP` | Visiting/identifying a symbiotic host tree (`visitedArbresCount`). |
| **Achievement Badge Awarded** | `+150 XP` | Completing any of the 14 badge milestones (`awardedBadgesCount`). |
| **Journal Sighting Logged** | `+25 XP` | Recording a validated field observation in the offline logbook (`totalSightingsCount`). |

### 2. The 10 Foraging Ranks & XP Thresholds

Progression spans 10 distinct ranks with trilingual localization (`ca`, `es`, `en`):

| Level | XP Threshold | Catalan Title | Spanish Title | English Title |
|:---:|:---:|---|---|---|
| **1** | `0 XP` | **Novell del Bosc** | Novato del Bosque | Forest Rookie |
| **2** | `100 XP` | **Cercador Curiós** | Buscador Curioso | Curious Seeker |
| **3** | `250 XP` | **Rastrejador Silvestre** | Rastreador Silvestre | Wilderness Tracker |
| **4** | `500 XP` | **Explorador dels Pins** | Explorador de los Pinos | Pine Explorer |
| **5** | `850 XP` | **Boletaire de Camp** | Recolector de Campo | Field Forager |
| **6** | `1300 XP` | **Guia de la Fageda** | Guía del Hayedo | Beechwood Guide |
| **7** | `1900 XP` | **Expert Micòleg** | Experto Micólogo | Expert Mycologist |
| **8** | `2650 XP` | **Guardià del Sotabosc** | Guardián del Sotobosque | Understory Guardian |
| **9** | `3550 XP` | **Cistell Daurat** | Cesta Dorada | Golden Basket |
| **10** | `4600 XP` | **Mestre del Bosc** | Maestro del Bosque | Master of the Forest |

### 3. Architecture & Reactive State Management

The leveling engine is encapsulated in pure Dart domain models and wired reactively through Riverpod:

* **Domain Model (`lib/domain/models/forager_level.dart`):** `ForagerLevel.calculate(...)` evaluates raw stats against the ascending thresholds, calculating proportional in-level progress (`0.0` to `1.0`), remaining XP required for the next rank, and localized titles.
* **Provider (`lib/presentation/boscdex/boscdex_provider.dart`):** `foragerLevelProvider` watches `discoveryCountProvider`, `visitedArbresCountProvider`, `awardedBadgesCountProvider`, and `totalSightingsCountProvider` to compute level updates reactively whenever the local SQLite database mutates.

### 4. User Interface Integrations

* **Boscdex AppBar HUD Badge (`BoscdexScreen`):** Displays dynamic `LVL ${level.level}` in a 16-bit pixel font container. Tapping the badge triggers light haptic feedback and opens the detail dialog.
* **Forager Level Modal Sheet (`ForagerLevelDialog`):**
  * **Current Level Hero Card:** Retro card displaying current rank title, pixel level badge, total accumulated XP, segmented `RetroProgressBar`, and next-rank threshold countdown.
  * **Experience Breakdown Matrix:** 4-card matrix itemizing points gained from bolets, trees, badges, and sightings.
  * **Ranks Roadmap:** Full 10-tier roadmap highlighting current position with an `ACTUAL` badge, locked tiers, and required XP milestones.
* **Insignies Dialog Banner (`InsigniesDialog`):** Level navigation pill header providing 1-tap navigation from the trophy case to the leveling breakdown.
* **Settings Screen Status (`SettingsScreen`):** Displays current level title and XP in the Expedition Status diagnostic row.
