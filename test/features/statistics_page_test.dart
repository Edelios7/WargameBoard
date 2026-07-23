import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/database/tables/battles_table.dart';
import 'package:wargameboard/features/statistics/pages/statistics_page.dart';
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
        home: const StatisticsPage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('shows empty state when there is no data yet', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('0'), findsWidgets);
    expect(find.text('Pas encore d\'armée créée'), findsOneWidget);
  });

  testWidgets('reflects real army and collection data', (tester) async {
    final armyId = await database.armyDao.createArmy(
      name: 'Ma liste',
      factionId: seedFactionId,
    );
    final captain = await database.datasheetDao.search('Captain');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captain.single.id,
      modelCount: 1,
    );
    final entryId = await database.collectionDao.addEntry(
      datasheetId: captain.single.id,
      quantity: 3,
    );
    await database.collectionDao.updateCounts(entryId, painted: 2);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ma liste'), findsOneWidget);
    expect(find.text('90 pts'), findsOneWidget);
    expect(find.text('3'), findsOneWidget); // figurines en collection
    expect(find.text('2'), findsOneWidget); // figurines peintes
  });

  testWidgets(
      'battles feed the recent form strip and the breakdown donuts',
      (tester) async {
    await database.battleDao.addBattle(
      opponentName: 'Marc',
      opponentFactionId: seedOrksFactionId,
      result: BattleResult.victory,
      playedAt: DateTime(2026, 1, 1),
    );
    await database.battleDao.addBattle(
      opponentName: 'Julie',
      opponentFactionId: seedOrksFactionId,
      result: BattleResult.defeat,
      playedAt: DateTime(2026, 1, 5),
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('VICTOIRES / DÉFAITES / NULS'), findsOneWidget);
    expect(find.text('PARTIES PAR FACTION ADVERSE'), findsOneWidget);
    expect(find.textContaining('Orks'), findsWidgets);
    expect(find.byType(Tooltip), findsWidgets);
  });

  testWidgets(
      'the statistics page renders without overflow on a phone-sized screen',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final armyId = await database.armyDao.createArmy(
      name: 'Ma liste',
      factionId: seedFactionId,
    );
    final captain = await database.datasheetDao.search('Captain');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captain.single.id,
      modelCount: 1,
    );
    await database.battleDao.addBattle(
      opponentName: 'Marc',
      opponentFactionId: seedOrksFactionId,
      result: BattleResult.victory,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ma liste'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
