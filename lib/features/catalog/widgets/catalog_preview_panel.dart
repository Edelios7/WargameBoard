import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/faction_badge_icon.dart';
import '../../../database/models/cost_bracket.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../database/models/model_details.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../collection/widgets/add_collection_entry_dialog.dart';
import '../pages/datasheet_full_page.dart';

class CatalogPreviewPanel extends StatefulWidget {
  final DatasheetDetails? datasheet;
  final bool loading;

  const CatalogPreviewPanel({
    super.key,
    required this.datasheet,
    required this.loading,
  });

  @override
  State<CatalogPreviewPanel> createState() => _CatalogPreviewPanelState();
}

class _CatalogPreviewPanelState extends State<CatalogPreviewPanel> {
  bool _expandKeywords = false;

  @override
  void didUpdateWidget(covariant CatalogPreviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.datasheet?.id != widget.datasheet?.id) {
      _expandKeywords = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    final sheet = widget.datasheet;
    if (sheet == null) {
      return Center(
        child: Text(l10n.catalogSelectPrompt, style: AppTextStyles.caption),
      );
    }

    final imageFile = LocalCatalogImages.datasheet(sheet.id);
    final model = sheet.models.isNotEmpty ? sheet.models.first : null;
    final visibleKeywords = _expandKeywords
        ? sheet.keywords
        : sheet.keywords.take(4).toList();

    return Container(
      color: AppColors.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(sheet.name, style: AppTextStyles.title),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FactionBadgeIcon(
                            factionName: sheet.factionName,
                            factionId: sheet.factionId,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(sheet.factionName, style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
                _iconButton(
                  Icons.add_rounded,
                  tooltip: l10n.collectionAddEntry,
                  onTap: () => _addToCollection(context, sheet),
                ),
                _iconButton(
                  Icons.open_in_full_rounded,
                  tooltip: l10n.catalogViewFullSheet,
                  onTap: () => _openFullSheet(context, sheet.id),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: _costDisplay(l10n, sheet),
            ),
            const SizedBox(height: 16),
            if (imageFile != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  imageFile,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (model != null) ...[
              _statBoxRow(l10n, model),
              const SizedBox(height: 24),
            ],
            if (sheet.description != null && sheet.description!.isNotEmpty) ...[
              Text(
                l10n.sectionDescription.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 8),
              Text(sheet.description!, style: AppTextStyles.body),
              const SizedBox(height: 24),
            ],
            if (sheet.keywords.isNotEmpty) ...[
              Text(
                l10n.sectionKeywords.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ...visibleKeywords.map((k) => AppChip(label: k)),
                  if (sheet.keywords.length > 4)
                    GestureDetector(
                      onTap: () =>
                          setState(() => _expandKeywords = !_expandKeywords),
                      child: Text(
                        _expandKeywords
                            ? l10n.catalogSeeLess
                            : l10n.catalogSeeMore,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 28),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openFullSheet(context, sheet.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  l10n.catalogViewFullSheet.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFullSheet(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DatasheetFullPage(datasheetId: id)),
    );
  }

  void _addToCollection(BuildContext context, DatasheetDetails sheet) {
    showDialog(
      context: context,
      builder: (_) => AddCollectionEntryDialog(
        initialResult: SearchResult(
          id: sheet.id,
          name: sheet.name,
          type: 'datasheet',
          factionId: sheet.factionId,
          factionName: sheet.factionName,
          gameSystemId: sheet.gameSystemId,
          editionId: sheet.editionId,
          points: sheet.points,
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, {VoidCallback? onTap, String? tooltip}) {
    final button = Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap ?? () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }

  /// Affiche le coût de la fiche : un badge simple si elle n'a qu'un seul
  /// palier de coût, ou un badge par palier (voir DatasheetCosts.modelCount)
  /// quand le coût dépend du nombre de figurines choisi — beaucoup d'unités
  /// Warhammer 40k ne montent pas en coût de façon linéaire avec l'effectif.
  Widget _costDisplay(AppLocalizations l10n, DatasheetDetails sheet) {
    final sized = sheet.costBrackets.where((b) => b.modelCount != null).toList()
      ..sort((a, b) => a.modelCount!.compareTo(b.modelCount!));
    if (sized.length <= 1) {
      return _pointsBadge(l10n, sheet.points);
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.end,
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

  Widget _statBoxRow(AppLocalizations l10n, ModelDetails model) {
    final stats = <(String, String)>[
      (l10n.statMovement, '${model.movement}"'),
      (l10n.statToughness, '${model.toughness}'),
      (l10n.statSave, '${model.save}+'),
      (l10n.statWounds, '${model.wounds}'),
      (l10n.statLeadership, '${model.leadership}+'),
      (l10n.statObjectiveControl, '${model.objectiveControl}'),
    ];
    return Row(
      children: stats
          .map(
            (stat) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(stat.$2, style: AppTextStyles.title),
                      const SizedBox(height: 2),
                      Text(
                        stat.$1,
                        style: AppTextStyles.eyebrow,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
