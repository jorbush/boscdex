# Safety Gate Decision Flow

Safety is non-negotiable in wild mushroom foraging. The safety gate algorithm acts as a biological firewall protecting users against dangerous ingestion.

---

## 🔀 Decision Tree

```mermaid
flowchart TD
    Start([Inference Output Received]) --> CheckCount{Candidates > 0?}
    CheckCount -- No --> ReturnIncert["Nivell: Incert\n(No s'ha detectat cap exemplar)"]
    CheckCount -- Yes --> CheckConfidence{Top-1 Confidence >= 0.70?}

    CheckConfidence -- No --> ReturnLowConf["Nivell: Incert\n⚠️ 'No es pot identificar amb certesa.\nConsulta un micòleg.'"]
    
    CheckConfidence -- Yes --> CheckToxicLookalike{Has toxic lookalikes\nin database?}
    
    CheckToxicLookalike -- Yes --> ReturnToxicAlert["Nivell: Confusió Possible\n🚨 ALERTA DE CONFUSIÓ PERILLOSA\n(Mostra caixa vermella i comparació)"]
    CheckToxicLookalike -- No --> ReturnSegur["Nivell: Segur\n✅ Identificació fiable\n(Xapa de comestibilitat visible)"]
```

---

## 🛡️ Algorithmic Rules

1. **Rule 1 (Confidence Gate):** Any classification with less than $70\%$ certainty is marked `NivellSeguretat.incert`. The app explicitly refuses to give a confident green light on degraded, blurred, or juvenile specimens.
2. **Rule 2 (Toxic Precedence Gate):** If a species is known to have a toxic or deadly lookalike in Catalonia, it **must always** trigger `NivellSeguretat.confusioPossible`, even if the model predicts the edible species with $99\%$ confidence. Visual similarity in nature can deceive even experienced eyes under varying forest lighting.
3. **Rule 3 (Incentivized Education):** Tapping the safety warning box to inspect the morphological differences increases the user's progress toward the **Micòleg Prudent** badge, turning defensive safety into a rewarding game mechanic.
