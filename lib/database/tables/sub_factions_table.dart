import 'package:drift/drift.dart';

import 'factions_table.dart';

class SubFactions extends Table {
  TextColumn get id => text()();

  TextColumn get factionId =>
      text().references(Factions, #id)();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  TextColumn get iconPath => text().nullable()();

  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isPlayable =>
      boolean().withDefault(const Constant(true))();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}