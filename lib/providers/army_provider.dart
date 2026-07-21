import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/army_details.dart';
import '../repositories/army_repository.dart';
import '../services/army_builder_service.dart';
import '../services/army_validation_service.dart';
import 'database_provider.dart';
import 'xp_provider.dart';

final armyValidationServiceProvider =
    Provider<ArmyValidationService>((ref) => const ArmyValidationService());

final armyValidationProvider =
    Provider.family<ArmyValidationResult?, ArmyDetails?>((ref, army) {
  if (army == null) return null;
  return ref.watch(armyValidationServiceProvider).validate(army);
});

final armyRepositoryProvider = Provider<ArmyRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final xpService = ref.watch(xpServiceProvider);

  return ArmyRepository(database, xpService);
});

final armyBuilderServiceProvider = Provider<ArmyBuilderService>((ref) {
  final repository = ref.watch(armyRepositoryProvider);
  return ArmyBuilderService(repository);
});

final armiesListProvider = FutureProvider<List<ArmyListItem>>((ref) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.listArmies();
});

final selectedArmyIdProvider = StateProvider<String?>((ref) => null);

final selectedUnitIdProvider = StateProvider<String?>((ref) => null);

final selectedArmyProvider = FutureProvider<ArmyDetails?>((ref) async {
  final armyId = ref.watch(selectedArmyIdProvider);
  if (armyId == null) return null;

  final repository = ref.watch(armyRepositoryProvider);
  return repository.getArmy(armyId);
});

final detachmentsForFactionProvider =
    FutureProvider.family<List<DetachmentOption>, String>((ref, factionId) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.getDetachmentsForFaction(factionId);
});

final enhancementsForDetachmentProvider =
    FutureProvider.family<List<EnhancementOption>, String>(
        (ref, detachmentId) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.getEnhancementsForDetachment(detachmentId);
});

final stratagemsForDetachmentProvider =
    FutureProvider.family<List<StratagemOption>, String>((ref, detachmentId) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.getStratagemsForDetachment(detachmentId);
});

/// Choix d'équipement optionnel actuels d'une unité d'armée, par
/// groupe d'équipement. Invalidé après un changement de sélection pour
/// refléter le nouveau chargement d'armes de l'unité.
final unitEquipmentSelectionsProvider =
    FutureProvider.family<Map<String, List<String>>, String>((
  ref,
  armyUnitId,
) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.getUnitEquipmentSelections(armyUnitId);
});
