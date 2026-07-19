import 'package:drift/drift.dart';

import 'datasheets_table.dart';

class OwnedMiniatures extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text().references(Datasheets, #id)();

  IntColumn get quantity => integer()();

  IntColumn get assembled => integer().withDefault(const Constant(0))();

  IntColumn get primed => integer().withDefault(const Constant(0))();

  IntColumn get painted => integer().withDefault(const Constant(0))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get purchaseDate => dateTime().nullable()();

  RealColumn get purchasePrice => real().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
