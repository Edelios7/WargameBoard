import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/army_details.dart';
import '../models/cost_bracket.dart';
import '../tables/armies_table.dart';
import '../tables/army_unit_equipment_selections_table.dart';
import '../tables/army_units_table.dart';
import '../tables/datasheet_costs_table.dart';
import '../tables/datasheets_table.dart';
import '../tables/detachments_table.dart';
import '../tables/editions_table.dart';
import '../tables/enhancements_table.dart';
import '../tables/factions_table.dart';
import '../tables/stratagems_table.dart';
import '../tables/unit_sizes_table.dart';

part 'army_dao.g.dart';

@DriftAccessor(
  tables: [
    Armies,
    ArmyUnits,
    ArmyUnitEquipmentSelections,
    Factions,
    Datasheets,
    DatasheetCosts,
    Editions,
    UnitSizes,
    Detachments,
    Enhancements,
    Stratagems,
  ],
)
class ArmyDao extends DatabaseAccessor<AppDatabase> with _$ArmyDaoMixin {
  ArmyDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<int> countArmies() async {
    return (await select(armies).get()).length;
  }

  Future<String?> getFactionId(String armyId) async {
    final row = await (select(armies)..where((t) => t.id.equals(armyId)))
        .getSingleOrNull();
    return row?.factionId;
  }

  Future<String> createArmy({
    required String name,
    required String factionId,
    int? pointsLimit,
    String? detachmentId,
  }) async {
    final id = _uuid.v4();
    await into(armies).insert(
      ArmiesCompanion.insert(
        id: id,
        factionId: factionId,
        name: name,
        pointsLimit: Value(pointsLimit),
        detachmentId: Value(detachmentId),
      ),
    );
    return id;
  }

  Future<void> deleteArmy(String armyId) async {
    await (delete(armyUnits)..where((t) => t.armyId.equals(armyId))).go();
    await (delete(armies)..where((t) => t.id.equals(armyId))).go();
  }

  Future<void> _touchArmy(String armyId) {
    return (update(armies)..where((t) => t.id.equals(armyId)))
        .write(ArmiesCompanion(updatedAt: Value(DateTime.now())));
  }

  Future<String> addUnit({
    required String armyId,
    required String datasheetId,
    required int modelCount,
  }) async {
    final id = _uuid.v4();
    await into(armyUnits).insert(
      ArmyUnitsCompanion.insert(
        id: id,
        armyId: armyId,
        datasheetId: datasheetId,
        modelCount: modelCount,
      ),
    );
    await _touchArmy(armyId);
    return id;
  }

  Future<void> removeUnit(String armyUnitId) async {
    final unit = await (select(armyUnits)
          ..where((t) => t.id.equals(armyUnitId)))
        .getSingleOrNull();
    await (delete(armyUnitEquipmentSelections)
          ..where((t) => t.armyUnitId.equals(armyUnitId)))
        .go();
    await (delete(armyUnits)..where((t) => t.id.equals(armyUnitId))).go();
    if (unit != null) await _touchArmy(unit.armyId);
  }

  /// Met à jour le nombre de figurines d'une unité, borné par les
  /// tailles min/max de sa datasheet. Retourne la valeur réellement
  /// appliquée (après éventuel ajustement).
  Future<int> updateModelCount(String armyUnitId, int modelCount) async {
    final unit = await (select(armyUnits)
          ..where((t) => t.id.equals(armyUnitId)))
        .getSingle();

    final size = await (select(unitSizes)
          ..where((t) => t.datasheetId.equals(unit.datasheetId))
          ..limit(1))
        .getSingleOrNull();

    var clamped = modelCount;
    if (size != null) {
      clamped = clamped.clamp(size.minimumModels, size.maximumModels);
    }

    await (update(armyUnits)..where((t) => t.id.equals(armyUnitId)))
        .write(ArmyUnitsCompanion(modelCount: Value(clamped)));
    await _touchArmy(unit.armyId);

    return clamped;
  }

