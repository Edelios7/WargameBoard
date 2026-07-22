import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/battle_event_details.dart';
import '../../../database/tables/battle_unit_modifiers_table.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/xp_provider.dart';
import '../../catalog/pages/datasheet_full_page.dart';

const _phaseOrder = [
  BattlePhase.command,
  BattlePhase.movement,
  BattlePhase.shooting,
  BattlePhase.charge,
  BattlePhase.fight,
  BattlePhase.morale,
];

String _phaseLabel(AppLocalizations l10n, BattlePhase phase) {
  switch (phase) {
    case BattlePhase.command:
      return l10n.battlePhaseCommand;
    case BattlePhase.movement:
      return l10n.battlePhaseMovement;
    case BattlePhase.shooting:
      return l10n.battlePhaseShooting;
    case BattlePhase.charge:
      return l10n.battlePhaseCharge;
    case BattlePhase.fight:
      return l10n.battlePhaseFight;
    case BattlePhase.morale:
      return l10n.battlePhaseMorale;
  }
}

/// Tableau de bord d'une partie suivie en direct — affiché à la place de
/// la liste/historique tant que [activeBattleProvider] a une valeur (voir
/// [BattlePage]).
class BattleDashboard extends ConsumerWidget {
  final BattleDetails battle;

  const BattleDashboard({super.key, required this.battle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = battle.currentRound ?? 1;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(battle: battle, round: round),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScoreBlock(battle: battle),
                  const SizedBox(height: 16),
                  _PhaseBlock(battle: battle),
                  const SizedBox(height: 16),
                  _CommandPointsBlock(battle: battle),
                  if (battle.armyId != null) ...[
                    const SizedBox(height: 16),
                    _RosterBlock(battleId: battle.id, armyId: battle.armyId!),
                  ],
                  const SizedBox(height: 16),
                  _EventsBlock(battleId: battle.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  final BattleDetails battle;
  final int round;

  const _Header({required this.battle, required this.round});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                battle.opponentName ?? l10n.battleOpponentLabel,
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (battle.opponentFactionName != null)
                    battle.opponentFactionName!,
                  if (battle.missionName != null) battle.missionName!,
                ].join(' · '),
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: .16),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            l10n.battleDashboardRound(round),
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.surfaceElevated,
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (_) => _FinishBattleDialog(battle: battle),
          ),
          child: Text(AppLocalizations.of(context)!.battleDashboardFinish),
        ),
      ],
    );
  }
}

class _ScoreBlock extends ConsumerWidget {
  final BattleDetails battle;

  const _ScoreBlock({required this.battle});

  Future<void> _adjust(
    WidgetRef ref, {
    required bool mine,
    required int delta,
  }) {
    final repo = ref.read(battleRepositoryProvider);
    final current = mine ? (battle.myScore ?? 0) : (battle.opponentScore ?? 0);
    final next = (current + delta).clamp(0, 1 << 30);
    return repo
        .updateLiveState(
          battle.id,
          myScore: mine ? Value(next) : const Value.absent(),
          opponentScore: mine ? const Value.absent() : Value(next),
        )
        .then((_) => ref.invalidate(activeBattleProvider));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _ScoreColumn(
              label: l10n.battleMyScoreLabel,
              value: battle.myScore ?? 0,
              onIncrement: () => _adjust(ref, mine: true, delta: 1),
              onDecrement: () => _adjust(ref, mine: true, delta: -1),
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _ScoreColumn(
              label: l10n.battleOpponentScoreLabel,
              value: battle.opponentScore ?? 0,
              onIncrement: () => _adjust(ref, mine: false, delta: 1),
              onDecrement: () => _adjust(ref, mine: false, delta: -1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ScoreColumn({
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.eyebrow),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_rounded),
              color: AppColors.textSecondary,
              onPressed: onDecrement,
            ),
            SizedBox(
              width: 48,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: AppColors.primary,
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }
}

class _PhaseBlock extends ConsumerWidget {
  final BattleDetails battle;

  const _PhaseBlock({required this.battle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = battle.currentPhase == null
        ? 0
        : _phaseOrder.indexOf(battle.currentPhase!);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _phaseOrder.length; i++)
                _PhaseChip(
                  label: _phaseLabel(l10n, _phaseOrder[i]),
                  state: i < currentIndex
                      ? _PhaseState.done
                      : i == currentIndex
                      ? _PhaseState.active
                      : _PhaseState.pending,
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                await ref
                    .read(battleRepositoryProvider)
                    .advancePhase(battle.id);
                ref.invalidate(activeBattleProvider);
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(l10n.battleDashboardNextPhase),
            ),
          ),
        ],
      ),
    );
  }
}

