import '../tables/battles_table.dart';

class BattleEventDetails {
  final String id;
  final String battleId;
  final int? round;
  final BattlePhase? phase;
  final String label;
  final int? cpDelta;
  final DateTime createdAt;

  const BattleEventDetails({
    required this.id,
    required this.battleId,
    this.round,
    this.phase,
    required this.label,
    this.cpDelta,
    required this.createdAt,
  });
}
