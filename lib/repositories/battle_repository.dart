import '../database/app_database.dart';
import '../database/models/battle_details.dart';
import '../database/tables/battles_table.dart';

class BattleRepository {
  final AppDatabase database;

  BattleRepository(this.database);

  Future<List<BattleDetails>> listBattles() {
    return database.battleDao.listBattles();
  }

  Future<String> addBattle({
    String? armyId,
    String? opponentName,
    String? missionName,
    BattleResult? result,
    int? myScore,
    int? opponentScore,
    String? notes,
  }) {
    return database.battleDao.addBattle(
      armyId: armyId,
      opponentName: opponentName,
      missionName: missionName,
      result: result,
      myScore: myScore,
      opponentScore: opponentScore,
      notes: notes,
    );
  }

  Future<void> deleteBattle(String id) {
    return database.battleDao.deleteBattle(id);
  }
}
