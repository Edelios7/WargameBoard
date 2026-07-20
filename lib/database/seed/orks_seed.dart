import 'package:drift/drift.dart';

import '../app_database.dart';
import 'ability_seed.dart';
import 'faction_seed.dart';
import 'keyword_seed.dart';

const String wpChoppa = 'wp-choppa';
const String wpSlugga = 'wp-slugga';
const String wpBigShoota = 'wp-big-shoota';
const String wpPowerKlaw = 'wp-power-klaw';

const String dsWarboss = 'ds-warboss';
const String dsBoyz = 'ds-boyz';
const String dsNobz = 'ds-nobz';

Future<void> seedOrks(AppDatabase db) async {
  await _seedWeapons(db);
  await _seedWarboss(db);
  await _seedBoyz(db);
  await _seedNobz(db);
}

Future<void> _seedWeapons(AppDatabase db) async {
  final weapons = <String, ({String name, bool isMelee})>{
    wpChoppa: (name: 'Choppa', isMelee: true),
    wpSlugga: (name: 'Slugga', isMelee: false),
    wpBigShoota: (name: 'Big Shoota', isMelee: false),
    wpPowerKlaw: (name: 'Power Klaw', isMelee: true),
  };

  for (final entry in weapons.entries) {
    await db.into(db.weapons).insert(
          WeaponsCompanion.insert(
            id: entry.key,
            name: entry.value.name,
            isMelee: Value(entry.value.isMelee),
            isRanged: Value(!entry.value.isMelee),
          ),
        );
  }

  await db.into(db.weaponKeywordLinks).insert(
        WeaponKeywordLinksCompanion.insert(
          id: 'wkl-$wpSlugga-$kwPistol',
          weaponId: wpSlugga,
          keywordId: kwPistol,
        ),
      );
}

Future<void> _seedWarboss(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsWarboss,
          factionId: seedOrksFactionId,
          name: 'Warboss',
          battlefieldRole: 'HQ',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-warboss';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsWarboss,
          name: 'Warboss',
          isLeader: const Value(true),
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-warboss',
          datasheetModelId: modelId,
          name: 'Warboss',
          movement: 6,
          toughness: 6,
          save: 4,
          wounds: 6,
          leadership: 7,
          objectiveControl: 1,
        ),
      );

  await _attachWeapon(db, modelId, wpPowerKlaw);
  await _attachWeapon(db, modelId, wpSlugga);

  for (final kw in [kwInfantry, kwCharacter, kwOrks]) {
    await _linkDatasheetKeyword(db, dsWarboss, kw);
  }
  for (final ab in [abLeader, abEreWeGo, abWaaagh]) {
    await _linkDatasheetAbility(db, dsWarboss, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-warboss',
          datasheetId: dsWarboss,
          editionId: seedEditionId,
          points: 75,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-warboss',
          datasheetId: dsWarboss,
          minimumModels: 1,
          maximumModels: 1,
          defaultModels: 1,
        ),
      );
}

Future<void> _seedBoyz(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsBoyz,
          factionId: seedOrksFactionId,
          name: 'Boyz',
          battlefieldRole: 'Troops',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-boyz';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsBoyz,
          name: 'Ork Boy',
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-boyz',
          datasheetModelId: modelId,
          name: 'Ork Boy',
          movement: 6,
          toughness: 5,
          save: 6,
          wounds: 1,
          leadership: 7,
          objectiveControl: 2,
        ),
      );

  await _attachWeapon(db, modelId, wpChoppa);
  await _attachWeapon(db, modelId, wpSlugga);

  for (final kw in [kwInfantry, kwMob, kwOrks]) {
    await _linkDatasheetKeyword(db, dsBoyz, kw);
  }
  for (final ab in [abMobRule, abEreWeGo]) {
    await _linkDatasheetAbility(db, dsBoyz, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-boyz',
          datasheetId: dsBoyz,
          editionId: seedEditionId,
          points: 80,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-boyz',
          datasheetId: dsBoyz,
          minimumModels: 10,
          maximumModels: 20,
          defaultModels: 10,
        ),
      );
}

Future<void> _seedNobz(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsNobz,
          factionId: seedOrksFactionId,
          name: 'Nobz',
          battlefieldRole: 'Elites',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-nobz';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsNobz,
          name: 'Nob',
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-nobz',
          datasheetModelId: modelId,
          name: 'Nob',
          movement: 6,
          toughness: 5,
          save: 4,
          wounds: 2,
          leadership: 7,
          objectiveControl: 1,
        ),
      );

  await _attachWeapon(db, modelId, wpPowerKlaw);
  await _attachWeapon(db, modelId, wpBigShoota);

  for (final kw in [kwInfantry, kwMob, kwOrks]) {
    await _linkDatasheetKeyword(db, dsNobz, kw);
  }
  for (final ab in [abMobRule, abWaaagh]) {
    await _linkDatasheetAbility(db, dsNobz, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-nobz',
          datasheetId: dsNobz,
          editionId: seedEditionId,
          points: 90,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-nobz',
          datasheetId: dsNobz,
          minimumModels: 3,
          maximumModels: 9,
          defaultModels: 3,
        ),
      );
}

Future<void> _attachWeapon(
  AppDatabase db,
  String datasheetModelId,
  String weaponId,
) {
  return db.into(db.datasheetWeapons).insert(
        DatasheetWeaponsCompanion.insert(
          id: 'dw-$datasheetModelId-$weaponId',
          datasheetModelId: datasheetModelId,
          weaponId: weaponId,
          isDefault: const Value(true),
        ),
      );
}

Future<void> _linkDatasheetKeyword(
  AppDatabase db,
  String datasheetId,
  String keywordId,
) {
  return db.into(db.datasheetKeywordLinks).insert(
        DatasheetKeywordLinksCompanion.insert(
          id: 'dkl-$datasheetId-$keywordId',
          datasheetId: datasheetId,
          keywordId: keywordId,
        ),
      );
}

Future<void> _linkDatasheetAbility(
  AppDatabase db,
  String datasheetId,
  String abilityId,
) {
  return db.into(db.datasheetAbilityLinks).insert(
        DatasheetAbilityLinksCompanion.insert(
          id: 'dal-$datasheetId-$abilityId',
          datasheetId: datasheetId,
          abilityId: abilityId,
        ),
      );
}
