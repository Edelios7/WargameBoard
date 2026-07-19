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
  final int points;

  const ArmyUnitDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    required this.modelCount,
    required this.minimumModels,
    required this.maximumModels,
    required this.points,
  });
}

class ArmyDetails {
  final String id;
  final String name;
  final String factionId;
  final String factionName;
  final String? notes;
  final List<ArmyUnitDetails> units;
  final int totalPoints;
  final int? pointsLimit;

  const ArmyDetails({
    required this.id,
    required this.name,
    required this.factionId,
    required this.factionName,
    this.notes,
    required this.units,
    required this.totalPoints,
    this.pointsLimit,
  });

  bool get isOverLimit => pointsLimit != null && totalPoints > pointsLimit!;
}
