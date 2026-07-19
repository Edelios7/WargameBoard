import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/datasheet_details.dart';
import '../database/models/search_result.dart';
import '../repositories/catalog_repository.dart';
import 'database_provider.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return CatalogRepository(database);
});

final catalogSearchQueryProvider = StateProvider<String>((ref) => '');

final catalogSearchResultsProvider =
    FutureProvider<List<SearchResult>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  final query = ref.watch(catalogSearchQueryProvider);

  return repository.search(query);
});

final selectedDatasheetIdProvider = StateProvider<String?>((ref) => null);

final selectedDatasheetProvider =
    FutureProvider<DatasheetDetails?>((ref) async {
  final id = ref.watch(selectedDatasheetIdProvider);
  if (id == null) return null;

  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getDatasheet(id);
});