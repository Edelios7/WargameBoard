import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/army_details.dart';
import 'package:wargameboard/database/models/datasheet_details.dart';
import 'package:wargameboard/database/models/unit_details.dart';
import 'package:wargameboard/domain/armies/army_recommendations.dart';
import 'package:wargameboard/domain/catalog/common/unit_archetype.dart';

const _unitShape = UnitDetails(minimumSize: 1, maximumSize: 1, defaultSize: 1);

DatasheetDetails _sheet({
  required String id,
  required String name,
  UnitArchetype? archetype,
  int points = 100,
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
    models: const [],
    weapons: const [],
    equipment: const [],
    unit: _unitShape,
    points: points,
    archetype: archetype,
  );
}

ArmyUnitDetails _armyUnit(String datasheetId, {String? name}) {
  return ArmyUnitDetails(
    id: '$datasheetId-instance',
    datasheetId: datasheetId,
    datasheetName: name ?? datasheetId,
    modelCount: 1,
    minimumModels: 1,
    maximumModels: 1,
    datasheetPoints: 100,
  );
}

ArmyDetails _army(List<ArmyUnitDetails> units) {
  return ArmyDetails(
    id: 'a1',
    name: 'Armée',
    factionId: 'fac-test',
    factionName: 'Test',
    units: units,
    totalPoints: units.length * 100,
  );
}

void main() {
  group('suggestUnits — synergie', () {
    test('recommande les unités les plus co-occurrentes avec l\'armée actuelle', () {
      final catalog = [
        _sheet(id: 'a', name: 'A'),
        _sheet(id: 'b', name: 'B'),
        _sheet(id: 'c', name: 'C'),
      ];
      final army = _army([_armyUnit('a', name: 'A')]);
      final synergy = {
        'a': {'b': 5, 'c': 1},
      };

      final result = suggestUnits(
        army: army,
        synergy: synergy,
        factionCatalog: catalog,
        max: 3,
      );

      expect(result, hasLength(2));
      expect(result[0].datasheetId, 'b');
      expect(result[0].reason, UnitSuggestionReason.synergy);
      expect(result[0].synergyPartnerName, 'A');
      expect(result[1].datasheetId, 'c');
    });

    test('n\'inclut jamais une unité déjà présente dans l\'armée', () {
      final catalog = [_sheet(id: 'a', name: 'A'), _sheet(id: 'b', name: 'B')];
      final army = _army([_armyUnit('a', name: 'A'), _armyUnit('b', name: 'B')]);
      final synergy = {
        'a': {'b': 5},
      };

      final result = suggestUnits(
        army: army,
        synergy: synergy,
        factionCatalog: catalog,
      );

      expect(result, isEmpty);
    });

    test('ignore silencieusement une entrée de synergie hors catalogue', () {
      final catalog = [_sheet(id: 'a', name: 'A')];
      final army = _army([_armyUnit('a', name: 'A')]);
      final synergy = {
        'a': {'ghost-id': 9},
      };

      expect(
        () => suggestUnits(army: army, synergy: synergy, factionCatalog: catalog),
        returnsNormally,
      );
      final result = suggestUnits(
        army: army,
        synergy: synergy,
        factionCatalog: catalog,
      );
      expect(result, isEmpty);
    });
  });

  group('suggestUnits — repli trou de rôle', () {
    test('complète avec l\'unité la moins chère d\'un archétype absent', () {
      final catalog = [
        _sheet(id: 'elite-1', name: 'Elite Cher', archetype: UnitArchetype.elite, points: 200),
        _sheet(id: 'elite-2', name: 'Elite Pas Cher', archetype: UnitArchetype.elite, points: 90),
        _sheet(id: 'horde-1', name: 'Horde', archetype: UnitArchetype.horde, points: 60),
      ];
      final army = _army([]);

      final result = suggestUnits(
        army: army,
        synergy: const {},
        factionCatalog: catalog,
        max: 2,
      );

      expect(result, isNotEmpty);
      expect(result.every((s) => s.reason == UnitSuggestionReason.roleGap), isTrue);
      // Le moins cher des deux "elite" doit être choisi, pas le plus cher.
      final eliteSuggestion = result.firstWhere(
        (s) => s.missingArchetype == UnitArchetype.elite,
      );
      expect(eliteSuggestion.datasheetId, 'elite-2');
    });

    test('ne suggère jamais une fiche sans coût connu', () {
      final catalog = [
        DatasheetDetails(
          id: 'no-cost',
          name: 'Sans coût',
          factionId: 'fac-test',
          factionName: 'Test',
          gameSystemId: 'gs',
          editionId: 'ed',
          keywords: const [],
          abilities: const [],
          models: const [],
          weapons: const [],
          equipment: const [],
          unit: _unitShape,
          points: null,
          archetype: UnitArchetype.elite,
        ),
      ];
      final army = _army([]);

      final result = suggestUnits(
        army: army,
        synergy: const {},
        factionCatalog: catalog,
      );

      expect(result.any((s) => s.datasheetId == 'no-cost'), isFalse);
    });

    test(
        'ne suggère jamais une unité dont le coût dépasse le budget de '
        'points restant', () {
      final catalog = [
        _sheet(id: 'syn-cher', name: 'Synergie Chère', points: 300),
        _sheet(id: 'horde-abordable', name: 'Horde', archetype: UnitArchetype.horde, points: 50),
        _sheet(id: 'elite-cher', name: 'Elite Chère', archetype: UnitArchetype.elite, points: 300),
      ];
      final army = _army([_armyUnit('base', name: 'Base')]);
      final synergy = {
        'base': {'syn-cher': 5},
      };

      final result = suggestUnits(
        army: army,
        synergy: synergy,
        factionCatalog: catalog,
        max: 3,
        remainingPoints: 100,
      );

      expect(result.any((s) => s.datasheetId == 'syn-cher'), isFalse);
      expect(result.any((s) => s.datasheetId == 'elite-cher'), isFalse);
      expect(result.any((s) => s.datasheetId == 'horde-abordable'), isTrue);
    });

    test('respecte la limite max en combinant synergie et trou de rôle', () {
      final catalog = [
        _sheet(id: 'syn-1', name: 'Synergie 1'),
        _sheet(id: 'horde-1', name: 'Horde', archetype: UnitArchetype.horde, points: 50),
        _sheet(id: 'elite-1', name: 'Elite', archetype: UnitArchetype.elite, points: 60),
      ];
      final army = _army([_armyUnit('base', name: 'Base')]);
      final synergy = {
        'base': {'syn-1': 3},
      };

      final result = suggestUnits(
        army: army,
        synergy: synergy,
        factionCatalog: catalog,
        max: 2,
      );

      expect(result, hasLength(2));
      expect(result.first.reason, UnitSuggestionReason.synergy);
    });
  });
}
