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

// =========================
// DAO
// =========================

import 'daos/game_system_dao.dart';
import 'daos/faction_dao.dart';
import 'daos/ability_dao.dart';
import 'daos/keyword_dao.dart';
import 'daos/weapon_dao.dart';
import 'daos/datasheet_dao.dart';

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
  ],
  daos: [
    GameSystemDao,
    FactionDao,
    AbilityDao,
    KeywordDao,
    WeaponDao,
    DatasheetDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // =========================
  // DAO
  // =========================

  late final GameSystemDao gameSystemDao = GameSystemDao(this);

  late final FactionDao factionDao = FactionDao(this);

  late final AbilityDao abilityDao = AbilityDao(this);

  late final KeywordDao keywordDao = KeywordDao(this);

  late final WeaponDao weaponDao = WeaponDao(this);

  late final DatasheetDao datasheetDao = DatasheetDao(this);

  // =========================
  // Database version
  // =========================

  @override
  int get schemaVersion => 1;

  // =========================
  // Migrations
  // =========================

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },

        onUpgrade: (Migrator m, int from, int to) async {
          // Les futures migrations seront ajoutées ici.
        },

        beforeOpen: (details) async {
          // Initialisation future (PRAGMA, seed de données, etc.)
        },
      );
}