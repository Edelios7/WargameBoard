import '../tables/battle_unit_modifiers_table.dart';

class BattleUnitModifierDetails {
  final String id;
  final String armyUnitId;
  final BattleStatKey statKey;
  final int delta;
  final String? label;
  final DateTime createdAt;

  const BattleUnitModifierDetails({
    required this.id,
    required this.armyUnitId,
    required this.statKey,
    required this.delta,
    this.label,
    required this.createdAt,
  });
}
