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

  Widget wrap(AppDatabase database, SharedPreferences prefs) {
    return ProviderScope(
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
    );
  }

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await database.close();
  });

  group('desktop layout (3 colonnes)', () {
    // En dessous de 900px de large, la page bascule sur le flux mobile
    // (liste puis fiche en plein écran) — ces tests visent la disposition
    // filtres/résultats/aperçu côte à côte, donc un viewport large explicite.

    testWidgets('selecting a datasheet in the list shows its detail panel',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(database, prefs));
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
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final results = await database.datasheetDao.search('Sanguinary Guard');
      await database.collectionDao.addEntry(
        datasheetId: results.single.id,
        quantity: 3,
      );

      await tester.pumpWidget(wrap(database, prefs));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Sanguinary');
      await tester.pumpAndSettle();

      expect(find.text('Possédé ×3'), findsOneWidget);
    });

    testWidgets(
        'picking a faction from quick access shows an active filter chip that clears it',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(database, prefs));
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

    testWidgets(
        'starring a datasheet and toggling favorites-only narrows the list to it',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(database, prefs));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Sanguinary');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.star_outline_rounded).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_rounded), findsOneWidget);

      // Une autre fiche, jamais mise en favori, ne l'est pas devenue par
      // accident (l'état est bien par fiche, pas global).
      await tester.enterText(find.byType(TextField).first, 'Captain');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star_rounded), findsNothing);
      expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);

      // Basculer "favoris uniquement" réduit la liste à la fiche mise en
      // favori, même avec une recherche ne la ciblant pas.
      await tester.enterText(find.byType(TextField).first, '');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.filter_alt_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Sanguinary Guard'), findsOneWidget);
      expect(find.text('Captain'), findsNothing);
    });
  });

  testWidgets(
      'on a phone-sized screen, selecting a result opens its full-screen sheet',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(wrap(database, prefs));
    await tester.pumpAndSettle();

    // Pas de panneau d'aperçu à cette largeur — juste la liste, avec les
    // filtres derrière un bouton plutôt qu'une colonne toujours visible.
    expect(
      find.text('Sélectionnez une unité pour voir sa fiche'),
      findsNothing,
    );
    expect(tester.takeException(), isNull);

    await tester.enterText(find.byType(TextField).first, 'Sanguinary');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sanguinary Guard'));
    await tester.pumpAndSettle();

    // La fiche s'ouvre en plein écran (bouton retour) plutôt que dans un
    // panneau latéral.
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Blood Angels'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
