import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/detachment_seed.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/features/battle/pages/battle_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';

void main() {
  late AppDatabase database;

  Widget wrap() {
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const BattlePage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('logging a past battle shows it in the history', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Aucune partie enregistrée'), findsOneWidget);

    await tester.tap(find.text('Enregistrer une partie déjà jouée'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Marc');
    await tester.ensureVisible(find.text('Créer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    expect(find.text('Marc'), findsOneWidget);
    expect(find.text('Victoire'), findsOneWidget);
  });

  testWidgets('starting a new battle shows the live dashboard', (tester) async {
    tester.view.physicalSize = const Size(900, 1100);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Nouvelle partie'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Marc');
    await tester.ensureVisible(find.text('Lancer la partie'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lancer la partie'));
    await tester.pumpAndSettle();

    expect(find.text('Marc'), findsOneWidget);
    expect(find.text('Round 1'), findsOneWidget);
    expect(find.text('Commandement'), findsOneWidget);

    // The battle in progress isn't in the history yet.
    expect(find.text('Aucune partie enregistrée'), findsNothing);
  });

  testWidgets('tapping a past battle opens its read-only recap', (
    tester,
  ) async {
    await database.battleDao.addBattle(
      opponentName: 'Julie',
      notes: 'Le Land Raider a perdu 4 PV.',
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Julie'));
    await tester.pumpAndSettle();

    expect(find.text('Récapitulatif de la partie'), findsOneWidget);
    expect(find.text('Le Land Raider a perdu 4 PV.'), findsOneWidget);
  });

  testWidgets(
    'the stratagem assistant surfaces phase-relevant stratagems and spending CP logs an event',
    (tester) async {
      tester.view.physicalSize = const Size(1100, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final armyId = await database.armyDao.createArmy(
        name: 'Ma liste',
        factionId: seedFactionId,
        detachmentId: detAngelicHost,
      );
      final battleId = await database.battleDao.startBattle(armyId: armyId);
      // command -> movement -> shooting -> charge -> fight.
      for (var i = 0; i < 4; i++) {
        await database.battleDao.advancePhase(battleId);
      }
      await database.battleDao.updateLiveState(
        battleId,
        myCommandPoints: const Value(2),
      );

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      // Combat-phase and any-phase stratagems show up; movement-only doesn't.
      expect(find.text('No Escape'), findsOneWidget);
      expect(find.text('Honour the Chapter'), findsOneWidget);
      expect(find.text('Wings of Fire'), findsNothing);

      await tester.tap(find.text('No Escape'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Utiliser (-1 PC)'));
      await tester.pumpAndSettle();

      // The CP spend is logged in the battle events journal.
      expect(find.text('-1 CP'), findsOneWidget);
    },
  );

  testWidgets(
    'advancing past the last phase of a round shows the end-of-round reminder',
    (tester) async {
      final battleId = await database.battleDao.startBattle(
        opponentName: 'Marc',
      );
      // command -> movement -> shooting -> charge -> fight -> morale.
      for (var i = 0; i < 5; i++) {
        await database.battleDao.advancePhase(battleId);
      }

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(find.text('Fin de round'), findsNothing);

      await tester.tap(find.text('Phase suivante'));
      await tester.pumpAndSettle();

      expect(find.text('Fin de round'), findsOneWidget);
      expect(find.text('Round 2'), findsOneWidget);

      await tester.tap(find.text('Compris'));
      await tester.pumpAndSettle();

      expect(find.text('Fin de round'), findsNothing);
    },
  );

  testWidgets('deleting a battle removes it from the history', (tester) async {
    await database.battleDao.addBattle(opponentName: 'Julie');

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Julie'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Julie'), findsNothing);
    expect(find.text('Aucune partie enregistrée'), findsOneWidget);
  });
}
