import '../database/app_database.dart';
import '../database/models/army_details.dart';
import '../services/xp_service.dart';

class ArmyRepository {
  final AppDatabase database;
  final XpService xpService;

  ArmyRepository(this.database, this.xpService);

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
  }) async {
    final id = await database.armyDao.createArmy(
      name: name,
      factionId: factionId,
      pointsLimit: pointsLimit,
      detachmentId: detachmentId,
    );
    await xpService.awardFirstArmyIfNeeded(factionId);
    return id;
  }

  Future<void> deleteArmy(String armyId) {
    return database.armyDao.deleteArmy(armyId);
  }

  Future<void> updateNotes(String armyId, String? notes) {
    return database.armyDao.updateNotes(armyId, notes);
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

  Future<List<StratagemOption>> getStratagemsForDetachment(
    String detachmentId,
  ) {
    return database.armyDao.getStratagemsForDetachment(detachmentId);
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
