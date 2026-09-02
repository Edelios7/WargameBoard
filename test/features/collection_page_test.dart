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
    await tester.tap(find.text('Ajouter à la collection').last);
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

  testWidgets(
      'typing an invalid quantity (0) disables the add button instead of '
      'failing silently when tapped', (tester) async {
    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter à la collection'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Death Company Marines'));
    await tester.pumpAndSettle();
    // TextField 0 = recherche, 1 = quantité, 2 = prix (optionnel).
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.pumpAndSettle();

    // Deux boutons portent ce texte : celui qui ouvre le dialogue (barre
    // d'outils de la page) et celui du dialogue lui-même — on veut le
    // second.
    final addButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Ajouter à la collection').last,
    );
    expect(addButton.onPressed, isNull);

    final entries = await database.collectionDao.listEntries();
    expect(entries, isEmpty);
  });

  testWidgets('tapping a collection card opens its datasheet page',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    // "Captain" apparaît à la fois dans "Ajouts récents" (non cliquable)
    // et dans la grille principale (la _CollectionCard, cliquable) : on
    // vise la dernière occurrence, celle de la grille.
    final captainFinder = find.text('Captain').last;
    await tester.ensureVisible(captainFinder);
    await tester.pumpAndSettle();
    await tester.tap(captainFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Captain'), findsWidgets);
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

    // Une confirmation est demandée avant la suppression définitive.
    expect(find.text('Retirer cette entrée ?'), findsOneWidget);
    await tester.tap(find.text('Retirer'));
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

  testWidgets(
      'the explicit delete button asks for confirmation and can be cancelled',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 3,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final deleteButton = find.byKey(const Key('delete-entry-button'));
    await tester.ensureVisible(deleteButton);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Retirer cette entrée ?'), findsOneWidget);

    // Annuler ne doit rien supprimer.
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(await database.collectionDao.listEntries(), hasLength(1));

    // Confirmer supprime bien l'entrée.
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retirer'));
    await tester.pumpAndSettle();

    expect(await database.collectionDao.listEntries(), isEmpty);
  });

  testWidgets(
      'selecting entries in bulk mode and marking them painted updates all of them',
      (tester) async {
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 3,
    );
    await database.collectionDao.addEntry(
      datasheetId: 'ds-death-company-marines',
      quantity: 5,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final selectionToggle = find.byIcon(Icons.checklist_rounded);
    await tester.ensureVisible(selectionToggle);
    await tester.pumpAndSettle();
    await tester.tap(selectionToggle);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.circle_outlined), findsNWidgets(2));
    for (var i = 0; i < 2; i++) {
      final checkbox = find.byIcon(Icons.circle_outlined).first;
      await tester.ensureVisible(checkbox);
      await tester.pumpAndSettle();
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }

    final markPaintedButton = find.text('Marquer entièrement peint');
    await tester.ensureVisible(markPaintedButton);
    await tester.pumpAndSettle();
    await tester.tap(markPaintedButton);
    await tester.pumpAndSettle();

    // La confirmation partage le même libellé que le bouton déclencheur.
    await tester.tap(find.text('Marquer entièrement peint').last);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    for (final entry in entries) {
      expect(entry.painted, entry.quantity);
      expect(entry.assembled, entry.quantity);
      expect(entry.primed, entry.quantity);
    }

    // Le mode sélection se referme automatiquement après l'action groupée.
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
  });

  testWidgets(
      'an entry that drops out of the active filter while selected is no '
      'longer counted or touched by the bulk action',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 3,
    );
    await database.collectionDao.addEntry(
      datasheetId: 'ds-death-company-marines',
      quantity: 5,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    final selectionToggle = find.byIcon(Icons.checklist_rounded);
    await tester.ensureVisible(selectionToggle);
    await tester.pumpAndSettle();
    await tester.tap(selectionToggle);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.circle_outlined), findsNWidgets(2));
    for (var i = 0; i < 2; i++) {
      final checkbox = find.byIcon(Icons.circle_outlined).first;
      await tester.ensureVisible(checkbox);
      await tester.pumpAndSettle();
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }
    expect(find.text('2 sélectionnée(s)'), findsOneWidget);

    // Filtrer la recherche pour ne plus faire apparaître qu'une des deux
    // entrées sélectionnées — l'autre doit sortir du décompte.
    final searchField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Rechercher dans la collection...',
    );
    await tester.enterText(searchField, 'Captain');
    await tester.pumpAndSettle();

    final markPaintedButton = find.text('Marquer entièrement peint');
    await tester.ensureVisible(markPaintedButton);
    await tester.pumpAndSettle();
    await tester.tap(markPaintedButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Marquer entièrement peint').last);
    await tester.pumpAndSettle();

    final entries = await database.collectionDao.listEntries();
    final captain = entries.singleWhere((e) => e.datasheetName == 'Captain');
    final deathCompany = entries.singleWhere(
      (e) => e.datasheetName == 'Death Company Marines',
    );
    expect(captain.painted, captain.quantity);
    expect(deathCompany.painted, 0);
  });

  testWidgets(
      'the collection page renders without overflow on a phone-sized screen',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 3,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Captain'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'selecting two faction filters at once shows entries from both '
      '(OR, not AND)', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // Captain -> Blood Angels, Intercessor Squad -> Space Marines (Adeptus
    // Astartes) : deux factions distinctes, comme dans l'exemple de la
    // demande ("blood angels et adeptus astartes en même temps").
    await database.collectionDao.addEntry(
      datasheetId: 'ds-captain',
      quantity: 1,
    );
    await database.collectionDao.addEntry(
      datasheetId: 'ds-intercessor-squad',
      quantity: 1,
    );

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    // Les deux apparaissent avant tout filtre.
    expect(find.text('Captain'), findsWidgets);
    expect(find.text('Intercessor Squad'), findsWidgets);

    // Chaque ligne de filtre de faction porte une clé dédiée
    // ("faction-filter-<nom>") pour la cibler sans ambiguïté — le nom
    // de faction apparaît aussi en sous-titre sur la carte de la grille,
    // qui n'est pas le widget qu'on veut taper ici.
    // "Ajouts récents" affiche toujours les entrées les plus récentes
    // sans tenir compte du filtre actif (même logique que "Mes armées") :
    // on compte donc précisément les occurrences plutôt que d'attendre
    // zéro, pour ne pas confondre "sorti de la grille filtrée" avec
    // "disparu de la page entière".
    final bloodAngelsRow = find.byKey(const Key('faction-filter-Blood Angels'));
    await tester.ensureVisible(bloodAngelsRow);
    await tester.pumpAndSettle();
    await tester.tap(bloodAngelsRow);
    await tester.pumpAndSettle();

    expect(find.text('Captain'), findsNWidgets(2)); // ajouts récents + grille
    expect(
      find.text('Intercessor Squad'),
      findsOneWidget,
    ); // ajouts récents seulement, sorti de la grille filtrée

    // Coche EN PLUS "Space Marines (Adeptus Astartes)", sans décocher
    // "Blood Angels" : les deux doivent maintenant réapparaître dans la
    // grille (union), pas seulement leur éventuelle intersection.
    final spaceMarinesRow = find.byKey(
      const Key('faction-filter-Space Marines (Adeptus Astartes)'),
    );
    await tester.ensureVisible(spaceMarinesRow);
    await tester.pumpAndSettle();
    await tester.tap(spaceMarinesRow);
    await tester.pumpAndSettle();

    expect(find.text('Captain'), findsNWidgets(2));
    expect(find.text('Intercessor Squad'), findsNWidgets(2));
  });
}
