import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/battle_details.dart';
import '../database/models/battle_stats.dart';
import '../repositories/battle_repository.dart';
import 'database_provider.dart';

final battleRepositoryProvider = Provider<BattleRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return BattleRepository(database);
});

final battlesListProvider = FutureProvider<List<BattleDetails>>((ref) {
  final repository = ref.watch(battleRepositoryProvider);
  return repository.listBattles();
});

final battleStatsProvider = FutureProvider<BattleStats>((ref) async {
  final battles = await ref.watch(battlesListProvider.future);
  return BattleStats.fromBattles(battles);
});
