import 'package:drift/drift.dart';

class WeaponProfiles extends Table {
  TextColumn get id => text()();

  TextColumn get weaponId => text()();

  TextColumn get name => text()();

  IntColumn get range => integer()();

  TextColumn get attacks => text()();

  IntColumn get ballisticSkill =>
      integer().nullable()();

  IntColumn get weaponSkill =>
      integer().nullable()();

  IntColumn get strength => integer()();

  IntColumn get armorPenetration => integer()();

  TextColumn get damage => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}