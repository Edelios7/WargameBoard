import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/battle_provider.dart';
import '../widgets/battle_dashboard.dart';
import '../widgets/battle_setup_dialog.dart';
import '../widgets/log_battle_dialog.dart';

class BattlePage extends ConsumerWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeBattleAsync = ref.watch(activeBattleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: activeBattleAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) =>
            Center(child: Text('$error', style: AppTextStyles.caption)),
        data: (activeBattle) => activeBattle != null
            ? BattleDashboard(battle: activeBattle)
            : const _BattleHistoryView(),
      ),
    );
  }
}

class _BattleHistoryView extends ConsumerWidget {
  const _BattleHistoryView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final battlesAsync = ref.watch(battlesListProvider);

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;
              final title = Text(l10n.navBattles, style: AppTextStyles.heading);
              final controls = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const LogBattleDialog(),
                    ),
                    child: Text(
                      l10n.battleLogExistingGame,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: () async {
                      final started = await showDialog<String?>(
                        context: context,
                        builder: (_) => const BattleSetupDialog(),
                      );
                      if (started != null) ref.invalidate(activeBattleProvider);
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.battleNewBattle),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 12), controls],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [title, controls],
              );
            },
          ),
          const SizedBox(height: 24),
          Expanded(
            child: battlesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (error, _) =>
                  Center(child: Text('$error', style: AppTextStyles.caption)),
              data: (battles) {
                if (battles.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.battleEmptyList,
                      style: AppTextStyles.caption,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: battles.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BattleCard(battle: battles[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BattleCard extends ConsumerWidget {
  final BattleDetails battle;

  const _BattleCard({required this.battle});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _resultColor(battle.result).withValues(alpha: .18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _resultLabel(l10n, battle.result),
              style: AppTextStyles.caption.copyWith(
                color: _resultColor(battle.result),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        battle.opponentName ?? battle.missionName ?? '—',
                        style: AppTextStyles.body,
                      ),
                    ),
                    Text(
                      dateFormat.format(battle.playedAt),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    if (battle.armyName != null) battle.armyName!,
                    if (battle.missionName != null &&
                        battle.opponentName != null)
                      battle.missionName!,
                  ].join(' · '),
                  style: AppTextStyles.caption,
                ),
                if (battle.notes != null && battle.notes!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    battle.notes!,
                    style: AppTextStyles.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (battle.myScore != null && battle.opponentScore != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                l10n.battleScoreLine(battle.myScore!, battle.opponentScore!),
                style: AppTextStyles.title.copyWith(
                  color: _resultColor(battle.result),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textSecondary,
            onPressed: () async {
              await ref.read(battleRepositoryProvider).deleteBattle(battle.id);
              ref.invalidate(battlesListProvider);
              ref.invalidate(nextBattleProvider);
              ref.invalidate(lastBattleProvider);
            },
          ),
        ],
      ),
    );
  }
}
