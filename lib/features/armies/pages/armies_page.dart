import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/army_list_formatter.dart';
import '../../../database/models/army_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
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

class ArmiesPage extends ConsumerWidget {
  const ArmiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);
    final selectedId = ref.watch(selectedArmyIdProvider);
    final detailAsync = ref.watch(selectedArmyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: Row(
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
                ),
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
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: armies.length,
                        itemBuilder: (context, index) {
                          final army = armies[index];
                          return _ArmyListItem(
                            army: army,
                            selected: army.id == selectedId,
                            onTap: () => ref
                                .read(selectedArmyIdProvider.notifier)
                                .state = army.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          Expanded(
            child: detailAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, _) => Center(
                child: Text('$error', style: AppTextStyles.caption),
              ),
              data: (army) {
                if (army == null) {
                  return Center(
                    child: Text(
                      l10n.armyBuilderSelectPrompt,
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return _ArmyDetail(army: army);
              },
            ),
          ),
        ],
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

class _ArmyListItem extends StatelessWidget {
  final ArmyListItem army;
  final bool selected;
  final VoidCallback onTap;

  const _ArmyListItem({
    required this.army,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? AppColors.primary.withValues(alpha: .16) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(army.name, style: AppTextStyles.body),
                const SizedBox(height: 4),
                Text(
                  '${army.factionName} · ${army.totalPoints} pts',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArmyDetail extends ConsumerWidget {
  final ArmyDetails army;

  const _ArmyDetail({required this.army});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      army.name,
                      style: AppTextStyles.heading,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      army.detachmentName != null
                          ? '${army.factionName} · ${army.detachmentName}'
                          : army.factionName,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.armyBuilderCopyList,
                icon: const Icon(Icons.copy_rounded),
                color: AppColors.textSecondary,
                onPressed: () async {
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
                },
              ),
              if (army.detachmentId != null)
                IconButton(
                  tooltip: l10n.armyBuilderStratagems,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  color: AppColors.primary,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) =>
                        _StratagemsDialog(detachmentId: army.detachmentId!),
                  ),
                ),
              IconButton(
                tooltip: l10n.armyBuilderDuplicate,
                icon: const Icon(Icons.content_copy_rounded),
                color: AppColors.textSecondary,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => _DuplicateArmyDialog(army: army),
                ),
              ),
              IconButton(
                tooltip: l10n.armyBuilderDeleteArmy,
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.textSecondary,
                onPressed: () async {
                  await ref.read(armyRepositoryProvider).deleteArmy(army.id);
                  ref.read(selectedArmyIdProvider.notifier).state = null;
                  ref.invalidate(armiesListProvider);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: (army.isOverLimit ? AppColors.error : AppColors.primary)
                      .withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (army.isOverLimit
                            ? AppColors.error
                            : AppColors.primary)
                        .withValues(alpha: .4),
                  ),
                ),
                child: Text(
                  army.pointsLimit != null
                      ? l10n.armyBuilderPointsWithLimit(
                          army.totalPoints, army.pointsLimit!)
                      : l10n.pointsSuffix(army.totalPoints),
                  style: AppTextStyles.body.copyWith(
                    color:
                        army.isOverLimit ? AppColors.error : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (army.isOverLimit) ...[
                const SizedBox(width: 10),
                Text(
                  l10n.armyBuilderOverLimit,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
            ],
          ),
          Builder(
            builder: (context) {
              final validation = ref.watch(armyValidationProvider(army));
              if (validation == null || validation.warnings.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: validation.warnings
                      .map((issue) => Text(
                            _warningLabel(l10n, issue),
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textSecondary),
                          ))
                      .toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AddUnitDialog(armyId: army.id),
            ),
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.armyBuilderAddUnit),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: army.units.isEmpty
                ? Center(
                    child: Text(
                      l10n.armyBuilderEmptyUnits,
                      style: AppTextStyles.caption,
                    ),
                  )
                : ListView.builder(
                    itemCount: army.units.length,
                    itemBuilder: (context, index) {
                      final unit = army.units[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      unit.datasheetName,
                                      style: AppTextStyles.body,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.armyBuilderModelCount(
                                        unit.modelCount,
                                      ),
                                      style: AppTextStyles.caption,
                                    ),
                                    if (army.detachmentId != null) ...[
                                      const SizedBox(height: 4),
                                      InkWell(
                                        onTap: () => _pickEnhancement(
                                          context,
                                          ref,
                                          army.detachmentId!,
                                          unit,
                                        ),
                                        child: Text(
                                          unit.enhancementName ??
                                              l10n.armyBuilderChooseEnhancement,
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              if (unit.maximumModels > unit.minimumModels) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline_rounded,
                                    size: 20,
                                  ),
                                  color: AppColors.textSecondary,
                                  onPressed: unit.modelCount <=
                                          unit.minimumModels
                                      ? null
                                      : () async {
                                          await ref
                                              .read(armyRepositoryProvider)
                                              .updateModelCount(
                                                unit.id,
                                                unit.modelCount - 1,
                                              );
                                          ref.invalidate(selectedArmyProvider);
                                          ref.invalidate(armiesListProvider);
                                        },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 20,
                                  ),
                                  color: AppColors.textSecondary,
                                  onPressed: unit.modelCount >=
                                          unit.maximumModels
                                      ? null
                                      : () async {
                                          await ref
                                              .read(armyRepositoryProvider)
                                              .updateModelCount(
                                                unit.id,
                                                unit.modelCount + 1,
                                              );
                                          ref.invalidate(selectedArmyProvider);
                                          ref.invalidate(armiesListProvider);
                                        },
                                ),
                              ],
                              Text(
                                l10n.pointsSuffix(unit.points),
                                style: AppTextStyles.body,
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded),
                                color: AppColors.textSecondary,
                                onPressed: () async {
                                  await ref
                                      .read(armyRepositoryProvider)
                                      .removeUnit(unit.id);
                                  ref.invalidate(selectedArmyProvider);
                                  ref.invalidate(armiesListProvider);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
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
