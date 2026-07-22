import 'package:drift/drift.dart';

import 'battles_table.dart';

/// Journal d'une partie suivie en direct : sert à la fois d'historique de
/// dépense de command points (`cpDelta` non nul) et de journal d'actions
/// libre ("Captain détruit", "Objectif capturé"...).
class BattleEvents extends Table {
  TextColumn get id => text()();

  TextColumn get battleId => text().references(Battles, #id)();

  IntColumn get round => integer().nullable()();

  TextColumn get phase => textEnum<BattlePhase>().nullable()();

  TextColumn get label => text()();

  IntColumn get cpDelta => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
