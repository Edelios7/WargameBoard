import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/faction_colors.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../database/app_database.dart' show Faction, Keyword;
import '../../../database/models/catalog_sort.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../widgets/catalog_preview_panel.dart';
import 'datasheet_full_page.dart';
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
    final hasActiveFilters =
        factionFilter != null ||
        keywordFilter.isNotEmpty ||
        roleFilter != null ||
        unitTypeFilter != null ||
        editionFilter != null ||
        pointsRange != null;

    final headerBannerFile = factionFilter != null
        ? LocalCatalogImages.factionBanner(factionFilter)
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: headerBannerFile != null
                ? BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(headerBannerFile),
                      fit: BoxFit.cover,
                    ),
                  )
                : null,
            child: Container(
              decoration: headerBannerFile != null
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.background.withValues(alpha: .9),
                          AppColors.background.withValues(alpha: .6),
                        ],
                      ),
                    )
                  : null,
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.navCatalog.toUpperCase(),
                          style: AppTextStyles.heading,
                        ),
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
          ),
          const _FactionQuickAccessBar(),
          const SizedBox(height: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // En dessous de ce seuil, trois colonnes fixes ne laissent
                // plus de place à rien — on repasse à un flux liste puis
                // détail en plein écran (patron mobile), filtres derrière
                // un bouton plutôt qu'une colonne toujours visible.
                if (constraints.maxWidth < 900) {
                  return _NarrowCatalogLayout(
                    resultsAsync: resultsAsync,
                    hasActiveFilters: hasActiveFilters,
                  );
                }

                final filtersWidth = constraints.maxWidth < 1100 ? 200.0 : 232.0;
                final resultsWidth = constraints.maxWidth < 1100 ? 260.0 : 320.0;
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
                        onSelect: (id) =>
                            ref
                                    .read(selectedDatasheetIdProvider.notifier)
                                    .state =
                                id,
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

/// Liste seule (recherche + filtres derrière un bouton) sur petit écran ;
/// toucher un résultat ouvre sa fiche en plein écran plutôt que dans un
/// panneau latéral qui n'aurait pas la place de s'afficher.
class _NarrowCatalogLayout extends ConsumerWidget {
  final AsyncValue<List<SearchResult>> resultsAsync;
  final bool hasActiveFilters;

  const _NarrowCatalogLayout({
    required this.resultsAsync,
    required this.hasActiveFilters,
  });

  void _openFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final results = ref.watch(catalogSearchResultsProvider);
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: _FiltersPanel(
              hasActiveFilters: hasActiveFilters,
              resultsCount: results.value?.length,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: _SearchField(
                  hintText: l10n.catalogSearchHint,
                  onChanged: (value) => ref
                      .read(catalogSearchQueryProvider.notifier)
                      .state = value,
                ),
              ),
              const SizedBox(width: 8),
              Tooltip(
                message: l10n.catalogFilterTitle,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: hasActiveFilters
                        ? AppColors.primary.withValues(alpha: .16)
                        : AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onPressed: () => _openFilters(context),
                  icon: Icon(
                    Icons.tune_rounded,
                    color: hasActiveFilters
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _ResultsList(
            resultsAsync: resultsAsync,
            selectedId: null,
            onSelect: (id) {
              ref.read(selectedDatasheetIdProvider.notifier).state = id;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DatasheetFullPage(datasheetId: id),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FactionQuickAccessBar extends ConsumerWidget {
  const _FactionQuickAccessBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final factionsAsync = ref.watch(factionsListProvider);
    final selectedFactionId = ref.watch(catalogFactionFilterProvider);

    return factionsAsync.when(
      loading: () => const SizedBox(height: 100),
      error: (_, __) => const SizedBox.shrink(),
      data: (factions) {
        if (factions.isEmpty) return const SizedBox.shrink();
        final sorted = [...factions]..sort((a, b) => a.name.compareTo(b.name));
        return Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.catalogQuickAccessFactions.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: sorted.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _AllFactionsTile(
                        label: l10n.catalogAllFactionsChip,
                        selected: selectedFactionId == null,
                        onTap: () =>
                            ref
                                    .read(catalogFactionFilterProvider.notifier)
                                    .state =
                                null,
                      );
                    }
                    final faction = sorted[index - 1];
                    final selected = faction.id == selectedFactionId;
                    return _FactionTile(
                      faction: faction,
                      selected: selected,
                      onTap: () =>
                          ref
                              .read(catalogFactionFilterProvider.notifier)
                              .state = selected
                          ? null
                          : faction.id,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Tuile "Toutes" en tête de la barre d'accès rapide aux factions —
/// avant, il fallait deviner qu'on pouvait retaper la faction déjà
/// sélectionnée pour retirer le filtre ; là c'est un état explicite.
class _AllFactionsTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AllFactionsTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: .16)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.apps_rounded,
                  size: 18,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10.5,
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FactionTile extends StatelessWidget {
  final Faction faction;
  final bool selected;
  final VoidCallback onTap;

  const _FactionTile({
    required this.faction,
    required this.selected,
    required this.onTap,
  });

  String get _initials {
    if (faction.shortName != null && faction.shortName!.isNotEmpty) {
      return faction.shortName!.substring(
        0,
        faction.shortName!.length.clamp(0, 3),
      );
    }
    final words = faction.name
        .split(RegExp(r'[\s\-\(\)]+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 2).toUpperCase();
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = FactionColors.of(faction.id);
    final iconFile = LocalCatalogImages.faction(faction.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: selected
                ? color.withValues(alpha: .16)
                : AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: iconFile != null
                    ? Image.file(iconFile, fit: BoxFit.cover)
                    : Center(
                        child: Text(
                          _initials,
                          style: AppTextStyles.caption.copyWith(
                            color: FactionColors.onColor(color),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                faction.name,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10.5,
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
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
              Flexible(
                child: Text(
                  l10n.catalogFilterTitle.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasActiveFilters)
                InkWell(
                  onTap: () {
                    ref.read(catalogFactionFilterProvider.notifier).state =
                        null;
                    ref.read(catalogKeywordFilterProvider.notifier).state = {};
                    ref.read(catalogRoleFilterProvider.notifier).state = null;
                    ref.read(catalogUnitTypeFilterProvider.notifier).state =
                        null;
                    ref.read(catalogEditionFilterProvider.notifier).state =
                        null;
                    ref.read(catalogPointsRangeProvider.notifier).state = null;
                  },
                  child: Text(
                    l10n.catalogResetFilters,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
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
                  ref.read(catalogFactionFilterProvider.notifier).state = value,
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
            data: (keywords) => _KeywordMultiSelect(
              keywords: keywords,
              selected: keywordFilter,
              onChanged: (value) =>
                  ref.read(catalogKeywordFilterProvider.notifier).state = value,
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
                      onChanged: (values) =>
                          ref.read(catalogPointsRangeProvider.notifier).state =
                              values,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${range.start.round()}',
                        style: AppTextStyles.caption,
                      ),
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
                  ref.read(catalogEditionFilterProvider.notifier).state = value,
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
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
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
    final ownedQuantities = ref.watch(catalogOwnedQuantitiesProvider);
    final favoritesOnly = ref.watch(catalogFavoritesOnlyProvider);
    final favoriteIds = ref.watch(catalogFavoritesProvider).value ?? const {};

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
      data: (allResults) {
        final results = favoritesOnly
            ? allResults.where((r) => favoriteIds.contains(r.id)).toList()
            : allResults;
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
                  const SizedBox(width: 4),
                  Tooltip(
                    message: favoritesOnly
                        ? l10n.catalogFavoritesOnlyOff
                        : l10n.catalogFavoritesOnlyOn,
                    child: IconButton(
                      icon: Icon(
                        favoritesOnly
                            ? Icons.filter_alt_rounded
                            : Icons.filter_alt_outlined,
                        size: 20,
                      ),
                      color: favoritesOnly
                          ? AppColors.warning
                          : AppColors.textSecondary,
                      onPressed: () => ref
                          .read(catalogFavoritesOnlyProvider.notifier)
                          .state = !favoritesOnly,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: _SortDropdown(
                      value: sortBy,
                      onChanged: (value) =>
                          ref.read(catalogSortProvider.notifier).state = value,
                    ),
                  ),
                ],
              ),
            ),
            const _ActiveFiltersRow(),
            if (results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 36,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.catalogEmptyResults,
                        style: AppTextStyles.caption,
                      ),
                    ],
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
                      ownedQuantity: ownedQuantities[result.id] ?? 0,
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

/// Résumé des filtres actifs sous forme de chips retirables, pour ne pas
/// avoir à rouvrir chaque menu déroulant du panneau de filtres pour
/// savoir ce qui est actif ou pour l'enlever.
class _ActiveFiltersRow extends ConsumerWidget {
  const _ActiveFiltersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final factionFilter = ref.watch(catalogFactionFilterProvider);
    final keywordFilter = ref.watch(catalogKeywordFilterProvider);
    final roleFilter = ref.watch(catalogRoleFilterProvider);
    final unitTypeFilter = ref.watch(catalogUnitTypeFilterProvider);
    final editionFilter = ref.watch(catalogEditionFilterProvider);
    final pointsRange = ref.watch(catalogPointsRangeProvider);

    final factions = ref.watch(factionsListProvider).value ?? const [];
    final keywords = ref.watch(keywordsListProvider).value ?? const [];
    final editions = ref.watch(editionsListProvider).value ?? const [];

    final chips = <Widget>[];

    if (factionFilter != null) {
      final name = factions
          .where((f) => f.id == factionFilter)
          .map((f) => f.name)
          .firstOrNull;
      chips.add(
        _activeFilterChip(
          name ?? factionFilter,
          () => ref.read(catalogFactionFilterProvider.notifier).state = null,
        ),
      );
    }
    for (final keywordId in keywordFilter) {
      final name = keywords
          .where((k) => k.id == keywordId)
          .map((k) => k.name)
          .firstOrNull;
      chips.add(
        _activeFilterChip(
          name ?? keywordId,
          () => ref.read(catalogKeywordFilterProvider.notifier).state = {
            ...keywordFilter,
          }..remove(keywordId),
        ),
      );
    }
    if (roleFilter != null) {
      chips.add(
        _activeFilterChip(
          roleFilter,
          () => ref.read(catalogRoleFilterProvider.notifier).state = null,
        ),
      );
    }
    if (unitTypeFilter != null) {
      chips.add(
        _activeFilterChip(
          unitTypeFilter,
          () => ref.read(catalogUnitTypeFilterProvider.notifier).state = null,
        ),
      );
    }
    if (editionFilter != null) {
      final name = editions
          .where((e) => e.id == editionFilter)
          .map((e) => e.name)
          .firstOrNull;
      chips.add(
        _activeFilterChip(
          name ?? editionFilter,
          () => ref.read(catalogEditionFilterProvider.notifier).state = null,
        ),
      );
    }
    if (pointsRange != null) {
      chips.add(
        _activeFilterChip(
          '${pointsRange.start.round()}-${pointsRange.end.round()} pts',
          () => ref.read(catalogPointsRangeProvider.notifier).state = null,
        ),
      );
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Wrap(spacing: 6, runSpacing: 6, children: chips),
    );
  }

  Widget _activeFilterChip(String label, VoidCallback onRemove) {
    return AppChip(label: label, accent: true, onDeleted: onRemove);
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
              child: Text(labels[sort]!, style: AppTextStyles.caption),
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
          const Icon(
            Icons.expand_more_rounded,
            size: 16,
            color: AppColors.textSecondary,
          ),
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

/// Filtre "mots-clés" à choix multiples : contrairement aux autres
/// filtres (faction, rôle...), une fiche porte souvent plusieurs
/// mots-clés utiles à combiner (ex. Infantry + Character), donc un
/// simple menu déroulant mono-sélection était trop limitant.
class _KeywordMultiSelect extends StatelessWidget {
  final List<Keyword> keywords;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  const _KeywordMultiSelect({
    required this.keywords,
    required this.selected,
    required this.onChanged,
  });

  Future<void> _openPicker(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final chosen = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) => _KeywordPickerSheet(
        keywords: keywords,
        initiallySelected: selected,
        l10n: l10n,
      ),
    );
    if (chosen != null) onChanged(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedKeywords = keywords.where((k) => selected.contains(k.id));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selected.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedKeywords
                .map(
                  (keyword) => AppChip(
                    label: keyword.name,
                    accent: true,
                    onDeleted: () =>
                        onChanged({...selected}..remove(keyword.id)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton.icon(
          onPressed: () => _openPicker(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            l10n.catalogAddKeywordFilter,
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}

class _KeywordPickerSheet extends StatefulWidget {
  final List<Keyword> keywords;
  final Set<String> initiallySelected;
  final AppLocalizations l10n;

  const _KeywordPickerSheet({
    required this.keywords,
    required this.initiallySelected,
    required this.l10n,
  });

  @override
  State<_KeywordPickerSheet> createState() => _KeywordPickerSheetState();
}

class _KeywordPickerSheetState extends State<_KeywordPickerSheet> {
  final Set<String> _selected = {};
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.initiallySelected);
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...widget.keywords]
      ..sort((a, b) => a.name.compareTo(b.name));
    final filtered = _query.isEmpty
        ? sorted
        : sorted
              .where((k) => k.name.toLowerCase().contains(_query.toLowerCase()))
              .toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.l10n.catalogFilterKeywords.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 12),
              _SearchField(
                hintText: widget.l10n.catalogKeywordSearchHint,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final keyword = filtered[index];
                    final checked = _selected.contains(keyword.id);
                    return CheckboxListTile(
                      value: checked,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.primary,
                      title: Text(keyword.name, style: AppTextStyles.body),
                      onChanged: (value) => setState(() {
                        if (value ?? false) {
                          _selected.add(keyword.id);
                        } else {
                          _selected.remove(keyword.id);
                        }
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(widget.l10n.catalogApplyFilters),
                ),
              ),
            ],
          ),
        ),
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

class _DatasheetListItem extends ConsumerWidget {
  final SearchResult result;
  final bool selected;
  final int ownedQuantity;
  final VoidCallback onTap;

  const _DatasheetListItem({
    required this.result,
    required this.selected,
    required this.onTap,
    this.ownedQuantity = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final imageFile = LocalCatalogImages.unitPhoto(result.id);
    final favoriteIds = ref.watch(catalogFavoritesProvider).value ?? const {};
    final isFavorite = favoriteIds.contains(result.id);
    final factionColor = result.factionId != null
        ? FactionColors.of(result.factionId!)
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? AppColors.primary.withValues(alpha: .10)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.4 : 1,
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: factionColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
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
                                    color: factionColor.withValues(alpha: .16),
                                    child: Icon(
                                      Icons.shield_outlined,
                                      color: factionColor,
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
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: factionColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          result.factionName!,
                                          style: AppTextStyles.caption,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    if (ownedQuantity > 0)
                                      _OwnedBadge(quantity: ownedQuantity),
                                    if (result.unitType != null)
                                      AppChip(label: result.unitType!),
                                    if (result.subtitle != null)
                                      AppChip(
                                        label: result.subtitle!,
                                        accent: selected,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Tooltip(
                                message: isFavorite
                                    ? l10n.catalogRemoveFavoriteTooltip
                                    : l10n.catalogAddFavoriteTooltip,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () async {
                                    await ref
                                        .read(catalogRepositoryProvider)
                                        .toggleFavorite(result.id);
                                    ref.invalidate(catalogFavoritesProvider);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Icon(
                                      isFavorite
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 18,
                                      color: isFavorite
                                          ? AppColors.warning
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              if (result.points != null) ...[
                                const SizedBox(height: 2),
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
                        ],
                      ),
                    ),
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

/// Badge "possédé ×N" affiché sur les fiches déjà présentes dans la
/// Collection de l'utilisateur, pour relier visuellement le Catalogue
/// (ce qu'on peut jouer) à ce qu'on possède réellement.
class _OwnedBadge extends StatelessWidget {
  final int quantity;

  const _OwnedBadge({required this.quantity});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.success.withValues(alpha: .4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 11, color: AppColors.success),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              l10n.catalogOwnedBadge(quantity),
              style: AppTextStyles.eyebrow.copyWith(color: AppColors.success),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
