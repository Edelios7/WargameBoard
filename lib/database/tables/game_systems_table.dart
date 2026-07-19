import 'package:drift/drift.dart';

class GameSystems extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get shortName => text().nullable()();

  TextColumn get description => text().nullable()();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}