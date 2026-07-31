import 'dart:math';

import '../../database/models/model_details.dart';
import '../../database/models/weapon_details.dart';
import 'dice_notation.dart';

/// Résultat agrégé d'une simulation de combat sur plusieurs essais — voir
/// [simulateCombat]. Chaque champ est déjà moyenné sur [trials] essais.
class CombatSimulationResult {
  final int trials;
  final double averageModelsKilled;

  /// Probabilité (0..1) que l'unité défenseure soit entièrement détruite
  /// en un seul essai (une "vague" d'attaques).
  final double destructionProbability;

  /// Dégâts bruts moyens infligés (après sauvegarde), toutes attaques
  /// confondues sur un essai — inclut l'éventuel excédent perdu sur le
  /// dernier modèle tué.
  final double averageDamageDealt;
  final double averageModelsRemaining;

  const CombatSimulationResult({
    required this.trials,
    required this.averageModelsKilled,
    required this.destructionProbability,
    required this.averageDamageDealt,
    required this.averageModelsRemaining,
  });
}

/// Seuil (2 à 6) pour blesser avec une arme de Force [strength] contre une
/// cible d'Endurance [toughness], selon la table standard 10e édition.
int woundThreshold(int strength, int toughness) {
  if (strength >= toughness * 2) return 2;
  if (strength > toughness) return 3;
  if (strength == toughness) return 4;
  if (toughness < strength * 2) return 5;
  return 6;
}

/// Seuil de sauvegarde modifié par la pénétration d'armure — `null` si la
/// sauvegarde est impossible (seuil modifié > 6).
int? modifiedSaveThreshold(int save, int armorPenetration) {
  final modified = save + armorPenetration;
  return modified <= 6 ? modified : null;
}

/// Simule [trials] essais indépendants d'une unité attaquante (composée de
/// [attackerModelCount] modèles portant tous [weaponProfile]) tirant/
/// chargeant sur une unité défenseure de [defenderModelCount] modèles
/// identiques ([defenderModel]).
///
/// Cœur du combat uniquement (Toucher/Blesser/Sauvegarde/Dégâts) — aucune
/// règle spéciale (Sustained Hits, Lethal Hits, Devastating Wounds,
/// Anti-X, Feel No Pain, Invulnérable...) n'est prise en compte : ces
/// mots-clés n'existent qu'en texte libre en base, sans champ structuré
/// exploitable de façon fiable.
///
/// Dans chaque essai, les touches non-sauvegardées visent un modèle
/// défenseur courant ; une fois ce modèle détruit, les touches suivantes
/// visent le modèle suivant. L'excédent de dégâts d'un même coup au-delà
/// des PV restants du modèle courant est perdu (jamais reporté sur le
/// modèle suivant), conformément aux règles 10e édition.
CombatSimulationResult simulateCombat({
  required WeaponProfileDetails weaponProfile,
  required int attackerModelCount,
  required ModelDetails defenderModel,
  required int defenderModelCount,
  required int trials,
  Random? random,
}) {
  final rng = random ?? Random();
  final hitThreshold =
      (weaponProfile.isMelee
          ? weaponProfile.weaponSkill
          : weaponProfile.ballisticSkill) ??
      4;
  final wound = woundThreshold(weaponProfile.strength, defenderModel.toughness);
  final save = modifiedSaveThreshold(
    defenderModel.save,
    weaponProfile.armorPenetration,
  );

  var totalKilled = 0;
  var totalDamage = 0;
  var destroyedTrials = 0;

  for (var trial = 0; trial < trials; trial++) {
    final remainingWounds = List<int>.filled(
      defenderModelCount,
      defenderModel.wounds,
    );
    var currentModelIndex = 0;
    var trialDamage = 0;

    for (var model = 0; model < attackerModelCount; model++) {
      if (currentModelIndex >= defenderModelCount) break;

      final attacks = rollDiceNotation(rng, weaponProfile.attacks);
      for (var attack = 0; attack < attacks; attack++) {
        if (currentModelIndex >= defenderModelCount) break;

        final hitRoll = rng.nextInt(6) + 1;
        if (hitRoll == 1 || hitRoll < hitThreshold) continue;

        final woundRoll = rng.nextInt(6) + 1;
        if (woundRoll == 1 || woundRoll < wound) continue;

        if (save != null) {
          final saveRoll = rng.nextInt(6) + 1;
          if (saveRoll != 1 && saveRoll >= save) continue;
        }

        final damage = rollDiceNotation(rng, weaponProfile.damage);
        trialDamage += damage;
        remainingWounds[currentModelIndex] -= damage;
        if (remainingWounds[currentModelIndex] <= 0) {
          currentModelIndex++;
        }
      }
    }

    totalKilled += currentModelIndex;
    totalDamage += trialDamage;
    if (currentModelIndex >= defenderModelCount) destroyedTrials++;
  }

  return CombatSimulationResult(
    trials: trials,
    averageModelsKilled: totalKilled / trials,
    destructionProbability: destroyedTrials / trials,
    averageDamageDealt: totalDamage / trials,
    averageModelsRemaining: defenderModelCount - (totalKilled / trials),
  );
}
