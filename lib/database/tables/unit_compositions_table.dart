import 'package:drift/drift.dart';

class UnitCompositions extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get modelId => text()();

  IntColumn get minimum => integer()();

  IntColumn get maximum => integer()();

  BoolColumn get isLeader =>
      boolean().withDefault(const Constant(false))();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}