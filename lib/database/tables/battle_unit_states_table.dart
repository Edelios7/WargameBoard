import 'package:drift/drift.dart';

import 'army_units_table.dart';
import 'battles_table.dart';

/// État en direct d'une unité d'armée pour une partie donnée. Une ligne
/// n'existe que si l'unité a été touchée (marquée détruite) — son absence
/// vaut "vivante, par défaut" pour éviter de pré-créer une ligne par
/// unité à chaque démarrage de partie.
class BattleUnitStates extends Table {
  TextColumn get id => text()();

  TextColumn get battleId => text().references(Battles, #id)();

  TextColumn get armyUnitId => text().references(ArmyUnits, #id)();

  BoolColumn get destroyed =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
