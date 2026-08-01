import 'package:drift/drift.dart' hide isNull;
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

  test('search(editionId: ...) only considers cost brackets from that '
      'edition, instead of always picking the cheapest bracket across '
      'every edition regardless of the filter', () async {
    const datasheetId = 'ds-test-multi-edition';
    const otherEditionId = 'ed-w40k-9e';

    await database
        .into(database.editions)
        .insert(
          EditionsCompanion.insert(
            id: otherEditionId,
            gameSystemId: seedGameSystemId,
            name: '9th Edition',
            version: 9,
            isCurrent: const Value(false),
          ),
        );
    await database
        .into(database.datasheets)
        .insert(
          DatasheetsCompanion.insert(
            id: datasheetId,
            factionId: seedFactionId,
            name: 'Fiche multi-édition',
            battlefieldRole: 'Troops',
            unitType: 'Infantry',
          ),
        );
    // Coût moins cher dans une AUTRE édition que celle demandée : ne
    // doit jamais gagner la déduplication quand on filtre sur
    // `seedEditionId` (c'était le bug — le moins cher toutes éditions
    // confondues l'emportait toujours).
    await database
        .into(database.datasheetCosts)
        .insert(
          DatasheetCostsCompanion.insert(
            id: 'cost-9e-cheap',
            datasheetId: datasheetId,
            editionId: otherEditionId,
            points: 10,
          ),
        );
    await database
        .into(database.datasheetCosts)
        .insert(
          DatasheetCostsCompanion.insert(
            id: 'cost-10e',
            datasheetId: datasheetId,
            editionId: seedEditionId,
            points: 90,
          ),
        );

    final resultsForRequestedEdition = await database.datasheetDao.search(
      'multi-édition',
      editionId: seedEditionId,
    );
    expect(resultsForRequestedEdition, hasLength(1));
    expect(resultsForRequestedEdition.single.points, 90);

    final resultsForOtherEdition = await database.datasheetDao.search(
      'multi-édition',
      editionId: otherEditionId,
    );
    expect(resultsForOtherEdition, hasLength(1));
    expect(resultsForOtherEdition.single.points, 10);
  });

  test('a datasheet with no cost data at all still appears regardless of '
      'the edition filter, with points left null', () async {
    const datasheetId = 'ds-test-no-costs';
    await database
        .into(database.datasheets)
        .insert(
          DatasheetsCompanion.insert(
            id: datasheetId,
            factionId: seedFactionId,
            name: 'Fiche sans coût',
            battlefieldRole: 'Troops',
            unitType: 'Infantry',
          ),
        );

    final results = await database.datasheetDao.search(
      'sans coût',
      editionId: seedEditionId,
    );

    expect(results, hasLength(1));
    expect(results.single.points, isNull);
  });
}
