import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/weapons_table.dart';
import '../tables/weapon_profiles_table.dart';

part 'weapon_dao.g.dart';

@DriftAccessor(
  tables: [
    Weapons,
    WeaponProfiles,
  ],
)
class WeaponDao extends DatabaseAccessor<AppDatabase>
    with _$WeaponDaoMixin {
  WeaponDao(AppDatabase db) : super(db);

  Future<List<Weapon>> getAllWeapons() {
    return select(weapons).get();
  }

  Future<Weapon?> getWeapon(String id) {
    return (select(weapons)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<WeaponProfile>> getProfiles(String weaponId) {
    return (select(weaponProfiles)
          ..where((t) => t.weaponId.equals(weaponId)))
        .get();
  }

  Future<void> insertWeapon(
      WeaponsCompanion companion) async {
    await into(weapons).insert(companion);
  }

  Future<bool> updateWeapon(
      Weapon weapon) {
    return update(weapons).replace(weapon);
  }

  Future<int> deleteWeapon(String id) {
    return (delete(weapons)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}