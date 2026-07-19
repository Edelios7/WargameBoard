import 'package:drift/drift.dart';

import 'armies_table.dart';

enum BattleResult { victory, defeat, draw }

class Battles extends Table {
  TextColumn get id => text()();

  TextColumn get armyId => text().nullable().references(Armies, #id)();

  TextColumn get opponentName => text().nullable()();

  TextColumn get missionName => text().nullable()();

  TextColumn get result =>
      textEnum<BattleResult>().nullable()();

  IntColumn get myScore => integer().nullable()();

  IntColumn get opponentScore => integer().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get playedAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
