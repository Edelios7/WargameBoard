import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/battle_details.dart';
import '../database/models/battle_event_details.dart';
import '../database/models/battle_stats.dart';
import '../database/models/battle_unit_modifier_details.dart';
import '../database/models/battle_unit_state_details.dart';
import '../database/models/battle_unit_wound_details.dart';
import '../repositories/battle_repository.dart';
import 'database_provider.dart';
import 'xp_provider.dart';

final battleRepositoryProvider = Provider<BattleRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final xpService = ref.watch(xpServiceProvider);

  return BattleRepository(database, xpService);
});

final battlesListProvider = FutureProvider<List<BattleDetails>>((ref) {
  final repository = ref.watch(battleRepositoryProvider);
  return repository.listBattles();
});

final battleStatsProvider = FutureProvider<BattleStats>((ref) async {
  final battles = await ref.watch(battlesListProvider.future);
  return BattleStats.fromBattles(battles);
});

final nextBattleProvider = FutureProvider<BattleDetails?>((ref) {
  final repository = ref.watch(battleRepositoryProvider);
  return repository.getNextUpcoming();
});

final lastBattleProvider = FutureProvider<BattleDetails?>((ref) {
  final repository = ref.watch(battleRepositoryProvider);
  return repository.getLastPlayed();
});

/// Partie en cours de suivi en direct (setup ou active), s'il y en a une —
/// gate entre la liste/historique et le dashboard live sur la page Bataille.
final activeBattleProvider = FutureProvider<BattleDetails?>((ref) {
  final repository = ref.watch(battleRepositoryProvider);
  return repository.getActiveBattle();
});

final battleEventsProvider =
    FutureProvider.family<List<BattleEventDetails>, String>((ref, battleId) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getEvents(battleId);
    });

/// Unités marquées détruites pour cette partie (id d'ArmyUnit) — voir
/// [BattleRepository.getUnitStates].
final battleUnitStatesProvider =
    FutureProvider.family<List<BattleUnitStateDetails>, String>((
      ref,
      battleId,
    ) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitStates(battleId);
    });

/// Bonus/malus actifs pour cette partie, toutes unités confondues — voir
/// [BattleRepository.getUnitModifiers].
final battleUnitModifiersProvider =
    FutureProvider.family<List<BattleUnitModifierDetails>, String>((
      ref,
      battleId,
    ) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitModifiers(battleId);
    });

/// Modèles blessés pour cette partie (tous, toutes unités confondues) —
/// voir [BattleRepository.getUnitWounds].
final battleUnitWoundsProvider =
    FutureProvider.family<List<BattleUnitWoundDetails>, String>((
      ref,
      battleId,
    ) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitWounds(battleId);
    });
