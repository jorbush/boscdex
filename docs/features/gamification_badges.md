# Gamification & Badges Feature

Boscdex gamifies field exploration without requiring a remote server or social network backend. All achievement triggers run locally on database events.

---

## 🎖️ The 6 Starter Badges

The starter list of badges focuses on exploration milestones and safety habits:

| Badge ID | Catalan Title | Target | Unlock Condition |
|---|---|:---:|---|
| `primer_pas_al_bosc` | **Primer Pas al Bosc** | 1 | Register your very first specimen in the Boscdex. |
| `cacador_de_rovellons` | **Caçador de Rovellons** | 2 | Register both *Lactarius deliciosus* (Pinetell) and *Lactarius sanguifluus* (Rovelló de sang). |
| `micoleg_prudent` | **Micòleg Prudent** | 5 | Tap into the "Confusió Perillosa" comparison screen 5 times (encourages safety). |
| `alianca_silvestre` | **Aliança Silvestre** | 1 | Discover both a mushroom and its associated indicator tree. |
| `cistell_de_tardor` | **Cistell de Tardor** | 15 | Register at least 15 different species in the Boscdex. |
| `mestre_boletaire` | **Mestre Boletaire** | 50 | Register 50+ different species in the Boscdex. |

---

## ⚙️ Trigger Evaluation Engine (`BadgeService`)

Badge evaluation runs seamlessly in the background whenever the user:
1. **Registers a specimen from the scan sheet:** Triggers checks for `primer_pas_al_bosc`, `cacador_de_rovellons`, `alianca_silvestre`, `cistell_de_tardor`, and `mestre_boletaire`.
2. **Inspects a toxic lookalike comparison card:** Increments `toxicComparisonViewCount` and evaluates `micoleg_prudent`.

```dart
final updatedBadges = await badgeService.evaluateBadges(
  discoveryCount: allDiscoveries.length,
  hasRovello: hasRovello,
  hasPinetell: hasPinetell,
  toxicComparisonViewCount: toxicViews,
  hasTreeAlliance: hasTreeAlliance,
  currentBadges: currentDomainBadges,
);
```

---

## 🏆 Insignies Dialog UI (`InsigniesDialog`)

Tapping the trophy icon in the Boscdex AppBar displays the badges modal:
* Top summary counter displaying awarded badges (e.g., `2/6`).
* **Locked Badges:** Muted cards displaying current progress bar (e.g., `3/5 comparacions`).
* **Awarded Badges:** Green surface highlight, gold verified badge icon, and golden border with `DESBLOQUEJAT` tag.
