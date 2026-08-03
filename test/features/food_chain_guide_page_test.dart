import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/domain/rules/rules_data.dart';
import 'package:wargameboard/features/rules/pages/food_chain_guide_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';

void main() {
  final document = kRuleDocuments.firstWhere(
    (d) => d.id == 'guide-chaine-alimentaire',
  );

  Widget wrap() {
    return ProviderScope(
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: FoodChainGuidePage(document: document),
      ),
    );
  }

  testWidgets('picking two different archetypes shows who has the advantage',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Avantage : Blindé / Monstre'), findsNothing);

    await tester.tap(find.text('Horde').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blindé / Monstre').last);
    await tester.pumpAndSettle();

    expect(find.text('Avantage : Blindé / Monstre'), findsOneWidget);
  });

  testWidgets('picking the same archetype twice shows a balanced verdict',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Élite').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Élite').last);
    await tester.pumpAndSettle();

    expect(find.text('Équilibré'), findsOneWidget);
  });

  testWidgets('the reference sections are collapsed by default', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text("Les grands rôles d'unité"), findsOneWidget);
    expect(
      find.textContaining('Anti-infanterie : cadence de tir'),
      findsNothing,
    );
  });

  testWidgets(
    'the food chain guide renders without overflow on a phone-sized screen',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    },
  );
}
