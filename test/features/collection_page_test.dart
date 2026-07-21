import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/collection/pages/collection_page.dart';
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
        home: const CollectionPage(),
      ),
    );
  }

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('adding a collection entry shows it with its quantity',
      (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Ta collection est vide'), findsOneWidget);

    await tester.tap(find.text('Ajouter à la collection'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Death Company Marines'));
    // TextField 0 = recherche, 1 = quantité, 2 = prix (optionnel).
    await tester.enterText(find.byType(TextField).at(1), '5');
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    // Apparaît à la fois dans "Ajouts récents" et dans la grille complète.
    expect(find.text('Death Company Marines'), findsWidgets);
    // La quantité est affichée en deux morceaux (badge nombre + libellé).
    expect(
      tester
          .widget<Text>(find.byKey(const Key('quantity-badge-number')))
          .data,
      '5',
    );
    expect(find.text('possédées'), findsOneWidget);
  });

  testWidgets('incrementing assembled count is clamped to quantity',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final addAssembled =
        find.byIcon(Icons.add_circle_outline_rounded).first;

    await tester.ensureVisible(addAssembled);
    await tester.pumpAndSettle();
    await tester.tap(addAssembled);
    await tester.pumpAndSettle();

    await tester.ensureVisible(addAssembled);
    await tester.pumpAndSettle();
    await tester.tap(addAssembled);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    expect(entries.single.assembled, 1);
  });

  testWidgets(
      'decrementing quantity to zero removes the entry from the collection',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final removeQty = find.byKey(const Key('quantity-decrement-button'));
    await tester.ensureVisible(removeQty);
    await tester.pumpAndSettle();
    await tester.tap(removeQty);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    expect(entries, isEmpty);
    expect(find.text('Ta collection est vide'), findsOneWidget);
  });

  testWidgets('typing a custom step adds that amount to the quantity',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final addQty = find.byKey(const Key('quantity-increment-button'));
    final stepField = find.byKey(const Key('quantity-step-field'));

    await tester.ensureVisible(stepField);
    await tester.enterText(stepField, '3');
    await tester.pumpAndSettle();

    await tester.ensureVisible(addQty);
    await tester.tap(addQty);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    expect(entries.single.quantity, 4);
  });
}
