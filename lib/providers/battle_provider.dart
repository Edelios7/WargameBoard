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

// `.autoDispose` sur ces 4 familles : sans lui, chaque partie ouverte au
// cours d'une session (id unique) laissait ses entrées de cache (journal,
// unités détruites, modificateurs, blessures) vivre indéfiniment — sans
// borne naturelle comme le catalogue (nombre fini de factions/fiches),
// une longue session avec beaucoup de parties accumulerait ces caches sans
// jamais les libérer.
final battleEventsProvider = FutureProvider.autoDispose
    .family<List<BattleEventDetails>, String>((ref, battleId) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getEvents(battleId);
    });

/// Unités marquées détruites pour cette partie (id d'ArmyUnit) — voir
/// [BattleRepository.getUnitStates].
final battleUnitStatesProvider = FutureProvider.autoDispose
    .family<List<BattleUnitStateDetails>, String>((ref, battleId) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitStates(battleId);
    });

/// Bonus/malus actifs pour cette partie, toutes unités confondues — voir
/// [BattleRepository.getUnitModifiers].
final battleUnitModifiersProvider = FutureProvider.autoDispose
    .family<List<BattleUnitModifierDetails>, String>((ref, battleId) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitModifiers(battleId);
    });

/// Modèles blessés pour cette partie (tous, toutes unités confondues) —
/// voir [BattleRepository.getUnitWounds].
final battleUnitWoundsProvider = FutureProvider.autoDispose
    .family<List<BattleUnitWoundDetails>, String>((ref, battleId) {
      final repository = ref.watch(battleRepositoryProvider);
      return repository.getUnitWounds(battleId);
    });
