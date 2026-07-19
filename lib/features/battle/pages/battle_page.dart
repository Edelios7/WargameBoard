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
import '../widgets/log_battle_dialog.dart';

class BattlePage extends ConsumerWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final battlesAsync = ref.watch(battlesListProvider);

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
                Text(l10n.navBattles, style: AppTextStyles.heading),
                FilledButton.icon(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => const LogBattleDialog(),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.battleNewBattle),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: battlesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, _) => Center(
                  child: Text('$error', style: AppTextStyles.caption),
                ),
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
      ),
    );
  }
}

class _BattleCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).toString());

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
                Text(
                  battle.opponentName ?? battle.missionName ?? '—',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    dateFormat.format(battle.playedAt),
                    if (battle.armyName != null) battle.armyName!,
                    if (battle.missionName != null &&
                        battle.opponentName != null)
                      battle.missionName!,
                  ].join(' · '),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          if (battle.myScore != null && battle.opponentScore != null)
            Text(
              l10n.battleScoreLine(battle.myScore!, battle.opponentScore!),
              style: AppTextStyles.body,
            ),
        ],
      ),
    );
  }
}
