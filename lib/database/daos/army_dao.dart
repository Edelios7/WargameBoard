import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/army_details.dart';
import '../tables/armies_table.dart';
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
    return id;
  }

  Future<void> removeUnit(String armyUnitId) {
    return (delete(armyUnits)..where((t) => t.id.equals(armyUnitId))).go();
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

    return clamped;
  }

  /// Attache (ou retire, si `enhancementId` est null) un enhancement à
  /// une unité.
  Future<void> setUnitEnhancement(
    String armyUnitId,
    String? enhancementId,
  ) {
    return (update(armyUnits)..where((t) => t.id.equals(armyUnitId))).write(
      ArmyUnitsCompanion(enhancementId: Value(enhancementId)),
    );
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
      ..orderBy([OrderingTerm.asc(armies.name)]);

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
        datasheetCosts,
        datasheetCosts.datasheetId.equalsExp(armyUnits.datasheetId),
      ),
      leftOuterJoin(
        editions,
        editions.id.equalsExp(datasheetCosts.editionId) &
            editions.isCurrent.equals(true),
      ),
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
    final units = <ArmyUnitDetails>[];
    var totalPoints = 0;
    for (final row in unitRows) {
      final unit = row.readTable(armyUnits);
      final datasheet = row.readTable(datasheets);
      final cost = row.readTableOrNull(datasheetCosts);
      final size = row.readTableOrNull(unitSizes);
      final enhancement = row.readTableOrNull(enhancements);
      final datasheetPoints = cost?.points ?? 0;
      final enhancementPoints = enhancement?.points ?? 0;
      totalPoints += datasheetPoints + enhancementPoints;
      units.add(ArmyUnitDetails(
        id: unit.id,
        datasheetId: datasheet.id,
        datasheetName: datasheet.name,
        modelCount: unit.modelCount,
        minimumModels: size?.minimumModels ?? unit.modelCount,
        maximumModels: size?.maximumModels ?? unit.modelCount,
        datasheetPoints: datasheetPoints,
        enhancementId: enhancement?.id,
        enhancementName: enhancement?.name,
        enhancementPoints: enhancementPoints,
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
      innerJoin(
        datasheetCosts,
        datasheetCosts.datasheetId.equalsExp(armyUnits.datasheetId),
      ),
      innerJoin(
        editions,
        editions.id.equalsExp(datasheetCosts.editionId) &
            editions.isCurrent.equals(true),
      ),
      leftOuterJoin(
        enhancements,
        enhancements.id.equalsExp(armyUnits.enhancementId),
      ),
    ])
      ..where(armyUnits.armyId.equals(armyId));

    final rows = await query.get();
    var total = 0;
    for (final row in rows) {
      total += row.readTable(datasheetCosts).points;
      final enhancement = row.readTableOrNull(enhancements);
      total += enhancement?.points ?? 0;
    }
    return total;
  }
}
