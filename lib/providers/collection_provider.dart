import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/collection_item_details.dart';
import '../repositories/collection_repository.dart';
import '../services/collection_service.dart';
import 'database_provider.dart';
import 'xp_provider.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final xpService = ref.watch(xpServiceProvider);

  return CollectionRepository(database, xpService);
});

final collectionServiceProvider =
    Provider<CollectionService>((ref) => const CollectionService());

final collectionEntriesProvider =
    FutureProvider<List<CollectionItemDetails>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.listEntries();
});

final collectionSummaryProvider = FutureProvider<CollectionSummary>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.getSummary();
});

/// Quantité possédée d'une datasheet donnée — utilisé par l'army
/// builder pour signaler un manque face à ce qui est réellement dans
/// la vitrine du joueur.
final ownedQuantityProvider =
    FutureProvider.family<int, String>((ref, datasheetId) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.getOwnedQuantity(datasheetId);
});

final wishlistItemsProvider =
    FutureProvider<List<WishlistItemDetails>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.listWishlistItems();
});
