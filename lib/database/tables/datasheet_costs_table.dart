import 'package:drift/drift.dart';

class DatasheetCosts extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get editionId => text()();

  IntColumn get points => integer()();

  IntColumn get powerLevel =>
      integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}