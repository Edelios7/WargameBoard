import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/models/catalog_sort.dart';
import '../database/models/datasheet_details.dart';
import '../database/models/search_result.dart';
import '../database/models/weapon_summary.dart';
import '../repositories/catalog_repository.dart';
import 'collection_provider.dart';
import 'database_provider.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return CatalogRepository(database);
});

final catalogSearchQueryProvider = StateProvider<String>((ref) => '');

final catalogFactionFilterProvider = StateProvider<String?>((ref) => null);

final catalogKeywordFilterProvider = StateProvider<Set<String>>((ref) => {});

final catalogRoleFilterProvider = StateProvider<String?>((ref) => null);

final catalogUnitTypeFilterProvider = StateProvider<String?>((ref) => null);

final catalogEditionFilterProvider = StateProvider<String?>((ref) => null);

final catalogSortProvider =
    StateProvider<CatalogSort>((ref) => CatalogSort.nameAsc);

final catalogMaxPointsProvider = FutureProvider<int>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getMaxPoints();
});

final catalogPointsRangeProvider = StateProvider<RangeValues?>((ref) => null);

final catalogSearchResultsProvider =
    FutureProvider<List<SearchResult>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  final query = ref.watch(catalogSearchQueryProvider);
  final factionId = ref.watch(catalogFactionFilterProvider);
  final keywordIds = ref.watch(catalogKeywordFilterProvider);
  final role = ref.watch(catalogRoleFilterProvider);
  final unitType = ref.watch(catalogUnitTypeFilterProvider);
  final editionId = ref.watch(catalogEditionFilterProvider);
  final pointsRange = ref.watch(catalogPointsRangeProvider);
  final sortBy = ref.watch(catalogSortProvider);

  return repository.search(
    query,
    factionId: factionId,
    keywordIds: keywordIds,
    role: role,
    unitType: unitType,
    editionId: editionId,
    minPoints: pointsRange?.start.round(),
    maxPoints: pointsRange?.end.round(),
    sortBy: sortBy,
  );
});

final factionsListProvider = FutureProvider<List<Faction>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.factionDao.getAll();
});

final keywordsListProvider = FutureProvider<List<Keyword>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.keywordDao.getAll();
});

final rolesListProvider = FutureProvider<List<String>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getRoles();
});

final unitTypesListProvider = FutureProvider<List<String>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getUnitTypes();
});

final editionsListProvider = FutureProvider<List<Edition>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getEditions();
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

final datasheetByIdProvider =
    FutureProvider.family<DatasheetDetails?, String>((ref, id) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.getDatasheet(id);
});

final weaponsInventoryProvider = FutureProvider<List<WeaponSummary>>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.listWeaponsWithUsage();
});

/// Quantité possédée par datasheet (toutes entrées de collection
/// confondues) — utilisé par le Catalogue pour afficher un badge
/// "possédé" sur les fiches déjà dans la Collection de l'utilisateur.
final catalogOwnedQuantitiesProvider = Provider<Map<String, int>>((ref) {
  final entries = ref.watch(collectionEntriesProvider).value ?? const [];
  final result = <String, int>{};
  for (final entry in entries) {
    result[entry.datasheetId] = (result[entry.datasheetId] ?? 0) + entry.quantity;
  }
  return result;
});
