import '../database/app_database.dart';
import '../database/models/battle_details.dart';
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

    await xpService.awardBattle(armyId: armyId, result: result, type: type);

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
}
