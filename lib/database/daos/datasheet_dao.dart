import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/datasheet_details.dart';
import '../models/equipment_details.dart';
import '../models/model_details.dart';
import '../models/search_result.dart';
import '../models/unit_details.dart';
import '../models/weapon_details.dart';
import '../tables/abilities_table.dart';
import '../tables/datasheet_ability_links_table.dart';
import '../tables/datasheet_costs_table.dart';
import '../tables/datasheet_keyword_links_table.dart';
import '../tables/datasheet_models_table.dart';
import '../tables/datasheet_weapons_table.dart';
import '../tables/datasheets_table.dart';
import '../tables/editions_table.dart';
import '../tables/equipment_groups_table.dart';
import '../tables/equipment_options_table.dart';
import '../tables/factions_table.dart';
import '../tables/keywords_table.dart';
import '../tables/model_profiles_table.dart';
import '../tables/unit_sizes_table.dart';
import '../tables/weapon_ability_links_table.dart';
import '../tables/weapon_keyword_links_table.dart';
import '../tables/weapons_table.dart';

part 'datasheet_dao.g.dart';

@DriftAccessor(
  tables: [
    Datasheets,
    Factions,
    DatasheetCosts,
    Editions,
    DatasheetKeywordLinks,
    Keywords,
    DatasheetAbilityLinks,
    Abilities,
    DatasheetModels,
    ModelProfiles,
    DatasheetWeapons,
    Weapons,
    WeaponKeywordLinks,
    WeaponAbilityLinks,
    EquipmentGroups,
    EquipmentOptions,
    UnitSizes,
  ],
)
class DatasheetDao extends DatabaseAccessor<AppDatabase>
    with _$DatasheetDaoMixin {
  DatasheetDao(AppDatabase db) : super(db);

  Future<List<SearchResult>> search(String text) async {
    final pattern = '%$text%';
    final query = select(datasheets).join([
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
    ])
      ..where(datasheets.name.like(pattern))
      ..orderBy([OrderingTerm.asc(datasheets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      final datasheet = row.readTable(datasheets);
      final faction = row.readTable(factions);
      return SearchResult(
        id: datasheet.id,
        name: datasheet.name,
        type: 'datasheet',
        subtitle: datasheet.battlefieldRole,
        factionId: faction.id,
        factionName: faction.name,
        gameSystemId: faction.gameSystemId,
        editionId: null,
      );
    }).toList();
  }

  Future<DatasheetDetails?> getDatasheet(String id) async {
    final query = select(datasheets).join([
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
    ])
      ..where(datasheets.id.equals(id));

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final datasheet = row.readTable(datasheets);
    final faction = row.readTable(factions);

    final cost = await _getCurrentCost(id);
    final keywordNames = await _getKeywordNames(id);
    final abilityNames = await _getAbilityNames(id);
    final models = await _getModels(id);
    final weaponDetails = await _getWeapons(id);
    final equipment = await _getEquipment(id);
    final unit = await _getUnitDetails(id);

    return DatasheetDetails(
      id: datasheet.id,
      name: datasheet.name,
      description: null,
      factionId: faction.id,
      factionName: faction.name,
      gameSystemId: faction.gameSystemId,
      editionId: cost.editionId,
      keywords: keywordNames,
      abilities: abilityNames,
      models: models,
      weapons: weaponDetails,
      equipment: equipment,
      unit: unit,
      points: cost.points,
    );
  }

  Future<({int points, String editionId})> _getCurrentCost(
      String datasheetId) async {
    final query = select(datasheetCosts).join([
      innerJoin(editions, editions.id.equalsExp(datasheetCosts.editionId)),
    ])
      ..where(datasheetCosts.datasheetId.equals(datasheetId) &
          editions.isCurrent.equals(true));

    final currentRow = await query.getSingleOrNull();
    if (currentRow != null) {
      final cost = currentRow.readTable(datasheetCosts);
      return (points: cost.points, editionId: cost.editionId);
    }

    final fallback = await (select(datasheetCosts)
          ..where((t) => t.datasheetId.equals(datasheetId))
          ..limit(1))
        .getSingleOrNull();
    return (points: fallback?.points ?? 0, editionId: fallback?.editionId ?? '');
  }

  Future<List<String>> _getKeywordNames(String datasheetId) async {
    final query = select(datasheetKeywordLinks).join([
      innerJoin(
          keywords, keywords.id.equalsExp(datasheetKeywordLinks.keywordId)),
    ])
      ..where(datasheetKeywordLinks.datasheetId.equals(datasheetId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(keywords).name).toList();
  }

  Future<List<String>> _getAbilityNames(String datasheetId) async {
    final query = select(datasheetAbilityLinks).join([
      innerJoin(
          abilities, abilities.id.equalsExp(datasheetAbilityLinks.abilityId)),
    ])
      ..where(datasheetAbilityLinks.datasheetId.equals(datasheetId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(abilities).name).toList();
  }

  Future<List<ModelDetails>> _getModels(String datasheetId) async {
    final query = select(modelProfiles).join([
      innerJoin(datasheetModels,
          datasheetModels.id.equalsExp(modelProfiles.datasheetModelId)),
    ])
      ..where(datasheetModels.datasheetId.equals(datasheetId));

    final rows = await query.get();
    return rows.map((row) {
      final profile = row.readTable(modelProfiles);
      return ModelDetails(
        id: profile.id,
        name: profile.name,
        movement: profile.movement,
        toughness: profile.toughness,
        save: profile.save,
        wounds: profile.wounds,
        leadership: profile.leadership,
        objectiveControl: profile.objectiveControl,
      );
    }).toList();
  }

  Future<List<WeaponDetails>> _getWeapons(String datasheetId) async {
    final query = select(datasheetWeapons).join([
      innerJoin(datasheetModels,
          datasheetModels.id.equalsExp(datasheetWeapons.datasheetModelId)),
      innerJoin(weapons, weapons.id.equalsExp(datasheetWeapons.weaponId)),
    ])
      ..where(datasheetModels.datasheetId.equals(datasheetId));

    final rows = await query.get();
    final seen = <String>{};
    final result = <WeaponDetails>[];
    for (final row in rows) {
      final weapon = row.readTable(weapons);
      if (!seen.add(weapon.id)) continue;
      result.add(WeaponDetails(
        id: weapon.id,
        name: weapon.name,
        type: weapon.isMelee ? 'Melee' : 'Ranged',
        keywords: await _weaponKeywordNames(weapon.id),
        abilities: await _weaponAbilityNames(weapon.id),
      ));
    }
    return result;
  }

  Future<List<String>> _weaponKeywordNames(String weaponId) async {
    final query = select(weaponKeywordLinks).join([
      innerJoin(
          keywords, keywords.id.equalsExp(weaponKeywordLinks.keywordId)),
    ])
      ..where(weaponKeywordLinks.weaponId.equals(weaponId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(keywords).name).toList();
  }

  Future<List<String>> _weaponAbilityNames(String weaponId) async {
    final query = select(weaponAbilityLinks).join([
      innerJoin(
          abilities, abilities.id.equalsExp(weaponAbilityLinks.abilityId)),
    ])
      ..where(weaponAbilityLinks.weaponId.equals(weaponId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(abilities).name).toList();
  }

  Future<List<EquipmentDetails>> _getEquipment(String datasheetId) async {
    final groups = await (select(equipmentGroups)
          ..where((t) => t.datasheetId.equals(datasheetId))
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();

    final result = <EquipmentDetails>[];
    for (final group in groups) {
      final options = await (select(equipmentOptions)
            ..where((t) => t.groupId.equals(group.id))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();
      result.add(EquipmentDetails(
        groupName: group.name,
        options: options.map((o) => o.name).toList(),
      ));
    }
    return result;
  }

  Future<UnitDetails> _getUnitDetails(String datasheetId) async {
    final size = await (select(unitSizes)
          ..where((t) => t.datasheetId.equals(datasheetId))
          ..limit(1))
        .getSingleOrNull();
    if (size == null) {
      return const UnitDetails(minimumSize: 1, maximumSize: 1, defaultSize: 1);
    }
    return UnitDetails(
      minimumSize: size.minimumModels,
      maximumSize: size.maximumModels,
      defaultSize: size.defaultModels,
    );
  }
}
