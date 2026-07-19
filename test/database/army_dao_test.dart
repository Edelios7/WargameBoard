import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creating an army and adding units computes correct total points',
      () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Ma première liste',
      factionId: seedFactionId,
    );

    final searchResults = await database.datasheetDao.search('Captain');
    final captainId = searchResults.single.id;

    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captainId,
      modelCount: 1,
    );

    final army = await database.armyDao.getArmy(armyId);

    expect(army, isNotNull);
    expect(army!.name, 'Ma première liste');
    expect(army.factionName, 'Blood Angels');
    expect(army.units, hasLength(1));
    expect(army.units.single.datasheetName, 'Captain');
    expect(army.totalPoints, greaterThan(0));
    expect(army.totalPoints, army.units.single.points);
  });

  test('listArmies returns totals matching getArmy', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Sanguinary');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 3,
    );

    final list = await database.armyDao.listArmies();
    final detail = await database.armyDao.getArmy(armyId);

    expect(list, hasLength(1));
    expect(list.single.totalPoints, detail!.totalPoints);
  });

  test('removing a unit updates the army total', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Death Company');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 5,
    );

    await database.armyDao.removeUnit(unitId);

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.units, isEmpty);
    expect(army.totalPoints, 0);
  });

  test('updateModelCount clamps to the datasheet min/max range', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Death Company');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 5,
    );

    final tooHigh = await database.armyDao.updateModelCount(unitId, 99);
    expect(tooHigh, 10);

    final tooLow = await database.armyDao.updateModelCount(unitId, 1);
    expect(tooLow, 5);
  });

  test('isOverLimit reflects the army points limit', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Liste limitée',
      factionId: seedFactionId,
      pointsLimit: 50,
    );
    final results = await database.datasheetDao.search('Captain');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 1,
    );

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.pointsLimit, 50);
    expect(army.isOverLimit, isTrue);
  });
}
