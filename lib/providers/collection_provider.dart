import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/collection_item_details.dart';
import '../repositories/collection_repository.dart';
import 'database_provider.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return CollectionRepository(database);
});

final collectionEntriesProvider =
    FutureProvider<List<CollectionItemDetails>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.listEntries();
});

final collectionSummaryProvider = FutureProvider<CollectionSummary>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.getSummary();
});

final wishlistItemsProvider =
    FutureProvider<List<WishlistItemDetails>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.listWishlistItems();
});
