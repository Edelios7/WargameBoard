import 'package:drift/drift.dart';

import 'game_systems_table.dart';

class Factions extends Table {
  TextColumn get id => text()();

  TextColumn get gameSystemId =>
      text().references(GameSystems, #id)();

  TextColumn get name => text()();

  TextColumn get shortName => text().nullable()();

  TextColumn get description => text().nullable()();

  TextColumn get iconPath => text().nullable()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  BoolColumn get isPlayable =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}