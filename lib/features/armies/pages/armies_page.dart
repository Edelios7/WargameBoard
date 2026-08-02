import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_wallpapers.dart';
import '../../../core/utils/army_list_formatter.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/utils/search_normalize.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/discard_guard.dart';
import '../../../core/widgets/faction_badge_icon.dart';
import '../../../core/widgets/radar_chart.dart';
import '../../../core/widgets/unit_fallback_visual.dart';
import '../../../core/widgets/unit_photo_thumbnail.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../database/models/equipment_details.dart';
import '../../../database/models/model_details.dart';
import '../../../database/models/weapon_details.dart';
import '../../../domain/armies/army_profile.dart';
import '../../../domain/armies/army_recommendations.dart';
import '../../../domain/catalog/common/unit_archetype.dart';
import '../../../domain/rules/army_synergy_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../services/army_validation_service.dart';
import '../widgets/add_unit_dialog.dart';
import '../widgets/create_army_dialog.dart';

String _warningLabel(AppLocalizations l10n, ArmyValidationIssue issue) {
  switch (issue) {
    case ArmyValidationIssue.emptyArmy:
      return l10n.armyValidationEmptyArmy;
    case ArmyValidationIssue.noDetachmentSelected:
      return l10n.armyValidationNoDetachment;
    case ArmyValidationIssue.overPointsLimit:
      return l10n.armyBuilderOverLimit;
    case ArmyValidationIssue.tooManyEnhancements:
      return l10n.armyValidationTooManyEnhancements;
    case ArmyValidationIssue.duplicateEnhancement:
      return l10n.armyValidationDuplicateEnhancement;
    case ArmyValidationIssue.noWarlordSelected:
      return l10n.armyValidationNoWarlord;
    case ArmyValidationIssue.unknownUnitCosts:
      return l10n.armyValidationUnknownUnitCosts;
  }
}

/// Décide de l'action à effectuer quand `dragged` est lâchée sur `target`,
/// partagé entre la grille ([_UnitCard]) et la liste latérale
/// ([_UnitRosterRow]) : attacher/détacher si l'une des deux est un
/// personnage et l'autre non (redéposer un chef sur l'escouade à laquelle
/// il est déjà attaché détache — glisser = "lâcher prise" — sur une autre
/// escouade ça (ré)attache), sinon réordonner l'affichage. Rien de
/// pertinent à faire si une non-personnage est déposée sur un personnage.
Future<void> _handleUnitDrop(
  WidgetRef ref,
  ArmyDetails army, {
  required ArmyUnitDetails dragged,
  required ArmyUnitDetails target,
}) async {
  if (dragged.id == target.id) return;
  final repository = ref.read(armyRepositoryProvider);

  if (dragged.isCharacter && !target.isCharacter) {
    if (dragged.attachedToUnitId == target.id) {
      await repository.detachCharacter(dragged.id);
    } else {
      await repository.attachCharacter(dragged.id, target.id);
    }
  } else if (!dragged.isCharacter && target.isCharacter) {
    return;
  } else {
    final orderedIds = army.units.map((u) => u.id).toList();
    orderedIds.remove(dragged.id);
    final targetIndex = orderedIds.indexOf(target.id);
    orderedIds.insert(targetIndex, dragged.id);
    await repository.reorderUnits(army.id, orderedIds);
  }

  ref.invalidate(selectedArmyProvider);
  ref.invalidate(armyByIdProvider(army.id));
}

/// Demande confirmation avant une suppression définitive (unité ou
/// armée), pour éviter qu'un clic accidentel sur un bouton "facile
/// d'accès" (croix de la sidebar, etc.) ne fasse disparaître quelque
/// chose sans retour possible.
Future<bool> _confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialogShortcuts(
      onEnter: () => Navigator.of(dialogContext).pop(true),
      child: AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(title, style: AppTextStyles.title),
        content: Text(message, style: AppTextStyles.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.armyBuilderCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    ),
  );
  return confirmed ?? false;
}

/// Retire une unité de l'armée et propose de revenir en arrière via un
/// SnackBar — contrairement à d'autres suppressions de l'appli (dont la
/// confirmation suffit), recréer une unité à la main coûte plus cher que
/// juste "annuler" (retrouver la datasheet, resaisir le nombre de
/// figurines). L'"annuler" ne restaure que la fiche et l'effectif — pas
/// les choix d'armes/l'attachement/le statut Warlord de l'unité
/// d'origine, une limite acceptée pour rester une action ponctuelle
/// simple plutôt qu'un vrai historique d'annulation.
Future<void> _removeUnitWithUndo(
  BuildContext context,
  WidgetRef ref, {
  required ArmyDetails army,
  required ArmyUnitDetails unit,
}) async {
  // Le retrait fait souvent disparaître le widget qui a déclenché cette
  // action (ex. le panneau de détails, remplacé par la vue d'ensemble une
  // fois l'armée vide) — son `ref` devient alors invalide. Le conteneur
  // de providers, lui, survit tant que la page Armées reste affichée :
  // c'est lui qu'utilise le bouton "Annuler" du SnackBar, potentiellement
  // pressé bien après ce rebuild.
  final container = ProviderScope.containerOf(context, listen: false);
  final armyRepository = container.read(armyRepositoryProvider);

  await armyRepository.removeUnit(unit.id);
  if (container.read(selectedUnitIdProvider) == unit.id) {
    container.read(selectedUnitIdProvider.notifier).state = null;
  }
  container.invalidate(selectedArmyProvider);
  container.invalidate(armiesListProvider);
  container.invalidate(armyByIdProvider(army.id));

  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.armyBuilderUnitRemoved(unit.datasheetName)),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: l10n.armyBuilderUndoRemove,
        onPressed: () async {
          await armyRepository.addUnit(
            armyId: army.id,
            datasheetId: unit.datasheetId,
            modelCount: unit.modelCount,
          );
          container.invalidate(selectedArmyProvider);
          container.invalidate(armiesListProvider);
          container.invalidate(armyByIdProvider(army.id));
        },
      ),
    ),
  );
}

/// Ajoute une copie d'une unité déjà présente dans l'armée (même
/// datasheet, même nombre de figurines, mêmes choix d'armes
/// optionnelles) — évite de tout reconfigurer à la main pour une 2e
/// escouade identique. L'enhancement n'est volontairement pas copié :
/// une armée ne peut en avoir que 3 au total, dupliquer le forcerait
/// à en retirer un ailleurs de toute façon.
Future<void> _duplicateUnit(
  WidgetRef ref,
  ArmyDetails army,
  ArmyUnitDetails unit,
) async {
  final armyRepository = ref.read(armyRepositoryProvider);
  final newUnitId = await armyRepository.addUnit(
    armyId: army.id,
    datasheetId: unit.datasheetId,
    modelCount: unit.modelCount,
  );
  final selections = await armyRepository.getUnitEquipmentSelections(unit.id);
  for (final entry in selections.entries) {
    if (entry.value.isEmpty) continue;
    await armyRepository.setUnitEquipmentSelection(
      newUnitId,
      entry.key,
      entry.value,
    );
  }
  ref.invalidate(selectedArmyProvider);
  ref.invalidate(armiesListProvider);
  ref.invalidate(armyByIdProvider(army.id));
  ref.read(selectedUnitIdProvider.notifier).state = newUnitId;
}

bool _isBattleline(String role) {
  final normalized = role.toLowerCase();
  return normalized.contains('battleline') ||
      normalized.contains('troops') ||
      normalized.contains('troupes');
}

const _maxEnhancements = ArmyValidationService.maxEnhancements;

class ArmiesPage extends ConsumerWidget {
  const ArmiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedArmyIdProvider);

    if (selectedId == null) {
      return const _ArmyListPage();
    }

    final detailAsync = ref.watch(selectedArmyProvider);

    return Scaffold(
      backgroundColor: AppWallpapers.app == null
          ? AppColors.background
          : Colors.transparent,
      body: detailAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) =>
            Center(child: Text('$error', style: AppTextStyles.caption)),
        data: (army) {
          if (army == null) return const _ArmyListPage();
          return _ArmyBuilderPage(army: army);
        },
      ),
    );
  }
}

