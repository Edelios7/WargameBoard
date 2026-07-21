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

  Future<ArmyDetails?> getArmy(String armyId) async {
    final army = await database.armyDao.getArmy(armyId);
    if (army == null) return null;
    return _withEquipmentChoices(army);
  }

  /// Complète chaque unité avec un libellé de son chargement d'armes
  /// optionnelles actuel (ex. "Arme spéciale : Lance-flammes"), pour
  /// l'affichage et l'export texte (voir [ArmyListFormatter]) — la
  /// requête de base de [ArmyDao.getArmy] ne connaît pas les groupes
  /// d'équipement, gérés côté [DatasheetDao].
  Future<ArmyDetails> _withEquipmentChoices(ArmyDetails army) async {
    if (army.units.isEmpty) return army;

    final updatedUnits = <ArmyUnitDetails>[];
    for (final unit in army.units) {
      final groups =
          await database.datasheetDao.getEquipmentGroups(unit.datasheetId);
      if (groups.isEmpty) {
        updatedUnits.add(unit);
        continue;
      }

      final selections =
          await database.armyDao.getUnitEquipmentSelections(unit.id);
      final choices = <String>[];
      for (final group in groups) {
        final selected = selections[group.id];
        final chosenOptionIds = (selected != null && selected.isNotEmpty)
            ? selected
            : group.options
                .where((option) => option.isDefault)
                .map((option) => option.id)
                .toList();
        final chosenNames = group.options
            .where((option) => chosenOptionIds.contains(option.id))
            .map((option) => option.name)
            .join(', ');
        if (chosenNames.isNotEmpty) {
          choices.add('${group.name}: $chosenNames');
        }
      }

      updatedUnits.add(ArmyUnitDetails(
        id: unit.id,
        datasheetId: unit.datasheetId,
        datasheetName: unit.datasheetName,
        battlefieldRole: unit.battlefieldRole,
        modelCount: unit.modelCount,
        minimumModels: unit.minimumModels,
        maximumModels: unit.maximumModels,
        datasheetPoints: unit.datasheetPoints,
        enhancementId: unit.enhancementId,
        enhancementName: unit.enhancementName,
        enhancementPoints: unit.enhancementPoints,
        equipmentChoices: choices,
        isWarlord: unit.isWarlord,
      ));
    }

    return ArmyDetails(
      id: army.id,
      name: army.name,
      factionId: army.factionId,
      factionName: army.factionName,
      detachmentId: army.detachmentId,
      detachmentName: army.detachmentName,
      notes: army.notes,
      units: updatedUnits,
      totalPoints: army.totalPoints,
      pointsLimit: army.pointsLimit,
    );
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

  Future<int> setDetachment(String armyId, String? detachmentId) {
    return database.armyDao.setDetachment(armyId, detachmentId);
  }

  Future<void> setWarlord(String armyId, String? armyUnitId) {
    return database.armyDao.setWarlord(armyId, armyUnitId);
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

  Future<Map<String, List<String>>> getUnitEquipmentSelections(
    String armyUnitId,
  ) {
    return database.armyDao.getUnitEquipmentSelections(armyUnitId);
  }

  Future<void> setUnitEquipmentSelection(
    String armyUnitId,
    String groupId,
    List<String> optionIds,
  ) {
    return database.armyDao.setUnitEquipmentSelection(
      armyUnitId,
      groupId,
      optionIds,
    );
  }
}
