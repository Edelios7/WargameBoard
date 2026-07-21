import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../database/models/catalog_sort.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../widgets/catalog_preview_panel.dart';
import 'weapons_inventory_page.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync = ref.watch(catalogSearchResultsProvider);
    final detailAsync = ref.watch(selectedDatasheetProvider);
    final selectedId = ref.watch(selectedDatasheetIdProvider);

    final factionFilter = ref.watch(catalogFactionFilterProvider);
    final keywordFilter = ref.watch(catalogKeywordFilterProvider);
    final roleFilter = ref.watch(catalogRoleFilterProvider);
    final unitTypeFilter = ref.watch(catalogUnitTypeFilterProvider);
    final editionFilter = ref.watch(catalogEditionFilterProvider);
    final pointsRange = ref.watch(catalogPointsRangeProvider);
    final hasActiveFilters = factionFilter != null ||
        keywordFilter != null ||
        roleFilter != null ||
        unitTypeFilter != null ||
        editionFilter != null ||
        pointsRange != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.navCatalog.toUpperCase(),
                          style: AppTextStyles.heading),
                      const SizedBox(height: 4),
                      Text(
                        l10n.catalogBreadcrumbAllUnits,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WeaponsInventoryPage(),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  icon: const Icon(Icons.hardware_rounded, size: 18),
                  label: Text(l10n.catalogWeaponsButton),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final filtersWidth =
                    constraints.maxWidth < 700 ? 200.0 : 232.0;
                final resultsWidth =
                    constraints.maxWidth < 700 ? 260.0 : 320.0;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: filtersWidth,
                      child: _FiltersPanel(
                        hasActiveFilters: hasActiveFilters,
                        resultsCount: resultsAsync.value?.length,
                      ),
                    ),
                    Container(width: 1, color: AppColors.border),
                    SizedBox(
                      width: resultsWidth,
                      child: _ResultsList(
                        resultsAsync: resultsAsync,
                        selectedId: selectedId,
                        onSelect: (id) => ref
                            .read(selectedDatasheetIdProvider.notifier)
                            .state = id,
                      ),
                    ),
                    Container(width: 1, color: AppColors.border),
                    Expanded(
                      child: CatalogPreviewPanel(
                        datasheet: detailAsync.value,
                        loading: detailAsync.isLoading,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersPanel extends ConsumerWidget {
  final bool hasActiveFilters;
  final int? resultsCount;

  const _FiltersPanel({
    required this.hasActiveFilters,
    required this.resultsCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final factionsAsync = ref.watch(factionsListProvider);
    final rolesAsync = ref.watch(rolesListProvider);
    final keywordsAsync = ref.watch(keywordsListProvider);
    final unitTypesAsync = ref.watch(unitTypesListProvider);
    final editionsAsync = ref.watch(editionsListProvider);
    final maxPointsAsync = ref.watch(catalogMaxPointsProvider);

    final factionFilter = ref.watch(catalogFactionFilterProvider);
    final roleFilter = ref.watch(catalogRoleFilterProvider);
    final keywordFilter = ref.watch(catalogKeywordFilterProvider);
    final unitTypeFilter = ref.watch(catalogUnitTypeFilterProvider);
    final editionFilter = ref.watch(catalogEditionFilterProvider);
    final pointsRange = ref.watch(catalogPointsRangeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.catalogFilterTitle.toUpperCase(),
                  style: AppTextStyles.eyebrow),
              if (hasActiveFilters)
                InkWell(
                  onTap: () {
                    ref.read(catalogFactionFilterProvider.notifier).state =
                        null;
                    ref.read(catalogKeywordFilterProvider.notifier).state =
                        null;
                    ref.read(catalogRoleFilterProvider.notifier).state = null;
                    ref.read(catalogUnitTypeFilterProvider.notifier).state =
                        null;
                    ref.read(catalogEditionFilterProvider.notifier).state =
                        null;
                    ref.read(catalogPointsRangeProvider.notifier).state =
                        null;
                  },
                  child: Text(
                    l10n.catalogResetFilters,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _SearchField(
            hintText: l10n.catalogSearchHint,
            onChanged: (value) =>
                ref.read(catalogSearchQueryProvider.notifier).state = value,
          ),
          const SizedBox(height: 18),
          _FilterLabel(l10n.catalogFilterFaction),
          factionsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (factions) => _FilterDropdown(
              value: factionFilter,
              allLabel: l10n.catalogFilterAllFactions,
              items: {for (final f in factions) f.id: f.name},
              onChanged: (value) =>
                  ref.read(catalogFactionFilterProvider.notifier).state =
                      value,
            ),
          ),
          const SizedBox(height: 14),
          _FilterLabel(l10n.catalogFilterRole),
          rolesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (roles) => _FilterDropdown(
              value: roleFilter,
              allLabel: l10n.catalogFilterAllRoles,
              items: {for (final r in roles) r: r},
              onChanged: (value) =>
                  ref.read(catalogRoleFilterProvider.notifier).state = value,
            ),
          ),
          const SizedBox(height: 14),
          _FilterLabel(l10n.catalogFilterKeywords),
          keywordsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (keywords) => _FilterDropdown(
              value: keywordFilter,
              allLabel: l10n.catalogFilterAllKeywords,
              items: {for (final k in keywords) k.id: k.name},
              onChanged: (value) =>
                  ref.read(catalogKeywordFilterProvider.notifier).state =
                      value,
            ),
          ),
          const SizedBox(height: 14),
          _FilterLabel(l10n.catalogFilterCost),
          maxPointsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (maxPoints) {
              final bound = maxPoints > 0 ? maxPoints.toDouble() : 500.0;
              final range = pointsRange ?? RangeValues(0, bound);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: .15),
                    ),
                    child: RangeSlider(
                      min: 0,
                      max: bound,
                      values: RangeValues(
                        range.start.clamp(0, bound),
                        range.end.clamp(0, bound),
                      ),
                      onChanged: (values) => ref
                          .read(catalogPointsRangeProvider.notifier)
                          .state = values,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${range.start.round()}',
                          style: AppTextStyles.caption),
                      Text(
                        range.end.round() >= bound.round()
                            ? '${bound.round()}+'
                            : '${range.end.round()}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          _FilterLabel(l10n.catalogFilterEdition),
          editionsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (editions) => _FilterDropdown(
              value: editionFilter,
              allLabel: l10n.catalogFilterAllEditions,
              items: {for (final e in editions) e.id: e.name},
              onChanged: (value) =>
                  ref.read(catalogEditionFilterProvider.notifier).state =
                      value,
            ),
          ),
          const SizedBox(height: 14),
          _FilterLabel(l10n.catalogFilterUnitType),
          unitTypesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (types) => _FilterDropdown(
              value: unitTypeFilter,
              allLabel: l10n.catalogFilterAllUnitTypes,
              items: {for (final t in types) t: t},
              onChanged: (value) =>
                  ref.read(catalogUnitTypeFilterProvider.notifier).state =
                      value,
            ),
          ),
          if (resultsCount != null) ...[
            const SizedBox(height: 20),
            Text(
              l10n.catalogResultsCount(resultsCount!),
              style: AppTextStyles.caption,
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsList extends ConsumerWidget {
  final AsyncValue<List<SearchResult>> resultsAsync;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _ResultsList({
    required this.resultsAsync,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sortBy = ref.watch(catalogSortProvider);

    return resultsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.catalogUnitsCount(results.length),
                      style: AppTextStyles.eyebrow,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: _SortDropdown(
                      value: sortBy,
                      onChanged: (value) => ref
                          .read(catalogSortProvider.notifier)
                          .state = value,
                    ),
                  ),
                ],
              ),
            ),
            if (results.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    l10n.catalogEmptyResults,
                    style: AppTextStyles.caption,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return _DatasheetListItem(
                      result: result,
                      selected: result.id == selectedId,
                      onTap: () => onSelect(result.id),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SortDropdown extends StatelessWidget {
  final CatalogSort value;
  final ValueChanged<CatalogSort> onChanged;

  const _SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      CatalogSort.nameAsc: l10n.catalogSortNameAsc,
      CatalogSort.pointsAsc: l10n.catalogSortPointsAsc,
      CatalogSort.pointsDesc: l10n.catalogSortPointsDesc,
    };
    return PopupMenuButton<CatalogSort>(
      initialValue: value,
      color: AppColors.surfaceElevated,
      onSelected: onChanged,
      itemBuilder: (context) => CatalogSort.values
          .map(
            (sort) => PopupMenuItem(
              value: sort,
              child:
                  Text(labels[sort]!, style: AppTextStyles.caption),
            ),
          )
          .toList(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '${l10n.catalogSortLabel} ${labels[value]}',
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.expand_more_rounded,
              size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _FilterLabel extends StatelessWidget {
  final String label;

  const _FilterLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label.toUpperCase(), style: AppTextStyles.eyebrow),
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

class _FilterDropdown extends StatelessWidget {
  final String? value;
  final String allLabel;
  final Map<String, String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.value,
    required this.allLabel,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          isExpanded: true,
          value: items.containsKey(value) ? value : null,
          dropdownColor: AppColors.surface,
          style: AppTextStyles.caption,
          icon: const Icon(
            Icons.expand_more_rounded,
            color: AppColors.textSecondary,
            size: 18,
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(allLabel, overflow: TextOverflow.ellipsis),
            ),
            ...items.entries.map(
              (entry) => DropdownMenuItem<String?>(
                value: entry.key,
                child: Text(entry.value, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: onChanged,
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
    final l10n = AppLocalizations.of(context)!;
    final imageFile = LocalCatalogImages.datasheet(result.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: .10)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageFile != null
                      ? Image.file(
                          imageFile,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 52,
                          height: 52,
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.shield_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.name,
                        style: AppTextStyles.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (result.factionName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          result.factionName!,
                          style: AppTextStyles.caption,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (result.unitType != null)
                            AppChip(label: result.unitType!),
                          if (result.subtitle != null)
                            AppChip(label: result.subtitle!, accent: selected),
                        ],
                      ),
                    ],
                  ),
                ),
                if (result.points != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    l10n.pointsSuffix(result.points!),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
