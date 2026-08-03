import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/cost_bracket.dart';

void main() {
  group('resolveCostForModelCount', () {
    test('returns null (unknown cost) when there are no brackets', () {
      expect(resolveCostForModelCount(const [], 5), isNull);
    });

    test('returns the flat cost when there is a single unsized bracket', () {
      const brackets = [CostBracket(modelCount: null, points: 90)];
      expect(resolveCostForModelCount(brackets, 5), 90);
      expect(resolveCostForModelCount(brackets, 10), 90);
    });

    test('picks the exact bracket for the requested model count', () {
      const brackets = [
        CostBracket(modelCount: 5, points: 85),
        CostBracket(modelCount: 10, points: 160),
      ];
      expect(resolveCostForModelCount(brackets, 5), 85);
      expect(resolveCostForModelCount(brackets, 10), 160);
    });

    test('a real bracketed unit is NOT simply double at double the size', () {
      // Death Company Marines : 85 pts à 5 figurines, 160 pts à 10 — pas
      // 170, c'est exactement le genre de cas que le fix corrige.
      const brackets = [
        CostBracket(modelCount: 5, points: 85),
        CostBracket(modelCount: 10, points: 160),
      ];
      final atFive = resolveCostForModelCount(brackets, 5);
      final atTen = resolveCostForModelCount(brackets, 10);
      expect(atTen, isNot(atFive! * 2));
      expect(atTen, 160);
    });

    test('falls back to the closest lower bracket for an in-between count',
        () {
      const brackets = [
        CostBracket(modelCount: 3, points: 125),
        CostBracket(modelCount: 6, points: 260),
      ];
      expect(resolveCostForModelCount(brackets, 4), 125);
      expect(resolveCostForModelCount(brackets, 5), 125);
    });

    test('falls back to the smallest bracket when below all known sizes',
        () {
      const brackets = [
        CostBracket(modelCount: 5, points: 85),
        CostBracket(modelCount: 10, points: 160),
      ];
      expect(resolveCostForModelCount(brackets, 1), 85);
    });

    test('ignores unsized entries once sized brackets exist', () {
      const brackets = [
        CostBracket(modelCount: null, points: 999),
        CostBracket(modelCount: 5, points: 85),
        CostBracket(modelCount: 10, points: 160),
      ];
      expect(resolveCostForModelCount(brackets, 5), 85);
    });

    test('brackets do not need to be pre-sorted', () {
      const brackets = [
        CostBracket(modelCount: 10, points: 160),
        CostBracket(modelCount: 5, points: 85),
      ];
      expect(resolveCostForModelCount(brackets, 7), 85);
    });

    group('minCopyIndex (surcoût à partir de la Ne copie)', () {
      // Leman Russ : 185 pts pour les 2 premiers exemplaires, 195 pts à
      // partir du 3e (cas réel du MFM 11e édition).
      const brackets = [
        CostBracket(modelCount: 1, points: 185),
        CostBracket(modelCount: 1, points: 195, minCopyIndex: 3),
      ];

      test('uses the base price for the 1st and 2nd copy', () {
        expect(resolveCostForModelCount(brackets, 1, copyIndex: 1), 185);
        expect(resolveCostForModelCount(brackets, 1, copyIndex: 2), 185);
      });

      test('uses the surcharge price from the 3rd copy onward', () {
        expect(resolveCostForModelCount(brackets, 1, copyIndex: 3), 195);
        expect(resolveCostForModelCount(brackets, 1, copyIndex: 4), 195);
      });

      test('defaults to copyIndex 1 when not specified (backward compat)',
          () {
        expect(resolveCostForModelCount(brackets, 1), 185);
      });

      test('combines model-count brackets and copy-index brackets', () {
        // Escouade Aggressor : 80/165 pts pour les 2 premières unités,
        // 90/175 pts à partir de la 3e — les deux dimensions varient
        // indépendamment.
        const combined = [
          CostBracket(modelCount: 3, points: 80),
          CostBracket(modelCount: 6, points: 165),
          CostBracket(modelCount: 3, points: 90, minCopyIndex: 3),
          CostBracket(modelCount: 6, points: 175, minCopyIndex: 3),
        ];
        expect(resolveCostForModelCount(combined, 3, copyIndex: 1), 80);
        expect(resolveCostForModelCount(combined, 6, copyIndex: 2), 165);
        expect(resolveCostForModelCount(combined, 3, copyIndex: 3), 90);
        expect(resolveCostForModelCount(combined, 6, copyIndex: 5), 175);
      });

      test('a datasheet with no surcharge tier ignores copyIndex entirely',
          () {
        const flat = [
          CostBracket(modelCount: 5, points: 85),
          CostBracket(modelCount: 10, points: 160),
        ];
        expect(resolveCostForModelCount(flat, 5, copyIndex: 10), 85);
      });
    });
  });
}
