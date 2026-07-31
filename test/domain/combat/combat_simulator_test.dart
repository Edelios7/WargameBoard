import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/model_details.dart';
import 'package:wargameboard/database/models/weapon_details.dart';
import 'package:wargameboard/domain/combat/combat_simulator.dart';

ModelDetails _model({int toughness = 4, int save = 3, int wounds = 1}) {
  return ModelDetails(
    id: 'model',
    name: 'Model',
    movement: 6,
    toughness: toughness,
    save: save,
    wounds: wounds,
    leadership: 7,
    objectiveControl: 1,
  );
}

WeaponProfileDetails _weapon({
  String attacks = '1',
  int? ballisticSkill = 3,
  int? weaponSkill,
  int strength = 4,
  int armorPenetration = 0,
  String damage = '1',
  bool isMelee = false,
}) {
  return WeaponProfileDetails(
    name: 'Weapon',
    range: isMelee ? 0 : 24,
    attacks: attacks,
    ballisticSkill: ballisticSkill,
    weaponSkill: weaponSkill,
    strength: strength,
    armorPenetration: armorPenetration,
    damage: damage,
    isMelee: isMelee,
  );
}

void main() {
  group('woundThreshold', () {
    test('strength at least double toughness needs 2+', () {
      expect(woundThreshold(8, 4), 2);
    });
    test('strength greater than toughness needs 3+', () {
      expect(woundThreshold(5, 4), 3);
    });
    test('strength equal to toughness needs 4+', () {
      expect(woundThreshold(4, 4), 4);
    });
    test('toughness greater than strength (but less than double) needs 5+', () {
      expect(woundThreshold(4, 5), 5);
    });
    test('toughness at least double strength needs 6+', () {
      expect(woundThreshold(2, 4), 6);
    });
  });

  group('modifiedSaveThreshold', () {
    test('unmodified save', () {
      expect(modifiedSaveThreshold(3, 0), 3);
    });
    test('AP worsens the required roll', () {
      expect(modifiedSaveThreshold(3, 2), 5);
    });
    test('AP pushing past 6 makes the save impossible', () {
      expect(modifiedSaveThreshold(4, 3), null);
    });
  });

  group('simulateCombat', () {
    test(
      'a weapon that always wounds and cannot be saved destroys the unit',
      () {
        final result = simulateCombat(
          weaponProfile: _weapon(
            attacks: '2',
            ballisticSkill: 2,
            strength: 20,
            armorPenetration: 6,
            damage: '3',
          ),
          attackerModelCount: 5,
          defenderModel: _model(toughness: 1, save: 2, wounds: 1),
          defenderModelCount: 3,
          trials: 500,
          random: Random(1),
        );

        expect(result.destructionProbability, 1.0);
        expect(result.averageModelsKilled, 3.0);
        expect(result.averageModelsRemaining, 0.0);
      },
    );

    test(
      'a weapon that almost never wounds (needs a natural 6) barely dents the unit',
      () {
        final result = simulateCombat(
          weaponProfile: _weapon(strength: 1, ballisticSkill: 2),
          attackerModelCount: 10,
          defenderModel: _model(toughness: 12, save: 2, wounds: 3),
          defenderModelCount: 5,
          trials: 200,
          random: Random(2),
        );

        // Un jet naturel de 6 blesse toujours (S=1 vs E=12 -> seuil 6+),
        // donc ce n'est jamais rigoureusement impossible, mais rare :
        // P(toucher)=5/6, P(blesser)=1/6, P(save ratée)=1/6 (sauvegarde
        // 2+ contre PA0) => ~2.3% de dégât par attaque.
        expect(result.averageModelsKilled, lessThan(0.5));
        expect(result.destructionProbability, 0.0);
      },
    );

    test('excess damage on a killed model does not carry over', () {
      final result = simulateCombat(
        weaponProfile: _weapon(
          attacks: '1',
          ballisticSkill: 2,
          strength: 20,
          armorPenetration: 6,
          damage: '10',
        ),
        attackerModelCount: 1,
        defenderModel: _model(toughness: 1, save: 2, wounds: 1),
        defenderModelCount: 5,
        trials: 100,
        random: Random(3),
      );

      // Un seul modèle attaquant, un seul jet d'attaque : au plus un
      // modèle défenseur peut être tué par essai, quel que soit le
      // surplus de dégâts.
      expect(result.averageModelsKilled, lessThanOrEqualTo(1.0));
    });

    test(
      'hit/wound/save rates converge to the expected probabilities over many trials',
      () {
        // CT3+ (hit 4/6), F4 vs E4 (wound 3/6 -> need 4+ so 3/6... recompute)
        final result = simulateCombat(
          weaponProfile: _weapon(
            attacks: '100',
            ballisticSkill: 3,
            strength: 4,
            armorPenetration: 0,
            damage: '1',
          ),
          attackerModelCount: 1,
          defenderModel: _model(toughness: 4, save: 3, wounds: 10000),
          defenderModelCount: 1,
          trials: 300,
          random: Random(4),
        );

        // P(hit) = 4/6 (CT3+), P(wound|hit) = 3/6 (S=T -> 4+),
        // P(save réussie|blessure) = 4/6 (save 3+) donc P(save ratée) = 2/6
        // Dégâts attendus par attaque ≈ 100 * (4/6) * (3/6) * (2/6) ≈ 11.11
        expect(result.averageDamageDealt, closeTo(11.1, 3.0));
      },
    );

    test('melee weapon uses weaponSkill instead of ballisticSkill', () {
      final result = simulateCombat(
        weaponProfile: _weapon(
          attacks: '50',
          ballisticSkill: null,
          weaponSkill: 2,
          strength: 20,
          armorPenetration: 6,
          damage: '1',
          isMelee: true,
        ),
        attackerModelCount: 1,
        defenderModel: _model(toughness: 1, save: 2, wounds: 100),
        defenderModelCount: 1,
        trials: 300,
        random: Random(5),
      );

      // CC2+ -> 5/6 hit chance, S=20 vs E=1 -> 5/6 chance de blesser,
      // sauvegarde impossible (2+PA6=8 > 6) donc toujours ratée.
      expect(result.averageDamageDealt, closeTo(50 * 5 / 6 * 5 / 6, 5.0));
    });
  });
}
