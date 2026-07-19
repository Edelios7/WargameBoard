import 'package:drift/drift.dart';

import '../app_database.dart';
import 'ability_seed.dart';
import 'faction_seed.dart';
import 'keyword_seed.dart';

const String wpMasterCraftedPowerWeapon = 'wp-master-crafted-power-weapon';
const String wpPlasmaPistol = 'wp-plasma-pistol';
const String wpAstartesChainsword = 'wp-astartes-chainsword';
const String wpBoltPistol = 'wp-bolt-pistol';
const String wpGlaiveEncarmine = 'wp-glaive-encarmine';
const String wpAngelusBoltgun = 'wp-angelus-boltgun';

const String dsCaptain = 'ds-captain';
const String dsDeathCompanyMarines = 'ds-death-company-marines';
const String dsSanguinaryGuard = 'ds-sanguinary-guard';

Future<void> seedDatasheets(AppDatabase db) async {
  await _seedWeapons(db);
  await _seedCaptain(db);
  await _seedDeathCompanyMarines(db);
  await _seedSanguinaryGuard(db);
}

Future<void> _seedWeapons(AppDatabase db) async {
  final weapons = <String, ({String name, bool isMelee})>{
    wpMasterCraftedPowerWeapon: (name: 'Master-crafted power weapon', isMelee: true),
    wpPlasmaPistol: (name: 'Plasma pistol', isMelee: false),
    wpAstartesChainsword: (name: 'Astartes chainsword', isMelee: true),
    wpBoltPistol: (name: 'Bolt pistol', isMelee: false),
    wpGlaiveEncarmine: (name: 'Glaive encarmine', isMelee: true),
    wpAngelusBoltgun: (name: 'Angelus boltgun', isMelee: false),
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

  await _linkWeaponKeyword(db, wpPlasmaPistol, kwPistol);
  await _linkWeaponKeyword(db, wpBoltPistol, kwPistol);
  await _linkWeaponKeyword(db, wpAngelusBoltgun, kwAssault);
  await _linkWeaponAbility(db, wpMasterCraftedPowerWeapon, abLethalHits);
  await _linkWeaponAbility(db, wpGlaiveEncarmine, abLethalHits);
}

Future<void> _seedCaptain(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsCaptain,
          factionId: seedFactionId,
          name: 'Captain',
          battlefieldRole: 'HQ',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-captain';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsCaptain,
          name: 'Captain',
          isLeader: const Value(true),
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-captain',
          datasheetModelId: modelId,
          name: 'Captain',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 5,
          leadership: 6,
          objectiveControl: 1,
        ),
      );

  await _attachWeapon(db, modelId, wpMasterCraftedPowerWeapon);
  await _attachWeapon(db, modelId, wpPlasmaPistol);

  for (final kw in [kwInfantry, kwCharacter, kwAdeptusAstartes, kwBloodAngels, kwImperium]) {
    await _linkDatasheetKeyword(db, dsCaptain, kw);
  }
  for (final ab in [abLeader, abShockAssault]) {
    await _linkDatasheetAbility(db, dsCaptain, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-captain',
          datasheetId: dsCaptain,
          editionId: seedEditionId,
          points: 90,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-captain',
          datasheetId: dsCaptain,
          minimumModels: 1,
          maximumModels: 1,
          defaultModels: 1,
        ),
      );
}

Future<void> _seedDeathCompanyMarines(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsDeathCompanyMarines,
          factionId: seedFactionId,
          name: 'Death Company Marines',
          battlefieldRole: 'Elites',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-death-company';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsDeathCompanyMarines,
          name: 'Death Company Marine',
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-death-company',
          datasheetModelId: modelId,
          name: 'Death Company Marine',
          movement: 6,
          toughness: 4,
          save: 3,
          wounds: 2,
          leadership: 6,
          objectiveControl: 1,
        ),
      );

  await _attachWeapon(db, modelId, wpAstartesChainsword);
  await _attachWeapon(db, modelId, wpBoltPistol);

  for (final kw in [kwInfantry, kwDeathCompany, kwAdeptusAstartes, kwBloodAngels, kwImperium]) {
    await _linkDatasheetKeyword(db, dsDeathCompanyMarines, kw);
  }
  for (final ab in [abFeelNoPain5, abBlackRage, abShockAssault]) {
    await _linkDatasheetAbility(db, dsDeathCompanyMarines, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-death-company',
          datasheetId: dsDeathCompanyMarines,
          editionId: seedEditionId,
          points: 90,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-death-company',
          datasheetId: dsDeathCompanyMarines,
          minimumModels: 5,
          maximumModels: 10,
          defaultModels: 5,
        ),
      );
}

