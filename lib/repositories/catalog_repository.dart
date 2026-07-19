import '../database/app_database.dart';
import '../database/models/datasheet_details.dart';
import '../database/models/search_result.dart';

class CatalogRepository {
  final AppDatabase database;

  CatalogRepository(this.database);

  Future<List<SearchResult>> search(String text) {
    return database.datasheetDao.search(text);
  }

  Future<DatasheetDetails?> getDatasheet(String id) {
    return database.datasheetDao.getDatasheet(id);
  }
}