import 'package:drift/drift.dart';

class EquipmentChoices extends Table {
  TextColumn get id => text()();

  TextColumn get groupId => text()();

  IntColumn get minimumChoices =>
      integer().withDefault(const Constant(1))();

  IntColumn get maximumChoices =>
      integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}