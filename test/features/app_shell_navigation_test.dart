import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/shell/app_shell.dart';

Widget _wrap(AppDatabase database) {
  return ProviderScope(
    overrides: [databaseProvider.overrideWithValue(database)],
    child: MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    ),
  );
}

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('starts on the Dashboard and shows its cards', (tester) async {
    await tester.pumpWidget(_wrap(database));
    await tester.pumpAndSettle();

    expect(find.text('Bonjour !'), findsOneWidget);
    expect(find.text('Armées'), findsWidgets);
  });

  testWidgets('tapping a sidebar item switches the visible page',
      (tester) async {
    await tester.pumpWidget(_wrap(database));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catalogue').first);
    await tester.pumpAndSettle();

    expect(find.text('Rechercher une unité...'), findsOneWidget);
  });

  testWidgets('tapping the points stat tile navigates to Army Builder',
      (tester) async {
    await tester.pumpWidget(_wrap(database));
    await tester.pumpAndSettle();

    // La tuile "POINTS CUMULÉS" du dashboard (pas l'item de la sidebar).
    await tester.tap(find.text('POINTS CUMULÉS'));
    await tester.pumpAndSettle();

    expect(find.text('Aucune armée pour l\'instant'), findsOneWidget);
  });

  testWidgets(
      'on a phone-sized screen, the sidebar becomes a drawer opened from the AppBar',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_wrap(database));
    await tester.pumpAndSettle();

    // Pas de sidebar permanente à cette largeur, mais une AppBar avec le
    // titre de l'onglet actif et le bouton menu.
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(Drawer), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);

    // Sélectionner un item referme le tiroir — vérifié ici sur le
    // Dashboard lui-même (déjà audité pour ne pas déborder à cette
    // largeur) ; les autres pages ont leur propre test de largeur étroite
    // au fur et à mesure de leur passage en responsive.
    await tester.tap(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Dashboard'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
