import 'package:drift/drift.dart' hide isNotNull;
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

  test(
    'when unit_sizes has no row for a datasheet, the size range is '
    'derived from its cost brackets instead of collapsing to a fixed 1 '
    'model — this is the case for almost the entire real catalog, where '
    'unit_sizes import coverage is sparse but cost brackets are not',
    () async {
      const datasheetId = 'ds-test-no-unit-sizes';
      await database
          .into(database.datasheets)
          .insert(
            DatasheetsCompanion.insert(
              id: datasheetId,
              factionId: seedFactionId,
              name: 'Fiche sans unit_sizes',
              battlefieldRole: 'Troops',
              unitType: 'Infantry',
            ),
          );
      await database
          .into(database.datasheetCosts)
          .insert(
            DatasheetCostsCompanion.insert(
              id: 'cost-test-5',
              datasheetId: datasheetId,
              editionId: seedEditionId,
              points: 90,
              modelCount: const Value(5),
            ),
          );
      await database
          .into(database.datasheetCosts)
          .insert(
            DatasheetCostsCompanion.insert(
              id: 'cost-test-10',
              datasheetId: datasheetId,
              editionId: seedEditionId,
              points: 160,
              modelCount: const Value(10),
            ),
          );

      final details = await database.datasheetDao.getDatasheet(datasheetId);

      expect(details, isNotNull);
      expect(details!.unit.minimumSize, 5);
      expect(details.unit.maximumSize, 10);
      expect(details.unit.defaultSize, 5);
      expect(details.points, 90);
    },
  );

  test('a datasheet with only a single cost bracket stays fixed-size — no '
      'phantom resizing range is invented from a single data point', () async {
    const datasheetId = 'ds-test-single-bracket';
    await database
        .into(database.datasheets)
        .insert(
          DatasheetsCompanion.insert(
            id: datasheetId,
            factionId: seedFactionId,
            name: 'Fiche à taille fixe',
            battlefieldRole: 'HQ',
            unitType: 'Infantry',
          ),
        );
    await database
        .into(database.datasheetCosts)
        .insert(
          DatasheetCostsCompanion.insert(
            id: 'cost-test-fixed',
            datasheetId: datasheetId,
            editionId: seedEditionId,
            points: 90,
            modelCount: const Value(1),
          ),
        );

    final details = await database.datasheetDao.getDatasheet(datasheetId);

    expect(details, isNotNull);
    expect(details!.unit.minimumSize, 1);
    expect(details.unit.maximumSize, 1);
  });
}
