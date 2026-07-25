import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/domain/xp/xp_category.dart';
import 'package:wargameboard/repositories/army_repository.dart';
import 'package:wargameboard/services/xp_service.dart';

void main() {
  late AppDatabase database;
  late ArmyRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ArmyRepository(database, XpService(database));
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'deleting and recreating an army does not re-award the '
    'first-army XP bonus',
    () async {
      final firstId = await repository.createArmy(
        name: 'Première liste',
        factionId: seedFactionId,
      );
      final afterFirst = await database.xpDao.getCategoryTotals();
      final collectionXpAfterFirst = afterFirst[XpCategory.collection]!;
      expect(collectionXpAfterFirst, greaterThan(0));

      await repository.deleteArmy(firstId);
      await repository.createArmy(
        name: 'Deuxième liste',
        factionId: seedFactionId,
      );

      final afterSecond = await database.xpDao.getCategoryTotals();
      expect(
        afterSecond[XpCategory.collection],
        collectionXpAfterFirst,
      );
    },
  );
}
