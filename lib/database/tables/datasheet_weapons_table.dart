import 'package:drift/drift.dart';

class DatasheetWeapons extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetModelId => text()();

  TextColumn get weaponId => text()();

  IntColumn get quantity =>
      integer().withDefault(const Constant(1))();

  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}