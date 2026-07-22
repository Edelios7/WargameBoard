import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../database/models/army_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/catalog_provider.dart';

/// Préparation d'une nouvelle partie suivie en direct — contrairement à
/// [LogBattleDialog] (saisie rétroactive d'une partie déjà jouée), ce
/// dialogue démarre une partie active dont le tableau de bord (round,
/// phase, CP, journal) reste affiché jusqu'à ce qu'elle soit terminée.
class BattleSetupDialog extends ConsumerStatefulWidget {
  const BattleSetupDialog({super.key});

  @override
  ConsumerState<BattleSetupDialog> createState() => _BattleSetupDialogState();
}

class _BattleSetupDialogState extends ConsumerState<BattleSetupDialog> {
  final _opponentController = TextEditingController();
  final _pointsLimitController = TextEditingController();
  final _missionController = TextEditingController();
  final _missionPackController = TextEditingController();
  final _terrainController = TextEditingController();
  String? _armyId;
  String? _opponentArmyId;
  String? _opponentFactionId;
  BattleType _type = BattleType.matched;

  @override
  void dispose() {
    _opponentController.dispose();
    _pointsLimitController.dispose();
    _missionController.dispose();
    _missionPackController.dispose();
    _terrainController.dispose();
    super.dispose();
  }

  void _onArmyChanged(String? armyId, List<ArmyListItem> armies) {
    setState(() {
      _armyId = armyId;
      final army = armies.where((a) => a.id == armyId).firstOrNull;
      if (army?.pointsLimit != null) {
        _pointsLimitController.text = army!.pointsLimit.toString();
      }
    });
  }

  Future<void> _start() async {
    final id = await ref
        .read(battleRepositoryProvider)
        .startBattle(
          armyId: _armyId,
          opponentArmyId: _opponentArmyId,
          opponentName: _opponentController.text.trim().isEmpty
              ? null
              : _opponentController.text.trim(),
          opponentFactionId: _opponentFactionId,
          pointsLimit: int.tryParse(_pointsLimitController.text.trim()),
          missionName: _missionController.text.trim().isEmpty
              ? null
              : _missionController.text.trim(),
          missionPack: _missionPackController.text.trim().isEmpty
              ? null
              : _missionPackController.text.trim(),
          terrain: _terrainController.text.trim().isEmpty
              ? null
              : _terrainController.text.trim(),
          type: _type,
        );

    ref.invalidate(activeBattleProvider);
    if (mounted) Navigator.of(context).pop(id);
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
    final factionsAsync = ref.watch(factionsListProvider);

    return AppDialogShortcuts(
      onEnter: _start,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.battleSetupTitle, style: AppTextStyles.title),
                  const SizedBox(height: 20),
                  armiesAsync.when(
                    loading: () =>
                        const LinearProgressIndicator(color: AppColors.primary),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (armies) => DropdownButtonFormField<String?>(
                      initialValue: _armyId,
                      isExpanded: true,
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
                            child: Text(
                              army.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) => _onArmyChanged(value, armies),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _opponentController,
                    style: AppTextStyles.body,
                    onSubmitted: (_) => _start(),
                    decoration: _decoration(l10n.battleOpponentLabel),
                  ),
                  const SizedBox(height: 12),
                  armiesAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (armies) => DropdownButtonFormField<String?>(
                      initialValue: _opponentArmyId,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      style: AppTextStyles.body,
                      decoration: _decoration(l10n.battleOpponentArmyLabel),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.battleArmyNone),
                        ),
                        ...armies
                            .where((army) => army.id != _armyId)
                            .map(
                              (army) => DropdownMenuItem<String?>(
                                value: army.id,
                                child: Text(
                                  army.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                      ],
                      onChanged: (value) =>
                          setState(() => _opponentArmyId = value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  factionsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (factions) => DropdownButtonFormField<String?>(
                      initialValue: _opponentFactionId,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      style: AppTextStyles.body,
                      decoration: _decoration(l10n.battleOpponentFactionLabel),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.battleArmyNone),
                        ),
                        ...factions.map(
                          (faction) => DropdownMenuItem<String?>(
                            value: faction.id,
                            child: Text(
                              faction.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _opponentFactionId = value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pointsLimitController,
                          keyboardType: TextInputType.number,
                          style: AppTextStyles.body,
                          decoration: _decoration(l10n.battlePointsLimitLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<BattleType>(
                          initialValue: _type,
                          isExpanded: true,
                          dropdownColor: AppColors.surface,
                          style: AppTextStyles.body,
                          decoration: _decoration(l10n.battleTypeLabel),
                          items: [
                            DropdownMenuItem(
                              value: BattleType.matched,
                              child: Text(l10n.battleTypeMatched),
                            ),
                            DropdownMenuItem(
                              value: BattleType.narrative,
                              child: Text(l10n.battleTypeNarrative),
                            ),
                            DropdownMenuItem(
                              value: BattleType.crusade,
                              child: Text(l10n.battleTypeCrusade),
                            ),
                            DropdownMenuItem(
                              value: BattleType.tournament,
                              child: Text(l10n.battleTypeTournament),
                            ),
                          ],
                          onChanged: (value) => setState(
                            () => _type = value ?? BattleType.matched,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _missionController,
                    style: AppTextStyles.body,
                    onSubmitted: (_) => _start(),
                    decoration: _decoration(l10n.battleMissionLabel),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _missionPackController,
                    style: AppTextStyles.body,
                    onSubmitted: (_) => _start(),
                    decoration: _decoration(l10n.battleMissionPackLabel),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _terrainController,
                    style: AppTextStyles.body,
                    onSubmitted: (_) => _start(),
                    decoration: _decoration(l10n.battleTerrainLabel),
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
                        onPressed: _start,
                        child: Text(l10n.battleSetupStart),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
