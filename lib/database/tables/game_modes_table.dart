import 'package:drift/drift.dart';

import 'editions_table.dart';

class GameModes extends Table {
  TextColumn get id => text()();

  TextColumn get editionId =>
      text().references(Editions, #id)();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}