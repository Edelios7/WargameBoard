import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/army_details.dart';
import '../repositories/army_repository.dart';
import '../services/army_validation_service.dart';
import 'database_provider.dart';

final armyValidationServiceProvider =
    Provider<ArmyValidationService>((ref) => const ArmyValidationService());

final armyValidationProvider =
    Provider.family<ArmyValidationResult?, ArmyDetails?>((ref, army) {
  if (army == null) return null;
  return ref.watch(armyValidationServiceProvider).validate(army);
});

final armyRepositoryProvider = Provider<ArmyRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return ArmyRepository(database);
});

final armiesListProvider = FutureProvider<List<ArmyListItem>>((ref) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.listArmies();
});

final selectedArmyIdProvider = StateProvider<String?>((ref) => null);

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
