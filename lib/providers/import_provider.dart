import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/catalog_import_service.dart';
import 'database_provider.dart';

final catalogImportServiceProvider = Provider<CatalogImportService>((ref) {
  final database = ref.watch(databaseProvider);

  return CatalogImportService(database);
});
