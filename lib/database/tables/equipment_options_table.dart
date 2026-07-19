import 'package:drift/drift.dart';

class EquipmentOptions extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text()();

  TextColumn get weaponId => text().nullable()();

  TextColumn get name => text()();

  IntColumn get quantity =>
      integer().withDefault(const Constant(1))();

  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}