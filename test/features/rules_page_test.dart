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
}
