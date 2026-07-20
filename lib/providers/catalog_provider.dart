import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/models/datasheet_details.dart';
import '../database/models/search_result.dart';
import '../repositories/catalog_repository.dart';
import 'database_provider.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return CatalogRepository(database);
});

final catalogSearchQueryProvider = StateProvider<String>((ref) => '');

final catalogFactionFilterProvider = StateProvider<String?>((ref) => null);

final catalogKeywordFilterProvider = StateProvider<String?>((ref) => null);

final catalogSearchResultsProvider =
    FutureProvider<List<SearchResult>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  final query = ref.watch(catalogSearchQueryProvider);
  final factionId = ref.watch(catalogFactionFilterProvider);
  final keywordId = ref.watch(catalogKeywordFilterProvider);

  return repository.search(query, factionId: factionId, keywordId: keywordId);
});

final factionsListProvider = FutureProvider<List<Faction>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.factionDao.getAll();
});

final keywordsListProvider = FutureProvider<List<Keyword>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.keywordDao.getAll();
});

final abilitiesListProvider = FutureProvider<List<Ability>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.abilityDao.getAll();
});

final selectedDatasheetIdProvider = StateProvider<String?>((ref) => null);

final selectedDatasheetProvider =
    FutureProvider<DatasheetDetails?>((ref) async {
  final id = ref.watch(selectedDatasheetIdProvider);
  if (id == null) return null;

  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getDatasheet(id);
});
