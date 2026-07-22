import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';

/// Mot-clé français de chaque phase, utilisé pour présélectionner les
/// stratagèmes dont la condition de déclenchement (texte libre importé du
/// livre de règles, `Stratagems.phase`) mentionne la phase active — pas
/// une correspondance garantie à 100% (la condition peut préciser "à
/// votre phase" ou "à la phase adverse"), d'où l'affichage du texte de
/// condition complet pour que le joueur tranche lui-même.
String? _phaseKeyword(BattlePhase phase) {
  switch (phase) {
    case BattlePhase.command:
      return 'commandement';
    case BattlePhase.movement:
      return 'mouvement';
    case BattlePhase.shooting:
      return 'tir';
    case BattlePhase.charge:
      return 'charge';
    case BattlePhase.fight:
      return 'combat';
    case BattlePhase.morale:
      return null;
  }
}

bool _matchesPhase(StratagemOption stratagem, BattlePhase phase) {
  final condition = stratagem.phase?.toLowerCase();
  if (condition == null || condition.isEmpty) return true;
  if (condition.contains('importe quelle phase')) return true;
  final keyword = _phaseKeyword(phase);
  if (keyword == null) return false;
  return condition.contains(keyword);
}

/// Assistant de règles : présélectionne, pour la phase en cours, les
/// stratagèmes du détachement dont la condition de déclenchement mentionne
/// cette phase — pour réduire les allers-retours dans le livret de
/// détachement sans jouer à la place du joueur (le texte de condition
/// complet reste affiché pour vérification).
class StratagemAssistantBlock extends ConsumerWidget {
  final BattleDetails battle;
  final String armyId;
  final String title;
  final Color accentColor;
  final bool mine;

  const StratagemAssistantBlock({
    super.key,
    required this.battle,
    required this.armyId,
    required this.title,
    required this.accentColor,
    required this.mine,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final armyAsync = ref.watch(armyByIdProvider(armyId));
    final phase = battle.currentPhase ?? BattlePhase.command;

    return armyAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (army) {
        final detachmentId = army?.detachmentId;
        if (detachmentId == null) return const SizedBox.shrink();

        final stratagemsAsync = ref.watch(
          stratagemsForDetachmentProvider(detachmentId),
        );

        return stratagemsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (all) {
            final matching = all.where((s) => _matchesPhase(s, phase)).toList();
            if (matching.isEmpty) return const SizedBox.shrink();

            return AppCard(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(title.toUpperCase(), style: AppTextStyles.eyebrow),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  for (final stratagem in matching)
                    _StratagemTile(
                      battle: battle,
                      stratagem: stratagem,
                      accentColor: accentColor,
                      mine: mine,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StratagemTile extends ConsumerWidget {
  final BattleDetails battle;
  final StratagemOption stratagem;
  final Color accentColor;
  final bool mine;

  const _StratagemTile({
    required this.battle,
    required this.stratagem,
    required this.accentColor,
    required this.mine,
  });

  Future<void> _use(WidgetRef ref) async {
    final repo = ref.read(battleRepositoryProvider);
    final current = mine
        ? (battle.myCommandPoints ?? 0)
        : (battle.opponentCommandPoints ?? 0);
    final next = (current - stratagem.commandPoints).clamp(0, 1 << 30);
    await repo.updateLiveState(
      battle.id,
      myCommandPoints: mine ? Value(next) : const Value.absent(),
      opponentCommandPoints: mine ? const Value.absent() : Value(next),
    );
    await repo.logEvent(
      battle.id,
      label: stratagem.name,
      cpDelta: mine ? -stratagem.commandPoints : null,
      opponentCpDelta: mine ? null : -stratagem.commandPoints,
      round: battle.currentRound,
      phase: battle.currentPhase,
    );
    ref.invalidate(activeBattleProvider);
    ref.invalidate(battleEventsProvider(battle.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final availableCp = mine
        ? (battle.myCommandPoints ?? 0)
        : (battle.opponentCommandPoints ?? 0);
    final canAfford = availableCp >= stratagem.commandPoints;

    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      title: Row(
        children: [
          Expanded(
            child: Text(
              stratagem.name,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              l10n.armyBuilderStratagemCp(stratagem.commandPoints),
              style: AppTextStyles.caption.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stratagem.phase != null) ...[
                Text(
                  stratagem.phase!,
                  style: AppTextStyles.caption.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              if (stratagem.description != null)
                Text(stratagem.description!, style: AppTextStyles.body),
              const SizedBox(height: 10),
              if (mine)
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: accentColor),
                  onPressed: canAfford ? () => _use(ref) : null,
                  child: Text(l10n.battleStratagemUse(stratagem.commandPoints)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
