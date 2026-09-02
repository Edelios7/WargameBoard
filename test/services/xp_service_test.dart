import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/domain/xp/xp_category.dart';
import 'package:wargameboard/services/xp_service.dart';

void main() {
  late AppDatabase database;
  late XpService xpService;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    xpService = XpService(database);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'viewing the same datasheet repeatedly only credits lore XP once, '
    'instead of letting it be farmed by reopening the page',
    () async {
      final before = await database.xpDao.getCategoryTotals();
      final loreXpBefore = before[XpCategory.lore]!;

      await xpService.awardDatasheetViewed('ds-captain');

      final afterFirstView = await database.xpDao.getCategoryTotals();
      expect(afterFirstView[XpCategory.lore], greaterThan(loreXpBefore));

      // Rouvrir la même fiche (le scénario réel : navigation vers
      // DatasheetFullPage puis retour, répété) ne doit plus rien créditer.
      await xpService.awardDatasheetViewed('ds-captain');
      await xpService.awardDatasheetViewed('ds-captain');

      final afterRepeatedViews = await database.xpDao.getCategoryTotals();
      expect(
        afterRepeatedViews[XpCategory.lore],
        afterFirstView[XpCategory.lore],
      );
    },
  );

  test(
    'viewing two different datasheets credits lore XP for each of them',
    () async {
      final before = await database.xpDao.getCategoryTotals();
      final loreXpBefore = before[XpCategory.lore]!;

      await xpService.awardDatasheetViewed('ds-captain');
      final afterFirst = await database.xpDao.getCategoryTotals();

      await xpService.awardDatasheetViewed('ds-death-company-marines');
      final afterSecond = await database.xpDao.getCategoryTotals();

      expect(afterFirst[XpCategory.lore], greaterThan(loreXpBefore));
      expect(
        afterSecond[XpCategory.lore],
        greaterThan(afterFirst[XpCategory.lore]!),
      );
    },
  );
}
