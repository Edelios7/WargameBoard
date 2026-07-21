import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/models/cost_bracket.dart';

void main() {
  group('resolveCostForModelCount', () {
    test('returns 0 when there are no brackets', () {
      expect(resolveCostForModelCount(const [], 5), 0);
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
      expect(atTen, isNot(atFive * 2));
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
  });
}
