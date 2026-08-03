import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/widgets/unit_photo_thumbnail.dart';
import 'package:wargameboard/l10n/app_localizations.dart';

void main() {
  Widget wrap({required bool hasPhoto}) {
    return ProviderScope(
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: UnitPhotoEditButton(
            datasheetId: 'unit-1',
            hasPhoto: hasPhoto,
          ),
        ),
      ),
    );
  }

  testWidgets('shows "Ajouter une image" when no photo exists yet', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(hasPhoto: false));

    expect(find.text('Ajouter une image'), findsOneWidget);
    expect(find.text('Modifier l\'image'), findsNothing);
  });

  testWidgets('shows "Modifier l\'image" once a photo already exists', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(hasPhoto: true));

    expect(find.text('Modifier l\'image'), findsOneWidget);
    expect(find.text('Ajouter une image'), findsNothing);
  });

  testWidgets(
    'tapping opens a menu with "Choisir une photo" and, only when a photo '
    'already exists, "Retirer la photo"',
    (tester) async {
      await tester.pumpWidget(wrap(hasPhoto: true));

      await tester.tap(find.byType(UnitPhotoEditButton));
      await tester.pumpAndSettle();

      expect(find.text('Choisir une photo'), findsOneWidget);
      expect(find.text('Retirer la photo'), findsOneWidget);
    },
  );

  testWidgets(
    'the menu offers no removal option when there is nothing to remove yet',
    (tester) async {
      await tester.pumpWidget(wrap(hasPhoto: false));

      await tester.tap(find.byType(UnitPhotoEditButton));
      await tester.pumpAndSettle();

      expect(find.text('Choisir une photo'), findsOneWidget);
      expect(find.text('Retirer la photo'), findsNothing);
    },
  );
}
