# Guia de Contribució a Boscdex 🍄🌲

Gràcies pel teu interès en col·laborar amb **Boscdex**, la guia micològica i d'arbres indicadors 100% offline amb estètica retro Game Boy per als boscos de Catalunya.

---

## 🏛️ Principis Fonamentals del Projecte

1. **Seguretat Micològica Vital:**  
   La identificació de bolets és una activitat de risc vital. Cap canvi o decisió de disseny pot comprometre la claredat dels avisos de toxicitat (`SafetyGateService`, `ToxicTwinAlert`, nivell de confusió perillosa). Si hi ha qualsevol dubte taxonòmic o de confiança, el sistema ha de fallar de manera segura (*fail closed*).

2. **100% Offline-First i Privadesa Total:**  
   L'aplicació ha de funcionar completament sense connexió a internet al mig del bosc. Les coordenades GPS de les clapes de bolets i les fotografies mai surten del dispositiu de l'usuari. No s'admeten dependències que requereixin connectivitat remota o telemetria en temps d'execució.

3. **Harmonia Estètica Retro (16-bit):**  
   Tots els elements visuals segueixen la temàtica retro: paleta de colors forestals de baix contrast, tipografia de píxel (`Pixelify Sans`), i iconografia en pixel art amb `FilterQuality.none` per preservar les vores nítides.

4. **Compatibilitat d'Entorn:**  
   El codi ha de mantenir compatibilitat estricta amb **Dart 2.18 / Flutter 3.3.3**:
   - Utilitzar `Key? key` i `super(key: key)` (NO utilitzar `super.key`).
   - NO utilitzar patrons o records de Dart 3 ni `switch` expressions (utilitzar sentències `switch`).
   - Evitar `Color.withValues()` (utilitzar `Color.withOpacity()` segons el SDK 3.3.3).

---

## 🛠️ Configuració de l'Entorn de Desenvolupament

### Requisits
- Flutter SDK 3.3.3 o compatible
- Dart SDK 2.18.x
- Java 17 + Android SDK 33
- Xcode 14+ (per a desenvolupament iOS)

### Passos inicials
```bash
# Instal·lar dependències
flutter pub get

# Generar codi de base de dades Drift
flutter pub run build_runner build --delete-conflicting-outputs

# Executar l'analitzador estàtic (ha de retornar 0 incidències)
flutter analyze

# Executar la suite de tests automatitzats
flutter test --exclude-tags ml_benchmark
```

---

## 🍄 Com Afegir una Nova Espècie de Bolet al Catàleg

Per afegir una nova espècie al catàleg del Boscdex, cal seguir aquests 7 passos de forma coordinada:

