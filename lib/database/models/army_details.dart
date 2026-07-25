class ArmyListItem {
  final String id;
  final String name;
  final String factionId;
  final String factionName;
  final int totalPoints;
  final int? pointsLimit;
  final int enhancementsCount;

  /// `true` si au moins une unité de cette armée n'a aucune donnée de
  /// coût connue dans le catalogue — [totalPoints] est alors une
  /// sous-estimation (ces unités comptent pour 0 dans le total), pas
  /// une valeur fiable pour juger du respect de [pointsLimit].
  final bool hasUnknownCost;
  final DateTime updatedAt;

  const ArmyListItem({
    required this.id,
    required this.name,
    required this.factionId,
    required this.factionName,
    required this.totalPoints,
    this.pointsLimit,
    this.enhancementsCount = 0,
    this.hasUnknownCost = false,
    required this.updatedAt,
  });

  bool get isOverLimit => pointsLimit != null && totalPoints > pointsLimit!;

  /// `true` si l'armée enfreint une règle de composition bloquante — pas
  /// seulement le dépassement de points, aussi la limite de 3
  /// enhancements par liste (même seuil que
  /// `ArmyValidationService.maxEnhancements`, dupliqué ici pour éviter
  /// une dépendance de ce modèle de données vers la couche service).
  bool get hasValidationErrors => isOverLimit || enhancementsCount > 3;
}

class ArmyUnitDetails {
  final String id;
  final String datasheetId;
  final String datasheetName;
  final String battlefieldRole;
  final int modelCount;
  final int minimumModels;
  final int maximumModels;

  /// `null` si cette datasheet n'a aucune donnée de coût dans le
  /// catalogue — voir [resolveCostForModelCount] (`cost_bracket.dart`).
  /// Ne compte alors pour 0 que dans [points]/le total de l'armée par
  /// nécessité arithmétique ; [hasUnknownCost] permet à l'affichage de
  /// distinguer ce cas d'une unité qui coûte réellement 0 pt.
  final int? datasheetPoints;
  final String? enhancementId;
  final String? enhancementName;
  final int enhancementPoints;

  /// Choix d'armes optionnelles actuels, un libellé par groupe
  /// d'équipement de la datasheet (ex. "Arme spéciale : Lance-flammes")
  /// — vide si la datasheet n'a pas de groupe d'équipement optionnel.
  final List<String> equipmentChoices;

  /// Une seule unité par armée peut être le Warlord — concept
  /// obligatoire des règles de tournoi 10e/11e édition.
  final bool isWarlord;

  const ArmyUnitDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    this.battlefieldRole = '',
    required this.modelCount,
    required this.minimumModels,
    required this.maximumModels,
    required this.datasheetPoints,
    this.enhancementId,
    this.enhancementName,
    this.enhancementPoints = 0,
    this.equipmentChoices = const [],
    this.isWarlord = false,
  });

  bool get hasUnknownCost => datasheetPoints == null;

  int get points => (datasheetPoints ?? 0) + enhancementPoints;
}

class ArmyDetails {
  final String id;
  final String name;
  final String factionId;
  final String factionName;
  final String? detachmentId;
  final String? detachmentName;
  final String? notes;
  final List<ArmyUnitDetails> units;
  final int totalPoints;
  final int? pointsLimit;

  const ArmyDetails({
    required this.id,
    required this.name,
    required this.factionId,
    required this.factionName,
    this.detachmentId,
    this.detachmentName,
    this.notes,
    required this.units,
    required this.totalPoints,
    this.pointsLimit,
  });

  bool get isOverLimit => pointsLimit != null && totalPoints > pointsLimit!;

  /// `true` si au moins une unité n'a aucune donnée de coût connue —
  /// [totalPoints] est alors une sous-estimation (ces unités comptent
  /// pour 0), pas un total fiable.
  bool get hasUnitsWithUnknownCost => units.any((u) => u.hasUnknownCost);
}

class DetachmentOption {
  final String id;
  final String name;
  final String? description;

  const DetachmentOption({
    required this.id,
    required this.name,
    this.description,
  });
}

class EnhancementOption {
  final String id;
  final String name;
  final int points;
  final String? description;

  const EnhancementOption({
    required this.id,
    required this.name,
    required this.points,
    this.description,
  });
}

class StratagemOption {
  final String id;
  final String name;
  final int commandPoints;
  final String? phase;
  final String? description;

  const StratagemOption({
    required this.id,
    required this.name,
    required this.commandPoints,
    this.phase,
    this.description,
  });
}
