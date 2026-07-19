import '../database/app_database.dart';
import '../database/models/army_details.dart';

class ArmyRepository {
  final AppDatabase database;

  ArmyRepository(this.database);

  Future<List<ArmyListItem>> listArmies() {
    return database.armyDao.listArmies();
  }

  Future<ArmyDetails?> getArmy(String armyId) {
    return database.armyDao.getArmy(armyId);
  }

  Future<String> createArmy({
    required String name,
    required String factionId,
  }) {
    return database.armyDao.createArmy(name: name, factionId: factionId);
  }

  Future<void> deleteArmy(String armyId) {
    return database.armyDao.deleteArmy(armyId);
  }

  Future<String> addUnit({
    required String armyId,
    required String datasheetId,
    required int modelCount,
  }) {
    return database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: datasheetId,
      modelCount: modelCount,
    );
  }

  Future<void> removeUnit(String armyUnitId) {
    return database.armyDao.removeUnit(armyUnitId);
  }
}
