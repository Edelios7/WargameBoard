class WeaponProfileSummary {
  final String name;
  final int range;
  final String attacks;
  final int? ballisticSkill;
  final int? weaponSkill;
  final int strength;
  final int armorPenetration;
  final String damage;

  const WeaponProfileSummary({
    required this.name,
    required this.range,
    required this.attacks,
    this.ballisticSkill,
    this.weaponSkill,
    required this.strength,
    required this.armorPenetration,
    required this.damage,
  });

  bool get isMelee => range == 0;
}

class WeaponSummary {
  final String id;
  final String name;
  final bool isMelee;
  final bool isRanged;
  final List<WeaponProfileSummary> profiles;
  final int usedByCount;

  const WeaponSummary({
    required this.id,
    required this.name,
    required this.isMelee,
    required this.isRanged,
    required this.profiles,
    required this.usedByCount,
  });

  bool get hasProfile => profiles.isNotEmpty;
}
