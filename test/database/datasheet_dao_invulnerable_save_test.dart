import 'package:drift/drift.dart' hide isNotNull, isNull;
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

  Future<void> insertDatasheet(String id, String name) => database
      .into(database.datasheets)
      .insert(
        DatasheetsCompanion.insert(
          id: id,
          factionId: seedFactionId,
          name: name,
          battlefieldRole: 'HQ',
          unitType: 'Infantry',
        ),
      );

  test(
    'a model profile with an invulnerable save round-trips it, while one '
    'without stays null instead of defaulting to 0 (which would read as '
    "an actual '0+' invulnerable save)",
    () async {
      const datasheetId = 'ds-test-invuln';
      await insertDatasheet(datasheetId, 'Fiche avec sauvegarde invulnérable');
      await database
          .into(database.datasheetModels)
          .insert(
            DatasheetModelsCompanion.insert(
              id: 'dm-test-invuln',
              datasheetId: datasheetId,
              name: 'Porteur',
            ),
          );
      await database
          .into(database.modelProfiles)
          .insert(
            ModelProfilesCompanion.insert(
              id: 'mp-test-invuln',
              datasheetModelId: 'dm-test-invuln',
              name: 'Porteur',
              movement: 6,
              toughness: 4,
              save: 3,
              wounds: 4,
              leadership: 6,
              objectiveControl: 1,
              invulnerableSave: const Value(4),
            ),
          );

      final details = await database.datasheetDao.getDatasheet(datasheetId);

      expect(details!.models.single.invulnerableSave, 4);
    },
  );

  test(
    'a model profile without an invulnerable save comes back as null, not 0',
    () async {
      const datasheetId = 'ds-test-no-invuln';
      await insertDatasheet(datasheetId, 'Fiche sans sauvegarde invulnérable');
      await database
          .into(database.datasheetModels)
          .insert(
            DatasheetModelsCompanion.insert(
              id: 'dm-test-no-invuln',
              datasheetId: datasheetId,
              name: 'Sans porteur',
            ),
          );
      await database
          .into(database.modelProfiles)
          .insert(
            ModelProfilesCompanion.insert(
              id: 'mp-test-no-invuln',
              datasheetModelId: 'dm-test-no-invuln',
              name: 'Sans porteur',
              movement: 6,
              toughness: 4,
              save: 3,
              wounds: 4,
              leadership: 6,
              objectiveControl: 1,
            ),
          );

      final details = await database.datasheetDao.getDatasheet(datasheetId);

      expect(details!.models.single.invulnerableSave, isNull);
    },
  );
}
