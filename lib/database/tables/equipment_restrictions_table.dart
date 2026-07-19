import 'package:drift/drift.dart';

class EquipmentRestrictions extends Table {
  TextColumn get id => text()();

  TextColumn get optionId => text()();

  TextColumn get restrictionType => text()();

  IntColumn get value =>
      integer().nullable()();

  TextColumn get description =>
      text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}