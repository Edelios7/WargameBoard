import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('adding a wishlist item surfaces faction and datasheet names',
      () async {
    final results = await database.datasheetDao.search('Warboss');
    await database.collectionDao.addWishlistItem(
      datasheetId: results.single.id,
      quantity: 1,
    );

    final items = await database.collectionDao.listWishlistItems();

    expect(items, hasLength(1));
    expect(items.single.datasheetName, 'Warboss');
    expect(items.single.factionName, 'Orks');
  });

  test('moving a wishlist item to the collection removes it from the '
      'wishlist and adds it as an owned entry', () async {
    final results = await database.datasheetDao.search('Boyz');
    final wishlistId = await database.collectionDao.addWishlistItem(
      datasheetId: results.single.id,
      quantity: 10,
    );

    await database.collectionDao.moveWishlistItemToCollection(wishlistId);

    final wishlist = await database.collectionDao.listWishlistItems();
    expect(wishlist, isEmpty);

    final owned = await database.collectionDao.listEntries();
    expect(owned, hasLength(1));
    expect(owned.single.datasheetName, 'Boyz');
    expect(owned.single.quantity, 10);
  });

  test('deleteWishlistItem removes the entry', () async {
    final results = await database.datasheetDao.search('Nobz');
    final id = await database.collectionDao.addWishlistItem(
      datasheetId: results.single.id,
    );

    await database.collectionDao.deleteWishlistItem(id);

    final items = await database.collectionDao.listWishlistItems();
    expect(items, isEmpty);
  });
}