class _ArmyListPage extends ConsumerWidget {
  const _ArmyListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);

    final ambianceFile = LocalCatalogImages.branding('hero-battle-siege');

    return Scaffold(
      backgroundColor: AppWallpapers.app == null
          ? AppColors.background
          : Colors.transparent,
      body: Stack(
        children: [
          if (ambianceFile != null)
            Positioned.fill(
              child: Image.file(
                ambianceFile,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          if (ambianceFile != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: .55),
                      AppColors.background.withValues(alpha: .93),
                      AppColors.background,
                    ],
                    stops: const [0, 0.45, 0.75],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.navArmies, style: AppTextStyles.heading),
                    IconButton(
                      tooltip: l10n.dashboardCreateArmyShort,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const CreateArmyDialog(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: armiesAsync.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Text('$error', style: AppTextStyles.caption),
                    ),
                    data: (armies) {
                      if (armies.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.armyBuilderEmptyList,
                            style: AppTextStyles.caption,
                          ),
                        );
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final columns = (constraints.maxWidth / 260)
                              .floor()
                              .clamp(1, 5);
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columns,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.9,
                                ),
                            itemCount: armies.length,
                            itemBuilder: (context, index) {
                              final army = armies[index];
                              return AppCard(
                                onTap: () =>
                                    ref
                                        .read(selectedArmyIdProvider.notifier)
                                        .state = army
                                        .id,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      army.name,
                                      style: AppTextStyles.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        FactionBadgeIcon(
                                          factionName: army.factionName,
                                          factionId: army.factionId,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            army.factionName,
                                            style: AppTextStyles.caption,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          army.pointsLimit != null
                                              ? l10n.armyBuilderPointsWithLimit(
                                                  army.totalPoints,
                                                  army.pointsLimit!,
                                                )
                                              : l10n.pointsSuffix(
                                                  army.totalPoints,
                                                ),
                                          style: AppTextStyles.body.copyWith(
                                            color: army.hasValidationErrors
                                                ? AppColors.error
                                                : AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if (army.hasUnknownCost) ...[
                                          const SizedBox(width: 6),
                                          Tooltip(
                                            message: l10n.unknownCostTooltip,
                                            child: Icon(
                                              Icons.warning_amber_rounded,
                                              size: 16,
                                              color: AppColors.warning,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Change le détachement d'une armée déjà créée. Réinitialise au
/// passage les enhancements des unités (ils sont propres à un
/// détachement, voir [ArmyDao.setDetachment]) et en informe l'
/// utilisateur si ça a concrètement retiré quelque chose.
Future<void> _pickDetachment(
  BuildContext context,
  WidgetRef ref,
  ArmyDetails army,
) async {
  final l10n = AppLocalizations.of(context)!;
  final options = await ref
      .read(armyRepositoryProvider)
      .getDetachmentsForFaction(army.factionId);

  if (!context.mounted) return;

  final selected = await showDialog<String?>(
    context: context,
    builder: (context) => AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text(
                    l10n.armyBuilderDetachmentNone,
                    style: AppTextStyles.body,
                  ),
                  selected: army.detachmentId == null,
                  selectedColor: AppColors.primary,
                  onTap: () => Navigator.of(context).pop(''),
                ),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option.name, style: AppTextStyles.body),
                    selected: option.id == army.detachmentId,
                    selectedColor: AppColors.primary,
                    onTap: () => Navigator.of(context).pop(option.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  if (selected == null) return; // dialogue fermé sans choix
  final newDetachmentId = selected.isEmpty ? null : selected;
  if (newDetachmentId == army.detachmentId) return;

  final resetCount = await ref
      .read(armyRepositoryProvider)
      .setDetachment(army.id, newDetachmentId);
  ref.invalidate(selectedArmyProvider);
  ref.invalidate(armiesListProvider);
  ref.invalidate(armyByIdProvider(army.id));

  if (resetCount > 0 && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.armyBuilderEnhancementsReset(resetCount)),
        backgroundColor: AppColors.surface,
      ),
    );
  }
}

Future<void> _pickEnhancement(
  BuildContext context,
  WidgetRef ref,
  String detachmentId,
  ArmyUnitDetails unit,
  ArmyDetails army,
) async {
  final l10n = AppLocalizations.of(context)!;
  final allOptions = await ref
      .read(armyRepositoryProvider)
      .getEnhancementsForDetachment(detachmentId);

  // Une amélioration ne peut être portée que par une seule figurine de
  // l'armée à la fois : celles déjà prises par une AUTRE unité ne sont
  // pas proposées ici (mais l'unité en cours garde la sienne dans la
  // liste, pour pouvoir la reconfirmer sans la perdre).
  final usedElsewhere = army.units
      .where((u) => u.id != unit.id)
      .map((u) => u.enhancementId)
      .whereType<String>()
      .toSet();
  final options = allOptions
      .where((o) => !usedElsewhere.contains(o.id))
      .toList();

  if (!context.mounted) return;

  final selected = await showDialog<String?>(
    context: context,
    builder: (context) => AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 460,
          height: 520,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView(
              children: [
                ListTile(
                  title: Text(
                    l10n.armyBuilderEnhancementNone,
                    style: AppTextStyles.body,
                  ),
                  onTap: () => Navigator.of(context).pop(''),
                ),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option.name, style: AppTextStyles.body),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.pointsSuffix(option.points),
                          style: AppTextStyles.caption,
                        ),
                        if (option.description != null &&
                            option.description!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            option.description!,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ],
                    ),
                    onTap: () => Navigator.of(context).pop(option.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  if (selected == null) return; // dialog dismissed, no change

  await ref
      .read(armyRepositoryProvider)
      .setUnitEnhancement(unit.id, selected.isEmpty ? null : selected);
  ref.invalidate(selectedArmyProvider);
  ref.invalidate(armiesListProvider);
  ref.invalidate(armyByIdProvider(army.id));
}

/// Liste d'armes effective d'une unité d'armée : les armes fixes de la
/// datasheet plus, pour chaque groupe d'équipement optionnel, l'arme
/// liée à l'option actuellement choisie (ou l'option par défaut si rien
/// n'a encore été sélectionné pour ce groupe).
List<WeaponDetails> _effectiveWeapons(
  DatasheetDetails sheet,
  Map<String, List<String>> selections,
) {
  final swappableWeaponIds = <String>{
    for (final group in sheet.equipmentGroups)
      for (final option in group.options)
        if (option.weaponId != null) option.weaponId!,
  };

  final chosenWeaponIds = <String>{};
  for (final group in sheet.equipmentGroups) {
    final currentOptionIds = group.options.map((o) => o.id).toSet();
    final selected = selections[group.id];
    // Une sélection enregistrée dont plus aucun id ne correspond aux
    // options actuelles du groupe (ex. ré-import du catalogue ayant
    // régénéré les ids d'équipement) ne doit pas faire disparaître
    // l'arme du groupe : repli sur l'option par défaut, comme si rien
    // n'avait encore été choisi.
    final hasValidSelection =
        selected != null && selected.any(currentOptionIds.contains);
    final chosenOptionIds = hasValidSelection
        ? selected
        : group.options
              .where((option) => option.isDefault)
              .map((option) => option.id)
              .toList();
    for (final optionId in chosenOptionIds) {
      for (final option in group.options) {
        if (option.id == optionId && option.weaponId != null) {
          chosenWeaponIds.add(option.weaponId!);
        }
      }
    }
  }

  return sheet.weapons
      .where(
        (weapon) =>
            !swappableWeaponIds.contains(weapon.id) ||
            chosenWeaponIds.contains(weapon.id),
      )
      .toList();
}

Widget _weaponsTable(AppLocalizations l10n, List<WeaponDetails> weaponList) {
  final rows = <TableRow>[
    TableRow(
      children: [
        _weaponHeaderCell(l10n.weaponColName),
        _weaponHeaderCell(l10n.weaponColRange, alignEnd: true),
        _weaponHeaderCell(l10n.weaponColAttacks, alignEnd: true),
        _weaponHeaderCell(l10n.weaponColStrength, alignEnd: true),
        _weaponHeaderCell(l10n.weaponColAp, alignEnd: true),
        _weaponHeaderCell(l10n.weaponColDamage, alignEnd: true),
      ],
    ),
  ];

  for (final weapon in weaponList) {
    if (weapon.profiles.isEmpty) {
      rows.add(
        TableRow(
          children: [
            _weaponCell(weapon.name, bold: true),
            _weaponCell('—', alignEnd: true),
            _weaponCell('—', alignEnd: true),
            _weaponCell('—', alignEnd: true),
            _weaponCell('—', alignEnd: true),
            _weaponCell('—', alignEnd: true),
          ],
        ),
      );
      continue;
    }
    for (var i = 0; i < weapon.profiles.length; i++) {
      final profile = weapon.profiles[i];
      final label = weapon.profiles.length > 1
          ? '${weapon.name} — ${profile.name}'
          : weapon.name;
      rows.add(
        TableRow(
          children: [
            _weaponCell(label, bold: true),
            _weaponCell(
              profile.isMelee ? l10n.weaponMelee : '${profile.range}"',
              alignEnd: true,
            ),
            _weaponCell(profile.attacks, alignEnd: true),
            _weaponCell('${profile.strength}', alignEnd: true),
            _weaponCell('${profile.armorPenetration}', alignEnd: true),
            _weaponCell(profile.damage, alignEnd: true),
          ],
        ),
      );
    }
  }

  return Table(
    columnWidths: const {
      0: FlexColumnWidth(2.2),
      1: FlexColumnWidth(1),
      2: FlexColumnWidth(0.7),
      3: FlexColumnWidth(0.7),
      4: FlexColumnWidth(0.7),
      5: FlexColumnWidth(0.7),
    },
    border: TableBorder(horizontalInside: BorderSide(color: AppColors.border)),
    children: rows,
  );
}

Widget _weaponHeaderCell(String label, {bool alignEnd = false}) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.eyebrow,
      ),
    ),
  );
}

Widget _weaponCell(String value, {bool bold = false, bool alignEnd = false}) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.middle,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Text(
        value,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: AppTextStyles.body.copyWith(
          fontSize: 13,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    ),
  );
}

class _ArmyBuilderPage extends ConsumerWidget {
  final ArmyDetails army;

  const _ArmyBuilderPage({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    ArmyUnitDetails? selectedUnit;
    if (selectedUnitId != null) {
      for (final unit in army.units) {
        if (unit.id == selectedUnitId) {
          selectedUnit = unit;
          break;
        }
      }
    }
    selectedUnit ??= army.units.isEmpty ? null : army.units.first;

    final bannerFile = LocalCatalogImages.factionBanner(army.factionId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: bannerFile != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(bannerFile),
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: Container(
            decoration: bannerFile != null
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.background.withValues(alpha: .88),
                        AppColors.background.withValues(alpha: .55),
                      ],
                    ),
                  )
                : null,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: _BuilderTopBar(army: army),
          ),
        ),
        Consumer(
          builder: (context, ref, _) {
            final l10n = AppLocalizations.of(context)!;
            final validation = ref.watch(armyValidationProvider(army));
            if (validation == null ||
                (validation.errors.isEmpty && validation.warnings.isEmpty)) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...validation.errors.map(
                    (issue) => _ValidationLine(
                      icon: Icons.error_outline_rounded,
                      color: AppColors.error,
                      text: _warningLabel(l10n, issue),
                    ),
                  ),
                  ...validation.warnings.map(
                    (issue) => _ValidationLine(
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      text: _warningLabel(l10n, issue),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(height: 1, color: AppColors.border),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final unitGrid = army.units.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.armyBuilderEmptyUnits,
                          style: AppTextStyles.caption,
                        ),
                      ),
                    )
                  : _GroupedUnitGrid(army: army, selectedUnit: selectedUnit);

              // Trois colonnes fixes (300 + grille + 340) ne laissent plus
              // de place à rien sur un écran de téléphone — on empile
              // sidebar, grille puis détails de l'unité sélectionnée dans
              // une seule colonne défilante. Toujours affiché, même sans
              // unité sélectionnée : c'est là que vit l'onglet "Vue
              // d'ensemble" (profil/radar/recommandations), utile dès
              // qu'une armée existe, y compris vide.
              if (constraints.maxWidth < 900) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hauteur bornée : la sidebar contient une liste
                      // interne (Expanded) qui a besoin d'une hauteur
                      // finie pour se disposer une fois placée dans un
                      // parent défilant (hauteur non bornée autrement).
                      SizedBox(height: 420, child: _BuilderSidebar(army: army)),
                      Container(height: 1, color: AppColors.border),
                      unitGrid,
                      Container(height: 1, color: AppColors.border),
                      _UnitDetailsPanel(
                        key: ValueKey(army.id),
                        army: army,
                        unit: selectedUnit,
                      ),
                    ],
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 300, child: _BuilderSidebar(army: army)),
                  Container(width: 1, color: AppColors.border),
                  Expanded(flex: 2, child: unitGrid),
                  Container(width: 1, color: AppColors.border),
                  SizedBox(
                    width: 340,
                    child: _UnitDetailsPanel(
                      key: ValueKey(army.id),
                      army: army,
                      unit: selectedUnit,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ValidationLine extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _ValidationLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderTopBar extends ConsumerWidget {
  final ArmyDetails army;

  const _BuilderTopBar({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final validation = ref.watch(armyValidationProvider(army));
    final isValid = validation?.isValid ?? true;
    final battlelineCount = army.units
        .where((u) => _isBattleline(u.battlefieldRole))
        .length;
    final enhancementsCount = army.units
        .where((u) => u.enhancementId != null)
        .length;

    final statsWrap = Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 8,
      children: [
        _StatColumn(
          label: l10n.armyBuilderStatPoints,
          value: army.pointsLimit != null
              ? l10n.armyBuilderPointsWithLimit(
                  army.totalPoints,
                  army.pointsLimit!,
                )
              : l10n.pointsSuffix(army.totalPoints),
          color: army.isOverLimit ? AppColors.error : AppColors.primary,
        ),
        _StatColumn(
          label: l10n.armyBuilderStatUnits,
          value: '${army.units.length}',
        ),
        _StatColumn(
          label: l10n.armyBuilderStatBattleline,
          value: '$battlelineCount',
        ),
        _StatColumn(
          label: l10n.armyBuilderStatEnhancements,
          value: '$enhancementsCount/$_maxEnhancements',
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: (isValid ? AppColors.success : AppColors.error).withValues(
              alpha: .14,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isValid ? Icons.check_circle_rounded : Icons.error_rounded,
                size: 14,
                color: isValid ? AppColors.success : AppColors.error,
              ),
              const SizedBox(width: 4),
              Text(
                isValid
                    ? l10n.armyBuilderListValid
                    : l10n.armyBuilderListInvalid,
                style: AppTextStyles.eyebrow.copyWith(
                  color: isValid ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              tooltip: l10n.armyBuilderBack,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                ref.read(selectedArmyIdProvider.notifier).state = null;
                ref.read(selectedUnitIdProvider.notifier).state = null;
              },
            ),
            const SizedBox(width: 8),
            FactionBadgeIcon(
              factionName: army.factionName,
              factionId: army.factionId,
              size: 32,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    army.name,
                    style: AppTextStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    army.detachmentName != null
                        ? '${army.factionName} · ${army.detachmentName}'
                        : army.factionName,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              tooltip: l10n.armyBuilderMoreActions,
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textSecondary,
              ),
              color: AppColors.surface,
              onSelected: (value) async {
                switch (value) {
                  case 'copy':
                    await Clipboard.setData(
                      ClipboardData(text: ArmyListFormatter.format(army)),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.armyBuilderCopiedToClipboard),
                          backgroundColor: AppColors.surface,
                        ),
                      );
                    }
                    break;
                  case 'notes':
                    showDialog(
                      context: context,
                      builder: (_) => _NotesDialog(
                        armyId: army.id,
                        initialNotes: army.notes,
                      ),
                    );
                    break;
                  case 'duplicate':
                    showDialog(
                      context: context,
                      builder: (_) => _DuplicateArmyDialog(army: army),
                    );
                    break;
                  case 'delete':
                    final confirmed = await _confirmDelete(
                      context,
                      title: l10n.armyBuilderDeleteArmyConfirmTitle,
                      message: l10n.armyBuilderDeleteArmyConfirmMessage(
                        army.name,
                      ),
                      confirmLabel: l10n.armyBuilderDeleteArmy,
                    );
                    if (!confirmed) break;
                    await ref.read(armyRepositoryProvider).deleteArmy(army.id);
                    ref.read(selectedArmyIdProvider.notifier).state = null;
                    ref.invalidate(armiesListProvider);
                    // deleteArmy annule armyId/opponentArmyId sur les
                    // batailles qui référençaient cette armée (préserve
                    // leur historique) — sans cette invalidation, l'onglet
                    // Bataille/Statistiques continue d'afficher son nom
                    // jusqu'au redémarrage de l'app (FutureProvider mis en
                    // cache, pas autoDispose).
                    ref.invalidate(battlesListProvider);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'copy',
                  child: Text(
                    l10n.armyBuilderCopyList,
                    style: AppTextStyles.body,
                  ),
                ),
                PopupMenuItem(
                  value: 'notes',
                  child: Text(
                    l10n.armyBuilderNotesLabel,
                    style: AppTextStyles.body,
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: Text(
                    l10n.armyBuilderDuplicate,
                    style: AppTextStyles.body,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    l10n.armyBuilderDeleteArmy,
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        statsWrap,
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatColumn({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.eyebrow),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _BuilderSidebar extends ConsumerStatefulWidget {
  final ArmyDetails army;

  const _BuilderSidebar({required this.army});

  @override
  ConsumerState<_BuilderSidebar> createState() => _BuilderSidebarState();
}

class _BuilderSidebarState extends ConsumerState<_BuilderSidebar> {
  final _rosterFilterController = TextEditingController();
  String _rosterFilter = '';

  @override
  void dispose() {
    _rosterFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final army = widget.army;
    final l10n = AppLocalizations.of(context)!;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    final normalizedRosterFilter = normalizeForSearch(_rosterFilter);
    final datasheetAliases = ref
        .watch(datasheetAliasesProvider)
        .maybeWhen(data: (m) => m, orElse: () => const {});
    final filteredUnits = normalizedRosterFilter.isEmpty
        ? army.units
        : army.units.where((unit) {
            if (normalizeForSearch(
              unit.datasheetName,
            ).contains(normalizedRosterFilter)) {
              return true;
            }
            return (datasheetAliases[unit.datasheetId] ?? const []).any(
              (alias) =>
                  normalizeForSearch(alias).contains(normalizedRosterFilter),
            );
          }).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.armyBuilderDetachmentSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _pickDetachment(context, ref, army),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            army.detachmentName ?? l10n.armyBuilderNoDetachment,
                            style: AppTextStyles.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(army.factionName, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const DecorSeparator(
            maxWidth: 280,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          Text(
            l10n.armyBuilderRulesSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: army.detachmentId == null
                ? null
                : () => showDialog(
                    context: context,
                    builder: (_) => _StratagemsDialog(
                      detachmentId: army.detachmentId!,
                      factionId: army.factionId,
                    ),
                  ),
            child: Text(
              l10n.armyBuilderViewAllRules,
              style: AppTextStyles.body.copyWith(
                color: army.detachmentId == null
                    ? AppColors.textSecondary
                    : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.armyBuilderUnitsSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 6),
          if (army.units.length > 6) ...[
            SizedBox(
              height: 36,
              child: TextField(
                controller: _rosterFilterController,
                onChanged: (value) => setState(() => _rosterFilter = value),
                style: AppTextStyles.caption,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: l10n.catalogSearchHint,
                  hintStyle: AppTextStyles.caption,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 16,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: army.units.isEmpty
                ? const SizedBox.shrink()
                : filteredUnits.isEmpty
                ? Center(
                    child: Text(
                      l10n.catalogEmptyResults,
                      style: AppTextStyles.caption,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredUnits.length,
                    itemBuilder: (context, index) {
                      final unit = filteredUnits[index];
                      final attachedLeaderNames = army
                          .leadersAttachedTo(unit.id)
                          .map((leader) => leader.datasheetName)
                          .toList();
                      return _UnitRosterRow(
                        army: army,
                        unit: unit,
                        selected: unit.id == selectedUnitId,
                        attachedLeaderNames: attachedLeaderNames,
                        onTap: () =>
                            ref.read(selectedUnitIdProvider.notifier).state =
                                unit.id,
                        onDelete: () async {
                          final confirmed = await _confirmDelete(
                            context,
                            title: l10n.armyBuilderRemoveUnitConfirmTitle,
                            message: l10n.armyBuilderRemoveUnitConfirmMessage(
                              unit.datasheetName,
                            ),
                            confirmLabel: l10n.armyBuilderRemoveUnit,
                          );
                          if (!confirmed || !context.mounted) return;
                          await _removeUnitWithUndo(
                            context,
                            ref,
                            army: army,
                            unit: unit,
                          );
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(40),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (_) =>
                  AddUnitDialog(armyId: army.id, factionId: army.factionId),
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.armyBuilderAddUnit),
          ),
        ],
      ),
    );
  }
}

class _UnitRosterRow extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails unit;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  /// Noms des personnages actuellement attachés à cette unité (voir
  /// [ArmyDetails.leadersAttachedTo]) — vide si `unit` n'est pas une
  /// escouade hôte ou n'a aucun chef attaché.
  final List<String> attachedLeaderNames;

  const _UnitRosterRow({
    required this.army,
    required this.unit,
    required this.selected,
    required this.onTap,
    required this.onDelete,
    this.attachedLeaderNames = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(
      factionCatalogDetailsProvider(army.factionId),
    );
    final archetype = catalogAsync.value
        ?.where((d) => d.id == unit.datasheetId)
        .firstOrNull
        ?.archetype;

    final row = DragTarget<ArmyUnitDetails>(
      onWillAcceptWithDetails: (details) => details.data.id != unit.id,
      onAcceptWithDetails: (details) =>
          _handleUnitDrop(ref, army, dragged: details.data, target: unit),
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;
        return Draggable<ArmyUnitDetails>(
          data: unit,
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              width: 220,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 1.6),
              ),
              child: Text(
                unit.datasheetName,
                style: AppTextStyles.body,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: .3,
            child: _rowContent(l10n, archetype),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isDropTarget
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: _rowContent(l10n, archetype),
          ),
        );
      },
    );

    return Padding(padding: const EdgeInsets.only(bottom: 6), child: row);
  }

  Widget _rowContent(AppLocalizations l10n, UnitArchetype? archetype) {
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: .12)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              UnitPhotoThumbnail(
                datasheetId: unit.datasheetId,
                entryId: unit.id,
                size: 32,
                borderRadius: BorderRadius.circular(6),
                editable: false,
                fallback: UnitFallbackVisual(
                  factionName: army.factionName,
                  roleIcon: unitRoleIcon(
                    isWarlord: unit.isWarlord,
                    isCharacter: unit.isCharacter,
                    archetype: archetype,
                    battlefieldRole: unit.battlefieldRole,
                  ),
                  size: 32,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (unit.isWarlord) ...[
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Flexible(
                          child: Text(
                            unit.datasheetName,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (unit.modelCount > 1)
                      Text(
                        'x${unit.modelCount}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    if (unit.isCharacter && unit.attachedToUnitName != null)
                      Text(
                        '→ ${unit.attachedToUnitName}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (attachedLeaderNames.isNotEmpty)
                      Text(
                        '★ ${attachedLeaderNames.join(', ')}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Tooltip(
                message: unit.hasUnknownCost ? l10n.unknownCostTooltip : '',
                child: Text(
                  unit.hasUnknownCost
                      ? l10n.unknownCost
                      : l10n.pointsSuffix(unit.points),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: unit.hasUnknownCost
                        ? AppColors.warning
                        : AppColors.primary,
                    fontSize: 13,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.armyBuilderRemoveUnit,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.close_rounded, size: 16),
                color: AppColors.textSecondary,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Grille des unités groupées par rôle — chaque carte se glisse (clic
/// maintenu) sur une autre pour : attacher/détacher un personnage sur une
/// escouade (glisser un Character sur une non-Character, ou l'inverse pour
/// re-cibler), ou réordonner l'affichage (glisser deux unités de même
/// catégorie l'une sur l'autre). Les attachements actifs sont en plus
/// reliés par un trait visuel (voir [_AttachmentLinesPainter]).
class _GroupedUnitGrid extends StatefulWidget {
  final ArmyDetails army;
  final ArmyUnitDetails? selectedUnit;

  const _GroupedUnitGrid({required this.army, required this.selectedUnit});

  @override
  State<_GroupedUnitGrid> createState() => _GroupedUnitGridState();
}

class _GroupedUnitGridState extends State<_GroupedUnitGrid> {
  // Une GlobalKey stable par unité (le CustomPainter en a besoin pour
  // retrouver la position de chaque carte à l'écran) — recréer les clés à
  // chaque build casserait leur identité et ferait clignoter les cartes.
  final Map<String, GlobalKey> _cardKeys = {};
  final GlobalKey _stackKey = GlobalKey();

  GlobalKey _keyFor(String unitId) =>
      _cardKeys.putIfAbsent(unitId, GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final army = widget.army;
    _cardKeys.removeWhere((id, _) => !army.units.any((u) => u.id == id));

    final groups = <String, List<ArmyUnitDetails>>{};
    for (final unit in army.units) {
      final role = unit.battlefieldRole.isEmpty
          ? l10n.armyBuilderRoleOther
          : unit.battlefieldRole;
      groups.putIfAbsent(role, () => []).add(unit);
    }

    final attachedPairs = [
      for (final leader in army.units)
        if (leader.attachedToUnitId != null)
          (leaderId: leader.id, targetId: leader.attachedToUnitId!),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Stack(
        key: _stackKey,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final entry in groups.entries) ...[
                Text(
                  entry.key.toUpperCase(),
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = (constraints.maxWidth / 160).floor().clamp(
                      2,
                      6,
                    );
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        final unit = entry.value[index];
                        return _UnitCard(
                          key: _keyFor(unit.id),
                          army: army,
                          unit: unit,
                          attachedLeaderNames: army
                              .leadersAttachedTo(unit.id)
                              .map((leader) => leader.datasheetName)
                              .toList(),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
          if (attachedPairs.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _AttachmentLinesPainter(
                    stackKey: _stackKey,
                    cardKeys: _cardKeys,
                    pairs: attachedPairs,
                    lineColor: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Dessine un trait entre chaque personnage attaché et son escouade hôte,
/// avec un petit médaillon "maillon de chaîne" au milieu — calculé à partir
/// des positions réelles des cartes (via leurs [GlobalKey]) à chaque
/// repaint, donc toujours à jour même quand la grille change de colonnes.
class _AttachmentLinesPainter extends CustomPainter {
  final GlobalKey stackKey;
  final Map<String, GlobalKey> cardKeys;
  final List<({String leaderId, String targetId})> pairs;
  final Color lineColor;

  _AttachmentLinesPainter({
    required this.stackKey,
    required this.cardKeys,
    required this.pairs,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final stackBox = stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.attached) return;

    final linePaint = Paint()
      ..color = lineColor.withValues(alpha: .75)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final badgeBgPaint = Paint()..color = lineColor;

    for (final pair in pairs) {
      final leaderBox =
          cardKeys[pair.leaderId]?.currentContext?.findRenderObject()
              as RenderBox?;
      final targetBox =
          cardKeys[pair.targetId]?.currentContext?.findRenderObject()
              as RenderBox?;
      if (leaderBox == null ||
          targetBox == null ||
          !leaderBox.attached ||
          !targetBox.attached) {
        continue;
      }

      final from = leaderBox.localToGlobal(
        leaderBox.size.center(Offset.zero),
        ancestor: stackBox,
      );
      final to = targetBox.localToGlobal(
        targetBox.size.center(Offset.zero),
        ancestor: stackBox,
      );
      canvas.drawLine(from, to, linePaint);

      final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
      canvas.drawCircle(mid, 11, badgeBgPaint);
      const icon = Icons.link_rounded;
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: 13,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        mid - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AttachmentLinesPainter oldDelegate) {
    return true;
  }
}

class _UnitCard extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails unit;
  final List<String> attachedLeaderNames;

  const _UnitCard({
    super.key,
    required this.army,
    required this.unit,
    this.attachedLeaderNames = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    final selected = unit.id == selectedUnitId;
    // Archétype réel de la fiche (horde/élite/blindé/anti-char/soutien),
    // pour une icône de repli plus précise qu'un symbole générique —
    // même donnée que le radar de profil d'armée, déjà mise en cache par
    // ce même provider quand l'onglet Vue d'ensemble a été ouvert.
    final catalogAsync = ref.watch(
      factionCatalogDetailsProvider(army.factionId),
    );
    final archetype = catalogAsync.value
        ?.where((d) => d.id == unit.datasheetId)
        .firstOrNull
        ?.archetype;

    return DragTarget<ArmyUnitDetails>(
      onWillAcceptWithDetails: (details) => details.data.id != unit.id,
      onAcceptWithDetails: (details) =>
          _handleUnitDrop(ref, army, dragged: details.data, target: unit),
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;
        // `Draggable` (pas `LongPressDraggable`) : sur desktop/souris, un
        // clic-glissé démarre naturellement en bougeant le curseur — un
        // seuil de maintien immobile façon "appui long tactile" est
        // presque toujours annulé par ce mouvement avant même de se
        // déclencher, ce qui rendait le glisser-déposer silencieusement
        // inopérant.
        return Draggable<ArmyUnitDetails>(
          data: unit,
          feedback: _UnitCardVisual(
            unit: unit,
            factionName: army.factionName,
            archetype: archetype,
            attachedLeaderNames: attachedLeaderNames,
            selected: false,
            width: 160,
            opacity: .9,
          ),
          childWhenDragging: Opacity(
            opacity: .3,
            child: _UnitCardVisual(
              unit: unit,
              factionName: army.factionName,
              archetype: archetype,
              attachedLeaderNames: attachedLeaderNames,
              selected: selected,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: isDropTarget
                  ? Border.all(color: AppColors.primary, width: 2.4)
                  : null,
            ),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () =>
                    ref.read(selectedUnitIdProvider.notifier).state = unit.id,
                child: _UnitCardVisual(
                  unit: unit,
                  factionName: army.factionName,
                  archetype: archetype,
                  attachedLeaderNames: attachedLeaderNames,
                  selected: selected,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Contenu visuel d'une carte d'unité, séparé de [_UnitCard] pour être
/// réutilisé tel quel comme aperçu (`feedback`) pendant le glisser-déposer.
class _UnitCardVisual extends StatelessWidget {
  final ArmyUnitDetails unit;
  final String factionName;
  final UnitArchetype? archetype;
  final List<String> attachedLeaderNames;
  final bool selected;
  final double? width;
  final double opacity;

  const _UnitCardVisual({
    required this.unit,
    required this.factionName,
    required this.archetype,
    required this.attachedLeaderNames,
    required this.selected,
    this.width,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageFile = LocalCatalogImages.collectionPhoto(
      unit.datasheetId,
      unit.id,
    );

    final card = Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageFile != null)
              Image.file(imageFile, fit: BoxFit.cover)
            else if (AppWallpapers.cards != null)
              Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(AppWallpapers.cards!, fit: BoxFit.cover),
                  ColoredBox(
                    color: AppColors.surfaceElevated.withValues(
                      alpha: AppWallpapers.dimming,
                    ),
                  ),
                  UnitFallbackVisual(
                    factionName: factionName,
                    roleIcon: unitRoleIcon(
                      isWarlord: unit.isWarlord,
                      isCharacter: unit.isCharacter,
                      archetype: archetype,
                      battlefieldRole: unit.battlefieldRole,
                    ),
                  ),
                ],
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.surface, AppColors.surfaceElevated],
                  ),
                ),
                child: UnitFallbackVisual(
                  factionName: factionName,
                  roleIcon: unitRoleIcon(
                    isWarlord: unit.isWarlord,
                    isCharacter: unit.isCharacter,
                    archetype: archetype,
                    battlefieldRole: unit.battlefieldRole,
                  ),
                ),
              ),
            Positioned(
              top: 6,
              right: 6,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Nombre de figurines : toujours son propre badge, jamais
                  // accolé au nom en bas de carte — un nom de fiche long
                  // (fréquent en 40k) tronquait ce chiffre en dehors de la
                  // zone visible, le rendant invisible (cause du "on ne
                  // sait pas de combien est faite l'escouade").
                  if (unit.maximumModels > 1 || unit.modelCount > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '×${unit.modelCount}',
                        style: AppTextStyles.eyebrow.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: unit.hasUnknownCost
                          ? AppColors.warning.withValues(alpha: .85)
                          : Colors.black.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      unit.hasUnknownCost
                          ? l10n.unknownCost
                          : l10n.pointsSuffix(unit.points),
                      style: AppTextStyles.eyebrow.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (unit.isCharacter && unit.attachedToUnitName != null ||
                attachedLeaderNames.isNotEmpty)
              Positioned(
                top: 6,
                left: 6,
                child: Tooltip(
                  message: unit.isCharacter
                      ? l10n.armyBuilderAttachedTo(unit.attachedToUnitName!)
                      : attachedLeaderNames.join(', '),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      unit.isCharacter
                          ? Icons.link_rounded
                          : Icons.star_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 16, 10, 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: .75),
                    ],
                  ),
                ),
                child: Text(
                  unit.datasheetName,
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final sized = width == null
        ? AspectRatio(aspectRatio: 1, child: card)
        : SizedBox(width: width, height: width, child: card);

    return opacity == 1 ? sized : Opacity(opacity: opacity, child: sized);
  }
}

class _UnitDetailsPanel extends ConsumerStatefulWidget {
  final ArmyDetails army;
  final ArmyUnitDetails? unit;

  const _UnitDetailsPanel({super.key, required this.army, required this.unit});

  @override
  ConsumerState<_UnitDetailsPanel> createState() => _UnitDetailsPanelState();
}

class _UnitDetailsPanelState extends ConsumerState<_UnitDetailsPanel> {
  // `null` = pas encore de choix explicite de l'utilisateur : on suit le
  // comportement historique (afficher les détails de l'unité choisie).
  // Une fois togglé, le choix reste sticky même si la sélection d'unité
  // change entre-temps.
  bool? _showOverview;

  bool get _effectiveShowOverview {
    if (widget.unit == null) return true;
    return _showOverview ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showOverview = _effectiveShowOverview;
    final content = showOverview
        ? _ArmyOverviewCard(army: widget.army)
        : _UnitDetailsBody(army: widget.army, unit: widget.unit!);

    final tabs = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _PanelTabButton(
              label: l10n.armyOverviewTab,
              icon: Icons.radar_rounded,
              selected: showOverview,
              onTap: () => setState(() => _showOverview = true),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PanelTabButton(
              label: l10n.armyDetailsTab,
              icon: Icons.info_outline_rounded,
              selected: !showOverview,
              onTap: widget.unit == null
                  ? null
                  : () => setState(() => _showOverview = false),
            ),
          ),
        ],
      ),
    );
    final divider = Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: AppColors.border,
    );

    // Ce panneau est utilisé à la fois dans un contexte à hauteur bornée
    // (colonne desktop, cf. Row + CrossAxisAlignment.stretch dans
    // _ArmyBuilderPage) et dans un contexte à hauteur non bornée
    // (empilement mobile dans un SingleChildScrollView). Dans une Column,
    // un enfant non-flexible reçoit toute la hauteur disponible comme
    // plafond (pas "le reste après les autres enfants") : sans Expanded,
    // le contenu se comporte donc bien en hauteur non bornée (il se
    // limite à sa taille intrinsèque) mais déborde en hauteur bornée
    // (lui + les onglets dépassent le budget total). D'où ce
    // LayoutBuilder : Expanded seulement quand la hauteur est bornée.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            tabs,
            divider,
            constraints.hasBoundedHeight ? Expanded(child: content) : content,
          ],
        );
      },
    );
  }
}

class _PanelTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _PanelTabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    final color = disabled
        ? AppColors.textSecondary.withValues(alpha: .4)
        : (selected ? AppColors.primary : AppColors.textSecondary);
    return Material(
      color: selected
          ? AppColors.primary.withValues(alpha: .12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Détail de l'unité sélectionnée — le contenu historique de l'ancien
/// `_UnitDetailsPanel`, maintenant affiché uniquement sous l'onglet
/// "Détails" (voir [_UnitDetailsPanelState]).
class _UnitDetailsBody extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails unit;

  const _UnitDetailsBody({required this.army, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUnit = unit;

    final datasheetAsync = ref.watch(
      datasheetByIdProvider(currentUnit.datasheetId),
    );
    final selectionsAsync = ref.watch(
      unitEquipmentSelectionsProvider(currentUnit.id),
    );

    if (datasheetAsync.isLoading || selectionsAsync.isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (datasheetAsync.hasError) {
      return Center(
        child: Text('${datasheetAsync.error}', style: AppTextStyles.caption),
      );
    }
    if (selectionsAsync.hasError) {
      return Center(
        child: Text('${selectionsAsync.error}', style: AppTextStyles.caption),
      );
    }

    final sheet = datasheetAsync.value;
    final selections = selectionsAsync.value ?? const {};
    if (sheet == null) return const SizedBox.shrink();
    final effectiveWeapons = _effectiveWeapons(sheet, selections);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.armyBuilderUnitDetailsTitle.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 12),
          UnitPhotoThumbnail(
            datasheetId: sheet.id,
            entryId: currentUnit.id,
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.circular(14),
            fallback: UnitFallbackVisual(
              factionName: army.factionName,
              roleIcon: unitRoleIcon(
                isWarlord: currentUnit.isWarlord,
                isCharacter: currentUnit.isCharacter,
                archetype: sheet.archetype,
                battlefieldRole: currentUnit.battlefieldRole,
              ),
              size: 150,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(sheet.name, style: AppTextStyles.title)),
              IconButton(
                tooltip: currentUnit.isWarlord
                    ? l10n.armyBuilderUnsetWarlord
                    : l10n.armyBuilderSetWarlord,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: Icon(
                  currentUnit.isWarlord
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 20,
                ),
                color: AppColors.warning,
                onPressed: () => ref
                    .read(armyRepositoryProvider)
                    .setWarlord(
                      army.id,
                      currentUnit.isWarlord ? null : currentUnit.id,
                    )
                    .then((_) {
                      ref.invalidate(selectedArmyProvider);
                      ref.invalidate(armyByIdProvider(army.id));
                    }),
              ),
              Tooltip(
                message: currentUnit.hasUnknownCost
                    ? l10n.unknownCostTooltip
                    : '',
                child: Text(
                  currentUnit.hasUnknownCost
                      ? l10n.unknownCost
                      : l10n.pointsSuffix(currentUnit.points),
                  style: AppTextStyles.body.copyWith(
                    color: currentUnit.hasUnknownCost
                        ? AppColors.warning
                        : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.armyBuilderRemoveUnit,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.error,
                onPressed: () async {
                  final confirmed = await _confirmDelete(
                    context,
                    title: l10n.armyBuilderRemoveUnitConfirmTitle,
                    message: l10n.armyBuilderRemoveUnitConfirmMessage(
                      currentUnit.datasheetName,
                    ),
                    confirmLabel: l10n.armyBuilderRemoveUnit,
                  );
                  if (!confirmed || !context.mounted) return;
                  await _removeUnitWithUndo(
                    context,
                    ref,
                    army: army,
                    unit: currentUnit,
                  );
                },
              ),
            ],
          ),
          Consumer(
            builder: (context, ref, _) {
              final ownedAsync = ref.watch(ownedQuantityProvider(sheet.id));
              final owned = ownedAsync.value;
              if (owned == null) return const SizedBox.shrink();
              final needed = army.units
                  .where((u) => u.datasheetId == sheet.id)
                  .fold<int>(0, (sum, u) => sum + u.modelCount);
              if (owned >= needed) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 15,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l10n.armyBuilderOwnedShortage(owned, needed),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          if (sheet.models.isNotEmpty) _StatBlock(model: sheet.models.first),
          if (effectiveWeapons.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.sectionWeapons.toUpperCase(),
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 10),
            _weaponsTable(l10n, effectiveWeapons),
          ],
          if (sheet.equipmentGroups.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.sectionEquipment.toUpperCase(),
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 10),
            ...sheet.equipmentGroups.map((group) {
              final selected = selections[group.id];
              final chosenOptionIds = (selected != null && selected.isNotEmpty)
                  ? selected
                  : group.options
                        .where((option) => option.isDefault)
                        .map((option) => option.id)
                        .toList();
              final chosenNames = group.options
                  .where((option) => chosenOptionIds.contains(option.id))
                  .map((option) => option.name)
                  .join(', ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => _EquipmentGroupDialog(
                        armyId: army.id,
                        armyUnitId: currentUnit.id,
                        group: group,
                        initialSelection: chosenOptionIds,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.name, style: AppTextStyles.body),
                              const SizedBox(height: 2),
                              Text(
                                chosenNames.isEmpty ? '—' : chosenNames,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
          if (sheet.abilities.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.sectionAbilities.toUpperCase(),
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 10),
            ...sheet.abilities.map(
              (ability) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ability.name, style: AppTextStyles.body),
                          if (ability.description.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              ability.description,
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (currentUnit.isCharacter) ...[
            const SizedBox(height: 24),
            Text(
              l10n.armyBuilderAttachedToSection,
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 10),
            if (currentUnit.attachedToUnitId != null) ...[
              Text(
                l10n.armyBuilderAttachedTo(
                  currentUnit.attachedToUnitName ?? '',
                ),
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => _AttachLeaderDialog(
                          army: army,
                          character: currentUnit,
                        ),
                      ),
                      child: Text(
                        l10n.armyBuilderChangeAttachment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onPressed: () async {
                        await ref
                            .read(armyRepositoryProvider)
                            .detachCharacter(currentUnit.id);
                        ref.invalidate(selectedArmyProvider);
                        ref.invalidate(armyByIdProvider(army.id));
                      },
                      child: Text(
                        l10n.armyBuilderDetachLeader,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) =>
                      _AttachLeaderDialog(army: army, character: currentUnit),
                ),
                icon: const Icon(Icons.link_rounded, size: 18),
                label: Text(l10n.armyBuilderAttachLeader),
              ),
          ] else if (army.leadersAttachedTo(currentUnit.id).isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.armyBuilderAttachedLeadersSection,
              style: AppTextStyles.eyebrow,
            ),
            const SizedBox(height: 10),
            ...army
                .leadersAttachedTo(currentUnit.id)
                .map(
                  (leader) =>
                      _AttachedLeaderTile(armyId: army.id, leader: leader),
                ),
          ],
          if (army.detachmentId != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _pickEnhancement(
                context,
                ref,
                army.detachmentId!,
                currentUnit,
                army,
              ),
              child: Text(
                currentUnit.enhancementName ??
                    l10n.armyBuilderChooseEnhancement,
                style: AppTextStyles.body.copyWith(color: AppColors.primary),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) =>
                        _EditUnitDialog(army: army, unit: currentUnit),
                  ),
                  icon: const Icon(Icons.tune_rounded, size: 18),
                  label: Text(l10n.armyBuilderEditUnit),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () => _duplicateUnit(ref, army, currentUnit),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: Text(l10n.armyBuilderDuplicateUnit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Une ligne "chef attaché" dans le panneau de détails d'une escouade —
/// affiche le nom du personnage et les aptitudes qu'il apporte à l'unité
/// tant qu'il y est attaché (concept de "Leader" 10e/11e édition : les
/// aptitudes propres du personnage s'appliquent à toute l'unité). Seules
/// les aptitudes non-core sont montrées : les aptitudes core (Leader,
/// Infiltration...) sont des règles génériques déjà connues, pas un bonus
/// spécifique à ce chef.
class _AttachedLeaderTile extends ConsumerWidget {
  final String armyId;
  final ArmyUnitDetails leader;

  const _AttachedLeaderTile({required this.armyId, required this.leader});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sheetAsync = ref.watch(datasheetByIdProvider(leader.datasheetId));
    // `AbilityDetails.isCore` n'est jamais renseigné par le pipeline
    // d'import actuel (toujours `false`, y compris pour des aptitudes
    // génériques comme "Leader") — c'est `type` ("Core"/"Faction"/...)
    // qui distingue réellement une règle générique d'un vrai bonus
    // propre à ce personnage.
    final bonuses =
        sheetAsync.value?.abilities.where((a) => a.type != 'Core').toList() ??
        const [];

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leader.datasheetName,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (bonuses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      l10n.armyBuilderLeaderBonusesNone,
                      style: AppTextStyles.caption,
                    ),
                  )
                else
                  ...bonuses.map(
                    (ability) => Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ability.name,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (ability.description.isNotEmpty)
                            Text(
                              ability.description,
                              style: AppTextStyles.caption,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.armyBuilderDetachLeader,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            icon: const Icon(Icons.link_off_rounded, size: 16),
            color: AppColors.textSecondary,
            onPressed: () async {
              await ref.read(armyRepositoryProvider).detachCharacter(leader.id);
              ref.invalidate(selectedArmyProvider);
              ref.invalidate(armyByIdProvider(armyId));
            },
          ),
        ],
      ),
    );
  }
}

/// Fenêtre de choix de l'escouade à laquelle attacher un personnage — le
/// catalogue ne recense pas quel personnage a le droit de rejoindre quelle
/// escouade selon les règles officielles, donc le choix est laissé libre
/// parmi toutes les unités non-personnage de l'armée plutôt que bloqué sur
/// une éligibilité qu'on ne peut pas vérifier fiablement.
class _AttachLeaderDialog extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails character;

  const _AttachLeaderDialog({required this.army, required this.character});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final eligible = army.units.where((u) => !u.isCharacter).toList();

    return AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 380,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.armyBuilderPickUnitToAttach,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 16),
                if (eligible.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.armyBuilderNoEligibleUnits,
                      style: AppTextStyles.caption,
                    ),
                  )
                else
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 360),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: eligible.length,
                        itemBuilder: (context, index) {
                          final target = eligible[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              target.datasheetName,
                              style: AppTextStyles.body,
                            ),
                            subtitle: target.modelCount > 1
                                ? Text(
                                    'x${target.modelCount}',
                                    style: AppTextStyles.caption,
                                  )
                                : null,
                            onTap: () async {
                              await ref
                                  .read(armyRepositoryProvider)
                                  .attachCharacter(character.id, target.id);
                              ref.invalidate(selectedArmyProvider);
                              ref.invalidate(armyByIdProvider(army.id));
                              if (context.mounted) Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.armyBuilderCancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Onglet "Vue d'ensemble" du panneau de droite : profil dominant, radar
/// de forces/faiblesses et recommandations d'unités complémentaires —
/// affiché par défaut sur une armée vide, accessible à tout moment
/// ensuite (voir [_UnitDetailsPanelState]).
class _ArmyOverviewCard extends ConsumerWidget {
  final ArmyDetails army;

  const _ArmyOverviewCard({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(
      factionCatalogDetailsProvider(army.factionId),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: catalogAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        error: (error, _) => Text('$error', style: AppTextStyles.caption),
        data: (catalog) {
          final catalogById = {for (final d in catalog) d.id: d};
          final scores = computeArmyProfile(army, catalogById);
          final profile = dominantProfile(scores);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.armyOverviewSectionTitle.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 4),
              Text(armyProfileLabel(l10n, profile), style: AppTextStyles.title),
              const SizedBox(height: 8),
              if (army.units.isEmpty)
                Text(l10n.armyOverviewEmptyArmy, style: AppTextStyles.caption)
              else
                Center(
                  child: RadarChart(
                    size: 220,
                    axes: [
                      RadarAxis(
                        label: armyProfileAxisName(l10n, ArmyProfileAxis.tir),
                        value: scores.tir,
                      ),
                      RadarAxis(
                        label: armyProfileAxisName(
                          l10n,
                          ArmyProfileAxis.corpsACorps,
                        ),
                        value: scores.corpsACorps,
                      ),
                      RadarAxis(
                        label: armyProfileAxisName(
                          l10n,
                          ArmyProfileAxis.resilience,
                        ),
                        value: scores.resilience,
                      ),
                      RadarAxis(
                        label: armyProfileAxisName(
                          l10n,
                          ArmyProfileAxis.mobilite,
                        ),
                        value: scores.mobilite,
                      ),
                      RadarAxis(
                        label: armyProfileAxisName(
                          l10n,
                          ArmyProfileAxis.controle,
                        ),
                        value: scores.controle,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              _RecommendationsBlock(army: army, catalog: catalog),
            ],
          );
        },
      ),
    );
  }
}

/// Bandeau "tutoriel" de recommandations d'unités complémentaires — voir
/// [suggestUnits] pour la logique (synergie issue des listes de style
/// par faction, avec repli sur les trous de rôle).
class _RecommendationsBlock extends ConsumerWidget {
  final ArmyDetails army;
  final List<DatasheetDetails> catalog;

  const _RecommendationsBlock({required this.army, required this.catalog});

  Future<void> _addSuggestion(
    BuildContext context,
    WidgetRef ref,
    DatasheetDetails sheet,
  ) async {
    final armyRepository = ref.read(armyRepositoryProvider);
    Object? failure;
    try {
      await armyRepository.addUnit(
        armyId: army.id,
        datasheetId: sheet.id,
        modelCount: sheet.unit.defaultSize,
      );
    } catch (e) {
      failure = e;
    } finally {
      ref.invalidate(selectedArmyProvider);
      ref.invalidate(armiesListProvider);
      ref.invalidate(armyByIdProvider(army.id));
    }

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failure == null
              ? l10n.armyBuilderUnitAdded(sheet.name)
              : l10n.armyBuilderAddUnitError(sheet.name),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final synergyAsync = ref.watch(armySynergyDataProvider);

    return synergyAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (synergy) {
        final suggestions = suggestUnits(
          army: army,
          synergy: synergy,
          factionCatalog: catalog,
          remainingPoints: army.pointsLimit == null
              ? null
              : army.pointsLimit! - army.totalPoints,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  size: 15,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.armyRecommendationsTitle.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (suggestions.isEmpty)
              Text(l10n.armyRecommendationEmpty, style: AppTextStyles.caption)
            else
              ...suggestions.map(
                (suggestion) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    onTap: () => _addSuggestion(
                      context,
                      ref,
                      catalog.firstWhere((d) => d.id == suggestion.datasheetId),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.datasheetName,
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                suggestion.reason ==
                                        UnitSuggestionReason.synergy
                                    ? l10n.armyRecommendationReasonSynergy(
                                        suggestion.synergyPartnerName ?? '',
                                      )
                                    : l10n.armyRecommendationReasonRoleGap(
                                        archetypeName(
                                          l10n,
                                          suggestion.missingArchetype!,
                                        ),
                                      ),
                                style: AppTextStyles.caption,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.add_circle_outline_rounded,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _StatBlock extends StatelessWidget {
  final ModelDetails model;

  const _StatBlock({required this.model});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = <String, String>{
      l10n.statMovement: '${model.movement}"',
      l10n.statToughness: '${model.toughness}',
      l10n.statSave: '${model.save}+',
      l10n.statWounds: '${model.wounds}',
      l10n.statLeadership: '${model.leadership}+',
      l10n.statObjectiveControl: '${model.objectiveControl}',
    };

    return Row(
      children: stats.entries
          .map(
            (entry) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        entry.key,
                        style: AppTextStyles.eyebrow.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.value,
                        style: AppTextStyles.title.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EquipmentGroupDialog extends ConsumerStatefulWidget {
  final String armyId;
  final String armyUnitId;
  final EquipmentGroupDetails group;
  final List<String> initialSelection;

  const _EquipmentGroupDialog({
    required this.armyId,
    required this.armyUnitId,
    required this.group,
    required this.initialSelection,
  });

  @override
  ConsumerState<_EquipmentGroupDialog> createState() =>
      _EquipmentGroupDialogState();
}

class _EquipmentGroupDialogState extends ConsumerState<_EquipmentGroupDialog> {
  late Set<String> _selected;

  bool get _isSingleChoice => widget.group.maximumChoices <= 1;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection.toSet();
  }

  void _toggle(String optionId, bool value) {
    setState(() {
      if (_isSingleChoice) {
        _selected = value ? {optionId} : {};
        return;
      }
      if (value) {
        if (_selected.length < widget.group.maximumChoices) {
          _selected.add(optionId);
        }
      } else {
        _selected.remove(optionId);
      }
    });
  }

  Future<void> _save() async {
    await ref
        .read(armyRepositoryProvider)
        .setUnitEquipmentSelection(
          widget.armyUnitId,
          widget.group.id,
          _selected.toList(),
        );
    ref.invalidate(unitEquipmentSelectionsProvider(widget.armyUnitId));
    // Sans ces deux invalidations, "Copier la liste" (qui lit
    // ArmyDetails.units[].equipmentChoices, calculé une fois pour toutes
    // par selectedArmyProvider) continuait d'exporter l'ancien choix
    // d'arme tant qu'aucune autre action ne rafraîchissait par ailleurs.
    ref.invalidate(selectedArmyProvider);
    ref.invalidate(armiesListProvider);
    ref.invalidate(armyByIdProvider(widget.armyId));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canSave = _selected.length >= widget.group.minimumChoices;

    return AppDialogShortcuts(
      onEnter: canSave ? _save : null,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.group.name, style: AppTextStyles.title),
                const SizedBox(height: 4),
                Text(
                  _isSingleChoice
                      ? l10n.armyBuilderPickOne
                      : l10n.armyBuilderPickUpTo(widget.group.maximumChoices),
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: _isSingleChoice
                      ? RadioGroup<String>(
                          groupValue: _selected.isEmpty
                              ? null
                              : _selected.first,
                          onChanged: (value) {
                            if (value != null) _toggle(value, true);
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: widget.group.options.map((option) {
                              return RadioListTile<String>(
                                value: option.id,
                                title: Text(
                                  option.name,
                                  style: AppTextStyles.body,
                                ),
                                activeColor: AppColors.primary,
                                contentPadding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          children: widget.group.options.map((option) {
                            return CheckboxListTile(
                              value: _selected.contains(option.id),
                              onChanged: (value) =>
                                  _toggle(option.id, value ?? false),
                              title: Text(
                                option.name,
                                style: AppTextStyles.body,
                              ),
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.armyBuilderCancel,
                        style: AppTextStyles.body,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: canSave ? _save : null,
                      child: Text(l10n.armyBuilderSave),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditUnitDialog extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails unit;

  const _EditUnitDialog({required this.army, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // L'armée peut changer pendant que ce dialogue reste ouvert (compteur de
    // figurines modifié via les boutons +/- ci-dessous) : on relit l'unité
    // à jour depuis le provider plutôt que de garder l'instantané passé au
    // constructeur, sinon le dialogue affiche un compteur figé.
    final freshArmy = ref.watch(selectedArmyProvider).value;
    final currentUnit =
        freshArmy?.units.firstWhere(
          (u) => u.id == unit.id,
          orElse: () => unit,
        ) ??
        unit;

    return AppDialogShortcuts(
      // Pas de confirmation à Entrée ici : la seule action "principale"
      // visible serait Retirer l'unité, destructive — on ne veut pas
      // qu'un Entrée irréfléchi la déclenche.
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentUnit.datasheetName, style: AppTextStyles.title),
                const SizedBox(height: 20),
                if (currentUnit.maximumModels > currentUnit.minimumModels) ...[
                  Text(
                    l10n.armyBuilderModelCountLabel,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        tooltip: l10n.armyBuilderModelCountDecrease,
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        color: AppColors.textSecondary,
                        onPressed:
                            currentUnit.modelCount <= currentUnit.minimumModels
                            ? null
                            : () async {
                                await ref
                                    .read(armyRepositoryProvider)
                                    .updateModelCount(
                                      currentUnit.id,
                                      currentUnit.modelCount - 1,
                                    );
                                ref.invalidate(selectedArmyProvider);
                                ref.invalidate(armiesListProvider);
                                ref.invalidate(armyByIdProvider(army.id));
                              },
                      ),
                      Text(
                        '${currentUnit.modelCount}',
                        style: AppTextStyles.title,
                      ),
                      IconButton(
                        tooltip: l10n.armyBuilderModelCountIncrease,
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        color: AppColors.textSecondary,
                        onPressed:
                            currentUnit.modelCount >= currentUnit.maximumModels
                            ? null
                            : () async {
                                await ref
                                    .read(armyRepositoryProvider)
                                    .updateModelCount(
                                      currentUnit.id,
                                      currentUnit.modelCount + 1,
                                    );
                                ref.invalidate(selectedArmyProvider);
                                ref.invalidate(armiesListProvider);
                                ref.invalidate(armyByIdProvider(army.id));
                              },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (army.detachmentId != null) ...[
                  Text(
                    l10n.armyBuilderEnhancementLabel,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _pickEnhancement(
                      context,
                      ref,
                      army.detachmentId!,
                      currentUnit,
                      army,
                    ),
                    child: Text(
                      currentUnit.enhancementName ??
                          l10n.armyBuilderChooseEnhancement,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final confirmed = await _confirmDelete(
                          context,
                          title: l10n.armyBuilderRemoveUnitConfirmTitle,
                          message: l10n.armyBuilderRemoveUnitConfirmMessage(
                            currentUnit.datasheetName,
                          ),
                          confirmLabel: l10n.armyBuilderRemoveUnit,
                        );
                        if (!confirmed || !context.mounted) return;
                        // Le SnackBar est affiché AVANT de fermer ce
                        // dialogue (pas après) : une fois fermé, ce
                        // `context` devient invalide et
                        // ScaffoldMessenger.of ne retrouverait plus rien à
                        // qui accrocher le message.
                        await _removeUnitWithUndo(
                          context,
                          ref,
                          army: army,
                          unit: currentUnit,
                        );
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: Text(l10n.armyBuilderRemoveUnit),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.armyBuilderCancel,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotesDialog extends ConsumerWidget {
  final String armyId;
  final String? initialNotes;

  const _NotesDialog({required this.armyId, required this.initialNotes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.armyBuilderNotesLabel, style: AppTextStyles.title),
                const SizedBox(height: 16),
                _ArmyNotesField(armyId: armyId, initialNotes: initialNotes),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.armyBuilderCancel,
                      style: AppTextStyles.body,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArmyNotesField extends ConsumerStatefulWidget {
  final String armyId;
  final String? initialNotes;

  const _ArmyNotesField({required this.armyId, required this.initialNotes});

  @override
  ConsumerState<_ArmyNotesField> createState() => _ArmyNotesFieldState();
}

class _ArmyNotesFieldState extends ConsumerState<_ArmyNotesField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNotes ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _save();
    });
  }

  @override
  void didUpdateWidget(covariant _ArmyNotesField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.armyId != widget.armyId) {
      _controller.text = widget.initialNotes ?? '';
    }
  }

  @override
  void dispose() {
    // Filet de rattrapage pour les fermetures qui ne font pas perdre le
    // focus au champ avant de démonter le widget (Échap → maybePop
    // direct, tap sur le voile derrière le dialogue) : sans ça, le texte
    // tapé disparaît silencieusement au lieu d'être sauvegardé comme
    // pour toute autre fermeture. Le container reste valide après la
    // destruction du widget (contrairement à `ref`), donc on le capture
    // ici pour que l'écriture puisse se terminer une fois le dialogue
    // déjà fermé.
    final text = _controller.text.trim();
    if (text != (widget.initialNotes ?? '')) {
      final container = ProviderScope.containerOf(context, listen: false);
      container
          .read(armyRepositoryProvider)
          .updateNotes(widget.armyId, text.isEmpty ? null : text)
          .then((_) {
            container.invalidate(selectedArmyProvider);
            container.invalidate(armiesListProvider);
            container.invalidate(armyByIdProvider(widget.armyId));
          });
    }
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text == (widget.initialNotes ?? '')) return;
    await ref
        .read(armyRepositoryProvider)
        .updateNotes(widget.armyId, text.isEmpty ? null : text);
    ref.invalidate(selectedArmyProvider);
    ref.invalidate(armiesListProvider);
    ref.invalidate(armyByIdProvider(widget.armyId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      maxLines: 3,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: l10n.armyBuilderNotesLabel,
        labelStyle: AppTextStyles.caption,
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
      onSubmitted: (_) => _save(),
    );
  }
}

class _DuplicateArmyDialog extends ConsumerStatefulWidget {
  final ArmyDetails army;

  const _DuplicateArmyDialog({required this.army});

  @override
  ConsumerState<_DuplicateArmyDialog> createState() =>
      _DuplicateArmyDialogState();
}

class _DuplicateArmyDialogState extends ConsumerState<_DuplicateArmyDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasUnsavedInput => _nameController.text.trim().isNotEmpty;

  Future<void> _duplicate() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim().isEmpty
        ? l10n.armyBuilderDuplicateSuffix(widget.army.name)
        : _nameController.text.trim();

    final newId = await ref
        .read(armyBuilderServiceProvider)
        .duplicateArmy(widget.army.id, name);

    ref.invalidate(armiesListProvider);
    if (newId != null) {
      ref.read(selectedArmyIdProvider.notifier).state = newId;
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppDialogShortcuts(
      onEnter: _duplicate,
      child: DiscardGuardScope(
        hasUnsavedInput: () => _hasUnsavedInput,
        child: Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 380,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.armyBuilderDuplicate, style: AppTextStyles.title),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: AppTextStyles.body,
                    onSubmitted: (_) => _duplicate(),
                    decoration: InputDecoration(
                      labelText: l10n.armyBuilderDuplicateNameLabel,
                      hintText: l10n.armyBuilderDuplicateSuffix(
                        widget.army.name,
                      ),
                      hintStyle: AppTextStyles.caption,
                      labelStyle: AppTextStyles.caption,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => DiscardGuard.popIfConfirmed(
                          context,
                          () => _hasUnsavedInput,
                        ),
                        child: Text(
                          l10n.armyBuilderCancel,
                          style: AppTextStyles.body,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: _duplicate,
                        child: Text(l10n.armyBuilderDuplicate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Certains détachements n'ont pas de vrai texte de règle en base (source
/// PDF indisponible) et gardent un tag brut du style "[2 PDD · PRENDRE ET
/// TENIR]" issu d'un import de points/catégorie de mission. On l'affiche
/// sous une forme lisible plutôt que tel quel.
final _detachmentTagPattern = RegExp(r'^\[(\d+)\s*PDD\s*·\s*(.+)\]$');

({int commandPoints, String category})? _parseDetachmentTag(
  String description,
) {
  final match = _detachmentTagPattern.firstMatch(description.trim());
  if (match == null) return null;
  return (commandPoints: int.parse(match.group(1)!), category: match.group(2)!);
}

class _StratagemsDialog extends ConsumerWidget {
  final String detachmentId;
  final String factionId;

  const _StratagemsDialog({
    required this.detachmentId,
    required this.factionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stratagemsAsync = ref.watch(
      stratagemsForDetachmentProvider(detachmentId),
    );
    final detachmentsAsync = ref.watch(
      detachmentsForFactionProvider(factionId),
    );
    final detachment = detachmentsAsync.value?.firstWhereOrNull(
      (d) => d.id == detachmentId,
    );

    return AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 460,
          height: 520,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detachment?.name ?? l10n.armyBuilderStratagems,
                  style: AppTextStyles.title,
                ),
                if (detachment?.description != null) ...[
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final tag = _parseDetachmentTag(detachment!.description!);
                      if (tag == null) {
                        return Text(
                          detachment.description!,
                          style: AppTextStyles.caption,
                        );
                      }
                      return Text(
                        '${l10n.armyBuilderStratagemCp(tag.commandPoints)} · ${tag.category}',
                        style: AppTextStyles.caption.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Text(l10n.armyBuilderStratagems, style: AppTextStyles.eyebrow),
                const SizedBox(height: 8),
                Expanded(
                  child: stratagemsAsync.when(
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Text('$error', style: AppTextStyles.caption),
                    ),
                    data: (stratagems) {
                      if (stratagems.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.armyBuilderNoStratagems,
                            style: AppTextStyles.caption,
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: stratagems.length,
                        itemBuilder: (context, index) {
                          final stratagem = stratagems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        stratagem.name,
                                        style: AppTextStyles.body,
                                      ),
                                    ),
                                    Text(
                                      l10n.armyBuilderStratagemCp(
                                        stratagem.commandPoints,
                                      ),
                                      style: AppTextStyles.body.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (stratagem.phase != null) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: .14,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      stratagem.phase!,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                if (stratagem.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    stratagem.description!,
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
