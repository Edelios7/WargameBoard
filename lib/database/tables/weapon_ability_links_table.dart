import 'package:drift/drift.dart';

class WeaponAbilityLinks extends Table {
  TextColumn get id => text()();

  TextColumn get weaponId => text()();

  TextColumn get abilityId => text()();

  @override
  Set<Column> get primaryKey => {id};
}