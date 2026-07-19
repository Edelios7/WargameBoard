import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/army_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/collection_provider.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navStatistics, style: AppTextStyles.heading),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _StatTile(
                  label: l10n.statsArmiesCount,
                  value: armiesAsync.value?.length.toString() ?? '—',
                ),
                _StatTile(
                  label: l10n.statsCollectionEntries,
                  value: summaryAsync.value?.totalEntries.toString() ?? '—',
                ),
                _StatTile(
                  label: l10n.statsCollectionModels,
                  value: summaryAsync.value?.totalModels.toString() ?? '—',
                ),
                _StatTile(
                  label: l10n.statsCollectionPainted,
                  value: summaryAsync.value?.totalPainted.toString() ?? '—',
                ),
              ],
            ),
            const SizedBox(height: 28),
            summaryAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.statsPaintingProgress,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: summary.paintedRatio,
                      minHeight: 10,
                      backgroundColor: AppColors.surface,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(l10n.statsPointsByArmy, style: AppTextStyles.title),
            const SizedBox(height: 16),
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
                        l10n.statsNoArmies,
                        style: AppTextStyles.caption,
                      ),
                    );
                  }
                  final maxPoints = armies
                      .map((a) => a.totalPoints)
                      .fold<int>(1, (max, p) => p > max ? p : max);

                  return ListView.builder(
                    itemCount: armies.length,
                    itemBuilder: (context, index) {
                      final army = armies[index];
                      return _ArmyPointsBar(army: army, maxPoints: maxPoints);
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

class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTextStyles.heading.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _ArmyPointsBar extends StatelessWidget {
  final ArmyListItem army;
  final int maxPoints;

  const _ArmyPointsBar({required this.army, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    final ratio = army.totalPoints / maxPoints;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(army.name, style: AppTextStyles.body),
              Text('${army.totalPoints} pts', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio.clamp(0, 1),
              minHeight: 8,
              backgroundColor: AppColors.surface,
              color: army.isOverLimit ? AppColors.error : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
