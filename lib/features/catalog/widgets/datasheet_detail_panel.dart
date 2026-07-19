import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_datasheet_images.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../l10n/app_localizations.dart';

class DatasheetDetailPanel extends StatelessWidget {
  final DatasheetDetails? datasheet;
  final bool loading;

  const DatasheetDetailPanel({
    super.key,
    required this.datasheet,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final sheet = datasheet;
    if (sheet == null) {
      return Center(
        child: Text(
          l10n.catalogSelectPrompt,
          style: AppTextStyles.caption,
        ),
      );
    }

    final imageFile = LocalDatasheetImages.find(sheet.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageFile != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                imageFile,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Text(sheet.name, style: AppTextStyles.heading),
          const SizedBox(height: 6),
          Text(sheet.factionName, style: AppTextStyles.caption),
          const SizedBox(height: 20),
          _pointsBadge(l10n, sheet.points),
          const SizedBox(height: 28),
          _section(
            l10n.sectionUnitSize,
            Text(
              l10n.unitSizeRange(
                sheet.unit.minimumSize,
                sheet.unit.maximumSize,
                sheet.unit.defaultSize,
              ),
              style: AppTextStyles.body,
            ),
          ),
          _section(l10n.sectionProfiles, _modelsTable(sheet)),
          _section(l10n.sectionWeapons, _weaponsList(sheet)),
          if (sheet.keywords.isNotEmpty)
            _section(l10n.sectionKeywords, _chips(sheet.keywords)),
          if (sheet.abilities.isNotEmpty)
            _section(l10n.sectionAbilities, _bulletList(sheet.abilities)),
          if (sheet.equipment.isNotEmpty)
            _section(l10n.sectionEquipment, _equipmentList(sheet)),
        ],
      ),
    );
  }

  Widget _pointsBadge(AppLocalizations l10n, int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withOpacity(.4)),
      ),
      child: Text(
        l10n.pointsSuffix(points),
        style: AppTextStyles.body.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _section(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTextStyles.caption),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _modelsTable(DatasheetDetails sheet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sheet.models
          .map(
            (model) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${model.name} — M${model.movement}" T${model.toughness} '
                'Sv${model.save}+ W${model.wounds} LD${model.leadership}+ '
                'OC${model.objectiveControl}',
                style: AppTextStyles.body,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _weaponsList(DatasheetDetails sheet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sheet.weapons
          .map(
            (weapon) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${weapon.name} (${weapon.type})',
                style: AppTextStyles.body,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _equipmentList(DatasheetDetails sheet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sheet.equipment
          .map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                '${group.groupName}: ${group.options.join(', ')}',
                style: AppTextStyles.body,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _bulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $item', style: AppTextStyles.body),
            ),
          )
          .toList(),
    );
  }

  Widget _chips(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(item, style: AppTextStyles.caption),
            ),
          )
          .toList(),
    );
  }
}
