import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/xp_summary.dart';
import '../repositories/xp_repository.dart';
import '../services/xp_service.dart';
import 'database_provider.dart';

final xpServiceProvider = Provider<XpService>((ref) {
  final database = ref.watch(databaseProvider);
  return XpService(database);
});

final xpRepositoryProvider = Provider<XpRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return XpRepository(database);
});

final xpSummaryProvider = FutureProvider<XpSummary>((ref) {
  final repository = ref.watch(xpRepositoryProvider);
  return repository.getSummary();
});
