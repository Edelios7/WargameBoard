import 'package:drift/drift.dart';

class DatasheetSources extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get sourceName =>
      text()();

  TextColumn get sourceType =>
      text()();

  TextColumn get page =>
      text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}