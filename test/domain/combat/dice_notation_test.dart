import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/combat/dice_notation.dart';

void main() {
  group('diceNotationAverage', () {
    test('plain integer', () {
      expect(diceNotationAverage('3'), 3.0);
    });

    test('single die (D6)', () {
      expect(diceNotationAverage('D6'), 3.5);
    });

    test('multiple dice (2D6)', () {
      expect(diceNotationAverage('2D6'), 7.0);
    });

    test('die with bonus (D3+1)', () {
      expect(diceNotationAverage('D3+1'), 3.0);
    });

    test('unrecognized format falls back to 1', () {
      expect(diceNotationAverage('n/a'), 1.0);
    });
  });

  group('rollDiceNotation', () {
    test('plain integer always returns that value', () {
      final rng = Random(42);
      for (var i = 0; i < 5; i++) {
        expect(rollDiceNotation(rng, '4'), 4);
      }
    });

    test('D6 stays within [1, 6]', () {
      final rng = Random(7);
      for (var i = 0; i < 200; i++) {
        final roll = rollDiceNotation(rng, 'D6');
        expect(roll, inInclusiveRange(1, 6));
      }
    });

    test('2D6 stays within [2, 12]', () {
      final rng = Random(11);
      for (var i = 0; i < 200; i++) {
        final roll = rollDiceNotation(rng, '2D6');
        expect(roll, inInclusiveRange(2, 12));
      }
    });

    test('D3+1 stays within [2, 4]', () {
      final rng = Random(3);
      for (var i = 0; i < 200; i++) {
        final roll = rollDiceNotation(rng, 'D3+1');
        expect(roll, inInclusiveRange(2, 4));
      }
    });

    test('is deterministic for a seeded Random', () {
      final first = rollDiceNotation(Random(99), '3D6');
      final second = rollDiceNotation(Random(99), '3D6');
      expect(first, second);
    });

    test('unrecognized format falls back to 1', () {
      expect(rollDiceNotation(Random(1), 'n/a'), 1);
    });

    test('average over many rolls converges to diceNotationAverage', () {
      final rng = Random(123);
      const trials = 5000;
      var total = 0;
      for (var i = 0; i < trials; i++) {
        total += rollDiceNotation(rng, '2D6+1');
      }
      final avg = total / trials;
      expect(avg, closeTo(diceNotationAverage('2D6+1'), 0.3));
    });
  });
}
