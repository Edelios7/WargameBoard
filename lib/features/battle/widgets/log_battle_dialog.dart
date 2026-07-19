import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';

class LogBattleDialog extends ConsumerStatefulWidget {
  const LogBattleDialog({super.key});

  @override
  ConsumerState<LogBattleDialog> createState() => _LogBattleDialogState();
}

class _LogBattleDialogState extends ConsumerState<LogBattleDialog> {
  final _opponentController = TextEditingController();
  final _missionController = TextEditingController();
  final _myScoreController = TextEditingController();
  final _opponentScoreController = TextEditingController();
  final _notesController = TextEditingController();
  String? _armyId;
  BattleResult _result = BattleResult.victory;

  @override
  void dispose() {
    _opponentController.dispose();
    _missionController.dispose();
    _myScoreController.dispose();
    _opponentScoreController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(battleRepositoryProvider).addBattle(
          armyId: _armyId,
          opponentName: _opponentController.text.trim().isEmpty
              ? null
              : _opponentController.text.trim(),
          missionName: _missionController.text.trim().isEmpty
              ? null
              : _missionController.text.trim(),
          result: _result,
          myScore: int.tryParse(_myScoreController.text.trim()),
          opponentScore: int.tryParse(_opponentScoreController.text.trim()),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    ref.invalidate(battlesListProvider);
    if (mounted) Navigator.of(context).pop();
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.caption,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.battleNewBattle, style: AppTextStyles.title),
              const SizedBox(height: 20),
              TextField(
                controller: _opponentController,
                style: AppTextStyles.body,
                decoration: _decoration(l10n.battleOpponentLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _missionController,
                style: AppTextStyles.body,
                decoration: _decoration(l10n.battleMissionLabel),
              ),
              const SizedBox(height: 12),
              armiesAsync.when(
                loading: () => const LinearProgressIndicator(
                  color: AppColors.primary,
                ),
                error: (_, __) => const SizedBox.shrink(),
                data: (armies) => DropdownButtonFormField<String?>(
                  initialValue: _armyId,
                  dropdownColor: AppColors.surface,
                  style: AppTextStyles.body,
                  decoration: _decoration(l10n.battleArmyLabel),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.battleArmyNone),
                    ),
                    ...armies.map(
                      (army) => DropdownMenuItem<String?>(
                        value: army.id,
                        child: Text(army.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _armyId = value),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<BattleResult>(
                initialValue: _result,
                dropdownColor: AppColors.surface,
                style: AppTextStyles.body,
                decoration: _decoration(l10n.battleResultLabel),
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
                onChanged: (value) =>
                    setState(() => _result = value ?? BattleResult.victory),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _myScoreController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body,
                      decoration: _decoration(l10n.battleMyScoreLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _opponentScoreController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.body,
                      decoration: _decoration(l10n.battleOpponentScoreLabel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: AppTextStyles.body,
                decoration: _decoration(l10n.battleNotesLabel),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.armyBuilderCancel,
                      style: AppTextStyles.body,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    onPressed: _save,
                    child: Text(l10n.armyBuilderCreate),
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
