import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/detachment_seed.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/repositories/army_repository.dart';
import 'package:wargameboard/services/army_builder_service.dart';
import 'package:wargameboard/services/xp_service.dart';

void main() {
  late AppDatabase database;
  late ArmyRepository repository;
  late ArmyBuilderService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ArmyRepository(database, XpService(database));
    service = ArmyBuilderService(repository);
  });

  tearDown(() async {
    await database.close();
  });

  test('duplicating an army copies its detachment, units and enhancements',
      () async {
    final sourceId = await repository.createArmy(
      name: 'Originale',
      factionId: seedFactionId,
      pointsLimit: 2000,
      detachmentId: detAngelicHost,
    );
    final results = await database.datasheetDao.search('Captain');
    final unitId = await repository.addUnit(
      armyId: sourceId,
      datasheetId: results.single.id,
      modelCount: 1,
    );
    await repository.setUnitEnhancement(unitId, enhDeathVisions);

    final newId = await service.duplicateArmy(sourceId, 'Copie');
    final copy = await repository.getArmy(newId!);

    expect(copy!.name, 'Copie');
    expect(copy.factionId, seedFactionId);
    expect(copy.detachmentId, detAngelicHost);
    expect(copy.pointsLimit, 2000);
    expect(copy.units, hasLength(1));
    expect(copy.units.single.datasheetName, 'Captain');
    expect(copy.units.single.enhancementName, 'Death Visions of Sanguinius');

    // L'originale n'est pas affectée par la copie.
    final original = await repository.getArmy(sourceId);
    expect(original!.units, hasLength(1));
  });

  test('duplicating an unknown army returns null', () async {
    final result = await service.duplicateArmy('does-not-exist', 'Copie');
    expect(result, isNull);
  });
}
