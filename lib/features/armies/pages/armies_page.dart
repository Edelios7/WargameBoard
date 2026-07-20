import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/army_list_formatter.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/model_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/catalog_provider.dart';
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
  }
}

bool _isBattleline(String role) {
  final normalized = role.toLowerCase();
  return normalized.contains('battleline') || normalized.contains('troops') ||
      normalized.contains('troupes');
}

const _maxEnhancements = 3;

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
        error: (error, _) => Center(
          child: Text('$error', style: AppTextStyles.caption),
        ),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
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
                  child: CircularProgressIndicator(color: AppColors.primary),
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
                            onTap: () => ref
                                .read(selectedArmyIdProvider.notifier)
                                .state = army.id,
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
                                Text(
                                  army.factionName,
                                  style: AppTextStyles.caption,
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
  final options =
      await ref.read(armyRepositoryProvider).getEnhancementsForDetachment(
            detachmentId,
          );

  if (!context.mounted) return;

  final selected = await showDialog<String?>(
    context: context,
    builder: (context) => Dialog(
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
  );

  if (selected == null) return; // dialog dismissed, no change

  await ref.read(armyRepositoryProvider).setUnitEnhancement(
        unit.id,
        selected.isEmpty ? null : selected,
      );
  ref.invalidate(selectedArmyProvider);
  ref.invalidate(armiesListProvider);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: _BuilderTopBar(army: army),
        ),
        Consumer(
          builder: (context, ref, _) {
            final l10n = AppLocalizations.of(context)!;
            final validation = ref.watch(armyValidationProvider(army));
            if (validation == null || validation.warnings.isEmpty) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Wrap(
                spacing: 12,
                runSpacing: 4,
                children: validation.warnings
                    .map(
                      (issue) => Text(
                        _warningLabel(l10n, issue),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.warning),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
        Container(height: 1, color: AppColors.border),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 300,
                child: _BuilderSidebar(army: army),
              ),
              Container(width: 1, color: AppColors.border),
              Expanded(
                flex: 2,
                child: army.units.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.armyBuilderNoUnitsYet,
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

class _BuilderTopBar extends ConsumerWidget {
  final ArmyDetails army;

  const _BuilderTopBar({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final validation = ref.watch(armyValidationProvider(army));
    final isValid = validation?.isValid ?? true;
    final battlelineCount =
        army.units.where((u) => _isBattleline(u.battlefieldRole)).length;
    final enhancementsCount =
        army.units.where((u) => u.enhancementId != null).length;

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
                        army.totalPoints, army.pointsLimit!)
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
          icon: const Icon(Icons.more_vert_rounded,
              color: AppColors.textSecondary),
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
              child: Text(l10n.armyBuilderNotesLabel, style: AppTextStyles.body),
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

class _BuilderSidebar extends ConsumerWidget {
  final ArmyDetails army;

  const _BuilderSidebar({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedUnitId = ref.watch(selectedUnitIdProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BuilderSidebarContent(army: army, l10n: l10n),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AddUnitDialog(armyId: army.id),
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.armyBuilderAddUnit),
          ),
        ],
      ),
    );
  }
}

class _BuilderSidebarContent extends StatelessWidget {
  final ArmyDetails army;
  final AppLocalizations l10n;

  const _BuilderSidebarContent({required this.army, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final selectedUnitId = ref.watch(selectedUnitIdProvider);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            l10n.armyBuilderDetachmentSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
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
                  child: const Icon(Icons.shield_rounded,
                      size: 18, color: AppColors.primary),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.armyBuilderRulesSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: army.detachmentId == null
                ? null
                : () => showDialog(
                      context: context,
                      builder: (_) =>
                          _StratagemsDialog(detachmentId: army.detachmentId!),
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
          const SizedBox(height: 20),
          Text(
            l10n.armyBuilderUnitsSection.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          army.units.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.armyBuilderEmptyUnits,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: army.units.length,
                    itemBuilder: (context, index) {
                      final unit = army.units[index];
                      return _UnitRosterRow(
                        unit: unit,
                        selected: unit.id == selectedUnitId,
                        onTap: () => ref
                            .read(selectedUnitIdProvider.notifier)
                            .state = unit.id,
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}

class _UnitRosterRow extends StatelessWidget {
  final ArmyUnitDetails unit;
  final bool selected;
  final VoidCallback onTap;

  const _UnitRosterRow({
    required this.unit,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageFile = LocalCatalogImages.datasheet(unit.datasheetId);

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
                      Text(
                        unit.datasheetName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (unit.modelCount > 1)
                        Text(
                          'x${unit.modelCount}',
                          style: AppTextStyles.caption,
                        ),
                    ],
                  ),
                ),
                Text(l10n.pointsSuffix(unit.points), style: AppTextStyles.caption),
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
                final columns =
                    (constraints.maxWidth / 220).floor().clamp(1, 4);
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
    final imageFile = LocalCatalogImages.datasheet(unit.datasheetId);

    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            ref.read(selectedUnitIdProvider.notifier).state = unit.id,
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
                      colors: [
                        AppColors.surface,
                        AppColors.surfaceElevated,
                      ],
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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

    final datasheetAsync =
        ref.watch(datasheetByIdProvider(currentUnit.datasheetId));

    return datasheetAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      error: (error, _) => Center(
        child: Text('$error', style: AppTextStyles.caption),
      ),
      data: (sheet) {
        if (sheet == null) return const SizedBox.shrink();
        final imageFile = LocalCatalogImages.datasheet(sheet.id);

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
                  Expanded(
                    child: Text(sheet.name, style: AppTextStyles.title),
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
              const SizedBox(height: 18),
              if (sheet.models.isNotEmpty) _StatBlock(model: sheet.models.first),
              if (sheet.equipment.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(l10n.sectionEquipment.toUpperCase(),
                    style: AppTextStyles.eyebrow),
                const SizedBox(height: 10),
                ...sheet.equipment.expand((group) => group.options).map(
                      (option) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 6, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(option, style: AppTextStyles.body),
                            ),
                            const Icon(Icons.chevron_right_rounded,
                                size: 18, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                    ),
              ],
              if (sheet.abilities.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(l10n.sectionAbilities.toUpperCase(),
                    style: AppTextStyles.eyebrow),
                const SizedBox(height: 10),
                ...sheet.abilities.map(
                  (ability) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.auto_awesome_rounded,
                              size: 15, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(ability, style: AppTextStyles.body),
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
                    style:
                        AppTextStyles.body.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton.icon(
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
            ],
          ),
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
    final stats = <String, String>{
      'M': '${model.movement}"',
      'T': '${model.toughness}',
      'SV': '${model.save}+',
      'W': '${model.wounds}',
      'LD': '${model.leadership}+',
      'OC': '${model.objectiveControl}',
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
                child: Column(
                  children: [
                    Text(entry.key, style: AppTextStyles.eyebrow),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
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

    return Dialog(
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
              Text(unit.datasheetName, style: AppTextStyles.title),
              const SizedBox(height: 20),
              if (unit.maximumModels > unit.minimumModels) ...[
                Text(l10n.armyBuilderModelCountLabel, style: AppTextStyles.caption),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      color: AppColors.textSecondary,
                      onPressed: unit.modelCount <= unit.minimumModels
                          ? null
                          : () async {
                              await ref
                                  .read(armyRepositoryProvider)
                                  .updateModelCount(
                                      unit.id, unit.modelCount - 1);
                              ref.invalidate(selectedArmyProvider);
                              ref.invalidate(armiesListProvider);
                            },
                    ),
                    Text('${unit.modelCount}', style: AppTextStyles.title),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      color: AppColors.textSecondary,
                      onPressed: unit.modelCount >= unit.maximumModels
                          ? null
                          : () async {
                              await ref
                                  .read(armyRepositoryProvider)
                                  .updateModelCount(
                                      unit.id, unit.modelCount + 1);
                              ref.invalidate(selectedArmyProvider);
                              ref.invalidate(armiesListProvider);
                            },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              if (army.detachmentId != null) ...[
                Text(l10n.armyBuilderEnhancementLabel,
                    style: AppTextStyles.caption),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _pickEnhancement(
                    context,
                    ref,
                    army.detachmentId!,
                    unit,
                  ),
                  child: Text(
                    unit.enhancementName ?? l10n.armyBuilderChooseEnhancement,
                    style:
                        AppTextStyles.body.copyWith(color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await ref
                          .read(armyRepositoryProvider)
                          .removeUnit(unit.id);
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

    return Dialog(
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
                  child: Text(l10n.armyBuilderCancel, style: AppTextStyles.body),
                ),
              ),
            ],
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

    return Dialog(
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
    );
  }
}

class _StratagemsDialog extends ConsumerWidget {
  final String detachmentId;

  const _StratagemsDialog({required this.detachmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stratagemsAsync =
        ref.watch(stratagemsForDetachmentProvider(detachmentId));

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 460,
        height: 480,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.armyBuilderStratagems, style: AppTextStyles.title),
              const SizedBox(height: 16),
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
                              if (stratagem.phase != null)
                                Text(
                                  stratagem.phase!,
                                  style: AppTextStyles.caption,
                                ),
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
    );
  }
}
