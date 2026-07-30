import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/weapon_summary.dart';
import '../tables/datasheet_models_table.dart';
import '../tables/datasheet_weapons_table.dart';
import '../tables/weapons_table.dart';
import '../tables/weapon_profiles_table.dart';

part 'weapon_dao.g.dart';

@DriftAccessor(
  tables: [
    Weapons,
    WeaponProfiles,
    DatasheetWeapons,
    DatasheetModels,
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
  /// nombre d'utilisations (nombre de FICHES distinctes qui l'embarquent —
  /// pas de N+1 : 3 requêtes en tout puis assemblage en mémoire).
  ///
  /// `DatasheetWeapons` relie une arme à un modèle (`datasheetModelId`),
  /// pas directement à une fiche : une escouade dont chaque figurine porte
  /// la même arme produit une ligne par modèle. Compter ces lignes
  /// surévaluerait donc l'usage dès qu'une fiche a plusieurs modèles avec
  /// la même arme — on passe par `DatasheetModels` pour dédupliquer sur
  /// `datasheetId`.
  Future<List<WeaponSummary>> listWeaponsWithUsage() async {
    final allWeapons = await select(weapons).get();
    final allProfiles = await select(weaponProfiles).get();

    final usageQuery = selectOnly(datasheetWeapons)
      ..addColumns([datasheetWeapons.weaponId, datasheetModels.datasheetId])
      ..join([
        innerJoin(
          datasheetModels,
          datasheetModels.id.equalsExp(datasheetWeapons.datasheetModelId),
        ),
      ]);
    final usageRows = await usageQuery.get();

    final profilesByWeapon = <String, List<WeaponProfile>>{};
    for (final profile in allProfiles) {
      profilesByWeapon.putIfAbsent(profile.weaponId, () => []).add(profile);
    }

    final datasheetIdsByWeapon = <String, Set<String>>{};
    for (final row in usageRows) {
      final weaponId = row.read(datasheetWeapons.weaponId)!;
      final datasheetId = row.read(datasheetModels.datasheetId)!;
      datasheetIdsByWeapon
          .putIfAbsent(weaponId, () => <String>{})
          .add(datasheetId);
    }
    final usageByWeapon = <String, int>{
      for (final entry in datasheetIdsByWeapon.entries)
        entry.key: entry.value.length,
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
