import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../database/models/model_details.dart';
import '../../../l10n/app_localizations.dart';
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
    final visibleKeywords =
        _expandKeywords ? sheet.keywords : sheet.keywords.take(4).toList();

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
                      Text(sheet.factionName, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _iconButton(Icons.info_outline_rounded),
                    _iconButton(Icons.ios_share_rounded),
                    _iconButton(
                      Icons.open_in_full_rounded,
                      onTap: () => _openFullSheet(context, sheet.id),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: _pointsBadge(l10n, sheet.points),
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
              _statBoxRow(model),
              const SizedBox(height: 24),
            ],
            if (sheet.description != null &&
                sheet.description!.isNotEmpty) ...[
              Text(l10n.sectionDescription.toUpperCase(),
                  style: AppTextStyles.eyebrow),
              const SizedBox(height: 8),
              Text(sheet.description!, style: AppTextStyles.body),
              const SizedBox(height: 24),
            ],
            if (sheet.keywords.isNotEmpty) ...[
              Text(l10n.sectionKeywords.toUpperCase(),
                  style: AppTextStyles.eyebrow),
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
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
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

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    return Material(
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

  Widget _statBoxRow(ModelDetails model) {
    final stats = <(String, String)>[
      ('M', '${model.movement}"'),
      ('T', '${model.toughness}'),
      ('SV', '${model.save}+'),
      ('W', '${model.wounds}'),
      ('LD', '${model.leadership}+'),
      ('OC', '${model.objectiveControl}'),
    ];
    return Row(
      children: stats
          .map(
            (stat) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(stat.$2, style: AppTextStyles.title),
                      const SizedBox(height: 2),
                      Text(stat.$1, style: AppTextStyles.eyebrow),
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
