import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/army_list_formatter.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/faction_badge_icon.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../database/models/equipment_details.dart';
import '../../../database/models/model_details.dart';
import '../../../database/models/weapon_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
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
    case ArmyValidationIssue.noWarlordSelected:
      return l10n.armyValidationNoWarlord;
  }
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
      backgroundColor: AppColors.background,
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
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
      backgroundColor: AppColors.background,
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
                    loading: () => const Center(
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
                                    Text(
                                      army.pointsLimit != null
                                          ? l10n.armyBuilderPointsWithLimit(
                                              army.totalPoints,
                                              army.pointsLimit!,
                                            )
                                          : l10n.pointsSuffix(army.totalPoints),
                                      style: AppTextStyles.body.copyWith(
                                        color: army.isOverLimit
                                            ? AppColors.error
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
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
) async {
  final l10n = AppLocalizations.of(context)!;
  final options = await ref
      .read(armyRepositoryProvider)
      .getEnhancementsForDetachment(detachmentId);

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
                    l10n.armyBuilderEnhancementNone,
                    style: AppTextStyles.body,
                  ),
                  onTap: () => Navigator.of(context).pop(''),
                ),
                ...options.map(
                  (option) => ListTile(
                    title: Text(option.name, style: AppTextStyles.body),
                    subtitle: Text(
                      l10n.pointsSuffix(option.points),
                      style: AppTextStyles.caption,
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
    final selected = selections[group.id];
    final chosenOptionIds = (selected != null && selected.isNotEmpty)
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 300, child: _BuilderSidebar(army: army)),
              Container(width: 1, color: AppColors.border),
              Expanded(
                flex: 2,
                child: army.units.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.armyBuilderEmptyUnits,
                          style: AppTextStyles.caption,
                        ),
                      )
                    : _GroupedUnitGrid(army: army, selectedUnit: selectedUnit),
              ),
              Container(width: 1, color: AppColors.border),
              SizedBox(
                width: 340,
                child: _UnitDetailsPanel(army: army, unit: selectedUnit),
              ),
            ],
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

    return Row(
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
        const SizedBox(width: 16),
        Flexible(
          child: Wrap(
            alignment: WrapAlignment.end,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isValid ? AppColors.success : AppColors.error)
                      .withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isValid
                          ? Icons.check_circle_rounded
                          : Icons.error_rounded,
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
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
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
                  builder: (_) =>
                      _NotesDialog(armyId: army.id, initialNotes: army.notes),
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
                  message: l10n.armyBuilderDeleteArmyConfirmMessage(army.name),
                  confirmLabel: l10n.armyBuilderDeleteArmy,
                );
                if (!confirmed) break;
                await ref.read(armyRepositoryProvider).deleteArmy(army.id);
                ref.read(selectedArmyIdProvider.notifier).state = null;
                ref.invalidate(armiesListProvider);
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'copy',
              child: Text(l10n.armyBuilderCopyList, style: AppTextStyles.body),
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
              child: Text(l10n.armyBuilderDuplicate, style: AppTextStyles.body),
            ),
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
    final filteredUnits = _rosterFilter.isEmpty
        ? army.units
        : army.units
              .where(
                (unit) => unit.datasheetName.toLowerCase().contains(
                  _rosterFilter.toLowerCase(),
                ),
              )
              .toList();

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
                      child: const Icon(
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
                      return _UnitRosterRow(
                        unit: unit,
                        selected: unit.id == selectedUnitId,
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
                          if (!confirmed) return;
                          await ref
                              .read(armyRepositoryProvider)
                              .removeUnit(unit.id);
                          if (ref.read(selectedUnitIdProvider) == unit.id) {
                            ref.read(selectedUnitIdProvider.notifier).state =
                                null;
                          }
                          ref.invalidate(selectedArmyProvider);
                          ref.invalidate(armiesListProvider);
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

class _UnitRosterRow extends StatelessWidget {
  final ArmyUnitDetails unit;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _UnitRosterRow({
    required this.unit,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageFile = LocalCatalogImages.unitPhoto(unit.datasheetId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: .12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: imageFile != null
                        ? Image.file(imageFile, fit: BoxFit.cover)
                        : Container(
                            color: AppColors.surfaceElevated,
                            child: const Icon(
                              Icons.shield_rounded,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
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
                    ],
                  ),
                ),
                Text(
                  l10n.pointsSuffix(unit.points),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  tooltip: l10n.armyBuilderRemoveUnit,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                  icon: const Icon(Icons.close_rounded, size: 16),
                  color: AppColors.textSecondary,
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GroupedUnitGrid extends StatelessWidget {
  final ArmyDetails army;
  final ArmyUnitDetails? selectedUnit;

  const _GroupedUnitGrid({required this.army, required this.selectedUnit});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groups = <String, List<ArmyUnitDetails>>{};
    for (final unit in army.units) {
      final role = unit.battlefieldRole.isEmpty
          ? l10n.armyBuilderRoleOther
          : unit.battlefieldRole;
      groups.putIfAbsent(role, () => []).add(unit);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in groups.entries) ...[
            Text(
              entry.key.toUpperCase(),
              style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = (constraints.maxWidth / 220).floor().clamp(
                  1,
                  4,
                );
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    return _UnitCard(unit: entry.value[index]);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }
}

class _UnitCard extends ConsumerWidget {
  final ArmyUnitDetails unit;

  const _UnitCard({required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);
    final selected = unit.id == selectedUnitId;
    final imageFile = LocalCatalogImages.unitPhoto(unit.datasheetId);

    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ref.read(selectedUnitIdProvider.notifier).state = unit.id,
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
              else
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.surface, AppColors.surfaceElevated],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield_moon_rounded,
                      size: 36,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    l10n.pointsSuffix(unit.points),
                    style: AppTextStyles.eyebrow.copyWith(color: Colors.white),
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
                    unit.modelCount > 1
                        ? '${unit.datasheetName} x${unit.modelCount}'
                        : unit.datasheetName,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

class _UnitDetailsPanel extends ConsumerWidget {
  final ArmyDetails army;
  final ArmyUnitDetails? unit;

  const _UnitDetailsPanel({required this.army, required this.unit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUnit = unit;

    if (currentUnit == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.armyBuilderSelectUnitPrompt,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final datasheetAsync = ref.watch(
      datasheetByIdProvider(currentUnit.datasheetId),
    );
    final selectionsAsync = ref.watch(
      unitEquipmentSelectionsProvider(currentUnit.id),
    );

    if (datasheetAsync.isLoading || selectionsAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
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
    final imageFile = LocalCatalogImages.unitPhoto(sheet.id);
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
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imageFile != null
                ? Image.file(
                    imageFile,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    color: AppColors.surfaceElevated,
                    child: const Icon(
                      Icons.shield_moon_rounded,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
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
                    .then((_) => ref.invalidate(selectedArmyProvider)),
              ),
              Text(
                l10n.pointsSuffix(currentUnit.points),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
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
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
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
          if (army.detachmentId != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _pickEnhancement(
                context,
                ref,
                army.detachmentId!,
                currentUnit,
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: stats.entries
            .map(
              (entry) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        entry.key,
                        style: AppTextStyles.eyebrow,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EquipmentGroupDialog extends ConsumerStatefulWidget {
  final String armyUnitId;
  final EquipmentGroupDetails group;
  final List<String> initialSelection;

  const _EquipmentGroupDialog({
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
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.group.options.map((option) {
                      return _isSingleChoice
                          ? RadioListTile<String>(
                              value: option.id,
                              groupValue: _selected.isEmpty
                                  ? null
                                  : _selected.first,
                              onChanged: (_) => _toggle(option.id, true),
                              title: Text(
                                option.name,
                                style: AppTextStyles.body,
                              ),
                              activeColor: AppColors.primary,
                              contentPadding: EdgeInsets.zero,
                            )
                          : CheckboxListTile(
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
                              },
                      ),
                      Text(
                        '${currentUnit.modelCount}',
                        style: AppTextStyles.title,
                      ),
                      IconButton(
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
                        await ref
                            .read(armyRepositoryProvider)
                            .removeUnit(currentUnit.id);
                        ref.invalidate(selectedArmyProvider);
                        ref.invalidate(armiesListProvider);
                        ref.read(selectedUnitIdProvider.notifier).state = null;
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
                Text(l10n.armyBuilderDuplicate, style: AppTextStyles.title),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  autofocus: true,
                  style: AppTextStyles.body,
                  onSubmitted: (_) => _duplicate(),
                  decoration: InputDecoration(
                    labelText: l10n.armyBuilderDuplicateNameLabel,
                    hintText: l10n.armyBuilderDuplicateSuffix(widget.army.name),
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
    );
  }
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
                  Text(
                    detachment!.description!,
                    style: AppTextStyles.caption,
                  ),
                ],
                const SizedBox(height: 16),
                Text(l10n.armyBuilderStratagems, style: AppTextStyles.eyebrow),
                const SizedBox(height: 8),
                Expanded(
                  child: stratagemsAsync.when(
                    loading: () => const Center(
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
