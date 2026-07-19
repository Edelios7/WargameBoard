import 'package:drift/drift.dart';

import 'game_systems_table.dart';

class Editions extends Table {
  TextColumn get id => text()();

  TextColumn get gameSystemId =>
      text().references(GameSystems, #id)();

  TextColumn get name => text()();

  IntColumn get version => integer()();

  BoolColumn get isCurrent =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get releaseDate => dateTime().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}