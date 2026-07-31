import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/widgets/app_card.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/domain/rules/rules_data.dart';
import 'package:wargameboard/features/rules/pages/combat_simulator_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';

void main() {
  late AppDatabase database;

  Widget wrap() {
    final document = kRuleDocuments.firstWhere(
      (d) => d.id == 'simulateur-de-combat',
    );
    return ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CombatSimulatorPage(document: document),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets(
    'picking an attacker weapon and a defender then running the '
    'simulation shows a result card',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1400, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(find.text('Simulateur de combat'), findsOneWidget);

      // Attaquant : faction -> unité -> arme (via les zones à clé stable,
      // pour ne pas dépendre du nombre exact de factions/unités/armes
      // présentes dans les données de test).
      final attackerFactions = find.byKey(
        const ValueKey('Attaquant-faction-choices'),
      );
      await tester.tap(
        find.descendant(of: attackerFactions, matching: find.text('Blood Angels')),
      );
      await tester.pumpAndSettle();

      final attackerUnits = find.byKey(
        const ValueKey('Attaquant-unit-choices'),
      );
      await tester.tap(
        find.descendant(of: attackerUnits, matching: find.text('Captain')),
      );
      await tester.pumpAndSettle();

      final attackerWeapons = find.byKey(
        const ValueKey('Attaquant-weapon-choices'),
      );
      await tester.tap(
        find.descendant(of: attackerWeapons, matching: find.byType(AppCard)).first,
      );
      await tester.pumpAndSettle();

      // Défenseur : faction -> unité.
      final defenderFactions = find.byKey(
        const ValueKey('Défenseur-faction-choices'),
      );
      await tester.tap(
        find.descendant(of: defenderFactions, matching: find.text('Blood Angels')),
      );
      await tester.pumpAndSettle();

      final defenderUnits = find.byKey(
        const ValueKey('Défenseur-unit-choices'),
      );
      await tester.tap(
        find.descendant(
          of: defenderUnits,
          matching: find.text('Death Company Marines'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('x100'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lancer la simulation'));
      await tester.pumpAndSettle();

      expect(find.text('Résultats'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'the combat simulator page renders without overflow on a phone-sized screen',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
