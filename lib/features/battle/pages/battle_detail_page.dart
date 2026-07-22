import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/battle_dashboard.dart';

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

/// Récapitulatif en lecture seule d'une partie terminée : le roster
/// (unités détruites, bonus/malus) et le journal restent visibles après
/// coup au lieu de disparaître une fois la partie close.
class BattleDetailPage extends StatelessWidget {
  final BattleDetails battle;

  const BattleDetailPage({super.key, required this.battle});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    );
    final rosters = [
      if (battle.armyId != null)
        RosterBlock(
          battleId: battle.id,
          armyId: battle.armyId!,
          title: l10n.battleDashboardRoster,
          accentColor: AppColors.primary,
          readOnly: true,
        ),
      if (battle.opponentArmyId != null)
        RosterBlock(
          battleId: battle.id,
          armyId: battle.opponentArmyId!,
          title: l10n.battleDashboardOpponentRoster,
          accentColor: AppColors.info,
          readOnly: true,
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(l10n.battleDetailTitle, style: AppTextStyles.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: l10n.battleDetailBack,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              battle.armyName ?? l10n.battleArmyLabel,
                              style: AppTextStyles.heading,
                            ),
                            Text(
                              'VS ${battle.opponentArmyName ?? battle.opponentName ?? l10n.battleOpponentLabel}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _resultColor(
                            battle.result,
                          ).withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _resultLabel(l10n, battle.result),
                          style: AppTextStyles.body.copyWith(
                            color: _resultColor(battle.result),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dateFormat.format(battle.playedAt),
                    style: AppTextStyles.caption,
                  ),
                  if (battle.myScore != null &&
                      battle.opponentScore != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.battleScoreLine(
                        battle.myScore!,
                        battle.opponentScore!,
                      ),
                      style: AppTextStyles.heading.copyWith(
                        color: _resultColor(battle.result),
                      ),
                    ),
                  ],
                  if (battle.myCommandPoints != null ||
                      battle.opponentCommandPoints != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.battleDashboardMyCp}: ${battle.myCommandPoints ?? 0}  ·  '
                      '${l10n.battleDashboardOpponentCp}: ${battle.opponentCommandPoints ?? 0}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ],
              ),
            ),
            for (final roster in rosters) ...[
              const SizedBox(height: 16),
              roster,
            ],
            const SizedBox(height: 16),
            EventsBlock(battleId: battle.id, readOnly: true),
            const SizedBox(height: 16),
            NotesBlock(
              battleId: battle.id,
              notes: battle.notes,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
