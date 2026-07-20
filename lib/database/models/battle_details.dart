import '../tables/battles_table.dart';

class BattleDetails {
  final String id;
  final String? armyId;
  final String? armyName;
  final String? opponentName;
  final String? opponentFactionId;
  final String? opponentFactionName;
  final String? location;
  final String? missionName;
  final BattleResult? result;
  final BattleType type;
  final int? myScore;
  final int? opponentScore;
  final String? notes;
  final DateTime playedAt;

  const BattleDetails({
    required this.id,
    this.armyId,
    this.armyName,
    this.opponentName,
    this.opponentFactionId,
    this.opponentFactionName,
    this.location,
    this.missionName,
    this.result,
    this.type = BattleType.matched,
    this.myScore,
    this.opponentScore,
    this.notes,
    required this.playedAt,
  });

  bool get isUpcoming =>
      result == null && playedAt.isAfter(DateTime.now());
}
