import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/tables/battles_table.dart';
import 'package:wargameboard/domain/xp/xp_category.dart';
import 'package:wargameboard/repositories/battle_repository.dart';
import 'package:wargameboard/services/xp_service.dart';

void main() {
  late AppDatabase database;
  late BattleRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = BattleRepository(database, XpService(database));
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'deleting a logged battle revokes the XP it credited, instead of '
    'letting it be farmed by creating and deleting battles repeatedly',
    () async {
      final before = await database.xpDao.getCategoryTotals();
      final battleXpBefore = before[XpCategory.battle]!;

      final battleId = await repository.addBattle(
        opponentName: 'Marc',
        result: BattleResult.victory,
        type: BattleType.tournament,
      );

      final afterCreate = await database.xpDao.getCategoryTotals();
      expect(
        afterCreate[XpCategory.battle],
        greaterThan(battleXpBefore),
      );

      await repository.deleteBattle(battleId);

      final afterDelete = await database.xpDao.getCategoryTotals();
      expect(afterDelete[XpCategory.battle], battleXpBefore);

      // Le cycle créer/supprimer répété ne doit jamais laisser un résidu
      // d'XP : c'est exactement le farm que ce correctif empêche.
      final secondId = await repository.addBattle(
        opponentName: 'Marc',
        result: BattleResult.victory,
        type: BattleType.tournament,
      );
      await repository.deleteBattle(secondId);
      final afterSecondCycle = await database.xpDao.getCategoryTotals();
      expect(afterSecondCycle[XpCategory.battle], battleXpBefore);
    },
  );

  test(
    'deleting a live battle that was never finished does not revoke XP '
    'it never received',
    () async {
      final before = await database.xpDao.getCategoryTotals();
      final battleXpBefore = before[XpCategory.battle]!;

      final battleId = await database.battleDao.startBattle(
        opponentName: 'Marc',
      );
      // Toujours en "setup" : jamais passé par finishBattle, donc jamais
      // crédité d'XP.
      final afterStart = await database.xpDao.getCategoryTotals();
      expect(afterStart[XpCategory.battle], battleXpBefore);

      await repository.deleteBattle(battleId);

      final afterDelete = await database.xpDao.getCategoryTotals();
      expect(afterDelete[XpCategory.battle], battleXpBefore);
    },
  );
}
