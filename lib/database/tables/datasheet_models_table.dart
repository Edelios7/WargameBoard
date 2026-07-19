import 'package:drift/drift.dart';

import 'datasheets_table.dart';

class DatasheetModels extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId =>
      text().references(Datasheets, #id)();

  TextColumn get name => text()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  BoolColumn get isLeader =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isChampion =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}