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
import 'tables/stratagems_table.dart';

import 'tables/armies_table.dart';
import 'tables/army_units_table.dart';
import 'tables/army_unit_equipment_selections_table.dart';

import 'tables/owned_miniatures_table.dart';
import 'tables/wishlist_items_table.dart';

import 'tables/battles_table.dart';

import 'tables/projects_table.dart';

import 'tables/xp_category_totals_table.dart';
import 'tables/xp_faction_totals_table.dart';

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
import 'daos/project_dao.dart';
import 'daos/xp_dao.dart';

import 'seed/catalog_seed.dart';
import 'seed/weapon_profile_seed.dart';

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
    Stratagems,

    // ===== ARMIES =====
    Armies,
    ArmyUnits,
    ArmyUnitEquipmentSelections,

    // ===== COLLECTION =====
    OwnedMiniatures,
    WishlistItems,

    // ===== BATTLES =====
    Battles,

    // ===== PROJECTS =====
    Projects,

    // ===== XP =====
    XpCategoryTotals,
    XpFactionTotals,
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
    ProjectDao,
    XpDao,
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

  late final ProjectDao projectDao = ProjectDao(this);

  late final XpDao xpDao = XpDao(this);

  // =========================
  // Database version
  // =========================

  @override
  int get schemaVersion => 13;

  // =========================
  // Migrations
  // =========================

  /// Vérifie qu'une colonne existe déjà avant de l'ajouter. Nécessaire
  /// car le compteur de version de schéma (PRAGMA user_version) peut se
  /// désynchroniser du schéma réellement appliqué (vu en usage réel :
  /// une base dont les colonnes/tables d'une migration existaient déjà
  /// alors que user_version indiquait une version antérieure) — sans ce
  /// garde-fou, `m.addColumn` plante avec "duplicate column name" et
  /// l'appli ne démarre plus du tout.
  Future<bool> _hasColumn(String table, String column) async {
    final rows = await customSelect('PRAGMA table_info($table)').get();
    return rows.any((row) => row.data['name'] == column);
  }

  Future<bool> _hasTable(String name) async {
    final rows = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name = ?",
      variables: [Variable.withString(name)],
    ).get();
    return rows.isNotEmpty;
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedCatalog(this);
          await xpDao.seedCategories();
        },

        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            if (!await _hasTable('armies')) await m.createTable(armies);
            if (!await _hasTable('army_units')) await m.createTable(armyUnits);
          }
          if (from < 3) {
            if (!await _hasColumn('armies', 'points_limit')) {
              await m.addColumn(armies, armies.pointsLimit);
            }
          }
          if (from < 4) {
            if (!await _hasTable('owned_miniatures')) {
              await m.createTable(ownedMiniatures);
            }
          }
          if (from < 5) {
            if (!await _hasTable('battles')) await m.createTable(battles);
          }
          if (from < 6) {
            if (!await _hasTable('detachments')) {
              await m.createTable(detachments);
            }
            if (!await _hasTable('enhancements')) {
              await m.createTable(enhancements);
            }
            if (!await _hasColumn('armies', 'detachment_id')) {
              await m.addColumn(armies, armies.detachmentId);
            }
            if (!await _hasColumn('army_units', 'enhancement_id')) {
              await m.addColumn(armyUnits, armyUnits.enhancementId);
            }
          }
          if (from < 7) {
            if (!await _hasTable('stratagems')) {
              await m.createTable(stratagems);
            }
          }
          if (from < 8) {
            if (!await _hasTable('wishlist_items')) {
              await m.createTable(wishlistItems);
            }
          }
          if (from < 9) {
            // Backfill des profils d'armes sur les bases déjà créées
            // avant leur introduction dans le seed.
            await seedWeaponProfiles(this);
          }
          if (from < 10) {
            if (!await _hasColumn('battles', 'opponent_faction_id')) {
              await m.addColumn(battles, battles.opponentFactionId);
            }
            if (!await _hasColumn('battles', 'location')) {
              await m.addColumn(battles, battles.location);
            }
            if (!await _hasColumn('battles', 'type')) {
              await m.addColumn(battles, battles.type);
            }
            if (!await _hasTable('projects')) await m.createTable(projects);
            if (!await _hasTable('xp_category_totals')) {
              await m.createTable(xpCategoryTotals);
            }
            if (!await _hasTable('xp_faction_totals')) {
              await m.createTable(xpFactionTotals);
            }
            await xpDao.seedCategories();
          }
          if (from < 11) {
            if (!await _hasTable('army_unit_equipment_selections')) {
              await m.createTable(armyUnitEquipmentSelections);
            }
          }
          if (from < 12) {
            if (!await _hasColumn('datasheet_costs', 'model_count')) {
              await m.addColumn(datasheetCosts, datasheetCosts.modelCount);
            }
          }
          if (from < 13) {
            if (!await _hasColumn('army_units', 'is_warlord')) {
              await m.addColumn(armyUnits, armyUnits.isWarlord);
            }
          }
        },

        beforeOpen: (details) async {
          // Initialisation future (PRAGMA, seed de données, etc.)
        },
      );
}