  /// Attache (ou retire, si `enhancementId` est null) un enhancement à
  /// une unité.
  Future<void> setUnitEnhancement(
    String armyUnitId,
    String? enhancementId,
  ) async {
    final unit = await (select(armyUnits)
          ..where((t) => t.id.equals(armyUnitId)))
        .getSingle();
    await (update(armyUnits)..where((t) => t.id.equals(armyUnitId))).write(
      ArmyUnitsCompanion(enhancementId: Value(enhancementId)),
    );
    await _touchArmy(unit.armyId);
  }

  /// Choix d'équipement optionnel actuels d'une unité, groupés par
  /// groupe d'équipement. Un groupe absent de la map signifie "options
  /// par défaut de la datasheet" (rien n'a encore été changé).
  Future<Map<String, List<String>>> getUnitEquipmentSelections(
    String armyUnitId,
  ) async {
    final rows = await (select(armyUnitEquipmentSelections)
          ..where((t) => t.armyUnitId.equals(armyUnitId)))
        .get();
    final result = <String, List<String>>{};
    for (final row in rows) {
      result.putIfAbsent(row.groupId, () => []).add(row.optionId);
    }
    return result;
  }

  /// Remplace le choix d'équipement d'une unité pour un groupe donné.
  /// `optionIds` vide retombe sur les options par défaut de la
  /// datasheet (voir [getUnitEquipmentSelections]).
  Future<void> setUnitEquipmentSelection(
    String armyUnitId,
    String groupId,
    List<String> optionIds,
  ) async {
    await (delete(armyUnitEquipmentSelections)
          ..where((t) =>
              t.armyUnitId.equals(armyUnitId) & t.groupId.equals(groupId)))
        .go();
    for (final optionId in optionIds) {
      await into(armyUnitEquipmentSelections).insert(
        ArmyUnitEquipmentSelectionsCompanion.insert(
          id: _uuid.v4(),
          armyUnitId: armyUnitId,
          groupId: groupId,
          optionId: optionId,
        ),
      );
    }
    final unit = await (select(armyUnits)
          ..where((t) => t.id.equals(armyUnitId)))
        .getSingle();
    await _touchArmy(unit.armyId);
  }

