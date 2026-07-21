import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../database/models/ability_details.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../domain/catalog/core_ability_glossary.dart';
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

    final imageFile = LocalCatalogImages.datasheet(sheet.id);
    final factionIcon = LocalCatalogImages.faction(sheet.factionId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hero(sheet, imageFile, factionIcon, l10n),
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
          _section(l10n.sectionProfiles, _modelsStatBlocks(sheet, l10n)),
          _section(l10n.sectionWeapons, _weaponsList(l10n, sheet)),
          if (sheet.keywords.isNotEmpty)
            _section(l10n.sectionKeywords, _chips(sheet.keywords)),
          if (sheet.abilities.isNotEmpty)
            _section(
              l10n.sectionAbilities,
              _abilityCards(sheet.abilities, l10n),
            ),
          if (sheet.equipment.isNotEmpty)
            _section(l10n.sectionEquipment, _equipmentList(sheet)),
        ],
      ),
    );
  }

  Widget _hero(
    DatasheetDetails sheet,
    dynamic imageFile,
    dynamic factionIcon,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageFile != null)
            Stack(
              children: [
                Image.file(
                  imageFile,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.surfaceElevated.withValues(alpha: .95),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(sheet.name, style: AppTextStyles.heading),
                    ),
                    _pointsBadge(l10n, sheet.points),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (factionIcon != null) ...[
                      ClipOval(
                        child: Image.file(
                          factionIcon,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(sheet.factionName, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsBadge(AppLocalizations l10n, int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
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

  Widget _modelsStatBlocks(DatasheetDetails sheet, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sheet.models
          .map(
            (model) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sheet.models.length > 1) ...[
                    Text(model.name, style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 6),
                  ],
                  Row(
                    children: [
                      _statBox(l10n.statMovement, '${model.movement}"'),
                      _statBox(l10n.statToughness, '${model.toughness}'),
                      _statBox(l10n.statSave, '${model.save}+'),
                      _statBox(l10n.statWounds, '${model.wounds}'),
                      _statBox(l10n.statLeadership, '${model.leadership}+'),
                      _statBox(
                        l10n.statObjectiveControl,
                        '${model.objectiveControl}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _statBox(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.eyebrow,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _weaponsList(AppLocalizations l10n, DatasheetDetails sheet) {
    final rows = <TableRow>[
      TableRow(
        children: [
          _weaponHeaderCell(l10n.weaponColName),
          _weaponHeaderCell(l10n.weaponColRange, alignEnd: true),
          _weaponHeaderCell(l10n.weaponColAttacks, alignEnd: true),
          _weaponHeaderCell(l10n.weaponColStrength, alignEnd: true),
          _weaponHeaderCell(l10n.weaponColAp, alignEnd: true),
          _weaponHeaderCell(l10n.weaponColDamage, alignEnd: true),
        ],
      ),
    ];

    for (final weapon in sheet.weapons) {
      if (weapon.profiles.isEmpty) {
        rows.add(TableRow(children: [
          _weaponCell(weapon.name, bold: true),
          _weaponCell(weapon.type, alignEnd: true),
          _weaponCell('—', alignEnd: true),
          _weaponCell('—', alignEnd: true),
          _weaponCell('—', alignEnd: true),
          _weaponCell('—', alignEnd: true),
        ]));
        continue;
      }
      for (var i = 0; i < weapon.profiles.length; i++) {
        final profile = weapon.profiles[i];
        final label = weapon.profiles.length > 1
            ? '${weapon.name} — ${profile.name}'
            : weapon.name;
        rows.add(TableRow(children: [
          _weaponCell(label, bold: true),
          _weaponCell(
            profile.isMelee ? l10n.weaponMelee : '${profile.range}"',
            alignEnd: true,
          ),
          _weaponCell(profile.attacks, alignEnd: true),
          _weaponCell('${profile.strength}', alignEnd: true),
          _weaponCell('${profile.armorPenetration}', alignEnd: true),
          _weaponCell(profile.damage, alignEnd: true),
        ]));
      }
    }

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(0.7),
        3: FlexColumnWidth(0.7),
        4: FlexColumnWidth(0.7),
        5: FlexColumnWidth(0.7),
      },
      border: TableBorder(
        horizontalInside: BorderSide(color: AppColors.border),
      ),
      children: rows,
    );
  }

  Widget _weaponHeaderCell(String label, {bool alignEnd = false}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          label,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.eyebrow,
        ),
      ),
    );
  }

  Widget _weaponCell(String value, {bool bold = false, bool alignEnd = false}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Text(
          value,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
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

  Widget _abilityCards(List<AbilityDetails> items, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (ability) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ability.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (ability.isCore) ...[
                        const SizedBox(width: 8),
                        AppChip(label: 'CORE', accent: true),
                      ] else if (ability.type != null) ...[
                        const SizedBox(width: 8),
                        AppChip(label: ability.type!.toUpperCase()),
                      ],
                    ],
                  ),
                  if (ability.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(ability.description, style: AppTextStyles.caption),
                  ] else ...[
                    const SizedBox(height: 6),
                    Builder(builder: (context) {
                      final generic =
                          lookupCoreAbilityDescription(ability.name);
                      if (generic != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppChip(label: l10n.abilityGenericRuleTag),
                            const SizedBox(height: 6),
                            Text(generic, style: AppTextStyles.caption),
                          ],
                        );
                      }
                      return Text(
                        l10n.abilityNoTextAvailable,
                        style: AppTextStyles.caption.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _chips(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) => AppChip(label: item)).toList(),
    );
  }
}
