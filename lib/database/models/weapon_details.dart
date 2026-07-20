class WeaponProfileDetails {
  final String name;
  final int range;
  final String attacks;
  final int? ballisticSkill;
  final int? weaponSkill;
  final int strength;
  final int armorPenetration;
  final String damage;

  const WeaponProfileDetails({
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

  /// Ligne compacte façon datasheet, ex. `12" A1 CT2+ F7 PA-2 D1`
  /// ou `Mêlée A6 CC2+ F5 PA-2 D2`.
  String get summary {
    final parts = <String>[
      isMelee ? 'Mêlée' : '$range"',
      'A$attacks',
      if (ballisticSkill != null) 'CT$ballisticSkill+',
      if (weaponSkill != null) 'CC$weaponSkill+',
      'F$strength',
      'PA$armorPenetration',
      'D$damage',
    ];
    return parts.join(' ');
  }
}

class WeaponDetails {
  final String id;

  final String name;

  final String type;

  final List<String> keywords;

  final List<String> abilities;

  final List<WeaponProfileDetails> profiles;

  const WeaponDetails({
    required this.id,
    required this.name,
    required this.type,
    required this.keywords,
    required this.abilities,
    this.profiles = const [],
  });
}