enum _PhaseState { done, active, pending }

class _PhaseChip extends StatelessWidget {
  final String label;
  final _PhaseState state;

  const _PhaseChip({required this.label, required this.state});

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      _PhaseState.done => AppColors.success,
      _PhaseState.active => AppColors.primary,
      _PhaseState.pending => AppColors.textSecondary,
    };
    final icon = switch (state) {
      _PhaseState.done => Icons.check_circle_rounded,
      _PhaseState.active => Icons.play_circle_fill_rounded,
      _PhaseState.pending => Icons.circle_outlined,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: state == _PhaseState.pending ? 0 : .14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: .5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: state == _PhaseState.active
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommandPointsBlock extends ConsumerWidget {
  final BattleDetails battle;

  const _CommandPointsBlock({required this.battle});

  Future<void> _adjust(
    WidgetRef ref, {
    required bool mine,
    required int delta,
  }) async {
    final repo = ref.read(battleRepositoryProvider);
    final current = mine
        ? (battle.myCommandPoints ?? 0)
        : (battle.opponentCommandPoints ?? 0);
    final next = (current + delta).clamp(0, 1 << 30);
    await repo.updateLiveState(
      battle.id,
      myCommandPoints: mine ? Value(next) : const Value.absent(),
      opponentCommandPoints: mine ? const Value.absent() : Value(next),
    );
    await repo.logEvent(
      battle.id,
      label: mine
          ? 'CP ${delta > 0 ? '+1' : '-1'}'
          : 'Opponent CP ${delta > 0 ? '+1' : '-1'}',
      cpDelta: mine ? delta : null,
      round: battle.currentRound,
      phase: battle.currentPhase,
    );
    ref.invalidate(activeBattleProvider);
    ref.invalidate(battleEventsProvider(battle.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: _ScoreColumn(
              label: l10n.battleDashboardMyCp,
              value: battle.myCommandPoints ?? 0,
              onIncrement: () => _adjust(ref, mine: true, delta: 1),
              onDecrement: () => _adjust(ref, mine: true, delta: -1),
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _ScoreColumn(
              label: l10n.battleDashboardOpponentCp,
              value: battle.opponentCommandPoints ?? 0,
              onIncrement: () => _adjust(ref, mine: false, delta: 1),
              onDecrement: () => _adjust(ref, mine: false, delta: -1),
            ),
          ),
        ],
      ),
    );
  }
}

String _statLabel(AppLocalizations l10n, BattleStatKey key) {
  switch (key) {
    case BattleStatKey.movement:
      return l10n.statMovement;
    case BattleStatKey.toughness:
      return l10n.statToughness;
    case BattleStatKey.save:
      return l10n.statSave;
    case BattleStatKey.wounds:
      return l10n.statWounds;
    case BattleStatKey.leadership:
      return l10n.statLeadership;
    case BattleStatKey.objectiveControl:
      return l10n.statObjectiveControl;
  }
}

/// Roster de l'armée engagée — consultation instantanée d'une fiche
/// complète, marquage détruit/vivant et bonus-malus de caractéristiques
/// sans quitter la partie (voir vision "Assistant de règles").
class _RosterBlock extends ConsumerWidget {
  final String battleId;
  final String armyId;

