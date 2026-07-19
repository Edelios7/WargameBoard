import 'package:drift/drift.dart';

import 'database_connection.dart';

// =========================
// Tables
// =========================

import 'tables/game_systems_table.dart';
import 'tables/editions_table.dart';
import 'tables/game_modes_table.dart';

import 'tables/factions_table.dart';
import 'tables/sub_factions_table.dart';

import 'tables/keywords_table.dart';
import 'tables/abilities_table.dart';

import 'tables/datasheets_table.dart';
import 'tables/datasheet_models_table.dart';
import 'tables/model_profiles_table.dart';

import 'tables/unit_sizes_table.dart';
import 'tables/unit_compositions_table.dart';

import 'tables/datasheet_costs_table.dart';
import 'tables/datasheet_versions_table.dart';
import 'tables/datasheet_sources_table.dart';

import 'tables/equipment_groups_table.dart';
import 'tables/equipment_options_table.dart';
import 'tables/equipment_choices_table.dart';
import 'tables/equipment_restrictions_table.dart';

import 'tables/weapons_table.dart';
import 'tables/weapon_profiles_table.dart';
import 'tables/datasheet_weapons_table.dart';

import 'tables/weapon_keyword_links_table.dart';
import 'tables/weapon_ability_links_table.dart';
import 'tables/datasheet_keyword_links_table.dart';
import 'tables/datasheet_ability_links_table.dart';

import 'tables/detachments_table.dart';
import 'tables/enhancements_table.dart';

import 'tables/armies_table.dart';
import 'tables/army_units_table.dart';

import 'tables/owned_miniatures_table.dart';

import 'tables/battles_table.dart';

// =========================
// DAO
// =========================

import 'daos/game_system_dao.dart';
import 'daos/faction_dao.dart';
import 'daos/ability_dao.dart';
import 'daos/keyword_dao.dart';
import 'daos/weapon_dao.dart';
import 'daos/datasheet_dao.dart';
import 'daos/army_dao.dart';
import 'daos/collection_dao.dart';
import 'daos/battle_dao.dart';

import 'seed/catalog_seed.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    // ===== GAME =====
    GameSystems,
    Editions,
    GameModes,

    // ===== FACTIONS =====
    Factions,
    SubFactions,

    // ===== RULES =====
    Keywords,
    Abilities,

    // ===== DATASHEETS =====
    Datasheets,
    DatasheetModels,
    ModelProfiles,

    UnitSizes,
    UnitCompositions,

    DatasheetCosts,
    DatasheetVersions,
    DatasheetSources,

    // ===== EQUIPMENT =====
    EquipmentGroups,
    EquipmentOptions,
    EquipmentChoices,
    EquipmentRestrictions,

    // ===== WEAPONS =====
    Weapons,
    WeaponProfiles,
    DatasheetWeapons,

    // ===== LINKS =====
    WeaponKeywordLinks,
    WeaponAbilityLinks,
    DatasheetKeywordLinks,
    DatasheetAbilityLinks,

    // ===== DETACHMENTS =====
    Detachments,
    Enhancements,

    // ===== ARMIES =====
    Armies,
    ArmyUnits,

    // ===== COLLECTION =====
    OwnedMiniatures,

    // ===== BATTLES =====
    Battles,
  ],
  daos: [
    GameSystemDao,
    FactionDao,
    AbilityDao,
    KeywordDao,
    WeaponDao,
    DatasheetDao,
    ArmyDao,
    CollectionDao,
    BattleDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  AppDatabase.forTesting(QueryExecutor executor) : super(executor);

  // =========================
  // DAO
  // =========================

  late final GameSystemDao gameSystemDao = GameSystemDao(this);

  late final FactionDao factionDao = FactionDao(this);

  late final AbilityDao abilityDao = AbilityDao(this);

  late final KeywordDao keywordDao = KeywordDao(this);

  late final WeaponDao weaponDao = WeaponDao(this);

  late final DatasheetDao datasheetDao = DatasheetDao(this);

  late final ArmyDao armyDao = ArmyDao(this);

  late final CollectionDao collectionDao = CollectionDao(this);

  late final BattleDao battleDao = BattleDao(this);

  // =========================
  // Database version
  // =========================

  @override
  int get schemaVersion => 6;

  // =========================
  // Migrations
  // =========================

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedCatalog(this);
        },

        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(armies);
            await m.createTable(armyUnits);
          }
          if (from < 3) {
            await m.addColumn(armies, armies.pointsLimit);
          }
          if (from < 4) {
            await m.createTable(ownedMiniatures);
          }
          if (from < 5) {
            await m.createTable(battles);
          }
          if (from < 6) {
            await m.createTable(detachments);
            await m.createTable(enhancements);
            await m.addColumn(armies, armies.detachmentId);
            await m.addColumn(armyUnits, armyUnits.enhancementId);
          }
        },

        beforeOpen: (details) async {
          // Initialisation future (PRAGMA, seed de données, etc.)
        },
      );
}