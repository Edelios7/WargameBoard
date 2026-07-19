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
    await tester.enterText(find.byType(TextField).last, '5');
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    expect(find.text('Death Company Marines'), findsOneWidget);
    expect(find.text('5 possédées'), findsOneWidget);
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

    await tester.tap(addAssembled);
    await tester.pumpAndSettle();
    await tester.tap(addAssembled);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    expect(entries.single.assembled, 1);
  });
}
