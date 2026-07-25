import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/domain/xp/xp_category.dart';
import 'package:wargameboard/repositories/collection_repository.dart';
import 'package:wargameboard/services/xp_service.dart';

void main() {
  late AppDatabase database;
  late CollectionRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CollectionRepository(database, XpService(database));
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'reducing quantity to match an already-clamped assembled/painted count '
    'does not award the squad-completed XP bonus',
    () async {
      final results = await database.datasheetDao.search('Captain');
      final entryId = await repository.addEntry(
        datasheetId: results.single.id,
        quantity: 10,
      );

      // Ni monté ni peint : loin de "complet".
      await repository.updateCounts(entryId, assembled: 8, painted: 5);
      final afterProgress =
          await database.xpDao.getCategoryTotals();
      final assemblyBefore = afterProgress[XpCategory.assembly]!;
      final paintingBefore = afterProgress[XpCategory.painting]!;

      // Réduire la quantité jusqu'à rejoindre assembled/painted ne doit
      // déclencher aucun bonus "escouade complète" : aucun modèle n'a été
      // monté ou peint de plus.
      await repository.updateCounts(entryId, quantity: 8);
      final afterShrink = await database.xpDao.getCategoryTotals();
      expect(afterShrink[XpCategory.assembly], assemblyBefore);

      await repository.updateCounts(entryId, quantity: 5);
      final afterShrinkMore = await database.xpDao.getCategoryTotals();
      expect(afterShrinkMore[XpCategory.painting], paintingBefore);

      // Remonter puis redescendre la quantité ne doit pas non plus créditer
      // d'XP répétée (le farm signalé par l'audit).
      await repository.updateCounts(entryId, quantity: 10);
      await repository.updateCounts(entryId, quantity: 8);
      final afterRoundTrip = await database.xpDao.getCategoryTotals();
      expect(afterRoundTrip[XpCategory.assembly], assemblyBefore);
    },
  );

  test(
    'genuinely assembling the last model to reach the quantity still '
    'awards the squad-completed bonus',
    () async {
      final results = await database.datasheetDao.search('Captain');
      final entryId = await repository.addEntry(
        datasheetId: results.single.id,
        quantity: 3,
      );

      await repository.updateCounts(entryId, assembled: 2);
      final before = await database.xpDao.getCategoryTotals();

      await repository.updateCounts(entryId, assembled: 3);
      final after = await database.xpDao.getCategoryTotals();

      expect(
        after[XpCategory.assembly]!,
        greaterThan(before[XpCategory.assembly]!),
      );
    },
  );

  test(
    'moving a wishlist item into the collection awards the new-box XP, '
    'just like adding it directly',
    () async {
      final results = await database.datasheetDao.search('Captain');
      final wishlistId = await repository.addWishlistItem(
        datasheetId: results.single.id,
        quantity: 2,
      );
      final beforeMove = await database.xpDao.getCategoryTotals();

      await repository.moveWishlistItemToCollection(wishlistId);

      final afterMove = await database.xpDao.getCategoryTotals();
      expect(
        afterMove[XpCategory.collection]!,
        greaterThan(beforeMove[XpCategory.collection]!),
      );

      final entries = await repository.listEntries();
      expect(entries, hasLength(1));
      expect(entries.single.quantity, 2);

      final wishlist = await repository.listWishlistItems();
      expect(wishlist, isEmpty);
    },
  );
}
