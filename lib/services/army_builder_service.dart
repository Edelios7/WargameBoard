import '../repositories/army_repository.dart';

/// Orchestration au-dessus d'ArmyRepository pour des opérations qui
/// touchent plusieurs unités/appels DAO à la fois (le repository reste
/// un simple passe-plat vers ArmyDao pour les opérations unitaires).
class ArmyBuilderService {
  final ArmyRepository repository;

  const ArmyBuilderService(this.repository);

  /// Duplique une armée existante (même faction/détachement/limite de
  /// points) sous un nouveau nom, avec toutes ses unités et leurs
  /// enhancements. Retourne l'id de la nouvelle armée, ou `null` si
  /// l'armée source n'existe pas.
  Future<String?> duplicateArmy(String armyId, String newName) async {
    final source = await repository.getArmy(armyId);
    if (source == null) return null;

    final newArmyId = await repository.createArmy(
      name: newName,
      factionId: source.factionId,
      pointsLimit: source.pointsLimit,
      detachmentId: source.detachmentId,
    );

    for (final unit in source.units) {
      final newUnitId = await repository.addUnit(
        armyId: newArmyId,
        datasheetId: unit.datasheetId,
        modelCount: unit.modelCount,
      );
      if (unit.enhancementId != null) {
        await repository.setUnitEnhancement(newUnitId, unit.enhancementId);
      }
    }

    return newArmyId;
  }
}
