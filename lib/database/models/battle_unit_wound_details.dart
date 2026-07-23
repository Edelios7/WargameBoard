class BattleUnitWoundDetails {
  final String armyUnitId;
  final int modelIndex;
  final int currentWounds;

  const BattleUnitWoundDetails({
    required this.armyUnitId,
    required this.modelIndex,
    required this.currentWounds,
  });
}
