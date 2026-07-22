import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/database/tables/battle_unit_modifiers_table.dart';
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

  group('live battle tracking', () {
    test('startBattle creates a setup battle absent from history', () async {
      final id = await database.battleDao.startBattle(
        opponentName: 'Marc',
        pointsLimit: 2000,
      );

      final active = await database.battleDao.getActiveBattle();
      expect(active, isNotNull);
      expect(active!.id, id);
      expect(active.status, BattleStatus.setup);
      expect(active.currentRound, 1);
      expect(active.currentPhase, BattlePhase.command);
      expect(active.myCommandPoints, 0);

      final history = await database.battleDao.listBattles();
      expect(history, isEmpty);
    });

    test(
      'startBattle resolves both my army and the opponent army name',
      () async {
        final myArmyId = await database.armyDao.createArmy(
          name: 'Ma liste',
          factionId: seedFactionId,
        );
        final opponentArmyId = await database.armyDao.createArmy(
          name: 'Liste de Marc',
          factionId: seedFactionId,
        );

        await database.battleDao.startBattle(
          armyId: myArmyId,
          opponentArmyId: opponentArmyId,
        );

        final active = await database.battleDao.getActiveBattle();
        expect(active!.armyName, 'Ma liste');
        expect(active.opponentArmyId, opponentArmyId);
        expect(active.opponentArmyName, 'Liste de Marc');
      },
    );

    test('advancePhase walks through phases then bumps the round', () async {
      final id = await database.battleDao.startBattle(opponentName: 'Marc');

      for (final expected in [
        BattlePhase.movement,
        BattlePhase.shooting,
        BattlePhase.charge,
        BattlePhase.fight,
        BattlePhase.morale,
      ]) {
        await database.battleDao.advancePhase(id);
        final active = await database.battleDao.getActiveBattle();
        expect(active!.currentPhase, expected);
        expect(active.currentRound, 1);
        expect(active.status, BattleStatus.active);
      }

      await database.battleDao.advancePhase(id);
      final active = await database.battleDao.getActiveBattle();
      expect(active!.currentPhase, BattlePhase.command);
      expect(active.currentRound, 2);
    });

    test('logEvent records CP history readable via getEvents', () async {
      final id = await database.battleDao.startBattle(opponentName: 'Marc');

      await database.battleDao.updateLiveState(
        id,
        myCommandPoints: const Value(1),
      );
      await database.battleDao.logEvent(
        id,
        label: 'Rapid Ingress',
        cpDelta: -1,
        round: 2,
      );

      final events = await database.battleDao.getEvents(id);
      expect(events, hasLength(1));
      expect(events.single.label, 'Rapid Ingress');
      expect(events.single.cpDelta, -1);
    });

    test('finishBattle moves the battle into history', () async {
      final id = await database.battleDao.startBattle(opponentName: 'Marc');

      await database.battleDao.finishBattle(
        id,
        result: BattleResult.victory,
        myScore: 90,
        opponentScore: 60,
      );

      expect(await database.battleDao.getActiveBattle(), isNull);

      final history = await database.battleDao.listBattles();
      expect(history, hasLength(1));
      expect(history.single.status, BattleStatus.completed);
      expect(history.single.result, BattleResult.victory);
    });

    test('deleteBattle cascades to its events', () async {
      final id = await database.battleDao.startBattle(opponentName: 'Marc');
      await database.battleDao.logEvent(id, label: 'Captain détruit');

      await database.battleDao.deleteBattle(id);

      expect(await database.battleDao.getEvents(id), isEmpty);
    });
  });

  group('live unit tracking', () {
    Future<String> seedArmyUnit(AppDatabase database) async {
      final armyId = await database.armyDao.createArmy(
        name: 'Ma liste',
        factionId: seedFactionId,
      );
      final results = await database.datasheetDao.search('Captain');
      return database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: results.single.id,
        modelCount: 1,
      );
    }

    test(
      'setUnitDestroyed toggles a unit in and out of getUnitStates',
      () async {
        final battleId = await database.battleDao.startBattle(
          opponentName: 'Marc',
        );
        final armyUnitId = await seedArmyUnit(database);

        await database.battleDao.setUnitDestroyed(
          battleId,
          armyUnitId,
          destroyed: true,
        );
        var states = await database.battleDao.getUnitStates(battleId);
        expect(states.single.armyUnitId, armyUnitId);
        expect(states.single.destroyed, isTrue);

        await database.battleDao.setUnitDestroyed(
          battleId,
          armyUnitId,
          destroyed: false,
        );
        states = await database.battleDao.getUnitStates(battleId);
        expect(states, isEmpty);
      },
    );

    test('addUnitModifier and removeUnitModifier round-trip', () async {
      final battleId = await database.battleDao.startBattle(
        opponentName: 'Marc',
      );
      final armyUnitId = await seedArmyUnit(database);

      final modifierId = await database.battleDao.addUnitModifier(
        battleId,
        armyUnitId,
        statKey: BattleStatKey.toughness,
        delta: 1,
        label: 'Rite de guerre',
      );

      var modifiers = await database.battleDao.getUnitModifiers(battleId);
      expect(modifiers, hasLength(1));
      expect(modifiers.single.armyUnitId, armyUnitId);
      expect(modifiers.single.statKey, BattleStatKey.toughness);
      expect(modifiers.single.delta, 1);

      await database.battleDao.removeUnitModifier(modifierId);
      modifiers = await database.battleDao.getUnitModifiers(battleId);
      expect(modifiers, isEmpty);
    });
  });
}
