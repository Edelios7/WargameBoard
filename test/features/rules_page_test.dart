import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/rules/pages/rules_page.dart';
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
        home: const RulesPage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('shows the recent documents and lets categories be filtered', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Missions Pack – Leviathan'), findsWidgets);

    await tester.tap(find.text('Missions'));
    await tester.pumpAndSettle();

    expect(find.text('Missions Pack – Leviathan'), findsWidgets);
    expect(find.text('Chapter Approved 2024'), findsNothing);
  });

  testWidgets(
    'opening the hero rulebook opens the in-app PDF viewer when the local file exists',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ouvrir le livre de règles'));
      // La résolution du fichier local est asynchrone (I/O) : on laisse le
      // temps à la promesse de se résoudre avant de vérifier la navigation,
      // sans pumpAndSettle pour ne pas attendre le rendu natif du PDF.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Warhammer 40,000 – Édition 11'), findsWidgets);
    },
  );

  testWidgets('Voir tout expands the recent documents list', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Voir tout'), findsWidgets);

    await tester.tap(find.text('Voir tout').first);
    await tester.pumpAndSettle();

    expect(find.text('Voir moins'), findsWidgets);
  });

  testWidgets('the filters toggle hides and shows the categories grid', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('TOUTES'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.text('TOUTES'), findsNothing);
  });

  testWidgets(
    'a help row item without real content shows a coming-soon message',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Vidéos explicatives'));
      await tester.pump();

      expect(
        find.text('Vidéos explicatives : pas encore disponible'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'picking a faction in the army lists guide reveals its list styles',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Exemples de listes'));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Exemples de listes d'armée").first);
      await tester.pumpAndSettle();

      // Aucune faction choisie au départ : pas de liste affichée.
      expect(find.text('Charge Écarlate'), findsNothing);

      await tester.tap(find.text('Blood Angels'));
      await tester.pumpAndSettle();

      expect(find.text('Charge Écarlate'), findsOneWidget);
      expect(find.text('Colonne Blindée du Sang'), findsOneWidget);
      expect(find.text('Rempart Sanguinaire'), findsOneWidget);
      expect(find.textContaining('pts'), findsWidgets);
    },
  );

  testWidgets(
    'opening the tactical guide document opens the interactive food chain page',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('La chaîne alimentaire des unités').first);
      await tester.pumpAndSettle();

      expect(find.text('Qui a l\'avantage ?'), findsOneWidget);
    },
  );

  testWidgets(
    'opening the combat simulator document opens the interactive simulator page',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Simulateur de combat').first);
      await tester.pumpAndSettle();

      expect(find.text('Lancer la simulation'), findsOneWidget);
    },
  );

  testWidgets(
    'the rules page renders without overflow on a phone-sized screen',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
