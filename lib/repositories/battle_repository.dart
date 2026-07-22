import 'package:drift/drift.dart' show Value;

import '../database/app_database.dart';
import '../database/models/battle_details.dart';
import '../database/models/battle_event_details.dart';
import '../database/models/battle_unit_modifier_details.dart';
import '../database/models/battle_unit_state_details.dart';
import '../database/tables/battle_unit_modifiers_table.dart';
import '../database/tables/battles_table.dart';
import '../services/xp_service.dart';

class BattleRepository {
  final AppDatabase database;
  final XpService xpService;

  BattleRepository(this.database, this.xpService);

  Future<List<BattleDetails>> listBattles() {
    return database.battleDao.listBattles();
  }

  Future<String> addBattle({
    String? armyId,
    String? opponentName,
    String? opponentFactionId,
    String? location,
    String? missionName,
    BattleResult? result,
    BattleType type = BattleType.matched,
    int? myScore,
    int? opponentScore,
    String? notes,
    DateTime? playedAt,
  }) async {
    final effectivePlayedAt = playedAt ?? DateTime.now();
    final id = await database.battleDao.addBattle(
      armyId: armyId,
      opponentName: opponentName,
      opponentFactionId: opponentFactionId,
      location: location,
      missionName: missionName,
      result: result,
      type: type,
      myScore: myScore,
      opponentScore: opponentScore,
      notes: notes,
      playedAt: playedAt,
    );

    await xpService.awardBattle(
      armyId: armyId,
      result: result,
      type: type,
      playedAt: effectivePlayedAt,
    );

    return id;
  }

  Future<void> deleteBattle(String id) {
    return database.battleDao.deleteBattle(id);
  }

  Future<BattleDetails?> getNextUpcoming() {
    return database.battleDao.getNextUpcoming();
  }

  Future<BattleDetails?> getLastPlayed() {
    return database.battleDao.getLastPlayed();
  }

  // =========================
  // Suivi de partie en direct
  // =========================

  Future<String> startBattle({
    String? armyId,
    String? opponentName,
    String? opponentFactionId,
    int? pointsLimit,
    String? missionName,
    String? missionPack,
    String? terrain,
    BattleType type = BattleType.matched,
  }) {
    return database.battleDao.startBattle(
      armyId: armyId,
      opponentName: opponentName,
      opponentFactionId: opponentFactionId,
      pointsLimit: pointsLimit,
      missionName: missionName,
      missionPack: missionPack,
      terrain: terrain,
      type: type,
    );
  }

  Future<BattleDetails?> getActiveBattle() {
    return database.battleDao.getActiveBattle();
  }

  Future<void> updateLiveState(
    String battleId, {
    Value<BattleStatus?> status = const Value.absent(),
    Value<int?> currentRound = const Value.absent(),
    Value<BattlePhase?> currentPhase = const Value.absent(),
    Value<int?> myCommandPoints = const Value.absent(),
    Value<int?> opponentCommandPoints = const Value.absent(),
    Value<int?> myScore = const Value.absent(),
    Value<int?> opponentScore = const Value.absent(),
    Value<bool?> myTurnActive = const Value.absent(),
  }) {
    return database.battleDao.updateLiveState(
      battleId,
      status: status,
      currentRound: currentRound,
      currentPhase: currentPhase,
      myCommandPoints: myCommandPoints,
      opponentCommandPoints: opponentCommandPoints,
      myScore: myScore,
      opponentScore: opponentScore,
      myTurnActive: myTurnActive,
    );
  }

  Future<void> advancePhase(String battleId) {
    return database.battleDao.advancePhase(battleId);
  }

  Future<void> logEvent(
    String battleId, {
    required String label,
    int? cpDelta,
    int? round,
    BattlePhase? phase,
  }) {
    return database.battleDao.logEvent(
      battleId,
      label: label,
      cpDelta: cpDelta,
      round: round,
      phase: phase,
    );
  }

  Future<List<BattleEventDetails>> getEvents(String battleId) {
    return database.battleDao.getEvents(battleId);
  }

  /// Finalise une partie suivie en direct et crédite l'XP correspondante
  /// (même règles que [addBattle], la partie n'existait juste pas encore
  /// en base au moment où elle a été jouée).
  Future<void> finishBattle(
    String battleId, {
    String? armyId,
    BattleResult? result,
    BattleType type = BattleType.matched,
    int? myScore,
    int? opponentScore,
    String? notes,
  }) async {
    await database.battleDao.finishBattle(
      battleId,
      result: result,
      myScore: myScore,
      opponentScore: opponentScore,
      notes: notes,
    );

    await xpService.awardBattle(
      armyId: armyId,
      result: result,
      type: type,
      playedAt: DateTime.now(),
    );
  }

  // =========================
  // État des unités en direct
  // =========================

  Future<void> setUnitDestroyed(
    String battleId,
    String armyUnitId, {
    required bool destroyed,
  }) {
    return database.battleDao.setUnitDestroyed(
      battleId,
      armyUnitId,
      destroyed: destroyed,
    );
  }

  Future<List<BattleUnitStateDetails>> getUnitStates(String battleId) {
    return database.battleDao.getUnitStates(battleId);
  }

  Future<String> addUnitModifier(
    String battleId,
    String armyUnitId, {
    required BattleStatKey statKey,
    required int delta,
    String? label,
  }) {
    return database.battleDao.addUnitModifier(
      battleId,
      armyUnitId,
      statKey: statKey,
      delta: delta,
      label: label,
    );
  }

  Future<void> removeUnitModifier(String modifierId) {
    return database.battleDao.removeUnitModifier(modifierId);
  }

  Future<List<BattleUnitModifierDetails>> getUnitModifiers(String battleId) {
    return database.battleDao.getUnitModifiers(battleId);
  }
}
