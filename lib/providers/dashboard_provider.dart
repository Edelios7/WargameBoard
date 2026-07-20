import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/collection_item_details.dart';
import '../database/models/search_result.dart';
import 'catalog_provider.dart';
import 'collection_provider.dart';
import 'database_provider.dart';
import 'shared_preferences_provider.dart';

/// Clé SharedPreferences pour le nom affiché sur le Dashboard.
const String displayNamePreferenceKey = 'display_name';

/// Nom affiché dans le bandeau du Dashboard ("Bonjour {nom}").
///
/// La valeur initiale réelle est injectée au démarrage via un override
/// dans main.dart, à partir de SharedPreferences (comme la locale).
final displayNameProvider = StateProvider<String?>((ref) => null);

/// Clé SharedPreferences pour l'historique des fiches consultées.
const String recentlyViewedPreferenceKey = 'recently_viewed_datasheets';

const int _maxRecentlyViewed = 8;

/// Ids des dernières fiches consultées dans le Catalogue, du plus récent
/// au plus ancien. Persisté dans SharedPreferences à chaque ajout.
class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  final Ref ref;

  RecentlyViewedNotifier(this.ref, List<String> initial) : super(initial);

  void add(String datasheetId) {
    final updated = [
      datasheetId,
      ...state.where((id) => id != datasheetId),
    ].take(_maxRecentlyViewed).toList();
    state = updated;
    ref
        .read(sharedPreferencesProvider)
        .setStringList(recentlyViewedPreferenceKey, updated);
  }
}

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>((ref) {
  return RecentlyViewedNotifier(ref, const []);
});

final recentlyViewedDatasheetsProvider =
    FutureProvider<List<SearchResult>>((ref) async {
  final ids = ref.watch(recentlyViewedProvider);
  if (ids.isEmpty) return const [];

  final repository = ref.watch(catalogRepositoryProvider);
  final results = <SearchResult>[];
  for (final id in ids) {
    final details = await repository.getDatasheet(id);
    if (details == null) continue;
    results.add(SearchResult(
      id: details.id,
      name: details.name,
      type: 'datasheet',
      factionId: details.factionId,
      factionName: details.factionName,
    ));
  }
  return results;
});

final favoriteDatasheetsProvider = FutureProvider<List<SearchResult>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.datasheetDao.mostUsedDatasheets();
});

final collectionGapsProvider = FutureProvider<List<CollectionGap>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.getCollectionGaps();
});

final recentPurchasesProvider =
    FutureProvider<List<CollectionItemDetails>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.listRecentPurchases();
});

class CatalogStats {
  final int datasheets;
  final int modelProfiles;
  final int weapons;
  final int abilities;
  final int keywords;

  const CatalogStats({
    required this.datasheets,
    required this.modelProfiles,
    required this.weapons,
    required this.abilities,
    required this.keywords,
  });
}

final catalogStatsProvider = FutureProvider<CatalogStats>((ref) async {
  final database = ref.watch(databaseProvider);
  final datasheets = await database.datasheetDao.countDatasheets();
  final modelProfiles = await database.datasheetDao.countModelProfiles();
  final weapons = await database.weaponDao.getAllWeapons();
  final abilities = await database.abilityDao.getAll();
  final keywords = await database.keywordDao.getAll();
  return CatalogStats(
    datasheets: datasheets,
    modelProfiles: modelProfiles,
    weapons: weapons.length,
    abilities: abilities.length,
    keywords: keywords.length,
  );
});
