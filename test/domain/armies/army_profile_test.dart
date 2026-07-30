import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/army_details.dart';
import 'package:wargameboard/database/models/datasheet_details.dart';
import 'package:wargameboard/database/models/model_details.dart';
import 'package:wargameboard/database/models/unit_details.dart';
import 'package:wargameboard/database/models/weapon_details.dart';
import 'package:wargameboard/domain/armies/army_profile.dart';

const _unitShape = UnitDetails(minimumSize: 1, maximumSize: 1, defaultSize: 1);

DatasheetDetails _sheet({
  required String id,
  required String name,
  List<WeaponDetails> weapons = const [],
  List<ModelDetails> models = const [],
}) {
  return DatasheetDetails(
    id: id,
    name: name,
    factionId: 'fac-test',
    factionName: 'Test',
    gameSystemId: 'gs',
    editionId: 'ed',
    keywords: const [],
    abilities: const [],
    models: models,
    weapons: weapons,
    equipment: const [],
    unit: _unitShape,
    points: 100,
  );
}

ArmyUnitDetails _armyUnit({
  required String datasheetId,
  required int modelCount,
  int? points,
}) {
  return ArmyUnitDetails(
    id: '$datasheetId-instance',
    datasheetId: datasheetId,
    datasheetName: datasheetId,
    modelCount: modelCount,
    minimumModels: modelCount,
    maximumModels: modelCount,
    datasheetPoints: points,
  );
}

