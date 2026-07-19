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
    int? pointsLimit,
    String? detachmentId,
  }) {
    return database.armyDao.createArmy(
      name: name,
      factionId: factionId,
      pointsLimit: pointsLimit,
      detachmentId: detachmentId,
    );
  }

  Future<void> deleteArmy(String armyId) {
    return database.armyDao.deleteArmy(armyId);
  }

  Future<int> updateModelCount(String armyUnitId, int modelCount) {
    return database.armyDao.updateModelCount(armyUnitId, modelCount);
  }

  Future<void> setUnitEnhancement(String armyUnitId, String? enhancementId) {
    return database.armyDao.setUnitEnhancement(armyUnitId, enhancementId);
  }

  Future<List<DetachmentOption>> getDetachmentsForFaction(String factionId) {
    return database.armyDao.getDetachmentsForFaction(factionId);
  }

  Future<List<EnhancementOption>> getEnhancementsForDetachment(
    String detachmentId,
  ) {
    return database.armyDao.getEnhancementsForDetachment(detachmentId);
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
