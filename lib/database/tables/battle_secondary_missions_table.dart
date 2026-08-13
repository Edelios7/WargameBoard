import 'package:drift/drift.dart';

import 'battles_table.dart';
import 'secondary_missions_table.dart';

enum BattleSecondarySide { mine, opponent }

/// Mission secondaire choisie pour une bataille suivie, par camp (chacun
/// en choisit généralement 2 en Tactique, ou jusqu'à 2 Fixes).
class BattleSecondaryMissionSelections extends Table {
  TextColumn get id => text()();

  TextColumn get battleId => text().references(Battles, #id)();

  TextColumn get secondaryMissionId =>
      text().references(SecondaryMissions, #id)();

  TextColumn get side => textEnum<BattleSecondarySide>()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
