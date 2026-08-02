import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/domain/xp/xp_category.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'two concurrent incrementCategory calls both apply, instead of the '
    'second one reading a stale pre-write total and net-ing only +1',
    () async {
      await Future.wait([
        database.xpDao.incrementCategory(XpCategory.painting, 5),
        database.xpDao.incrementCategory(XpCategory.painting, 5),
      ]);

      final totals = await database.xpDao.getCategoryTotals();
      expect(totals[XpCategory.painting], 10);
    },
  );

  test(
    'two concurrent incrementFaction calls both apply for the same faction',
    () async {
      await Future.wait([
        database.xpDao.incrementFaction(seedFactionId, 3),
        database.xpDao.incrementFaction(seedFactionId, 3),
      ]);

      final totals = await database.xpDao.getFactionTotals();
      expect(totals.singleWhere((t) => t.factionId == seedFactionId).xp, 6);
    },
  );

  test(
    'incrementCategory clamps the total at 0, never goes negative',
    () async {
      await database.xpDao.incrementCategory(XpCategory.assembly, 3);
      await database.xpDao.incrementCategory(XpCategory.assembly, -10);

      final totals = await database.xpDao.getCategoryTotals();
      expect(totals[XpCategory.assembly], 0);
    },
  );
}