### 1. Afegir el registre a la base de dades llavor (`SeedData`)
Edita [`lib/data/database/seed/seed_data.dart`](file:///Users/jordi/dev/boscdex/lib/data/database/seed/seed_data.dart) dins de `getBoletsSeed()`:
```dart
BoletsCompanion(
  id: const Value('nom_cientific_slug'),       // e.g. 'marasmius_oreades'
  catalanName: const Value('Carrereta / Cama-sec'),
  scientificName: const Value('Marasmius oreades'),
  family: const Value('Marasmiaceae'),
  rarityTier: const Value('comu'),              // 'comu', 'poc_frequent', 'rar', 'molt_rar', 'llegendari'
  edibility: const Value('excellent'),          // 'excellent', 'comestible', 'sense_valor', 'toxic', 'mortal'
  fruitingSeason: const Value('[5,6,9,10,11]'), // Mesos de fructificació en format JSON
  altitudeMin: const Value(200),
  altitudeMax: const Value(1800),
  capDescription: const Value('...'),
  gillsDescription: const Value('...'),
  stemDescription: const Value('...'),
  latexDescription: const Value(null),          // O descripció si en té (e.g. gènere Lactarius)
  safetyNotes: const Value('...'),
  dexNumber: const Value(23),                   // Següent número correlatiu
)
```

### 2. Establir les Associacions amb Arbres Indicadors
A `SeedData.getBoletArbreAssociationsSeed()`, enllaça el bolet amb els seus arbres socis simbiòtics o hàbitats:
```dart
const BoletArbreAssociationsCompanion(
  boletId: Value('nom_cientific_slug'),
  arbreId: Value('quercus_ilex'),
),
```

### 3. Declarar Possibles Confusions Perilloses (*Toxic Lookalikes*)
Si el bolet té semblances amb alguna espècie tòxica o mortal, declara-la a `SeedData.getToxicLookalikesSeed()`:
```dart
const ToxicLookalikesCompanion(
  boletId: Value('nom_cientific_slug'),
  lookalikeBoletId: Value('amanita_phalloides'),
  comparisonNotes: Value('Diferències morfològiques clau...'),
),
```

### 4. Afegir Traduccions Trilingües (`SpeciesLocalizer`)
Edita [`lib/core/localization/species_localizer.dart`](file:///Users/jordi/dev/boscdex/lib/core/localization/species_localizer.dart):
- Nom comú en Català, Castellà i Anglès a `_mushroomNames`.
- Descripcions morfològiques a `_mushroomMorphology` (barret, làmines, peu, làtex, seguretat).
- Notes comparatives de confusions a `_lookalikeNotes`.

### 5. Incorporar el Sprite Pixel Art
1. Genera o dissenya una il·lustració en pixel art de 16 bits (128x128 píxels, fons transparent).
2. Desa la imatge a `assets/images/mushrooms/<nom_cientific_slug>.png`.
3. Assegura't que el fitxer està inclòs a la secció `assets:` de `pubspec.yaml`.

### 6. Sincronitzar el Model Edge ML (TFLite)
1. Afegeix la nova etiqueta a [`assets/models/mushroom_classifier_labels.txt`](file:///Users/jordi/dev/boscdex/assets/models/mushroom_classifier_labels.txt).
2. Si has entrenat un nou cap de classificació amb MobileNetV2, actualitza els pesos a `assets/models/mushroom_head_weights.json` o el model corresponent.
3. Afegeix fotografies reals de camp a `test/assets/test_mushrooms/<nom_cientific_slug>/` per validar la precisió del classificador.

### 7. Validar amb Tests
Executa el test de càrrega d'actius per verificar que la imatge i les dades estan ben configurades:
```bash
flutter test test/unit_tests/presentation/asset_load_test.dart
```

---

## 🌲 Com Afegir un Nou Arbre Indicador

1. **Registre:** Afegeix el registre a `SeedData.getArbresSeed()` a `seed_data.dart`.
2. **Traduccions:** Afegeix el nom i les descripcions d'escorça i fulla a `SpeciesLocalizer`.
3. **Sprite:** Afegeix la imatge de l'arbre a `assets/images/trees/<arbre_id>.png`.
4. **Relacions:** Afegeix les associacions amb els bolets pertinents.

---

## 🧪 Estratègia de Proves i Qualitat

El projecte compta amb una suite de proves estructurada en tres nivells:

1. **Unit Tests (`test/unit_tests/`):**
   - Validació de models de domini, `SafetyGateService`, `BadgeProgressionService`, `SpeciesLocalizer`, i widgets aïllats.
2. **Integration Tests (`test/integration_tests/`):**
   - Proves de base de dades SQLite en memòria, transaccions en DAOs, cicle de vida de fotografies i providers de Riverpod.
3. **Golden Snapshot Tests (`test/unit_tests/presentation/golden_retro_widgets_test.dart`):**
   - Garanteixen que els canvis de codi no trenquin l'estètica ni la disposició dels components retro (insígnies d'edibilitat, vores de raresa, barres de progrés).
   - Per regenerar les imatges de referència:
     ```bash
     flutter test test/unit_tests/presentation/golden_retro_widgets_test.dart --update-goldens
     ```
4. **ML Benchmarks (`test/integration_tests/services/`):**
   - Proves amb fotos reals de camp aïllades amb `@Tags(['ml_benchmark'])` per no alentir la integració contínua estàndard.
   - Per executar-los explícitament:
     ```bash
     flutter test --tags ml_benchmark
     ```

---

## 📦 Preparació per a Producció i Publicació

### Android Keystore
Per generar un paquet de producció (AAB / APK signat):
1. Copia `android/key.properties.example` a `android/key.properties`.
2. Introdueix la ruta del teu magatzem de claus (`.jks`) i les credencials.
3. El fitxer `key.properties` està protegit per `.gitignore` i mai s'ha de commitar.
4. Les regles de minificació R8/ProGuard es troben a `android/app/proguard-rules.pro`.

### iOS Permisos
Les descripcions de permisos per a la càmera, galeria i geolocalització es troben localitzades a:
- `ios/Runner/ca.lproj/InfoPlist.strings` (Català)
- `ios/Runner/es.lproj/InfoPlist.strings` (Castellà)
- `ios/Runner/en.lproj/InfoPlist.strings` (Anglès)
