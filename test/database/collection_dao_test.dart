import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('adding a collection entry surfaces faction and datasheet names',
      () async {
    final results = await database.datasheetDao.search('Sanguinary');
    final entryId = await database.collectionDao.addEntry(
      datasheetId: results.single.id,
      quantity: 5,
    );

    final entries = await database.collectionDao.listEntries();

    expect(entries, hasLength(1));
    expect(entries.single.id, entryId);
    expect(entries.single.datasheetName, 'Sanguinary Guard');
    expect(entries.single.factionName, 'Blood Angels');
    expect(entries.single.quantity, 5);
  });

  test('updateCounts clamps assembled/primed/painted to the quantity',
      () async {
    final results = await database.datasheetDao.search('Captain');
    final entryId = await database.collectionDao.addEntry(
      datasheetId: results.single.id,
      quantity: 3,
    );

    await database.collectionDao.updateCounts(
      entryId,
      assembled: 10,
      primed: 2,
      painted: -5,
    );

    final entries = await database.collectionDao.listEntries();
    final entry = entries.single;

    expect(entry.assembled, 3);
    expect(entry.primed, 2);
    expect(entry.painted, 0);
  });

  test('getSummary aggregates totals across entries', () async {
    final captain = await database.datasheetDao.search('Captain');
    final guard = await database.datasheetDao.search('Sanguinary');

    final captainEntry = await database.collectionDao.addEntry(
      datasheetId: captain.single.id,
      quantity: 1,
    );
    await database.collectionDao.addEntry(
      datasheetId: guard.single.id,
      quantity: 3,
    );
    await database.collectionDao.updateCounts(captainEntry, painted: 1);

    final summary = await database.collectionDao.getSummary();

    expect(summary.totalEntries, 2);
    expect(summary.totalModels, 4);
    expect(summary.totalPainted, 1);
  });
}
