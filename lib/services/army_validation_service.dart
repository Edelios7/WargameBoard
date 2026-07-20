import '../database/models/army_details.dart';

enum ArmyValidationIssue {
  overPointsLimit,
  emptyArmy,
  noDetachmentSelected,
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

    return ArmyValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }
}
