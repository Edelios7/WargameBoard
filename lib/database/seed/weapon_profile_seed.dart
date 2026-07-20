import 'package:drift/drift.dart';

import '../app_database.dart';
import 'datasheet_seed.dart';
import 'orks_seed.dart';

/// Profils de tir/corps à corps des armes seedées.
///
/// Comme le reste du seed, valeurs plausibles 10e édition à vérifier
/// contre une source officielle. Convention : range 0 = arme de mêlée
/// (le profil utilise alors weaponSkill au lieu de ballisticSkill).
Future<void> seedWeaponProfiles(AppDatabase db) async {
  final profiles = <({
    String weaponId,
    int range,
    String attacks,
    int? bs,
    int? ws,
    int strength,
    int ap,
    String damage,
  })>[
    // ===== Blood Angels =====
    (
      weaponId: wpMasterCraftedPowerWeapon,
      range: 0,
      attacks: '6',
      bs: null,
      ws: 2,
      strength: 5,
      ap: -2,
      damage: '2',
    ),
    (
      weaponId: wpPlasmaPistol,
      range: 12,
      attacks: '1',
      bs: 2,
      ws: null,
      strength: 7,
      ap: -2,
      damage: '1',
    ),
    (
      weaponId: wpAstartesChainsword,
      range: 0,
      attacks: '4',
      bs: null,
      ws: 3,
      strength: 4,
      ap: -1,
      damage: '1',
    ),
    (
      weaponId: wpBoltPistol,
      range: 12,
      attacks: '1',
      bs: 3,
      ws: null,
      strength: 4,
      ap: 0,
      damage: '1',
    ),
    (
      weaponId: wpGlaiveEncarmine,
      range: 0,
      attacks: '4',
      bs: null,
      ws: 2,
      strength: 6,
      ap: -2,
      damage: '2',
    ),
    (
      weaponId: wpAngelusBoltgun,
      range: 18,
      attacks: '2',
      bs: 3,
      ws: null,
      strength: 4,
      ap: -1,
      damage: '1',
    ),
    // ===== Orks =====
    (
      weaponId: wpChoppa,
      range: 0,
      attacks: '3',
      bs: null,
      ws: 3,
      strength: 4,
      ap: -1,
      damage: '1',
    ),
    (
      weaponId: wpSlugga,
      range: 12,
      attacks: '1',
      bs: 5,
      ws: null,
      strength: 4,
      ap: 0,
      damage: '1',
    ),
    (
      weaponId: wpBigShoota,
      range: 36,
      attacks: '3',
      bs: 5,
      ws: null,
      strength: 5,
      ap: 0,
      damage: '1',
    ),
    (
      weaponId: wpPowerKlaw,
      range: 0,
      attacks: '4',
      bs: null,
      ws: 4,
      strength: 9,
      ap: -2,
      damage: '2',
    ),
  ];

  for (final profile in profiles) {
    await db.into(db.weaponProfiles).insert(
          WeaponProfilesCompanion.insert(
            id: 'wpp-${profile.weaponId}',
            weaponId: profile.weaponId,
            name: 'Standard',
            range: profile.range,
            attacks: profile.attacks,
            ballisticSkill: Value(profile.bs),
            weaponSkill: Value(profile.ws),
            strength: profile.strength,
            armorPenetration: profile.ap,
            damage: profile.damage,
          ),
        );
  }
}
