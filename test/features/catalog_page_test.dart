import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/catalog/pages/catalog_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('selecting a datasheet in the list shows its detail panel',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
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
}
