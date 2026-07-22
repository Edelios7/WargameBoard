import 'package:drift/drift.dart';

import 'army_units_table.dart';
import 'battles_table.dart';

/// Caractéristique visée par un [BattleUnitModifiers] — les mêmes que
/// celles affichées sur une fiche (voir `ModelDetails`).
enum BattleStatKey {
  movement,
  toughness,
  save,
  wounds,
  leadership,
  objectiveControl,
}

/// Bonus/malus appliqué en direct à une unité pendant une partie (ex.
/// "+1 Endurance (Rite de guerre)") — purement additif sur la valeur
/// affichée, ne modifie jamais la fiche catalogue elle-même.
class BattleUnitModifiers extends Table {
  TextColumn get id => text()();

  TextColumn get battleId => text().references(Battles, #id)();

  TextColumn get armyUnitId => text().references(ArmyUnits, #id)();

  TextColumn get statKey => textEnum<BattleStatKey>()();

  IntColumn get delta => integer()();

  TextColumn get label => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
