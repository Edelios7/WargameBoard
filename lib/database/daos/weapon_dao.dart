import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/weapon_summary.dart';
import '../tables/datasheet_weapons_table.dart';
import '../tables/weapons_table.dart';
import '../tables/weapon_profiles_table.dart';

part 'weapon_dao.g.dart';

@DriftAccessor(
  tables: [
    Weapons,
    WeaponProfiles,
    DatasheetWeapons,
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

  /// Inventaire complet des armes du catalogue avec leurs profils et leur
  /// nombre d'utilisations (nombre de fiches/modèles qui les embarquent).
  /// Fait 3 requêtes en tout (pas de N+1) puis assemble en mémoire.
  Future<List<WeaponSummary>> listWeaponsWithUsage() async {
    final allWeapons = await select(weapons).get();
    final allProfiles = await select(weaponProfiles).get();

    final usageQuery = selectOnly(datasheetWeapons)
      ..addColumns([datasheetWeapons.weaponId, datasheetWeapons.id.count()])
      ..groupBy([datasheetWeapons.weaponId]);
    final usageRows = await usageQuery.get();

    final profilesByWeapon = <String, List<WeaponProfile>>{};
    for (final profile in allProfiles) {
      profilesByWeapon.putIfAbsent(profile.weaponId, () => []).add(profile);
    }

    final usageByWeapon = <String, int>{
      for (final row in usageRows)
        row.read(datasheetWeapons.weaponId)!:
            row.read(datasheetWeapons.id.count())!,
    };

    final summaries = allWeapons.map((weapon) {
      final profiles = profilesByWeapon[weapon.id] ?? const <WeaponProfile>[];
      return WeaponSummary(
        id: weapon.id,
        name: weapon.name,
        isMelee: weapon.isMelee,
        isRanged: weapon.isRanged,
        usedByCount: usageByWeapon[weapon.id] ?? 0,
        profiles: profiles
            .map((p) => WeaponProfileSummary(
                  name: p.name,
                  range: p.range,
                  attacks: p.attacks,
                  ballisticSkill: p.ballisticSkill,
                  weaponSkill: p.weaponSkill,
                  strength: p.strength,
                  armorPenetration: p.armorPenetration,
                  damage: p.damage,
                ))
            .toList(),
      );
    }).toList();

    summaries.sort((a, b) => a.name.compareTo(b.name));
    return summaries;
  }
}
