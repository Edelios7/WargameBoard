import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/donut_chart.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../shell/navigation.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final entriesAsync = ref.watch(collectionEntriesProvider);
    final battleStatsAsync = ref.watch(battleStatsProvider);

    void goTo(AppTab tab) =>
        ref.read(selectedTabProvider.notifier).state = tab;

    final armies = armiesAsync.value ?? const <ArmyListItem>[];
    final totalArmyPoints =
        armies.fold<int>(0, (sum, a) => sum + a.totalPoints);
    final summary = summaryAsync.value;
    final entries = entriesAsync.value ?? const <CollectionItemDetails>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navDashboard, style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(l10n.dashboardWelcome, style: AppTextStyles.caption),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 900 ? 4 : 2;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.0,
                  children: [
                    _StatTile(
                      icon: Icons.groups_rounded,
                      label: l10n.dashboardStatArmies,
                      value: armies.length.toString(),
                      sublabel: l10n.dashboardStatArmiesSub,
                      onTap: () => goTo(AppTab.armies),
                    ),
                    _StatTile(
                      icon: Icons.inventory_2_rounded,
                      label: l10n.dashboardStatCollection,
                      value: (summary?.totalModels ?? 0).toString(),
                      sublabel: l10n.dashboardStatCollectionSub,
                      onTap: () => goTo(AppTab.collection),
                    ),
                    _StatTile(
                      icon: Icons.military_tech_rounded,
                      label: l10n.dashboardStatPoints,
                      value: totalArmyPoints.toString(),
                      sublabel: l10n.dashboardStatPointsSub,
                      onTap: () => goTo(AppTab.armies),
                    ),
                    _StatTile(
                      icon: Icons.brush_rounded,
                      label: l10n.dashboardStatPainting,
                      value: summary == null
                          ? '—'
                          : '${(summary.paintedRatio * 100).round()}%',
                      sublabel: l10n.dashboardStatPaintingSub,
                      onTap: () => goTo(AppTab.statistics),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 900;
                final armiesCard = _RecentArmiesCard(
                  armies: armies,
                  onSeeAll: () => goTo(AppTab.armies),
                );
                final chartsCard = _ChartsCard(
                  entries: entries,
                  battleStatsAsync: battleStatsAsync,
                );

                if (!wide) {
                  return Column(
                    children: [
                      armiesCard,
                      const SizedBox(height: 16),
                      chartsCard,
                    ],
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 3, child: armiesCard),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: chartsCard),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sublabel;
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _RecentArmiesCard extends StatelessWidget {
  final List<ArmyListItem> armies;
  final VoidCallback onSeeAll;

  const _RecentArmiesCard({required this.armies, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shown = armies.take(6).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.dashboardYourArmies, style: AppTextStyles.title),
              if (armies.isNotEmpty)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    l10n.dashboardSeeAll,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardNoArmiesYet,
                style: AppTextStyles.caption,
              ),
            )
          else
            ...shown.map(
              (army) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              army.name,
                              style: AppTextStyles.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              army.factionName,
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${army.totalPoints} pts',
                        style: AppTextStyles.body.copyWith(
                          color: army.isOverLimit
                              ? AppColors.error
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartsCard extends StatelessWidget {
  final List<CollectionItemDetails> entries;
  final AsyncValue battleStatsAsync;

  const _ChartsCard({required this.entries, required this.battleStatsAsync});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    var painted = 0;
    var assembledOnly = 0;
    var unbuilt = 0;
    for (final entry in entries) {
      painted += entry.painted;
      assembledOnly += (entry.assembled - entry.painted).clamp(0, entry.quantity);
      unbuilt += (entry.quantity - entry.assembled).clamp(0, entry.quantity);
    }

    final factionTotals = <String, int>{};
    for (final entry in entries) {
      factionTotals[entry.factionName] =
          (factionTotals[entry.factionName] ?? 0) + entry.quantity;
    }
    final factionColors = [
      AppColors.primary,
      AppColors.primaryLight,
      AppColors.warning,
      AppColors.success,
      AppColors.textSecondary,
    ];
    final factionSegments = <DonutSegment>[];
    var colorIndex = 0;
    for (final e in factionTotals.entries) {
      factionSegments.add(DonutSegment(
        label: e.key,
        value: e.value,
        color: factionColors[colorIndex % factionColors.length],
      ));
      colorIndex++;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardPaintingBreakdown, style: AppTextStyles.title),
          const SizedBox(height: 16),
          DonutChart(
            segments: [
              DonutSegment(
                label: l10n.dashboardStatusPainted,
                value: painted,
                color: AppColors.success,
              ),
              DonutSegment(
                label: l10n.dashboardStatusAssembled,
                value: assembledOnly,
                color: AppColors.primary,
              ),
              DonutSegment(
                label: l10n.dashboardStatusUnbuilt,
                value: unbuilt,
                color: AppColors.border,
              ),
            ],
          ),
          if (factionSegments.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(l10n.dashboardFactionBreakdown, style: AppTextStyles.title),
            const SizedBox(height: 16),
            DonutChart(segments: factionSegments),
          ],
        ],
      ),
    );
  }
}
