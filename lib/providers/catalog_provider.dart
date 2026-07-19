import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/catalog_repository.dart';
import 'database_provider.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return CatalogRepository(database);
});