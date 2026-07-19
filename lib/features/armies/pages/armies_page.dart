import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/army_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../widgets/add_unit_dialog.dart';
import '../widgets/create_army_dialog.dart';

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
        color: selected ? AppColors.primary.withOpacity(.16) : AppColors.surface,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(army.name, style: AppTextStyles.heading),
                  const SizedBox(height: 6),
                  Text(army.factionName, style: AppTextStyles.caption),
                ],
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
                      .withOpacity(.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (army.isOverLimit
                            ? AppColors.error
                            : AppColors.primary)
                        .withOpacity(.4),
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
