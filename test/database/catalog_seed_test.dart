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

  test('seeded Blood Angels datasheets are searchable', () async {
    final results = await database.datasheetDao.search('Sanguinary');

    expect(results, hasLength(1));
    expect(results.single.name, 'Sanguinary Guard');
    expect(results.single.factionName, 'Blood Angels');
  });

  test('getDatasheet resolves full details including weapons and keywords', () async {
    final results = await database.datasheetDao.search('Death Company');
    final details = await database.datasheetDao.getDatasheet(results.single.id);

    expect(details, isNotNull);
    expect(details!.factionName, 'Blood Angels');
    expect(details.points, greaterThan(0));
    expect(details.keywords, contains('Death Company'));
    expect(details.abilities, contains('Feel No Pain 5+'));
    expect(details.weapons, isNotEmpty);
    expect(details.unit.minimumSize, 5);
    expect(details.unit.maximumSize, 10);
  });

  test('unknown datasheet id returns null', () async {
    final details = await database.datasheetDao.getDatasheet('does-not-exist');
    expect(details, isNull);
  });
}
