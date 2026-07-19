import '../tables/battles_table.dart';

class BattleDetails {
  final String id;
  final String? armyId;
  final String? armyName;
  final String? opponentName;
  final String? missionName;
  final BattleResult? result;
  final int? myScore;
  final int? opponentScore;
  final String? notes;
  final DateTime playedAt;

  const BattleDetails({
    required this.id,
    this.armyId,
    this.armyName,
    this.opponentName,
    this.missionName,
    this.result,
    this.myScore,
    this.opponentScore,
    this.notes,
    required this.playedAt,
  });
}
