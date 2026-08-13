import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/battle_secondary_mission_details.dart';
import '../../../database/models/mission_options.dart';
import '../../../database/tables/battle_secondary_missions_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/battle_provider.dart';

/// Fiche de mission (pack GDM 2026) : choix des postures de bataille pour
/// faire apparaître la mission primaire qui en résulte, et choix des
/// missions secondaires de chaque camp — tout est affiché en carte de
/// référence consultable pendant la partie.
class MissionCardBlock extends ConsumerWidget {
  final BattleDetails battle;

  const MissionCardBlock({super.key, required this.battle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dispositionsAsync = ref.watch(dispositionsProvider);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.battleMissionCardTitle.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
            ],
          ),
          const SizedBox(height: 16),
          dispositionsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (dispositions) => _DispositionPickers(
              battle: battle,
              dispositions: dispositions,
            ),
          ),
          if (battle.myDispositionId != null &&
              battle.opponentDispositionId != null) ...[
            const SizedBox(height: 16),
            _PrimaryMissionCard(
              yourDispositionId: battle.myDispositionId!,
              opponentDispositionId: battle.opponentDispositionId!,
            ),
          ],
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SecondaryMissionsColumn(
                  battleId: battle.id,
                  title: l10n.battleMissionCardMySecondaries,
                  side: BattleSecondarySide.mine,
                  accentColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _SecondaryMissionsColumn(
                  battleId: battle.id,
                  title: l10n.battleMissionCardOpponentSecondaries,
                  side: BattleSecondarySide.opponent,
                  accentColor: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DispositionPickers extends ConsumerWidget {
  final BattleDetails battle;
  final List<DispositionOption> dispositions;

  const _DispositionPickers({required this.battle, required this.dispositions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> pick({required bool mine}) async {
      final selected = await showDialog<String>(
        context: context,
        builder: (context) => AppDialogShortcuts(
          child: SimpleDialog(
            backgroundColor: AppColors.surface,
            title: Text(
              mine
                  ? l10n.battleMissionCardMyDisposition
                  : l10n.battleMissionCardOpponentDisposition,
              style: AppTextStyles.title,
            ),
            children: [
              for (final d in dispositions)
                SimpleDialogOption(
                  onPressed: () => Navigator.of(context).pop(d.id),
                  child: Text(d.name, style: AppTextStyles.body),
                ),
            ],
          ),
        ),
      );
      if (selected == null) return;
      final repository = ref.read(battleRepositoryProvider);
      await repository.updateLiveState(
        battle.id,
        myDispositionId: mine ? Value(selected) : const Value.absent(),
        opponentDispositionId: mine
            ? const Value.absent()
            : Value(selected),
      );
      ref.invalidate(activeBattleProvider);
    }

    String labelFor(String? id) =>
        dispositions.where((d) => d.id == id).map((d) => d.name).firstOrNull ??
        l10n.battleMissionCardChoose;

    return Row(
      children: [
        Expanded(
          child: _PickerTile(
            label: l10n.battleMissionCardMyDisposition,
            value: labelFor(battle.myDispositionId),
            onTap: () => pick(mine: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PickerTile(
            label: l10n.battleMissionCardOpponentDisposition,
            value: labelFor(battle.opponentDispositionId),
            onTap: () => pick(mine: false),
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryMissionCard extends ConsumerWidget {
  final String yourDispositionId;
  final String opponentDispositionId;

  const _PrimaryMissionCard({
    required this.yourDispositionId,
    required this.opponentDispositionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final missionAsync = ref.watch(
      primaryMissionProvider((yourDispositionId, opponentDispositionId)),
    );

    return missionAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (mission) {
        if (mission == null) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.battleMissionCardPrimaryMission,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 4),
              Text(mission.name, style: AppTextStyles.title),
              const SizedBox(height: 8),
              Text(mission.scoring, style: AppTextStyles.body),
              if (mission.action != null && mission.action!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.battleMissionCardAction,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(mission.action!, style: AppTextStyles.body),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SecondaryMissionsColumn extends ConsumerWidget {
  final String battleId;
  final String title;
  final BattleSecondarySide side;
  final Color accentColor;

  const _SecondaryMissionsColumn({
    required this.battleId,
    required this.title,
    required this.side,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectionsAsync = ref.watch(battleSecondaryMissionsProvider(battleId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.caption.copyWith(color: accentColor),
              ),
            ),
            InkWell(
              onTap: () => _editSecondaries(context, ref),
              child: Text(
                l10n.battleMissionCardEditSecondaries,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        selectionsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (all) {
            final mine = all.where((s) => s.side == side).toList();
            if (mine.isEmpty) {
              return Text(
                l10n.battleMissionCardNoneChosen,
                style: AppTextStyles.caption,
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final selection in mine) ...[
                  _SecondaryMissionTile(
                    selection: selection,
                    accentColor: accentColor,
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _editSecondaries(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final allOptions = await ref
        .read(battleRepositoryProvider)
        .listSecondaryMissions();
    final current = await ref
        .read(battleRepositoryProvider)
        .listBattleSecondaryMissions(battleId);
    final selectedIds = current
        .where((s) => s.side == side)
        .map((s) => s.secondaryMissionId)
        .toSet();

    if (!context.mounted) return;

    final result = await showDialog<Set<String>>(
      context: context,
      builder: (context) => _SecondaryMissionPickerDialog(
        title: l10n.battleMissionCardPickSecondariesTitle,
        options: allOptions,
        initiallySelected: selectedIds,
      ),
    );
    if (result == null) return;

    await ref
        .read(battleRepositoryProvider)
        .setBattleSecondaryMissions(battleId, side, result.toList());
    ref.invalidate(battleSecondaryMissionsProvider(battleId));
  }
}

class _SecondaryMissionTile extends StatelessWidget {
  final BattleSecondaryMissionDetails selection;
  final Color accentColor;

  const _SecondaryMissionTile({
    required this.selection,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  selection.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (selection.isFixed) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: .18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.battleMissionCardFixedBadge,
                    style: AppTextStyles.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(selection.effect, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SecondaryMissionPickerDialog extends StatefulWidget {
  final String title;
  final List<SecondaryMissionOption> options;
  final Set<String> initiallySelected;

  const _SecondaryMissionPickerDialog({
    required this.title,
    required this.options,
    required this.initiallySelected,
  });

  @override
  State<_SecondaryMissionPickerDialog> createState() =>
      _SecondaryMissionPickerDialogState();
}

class _SecondaryMissionPickerDialogState
    extends State<_SecondaryMissionPickerDialog> {
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShortcuts(
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 460,
          height: 560,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: AppTextStyles.title),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: [
                      for (final option in widget.options)
                        CheckboxListTile(
                          value: _selected.contains(option.id),
                          title: Text(option.name, style: AppTextStyles.body),
                          subtitle: Text(
                            option.effect,
                            style: AppTextStyles.caption,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (checked) {
                            setState(() {
                              if (checked ?? false) {
                                _selected.add(option.id);
                              } else {
                                _selected.remove(option.id);
                              }
                            });
                          },
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: const Text('OK'),
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
