import 'package:drift/drift.dart';

class Weapons extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get description =>
      text().nullable()();

  BoolColumn get isMelee =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isRanged =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}