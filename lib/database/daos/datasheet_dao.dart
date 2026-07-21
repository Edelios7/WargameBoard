import 'package:drift/drift.dart';

import '../../domain/catalog/factions/space_marine_chapters.dart';
import '../../domain/xp/xp_awards.dart';
import '../app_database.dart';
import '../models/ability_details.dart';
import '../models/catalog_sort.dart';
import '../models/cost_bracket.dart';
import '../models/datasheet_details.dart';
import '../models/equipment_details.dart';
import '../models/model_details.dart';
import '../models/search_result.dart';
import '../models/unit_details.dart';
import '../models/weapon_details.dart';
import '../tables/abilities_table.dart';
import '../tables/army_units_table.dart';
import '../tables/datasheet_ability_links_table.dart';
import '../tables/datasheet_costs_table.dart';
import '../tables/datasheet_keyword_links_table.dart';
import '../tables/datasheet_models_table.dart';
import '../tables/datasheet_weapons_table.dart';
import '../tables/datasheets_table.dart';
import '../tables/editions_table.dart';
import '../tables/equipment_choices_table.dart';
import '../tables/equipment_groups_table.dart';
import '../tables/equipment_options_table.dart';
import '../tables/factions_table.dart';
import '../tables/keywords_table.dart';
import '../tables/model_profiles_table.dart';
import '../tables/unit_sizes_table.dart';
import '../tables/weapon_ability_links_table.dart';
import '../tables/weapon_keyword_links_table.dart';
import '../tables/weapon_profiles_table.dart';
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
    WeaponProfiles,
    EquipmentGroups,
    EquipmentOptions,
    EquipmentChoices,
    UnitSizes,
    ArmyUnits,
  ],
)
class DatasheetDao extends DatabaseAccessor<AppDatabase>
    with _$DatasheetDaoMixin {
  DatasheetDao(AppDatabase db) : super(db);

  Future<int> countDatasheets() async {
    return (await select(datasheets).get()).length;
  }

  /// Classification légère d'une datasheet pour le barème d'XP peinture/
  /// montage (voir lib/domain/xp/xp_awards.dart) : faction + gabarit
  /// (personnage / véhicule / standard), déduits des colonnes existantes
  /// (`isNamedCharacter`/`isEpicHero`, `unitType`, `battlefieldRole`) sans
  /// dépendre d'un enum de rôle strict, la donnée source (import PDF) étant
  /// encore en texte libre.
  Future<DatasheetXpClass?> getXpClassification(String datasheetId) async {
    final row = await (select(datasheets)
          ..where((t) => t.id.equals(datasheetId)))
        .getSingleOrNull();
    if (row == null) return null;

    final typeAndRole =
        '${row.unitType} ${row.battlefieldRole}'.toLowerCase();
    const vehicleKeywords = [
      'vehicle',
      'véhicule',
      'monster',
      'monstre',
      'aircraft',
      'aéronef',
      'fortification',
    ];

    return DatasheetXpClass(
      factionId: row.factionId,
      isCharacterTier: row.isNamedCharacter || row.isEpicHero,
      isVehicleTier: vehicleKeywords.any(typeAndRole.contains),
    );
  }

  Future<int> countModelProfiles() async {
    return (await select(modelProfiles).get()).length;
  }

  /// Datasheets les plus utilisées à travers toutes les armées (favoris).
  Future<List<SearchResult>> mostUsedDatasheets({int limit = 5}) async {
    final query = select(armyUnits).join([
      innerJoin(
        datasheets,
        datasheets.id.equalsExp(armyUnits.datasheetId),
      ),
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
    ]);

    final rows = await query.get();
    final counts = <String, int>{};
    final byId = <String, SearchResult>{};
    for (final row in rows) {
      final datasheet = row.readTable(datasheets);
      final faction = row.readTable(factions);
      counts[datasheet.id] = (counts[datasheet.id] ?? 0) + 1;
      byId[datasheet.id] = SearchResult(
        id: datasheet.id,
        name: datasheet.name,
        type: 'datasheet',
        subtitle: datasheet.battlefieldRole,
        factionId: faction.id,
        factionName: faction.name,
        gameSystemId: faction.gameSystemId,
        editionId: null,
      );
    }
    final sortedIds = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return sortedIds.take(limit).map((id) => byId[id]!).toList();
  }

  Future<List<SearchResult>> search(
    String text, {
    String? factionId,
    Set<String> keywordIds = const {},
    String? role,
    String? unitType,
    String? editionId,
    int? minPoints,
    int? maxPoints,
    CatalogSort sortBy = CatalogSort.nameAsc,
  }) async {
    final pattern = '%$text%';
    final costPoints = datasheetCosts.points;

    final query = select(datasheets).join([
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
      leftOuterJoin(
        datasheetCosts,
        datasheetCosts.datasheetId.equalsExp(datasheets.id),
      ),
      leftOuterJoin(
        editions,
        editions.id.equalsExp(datasheetCosts.editionId) &
            (editionId != null
                ? editions.id.equals(editionId)
                : editions.isCurrent.equals(true)),
      ),
    ])
      ..where(datasheets.name.like(pattern));

    if (factionId != null) {
      final matchIds = await _resolveFactionIdsForFilter(factionId);
      query.where(datasheets.factionId.isIn(matchIds));
    }
    if (role != null) {
      query.where(datasheets.battlefieldRole.equals(role));
    }
    if (unitType != null) {
      query.where(datasheets.unitType.equals(unitType));
    }
    // minPoints/maxPoints se filtrent en Dart plus bas, après
    // déduplication des paliers de coût — voir commentaire ci-dessous.

    // Le tri SQL n'est qu'indicatif ici : une datasheet à plusieurs
    // paliers de coût (voir DatasheetCosts.modelCount) produit une ligne
    // par palier via le join ci-dessus, donc on trie/filtre à nouveau en
    // Dart après avoir dédupliqué (une seule entrée par datasheet, celle
    // au palier le moins cher, cohérent avec l'affichage "coût de base").
    query.orderBy([OrderingTerm.asc(datasheets.name)]);

    final rows = await query.get();
    final byDatasheetId = <String, SearchResult>{};
    for (final row in rows) {
      final datasheet = row.readTable(datasheets);
      final faction = row.readTable(factions);
      final points = row.read(costPoints);
      final existing = byDatasheetId[datasheet.id];
      if (existing != null &&
          (existing.points ?? _maxSearchPoints) <= (points ?? _maxSearchPoints)) {
        continue;
      }
      byDatasheetId[datasheet.id] = SearchResult(
        id: datasheet.id,
        name: datasheet.name,
        type: 'datasheet',
        subtitle: datasheet.battlefieldRole,
        factionId: faction.id,
        factionName: faction.name,
        gameSystemId: faction.gameSystemId,
        editionId: null,
        unitType: datasheet.unitType,
        points: points,
      );
    }

    var results = byDatasheetId.values.toList();

    if (keywordIds.isNotEmpty) {
      // Filtre "ET" : une fiche doit porter TOUS les mots-clés
      // sélectionnés, pas juste un seul. Fait en Dart après dédup plutôt
      // qu'un join (un join par mot-clé sélectionné ferait fanner-out
      // les lignes, comme pour les paliers de coût ci-dessus).
      final candidateIds = results.map((r) => r.id).toList();
      if (candidateIds.isEmpty) return const [];
      final linkRows = await (select(datasheetKeywordLinks)
            ..where((t) =>
                t.datasheetId.isIn(candidateIds) &
                t.keywordId.isIn(keywordIds.toList())))
          .get();
      final matchedKeywordsByDatasheet = <String, Set<String>>{};
      for (final link in linkRows) {
        matchedKeywordsByDatasheet
            .putIfAbsent(link.datasheetId, () => {})
            .add(link.keywordId);
      }
      results = results
          .where((r) =>
              (matchedKeywordsByDatasheet[r.id]?.length ?? 0) ==
              keywordIds.length)
          .toList();
    }

    if (minPoints != null) {
      results = results.where((r) => (r.points ?? 0) >= minPoints).toList();
    }
    if (maxPoints != null) {
      results = results.where((r) => (r.points ?? 0) <= maxPoints).toList();
    }

    switch (sortBy) {
      case CatalogSort.nameAsc:
        results.sort((a, b) => a.name.compareTo(b.name));
        break;
      case CatalogSort.pointsAsc:
        results.sort((a, b) {
          final cmp = (a.points ?? 0).compareTo(b.points ?? 0);
          return cmp != 0 ? cmp : a.name.compareTo(b.name);
        });
        break;
      case CatalogSort.pointsDesc:
        results.sort((a, b) {
          final cmp = (b.points ?? 0).compareTo(a.points ?? 0);
          return cmp != 0 ? cmp : a.name.compareTo(b.name);
        });
        break;
    }
    return results;
  }

  static const _maxSearchPoints = 1 << 30;

  /// Élargit un filtre de faction pour les chapitres de Space Marines :
  /// une armée Blood Angels peut aussi jouer des unités Space Marines
  /// génériques (pas propres à un chapitre), qui sont une faction à
  /// part dans les données importées. Sans ça, filtrer par faction lors
  /// de l'ajout d'une unité ne montrerait que les fiches strictement
  /// Blood Angels, en excluant à tort tout le "socle" Space Marines
  /// commun. L'inverse n'est pas vrai : une armée Space Marines
  /// générique ne doit pas voir apparaître les unités propres à un
  /// chapitre (ex. personnages nommés Blood Angels).
  Future<List<String>> _resolveFactionIdsForFilter(String factionId) async {
    final target = await (select(factions)
          ..where((t) => t.id.equals(factionId)))
        .getSingleOrNull();
    if (target == null || !isSpaceMarineFactionName(target.name)) {
      return [factionId];
    }
    if (isGenericSpaceMarinesFactionName(target.name)) {
      return [factionId];
    }

    final allFactions = await select(factions).get();
    final genericIds = allFactions
        .where((f) => isGenericSpaceMarinesFactionName(f.name))
        .map((f) => f.id);
    return {factionId, ...genericIds}.toList();
  }

  Future<List<String>> getDistinctRoles() async {
    final query = selectOnly(datasheets, distinct: true)
      ..addColumns([datasheets.battlefieldRole])
      ..orderBy([OrderingTerm.asc(datasheets.battlefieldRole)]);
    final rows = await query.get();
    return rows.map((row) => row.read(datasheets.battlefieldRole)!).toList();
  }

  Future<List<String>> getDistinctUnitTypes() async {
    final query = selectOnly(datasheets, distinct: true)
      ..addColumns([datasheets.unitType])
      ..orderBy([OrderingTerm.asc(datasheets.unitType)]);
    final rows = await query.get();
    return rows.map((row) => row.read(datasheets.unitType)!).toList();
  }

  Future<List<Edition>> getEditions() async {
    final query = select(editions)
      ..orderBy([(e) => OrderingTerm.desc(e.version)]);
    return query.get();
  }

  Future<int> getMaxPoints() async {
    final maxExp = datasheetCosts.points.max();
    final query = selectOnly(datasheetCosts)..addColumns([maxExp]);
    final row = await query.getSingleOrNull();
    return row?.read(maxExp) ?? 0;
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

    final unit = await _getUnitDetails(id);
    final costs = await _getCostBrackets(id);
    final points = resolveCostForModelCount(costs.brackets, unit.defaultSize);
    final keywordNames = await _getKeywordNames(id);
    final abilityDetails = await _getAbilityDetails(id);
    final models = await _getModels(id);
    final weaponDetails = await _getWeapons(id);
    final equipment = await _getEquipment(id);
    final equipmentGroups = await _getEquipmentGroups(id);

    return DatasheetDetails(
      id: datasheet.id,
      name: datasheet.name,
      description: null,
      factionId: faction.id,
      factionName: faction.name,
      gameSystemId: faction.gameSystemId,
      editionId: costs.editionId,
      keywords: keywordNames,
      abilities: abilityDetails,
      models: models,
      weapons: weaponDetails,
      equipment: equipment,
      equipmentGroups: equipmentGroups,
      unit: unit,
      points: points,
      costBrackets: costs.brackets,
    );
  }

  /// Coût en points pour un nombre de figurines donné, en tenant compte
  /// des paliers de coût par taille d'unité (voir [resolveCostForModelCount]).
  Future<int> getCostForModelCount(String datasheetId, int modelCount) async {
    final costs = await _getCostBrackets(datasheetId);
    return resolveCostForModelCount(costs.brackets, modelCount);
  }

  Future<({List<CostBracket> brackets, String editionId})> _getCostBrackets(
      String datasheetId) async {
    final query = select(datasheetCosts).join([
      innerJoin(editions, editions.id.equalsExp(datasheetCosts.editionId)),
    ])
      ..where(datasheetCosts.datasheetId.equals(datasheetId) &
          editions.isCurrent.equals(true));

    final currentRows = await query.get();
    if (currentRows.isNotEmpty) {
      final brackets = currentRows.map((row) {
        final cost = row.readTable(datasheetCosts);
        return CostBracket(modelCount: cost.modelCount, points: cost.points);
      }).toList();
      return (
        brackets: brackets,
        editionId: currentRows.first.readTable(datasheetCosts).editionId,
      );
    }

    final fallbackRows = await (select(datasheetCosts)
          ..where((t) => t.datasheetId.equals(datasheetId)))
        .get();
    if (fallbackRows.isEmpty) {
      return (brackets: const <CostBracket>[], editionId: '');
    }
    final editionId = fallbackRows.first.editionId;
    final brackets = fallbackRows
        .where((row) => row.editionId == editionId)
        .map((row) => CostBracket(modelCount: row.modelCount, points: row.points))
        .toList();
    return (brackets: brackets, editionId: editionId);
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

  Future<List<AbilityDetails>> _getAbilityDetails(String datasheetId) async {
    final query = select(datasheetAbilityLinks).join([
      innerJoin(
          abilities, abilities.id.equalsExp(datasheetAbilityLinks.abilityId)),
    ])
      ..where(datasheetAbilityLinks.datasheetId.equals(datasheetId))
      ..orderBy([OrderingTerm.asc(abilities.name)]);
    final rows = await query.get();
    return rows.map((r) {
      final ability = r.readTable(abilities);
      return AbilityDetails(
        id: ability.id,
        name: ability.name,
        description: ability.description,
        type: ability.type,
        isCore: ability.isCore,
      );
    }).toList();
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
        profiles: await _weaponProfiles(weapon.id),
      ));
    }
    return result;
  }

  Future<List<WeaponProfileDetails>> _weaponProfiles(String weaponId) async {
    final rows = await (select(weaponProfiles)
          ..where((t) => t.weaponId.equals(weaponId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows
        .map((p) => WeaponProfileDetails(
              name: p.name,
              range: p.range,
              attacks: p.attacks,
              ballisticSkill: p.ballisticSkill,
              weaponSkill: p.weaponSkill,
              strength: p.strength,
              armorPenetration: p.armorPenetration,
              damage: p.damage,
            ))
        .toList();
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

  /// Groupes d'équipement optionnel d'une datasheet (voir
  /// [EquipmentGroupDetails]) — utilisé par l'army builder pour piloter
  /// les choix d'armes par unité sans repasser par [getDatasheet] (qui
  /// recharge aussi modèles/armes/aptitudes, inutiles ici).
  Future<List<EquipmentGroupDetails>> getEquipmentGroups(
    String datasheetId,
  ) {
    return _getEquipmentGroups(datasheetId);
  }

  Future<List<EquipmentGroupDetails>> _getEquipmentGroups(
      String datasheetId) async {
    final groups = await (select(equipmentGroups)
          ..where((t) => t.datasheetId.equals(datasheetId))
          ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
        .get();

    final result = <EquipmentGroupDetails>[];
    for (final group in groups) {
      final options = await (select(equipmentOptions)
            ..where((t) => t.groupId.equals(group.id))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();
      final choice = await (select(equipmentChoices)
            ..where((t) => t.groupId.equals(group.id))
            ..limit(1))
          .getSingleOrNull();
      result.add(EquipmentGroupDetails(
        id: group.id,
        name: group.name,
        minimumChoices: choice?.minimumChoices ?? 1,
        maximumChoices: choice?.maximumChoices ?? 1,
        options: options
            .map((o) => EquipmentOptionDetails(
                  id: o.id,
                  name: o.name,
                  weaponId: o.weaponId,
                  isDefault: o.isDefault,
                ))
            .toList(),
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
