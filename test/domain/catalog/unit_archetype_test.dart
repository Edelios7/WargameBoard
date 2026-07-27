import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/catalog/common/unit_archetype.dart';

void main() {
  group('classifyArchetype', () {
    test('a unit with the Véhicule keyword is armored regardless of size', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie', 'Véhicule'],
          maxModelSize: 1,
          baseToughness: 6,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.armored,
      );
    });

    test('a unit with the Monstre keyword is armored', () {
      expect(
        classifyArchetype(
          keywords: const ['Monstre'],
          maxModelSize: 1,
          baseToughness: 8,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.armored,
      );
    });

    test(
        'a small squad with a dedicated high-AP high-strength weapon is anti-tank',
        () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie'],
          maxModelSize: 3,
          baseToughness: 4,
          hasDedicatedAntiTankWeapon: true,
        ),
        UnitArchetype.antiTank,
      );
    });

    test('a large fragile squad is a horde', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie'],
          maxModelSize: 10,
          baseToughness: 3,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.horde,
      );
    });

    test('a large squad is not a horde if it is tough enough', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie'],
          maxModelSize: 10,
          baseToughness: 6,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.elite,
      );
    });

    test('a small psyker unit without a heavy weapon is support', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie', 'Psyker'],
          maxModelSize: 1,
          baseToughness: 3,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.support,
      );
    });

    test('a psyker unit with a dedicated anti-tank weapon is anti-tank, not support', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie', 'Psyker'],
          maxModelSize: 1,
          baseToughness: 4,
          hasDedicatedAntiTankWeapon: true,
        ),
        UnitArchetype.antiTank,
      );
    });

    test('a small tough non-psyker squad defaults to elite', () {
      expect(
        classifyArchetype(
          keywords: const ['Infanterie'],
          maxModelSize: 5,
          baseToughness: 5,
          hasDedicatedAntiTankWeapon: false,
        ),
        UnitArchetype.elite,
      );
    });
  });

  group('parseArchetype', () {
    test('round-trips every UnitArchetype value through its enum name', () {
      for (final archetype in UnitArchetype.values) {
        expect(parseArchetype(archetype.name), archetype);
      }
    });

    test('returns null for an unknown or missing value', () {
      expect(parseArchetype(null), isNull);
      expect(parseArchetype('not-a-real-archetype'), isNull);
    });
  });

  group('matchupFor', () {
    test('the same archetype twice is balanced with no advantage', () {
      final result = matchupFor(UnitArchetype.elite, UnitArchetype.elite);
      expect(result.advantage, isNull);
      expect(result.explanation, isNotEmpty);
    });

    test('armored beats horde', () {
      final result = matchupFor(UnitArchetype.horde, UnitArchetype.armored);
      expect(result.advantage, UnitArchetype.armored);
    });

    test('matchupFor is symmetric regardless of argument order', () {
      final ab = matchupFor(UnitArchetype.armored, UnitArchetype.antiTank);
      final ba = matchupFor(UnitArchetype.antiTank, UnitArchetype.armored);
      expect(ab.advantage, ba.advantage);
      expect(ab.explanation, ba.explanation);
    });

    test('every unordered pair of distinct archetypes has an explanation', () {
      for (final a in UnitArchetype.values) {
        for (final b in UnitArchetype.values) {
          if (a == b) continue;
          final result = matchupFor(a, b);
          expect(
            result.explanation,
            isNotEmpty,
            reason: 'missing matchup text for $a vs $b',
          );
        }
      }
    });
  });
}
