import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/army_details.dart';
import '../tables/armies_table.dart';
import '../tables/army_units_table.dart';
import '../tables/datasheet_costs_table.dart';
import '../tables/datasheets_table.dart';
import '../tables/editions_table.dart';
import '../tables/factions_table.dart';

part 'army_dao.g.dart';

@DriftAccessor(
  tables: [
    Armies,
    ArmyUnits,
    Factions,
    Datasheets,
    DatasheetCosts,
    Editions,
  ],
)
class ArmyDao extends DatabaseAccessor<AppDatabase> with _$ArmyDaoMixin {
  ArmyDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<String> createArmy({
    required String name,
    required String factionId,
  }) async {
    final id = _uuid.v4();
    await into(armies).insert(
      ArmiesCompanion.insert(id: id, factionId: factionId, name: name),
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
      ));
    }
    return result;
  }

  Future<ArmyDetails?> getArmy(String armyId) async {
    final headerQuery = select(armies).join([
      innerJoin(factions, factions.id.equalsExp(armies.factionId)),
    ])
      ..where(armies.id.equals(armyId));

    final headerRow = await headerQuery.getSingleOrNull();
    if (headerRow == null) return null;

    final army = headerRow.readTable(armies);
    final faction = headerRow.readTable(factions);

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
      final points = cost?.points ?? 0;
      totalPoints += points;
      units.add(ArmyUnitDetails(
        id: unit.id,
        datasheetId: datasheet.id,
        datasheetName: datasheet.name,
        modelCount: unit.modelCount,
        points: points,
      ));
    }

    return ArmyDetails(
      id: army.id,
      name: army.name,
      factionId: faction.id,
      factionName: faction.name,
      notes: army.notes,
      units: units,
      totalPoints: totalPoints,
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
    ])
      ..where(armyUnits.armyId.equals(armyId));

    final rows = await query.get();
    var total = 0;
    for (final row in rows) {
      total += row.readTable(datasheetCosts).points;
    }
    return total;
  }
}
