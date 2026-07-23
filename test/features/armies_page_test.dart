import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/armies/pages/armies_page.dart';
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
        home: const ArmiesPage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('creating an army from the dialog shows it in the list',
      (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Aucune armée pour l\'instant'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Ma première liste');
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    expect(find.text('Ma première liste'), findsWidgets);
    expect(find.textContaining('Blood Angels'), findsWidgets);
  });

  testWidgets('adding a unit updates the points total', (tester) async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: 'fac-blood-angels',
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Escouade test'));
    await tester.pumpAndSettle();

    expect(find.text('Aucune unité dans cette armée'), findsOneWidget);

    await tester.tap(find.text('Ajouter une unité'));
    await tester.pumpAndSettle();

    final captainTile = find.widgetWithText(ListTile, 'Captain');
    expect(captainTile, findsOneWidget);
    await tester.tap(
      find.descendant(
        of: captainTile,
        matching: find.byIcon(Icons.add_circle_rounded),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Captain'), findsWidgets);
    expect(find.textContaining('90 pts'), findsWidgets);

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.units, hasLength(1));
  });

  testWidgets('the quantity stepper adds several copies of a unit at once',
      (tester) async {
    final armyId = await database.armyDao.createArmy(
      name: 'Escouade test',
      factionId: 'fac-blood-angels',
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Escouade test'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter une unité'));
    await tester.pumpAndSettle();

    final captainTile = find.widgetWithText(ListTile, 'Captain');
    expect(captainTile, findsOneWidget);

    final incrementButton = find.descendant(
      of: captainTile,
      matching: find.byIcon(Icons.add_rounded),
    );
    await tester.tap(incrementButton);
    await tester.pump();
    await tester.tap(incrementButton);
    await tester.pump();

    expect(find.descendant(of: captainTile, matching: find.text('3')),
        findsOneWidget);

    await tester.tap(
      find.descendant(
        of: captainTile,
        matching: find.byIcon(Icons.add_circle_rounded),
      ),
    );
    await tester.pumpAndSettle();

    final army = await database.armyDao.getArmy(armyId);
    expect(army!.units, hasLength(3));
    expect(army.units.every((u) => u.datasheetId == army.units.first.datasheetId),
        isTrue);
  });

  testWidgets(
      'the armies page renders without overflow on a phone-sized screen',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final armyId = await database.armyDao.createArmy(
      name: 'Ma liste',
      factionId: 'fac-blood-angels',
    );
    final captain = await database.datasheetDao.search('Captain');
    await database.armyDao.addUnit(
      armyId: armyId,
      datasheetId: captain.single.id,
      modelCount: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ma liste'), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Ma liste').first);
    await tester.pumpAndSettle();

    expect(find.text('Captain'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
