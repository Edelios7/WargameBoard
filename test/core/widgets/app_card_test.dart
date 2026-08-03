import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/theme/block_overrides.dart';
import 'package:wargameboard/core/widgets/app_card.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/customization_provider.dart';

void main() {
  tearDown(() => BlockOverrides.clearAll());

  Widget wrap({required bool customizationMode, String? customizationId}) {
    return ProviderScope(
      overrides: [
        customizationModeProvider.overrideWith((ref) => customizationMode),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AppCard(
            customizationId: customizationId,
            child: const Text('Contenu'),
          ),
        ),
      ),
    );
  }

  testWidgets('shows no edit badge outside customization mode', (tester) async {
    await tester.pumpWidget(
      wrap(customizationMode: false, customizationId: 'dashboard.test'),
    );

    expect(find.byIcon(Icons.palette_outlined), findsNothing);
  });

  testWidgets(
    'shows no edit badge in customization mode without a customizationId '
    '(dynamically generated list cards must never offer one)',
    (tester) async {
      await tester.pumpWidget(wrap(customizationMode: true));

      expect(find.byIcon(Icons.palette_outlined), findsNothing);
    },
  );

  testWidgets(
    'shows the edit badge in customization mode when a customizationId is set',
    (tester) async {
      await tester.pumpWidget(
        wrap(customizationMode: true, customizationId: 'dashboard.test'),
      );

      expect(find.byIcon(Icons.palette_outlined), findsOneWidget);
    },
  );

  testWidgets('renders a color override applied to the block', (tester) async {
    BlockOverrides.setColor('dashboard.test', const Color(0xFF00897B));

    await tester.pumpWidget(
      wrap(customizationMode: false, customizationId: 'dashboard.test'),
    );

    expect(find.text('Contenu'), findsOneWidget);
  });

  testWidgets(
    'fills a fixed-height parent instead of shrinking to its content — a '
    'regression test for the outer Stack added for the edit badge, which '
    'must use StackFit.passthrough or every card collapses to text size '
    'inside a grid cell / Expanded+Row',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [customizationModeProvider.overrideWith((ref) => true)],
          child: MaterialApp(
            locale: const Locale('fr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 300,
                height: 240,
                child: AppCard(
                  customizationId: 'dashboard.test',
                  child: const Text('Contenu'),
                ),
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(AppCard));
      expect(size.width, 300);
      expect(size.height, 240);
    },
  );
}