Future<void> _seedSanguinaryGuard(AppDatabase db) async {
  await db.into(db.datasheets).insert(
        DatasheetsCompanion.insert(
          id: dsSanguinaryGuard,
          factionId: seedFactionId,
          name: 'Sanguinary Guard',
          battlefieldRole: 'Elites',
          unitType: 'Infantry',
        ),
      );

  const modelId = 'dm-sanguinary-guard';
  await db.into(db.datasheetModels).insert(
        DatasheetModelsCompanion.insert(
          id: modelId,
          datasheetId: dsSanguinaryGuard,
          name: 'Sanguinary Guard',
        ),
      );

  await db.into(db.modelProfiles).insert(
        ModelProfilesCompanion.insert(
          id: 'mp-sanguinary-guard',
          datasheetModelId: modelId,
          name: 'Sanguinary Guard',
          movement: 12,
          toughness: 4,
          save: 2,
          wounds: 3,
          leadership: 6,
          objectiveControl: 2,
        ),
      );

  await _attachWeapon(db, modelId, wpGlaiveEncarmine);
  await _attachWeapon(db, modelId, wpAngelusBoltgun);

  for (final kw in [kwInfantry, kwFly, kwAdeptusAstartes, kwBloodAngels, kwImperium]) {
    await _linkDatasheetKeyword(db, dsSanguinaryGuard, kw);
  }
  for (final ab in [abAngelicVisage, abDeepStrike]) {
    await _linkDatasheetAbility(db, dsSanguinaryGuard, ab);
  }

  await db.into(db.datasheetCosts).insert(
        DatasheetCostsCompanion.insert(
          id: 'cost-sanguinary-guard',
          datasheetId: dsSanguinaryGuard,
          editionId: seedEditionId,
          points: 110,
        ),
      );

  await db.into(db.unitSizes).insert(
        UnitSizesCompanion.insert(
          id: 'size-sanguinary-guard',
          datasheetId: dsSanguinaryGuard,
          minimumModels: 3,
          maximumModels: 6,
          defaultModels: 3,
        ),
      );
}

Future<void> _attachWeapon(AppDatabase db, String datasheetModelId, String weaponId) {
  return db.into(db.datasheetWeapons).insert(
        DatasheetWeaponsCompanion.insert(
          id: 'dw-$datasheetModelId-$weaponId',
          datasheetModelId: datasheetModelId,
          weaponId: weaponId,
          isDefault: const Value(true),
        ),
      );
}

Future<void> _linkDatasheetKeyword(AppDatabase db, String datasheetId, String keywordId) {
  return db.into(db.datasheetKeywordLinks).insert(
        DatasheetKeywordLinksCompanion.insert(
          id: 'dkl-$datasheetId-$keywordId',
          datasheetId: datasheetId,
          keywordId: keywordId,
        ),
      );
}

Future<void> _linkDatasheetAbility(AppDatabase db, String datasheetId, String abilityId) {
  return db.into(db.datasheetAbilityLinks).insert(
        DatasheetAbilityLinksCompanion.insert(
          id: 'dal-$datasheetId-$abilityId',
          datasheetId: datasheetId,
          abilityId: abilityId,
        ),
      );
}

Future<void> _linkWeaponKeyword(AppDatabase db, String weaponId, String keywordId) {
  return db.into(db.weaponKeywordLinks).insert(
        WeaponKeywordLinksCompanion.insert(
          id: 'wkl-$weaponId-$keywordId',
          weaponId: weaponId,
          keywordId: keywordId,
        ),
      );
}

Future<void> _linkWeaponAbility(AppDatabase db, String weaponId, String abilityId) {
  return db.into(db.weaponAbilityLinks).insert(
        WeaponAbilityLinksCompanion.insert(
          id: 'wal-$weaponId-$abilityId',
          weaponId: weaponId,
          abilityId: abilityId,
        ),
      );
}
