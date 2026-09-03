import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
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

    testWidgets('selecting a datasheet in the list shows its detail panel', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap(database, prefs));
      await tester.pumpAndSettle();

      expect(
        find.text('Sélectionnez une unité pour voir sa fiche'),
        findsOneWidget,
      );

      await tester.enterText(find.byType(TextField).first, 'Sanguinary');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sanguinary Guard'));
      await tester.pumpAndSettle();

      expect(find.text('Blood Angels'), findsWidgets);
      expect(find.textContaining('pts'), findsWidgets);
    });

    testWidgets('a unit already in the collection shows an owned badge', (
      tester,
    ) async {
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
      },
    );

    testWidgets(
      '"Réinitialiser" also clears the search text, not just the filter chips',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(wrap(database, prefs));
        await tester.pumpAndSettle();

        // Une recherche texte + un filtre de faction, tous les deux actifs.
        await tester.enterText(find.byType(TextField).first, 'Sanguinary');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Blood Angels').first);
        await tester.pumpAndSettle();

        expect(find.text('Sanguinary'), findsOneWidget);

        await tester.tap(find.text('Réinitialiser'));
        await tester.pumpAndSettle();

        // Le texte tapé a bien disparu de la barre de recherche, pas
        // seulement les filtres — sinon la liste resterait filtrée par un
        // texte qu'on ne voit plus.
        expect(find.text('Sanguinary'), findsNothing);
      },
    );

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
      },
    );

    testWidgets(
      'a model with an invulnerable save shows an extra stat box for it, '
      'unlike a model without one',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        const datasheetId = 'ds-test-invuln-preview';
        await database
            .into(database.datasheets)
            .insert(
              DatasheetsCompanion.insert(
                id: datasheetId,
                factionId: seedFactionId,
                name: 'Porteuse de Bouclier de Test',
                battlefieldRole: 'HQ',
                unitType: 'Infantry',
              ),
            );
        await database
            .into(database.datasheetModels)
            .insert(
              DatasheetModelsCompanion.insert(
                id: 'dm-test-invuln-preview',
                datasheetId: datasheetId,
                name: 'Porteuse de Bouclier de Test',
              ),
            );
        await database
            .into(database.modelProfiles)
            .insert(
              ModelProfilesCompanion.insert(
                id: 'mp-test-invuln-preview',
                datasheetModelId: 'dm-test-invuln-preview',
                name: 'Porteuse de Bouclier de Test',
                movement: 6,
                toughness: 4,
                save: 3,
                wounds: 4,
                leadership: 6,
                objectiveControl: 1,
                invulnerableSave: const Value(4),
              ),
            );

        await tester.pumpWidget(wrap(database, prefs));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'Bouclier de Test',
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Porteuse de Bouclier de Test'));
        await tester.pumpAndSettle();

        expect(find.text('Sauv. Invul.'), findsOneWidget);
        expect(find.text('4+'), findsOneWidget);

        // Une autre fiche sans sauvegarde invulnérable n'affiche pas la case
        // — l'absence de donnée doit rester invisible plutôt qu'afficher un
        // "null+" ou une case vide trompeuse.
        await tester.enterText(find.byType(TextField).first, 'Captain');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Captain').last);
        await tester.pumpAndSettle();

        expect(find.text('Sauv. Invul.'), findsNothing);
      },
    );

    testWidgets(
      'the detail panel opens on the Fiche tab, and the Historique tab '
      'reaches the battle-history empty state for a datasheet never used '
      'in a battle',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(wrap(database, prefs));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'Sanguinary');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sanguinary Guard'));
        await tester.pumpAndSettle();

        // Onglet Fiche affiché par défaut : le bloc Informations y est
        // (les titres de section sont affichés en majuscules, voir _section).
        expect(find.text('INFORMATIONS'), findsOneWidget);

        await tester.tap(find.text('Historique'));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Aucune partie enregistrée avec cette fiche pour '
            'l\'instant.',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'a datasheet with no abilities and no weapons/equipment shows a '
      "dedicated empty message on each tab, not an empty header-only "
      'table or the wrong per-ability placeholder text',
      (tester) async {
        tester.view.physicalSize = const Size(1400, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        const datasheetId = 'ds-test-bare';
        await database
            .into(database.datasheets)
            .insert(
              DatasheetsCompanion.insert(
                id: datasheetId,
                factionId: seedFactionId,
                name: 'Fiche Dépouillée De Test',
                battlefieldRole: 'HQ',
                unitType: 'Infantry',
              ),
            );
        await database
            .into(database.datasheetModels)
            .insert(
              DatasheetModelsCompanion.insert(
                id: 'dm-test-bare',
                datasheetId: datasheetId,
                name: 'Fiche Dépouillée De Test',
              ),
            );
        await database
            .into(database.modelProfiles)
            .insert(
              ModelProfilesCompanion.insert(
                id: 'mp-test-bare',
                datasheetModelId: 'dm-test-bare',
                name: 'Fiche Dépouillée De Test',
                movement: 6,
                toughness: 4,
                save: 3,
                wounds: 4,
                leadership: 6,
                objectiveControl: 1,
              ),
            );

        await tester.pumpWidget(wrap(database, prefs));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'Dépouillée');
        await tester.pumpAndSettle();
        await tester.tap(find.text('Fiche Dépouillée De Test'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Équipement'));
        await tester.pumpAndSettle();
        expect(
          find.text('Cette fiche n\'a ni arme ni équipement.'),
          findsOneWidget,
        );
        // Pas de tableau réduit à sa seule ligne d'en-tête ("Arme"/"Portée"...)
        // affiché à la place d'un vrai message.
        expect(find.text('Arme'), findsNothing);

        await tester.tap(find.text('Capacités'));
        await tester.pumpAndSettle();
        expect(
          find.text('Cette fiche n\'a aucune capacité particulière.'),
          findsOneWidget,
        );
        // Pas le texte de repli pensé pour une aptitude individuelle sans
        // description, qui n'a pas de sens ici (aucune aptitude du tout).
        expect(find.textContaining('Règle propre à la faction'), findsNothing);
      },
    );
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
      // Fil d'Ariane Catalogue › Faction › Unité, pour situer la fiche sans
      // avoir à deviner d'où on vient.
      expect(find.text('Catalogue'), findsOneWidget);
      expect(find.text('Sanguinary Guard'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
