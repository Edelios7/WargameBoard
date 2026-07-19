import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/database/tables/battles_table.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('logging a battle with an army surfaces the army name', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Ma liste',
      factionId: seedFactionId,
    );

    await database.battleDao.addBattle(
      armyId: armyId,
      opponentName: 'Marc',
      missionName: 'Purge encombrante',
      result: BattleResult.victory,
      myScore: 90,
      opponentScore: 75,
    );

    final battles = await database.battleDao.listBattles();

    expect(battles, hasLength(1));
    expect(battles.single.armyName, 'Ma liste');
    expect(battles.single.opponentName, 'Marc');
    expect(battles.single.result, BattleResult.victory);
  });

  test('battles are ordered from most recent to oldest', () async {
    await database.battleDao.addBattle(
      opponentName: 'Ancienne partie',
      result: BattleResult.defeat,
      playedAt: DateTime(2025, 1, 1),
    );
    await database.battleDao.addBattle(
      opponentName: 'Partie récente',
      result: BattleResult.victory,
      playedAt: DateTime(2026, 1, 1),
    );

    final battles = await database.battleDao.listBattles();

    expect(battles.first.opponentName, 'Partie récente');
    expect(battles.last.opponentName, 'Ancienne partie');
  });

  test('deleteBattle removes the entry', () async {
    await database.battleDao.addBattle(opponentName: 'À supprimer');
    final battles = await database.battleDao.listBattles();

    await database.battleDao.deleteBattle(battles.single.id);

    final remaining = await database.battleDao.listBattles();
    expect(remaining, isEmpty);
  });
}
