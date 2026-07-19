import 'package:drift/drift.dart';

class EquipmentGroups extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get name => text()();

  TextColumn get description => text().nullable()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}