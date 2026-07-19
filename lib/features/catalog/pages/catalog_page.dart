import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../widgets/datasheet_detail_panel.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync = ref.watch(catalogSearchResultsProvider);
    final detailAsync = ref.watch(selectedDatasheetProvider);
    final selectedId = ref.watch(selectedDatasheetIdProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: Text(l10n.navCatalog, style: AppTextStyles.heading),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SearchField(
                    hintText: l10n.catalogSearchHint,
                    onChanged: (value) => ref
                        .read(catalogSearchQueryProvider.notifier)
                        .state = value,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: resultsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          l10n.catalogLoadError(error.toString()),
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ),
                    data: (results) {
                      if (results.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.catalogEmptyResults,
                            style: AppTextStyles.caption,
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final result = results[index];
                          return _DatasheetListItem(
                            result: result,
                            selected: result.id == selectedId,
                            onTap: () => ref
                                .read(selectedDatasheetIdProvider.notifier)
                                .state = result.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, color: AppColors.border),
          Expanded(
            child: DatasheetDetailPanel(
              datasheet: detailAsync.value,
              loading: detailAsync.isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.caption,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _DatasheetListItem extends StatelessWidget {
  final SearchResult result;
  final bool selected;
  final VoidCallback onTap;

  const _DatasheetListItem({
    required this.result,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: .16)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.name, style: AppTextStyles.body),
                if (result.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(result.subtitle!, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
