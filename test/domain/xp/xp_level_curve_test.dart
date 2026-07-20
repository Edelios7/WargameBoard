import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/xp/xp_level_curve.dart';

void main() {
  group('xpForLevel', () {
    test('level 1 requires 0 XP', () {
      expect(xpForLevel(1), 0);
    });

    test('is strictly increasing', () {
      for (var level = 1; level < 50; level++) {
        expect(xpForLevel(level + 1), greaterThan(xpForLevel(level)));
      }
    });
  });

  group('levelForXp', () {
    test('0 XP is level 1', () {
      expect(levelForXp(0).level, 1);
    });

    test('matches the threshold exactly at a level boundary', () {
      final threshold = xpForLevel(10);
      expect(levelForXp(threshold).level, 10);
    });

    test('one XP below a threshold stays at the previous level', () {
      final threshold = xpForLevel(10);
      expect(levelForXp(threshold - 1).level, 9);
    });

    test('progress is 0 at the start of a level and climbs toward 1', () {
      final progress = levelForXp(xpForLevel(5));
      expect(progress.progress, 0);

      final midway = levelForXp(
        xpForLevel(5) + ((xpForLevel(6) - xpForLevel(5)) ~/ 2),
      );
      expect(midway.progress, greaterThan(0));
      expect(midway.progress, lessThan(1));
    });
  });
}
