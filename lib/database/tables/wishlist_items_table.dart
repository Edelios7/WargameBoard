import 'package:drift/drift.dart';

import 'datasheets_table.dart';

class WishlistItems extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text().references(Datasheets, #id)();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
