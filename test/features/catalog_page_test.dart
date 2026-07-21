import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/catalog/pages/catalog_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/providers/shared_preferences_provider.dart';

void main() {
  late AppDatabase database;
  late SharedPreferences prefs;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('selecting a datasheet in the list shows its detail panel',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CatalogPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sélectionnez une unité pour voir sa fiche'),
        findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Sanguinary');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sanguinary Guard'));
    await tester.pumpAndSettle();

    expect(find.text('Blood Angels'), findsWidgets);
    expect(find.textContaining('pts'), findsWidgets);
  });

  testWidgets('a unit already in the collection shows an owned badge',
      (tester) async {
    final results = await database.datasheetDao.search('Sanguinary Guard');
    await database.collectionDao.addEntry(
      datasheetId: results.single.id,
      quantity: 3,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CatalogPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Sanguinary');
    await tester.pumpAndSettle();

    expect(find.text('Possédé ×3'), findsOneWidget);
  });

  testWidgets(
      'picking a faction from quick access shows an active filter chip that clears it',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CatalogPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Blood Angels').first);
    await tester.pumpAndSettle();

    // Le chip de filtre actif apparaît avec le nom de la faction, et une
    // croix permet de le retirer sans rouvrir le menu déroulant.
    final chipFinder = find.ancestor(
      of: find.text('Blood Angels').last,
      matching: find.byType(Container),
    );
    expect(chipFinder, findsWidgets);

    await tester.tap(find.byIcon(Icons.close_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });
}
