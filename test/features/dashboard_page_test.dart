import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/features/dashboard/pages/dashboard_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/army_provider.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/shell/navigation.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  Widget wrap() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const DashboardPage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(database)],
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  testWidgets('tapping an army card selects it and switches to the Armies tab',
      (tester) async {
    final armyId = await database.armyDao.createArmy(
      name: 'Ma liste',
      factionId: seedFactionId,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Ma liste'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ma liste'));
    await tester.pumpAndSettle();

    expect(container.read(selectedTabProvider), AppTab.armies);
    expect(container.read(selectedArmyIdProvider), armyId);
  });

  testWidgets('tapping a recently added entry opens its datasheet page',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Captain').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Captain').first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
  });
}