void main() {
  group('computeArmyProfile', () {
    test('returns all-zero scores for an army with no units', () {
      final army = ArmyDetails(
        id: 'a1',
        name: 'Vide',
        factionId: 'fac-test',
        factionName: 'Test',
        units: const [],
        totalPoints: 0,
      );

      final scores = computeArmyProfile(army, {});

      expect(scores.tir, 0);
      expect(scores.corpsACorps, 0);
      expect(scores.resilience, 0);
      expect(scores.mobilite, 0);
      expect(scores.controle, 0);
    });

    test('a pure-shooting unit scores high on Tir and near-zero elsewhere', () {
      final sheet = _sheet(
        id: 'ds-tir',
        name: 'Tireur',
        weapons: [
          const WeaponDetails(
            id: 'w1',
            name: 'Fusil bolter',
            type: 'Arme à distance',
            keywords: [],
            abilities: [],
            profiles: [
              WeaponProfileDetails(
                name: 'Fusil bolter',
                range: 24,
                attacks: '2',
                strength: 4,
                armorPenetration: 0,
                damage: '1',
                isMelee: false,
              ),
            ],
          ),
        ],
        models: const [
          ModelDetails(
            id: 'm1',
            name: 'Tireur',
            movement: 6,
            toughness: 4,
            save: 3,
            wounds: 2,
            leadership: 6,
            objectiveControl: 1,
          ),
        ],
      );
      final unit = _armyUnit(datasheetId: 'ds-tir', modelCount: 5, points: 80);
      final army = ArmyDetails(
        id: 'a1',
        name: 'Armée de tir',
        factionId: 'fac-test',
        factionName: 'Test',
        units: [unit],
        totalPoints: 80,
      );

      final scores = computeArmyProfile(army, {'ds-tir': sheet});

      expect(scores.tir, greaterThan(0));
      expect(scores.corpsACorps, 0);
      final result = dominantProfile(scores);
      expect(result.isBalanced, isFalse);
      expect(result.dominantAxes.first, ArmyProfileAxis.tir);
    });

    test('a pure-melee unit scores high on Corps-à-corps only', () {
      final sheet = _sheet(
        id: 'ds-cac',
        name: 'Bretteur',
        weapons: [
          const WeaponDetails(
            id: 'w1',
            name: 'Épée énergétique',
            type: 'Arme de mêlée',
            keywords: [],
            abilities: [],
            profiles: [
              WeaponProfileDetails(
                name: 'Épée énergétique',
                range: 0,
                attacks: '4',
                strength: 5,
                armorPenetration: 2,
                damage: '2',
                isMelee: true,
              ),
            ],
          ),
        ],
      );
      final unit = _armyUnit(datasheetId: 'ds-cac', modelCount: 3, points: 90);
      final army = ArmyDetails(
        id: 'a2',
        name: 'Armée de corps-à-corps',
        factionId: 'fac-test',
        factionName: 'Test',
        units: [unit],
        totalPoints: 90,
      );

      final scores = computeArmyProfile(army, {'ds-cac': sheet});

      expect(scores.corpsACorps, greaterThan(0));
      expect(scores.tir, 0);
    });

    test('ignores units whose datasheet is missing instead of crashing', () {
      final unit = _armyUnit(datasheetId: 'ds-unknown', modelCount: 5, points: 80);
      final army = ArmyDetails(
        id: 'a3',
        name: 'Armée',
        factionId: 'fac-test',
        factionName: 'Test',
        units: [unit],
        totalPoints: 80,
      );

      final scores = computeArmyProfile(army, {});

      expect(scores.tir, 0);
      expect(scores.corpsACorps, 0);
      expect(scores.resilience, 0);
    });

    test(
        'a unit with an unknown cost does not skew any axis (excluded like '
        'it already was from mobilité)', () {
      final sheet = _sheet(
        id: 'ds-tir',
        name: 'Tireur',
        weapons: [
          const WeaponDetails(
            id: 'w1',
            name: 'Fusil bolter',
            type: 'Arme à distance',
            keywords: [],
            abilities: [],
            profiles: [
              WeaponProfileDetails(
                name: 'Fusil bolter',
                range: 24,
                attacks: '2',
                strength: 4,
                armorPenetration: 0,
                damage: '1',
                isMelee: false,
              ),
            ],
          ),
        ],
        models: const [
          ModelDetails(
            id: 'm1',
            name: 'Tireur',
            movement: 6,
            toughness: 4,
            save: 3,
            wounds: 2,
            leadership: 6,
            objectiveControl: 1,
          ),
        ],
      );
      final knownUnit = _armyUnit(
        datasheetId: 'ds-tir',
        modelCount: 5,
        points: 80,
      );
      final unknownCostUnit = _armyUnit(
        datasheetId: 'ds-tir',
        modelCount: 50,
      );
      expect(unknownCostUnit.hasUnknownCost, isTrue);

      final withoutUnknown = computeArmyProfile(
        ArmyDetails(
          id: 'a1',
          name: 'Armée de tir',
          factionId: 'fac-test',
          factionName: 'Test',
          units: [knownUnit],
          totalPoints: 80,
        ),
        {'ds-tir': sheet},
      );
      final withUnknownAdded = computeArmyProfile(
        ArmyDetails(
          id: 'a1',
          name: 'Armée de tir',
          factionId: 'fac-test',
          factionName: 'Test',
          units: [knownUnit, unknownCostUnit],
          // totalPoints n'inclut que le coût connu, comme le calcule le
          // reste de l'appli pour une unité à coût inconnu.
          totalPoints: 80,
        ),
        {'ds-tir': sheet},
      );

      expect(withUnknownAdded.tir, withoutUnknown.tir);
      expect(withUnknownAdded.resilience, withoutUnknown.resilience);
      expect(withUnknownAdded.controle, withoutUnknown.controle);
    });
  });

  group('dominantProfile', () {
    test('returns balanced when all axes are close', () {
      const scores = ArmyProfileScores(
        tir: 50,
        corpsACorps: 52,
        resilience: 48,
        mobilite: 55,
        controle: 51,
      );

      expect(dominantProfile(scores).isBalanced, isTrue);
    });

    test('returns a single dominant axis when one clearly leads', () {
      const scores = ArmyProfileScores(
        tir: 90,
        corpsACorps: 20,
        resilience: 15,
        mobilite: 10,
        controle: 5,
      );

      final result = dominantProfile(scores);
      expect(result.isBalanced, isFalse);
      expect(result.dominantAxes, [ArmyProfileAxis.tir]);
    });

    test('returns two axes when the top two are close together', () {
      const scores = ArmyProfileScores(
        tir: 80,
        corpsACorps: 75,
        resilience: 20,
        mobilite: 10,
        controle: 5,
      );

      final result = dominantProfile(scores);
      expect(result.dominantAxes, [ArmyProfileAxis.tir, ArmyProfileAxis.corpsACorps]);
    });
  });
}
