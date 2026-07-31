import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/detachment_seed.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/services/army_validation_service.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creating an army and adding units computes correct total points',
      () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Ma première liste',
      factionId: seedFactionId,
    );

    final searchResults = await database.datasheetDao.search('Captain');
    final captainId = searchResults.single.id;

    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captainId,
      modelCount: 1,
    );

    final army = await database.armyDao.getArmy(armyId);

    expect(army, isNotNull);
    expect(army!.name, 'Ma première liste');
    expect(army.factionName, 'Blood Angels');
    expect(army.units, hasLength(1));
    expect(army.units.single.datasheetName, 'Captain');
    expect(army.totalPoints, greaterThan(0));
    expect(army.totalPoints, army.units.single.points);
  });

  test('listArmies returns totals matching getArmy', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Sanguinary');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 3,
    );

    final list = await database.armyDao.listArmies();
    final detail = await database.armyDao.getArmy(armyId);

    expect(list, hasLength(1));
    expect(list.single.totalPoints, detail!.totalPoints);
  });

  test('removing a unit updates the army total', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Death Company');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 5,
    );

    await database.armyDao.removeUnit(unitId);

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.units, isEmpty);
    expect(army.totalPoints, 0);
  });

  test(
      'points reflect the bracket for the chosen model count, not a linear scale',
      () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Death Company');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 5,
    );

    final atFive = await database.armyDao.getArmy(armyId);
    expect(atFive!.units.single.datasheetPoints, 85);
    expect(atFive.totalPoints, 85);

    await database.armyDao.updateModelCount(unitId, 10);

    final atTen = await database.armyDao.getArmy(armyId);
    expect(atTen!.units.single.datasheetPoints, 160);
    expect(atTen.totalPoints, 160);
    // Le coût à 10 figurines n'est pas un simple doublement de celui à 5.
    expect(atTen.totalPoints, isNot(atFive.totalPoints * 2));
  });

  test('updateModelCount clamps to the datasheet min/max range', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final results = await database.datasheetDao.search('Death Company');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 5,
    );

    final tooHigh = await database.armyDao.updateModelCount(unitId, 99);
    expect(tooHigh, 10);

    final tooLow = await database.armyDao.updateModelCount(unitId, 1);
    expect(tooLow, 5);
  });

  test('isOverLimit reflects the army points limit', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Liste limitée',
      factionId: seedFactionId,
      pointsLimit: 50,
    );
    final results = await database.datasheetDao.search('Captain');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 1,
    );

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.pointsLimit, 50);
    expect(army.isOverLimit, isTrue);
  });

  test('detachment and enhancement points are included in the total',
      () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Liste avec détachement',
      factionId: seedFactionId,
      detachmentId: detAngelicHost,
    );
    final results = await database.datasheetDao.search('Captain');
    final unitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: results.single.id,
      modelCount: 1,
    );

    final beforeEnhancement = await database.armyDao.getArmy(armyId);
    final basePoints = beforeEnhancement!.totalPoints;

    await database.armyDao.setUnitEnhancement(unitId, enhDeathVisions);

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.detachmentName, 'Angelic Host');
    expect(army.units.single.enhancementName, 'Death Visions of Sanguinius');
    expect(army.units.single.enhancementPoints, 25);
    expect(army.totalPoints, basePoints + 25);

    final detachments =
        await database.armyDao.getDetachmentsForFaction(seedFactionId);
    expect(detachments.map((d) => d.id), contains(detAngelicHost));

    final options =
        await database.armyDao.getEnhancementsForDetachment(detAngelicHost);
    expect(options, hasLength(3));
  });

  test('stratagems are listed for a detachment, ordered by command points',
      () async {
    final stratagems =
        await database.armyDao.getStratagemsForDetachment(detAngelicHost);

    expect(stratagems, hasLength(3));
    expect(stratagems.map((s) => s.name), contains('Wings of Fire'));
    for (var i = 1; i < stratagems.length; i++) {
      expect(
        stratagems[i].commandPoints,
        greaterThanOrEqualTo(stratagems[i - 1].commandPoints),
      );
    }
  });

  test('updateNotes sets and clears the army notes', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Liste avec notes',
      factionId: seedFactionId,
    );

    await database.armyDao.updateNotes(armyId, 'Prévoir un plan B contre les chars.');
    var army = await database.armyDao.getArmy(armyId);
    expect(army!.notes, 'Prévoir un plan B contre les chars.');

    await database.armyDao.updateNotes(armyId, null);
    army = await database.armyDao.getArmy(armyId);
    expect(army!.notes, isNull);
  });

  test(
    'deleteArmy also clears battle state tied to its units and unlinks '
    'past battles, instead of leaving orphaned rows',
    () async {
      final armyId = await database.armyDao.createArmy(
        name: 'Liste temporaire',
        factionId: seedFactionId,
      );
      final results = await database.datasheetDao.search('Captain');
      final unitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: results.single.id,
        modelCount: 1,
      );

      final battleId = await database.battleDao.startBattle(
        armyId: armyId,
        opponentName: 'Marc',
      );
      await database.battleDao.setUnitDestroyed(
        battleId,
        unitId,
        destroyed: true,
      );

      await database.armyDao.deleteArmy(armyId);

      expect(await database.armyDao.getArmy(armyId), isNull);
      expect(await database.battleDao.getUnitStates(battleId), isEmpty);

      // La partie (toujours en "setup") reste en base, mais ne référence
      // plus l'armée supprimée.
      final battle = await database.battleDao.getActiveBattle();
      expect(battle, isNotNull);
      expect(battle!.id, battleId);
      expect(battle.armyId, isNull);
      expect(battle.armyName, isNull);
    },
  );

  test(
    'hasValidationErrors reflects both the points limit and the '
    'enhancement-count rule, in the list summary too',
    () async {
      final armyId = await database.armyDao.createArmy(
        name: 'Liste avec détachement',
        factionId: seedFactionId,
        detachmentId: detAngelicHost,
      );
      final results = await database.datasheetDao.search('Captain');
      final unitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: results.single.id,
        modelCount: 1,
      );
      await database.armyDao.setUnitEnhancement(unitId, enhDeathVisions);

      final beforeLimitBreak = await database.armyDao.listArmies();
      expect(beforeLimitBreak.single.enhancementsCount, 1);
      expect(beforeLimitBreak.single.hasValidationErrors, isFalse);
    },
  );

  test(
    'a datasheet with no cost bracket data resolves to an unknown cost, '
    'not a free 0 pt — and is flagged instead of silently deflating the '
    'army total',
    () async {
      const noCostDatasheetId = 'ds-no-cost-data';
      await database.into(database.datasheets).insert(
            DatasheetsCompanion.insert(
              id: noCostDatasheetId,
              factionId: seedFactionId,
              name: 'Fiche sans données de coût',
              battlefieldRole: 'Troops',
              unitType: 'Infantry',
            ),
          );

      final armyId = await database.armyDao.createArmy(
        name: 'Liste avec fiche incomplète',
        factionId: seedFactionId,
      );
      final captainResults = await database.datasheetDao.search('Captain');
      await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: captainResults.single.id,
        modelCount: 1,
      );
      await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: noCostDatasheetId,
        modelCount: 1,
      );

      final army = await database.armyDao.getArmy(armyId);
      final noCostUnit =
          army!.units.firstWhere((u) => u.datasheetId == noCostDatasheetId);

      expect(noCostUnit.datasheetPoints, isNull);
      expect(noCostUnit.hasUnknownCost, isTrue);
      expect(noCostUnit.points, 0);
      expect(army.hasUnitsWithUnknownCost, isTrue);
      // Le total reste la somme des coûts connus (celui du Captain), pas 0
      // ni une erreur : seule l'unité sans donnée est signalée à part.
      expect(army.totalPoints, greaterThan(0));

      final list = await database.armyDao.listArmies();
      expect(list.single.hasUnknownCost, isTrue);

      const validationService = ArmyValidationService();
      final validation = validationService.validate(army);
      expect(
        validation.warnings,
        contains(ArmyValidationIssue.unknownUnitCosts),
      );
    },
  );

  test('getArmy flags Character datasheets via isCharacter', () async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: seedFactionId,
    );
    final captain = await database.datasheetDao.search('Captain');
    final squad = await database.datasheetDao.search('Death Company');
    final captainUnitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captain.single.id,
      modelCount: 1,
    );
    final squadUnitId = await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: squad.single.id,
      modelCount: 5,
    );

    final army = await database.armyDao.getArmy(armyId);
    final captainUnit =
        army!.units.firstWhere((u) => u.id == captainUnitId);
    final squadUnit = army.units.firstWhere((u) => u.id == squadUnitId);

    expect(captainUnit.isCharacter, isTrue);
    expect(squadUnit.isCharacter, isFalse);
  });

  test(
    'attachCharacter links a Character unit to another unit of the same '
    'army, resolved back with its display name; detachCharacter clears it',
    () async {
      final armyId = await database.armyDao.createArmy(
        name: 'Escouade test',
        factionId: seedFactionId,
      );
      final captain = await database.datasheetDao.search('Captain');
      final squad = await database.datasheetDao.search('Death Company');
      final captainUnitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: captain.single.id,
        modelCount: 1,
      );
      final squadUnitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: squad.single.id,
        modelCount: 5,
      );

      await database.armyDao.attachCharacter(captainUnitId, squadUnitId);

      final attached = await database.armyDao.getArmy(armyId);
      final captainUnit =
          attached!.units.firstWhere((u) => u.id == captainUnitId);
      expect(captainUnit.attachedToUnitId, squadUnitId);
      expect(captainUnit.attachedToUnitName, 'Death Company Marines');
      expect(
        attached.leadersAttachedTo(squadUnitId).map((u) => u.id),
        [captainUnitId],
      );

      await database.armyDao.detachCharacter(captainUnitId);

      final detached = await database.armyDao.getArmy(armyId);
      final detachedCaptain =
          detached!.units.firstWhere((u) => u.id == captainUnitId);
      expect(detachedCaptain.attachedToUnitId, isNull);
      expect(detached.leadersAttachedTo(squadUnitId), isEmpty);
    },
  );

  test(
    'removing the host unit detaches any Character that was attached to '
    'it, instead of leaving a dangling reference',
    () async {
      final armyId = await database.armyDao.createArmy(
        name: 'Escouade test',
        factionId: seedFactionId,
      );
      final captain = await database.datasheetDao.search('Captain');
      final squad = await database.datasheetDao.search('Death Company');
      final captainUnitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: captain.single.id,
        modelCount: 1,
      );
      final squadUnitId = await database.armyDao.addUnit(
        armyId: armyId,
        datasheetId: squad.single.id,
        modelCount: 5,
      );
      await database.armyDao.attachCharacter(captainUnitId, squadUnitId);

      await database.armyDao.removeUnit(squadUnitId);

      final army = await database.armyDao.getArmy(armyId);
      expect(army!.units, hasLength(1));
      expect(army.units.single.id, captainUnitId);
      expect(army.units.single.attachedToUnitId, isNull);
    },
  );
}
