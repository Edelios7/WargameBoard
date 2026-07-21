import '../database/app_database.dart';
import '../database/models/catalog_sort.dart';
import '../database/models/datasheet_details.dart';
import '../database/models/search_result.dart';
import '../database/models/weapon_summary.dart';

class CatalogRepository {
  final AppDatabase database;

  CatalogRepository(this.database);

  Future<List<SearchResult>> search(
    String text, {
    String? factionId,
    Set<String> keywordIds = const {},
    String? role,
    String? unitType,
    String? editionId,
    int? minPoints,
    int? maxPoints,
    CatalogSort sortBy = CatalogSort.nameAsc,
  }) {
    return database.datasheetDao.search(
      text,
      factionId: factionId,
      keywordIds: keywordIds,
      role: role,
      unitType: unitType,
      editionId: editionId,
      minPoints: minPoints,
      maxPoints: maxPoints,
      sortBy: sortBy,
    );
  }

  Future<DatasheetDetails?> getDatasheet(String id) {
    return database.datasheetDao.getDatasheet(id);
  }

  Future<List<String>> getRoles() => database.datasheetDao.getDistinctRoles();

  Future<List<String>> getUnitTypes() =>
      database.datasheetDao.getDistinctUnitTypes();

  Future<List<Edition>> getEditions() => database.datasheetDao.getEditions();

  Future<int> getMaxPoints() => database.datasheetDao.getMaxPoints();

  Future<List<WeaponSummary>> listWeaponsWithUsage() =>
      database.weaponDao.listWeaponsWithUsage();
}