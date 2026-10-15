import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:boscdex/data/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    // In-memory sqlite database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Database populates seed data on creation', () async {
    final bolets = await db.boletDao.getAllBolets();
    expect(bolets.length, equals(47));

    final arbres = await db.arbreDao.getAllArbres();
    expect(arbres.length, equals(5));

    final insignies = await db.insigniaDao.getAllInsignies();
    expect(insignies.length, equals(14));
  });

  test('BoletDao queries work correctly', () async {
    final rovello = await db.boletDao.getBoletById('lactarius_deliciosus');
    expect(rovello, isNotNull);
    expect(rovello!.catalanName, contains('Rovelló'));
    expect(rovello.scientificName, equals('Lactarius deliciosus'));

    final carrereta = await db.boletDao.getBoletById('marasmius_oreades');
    expect(carrereta, isNotNull);
    expect(carrereta!.catalanName, contains('Carrereta'));
    expect(carrereta.edibility, equals('excellent'));

    final carlet = await db.boletDao.getBoletById('hygrophorus_russula');
    expect(carlet, isNotNull);
    expect(carlet!.catalanName, contains('Carlet'));
    expect(carlet.edibility, equals('excellent'));

    final edibles = await db.boletDao.getBoletsByEdibility('excellent');
    expect(edibles.length, greaterThanOrEqualTo(10));

    final lookalikes =
        await db.boletDao.getToxicLookalikes('lactarius_deliciosus');
    expect(lookalikes, isNotEmpty);
    expect(
      lookalikes.any((l) => l.id == 'lactarius_chrysorrheus'),
      isTrue,
    );
    expect(
      lookalikes.any((l) => l.id == 'lactarius_torminosus'),
      isTrue,
    );

    final xampinyoLookalikes =
        await db.boletDao.getToxicLookalikes('agaricus_campestris');
    expect(
      xampinyoLookalikes.any((l) => l.id == 'agaricus_xanthodermus'),
      isTrue,
    );
    expect(
      xampinyoLookalikes.any((l) => l.id == 'amanita_verna'),
      isTrue,
    );

    // Verify newly added dangerous confusion companions
    final sanguifluusLookalikes =
        await db.boletDao.getToxicLookalikes('lactarius_sanguifluus');
    expect(
      sanguifluusLookalikes.any((l) => l.id == 'lactarius_chrysorrheus'),
      isTrue,
    );
    expect(
      sanguifluusLookalikes.any((l) => l.id == 'lactarius_torminosus'),
      isTrue,
    );

    final aereusLookalikes =
        await db.boletDao.getToxicLookalikes('boletus_aereus');
    expect(
      aereusLookalikes.any((l) => l.id == 'rubroboletus_satanas'),
      isTrue,
    );

    final eburneusLookalikes =
        await db.boletDao.getToxicLookalikes('hygrophorus_eburneus');
    expect(
      eburneusLookalikes.any((l) => l.id == 'amanita_verna'),
      isTrue,
    );

    final cyanoxanthaLookalikes =
        await db.boletDao.getToxicLookalikes('russula_cyanoxantha');
    expect(
      cyanoxanthaLookalikes.any((l) => l.id == 'amanita_phalloides'),
      isTrue,
    );

    // Verify bidirectional lookups from the toxic mushroom side
    final phalloidesLookalikes =
        await db.boletDao.getToxicLookalikes('amanita_phalloides');
    expect(
      phalloidesLookalikes.any((l) => l.id == 'russula_virescens'),
      isTrue,
    );
    expect(
      phalloidesLookalikes.any((l) => l.id == 'russula_cyanoxantha'),
      isTrue,
    );
    expect(
      phalloidesLookalikes.any((l) => l.id == 'macrolepiota_procera'),
      isTrue,
    );
    expect(
      phalloidesLookalikes.any((l) => l.id == 'hygrophorus_personii'),
      isTrue,
    );

    // Verify lethal sentinels virosa and galerina
    final virosaLookalikes =
        await db.boletDao.getToxicLookalikes('amanita_virosa');
    expect(
      virosaLookalikes.any((l) => l.id == 'calocybe_gambosa'),
      isTrue,
    );
    expect(
      virosaLookalikes.any((l) => l.id == 'agaricus_campestris'),
      isTrue,
    );

    final marginataLookalikes =
        await db.boletDao.getToxicLookalikes('galerina_marginata');
    expect(
      marginataLookalikes.any((l) => l.id == 'pleurotus_ostreatus'),
      isTrue,
    );

    final semisanguifluusLookalikes =
        await db.boletDao.getToxicLookalikes('lactarius_semisanguifluus');
    expect(
      semisanguifluusLookalikes.any((l) => l.id == 'lactarius_chrysorrheus'),
      isTrue,
    );
    expect(
      semisanguifluusLookalikes.any((l) => l.id == 'lactarius_torminosus'),
      isTrue,
    );
  });

  test('BoletDao searchByName finds specimens by Catalan or scientific name',
      () async {
    final searchCatalan = await db.boletDao.searchByName('Rovelló');
    expect(
        searchCatalan.length,
        equals(
            5)); // Pinetell, Rovelló d'obaga, Fals rovelló, Rovelló bord & Rovelló de pi negre

    final searchScientific = await db.boletDao.searchByName('Boletus');
    expect(searchScientific, isNotEmpty);
    expect(searchScientific.first.scientificName, contains('Boletus'));

    final searchAccentInsensitive = await db.boletDao.searchByName('rovello');
    expect(searchAccentInsensitive, isNotEmpty);
    expect(searchAccentInsensitive.first.catalanName, contains('Rovelló'));

    final searchGirgola = await db.boletDao.searchByName('girgola');
    expect(searchGirgola, isNotEmpty);
    expect(searchGirgola.first.catalanName, contains('Gírgola'));

    final searchNone = await db.boletDao.searchByName('NonExistentSpeciesXYZ');
    expect(searchNone, isEmpty);
  });

  test('BoletDao getToxicLookalikesWithNotes returns joined comparison notes',
      () async {
    final lookalikesWithNotes =
        await db.boletDao.getToxicLookalikesWithNotes('lactarius_deliciosus');
    expect(lookalikesWithNotes, isNotEmpty);

    final entry = lookalikesWithNotes.first;
    expect(entry.lookalike.id, equals('amanita_muscaria'));
    expect(entry.comparisonNotes, contains('Reig bord'));
    expect(entry.comparisonNotes, isNotEmpty);

    // Verify reverse lookup with notes from the toxic mushroom side
    final phalloidesNotes =
        await db.boletDao.getToxicLookalikesWithNotes('amanita_phalloides');
    expect(phalloidesNotes, isNotEmpty);
    expect(
      phalloidesNotes.any((n) =>
          n.lookalike.id == 'russula_virescens' &&
          n.comparisonNotes.contains('Palometa')),
      isTrue,
    );
  });

  test('BoletDao relational tree associations work correctly', () async {
    final boletsWithPinus =
        await db.boletDao.getBoletsByArbreId('pinus_sylvestris');
    expect(boletsWithPinus, isNotEmpty);
    expect(boletsWithPinus.any((b) => b.id == 'lactarius_deliciosus'), isTrue);

    final arbresForCep =
        await db.boletDao.getAssociatedArbres('boletus_edulis');
    expect(arbresForCep, isNotEmpty);
    expect(arbresForCep.any((a) => a.id == 'fagus_sylvatica'), isTrue);

    final distinctBoletIds = await db.boletDao.getBoletIdsWithArbres();
    expect(distinctBoletIds, isNotEmpty);
    expect(distinctBoletIds.contains('lactarius_deliciosus'), isTrue);
  });

  test('DescobrimentDao tracks discoveries and handles duplicates idempotently',
      () async {
    var isFound = await db.descobrimentDao.isDiscovered('boletus_edulis');
    expect(isFound, isFalse);

    final now = DateTime.now();
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion.insert(
        id: 'test-avistament-1',
        boletId: const Value('boletus_edulis'),
        timestamp: now,
      ),
    );
    await db.descobrimentDao
        .markDiscovered('boletus_edulis', now, 'test-avistament-1');

    isFound = await db.descobrimentDao.isDiscovered('boletus_edulis');
    expect(isFound, isTrue);

    final count = await db.descobrimentDao.getDiscoveryCount();
    expect(count, equals(1));

    // Duplicate call should be ignored without error
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion.insert(
        id: 'test-avistament-2',
        boletId: const Value('boletus_edulis'),
        timestamp: now,
      ),
    );
    await db.descobrimentDao
        .markDiscovered('boletus_edulis', now, 'test-avistament-2');
    final countAfterDuplicate = await db.descobrimentDao.getDiscoveryCount();
    expect(countAfterDuplicate, equals(1));
  });

  test('AvistamentDao records and deletes sightings', () async {
    final now = DateTime.now();
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion.insert(
        id: 'sighting-1',
        boletId: const Value('cantharellus_cibarius'),
        timestamp: now,
        notes: const Value('Trobat sota faigs al Montseny'),
      ),
    );

    final sightings =
        await db.avistamentDao.getAvistamentsByBolet('cantharellus_cibarius');
    expect(sightings.length, equals(1));
    expect(sightings.first.notes, equals('Trobat sota faigs al Montseny'));

    await db.avistamentDao.deleteAvistament('sighting-1');
    final afterDelete =
        await db.avistamentDao.getAvistamentsByBolet('cantharellus_cibarius');
    expect(afterDelete, isEmpty);
  });

  test('AvistamentDao records and queries tree sightings with null boletId',
      () async {
    final now = DateTime.now();
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('tree-sighting-1'),
        arbreId: const Value('pinus_sylvestris'),
        timestamp: Value(now),
        notes: const Value('Pi roig immens al Cadí-Moixeró'),
        confidenceScore: const Value(0.95),
      ),
    );

    final treeSightings =
        await db.avistamentDao.getAvistamentsByArbre('pinus_sylvestris');
    expect(treeSightings.length, equals(1));
    expect(treeSightings.first.id, equals('tree-sighting-1'));
    expect(treeSightings.first.arbreId, equals('pinus_sylvestris'));
    expect(treeSightings.first.boletId, isNull);
    expect(treeSightings.first.confidenceScore, equals(0.95));
  });

  test('Migration self-heals legacy avistaments table with NOT NULL bolet_id',
      () async {
    // 1. Manually create a legacy v1 avistaments table with NOT NULL bolet_id
    await db.customStatement('DROP TABLE avistaments;');
    await db.customStatement('''
      CREATE TABLE avistaments (
        id TEXT NOT NULL PRIMARY KEY,
        bolet_id TEXT NOT NULL REFERENCES bolets (id),
        timestamp INTEGER NOT NULL,
        latitude REAL,
        longitude REAL,
        altitude REAL,
        photo_path TEXT,
        confidence_score REAL,
        notes TEXT
      );
    ''');

    // 2. Insert a legacy mushroom sighting
    await db.customStatement('''
      INSERT INTO avistaments (id, bolet_id, timestamp, notes)
      VALUES ('legacy-sighting-1', 'boletus_edulis', 1700000000, 'Legacy cep sighting');
    ''');

    // Verify it is currently NOT NULL
    final legacyCols =
        await db.customSelect('PRAGMA table_info(avistaments);').get();
    final legacyBoletCol =
        legacyCols.firstWhere((c) => c.read<String>('name') == 'bolet_id');
    expect(legacyBoletCol.read<int>('notnull'), equals(1));

    // 3. Trigger database opening/migration logic
    await db.migration.beforeOpen!(const OpeningDetails(null, 1));

    // 4. Verify table is migrated: bolet_id is now nullable (notnull == 0) and arbre_id exists
    final migratedCols =
        await db.customSelect('PRAGMA table_info(avistaments);').get();
    final migratedBoletCol =
        migratedCols.firstWhere((c) => c.read<String>('name') == 'bolet_id');
    expect(migratedBoletCol.read<int>('notnull'), equals(0));
    final hasArbreId =
        migratedCols.any((c) => c.read<String>('name') == 'arbre_id');
    expect(hasArbreId, isTrue);

    // 5. Verify pre-existing legacy sighting was preserved intact
    final legacySightings =
        await db.avistamentDao.getAvistamentsByBolet('boletus_edulis');
    expect(legacySightings.length, equals(1));
    expect(legacySightings.first.id, equals('legacy-sighting-1'));

    // 6. Verify inserting tree sighting with null boletId succeeds without throwing constraint error
    await db.avistamentDao.insertAvistament(
      AvistamentsCompanion(
        id: const Value('new-tree-sighting'),
        arbreId: const Value('pinus_sylvestris'),
        timestamp: Value(DateTime.now()),
      ),
    );
    final treeSightings =
        await db.avistamentDao.getAvistamentsByArbre('pinus_sylvestris');
    expect(treeSightings.length, equals(1));
    expect(treeSightings.first.arbreId, equals('pinus_sylvestris'));
  });
}