  /// Change le détachement d'une armée déjà créée. Les enhancements
  /// sont propres à un détachement (voir [getEnhancementsForDetachment])
  /// : les choix déjà faits sur les unités deviennent invalides et sont
  /// réinitialisés. Retourne le nombre d'unités dont un enhancement a
  /// été retiré, pour que l'UI puisse en informer l'utilisateur.
  Future<int> setDetachment(String armyId, String? detachmentId) async {
    await (update(armies)..where((t) => t.id.equals(armyId))).write(
      ArmiesCompanion(
        detachmentId: Value(detachmentId),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final unitsWithEnhancement = await (select(armyUnits)
          ..where((t) =>
              t.armyId.equals(armyId) & t.enhancementId.isNotNull()))
        .get();
    if (unitsWithEnhancement.isNotEmpty) {
      await (update(armyUnits)..where((t) => t.armyId.equals(armyId))).write(
        const ArmyUnitsCompanion(enhancementId: Value(null)),
      );
    }
    return unitsWithEnhancement.length;
  }

  /// Désigne (ou retire, si `armyUnitId` est null) le Warlord de
  /// l'armée. Une seule unité peut l'être : les autres sont
  /// désélectionnées au passage.
  Future<void> setWarlord(String armyId, String? armyUnitId) async {
    await (update(armyUnits)..where((t) => t.armyId.equals(armyId))).write(
      const ArmyUnitsCompanion(isWarlord: Value(false)),
    );
    if (armyUnitId != null) {
      await (update(armyUnits)..where((t) => t.id.equals(armyUnitId))).write(
        const ArmyUnitsCompanion(isWarlord: Value(true)),
      );
    }
    await _touchArmy(armyId);
  }

  Future<void> updateNotes(String armyId, String? notes) {
    return (update(armies)..where((t) => t.id.equals(armyId))).write(
      ArmiesCompanion(
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<DetachmentOption>> getDetachmentsForFaction(
    String factionId,
  ) async {
    final rows = await (select(detachments)
          ..where((t) => t.factionId.equals(factionId)))
        .get();
    return rows
        .map((d) => DetachmentOption(
              id: d.id,
              name: d.name,
              description: d.description,
            ))
        .toList();
  }

  Future<List<EnhancementOption>> getEnhancementsForDetachment(
    String detachmentId,
  ) async {
    final rows = await (select(enhancements)
          ..where((t) => t.detachmentId.equals(detachmentId)))
        .get();
    return rows
        .map((e) => EnhancementOption(
              id: e.id,
              name: e.name,
              points: e.points,
              description: e.description,
            ))
        .toList();
  }

  Future<List<StratagemOption>> getStratagemsForDetachment(
    String detachmentId,
  ) async {
    final rows = await (select(stratagems)
          ..where((t) => t.detachmentId.equals(detachmentId))
          ..orderBy([(t) => OrderingTerm.asc(t.commandPoints)]))
        .get();
    return rows
        .map((s) => StratagemOption(
              id: s.id,
              name: s.name,
              commandPoints: s.commandPoints,
              phase: s.phase,
              description: s.description,
            ))
        .toList();
  }

  Future<List<ArmyListItem>> listArmies() async {
    final query = select(armies).join([
      innerJoin(factions, factions.id.equalsExp(armies.factionId)),
    ])
      ..orderBy([OrderingTerm.desc(armies.updatedAt)]);

    final rows = await query.get();
    final result = <ArmyListItem>[];
    for (final row in rows) {
      final army = row.readTable(armies);
      final faction = row.readTable(factions);
      result.add(ArmyListItem(
        id: army.id,
        name: army.name,
        factionId: faction.id,
        factionName: faction.name,
        totalPoints: await _totalPoints(army.id),
        pointsLimit: army.pointsLimit,
        updatedAt: army.updatedAt,
      ));
    }
    return result;
  }

  Future<ArmyDetails?> getArmy(String armyId) async {
    final headerQuery = select(armies).join([
      innerJoin(factions, factions.id.equalsExp(armies.factionId)),
      leftOuterJoin(
        detachments,
        detachments.id.equalsExp(armies.detachmentId),
      ),
    ])
      ..where(armies.id.equals(armyId));

    final headerRow = await headerQuery.getSingleOrNull();
    if (headerRow == null) return null;

    final army = headerRow.readTable(armies);
    final faction = headerRow.readTable(factions);
    final detachment = headerRow.readTableOrNull(detachments);

    final unitsQuery = select(armyUnits).join([
      innerJoin(datasheets, datasheets.id.equalsExp(armyUnits.datasheetId)),
      leftOuterJoin(
        unitSizes,
        unitSizes.datasheetId.equalsExp(armyUnits.datasheetId),
      ),
      leftOuterJoin(
        enhancements,
        enhancements.id.equalsExp(armyUnits.enhancementId),
      ),
    ])
      ..where(armyUnits.armyId.equals(armyId))
      ..orderBy([OrderingTerm.asc(armyUnits.displayOrder)]);

    final unitRows = await unitsQuery.get();
    final datasheetIds =
        unitRows.map((row) => row.readTable(armyUnits).datasheetId).toSet();
    final costsByDatasheet =
        await _getCostBracketsByDatasheet(datasheetIds.toList());

    final units = <ArmyUnitDetails>[];
    var totalPoints = 0;
    for (final row in unitRows) {
      final unit = row.readTable(armyUnits);
      final datasheet = row.readTable(datasheets);
      final size = row.readTableOrNull(unitSizes);
      final enhancement = row.readTableOrNull(enhancements);
      final brackets = costsByDatasheet[unit.datasheetId] ?? const [];
      final datasheetPoints =
          resolveCostForModelCount(brackets, unit.modelCount);
      final enhancementPoints = enhancement?.points ?? 0;
      totalPoints += datasheetPoints + enhancementPoints;
      units.add(ArmyUnitDetails(
        id: unit.id,
        datasheetId: datasheet.id,
        datasheetName: datasheet.name,
        battlefieldRole: datasheet.battlefieldRole,
        modelCount: unit.modelCount,
        minimumModels: size?.minimumModels ?? unit.modelCount,
        maximumModels: size?.maximumModels ?? unit.modelCount,
        datasheetPoints: datasheetPoints,
        enhancementId: enhancement?.id,
        enhancementName: enhancement?.name,
        enhancementPoints: enhancementPoints,
        isWarlord: unit.isWarlord,
      ));
    }

    return ArmyDetails(
      id: army.id,
      name: army.name,
      factionId: faction.id,
      factionName: faction.name,
      detachmentId: detachment?.id,
      detachmentName: detachment?.name,
      notes: army.notes,
      units: units,
      totalPoints: totalPoints,
      pointsLimit: army.pointsLimit,
    );
  }

  Future<int> _totalPoints(String armyId) async {
    final query = select(armyUnits).join([
      leftOuterJoin(
        enhancements,
        enhancements.id.equalsExp(armyUnits.enhancementId),
      ),
    ])
      ..where(armyUnits.armyId.equals(armyId));

    final rows = await query.get();
    final datasheetIds =
        rows.map((row) => row.readTable(armyUnits).datasheetId).toSet();
    final costsByDatasheet =
        await _getCostBracketsByDatasheet(datasheetIds.toList());

    var total = 0;
    for (final row in rows) {
      final unit = row.readTable(armyUnits);
      final brackets = costsByDatasheet[unit.datasheetId] ?? const [];
      total += resolveCostForModelCount(brackets, unit.modelCount);
      final enhancement = row.readTableOrNull(enhancements);
      total += enhancement?.points ?? 0;
    }
    return total;
  }

  /// Récupère les paliers de coût (voir [CostBracket]) de plusieurs
  /// datasheets en une passe, groupés par datasheetId, pour éviter de
  /// faire fanner-out une jointure directe sur `datasheetCosts` (une
  /// datasheet à plusieurs paliers a plusieurs lignes de coût, ce qui
  /// compterait les points en double si on la joignait naïvement).
  Future<Map<String, List<CostBracket>>> _getCostBracketsByDatasheet(
    List<String> datasheetIds,
  ) async {
    if (datasheetIds.isEmpty) return {};

    final query = select(datasheetCosts).join([
      innerJoin(editions, editions.id.equalsExp(datasheetCosts.editionId)),
    ])
      ..where(datasheetCosts.datasheetId.isIn(datasheetIds) &
          editions.isCurrent.equals(true));

    final rows = await query.get();
    final result = <String, List<CostBracket>>{};
    for (final row in rows) {
      final cost = row.readTable(datasheetCosts);
      result.putIfAbsent(cost.datasheetId, () => []).add(
            CostBracket(modelCount: cost.modelCount, points: cost.points),
          );
    }

    // Repli tolérant (mêmes règles que DatasheetDao) pour les datasheets
    // dont le coût n'est pas rattaché à l'édition courante.
    final missingIds =
        datasheetIds.where((id) => !result.containsKey(id)).toList();
    for (final id in missingIds) {
      final fallbackRows = await (select(datasheetCosts)
            ..where((t) => t.datasheetId.equals(id)))
          .get();
      if (fallbackRows.isEmpty) continue;
      final editionId = fallbackRows.first.editionId;
      result[id] = fallbackRows
          .where((row) => row.editionId == editionId)
          .map((row) =>
              CostBracket(modelCount: row.modelCount, points: row.points))
          .toList();
    }

    return result;
  }
}
