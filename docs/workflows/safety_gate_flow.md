# Safety Gate Decision Flow

Safety is non-negotiable in wild mushroom foraging. The safety gate algorithm acts as a biological firewall protecting users against dangerous ingestion.

---

## 🔀 Decision Tree

```mermaid
flowchart TD
    Start([Inference Output Received]) --> CheckCount{Candidates > 0?}
    CheckCount -- No --> ReturnIncert["Nivell: Incert\n(No s'ha detectat cap exemplar)"]
    CheckCount -- Yes --> CheckSpecimenEdibility{Specimen edibility is\ntoxic or mortal?}

    CheckSpecimenEdibility -- Yes --> ReturnPerill["Nivell: Perill ☠️\n🚨 BOLET TÒXIC / MORTAL\n(Alerta màxima immediata)"]
    CheckSpecimenEdibility -- No --> CheckConfidence{Top-1 Confidence >= 0.70?}

    CheckConfidence -- No --> ReturnLowConf["Nivell: Incert\n⚠️ 'No es pot identificar amb certesa.\nConsulta un micòleg.'"]
    
    CheckConfidence -- Yes --> CheckToxicLookalike{Has toxic lookalikes\nin database?}
    
    CheckToxicLookalike -- Yes --> ReturnToxicAlert["Nivell: Confusió Possible\n🚨 ALERTA DE CONFUSIÓ PERILLOSA\n(Mostra caixa vermella i comparació)"]
    CheckToxicLookalike -- No --> CheckSecondaryToxic{Runner-up in top-3 has\ntoxic edibility >= 15%?}
    CheckSecondaryToxic -- Yes --> ReturnToxicAlert
    CheckSecondaryToxic -- No --> ReturnSegur["Nivell: Segur\n✅ Identificació fiable\n(Xapa de comestibilitat visible)"]
```

---

## 🛡️ Algorithmic Rules

1. **Rule 0 (Life-Safety Toxicity Priority):** If the specimen itself is classified as toxic or mortal, the algorithm immediately returns `NivellSeguretat.perill`. Low neural confidence must **never** suppress an alert on a potentially lethal specimen.
2. **Rule 1 (Confidence Gate):** Any classification with less than $70\%$ certainty is marked `NivellSeguretat.incert`. The app explicitly refuses to give a confident green light on degraded, blurred, or juvenile specimens.
3. **Rule 2 (Toxic Lookalike Precedence Gate):** If a species is known to have a toxic or deadly lookalike in Catalonia (21 cataloged pairs), it **must always** trigger `NivellSeguretat.confusioPossible`, even if the model predicts the edible species with $99\%$ confidence.
4. **Rule 3 (Runner-Up Toxicity Gate):** If any secondary candidate in the top-3 predictions is toxic/mortal with confidence $\ge 15\%$ and top candidate confidence is not overwhelming ($< 88\%$), the gate escalates to `NivellSeguretat.confusioPossible`.
5. **Rule 4 (Incentivized Education):** Tapping the safety warning box to inspect morphological differences fuels the **Micòleg Prudent** (5 views) and **Sentinella del Bosc** (15 views) badges, turning defensive safety into a rewarding game mechanic.
