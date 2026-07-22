import '../tables/battles_table.dart';

class BattleDetails {
  final String id;
  final String? armyId;
  final String? armyName;
  final String? opponentArmyId;
  final String? opponentArmyName;
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

  // Suivi de partie en direct — `null` pour les parties créées via l'ancien
  // flux rétroactif.
  final BattleStatus? status;
  final int? currentRound;
  final BattlePhase? currentPhase;
  final int? myCommandPoints;
  final int? opponentCommandPoints;
  final String? missionPack;
  final String? terrain;
  final int? pointsLimit;
  final bool? myTurnActive;

  const BattleDetails({
    required this.id,
    this.armyId,
    this.armyName,
    this.opponentArmyId,
    this.opponentArmyName,
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
    this.status,
    this.currentRound,
    this.currentPhase,
    this.myCommandPoints,
    this.opponentCommandPoints,
    this.missionPack,
    this.terrain,
    this.pointsLimit,
    this.myTurnActive,
  });

  bool get isUpcoming => result == null && playedAt.isAfter(DateTime.now());

  /// Vrai pour une partie en cours de suivi en direct (setup ou active) —
  /// `status == null` (ligne legacy) est toujours traité comme terminé.
  bool get isLive =>
      status == BattleStatus.setup || status == BattleStatus.active;
}
