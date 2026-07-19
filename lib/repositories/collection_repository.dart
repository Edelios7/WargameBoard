import '../database/app_database.dart';
import '../database/models/collection_item_details.dart';

class CollectionRepository {
  final AppDatabase database;

  CollectionRepository(this.database);

  Future<List<CollectionItemDetails>> listEntries() {
    return database.collectionDao.listEntries();
  }

  Future<CollectionSummary> getSummary() {
    return database.collectionDao.getSummary();
  }

  Future<String> addEntry({
    required String datasheetId,
    required int quantity,
  }) {
    return database.collectionDao.addEntry(
      datasheetId: datasheetId,
      quantity: quantity,
    );
  }

  Future<void> deleteEntry(String id) {
    return database.collectionDao.deleteEntry(id);
  }

  Future<void> updateCounts(
    String id, {
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
  }) {
    return database.collectionDao.updateCounts(
      id,
      quantity: quantity,
      assembled: assembled,
      primed: primed,
      painted: painted,
    );
  }
}
