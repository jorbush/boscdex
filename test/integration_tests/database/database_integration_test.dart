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
    expect(bolets.length, equals(22));

    final arbres = await db.arbreDao.getAllArbres();
    expect(arbres.length, equals(5));

    final insignies = await db.insigniaDao.getAllInsignies();
    expect(insignies.length, equals(6));
  });

  test('BoletDao queries work correctly', () async {
    final rovello = await db.boletDao.getBoletById('lactarius_deliciosus');
    expect(rovello, isNotNull);
    expect(rovello!.catalanName, contains('Rovelló'));
    expect(rovello.scientificName, equals('Lactarius deliciosus'));

    final edibles = await db.boletDao.getBoletsByEdibility('excellent');
    expect(edibles.length, greaterThanOrEqualTo(5));

    final lookalikes =
        await db.boletDao.getToxicLookalikes('lactarius_deliciosus');
    expect(lookalikes, isNotEmpty);
  });

  test('BoletDao searchByName finds specimens by Catalan or scientific name',
      () async {
    final searchCatalan = await db.boletDao.searchByName('Rovelló');
    expect(searchCatalan.length, equals(2)); // Pinetell & Rovelló d'obaga

    final searchScientific = await db.boletDao.searchByName('Boletus');
    expect(searchScientific, isNotEmpty);
    expect(searchScientific.first.scientificName, contains('Boletus'));

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
        boletId: 'boletus_edulis',
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
        boletId: 'boletus_edulis',
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
        boletId: 'cantharellus_cibarius',
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
}
