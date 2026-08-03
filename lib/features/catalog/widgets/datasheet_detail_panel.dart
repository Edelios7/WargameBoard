import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_loading_indicator.dart';
import '../../../core/widgets/archetype_badge.dart';
import '../../../core/widgets/unit_photo_thumbnail.dart';
import '../../../database/models/ability_details.dart';
import '../../../database/models/cost_bracket.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../domain/catalog/core_ability_glossary.dart';
import '../../../l10n/app_localizations.dart';

class DatasheetDetailPanel extends StatelessWidget {
  final DatasheetDetails? datasheet;
  final bool loading;

  /// Affiche le bouton "Ajouter à la collection" juste sous l'en-tête
  /// quand fourni — masqué par défaut (ex. `DatasheetFullPage`, où
  /// l'ajout n'a pas sa place) pour ne pas dupliquer cette action
  /// partout où ce panneau est réutilisé.
  final VoidCallback? onAddToCollection;

  const DatasheetDetailPanel({
    super.key,
    required this.datasheet,
    required this.loading,
    this.onAddToCollection,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const AppLoadingIndicator();
    }

    final sheet = datasheet;
    if (sheet == null) {
      return Center(
        child: Text(l10n.catalogSelectPrompt, style: AppTextStyles.caption),
      );
    }

    final imageFile = LocalCatalogImages.unitPhoto(sheet.id);
    final factionIcon = LocalCatalogImages.faction(sheet.factionId);
    final factionBanner = imageFile == null
        ? LocalCatalogImages.factionBanner(sheet.factionId)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _hero(sheet, imageFile, factionIcon, factionBanner, l10n),
          if (onAddToCollection != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onAddToCollection,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  l10n.collectionAddEntry,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
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
    dynamic factionBanner,
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
          Stack(
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
                )
              else if (factionBanner != null)
                // Pas de visuel propre à la fiche : la bannière de faction
                // habille l'en-tête à la place d'un bloc vide.
                Stack(
                  children: [
                    Image.file(
                      factionBanner,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.surfaceElevated.withValues(alpha: .35),
                              AppColors.surfaceElevated.withValues(alpha: .9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                // Ni photo perso ni bannière de faction : sans ce bloc
                // neutre, la zone d'image disparaissait entièrement (la
                // fiche passait directement au titre), ce qui rendait
                // le bouton d'ajout d'image ci-dessous encore plus dur
                // à situer.
                Container(
                  height: 140,
                  width: double.infinity,
                  color: AppColors.background,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shield_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withValues(alpha: .4),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: UnitPhotoEditButton(
                  datasheetId: sheet.id,
                  hasPhoto: imageFile != null,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sheet.name, style: AppTextStyles.heading),
                const SizedBox(height: 8),
                _costDisplay(l10n, sheet),
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
                    if (sheet.archetype != null) ...[
                      const SizedBox(width: 10),
                      ArchetypeChip(archetype: sheet.archetype!),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pointsBadge(AppLocalizations l10n, int? points) {
    if (points == null) {
      return Tooltip(
        message: l10n.unknownCostTooltip,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: .18),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.warning.withValues(alpha: .4)),
          ),
          child: Text(
            l10n.unknownCost,
            style: AppTextStyles.body.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
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

  /// Affiche le coût de la fiche : un badge simple si elle n'a qu'un seul
  /// palier de coût, ou un badge par palier (voir DatasheetCosts.modelCount)
  /// quand le coût dépend du nombre de figurines choisi.
  Widget _costDisplay(AppLocalizations l10n, DatasheetDetails sheet) {
    // Cette vue n'est pas rattachée à une armée, donc sans notion de
    // "combien j'en ai déjà" : uniquement le palier de base (voir
    // CostBracket.minCopyIndex), pas les paliers de surcoût à partir de
    // la Ne copie, qui ne feraient qu'afficher deux badges pour la même
    // taille de figurines.
    final sized =
        sheet.costBrackets
            .where((b) => b.modelCount != null && (b.minCopyIndex ?? 1) <= 1)
            .toList()
          ..sort((a, b) => a.modelCount!.compareTo(b.modelCount!));
    if (sized.length <= 1) {
      return _pointsBadge(l10n, sheet.points);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sized.map((bracket) => _bracketChip(l10n, bracket)).toList(),
    );
  }

  Widget _bracketChip(AppLocalizations l10n, CostBracket bracket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withValues(alpha: .35)),
      ),
      child: Text(
        l10n.catalogCostBracketLabel(bracket.modelCount!, bracket.points),
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
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
          Text(title.toUpperCase(), style: AppTextStyles.eyebrow),
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
                    Text(
                      model.name,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
        rows.add(
          TableRow(
            children: [
              _weaponCell(weapon.name, bold: true),
              _weaponCell(weapon.type, alignEnd: true),
              _weaponCell('—', alignEnd: true),
              _weaponCell('—', alignEnd: true),
              _weaponCell('—', alignEnd: true),
              _weaponCell('—', alignEnd: true),
            ],
          ),
        );
        continue;
      }
      for (var i = 0; i < weapon.profiles.length; i++) {
        final profile = weapon.profiles[i];
        final label = weapon.profiles.length > 1
            ? '${weapon.name} — ${profile.name}'
            : weapon.name;
        rows.add(
          TableRow(
            children: [
              _weaponCell(label, bold: true),
              _weaponCell(
                profile.isMelee ? l10n.weaponMelee : '${profile.range}"',
                alignEnd: true,
              ),
              _weaponCell(profile.attacks, alignEnd: true),
              _weaponCell('${profile.strength}', alignEnd: true),
              _weaponCell('${profile.armorPenetration}', alignEnd: true),
              _weaponCell(profile.damage, alignEnd: true),
            ],
          ),
        );
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
                        Tooltip(
                          message: l10n.catalogCoreAbilityTooltip,
                          child: AppChip(label: 'CORE', accent: true),
                        ),
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
                    Builder(
                      builder: (context) {
                        final generic = lookupCoreAbilityDescription(
                          ability.name,
                        );
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
                      },
                    ),
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
