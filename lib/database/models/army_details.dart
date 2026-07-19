class ArmyListItem {
  final String id;
  final String name;
  final String factionId;
  final String factionName;
  final int totalPoints;
  final int? pointsLimit;

  const ArmyListItem({
    required this.id,
    required this.name,
    required this.factionId,
    required this.factionName,
    required this.totalPoints,
    this.pointsLimit,
  });

  bool get isOverLimit => pointsLimit != null && totalPoints > pointsLimit!;
}

class ArmyUnitDetails {
  final String id;
  final String datasheetId;
  final String datasheetName;
  final int modelCount;
  final int minimumModels;
  final int maximumModels;
  final int datasheetPoints;
  final String? enhancementId;
  final String? enhancementName;
  final int enhancementPoints;

  const ArmyUnitDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    required this.modelCount,
    required this.minimumModels,
    required this.maximumModels,
    required this.datasheetPoints,
    this.enhancementId,
    this.enhancementName,
    this.enhancementPoints = 0,
  });

  int get points => datasheetPoints + enhancementPoints;
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
