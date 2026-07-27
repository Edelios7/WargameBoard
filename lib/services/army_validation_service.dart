import '../database/models/army_details.dart';

enum ArmyValidationIssue {
  overPointsLimit,
  emptyArmy,
  noDetachmentSelected,
  tooManyEnhancements,
  noWarlordSelected,
  unknownUnitCosts,
  duplicateEnhancement,
}

class ArmyValidationResult {
  final bool isValid;
  final List<ArmyValidationIssue> errors;
  final List<ArmyValidationIssue> warnings;

  const ArmyValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });
}

/// Vérifie une armée construite et remonte erreurs/avertissements.
///
/// Volontairement simple pour l'instant (limite de points, armée vide,
/// détachement manquant) : les règles de composition détaillées
/// (min/max Battleline, restrictions de détachement...) demanderaient
/// des données de règles par édition qu'on n'a pas encore de façon
/// fiable — à étoffer une fois le pipeline d'import plus complet.
class ArmyValidationService {
  const ArmyValidationService();

  /// Une liste ne peut pas comporter plus de 3 enhancements par
  /// détachement (règle commune aux éditions 10 et 11).
  static const maxEnhancements = 3;

  ArmyValidationResult validate(ArmyDetails army) {
    final errors = <ArmyValidationIssue>[];
    final warnings = <ArmyValidationIssue>[];

    if (army.isOverLimit) {
      errors.add(ArmyValidationIssue.overPointsLimit);
    }
    if (army.units.isEmpty) {
      warnings.add(ArmyValidationIssue.emptyArmy);
    }
    if (army.pointsLimit != null && army.detachmentId == null) {
      warnings.add(ArmyValidationIssue.noDetachmentSelected);
    }
    final enhancementIds = army.units
        .map((u) => u.enhancementId)
        .whereType<String>()
        .toList();
    if (enhancementIds.length > maxEnhancements) {
      errors.add(ArmyValidationIssue.tooManyEnhancements);
    }
    // Une amélioration ne peut être portée que par une seule figurine à
    // la fois — le sélecteur (armies_page.dart, _pickEnhancement) filtre
    // déjà celles prises ailleurs, mais on le revérifie ici en filet de
    // sécurité (données existantes avant ce correctif, etc.).
    if (enhancementIds.toSet().length != enhancementIds.length) {
      errors.add(ArmyValidationIssue.duplicateEnhancement);
    }
    if (army.units.isNotEmpty && !army.units.any((u) => u.isWarlord)) {
      warnings.add(ArmyValidationIssue.noWarlordSelected);
    }
    if (army.hasUnitsWithUnknownCost) {
      warnings.add(ArmyValidationIssue.unknownUnitCosts);
    }

    return ArmyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
