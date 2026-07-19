import 'package:drift/drift.dart';

class DatasheetVersions extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get version =>
      text()();

  TextColumn get description =>
      text().nullable()();

  BoolColumn get isCurrent =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}