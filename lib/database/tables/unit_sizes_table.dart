import 'package:drift/drift.dart';

import 'datasheets_table.dart';

class UnitSizes extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId =>
      text().references(Datasheets, #id)();

  IntColumn get minimumModels => integer()();

  IntColumn get maximumModels => integer()();

  IntColumn get defaultModels => integer()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}