  const _RosterBlock({required this.battleId, required this.armyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armyAsync = ref.watch(armyByIdProvider(armyId));
    final statesAsync = ref.watch(battleUnitStatesProvider(battleId));
    final modifiersAsync = ref.watch(battleUnitModifiersProvider(battleId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.battleDashboardRoster.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 12),
          armyAsync.when(
            loading: () =>
                const LinearProgressIndicator(color: AppColors.primary),
            error: (_, __) => const SizedBox.shrink(),
            data: (army) {
              if (army == null || army.units.isEmpty) {
                return const SizedBox.shrink();
              }
              final destroyedIds = {
                for (final state in statesAsync.value ?? const [])
                  if (state.destroyed) state.armyUnitId,
              };
              final modifierCounts = <String, int>{};
              for (final modifier in modifiersAsync.value ?? const []) {
                modifierCounts[modifier.armyUnitId] =
                    (modifierCounts[modifier.armyUnitId] ?? 0) + 1;
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final unit in army.units)
                    _RosterChip(
                      label: unit.datasheetName,
                      modelCount: unit.modelCount,
                      destroyed: destroyedIds.contains(unit.id),
                      modifierCount: modifierCounts[unit.id] ?? 0,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => _UnitManageDialog(
                          battleId: battleId,
                          unit: unit,
                          destroyed: destroyedIds.contains(unit.id),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RosterChip extends StatelessWidget {
  final String label;
  final int modelCount;
  final bool destroyed;
  final int modifierCount;
  final VoidCallback onTap;

  const _RosterChip({
    required this.label,
    required this.modelCount,
    required this.destroyed,
    required this.modifierCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: destroyed ? 0.45 : 1,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: destroyed ? AppColors.error : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (destroyed)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.error,
                    ),
                  ),
                Text(
                  '$label ×$modelCount',
                  style: AppTextStyles.body.copyWith(
                    decoration: destroyed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                if (modifierCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$modifierCount',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitManageDialog extends ConsumerStatefulWidget {
  final String battleId;
  final ArmyUnitDetails unit;
  final bool destroyed;

  const _UnitManageDialog({
    required this.battleId,
    required this.unit,
    required this.destroyed,
  });

  @override
  ConsumerState<_UnitManageDialog> createState() => _UnitManageDialogState();
}

class _UnitManageDialogState extends ConsumerState<_UnitManageDialog> {
  final _valueController = TextEditingController(text: '1');
  final _labelController = TextEditingController();
  BattleStatKey _statKey = BattleStatKey.toughness;

  @override
  void dispose() {
    _valueController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _toggleDestroyed(bool destroyed) async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(battleRepositoryProvider);
    await repo.setUnitDestroyed(
      widget.battleId,
      widget.unit.id,
      destroyed: destroyed,
    );
    await repo.logEvent(
      widget.battleId,
      label: destroyed
          ? '${widget.unit.datasheetName} — ${l10n.battleUnitDestroyed}'
          : '${widget.unit.datasheetName} — ${l10n.battleUnitRestore}',
    );
    ref.invalidate(battleUnitStatesProvider(widget.battleId));
    ref.invalidate(battleEventsProvider(widget.battleId));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _addModifier() async {
    final delta = int.tryParse(_valueController.text.trim());
    if (delta == null || delta == 0) return;

    await ref
        .read(battleRepositoryProvider)
        .addUnitModifier(
          widget.battleId,
          widget.unit.id,
          statKey: _statKey,
          delta: delta,
          label: _labelController.text.trim().isEmpty
              ? null
              : _labelController.text.trim(),
        );
    ref.invalidate(battleUnitModifiersProvider(widget.battleId));
    _labelController.clear();
  }

  Future<void> _removeModifier(String modifierId) async {
    await ref.read(battleRepositoryProvider).removeUnitModifier(modifierId);
    ref.invalidate(battleUnitModifiersProvider(widget.battleId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modifiersAsync = ref.watch(
      battleUnitModifiersProvider(widget.battleId),
    );
    final unitModifiers = (modifiersAsync.value ?? const [])
        .where((m) => m.armyUnitId == widget.unit.id)
        .toList();

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.unit.datasheetName, style: AppTextStyles.title),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DatasheetFullPage(
                          datasheetId: widget.unit.datasheetId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: Text(l10n.battleUnitViewFullSheet),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.destroyed
                        ? AppColors.success
                        : AppColors.error,
                  ),
                  onPressed: () => _toggleDestroyed(!widget.destroyed),
                  child: Text(
                    widget.destroyed
                        ? l10n.battleUnitRestore
                        : l10n.battleUnitMarkDestroyed,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.battleUnitModifiersTitle.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                ),
                const SizedBox(height: 8),
                if (unitModifiers.isEmpty)
                  Text(l10n.battleUnitNoModifiers, style: AppTextStyles.caption)
                else
                  for (final modifier in unitModifiers)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            '${modifier.delta > 0 ? '+' : ''}${modifier.delta} ${_statLabel(l10n, modifier.statKey)}',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: modifier.delta > 0
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          if (modifier.label != null &&
                              modifier.label!.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                modifier.label!,
                                style: AppTextStyles.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else
                            const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16),
                            color: AppColors.textSecondary,
                            onPressed: () => _removeModifier(modifier.id),
                          ),
                        ],
                      ),
                    ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<BattleStatKey>(
                        initialValue: _statKey,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        style: AppTextStyles.body,
                        decoration: const InputDecoration(isDense: true),
                        items: [
                          for (final key in BattleStatKey.values)
                            DropdownMenuItem(
                              value: key,
                              child: Text(_statLabel(l10n, key)),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _statKey = value ?? _statKey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _valueController,
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                        ),
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: l10n.battleUnitModifierValueHint,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _labelController,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: l10n.battleUnitModifierLabelHint,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _addModifier,
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: Text(l10n.battleUnitAddModifier),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventsBlock extends ConsumerStatefulWidget {
  final String battleId;

  const _EventsBlock({required this.battleId});

  @override
  ConsumerState<_EventsBlock> createState() => _EventsBlockState();
}

class _EventsBlockState extends ConsumerState<_EventsBlock> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await ref
        .read(battleRepositoryProvider)
        .logEvent(widget.battleId, label: text);
    _controller.clear();
    ref.invalidate(battleEventsProvider(widget.battleId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final eventsAsync = ref.watch(battleEventsProvider(widget.battleId));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.battleDashboardEvents.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: AppTextStyles.body,
                  onSubmitted: (_) => _add(),
                  decoration: InputDecoration(
                    hintText: l10n.battleDashboardEventHint,
                    hintStyle: AppTextStyles.caption,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_rounded),
                color: AppColors.primary,
                onPressed: _add,
              ),
            ],
          ),
          const SizedBox(height: 8),
          eventsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (events) => Column(
              children: [for (final event in events) _EventRow(event: event)],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  final BattleEventDetails event;

  const _EventRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.Hm();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            timeFormat.format(event.createdAt),
            style: AppTextStyles.caption,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(event.label, style: AppTextStyles.body)),
          if (event.cpDelta != null)
            Text(
              '${event.cpDelta! > 0 ? '+' : ''}${event.cpDelta} CP',
              style: AppTextStyles.caption.copyWith(
                color: event.cpDelta! > 0 ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}

class _FinishBattleDialog extends ConsumerStatefulWidget {
  final BattleDetails battle;

  const _FinishBattleDialog({required this.battle});

  @override
  ConsumerState<_FinishBattleDialog> createState() =>
      _FinishBattleDialogState();
}

class _FinishBattleDialogState extends ConsumerState<_FinishBattleDialog> {
  final _notesController = TextEditingController();
  BattleResult? _result = BattleResult.victory;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final battle = widget.battle;
    await ref
        .read(battleRepositoryProvider)
        .finishBattle(
          battle.id,
          armyId: battle.armyId,
          result: _result,
          type: battle.type,
          myScore: battle.myScore,
          opponentScore: battle.opponentScore,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    ref.invalidate(activeBattleProvider);
    ref.invalidate(battlesListProvider);
    ref.invalidate(battleStatsProvider);
    ref.invalidate(xpSummaryProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.battleDashboardFinish, style: AppTextStyles.title),
              const SizedBox(height: 16),
              DropdownButtonFormField<BattleResult?>(
                initialValue: _result,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: l10n.battleResultLabel,
                  labelStyle: AppTextStyles.caption,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: BattleResult.victory,
                    child: Text(l10n.battleResultVictory),
                  ),
                  DropdownMenuItem(
                    value: BattleResult.defeat,
                    child: Text(l10n.battleResultDefeat),
                  ),
                  DropdownMenuItem(
                    value: BattleResult.draw,
                    child: Text(l10n.battleResultDraw),
                  ),
                ],
                onChanged: (value) => setState(() => _result = value),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: l10n.battleNotesLabel,
                  labelStyle: AppTextStyles.caption,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.armyBuilderCancel,
                      style: AppTextStyles.body,
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: _finish,
                    child: Text(l10n.battleDashboardFinish),
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
