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

    expect(find.text('Bienvenue sur Wargame Board'), findsOneWidget);
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

  testWidgets('tapping the Armées dashboard card navigates to Army Builder',
      (tester) async {
    await tester.pumpWidget(_wrap(database));
    await tester.pumpAndSettle();

    // La carte "Armées" du dashboard (pas l'item de la sidebar).
    await tester.tap(find.text('Armées').last);
    await tester.pumpAndSettle();

    expect(find.text('Aucune armée pour l\'instant'), findsOneWidget);
  });
}
