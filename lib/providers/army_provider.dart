import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/models/army_details.dart';
import '../database/models/datasheet_details.dart';
import '../repositories/army_repository.dart';
import '../services/army_builder_service.dart';
import '../services/army_validation_service.dart';
import 'catalog_provider.dart';
import 'database_provider.dart';
import 'xp_provider.dart';

final armyValidationServiceProvider = Provider<ArmyValidationService>(
  (ref) => const ArmyValidationService(),
);

// autoDispose : `army` vient de selectedArmyProvider, qui réémet une
// nouvelle instance d'ArmyDetails (identité d'objet différente, pas de
// ==/hashCode surchargés) à chaque modification de l'armée — sans
// autoDispose, chaque ajout/retrait d'unité ou changement de quantité
// pendant une session de construction d'armée créait une entrée de
// cache permanente jamais libérée.
final armyValidationProvider = Provider.autoDispose
    .family<ArmyValidationResult?, ArmyDetails?>((ref, army) {
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

/// Armée par id, indépendante de la sélection courante de l'Army Builder
/// (voir [selectedArmyProvider]) — utilisée par ex. par le dashboard de
/// bataille pour afficher le roster de l'armée engagée dans la partie.
final armyByIdProvider = FutureProvider.family<ArmyDetails?, String>((
  ref,
  armyId,
) {
  final repository = ref.watch(armyRepositoryProvider);
  return repository.getArmy(armyId);
});

final detachmentsForFactionProvider =
    FutureProvider.family<List<DetachmentOption>, String>((ref, factionId) {
      final repository = ref.watch(armyRepositoryProvider);
      return repository.getDetachmentsForFaction(factionId);
    });

final enhancementsForDetachmentProvider =
    FutureProvider.family<List<EnhancementOption>, String>((ref, detachmentId) {
      final repository = ref.watch(armyRepositoryProvider);
      return repository.getEnhancementsForDetachment(detachmentId);
    });

final stratagemsForDetachmentProvider =
    FutureProvider.family<List<StratagemOption>, String>((ref, detachmentId) {
      final repository = ref.watch(armyRepositoryProvider);
      return repository.getStratagemsForDetachment(detachmentId);
    });

/// Fiches détaillées de tout le catalogue jouable d'une faction (avec,
/// pour un chapitre successeur, le pool générique Space Marines élargi —
/// même règle que [AddUnitDialog]) : sert à la fois de base au profil
/// d'armée (radar) et aux recommandations d'unités complémentaires, qui
/// ont besoin des fiches des unités déjà en armée ET de celles qui n'y
/// sont pas encore. `autoDispose` : coûteux à calculer (une requête par
/// fiche), inutile de garder ça en mémoire une fois qu'on quitte le
/// constructeur d'armée de cette faction.
final factionCatalogDetailsProvider = FutureProvider.autoDispose
    .family<List<DatasheetDetails>, String>((ref, factionId) async {
      final catalogRepository = ref.watch(catalogRepositoryProvider);
      final results = await catalogRepository.search('', factionId: factionId);
      final sheets = await Future.wait(
        results.map((r) => catalogRepository.getDatasheet(r.id)),
      );
      return sheets.whereType<DatasheetDetails>().toList();
    });

/// Choix d'équipement optionnel actuels d'une unité d'armée, par
/// groupe d'équipement. Invalidé après un changement de sélection pour
/// refléter le nouveau chargement d'armes de l'unité.
final unitEquipmentSelectionsProvider = FutureProvider.autoDispose
    .family<Map<String, List<String>>, String>((ref, armyUnitId) {
      final repository = ref.watch(armyRepositoryProvider);
      return repository.getUnitEquipmentSelections(armyUnitId);
    });
