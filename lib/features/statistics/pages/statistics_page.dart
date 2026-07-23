import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/donut_chart.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/xp_summary.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../providers/xp_provider.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final battleStatsAsync = ref.watch(battleStatsProvider);
    final battlesAsync = ref.watch(battlesListProvider);
    final xpAsync = ref.watch(xpSummaryProvider);
    final battleStats = battleStatsAsync.value;
    final battles = battlesAsync.value ?? const <BattleDetails>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.navStatistics, style: AppTextStyles.heading),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                          value:
                              summaryAsync.value?.totalEntries.toString() ??
                              '—',
                        ),
                        _StatTile(
                          label: l10n.statsCollectionModels,
                          value:
                              summaryAsync.value?.totalModels.toString() ??
                              '—',
                        ),
                        _StatTile(
                          label: l10n.statsCollectionPainted,
                          value:
                              summaryAsync.value?.totalPainted.toString() ??
                              '—',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.4,
                      children: [
                        _StatTile(
                          label: l10n.statsGamesPlayed,
                          value: battleStats?.totalGames.toString() ?? '—',
                        ),
                        _StatTile(
                          label: l10n.statsVictories,
                          value: battleStats?.victories.toString() ?? '—',
                        ),
                        _StatTile(
                          label: l10n.statsDefeats,
                          value: battleStats?.defeats.toString() ?? '—',
                        ),
                        _StatTile(
                          label: l10n.statsWinRate,
                          value: battleStats == null
                              ? '—'
                              : '${(battleStats.winRate * 100).round()} %',
                        ),
                      ],
                    ),
                    if (battleStats != null && battleStats.totalGames > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.statsBattleRecord(
                          battleStats.victories,
                          battleStats.defeats,
                          battleStats.draws,
                        ),
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    summaryAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (summary) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.statsPaintingProgress.toUpperCase(),
                                style: AppTextStyles.eyebrow,
                              ),
                              Text(
                                '${(summary.paintedRatio * 100).round()}%',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
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
                    const DecorSeparator(
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    Text(l10n.statsProgressionTitle, style: AppTextStyles.title),
                    const SizedBox(height: 16),
                    xpAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (xp) => _ProgressionSection(l10n: l10n, xp: xp),
                    ),
                    const DecorSeparator(
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    Text(
                      l10n.statsRecentFormTitle,
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: 16),
                    battles.isEmpty
                        ? Text(l10n.battleEmptyList, style: AppTextStyles.caption)
                        : _RecentFormRow(l10n: l10n, battles: battles),
                    const DecorSeparator(
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final outcomes = _BattleOutcomesCard(
                          l10n: l10n,
                          battles: battles,
                        );
                        final byFaction = _BattlesByFactionCard(
                          l10n: l10n,
                          battles: battles,
                        );
                        if (constraints.maxWidth < 720) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              outcomes,
                              const SizedBox(height: 16),
                              byFaction,
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: outcomes),
                            const SizedBox(width: 16),
                            Expanded(child: byFaction),
                          ],
                        );
                      },
                    ),
                    const DecorSeparator(
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    Text(l10n.statsPointsByArmy, style: AppTextStyles.title),
                    const SizedBox(height: 16),
                    armiesAsync.when(
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
                          return Text(
                            l10n.statsNoArmies,
                            style: AppTextStyles.caption,
                          );
                        }
                        final maxPoints = armies
                            .map((a) => a.totalPoints)
                            .fold<int>(1, (max, p) => p > max ? p : max);

                        return Column(
                          children: [
                            for (final army in armies)
                              _ArmyPointsBar(army: army, maxPoints: maxPoints),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTextStyles.heading.copyWith(color: AppColors.primary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
              Expanded(
                child: Text(
                  army.name,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${army.totalPoints} pts',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: army.isOverLimit
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
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

/// Niveau Commandant + les factions ayant le plus d'XP — reprend les
/// mêmes clés l10n que la page Profil pour rester cohérent.
class _ProgressionSection extends StatelessWidget {
  final AppLocalizations l10n;
  final XpSummary xp;

  const _ProgressionSection({required this.l10n, required this.xp});

  @override
  Widget build(BuildContext context) {
    final level = xp.commandantLevel;
    final topFactions = [...xp.factions]
      ..sort((a, b) => b.xp.compareTo(a.xp));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.profileCommandant, style: AppTextStyles.body),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.profileLevelShort(level.level),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                l10n.profileXpProgress(level.xpIntoLevel, level.xpForNextLevel),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: level.progress,
              minHeight: 8,
              backgroundColor: AppColors.background,
              color: AppColors.primary,
            ),
          ),
          if (topFactions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(l10n.profileFactionsTitle, style: AppTextStyles.eyebrow),
            const SizedBox(height: 8),
            for (final faction in topFactions.take(3))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        faction.factionName,
                        style: AppTextStyles.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      l10n.profileLevelShort(faction.level.level),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

String _resultLabel(AppLocalizations l10n, BattleResult? result) {
  switch (result) {
    case BattleResult.victory:
      return l10n.battleResultVictory;
    case BattleResult.defeat:
      return l10n.battleResultDefeat;
    case BattleResult.draw:
    case null:
      return l10n.battleResultDraw;
  }
}

Color _resultColor(BattleResult? result) {
  switch (result) {
    case BattleResult.victory:
      return AppColors.success;
    case BattleResult.defeat:
      return AppColors.error;
    case BattleResult.draw:
    case null:
      return AppColors.textSecondary;
  }
}

/// Bande de pastilles chronologiques (plus ancienne à gauche, plus récente
/// à droite) donnant un coup d'œil rapide sur la dynamique récente, sans
/// avoir à lire l'historique complet.
class _RecentFormRow extends StatelessWidget {
  final AppLocalizations l10n;
  final List<BattleDetails> battles;

  const _RecentFormRow({required this.l10n, required this.battles});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final recent = battles.take(10).toList().reversed.toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final battle in recent)
          Tooltip(
            message:
                '${_resultLabel(l10n, battle.result)} — '
                '${battle.opponentName ?? battle.opponentArmyName ?? battle.missionName ?? '—'}'
                ' (${dateFormat.format(battle.playedAt)})',
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _resultColor(battle.result),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

class _BattleOutcomesCard extends StatelessWidget {
  final AppLocalizations l10n;
  final List<BattleDetails> battles;

  const _BattleOutcomesCard({required this.l10n, required this.battles});

  @override
  Widget build(BuildContext context) {
    var victories = 0;
    var defeats = 0;
    var draws = 0;
    for (final battle in battles) {
      switch (battle.result) {
        case BattleResult.victory:
          victories++;
        case BattleResult.defeat:
          defeats++;
        case BattleResult.draw:
          draws++;
        case null:
          break;
      }
    }
    final decided = victories + defeats + draws;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsBattleOutcomesTitle.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 12),
          if (decided == 0)
            Text(l10n.battleEmptyList, style: AppTextStyles.caption)
          else
            DonutChart(
              segments: [
                DonutSegment(
                  label: l10n.battleResultVictory,
                  value: victories,
                  color: AppColors.success,
                ),
                DonutSegment(
                  label: l10n.battleResultDefeat,
                  value: defeats,
                  color: AppColors.error,
                ),
                DonutSegment(
                  label: l10n.battleResultDraw,
                  value: draws,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _BattlesByFactionCard extends StatelessWidget {
  final AppLocalizations l10n;
  final List<BattleDetails> battles;

  const _BattlesByFactionCard({required this.l10n, required this.battles});

  static const _palette = [
    AppColors.primary,
    AppColors.info,
    AppColors.success,
    AppColors.warning,
    AppColors.error,
  ];

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final battle in battles) {
      final name = battle.opponentFactionName ?? l10n.statsUnknownFaction;
      counts[name] = (counts[name] ?? 0) + 1;
    }
    final entries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.statsBattlesByFactionTitle.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 12),
          if (entries.isEmpty)
            Text(l10n.battleEmptyList, style: AppTextStyles.caption)
          else
            DonutChart(
              segments: [
                for (var i = 0; i < entries.length; i++)
                  DonutSegment(
                    label: entries[i].key,
                    value: entries[i].value,
                    color: _palette[i % _palette.length],
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
