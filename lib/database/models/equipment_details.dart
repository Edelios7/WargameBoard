class EquipmentDetails {
  final String groupName;

  final List<String> options;

  const EquipmentDetails({
    required this.groupName,
    required this.options,
  });
}

/// Une option d'un groupe d'équipement optionnel, éventuellement liée à
/// une arme réelle (`weaponId`) qu'on peut alors substituer dans la
/// liste d'armes effective d'une unité d'armée.
class EquipmentOptionDetails {
  final String id;

  final String name;

  final String? weaponId;

  final bool isDefault;

  const EquipmentOptionDetails({
    required this.id,
    required this.name,
    this.weaponId,
    this.isDefault = false,
  });
}

/// Un groupe d'équipement au sens règles (ex. "Arme spéciale") : un
/// choix à faire parmi [options], borné par [minimumChoices]/
/// [maximumChoices] (le plus souvent 1/1 — remplacement simple).
class EquipmentGroupDetails {
  final String id;

  final String name;

  final int minimumChoices;

  final int maximumChoices;

  final List<EquipmentOptionDetails> options;

  const EquipmentGroupDetails({
    required this.id,
    required this.name,
    required this.minimumChoices,
    required this.maximumChoices,
    required this.options,
  });
}