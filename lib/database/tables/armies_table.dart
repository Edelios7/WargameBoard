import 'package:drift/drift.dart';

import 'factions_table.dart';

class Armies extends Table {
  TextColumn get id => text()();

  TextColumn get factionId => text().references(Factions, #id)();

  TextColumn get name => text()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
