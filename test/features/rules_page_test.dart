import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/features/rules/pages/rules_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';

void main() {
  Widget wrap() {
    return MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const RulesPage(),
    );
  }

  testWidgets('shows the recent documents and lets categories be filtered',
      (tester) async {
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

  testWidgets('opening the hero rulebook shows the local PDF path',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ouvrir le livre de règles'));
    await tester.pump();

    expect(
      find.textContaining('local_assets/rules/warhammer-40000-core-rules.pdf'),
      findsOneWidget,
    );
  });

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

  testWidgets('the filters toggle hides and shows the categories grid',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('TOUTES'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();

    expect(find.text('TOUTES'), findsNothing);
  });

  testWidgets('a help row item without real content shows a coming-soon message',
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
  });

  testWidgets('the rules page renders without overflow on a phone-sized screen',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
