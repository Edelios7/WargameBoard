import '../tables/battle_secondary_missions_table.dart';

class BattleSecondaryMissionDetails {
  final String id;
  final String secondaryMissionId;
  final String name;
  final bool isFixed;
  final String effect;
  final BattleSecondarySide side;

  const BattleSecondaryMissionDetails({
    required this.id,
    required this.secondaryMissionId,
    required this.name,
    required this.isFixed,
    required this.effect,
    required this.side,
  });
}
