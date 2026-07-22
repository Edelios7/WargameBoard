import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
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

  testWidgets('logging a past battle shows it in the history', (
    tester,
  ) async {
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

  testWidgets('starting a new battle shows the live dashboard', (
    tester,
  ) async {
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
