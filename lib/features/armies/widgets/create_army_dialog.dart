import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/catalog_provider.dart';

class CreateArmyDialog extends ConsumerStatefulWidget {
  const CreateArmyDialog({super.key});

  @override
  ConsumerState<CreateArmyDialog> createState() => _CreateArmyDialogState();
}

class _CreateArmyDialogState extends ConsumerState<CreateArmyDialog> {
  final _nameController = TextEditingController();
  final _pointsLimitController = TextEditingController();
  String? _factionId;

  @override
  void dispose() {
    _nameController.dispose();
    _pointsLimitController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final factionId = _factionId;
    if (_nameController.text.trim().isEmpty || factionId == null) return;

    final armyId = await ref.read(armyRepositoryProvider).createArmy(
          name: _nameController.text.trim(),
          factionId: factionId,
          pointsLimit: int.tryParse(_pointsLimitController.text.trim()),
        );

    ref.invalidate(armiesListProvider);
    ref.read(selectedArmyIdProvider.notifier).state = armyId;

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final factionsAsync = ref.watch(factionsListProvider);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.armyBuilderNewArmy, style: AppTextStyles.title),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                autofocus: true,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: l10n.armyBuilderArmyName,
                  labelStyle: AppTextStyles.caption,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              factionsAsync.when(
                loading: () => const LinearProgressIndicator(
                  color: AppColors.primary,
                ),
                error: (error, _) => Text('$error', style: AppTextStyles.caption),
                data: (factions) {
                  _factionId ??= factions.isNotEmpty ? factions.first.id : null;
                  return DropdownButtonFormField<String>(
                    initialValue: _factionId,
                    dropdownColor: AppColors.surface,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      labelText: l10n.armyBuilderFaction,
                      labelStyle: AppTextStyles.caption,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: factions
                        .map(
                          (faction) => DropdownMenuItem(
                            value: faction.id,
                            child: Text(faction.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _factionId = value),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pointsLimitController,
                keyboardType: TextInputType.number,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  labelText: l10n.armyBuilderPointsLimitLabel,
                  labelStyle: AppTextStyles.caption,
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
                    onPressed: _create,
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
