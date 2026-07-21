import '../database/app_database.dart';
import '../database/models/collection_item_details.dart';
import '../services/xp_service.dart';

class CollectionRepository {
  final AppDatabase database;
  final XpService xpService;

  CollectionRepository(this.database, this.xpService);

  Future<List<CollectionItemDetails>> listEntries() {
    return database.collectionDao.listEntries();
  }

  Future<CollectionSummary> getSummary() {
    return database.collectionDao.getSummary();
  }

  Future<int> getOwnedQuantity(String datasheetId) {
    return database.collectionDao.getOwnedQuantity(datasheetId);
  }

  Future<String> addEntry({
    required String datasheetId,
    required int quantity,
    double? purchasePrice,
  }) async {
    final id = await database.collectionDao.addEntry(
      datasheetId: datasheetId,
      quantity: quantity,
      purchasePrice: purchasePrice,
    );
    await xpService.awardNewBox(datasheetId);
    return id;
  }

  Future<void> deleteEntry(String id) {
    return database.collectionDao.deleteEntry(id);
  }

  Future<void> setPurchasePrice(String id, double? purchasePrice) {
    return database.collectionDao.setPurchasePrice(id, purchasePrice);
  }

  Future<void> updateCounts(
    String id, {
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
  }) async {
    final result = await database.collectionDao.updateCounts(
      id,
      quantity: quantity,
      assembled: assembled,
      primed: primed,
      painted: painted,
    );

    final before = result.before;
    final after = result.after;

    final assembledDelta = after.assembled - before.assembled;
    final assembledJustCompleted = after.assembled == after.quantity &&
        before.assembled != before.quantity;
    if (assembledDelta > 0 || assembledJustCompleted) {
      await xpService.awardAssembly(
        datasheetId: after.datasheetId,
        delta: assembledDelta > 0 ? assembledDelta : 0,
        squadCompleted: assembledJustCompleted,
      );
    }

    final paintedDelta = after.painted - before.painted;
    final paintedJustCompleted =
        after.painted == after.quantity && before.painted != before.quantity;
    if (paintedDelta > 0 || paintedJustCompleted) {
      await xpService.awardPainting(
        datasheetId: after.datasheetId,
        delta: paintedDelta > 0 ? paintedDelta : 0,
        squadCompleted: paintedJustCompleted,
      );
    }
  }

  Future<List<WishlistItemDetails>> listWishlistItems() {
    return database.collectionDao.listWishlistItems();
  }

  Future<String> addWishlistItem({
    required String datasheetId,
    int quantity = 1,
    String? notes,
  }) {
    return database.collectionDao.addWishlistItem(
      datasheetId: datasheetId,
      quantity: quantity,
      notes: notes,
    );
  }

  Future<void> deleteWishlistItem(String id) {
    return database.collectionDao.deleteWishlistItem(id);
  }

  Future<void> moveWishlistItemToCollection(String id) {
    return database.collectionDao.moveWishlistItemToCollection(id);
  }

  Future<List<CollectionItemDetails>> listRecentPurchases({int limit = 5}) {
    return database.collectionDao.listRecentPurchases(limit: limit);
  }

  Future<List<CollectionItemDetails>> listRecentlyAdded({int limit = 5}) {
    return database.collectionDao.listRecentlyAdded(limit: limit);
  }

  Future<List<CollectionGap>> getCollectionGaps({int limit = 5}) {
    return database.collectionDao.getCollectionGaps(limit: limit);
  }
}
