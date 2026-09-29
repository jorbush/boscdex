// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BoletsTable extends Bolets with TableInfo<$BoletsTable, Bolet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _catalanNameMeta =
      const VerificationMeta('catalanName');
  @override
  late final GeneratedColumn<String> catalanName = GeneratedColumn<String>(
      'catalan_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
      'family', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rarityTierMeta =
      const VerificationMeta('rarityTier');
  @override
  late final GeneratedColumn<String> rarityTier = GeneratedColumn<String>(
      'rarity_tier', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _edibilityMeta =
      const VerificationMeta('edibility');
  @override
  late final GeneratedColumn<String> edibility = GeneratedColumn<String>(
      'edibility', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fruitingSeasonMeta =
      const VerificationMeta('fruitingSeason');
  @override
  late final GeneratedColumn<String> fruitingSeason = GeneratedColumn<String>(
      'fruiting_season', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _altitudeMinMeta =
      const VerificationMeta('altitudeMin');
  @override
  late final GeneratedColumn<int> altitudeMin = GeneratedColumn<int>(
      'altitude_min', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMaxMeta =
      const VerificationMeta('altitudeMax');
  @override
  late final GeneratedColumn<int> altitudeMax = GeneratedColumn<int>(
      'altitude_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _capDescriptionMeta =
      const VerificationMeta('capDescription');
  @override
  late final GeneratedColumn<String> capDescription = GeneratedColumn<String>(
      'cap_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gillsDescriptionMeta =
      const VerificationMeta('gillsDescription');
  @override
  late final GeneratedColumn<String> gillsDescription = GeneratedColumn<String>(
      'gills_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stemDescriptionMeta =
      const VerificationMeta('stemDescription');
  @override
  late final GeneratedColumn<String> stemDescription = GeneratedColumn<String>(
      'stem_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latexDescriptionMeta =
      const VerificationMeta('latexDescription');
  @override
  late final GeneratedColumn<String> latexDescription = GeneratedColumn<String>(
      'latex_description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _safetyNotesMeta =
      const VerificationMeta('safetyNotes');
  @override
  late final GeneratedColumn<String> safetyNotes = GeneratedColumn<String>(
      'safety_notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageAssetPathMeta =
      const VerificationMeta('imageAssetPath');
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
      'image_asset_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _silhouetteAssetPathMeta =
      const VerificationMeta('silhouetteAssetPath');
  @override
  late final GeneratedColumn<String> silhouetteAssetPath =
      GeneratedColumn<String>('silhouette_asset_path', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dexNumberMeta =
      const VerificationMeta('dexNumber');
  @override
  late final GeneratedColumn<int> dexNumber = GeneratedColumn<int>(
      'dex_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        catalanName,
        scientificName,
        family,
        rarityTier,
        edibility,
        fruitingSeason,
        altitudeMin,
        altitudeMax,
        capDescription,
        gillsDescription,
        stemDescription,
        latexDescription,
        safetyNotes,
        imageAssetPath,
        silhouetteAssetPath,
        dexNumber
      ];
  @override
  String get aliasedName => _alias ?? 'bolets';
  @override
  String get actualTableName => 'bolets';
  @override
  VerificationContext validateIntegrity(Insertable<Bolet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('catalan_name')) {
      context.handle(
          _catalanNameMeta,
          catalanName.isAcceptableOrUnknown(
              data['catalan_name']!, _catalanNameMeta));
    } else if (isInserting) {
      context.missing(_catalanNameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family']!, _familyMeta));
    } else if (isInserting) {
      context.missing(_familyMeta);
    }
    if (data.containsKey('rarity_tier')) {
      context.handle(
          _rarityTierMeta,
          rarityTier.isAcceptableOrUnknown(
              data['rarity_tier']!, _rarityTierMeta));
    } else if (isInserting) {
      context.missing(_rarityTierMeta);
    }
    if (data.containsKey('edibility')) {
      context.handle(_edibilityMeta,
          edibility.isAcceptableOrUnknown(data['edibility']!, _edibilityMeta));
    } else if (isInserting) {
      context.missing(_edibilityMeta);
    }
    if (data.containsKey('fruiting_season')) {
      context.handle(
          _fruitingSeasonMeta,
          fruitingSeason.isAcceptableOrUnknown(
              data['fruiting_season']!, _fruitingSeasonMeta));
    } else if (isInserting) {
      context.missing(_fruitingSeasonMeta);
    }
    if (data.containsKey('altitude_min')) {
      context.handle(
          _altitudeMinMeta,
          altitudeMin.isAcceptableOrUnknown(
              data['altitude_min']!, _altitudeMinMeta));
    }
    if (data.containsKey('altitude_max')) {
      context.handle(
          _altitudeMaxMeta,
          altitudeMax.isAcceptableOrUnknown(
              data['altitude_max']!, _altitudeMaxMeta));
    }
    if (data.containsKey('cap_description')) {
      context.handle(
          _capDescriptionMeta,
          capDescription.isAcceptableOrUnknown(
              data['cap_description']!, _capDescriptionMeta));
    } else if (isInserting) {
      context.missing(_capDescriptionMeta);
    }
    if (data.containsKey('gills_description')) {
      context.handle(
          _gillsDescriptionMeta,
          gillsDescription.isAcceptableOrUnknown(
              data['gills_description']!, _gillsDescriptionMeta));
    } else if (isInserting) {
      context.missing(_gillsDescriptionMeta);
    }
    if (data.containsKey('stem_description')) {
      context.handle(
          _stemDescriptionMeta,
          stemDescription.isAcceptableOrUnknown(
              data['stem_description']!, _stemDescriptionMeta));
    } else if (isInserting) {
      context.missing(_stemDescriptionMeta);
    }
    if (data.containsKey('latex_description')) {
      context.handle(
          _latexDescriptionMeta,
          latexDescription.isAcceptableOrUnknown(
              data['latex_description']!, _latexDescriptionMeta));
    }
    if (data.containsKey('safety_notes')) {
      context.handle(
          _safetyNotesMeta,
          safetyNotes.isAcceptableOrUnknown(
              data['safety_notes']!, _safetyNotesMeta));
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
          _imageAssetPathMeta,
          imageAssetPath.isAcceptableOrUnknown(
              data['image_asset_path']!, _imageAssetPathMeta));
    }
    if (data.containsKey('silhouette_asset_path')) {
      context.handle(
          _silhouetteAssetPathMeta,
          silhouetteAssetPath.isAcceptableOrUnknown(
              data['silhouette_asset_path']!, _silhouetteAssetPathMeta));
    }
    if (data.containsKey('dex_number')) {
      context.handle(_dexNumberMeta,
          dexNumber.isAcceptableOrUnknown(data['dex_number']!, _dexNumberMeta));
    } else if (isInserting) {
      context.missing(_dexNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bolet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bolet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      catalanName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}catalan_name'])!,
      scientificName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scientific_name'])!,
      family: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family'])!,
      rarityTier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity_tier'])!,
      edibility: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}edibility'])!,
      fruitingSeason: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}fruiting_season'])!,
      altitudeMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_min']),
      altitudeMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}altitude_max']),
      capDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cap_description'])!,
      gillsDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}gills_description'])!,
      stemDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}stem_description'])!,
      latexDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}latex_description']),
      safetyNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}safety_notes']),
      imageAssetPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_asset_path']),
      silhouetteAssetPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}silhouette_asset_path']),
      dexNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}dex_number'])!,
    );
  }

  @override
  $BoletsTable createAlias(String alias) {
    return $BoletsTable(attachedDatabase, alias);
  }
}

class Bolet extends DataClass implements Insertable<Bolet> {
  final String id;
  final String catalanName;
  final String scientificName;
  final String family;
  final String rarityTier;
  final String edibility;
  final String fruitingSeason;
  final int? altitudeMin;
  final int? altitudeMax;
  final String capDescription;
  final String gillsDescription;
  final String stemDescription;
  final String? latexDescription;
  final String? safetyNotes;
  final String? imageAssetPath;
  final String? silhouetteAssetPath;
  final int dexNumber;
  const Bolet(
      {required this.id,
      required this.catalanName,
      required this.scientificName,
      required this.family,
      required this.rarityTier,
      required this.edibility,
      required this.fruitingSeason,
      this.altitudeMin,
      this.altitudeMax,
      required this.capDescription,
      required this.gillsDescription,
      required this.stemDescription,
      this.latexDescription,
      this.safetyNotes,
      this.imageAssetPath,
      this.silhouetteAssetPath,
      required this.dexNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['catalan_name'] = Variable<String>(catalanName);
    map['scientific_name'] = Variable<String>(scientificName);
    map['family'] = Variable<String>(family);
    map['rarity_tier'] = Variable<String>(rarityTier);
    map['edibility'] = Variable<String>(edibility);
    map['fruiting_season'] = Variable<String>(fruitingSeason);
    if (!nullToAbsent || altitudeMin != null) {
      map['altitude_min'] = Variable<int>(altitudeMin);
    }
    if (!nullToAbsent || altitudeMax != null) {
      map['altitude_max'] = Variable<int>(altitudeMax);
    }
    map['cap_description'] = Variable<String>(capDescription);
    map['gills_description'] = Variable<String>(gillsDescription);
    map['stem_description'] = Variable<String>(stemDescription);
    if (!nullToAbsent || latexDescription != null) {
      map['latex_description'] = Variable<String>(latexDescription);
    }
    if (!nullToAbsent || safetyNotes != null) {
      map['safety_notes'] = Variable<String>(safetyNotes);
    }
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    if (!nullToAbsent || silhouetteAssetPath != null) {
      map['silhouette_asset_path'] = Variable<String>(silhouetteAssetPath);
    }
    map['dex_number'] = Variable<int>(dexNumber);
    return map;
  }

  BoletsCompanion toCompanion(bool nullToAbsent) {
    return BoletsCompanion(
      id: Value(id),
      catalanName: Value(catalanName),
      scientificName: Value(scientificName),
      family: Value(family),
      rarityTier: Value(rarityTier),
      edibility: Value(edibility),
      fruitingSeason: Value(fruitingSeason),
      altitudeMin: altitudeMin == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMin),
      altitudeMax: altitudeMax == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMax),
      capDescription: Value(capDescription),
      gillsDescription: Value(gillsDescription),
      stemDescription: Value(stemDescription),
      latexDescription: latexDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(latexDescription),
      safetyNotes: safetyNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(safetyNotes),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
      silhouetteAssetPath: silhouetteAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(silhouetteAssetPath),
      dexNumber: Value(dexNumber),
    );
  }

  factory Bolet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bolet(
      id: serializer.fromJson<String>(json['id']),
      catalanName: serializer.fromJson<String>(json['catalanName']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      family: serializer.fromJson<String>(json['family']),
      rarityTier: serializer.fromJson<String>(json['rarityTier']),
      edibility: serializer.fromJson<String>(json['edibility']),
      fruitingSeason: serializer.fromJson<String>(json['fruitingSeason']),
      altitudeMin: serializer.fromJson<int?>(json['altitudeMin']),
      altitudeMax: serializer.fromJson<int?>(json['altitudeMax']),
      capDescription: serializer.fromJson<String>(json['capDescription']),
      gillsDescription: serializer.fromJson<String>(json['gillsDescription']),
      stemDescription: serializer.fromJson<String>(json['stemDescription']),
      latexDescription: serializer.fromJson<String?>(json['latexDescription']),
      safetyNotes: serializer.fromJson<String?>(json['safetyNotes']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
      silhouetteAssetPath:
          serializer.fromJson<String?>(json['silhouetteAssetPath']),
      dexNumber: serializer.fromJson<int>(json['dexNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catalanName': serializer.toJson<String>(catalanName),
      'scientificName': serializer.toJson<String>(scientificName),
      'family': serializer.toJson<String>(family),
      'rarityTier': serializer.toJson<String>(rarityTier),
      'edibility': serializer.toJson<String>(edibility),
      'fruitingSeason': serializer.toJson<String>(fruitingSeason),
      'altitudeMin': serializer.toJson<int?>(altitudeMin),
      'altitudeMax': serializer.toJson<int?>(altitudeMax),
      'capDescription': serializer.toJson<String>(capDescription),
      'gillsDescription': serializer.toJson<String>(gillsDescription),
      'stemDescription': serializer.toJson<String>(stemDescription),
      'latexDescription': serializer.toJson<String?>(latexDescription),
      'safetyNotes': serializer.toJson<String?>(safetyNotes),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
      'silhouetteAssetPath': serializer.toJson<String?>(silhouetteAssetPath),
      'dexNumber': serializer.toJson<int>(dexNumber),
    };
  }

  Bolet copyWith(
          {String? id,
          String? catalanName,
          String? scientificName,
          String? family,
          String? rarityTier,
          String? edibility,
          String? fruitingSeason,
          Value<int?> altitudeMin = const Value.absent(),
          Value<int?> altitudeMax = const Value.absent(),
          String? capDescription,
          String? gillsDescription,
          String? stemDescription,
          Value<String?> latexDescription = const Value.absent(),
          Value<String?> safetyNotes = const Value.absent(),
          Value<String?> imageAssetPath = const Value.absent(),
          Value<String?> silhouetteAssetPath = const Value.absent(),
          int? dexNumber}) =>
      Bolet(
        id: id ?? this.id,
        catalanName: catalanName ?? this.catalanName,
        scientificName: scientificName ?? this.scientificName,
        family: family ?? this.family,
        rarityTier: rarityTier ?? this.rarityTier,
        edibility: edibility ?? this.edibility,
        fruitingSeason: fruitingSeason ?? this.fruitingSeason,
        altitudeMin: altitudeMin.present ? altitudeMin.value : this.altitudeMin,
        altitudeMax: altitudeMax.present ? altitudeMax.value : this.altitudeMax,
        capDescription: capDescription ?? this.capDescription,
        gillsDescription: gillsDescription ?? this.gillsDescription,
        stemDescription: stemDescription ?? this.stemDescription,
        latexDescription: latexDescription.present
            ? latexDescription.value
            : this.latexDescription,
        safetyNotes: safetyNotes.present ? safetyNotes.value : this.safetyNotes,
        imageAssetPath:
            imageAssetPath.present ? imageAssetPath.value : this.imageAssetPath,
        silhouetteAssetPath: silhouetteAssetPath.present
            ? silhouetteAssetPath.value
            : this.silhouetteAssetPath,
        dexNumber: dexNumber ?? this.dexNumber,
      );
  @override
  String toString() {
    return (StringBuffer('Bolet(')
          ..write('id: $id, ')
          ..write('catalanName: $catalanName, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('rarityTier: $rarityTier, ')
          ..write('edibility: $edibility, ')
          ..write('fruitingSeason: $fruitingSeason, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax, ')
          ..write('capDescription: $capDescription, ')
          ..write('gillsDescription: $gillsDescription, ')
          ..write('stemDescription: $stemDescription, ')
          ..write('latexDescription: $latexDescription, ')
          ..write('safetyNotes: $safetyNotes, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('silhouetteAssetPath: $silhouetteAssetPath, ')
          ..write('dexNumber: $dexNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      catalanName,
      scientificName,
      family,
      rarityTier,
      edibility,
      fruitingSeason,
      altitudeMin,
      altitudeMax,
      capDescription,
      gillsDescription,
      stemDescription,
      latexDescription,
      safetyNotes,
      imageAssetPath,
      silhouetteAssetPath,
      dexNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bolet &&
          other.id == this.id &&
          other.catalanName == this.catalanName &&
          other.scientificName == this.scientificName &&
          other.family == this.family &&
          other.rarityTier == this.rarityTier &&
          other.edibility == this.edibility &&
          other.fruitingSeason == this.fruitingSeason &&
          other.altitudeMin == this.altitudeMin &&
          other.altitudeMax == this.altitudeMax &&
          other.capDescription == this.capDescription &&
          other.gillsDescription == this.gillsDescription &&
          other.stemDescription == this.stemDescription &&
          other.latexDescription == this.latexDescription &&
          other.safetyNotes == this.safetyNotes &&
          other.imageAssetPath == this.imageAssetPath &&
          other.silhouetteAssetPath == this.silhouetteAssetPath &&
          other.dexNumber == this.dexNumber);
}

class BoletsCompanion extends UpdateCompanion<Bolet> {
  final Value<String> id;
  final Value<String> catalanName;
  final Value<String> scientificName;
  final Value<String> family;
  final Value<String> rarityTier;
  final Value<String> edibility;
  final Value<String> fruitingSeason;
  final Value<int?> altitudeMin;
  final Value<int?> altitudeMax;
  final Value<String> capDescription;
  final Value<String> gillsDescription;
  final Value<String> stemDescription;
  final Value<String?> latexDescription;
  final Value<String?> safetyNotes;
  final Value<String?> imageAssetPath;
  final Value<String?> silhouetteAssetPath;
  final Value<int> dexNumber;
  const BoletsCompanion({
    this.id = const Value.absent(),
    this.catalanName = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.family = const Value.absent(),
    this.rarityTier = const Value.absent(),
    this.edibility = const Value.absent(),
    this.fruitingSeason = const Value.absent(),
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
    this.capDescription = const Value.absent(),
    this.gillsDescription = const Value.absent(),
    this.stemDescription = const Value.absent(),
    this.latexDescription = const Value.absent(),
    this.safetyNotes = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.silhouetteAssetPath = const Value.absent(),
    this.dexNumber = const Value.absent(),
  });
  BoletsCompanion.insert({
    required String id,
    required String catalanName,
    required String scientificName,
    required String family,
    required String rarityTier,
    required String edibility,
    required String fruitingSeason,
    this.altitudeMin = const Value.absent(),
    this.altitudeMax = const Value.absent(),
    required String capDescription,
    required String gillsDescription,
    required String stemDescription,
    this.latexDescription = const Value.absent(),
    this.safetyNotes = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
    this.silhouetteAssetPath = const Value.absent(),
    required int dexNumber,
  })  : id = Value(id),
        catalanName = Value(catalanName),
        scientificName = Value(scientificName),
        family = Value(family),
        rarityTier = Value(rarityTier),
        edibility = Value(edibility),
        fruitingSeason = Value(fruitingSeason),
        capDescription = Value(capDescription),
        gillsDescription = Value(gillsDescription),
        stemDescription = Value(stemDescription),
        dexNumber = Value(dexNumber);
  static Insertable<Bolet> custom({
    Expression<String>? id,
    Expression<String>? catalanName,
    Expression<String>? scientificName,
    Expression<String>? family,
    Expression<String>? rarityTier,
    Expression<String>? edibility,
    Expression<String>? fruitingSeason,
    Expression<int>? altitudeMin,
    Expression<int>? altitudeMax,
    Expression<String>? capDescription,
    Expression<String>? gillsDescription,
    Expression<String>? stemDescription,
    Expression<String>? latexDescription,
    Expression<String>? safetyNotes,
    Expression<String>? imageAssetPath,
    Expression<String>? silhouetteAssetPath,
    Expression<int>? dexNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catalanName != null) 'catalan_name': catalanName,
      if (scientificName != null) 'scientific_name': scientificName,
      if (family != null) 'family': family,
      if (rarityTier != null) 'rarity_tier': rarityTier,
      if (edibility != null) 'edibility': edibility,
      if (fruitingSeason != null) 'fruiting_season': fruitingSeason,
      if (altitudeMin != null) 'altitude_min': altitudeMin,
      if (altitudeMax != null) 'altitude_max': altitudeMax,
      if (capDescription != null) 'cap_description': capDescription,
      if (gillsDescription != null) 'gills_description': gillsDescription,
      if (stemDescription != null) 'stem_description': stemDescription,
      if (latexDescription != null) 'latex_description': latexDescription,
      if (safetyNotes != null) 'safety_notes': safetyNotes,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
      if (silhouetteAssetPath != null)
        'silhouette_asset_path': silhouetteAssetPath,
      if (dexNumber != null) 'dex_number': dexNumber,
    });
  }

  BoletsCompanion copyWith(
      {Value<String>? id,
      Value<String>? catalanName,
      Value<String>? scientificName,
      Value<String>? family,
      Value<String>? rarityTier,
      Value<String>? edibility,
      Value<String>? fruitingSeason,
      Value<int?>? altitudeMin,
      Value<int?>? altitudeMax,
      Value<String>? capDescription,
      Value<String>? gillsDescription,
      Value<String>? stemDescription,
      Value<String?>? latexDescription,
      Value<String?>? safetyNotes,
      Value<String?>? imageAssetPath,
      Value<String?>? silhouetteAssetPath,
      Value<int>? dexNumber}) {
    return BoletsCompanion(
      id: id ?? this.id,
      catalanName: catalanName ?? this.catalanName,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      rarityTier: rarityTier ?? this.rarityTier,
      edibility: edibility ?? this.edibility,
      fruitingSeason: fruitingSeason ?? this.fruitingSeason,
      altitudeMin: altitudeMin ?? this.altitudeMin,
      altitudeMax: altitudeMax ?? this.altitudeMax,
      capDescription: capDescription ?? this.capDescription,
      gillsDescription: gillsDescription ?? this.gillsDescription,
      stemDescription: stemDescription ?? this.stemDescription,
      latexDescription: latexDescription ?? this.latexDescription,
      safetyNotes: safetyNotes ?? this.safetyNotes,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      silhouetteAssetPath: silhouetteAssetPath ?? this.silhouetteAssetPath,
      dexNumber: dexNumber ?? this.dexNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catalanName.present) {
      map['catalan_name'] = Variable<String>(catalanName.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (rarityTier.present) {
      map['rarity_tier'] = Variable<String>(rarityTier.value);
    }
    if (edibility.present) {
      map['edibility'] = Variable<String>(edibility.value);
    }
    if (fruitingSeason.present) {
      map['fruiting_season'] = Variable<String>(fruitingSeason.value);
    }
    if (altitudeMin.present) {
      map['altitude_min'] = Variable<int>(altitudeMin.value);
    }
    if (altitudeMax.present) {
      map['altitude_max'] = Variable<int>(altitudeMax.value);
    }
    if (capDescription.present) {
      map['cap_description'] = Variable<String>(capDescription.value);
    }
    if (gillsDescription.present) {
      map['gills_description'] = Variable<String>(gillsDescription.value);
    }
    if (stemDescription.present) {
      map['stem_description'] = Variable<String>(stemDescription.value);
    }
    if (latexDescription.present) {
      map['latex_description'] = Variable<String>(latexDescription.value);
    }
    if (safetyNotes.present) {
      map['safety_notes'] = Variable<String>(safetyNotes.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    if (silhouetteAssetPath.present) {
      map['silhouette_asset_path'] =
          Variable<String>(silhouetteAssetPath.value);
    }
    if (dexNumber.present) {
      map['dex_number'] = Variable<int>(dexNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoletsCompanion(')
          ..write('id: $id, ')
          ..write('catalanName: $catalanName, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('rarityTier: $rarityTier, ')
          ..write('edibility: $edibility, ')
          ..write('fruitingSeason: $fruitingSeason, ')
          ..write('altitudeMin: $altitudeMin, ')
          ..write('altitudeMax: $altitudeMax, ')
          ..write('capDescription: $capDescription, ')
          ..write('gillsDescription: $gillsDescription, ')
          ..write('stemDescription: $stemDescription, ')
          ..write('latexDescription: $latexDescription, ')
          ..write('safetyNotes: $safetyNotes, ')
          ..write('imageAssetPath: $imageAssetPath, ')
          ..write('silhouetteAssetPath: $silhouetteAssetPath, ')
          ..write('dexNumber: $dexNumber')
          ..write(')'))
        .toString();
  }
}

class $ArbresTable extends Arbres with TableInfo<$ArbresTable, Arbre> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArbresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _catalanNameMeta =
      const VerificationMeta('catalanName');
  @override
  late final GeneratedColumn<String> catalanName = GeneratedColumn<String>(
      'catalan_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _leafTypeMeta =
      const VerificationMeta('leafType');
  @override
  late final GeneratedColumn<String> leafType = GeneratedColumn<String>(
      'leaf_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barkDescriptionMeta =
      const VerificationMeta('barkDescription');
  @override
  late final GeneratedColumn<String> barkDescription = GeneratedColumn<String>(
      'bark_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typicalSoilMeta =
      const VerificationMeta('typicalSoil');
  @override
  late final GeneratedColumn<String> typicalSoil = GeneratedColumn<String>(
      'typical_soil', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageAssetPathMeta =
      const VerificationMeta('imageAssetPath');
  @override
  late final GeneratedColumn<String> imageAssetPath = GeneratedColumn<String>(
      'image_asset_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        catalanName,
        scientificName,
        leafType,
        barkDescription,
        typicalSoil,
        imageAssetPath
      ];
  @override
  String get aliasedName => _alias ?? 'arbres';
  @override
  String get actualTableName => 'arbres';
  @override
  VerificationContext validateIntegrity(Insertable<Arbre> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('catalan_name')) {
      context.handle(
          _catalanNameMeta,
          catalanName.isAcceptableOrUnknown(
              data['catalan_name']!, _catalanNameMeta));
    } else if (isInserting) {
      context.missing(_catalanNameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('leaf_type')) {
      context.handle(_leafTypeMeta,
          leafType.isAcceptableOrUnknown(data['leaf_type']!, _leafTypeMeta));
    } else if (isInserting) {
      context.missing(_leafTypeMeta);
    }
    if (data.containsKey('bark_description')) {
      context.handle(
          _barkDescriptionMeta,
          barkDescription.isAcceptableOrUnknown(
              data['bark_description']!, _barkDescriptionMeta));
    } else if (isInserting) {
      context.missing(_barkDescriptionMeta);
    }
    if (data.containsKey('typical_soil')) {
      context.handle(
          _typicalSoilMeta,
          typicalSoil.isAcceptableOrUnknown(
              data['typical_soil']!, _typicalSoilMeta));
    } else if (isInserting) {
      context.missing(_typicalSoilMeta);
    }
    if (data.containsKey('image_asset_path')) {
      context.handle(
          _imageAssetPathMeta,
          imageAssetPath.isAcceptableOrUnknown(
              data['image_asset_path']!, _imageAssetPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Arbre map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Arbre(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      catalanName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}catalan_name'])!,
      scientificName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scientific_name'])!,
      leafType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}leaf_type'])!,
      barkDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}bark_description'])!,
      typicalSoil: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}typical_soil'])!,
      imageAssetPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_asset_path']),
    );
  }

  @override
  $ArbresTable createAlias(String alias) {
    return $ArbresTable(attachedDatabase, alias);
  }
}

class Arbre extends DataClass implements Insertable<Arbre> {
  final String id;
  final String catalanName;
  final String scientificName;
  final String leafType;
  final String barkDescription;
  final String typicalSoil;
  final String? imageAssetPath;
  const Arbre(
      {required this.id,
      required this.catalanName,
      required this.scientificName,
      required this.leafType,
      required this.barkDescription,
      required this.typicalSoil,
      this.imageAssetPath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['catalan_name'] = Variable<String>(catalanName);
    map['scientific_name'] = Variable<String>(scientificName);
    map['leaf_type'] = Variable<String>(leafType);
    map['bark_description'] = Variable<String>(barkDescription);
    map['typical_soil'] = Variable<String>(typicalSoil);
    if (!nullToAbsent || imageAssetPath != null) {
      map['image_asset_path'] = Variable<String>(imageAssetPath);
    }
    return map;
  }

  ArbresCompanion toCompanion(bool nullToAbsent) {
    return ArbresCompanion(
      id: Value(id),
      catalanName: Value(catalanName),
      scientificName: Value(scientificName),
      leafType: Value(leafType),
      barkDescription: Value(barkDescription),
      typicalSoil: Value(typicalSoil),
      imageAssetPath: imageAssetPath == null && nullToAbsent
          ? const Value.absent()
          : Value(imageAssetPath),
    );
  }

  factory Arbre.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Arbre(
      id: serializer.fromJson<String>(json['id']),
      catalanName: serializer.fromJson<String>(json['catalanName']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      leafType: serializer.fromJson<String>(json['leafType']),
      barkDescription: serializer.fromJson<String>(json['barkDescription']),
      typicalSoil: serializer.fromJson<String>(json['typicalSoil']),
      imageAssetPath: serializer.fromJson<String?>(json['imageAssetPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'catalanName': serializer.toJson<String>(catalanName),
      'scientificName': serializer.toJson<String>(scientificName),
      'leafType': serializer.toJson<String>(leafType),
      'barkDescription': serializer.toJson<String>(barkDescription),
      'typicalSoil': serializer.toJson<String>(typicalSoil),
      'imageAssetPath': serializer.toJson<String?>(imageAssetPath),
    };
  }

  Arbre copyWith(
          {String? id,
          String? catalanName,
          String? scientificName,
          String? leafType,
          String? barkDescription,
          String? typicalSoil,
          Value<String?> imageAssetPath = const Value.absent()}) =>
      Arbre(
        id: id ?? this.id,
        catalanName: catalanName ?? this.catalanName,
        scientificName: scientificName ?? this.scientificName,
        leafType: leafType ?? this.leafType,
        barkDescription: barkDescription ?? this.barkDescription,
        typicalSoil: typicalSoil ?? this.typicalSoil,
        imageAssetPath:
            imageAssetPath.present ? imageAssetPath.value : this.imageAssetPath,
      );
  @override
  String toString() {
    return (StringBuffer('Arbre(')
          ..write('id: $id, ')
          ..write('catalanName: $catalanName, ')
          ..write('scientificName: $scientificName, ')
          ..write('leafType: $leafType, ')
          ..write('barkDescription: $barkDescription, ')
          ..write('typicalSoil: $typicalSoil, ')
          ..write('imageAssetPath: $imageAssetPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, catalanName, scientificName, leafType,
      barkDescription, typicalSoil, imageAssetPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Arbre &&
          other.id == this.id &&
          other.catalanName == this.catalanName &&
          other.scientificName == this.scientificName &&
          other.leafType == this.leafType &&
          other.barkDescription == this.barkDescription &&
          other.typicalSoil == this.typicalSoil &&
          other.imageAssetPath == this.imageAssetPath);
}

class ArbresCompanion extends UpdateCompanion<Arbre> {
  final Value<String> id;
  final Value<String> catalanName;
  final Value<String> scientificName;
  final Value<String> leafType;
  final Value<String> barkDescription;
  final Value<String> typicalSoil;
  final Value<String?> imageAssetPath;
  const ArbresCompanion({
    this.id = const Value.absent(),
    this.catalanName = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.leafType = const Value.absent(),
    this.barkDescription = const Value.absent(),
    this.typicalSoil = const Value.absent(),
    this.imageAssetPath = const Value.absent(),
  });
  ArbresCompanion.insert({
    required String id,
    required String catalanName,
    required String scientificName,
    required String leafType,
    required String barkDescription,
    required String typicalSoil,
    this.imageAssetPath = const Value.absent(),
  })  : id = Value(id),
        catalanName = Value(catalanName),
        scientificName = Value(scientificName),
        leafType = Value(leafType),
        barkDescription = Value(barkDescription),
        typicalSoil = Value(typicalSoil);
  static Insertable<Arbre> custom({
    Expression<String>? id,
    Expression<String>? catalanName,
    Expression<String>? scientificName,
    Expression<String>? leafType,
    Expression<String>? barkDescription,
    Expression<String>? typicalSoil,
    Expression<String>? imageAssetPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (catalanName != null) 'catalan_name': catalanName,
      if (scientificName != null) 'scientific_name': scientificName,
      if (leafType != null) 'leaf_type': leafType,
      if (barkDescription != null) 'bark_description': barkDescription,
      if (typicalSoil != null) 'typical_soil': typicalSoil,
      if (imageAssetPath != null) 'image_asset_path': imageAssetPath,
    });
  }

  ArbresCompanion copyWith(
      {Value<String>? id,
      Value<String>? catalanName,
      Value<String>? scientificName,
      Value<String>? leafType,
      Value<String>? barkDescription,
      Value<String>? typicalSoil,
      Value<String?>? imageAssetPath}) {
    return ArbresCompanion(
      id: id ?? this.id,
      catalanName: catalanName ?? this.catalanName,
      scientificName: scientificName ?? this.scientificName,
      leafType: leafType ?? this.leafType,
      barkDescription: barkDescription ?? this.barkDescription,
      typicalSoil: typicalSoil ?? this.typicalSoil,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (catalanName.present) {
      map['catalan_name'] = Variable<String>(catalanName.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (leafType.present) {
      map['leaf_type'] = Variable<String>(leafType.value);
    }
    if (barkDescription.present) {
      map['bark_description'] = Variable<String>(barkDescription.value);
    }
    if (typicalSoil.present) {
      map['typical_soil'] = Variable<String>(typicalSoil.value);
    }
    if (imageAssetPath.present) {
      map['image_asset_path'] = Variable<String>(imageAssetPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArbresCompanion(')
          ..write('id: $id, ')
          ..write('catalanName: $catalanName, ')
          ..write('scientificName: $scientificName, ')
          ..write('leafType: $leafType, ')
          ..write('barkDescription: $barkDescription, ')
          ..write('typicalSoil: $typicalSoil, ')
          ..write('imageAssetPath: $imageAssetPath')
          ..write(')'))
        .toString();
  }
}

class $BoletArbreAssociationsTable extends BoletArbreAssociations
    with TableInfo<$BoletArbreAssociationsTable, BoletArbreAssociation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoletArbreAssociationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _boletIdMeta =
      const VerificationMeta('boletId');
  @override
  late final GeneratedColumn<String> boletId = GeneratedColumn<String>(
      'bolet_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bolets (id)'));
  static const VerificationMeta _arbreIdMeta =
      const VerificationMeta('arbreId');
  @override
  late final GeneratedColumn<String> arbreId = GeneratedColumn<String>(
      'arbre_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES arbres (id)'));
  @override
  List<GeneratedColumn> get $columns => [boletId, arbreId];
  @override
  String get aliasedName => _alias ?? 'bolet_arbre_associations';
  @override
  String get actualTableName => 'bolet_arbre_associations';
  @override
  VerificationContext validateIntegrity(
      Insertable<BoletArbreAssociation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bolet_id')) {
      context.handle(_boletIdMeta,
          boletId.isAcceptableOrUnknown(data['bolet_id']!, _boletIdMeta));
    } else if (isInserting) {
      context.missing(_boletIdMeta);
    }
    if (data.containsKey('arbre_id')) {
      context.handle(_arbreIdMeta,
          arbreId.isAcceptableOrUnknown(data['arbre_id']!, _arbreIdMeta));
    } else if (isInserting) {
      context.missing(_arbreIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {boletId, arbreId};
  @override
  BoletArbreAssociation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoletArbreAssociation(
      boletId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bolet_id'])!,
      arbreId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arbre_id'])!,
    );
  }

  @override
  $BoletArbreAssociationsTable createAlias(String alias) {
    return $BoletArbreAssociationsTable(attachedDatabase, alias);
  }
}

class BoletArbreAssociation extends DataClass
    implements Insertable<BoletArbreAssociation> {
  final String boletId;
  final String arbreId;
  const BoletArbreAssociation({required this.boletId, required this.arbreId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bolet_id'] = Variable<String>(boletId);
    map['arbre_id'] = Variable<String>(arbreId);
    return map;
  }

  BoletArbreAssociationsCompanion toCompanion(bool nullToAbsent) {
    return BoletArbreAssociationsCompanion(
      boletId: Value(boletId),
      arbreId: Value(arbreId),
    );
  }

  factory BoletArbreAssociation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoletArbreAssociation(
      boletId: serializer.fromJson<String>(json['boletId']),
      arbreId: serializer.fromJson<String>(json['arbreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'boletId': serializer.toJson<String>(boletId),
      'arbreId': serializer.toJson<String>(arbreId),
    };
  }

  BoletArbreAssociation copyWith({String? boletId, String? arbreId}) =>
      BoletArbreAssociation(
        boletId: boletId ?? this.boletId,
        arbreId: arbreId ?? this.arbreId,
      );
  @override
  String toString() {
    return (StringBuffer('BoletArbreAssociation(')
          ..write('boletId: $boletId, ')
          ..write('arbreId: $arbreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(boletId, arbreId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoletArbreAssociation &&
          other.boletId == this.boletId &&
          other.arbreId == this.arbreId);
}

class BoletArbreAssociationsCompanion
    extends UpdateCompanion<BoletArbreAssociation> {
  final Value<String> boletId;
  final Value<String> arbreId;
  const BoletArbreAssociationsCompanion({
    this.boletId = const Value.absent(),
    this.arbreId = const Value.absent(),
  });
  BoletArbreAssociationsCompanion.insert({
    required String boletId,
    required String arbreId,
  })  : boletId = Value(boletId),
        arbreId = Value(arbreId);
  static Insertable<BoletArbreAssociation> custom({
    Expression<String>? boletId,
    Expression<String>? arbreId,
  }) {
    return RawValuesInsertable({
      if (boletId != null) 'bolet_id': boletId,
      if (arbreId != null) 'arbre_id': arbreId,
    });
  }

  BoletArbreAssociationsCompanion copyWith(
      {Value<String>? boletId, Value<String>? arbreId}) {
    return BoletArbreAssociationsCompanion(
      boletId: boletId ?? this.boletId,
      arbreId: arbreId ?? this.arbreId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (boletId.present) {
      map['bolet_id'] = Variable<String>(boletId.value);
    }
    if (arbreId.present) {
      map['arbre_id'] = Variable<String>(arbreId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoletArbreAssociationsCompanion(')
          ..write('boletId: $boletId, ')
          ..write('arbreId: $arbreId')
          ..write(')'))
        .toString();
  }
}

class $ToxicLookalikesTable extends ToxicLookalikes
    with TableInfo<$ToxicLookalikesTable, ToxicLookalike> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ToxicLookalikesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _boletIdMeta =
      const VerificationMeta('boletId');
  @override
  late final GeneratedColumn<String> boletId = GeneratedColumn<String>(
      'bolet_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bolets (id)'));
  static const VerificationMeta _lookalikeBoletIdMeta =
      const VerificationMeta('lookalikeBoletId');
  @override
  late final GeneratedColumn<String> lookalikeBoletId = GeneratedColumn<String>(
      'lookalike_bolet_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _comparisonNotesMeta =
      const VerificationMeta('comparisonNotes');
  @override
  late final GeneratedColumn<String> comparisonNotes = GeneratedColumn<String>(
      'comparison_notes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [boletId, lookalikeBoletId, comparisonNotes];
  @override
  String get aliasedName => _alias ?? 'toxic_lookalikes';
  @override
  String get actualTableName => 'toxic_lookalikes';
  @override
  VerificationContext validateIntegrity(Insertable<ToxicLookalike> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bolet_id')) {
      context.handle(_boletIdMeta,
          boletId.isAcceptableOrUnknown(data['bolet_id']!, _boletIdMeta));
    } else if (isInserting) {
      context.missing(_boletIdMeta);
    }
    if (data.containsKey('lookalike_bolet_id')) {
      context.handle(
          _lookalikeBoletIdMeta,
          lookalikeBoletId.isAcceptableOrUnknown(
              data['lookalike_bolet_id']!, _lookalikeBoletIdMeta));
    } else if (isInserting) {
      context.missing(_lookalikeBoletIdMeta);
    }
    if (data.containsKey('comparison_notes')) {
      context.handle(
          _comparisonNotesMeta,
          comparisonNotes.isAcceptableOrUnknown(
              data['comparison_notes']!, _comparisonNotesMeta));
    } else if (isInserting) {
      context.missing(_comparisonNotesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {boletId, lookalikeBoletId};
  @override
  ToxicLookalike map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ToxicLookalike(
      boletId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bolet_id'])!,
      lookalikeBoletId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}lookalike_bolet_id'])!,
      comparisonNotes: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}comparison_notes'])!,
    );
  }

  @override
  $ToxicLookalikesTable createAlias(String alias) {
    return $ToxicLookalikesTable(attachedDatabase, alias);
  }
}

class ToxicLookalike extends DataClass implements Insertable<ToxicLookalike> {
  final String boletId;
  final String lookalikeBoletId;
  final String comparisonNotes;
  const ToxicLookalike(
      {required this.boletId,
      required this.lookalikeBoletId,
      required this.comparisonNotes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bolet_id'] = Variable<String>(boletId);
    map['lookalike_bolet_id'] = Variable<String>(lookalikeBoletId);
    map['comparison_notes'] = Variable<String>(comparisonNotes);
    return map;
  }

  ToxicLookalikesCompanion toCompanion(bool nullToAbsent) {
    return ToxicLookalikesCompanion(
      boletId: Value(boletId),
      lookalikeBoletId: Value(lookalikeBoletId),
      comparisonNotes: Value(comparisonNotes),
    );
  }

  factory ToxicLookalike.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ToxicLookalike(
      boletId: serializer.fromJson<String>(json['boletId']),
      lookalikeBoletId: serializer.fromJson<String>(json['lookalikeBoletId']),
      comparisonNotes: serializer.fromJson<String>(json['comparisonNotes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'boletId': serializer.toJson<String>(boletId),
      'lookalikeBoletId': serializer.toJson<String>(lookalikeBoletId),
      'comparisonNotes': serializer.toJson<String>(comparisonNotes),
    };
  }

  ToxicLookalike copyWith(
          {String? boletId,
          String? lookalikeBoletId,
          String? comparisonNotes}) =>
      ToxicLookalike(
        boletId: boletId ?? this.boletId,
        lookalikeBoletId: lookalikeBoletId ?? this.lookalikeBoletId,
        comparisonNotes: comparisonNotes ?? this.comparisonNotes,
      );
  @override
  String toString() {
    return (StringBuffer('ToxicLookalike(')
          ..write('boletId: $boletId, ')
          ..write('lookalikeBoletId: $lookalikeBoletId, ')
          ..write('comparisonNotes: $comparisonNotes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(boletId, lookalikeBoletId, comparisonNotes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ToxicLookalike &&
          other.boletId == this.boletId &&
          other.lookalikeBoletId == this.lookalikeBoletId &&
          other.comparisonNotes == this.comparisonNotes);
}

class ToxicLookalikesCompanion extends UpdateCompanion<ToxicLookalike> {
  final Value<String> boletId;
  final Value<String> lookalikeBoletId;
  final Value<String> comparisonNotes;
  const ToxicLookalikesCompanion({
    this.boletId = const Value.absent(),
    this.lookalikeBoletId = const Value.absent(),
    this.comparisonNotes = const Value.absent(),
  });
  ToxicLookalikesCompanion.insert({
    required String boletId,
    required String lookalikeBoletId,
    required String comparisonNotes,
  })  : boletId = Value(boletId),
        lookalikeBoletId = Value(lookalikeBoletId),
        comparisonNotes = Value(comparisonNotes);
  static Insertable<ToxicLookalike> custom({
    Expression<String>? boletId,
    Expression<String>? lookalikeBoletId,
    Expression<String>? comparisonNotes,
  }) {
    return RawValuesInsertable({
      if (boletId != null) 'bolet_id': boletId,
      if (lookalikeBoletId != null) 'lookalike_bolet_id': lookalikeBoletId,
      if (comparisonNotes != null) 'comparison_notes': comparisonNotes,
    });
  }

  ToxicLookalikesCompanion copyWith(
      {Value<String>? boletId,
      Value<String>? lookalikeBoletId,
      Value<String>? comparisonNotes}) {
    return ToxicLookalikesCompanion(
      boletId: boletId ?? this.boletId,
      lookalikeBoletId: lookalikeBoletId ?? this.lookalikeBoletId,
      comparisonNotes: comparisonNotes ?? this.comparisonNotes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (boletId.present) {
      map['bolet_id'] = Variable<String>(boletId.value);
    }
    if (lookalikeBoletId.present) {
      map['lookalike_bolet_id'] = Variable<String>(lookalikeBoletId.value);
    }
    if (comparisonNotes.present) {
      map['comparison_notes'] = Variable<String>(comparisonNotes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ToxicLookalikesCompanion(')
          ..write('boletId: $boletId, ')
          ..write('lookalikeBoletId: $lookalikeBoletId, ')
          ..write('comparisonNotes: $comparisonNotes')
          ..write(')'))
        .toString();
  }
}

class $AvistamentsTable extends Avistaments
    with TableInfo<$AvistamentsTable, Avistament> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AvistamentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _boletIdMeta =
      const VerificationMeta('boletId');
  @override
  late final GeneratedColumn<String> boletId = GeneratedColumn<String>(
      'bolet_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bolets (id)'));
  static const VerificationMeta _arbreIdMeta =
      const VerificationMeta('arbreId');
  @override
  late final GeneratedColumn<String> arbreId = GeneratedColumn<String>(
      'arbre_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES arbres (id)'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _altitudeMeta =
      const VerificationMeta('altitude');
  @override
  late final GeneratedColumn<double> altitude = GeneratedColumn<double>(
      'altitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confidenceScoreMeta =
      const VerificationMeta('confidenceScore');
  @override
  late final GeneratedColumn<double> confidenceScore = GeneratedColumn<double>(
      'confidence_score', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        boletId,
        arbreId,
        timestamp,
        latitude,
        longitude,
        altitude,
        photoPath,
        confidenceScore,
        notes
      ];
  @override
  String get aliasedName => _alias ?? 'avistaments';
  @override
  String get actualTableName => 'avistaments';
  @override
  VerificationContext validateIntegrity(Insertable<Avistament> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('bolet_id')) {
      context.handle(_boletIdMeta,
          boletId.isAcceptableOrUnknown(data['bolet_id']!, _boletIdMeta));
    }
    if (data.containsKey('arbre_id')) {
      context.handle(_arbreIdMeta,
          arbreId.isAcceptableOrUnknown(data['arbre_id']!, _arbreIdMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('altitude')) {
      context.handle(_altitudeMeta,
          altitude.isAcceptableOrUnknown(data['altitude']!, _altitudeMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('confidence_score')) {
      context.handle(
          _confidenceScoreMeta,
          confidenceScore.isAcceptableOrUnknown(
              data['confidence_score']!, _confidenceScoreMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Avistament map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Avistament(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      boletId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bolet_id']),
      arbreId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arbre_id']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      altitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}altitude']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      confidenceScore: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}confidence_score']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $AvistamentsTable createAlias(String alias) {
    return $AvistamentsTable(attachedDatabase, alias);
  }
}

class Avistament extends DataClass implements Insertable<Avistament> {
  final String id;
  final String? boletId;
  final String? arbreId;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final String? photoPath;
  final double? confidenceScore;
  final String? notes;
  const Avistament(
      {required this.id,
      this.boletId,
      this.arbreId,
      required this.timestamp,
      this.latitude,
      this.longitude,
      this.altitude,
      this.photoPath,
      this.confidenceScore,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || boletId != null) {
      map['bolet_id'] = Variable<String>(boletId);
    }
    if (!nullToAbsent || arbreId != null) {
      map['arbre_id'] = Variable<String>(arbreId);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || altitude != null) {
      map['altitude'] = Variable<double>(altitude);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || confidenceScore != null) {
      map['confidence_score'] = Variable<double>(confidenceScore);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  AvistamentsCompanion toCompanion(bool nullToAbsent) {
    return AvistamentsCompanion(
      id: Value(id),
      boletId: boletId == null && nullToAbsent
          ? const Value.absent()
          : Value(boletId),
      arbreId: arbreId == null && nullToAbsent
          ? const Value.absent()
          : Value(arbreId),
      timestamp: Value(timestamp),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      altitude: altitude == null && nullToAbsent
          ? const Value.absent()
          : Value(altitude),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      confidenceScore: confidenceScore == null && nullToAbsent
          ? const Value.absent()
          : Value(confidenceScore),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Avistament.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Avistament(
      id: serializer.fromJson<String>(json['id']),
      boletId: serializer.fromJson<String?>(json['boletId']),
      arbreId: serializer.fromJson<String?>(json['arbreId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      altitude: serializer.fromJson<double?>(json['altitude']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      confidenceScore: serializer.fromJson<double?>(json['confidenceScore']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'boletId': serializer.toJson<String?>(boletId),
      'arbreId': serializer.toJson<String?>(arbreId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'altitude': serializer.toJson<double?>(altitude),
      'photoPath': serializer.toJson<String?>(photoPath),
      'confidenceScore': serializer.toJson<double?>(confidenceScore),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Avistament copyWith(
          {String? id,
          Value<String?> boletId = const Value.absent(),
          Value<String?> arbreId = const Value.absent(),
          DateTime? timestamp,
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<double?> altitude = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<double?> confidenceScore = const Value.absent(),
          Value<String?> notes = const Value.absent()}) =>
      Avistament(
        id: id ?? this.id,
        boletId: boletId.present ? boletId.value : this.boletId,
        arbreId: arbreId.present ? arbreId.value : this.arbreId,
        timestamp: timestamp ?? this.timestamp,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        altitude: altitude.present ? altitude.value : this.altitude,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        confidenceScore: confidenceScore.present
            ? confidenceScore.value
            : this.confidenceScore,
        notes: notes.present ? notes.value : this.notes,
      );
  @override
  String toString() {
    return (StringBuffer('Avistament(')
          ..write('id: $id, ')
          ..write('boletId: $boletId, ')
          ..write('arbreId: $arbreId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('photoPath: $photoPath, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, boletId, arbreId, timestamp, latitude,
      longitude, altitude, photoPath, confidenceScore, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Avistament &&
          other.id == this.id &&
          other.boletId == this.boletId &&
          other.arbreId == this.arbreId &&
          other.timestamp == this.timestamp &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.altitude == this.altitude &&
          other.photoPath == this.photoPath &&
          other.confidenceScore == this.confidenceScore &&
          other.notes == this.notes);
}

class AvistamentsCompanion extends UpdateCompanion<Avistament> {
  final Value<String> id;
  final Value<String?> boletId;
  final Value<String?> arbreId;
  final Value<DateTime> timestamp;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<double?> altitude;
  final Value<String?> photoPath;
  final Value<double?> confidenceScore;
  final Value<String?> notes;
  const AvistamentsCompanion({
    this.id = const Value.absent(),
    this.boletId = const Value.absent(),
    this.arbreId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.notes = const Value.absent(),
  });
  AvistamentsCompanion.insert({
    required String id,
    this.boletId = const Value.absent(),
    this.arbreId = const Value.absent(),
    required DateTime timestamp,
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.altitude = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.confidenceScore = const Value.absent(),
    this.notes = const Value.absent(),
  })  : id = Value(id),
        timestamp = Value(timestamp);
  static Insertable<Avistament> custom({
    Expression<String>? id,
    Expression<String>? boletId,
    Expression<String>? arbreId,
    Expression<DateTime>? timestamp,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? altitude,
    Expression<String>? photoPath,
    Expression<double>? confidenceScore,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (boletId != null) 'bolet_id': boletId,
      if (arbreId != null) 'arbre_id': arbreId,
      if (timestamp != null) 'timestamp': timestamp,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (altitude != null) 'altitude': altitude,
      if (photoPath != null) 'photo_path': photoPath,
      if (confidenceScore != null) 'confidence_score': confidenceScore,
      if (notes != null) 'notes': notes,
    });
  }

  AvistamentsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? boletId,
      Value<String?>? arbreId,
      Value<DateTime>? timestamp,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<double?>? altitude,
      Value<String?>? photoPath,
      Value<double?>? confidenceScore,
      Value<String?>? notes}) {
    return AvistamentsCompanion(
      id: id ?? this.id,
      boletId: boletId ?? this.boletId,
      arbreId: arbreId ?? this.arbreId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      photoPath: photoPath ?? this.photoPath,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (boletId.present) {
      map['bolet_id'] = Variable<String>(boletId.value);
    }
    if (arbreId.present) {
      map['arbre_id'] = Variable<String>(arbreId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (altitude.present) {
      map['altitude'] = Variable<double>(altitude.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (confidenceScore.present) {
      map['confidence_score'] = Variable<double>(confidenceScore.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AvistamentsCompanion(')
          ..write('id: $id, ')
          ..write('boletId: $boletId, ')
          ..write('arbreId: $arbreId, ')
          ..write('timestamp: $timestamp, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('altitude: $altitude, ')
          ..write('photoPath: $photoPath, ')
          ..write('confidenceScore: $confidenceScore, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $DescobrimentsTable extends Descobriments
    with TableInfo<$DescobrimentsTable, Descobriment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DescobrimentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _boletIdMeta =
      const VerificationMeta('boletId');
  @override
  late final GeneratedColumn<String> boletId = GeneratedColumn<String>(
      'bolet_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES bolets (id)'));
  static const VerificationMeta _discoveredAtMeta =
      const VerificationMeta('discoveredAt');
  @override
  late final GeneratedColumn<DateTime> discoveredAt = GeneratedColumn<DateTime>(
      'discovered_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _firstAvistamentIdMeta =
      const VerificationMeta('firstAvistamentId');
  @override
  late final GeneratedColumn<String> firstAvistamentId =
      GeneratedColumn<String>('first_avistament_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES avistaments (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns =>
      [boletId, discoveredAt, firstAvistamentId];
  @override
  String get aliasedName => _alias ?? 'descobriments';
  @override
  String get actualTableName => 'descobriments';
  @override
  VerificationContext validateIntegrity(Insertable<Descobriment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bolet_id')) {
      context.handle(_boletIdMeta,
          boletId.isAcceptableOrUnknown(data['bolet_id']!, _boletIdMeta));
    } else if (isInserting) {
      context.missing(_boletIdMeta);
    }
    if (data.containsKey('discovered_at')) {
      context.handle(
          _discoveredAtMeta,
          discoveredAt.isAcceptableOrUnknown(
              data['discovered_at']!, _discoveredAtMeta));
    } else if (isInserting) {
      context.missing(_discoveredAtMeta);
    }
    if (data.containsKey('first_avistament_id')) {
      context.handle(
          _firstAvistamentIdMeta,
          firstAvistamentId.isAcceptableOrUnknown(
              data['first_avistament_id']!, _firstAvistamentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {boletId};
  @override
  Descobriment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Descobriment(
      boletId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bolet_id'])!,
      discoveredAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}discovered_at'])!,
      firstAvistamentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}first_avistament_id']),
    );
  }

  @override
  $DescobrimentsTable createAlias(String alias) {
    return $DescobrimentsTable(attachedDatabase, alias);
  }
}

class Descobriment extends DataClass implements Insertable<Descobriment> {
  final String boletId;
  final DateTime discoveredAt;
  final String? firstAvistamentId;
  const Descobriment(
      {required this.boletId,
      required this.discoveredAt,
      this.firstAvistamentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bolet_id'] = Variable<String>(boletId);
    map['discovered_at'] = Variable<DateTime>(discoveredAt);
    if (!nullToAbsent || firstAvistamentId != null) {
      map['first_avistament_id'] = Variable<String>(firstAvistamentId);
    }
    return map;
  }

  DescobrimentsCompanion toCompanion(bool nullToAbsent) {
    return DescobrimentsCompanion(
      boletId: Value(boletId),
      discoveredAt: Value(discoveredAt),
      firstAvistamentId: firstAvistamentId == null && nullToAbsent
          ? const Value.absent()
          : Value(firstAvistamentId),
    );
  }

  factory Descobriment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Descobriment(
      boletId: serializer.fromJson<String>(json['boletId']),
      discoveredAt: serializer.fromJson<DateTime>(json['discoveredAt']),
      firstAvistamentId:
          serializer.fromJson<String?>(json['firstAvistamentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'boletId': serializer.toJson<String>(boletId),
      'discoveredAt': serializer.toJson<DateTime>(discoveredAt),
      'firstAvistamentId': serializer.toJson<String?>(firstAvistamentId),
    };
  }

  Descobriment copyWith(
          {String? boletId,
          DateTime? discoveredAt,
          Value<String?> firstAvistamentId = const Value.absent()}) =>
      Descobriment(
        boletId: boletId ?? this.boletId,
        discoveredAt: discoveredAt ?? this.discoveredAt,
        firstAvistamentId: firstAvistamentId.present
            ? firstAvistamentId.value
            : this.firstAvistamentId,
      );
  @override
  String toString() {
    return (StringBuffer('Descobriment(')
          ..write('boletId: $boletId, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('firstAvistamentId: $firstAvistamentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(boletId, discoveredAt, firstAvistamentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Descobriment &&
          other.boletId == this.boletId &&
          other.discoveredAt == this.discoveredAt &&
          other.firstAvistamentId == this.firstAvistamentId);
}

class DescobrimentsCompanion extends UpdateCompanion<Descobriment> {
  final Value<String> boletId;
  final Value<DateTime> discoveredAt;
  final Value<String?> firstAvistamentId;
  const DescobrimentsCompanion({
    this.boletId = const Value.absent(),
    this.discoveredAt = const Value.absent(),
    this.firstAvistamentId = const Value.absent(),
  });
  DescobrimentsCompanion.insert({
    required String boletId,
    required DateTime discoveredAt,
    this.firstAvistamentId = const Value.absent(),
  })  : boletId = Value(boletId),
        discoveredAt = Value(discoveredAt);
  static Insertable<Descobriment> custom({
    Expression<String>? boletId,
    Expression<DateTime>? discoveredAt,
    Expression<String>? firstAvistamentId,
  }) {
    return RawValuesInsertable({
      if (boletId != null) 'bolet_id': boletId,
      if (discoveredAt != null) 'discovered_at': discoveredAt,
      if (firstAvistamentId != null) 'first_avistament_id': firstAvistamentId,
    });
  }

  DescobrimentsCompanion copyWith(
      {Value<String>? boletId,
      Value<DateTime>? discoveredAt,
      Value<String?>? firstAvistamentId}) {
    return DescobrimentsCompanion(
      boletId: boletId ?? this.boletId,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      firstAvistamentId: firstAvistamentId ?? this.firstAvistamentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (boletId.present) {
      map['bolet_id'] = Variable<String>(boletId.value);
    }
    if (discoveredAt.present) {
      map['discovered_at'] = Variable<DateTime>(discoveredAt.value);
    }
    if (firstAvistamentId.present) {
      map['first_avistament_id'] = Variable<String>(firstAvistamentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DescobrimentsCompanion(')
          ..write('boletId: $boletId, ')
          ..write('discoveredAt: $discoveredAt, ')
          ..write('firstAvistamentId: $firstAvistamentId')
          ..write(')'))
        .toString();
  }
}

class $InsigniesTable extends Insignies
    with TableInfo<$InsigniesTable, Insignia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InsigniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _awardedAtMeta =
      const VerificationMeta('awardedAt');
  @override
  late final GeneratedColumn<DateTime> awardedAt = GeneratedColumn<DateTime>(
      'awarded_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _progressCountMeta =
      const VerificationMeta('progressCount');
  @override
  late final GeneratedColumn<int> progressCount = GeneratedColumn<int>(
      'progress_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, awardedAt, progressCount];
  @override
  String get aliasedName => _alias ?? 'insignies';
  @override
  String get actualTableName => 'insignies';
  @override
  VerificationContext validateIntegrity(Insertable<Insignia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('awarded_at')) {
      context.handle(_awardedAtMeta,
          awardedAt.isAcceptableOrUnknown(data['awarded_at']!, _awardedAtMeta));
    }
    if (data.containsKey('progress_count')) {
      context.handle(
          _progressCountMeta,
          progressCount.isAcceptableOrUnknown(
              data['progress_count']!, _progressCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Insignia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Insignia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      awardedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}awarded_at']),
      progressCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}progress_count'])!,
    );
  }

  @override
  $InsigniesTable createAlias(String alias) {
    return $InsigniesTable(attachedDatabase, alias);
  }
}

class Insignia extends DataClass implements Insertable<Insignia> {
  final String id;
  final DateTime? awardedAt;
  final int progressCount;
  const Insignia(
      {required this.id, this.awardedAt, required this.progressCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || awardedAt != null) {
      map['awarded_at'] = Variable<DateTime>(awardedAt);
    }
    map['progress_count'] = Variable<int>(progressCount);
    return map;
  }

  InsigniesCompanion toCompanion(bool nullToAbsent) {
    return InsigniesCompanion(
      id: Value(id),
      awardedAt: awardedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(awardedAt),
      progressCount: Value(progressCount),
    );
  }

  factory Insignia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Insignia(
      id: serializer.fromJson<String>(json['id']),
      awardedAt: serializer.fromJson<DateTime?>(json['awardedAt']),
      progressCount: serializer.fromJson<int>(json['progressCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'awardedAt': serializer.toJson<DateTime?>(awardedAt),
      'progressCount': serializer.toJson<int>(progressCount),
    };
  }

  Insignia copyWith(
          {String? id,
          Value<DateTime?> awardedAt = const Value.absent(),
          int? progressCount}) =>
      Insignia(
        id: id ?? this.id,
        awardedAt: awardedAt.present ? awardedAt.value : this.awardedAt,
        progressCount: progressCount ?? this.progressCount,
      );
  @override
  String toString() {
    return (StringBuffer('Insignia(')
          ..write('id: $id, ')
          ..write('awardedAt: $awardedAt, ')
          ..write('progressCount: $progressCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, awardedAt, progressCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Insignia &&
          other.id == this.id &&
          other.awardedAt == this.awardedAt &&
          other.progressCount == this.progressCount);
}

class InsigniesCompanion extends UpdateCompanion<Insignia> {
  final Value<String> id;
  final Value<DateTime?> awardedAt;
  final Value<int> progressCount;
  const InsigniesCompanion({
    this.id = const Value.absent(),
    this.awardedAt = const Value.absent(),
    this.progressCount = const Value.absent(),
  });
  InsigniesCompanion.insert({
    required String id,
    this.awardedAt = const Value.absent(),
    this.progressCount = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Insignia> custom({
    Expression<String>? id,
    Expression<DateTime>? awardedAt,
    Expression<int>? progressCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (awardedAt != null) 'awarded_at': awardedAt,
      if (progressCount != null) 'progress_count': progressCount,
    });
  }

  InsigniesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime?>? awardedAt,
      Value<int>? progressCount}) {
    return InsigniesCompanion(
      id: id ?? this.id,
      awardedAt: awardedAt ?? this.awardedAt,
      progressCount: progressCount ?? this.progressCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (awardedAt.present) {
      map['awarded_at'] = Variable<DateTime>(awardedAt.value);
    }
    if (progressCount.present) {
      map['progress_count'] = Variable<int>(progressCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InsigniesCompanion(')
          ..write('id: $id, ')
          ..write('awardedAt: $awardedAt, ')
          ..write('progressCount: $progressCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $BoletsTable bolets = $BoletsTable(this);
  late final $ArbresTable arbres = $ArbresTable(this);
  late final $BoletArbreAssociationsTable boletArbreAssociations =
      $BoletArbreAssociationsTable(this);
  late final $ToxicLookalikesTable toxicLookalikes =
      $ToxicLookalikesTable(this);
  late final $AvistamentsTable avistaments = $AvistamentsTable(this);
  late final $DescobrimentsTable descobriments = $DescobrimentsTable(this);
  late final $InsigniesTable insignies = $InsigniesTable(this);
  late final BoletDao boletDao = BoletDao(this as AppDatabase);
  late final ArbreDao arbreDao = ArbreDao(this as AppDatabase);
  late final AvistamentDao avistamentDao = AvistamentDao(this as AppDatabase);
  late final DescobrimentDao descobrimentDao =
      DescobrimentDao(this as AppDatabase);
  late final InsigniaDao insigniaDao = InsigniaDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        bolets,
        arbres,
        boletArbreAssociations,
        toxicLookalikes,
        avistaments,
        descobriments,
        insignies
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('avistaments',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('descobriments', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}
