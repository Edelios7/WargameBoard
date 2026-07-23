import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/collection_export_formatter.dart';
import '../../../core/utils/faction_iconography.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../core/widgets/unit_photo_thumbnail.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/faction_badge_icon.dart';
import '../../catalog/pages/datasheet_full_page.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../domain/catalog/factions/space_marine_chapters.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/xp_provider.dart';
import '../widgets/add_collection_entry_dialog.dart';

enum _PaintState { unbuilt, assembled, primed, painted }

enum _CollectionSort { nameAsc, dateAddedDesc, paintedPctDesc }

int _stateCount(CollectionItemDetails entry, _PaintState state) {
  switch (state) {
    case _PaintState.unbuilt:
      return (entry.quantity - entry.assembled).clamp(0, entry.quantity);
    case _PaintState.assembled:
      return (entry.assembled - entry.primed).clamp(0, entry.quantity);
    case _PaintState.primed:
      return (entry.primed - entry.painted).clamp(0, entry.quantity);
    case _PaintState.painted:
      return entry.painted;
  }
}

/// Clé sentinelle utilisée par le filtre de faction pour désigner le
/// groupe "Space Marines" (qui regroupe les chapitres/sous-factions),
/// plutôt qu'une faction unique portant ce nom exact. Le regroupement
/// lui-même (chapitres + faction générique) vit dans
/// domain/catalog/factions/space_marine_chapters.dart, partagé avec le
/// filtre d'ajout d'unité de l'army builder.
const _spaceMarinesGroupKey = '__space_marines_group__';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _filtersVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWishlistTab = _tabController.index == 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 760;
                final title = Text(
                  l10n.navCollection,
                  style: AppTextStyles.heading,
                );
                final controls = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (wide)
                      SizedBox(
                        width: 260,
                        child: TextField(
                          controller: _searchController,
                          style: AppTextStyles.body,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: l10n.collectionSearchHint,
                            hintStyle: AppTextStyles.caption,
                            filled: true,
                            fillColor: AppColors.surface,
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                          ),
                        ),
                      ),
                    if (wide) const SizedBox(width: 10),
                    IconButton(
                      tooltip: l10n.catalogFilterTitle,
                      style: IconButton.styleFrom(
                        backgroundColor: _filtersVisible
                            ? AppColors.primary.withValues(alpha: .16)
                            : AppColors.surface,
                        side: BorderSide(color: AppColors.border),
                      ),
                      onPressed: () =>
                          setState(() => _filtersVisible = !_filtersVisible),
                      icon: Icon(
                        Icons.tune_rounded,
                        color: _filtersVisible
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AddCollectionEntryDialog(
                            wishlist: isWishlistTab,
                          ),
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          isWishlistTab
                              ? l10n.wishlistAddItem
                              : l10n.collectionAddEntry,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                );

                if (!wide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [title, const SizedBox(height: 12), controls],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [title, controls],
                );
              },
            ),
            const DecorSeparator(
              style: DecorSeparatorStyle.horizontal,
              maxWidth: 320,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: l10n.collectionTabOwned),
                Tab(text: l10n.collectionTabWishlist),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CollectionTab(
                    searchQuery: _searchQuery,
                    filtersVisible: _filtersVisible,
                  ),
                  const _WishlistTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _copyExport(BuildContext context, AppLocalizations l10n, String text) {
  Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.collectionExportedToClipboard)));
}

class _CollectionTab extends ConsumerStatefulWidget {
  final String searchQuery;
  final bool filtersVisible;

  const _CollectionTab({
    required this.searchQuery,
    required this.filtersVisible,
  });

  @override
  ConsumerState<_CollectionTab> createState() => _CollectionTabState();
}

class _CollectionTabState extends ConsumerState<_CollectionTab> {
  String? _factionFilter;
  String? _chapterFilter;
  final Set<_PaintState> _stateFilter = {};
  _CollectionSort _sort = _CollectionSort.nameAsc;
  bool _selectionMode = false;
  final Set<String> _selectedIds = {};

  void _setFactionFilter(String? value) {
    setState(() {
      _factionFilter = value;
      if (value != _spaceMarinesGroupKey) {
        _chapterFilter = null;
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _selectionMode = !_selectionMode;
      _selectedIds.clear();
    });
  }

  void _toggleSelected(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _markSelectedPainted(List<CollectionItemDetails> entries) async {
    final repository = ref.read(collectionRepositoryProvider);
    final selected = entries.where((e) => _selectedIds.contains(e.id));
    await Future.wait([
      for (final entry in selected)
        repository.updateCounts(
          entry.id,
          assembled: entry.quantity,
          primed: entry.quantity,
          painted: entry.quantity,
        ),
    ]);
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
    ref.invalidate(xpSummaryProvider);
    if (mounted) {
      setState(() {
        _selectionMode = false;
        _selectedIds.clear();
      });
    }
  }

  List<CollectionItemDetails> _sorted(List<CollectionItemDetails> entries) {
    final sorted = [...entries];
    switch (_sort) {
      case _CollectionSort.nameAsc:
        sorted.sort(
          (a, b) =>
              a.datasheetName.toLowerCase().compareTo(b.datasheetName.toLowerCase()),
        );
      case _CollectionSort.dateAddedDesc:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _CollectionSort.paintedPctDesc:
        double ratio(CollectionItemDetails e) =>
            e.quantity == 0 ? 0 : e.painted / e.quantity;
        sorted.sort((a, b) => ratio(b).compareTo(ratio(a)));
    }
    return sorted;
  }

  bool _matches(CollectionItemDetails entry) {
    if (widget.searchQuery.isNotEmpty &&
        !entry.datasheetName.toLowerCase().contains(
          widget.searchQuery.toLowerCase(),
        )) {
      return false;
    }
    if (_factionFilter != null) {
      if (_factionFilter == _spaceMarinesGroupKey) {
        if (!isSpaceMarineFactionName(entry.factionName)) {
          return false;
        }
      } else if (entry.factionName != _factionFilter) {
        return false;
      }
    }
    if (_chapterFilter != null && entry.factionName != _chapterFilter) {
      return false;
    }
    if (_stateFilter.isNotEmpty &&
        !_stateFilter.any((state) => _stateCount(entry, state) > 0)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entriesAsync = ref.watch(collectionEntriesProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final armiesAsync = ref.watch(armiesListProvider);
    final recentAsync = ref.watch(recentlyAddedProvider);
    final lastBattleAsync = ref.watch(lastBattleProvider);

    final entries = entriesAsync.value ?? const <CollectionItemDetails>[];
    final armies = armiesAsync.value ?? const <ArmyListItem>[];
    final recent = recentAsync.value ?? const <CollectionItemDetails>[];

    if (entriesAsync.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (entriesAsync.hasError) {
      return Center(
        child: Text('${entriesAsync.error}', style: AppTextStyles.caption),
      );
    }
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.collectionEmpty,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final filtered = _sorted(entries.where(_matches).toList());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OverviewStatsRow(
            armies: armies,
            entries: entries,
            summary: summaryAsync.value,
            lastBattle: lastBattleAsync.value,
          ),
          const SizedBox(height: 20),
          _FactionQuickAccessRow(
            entries: entries,
            factionFilter: _factionFilter,
            chapterFilter: _chapterFilter,
            onFactionChanged: _setFactionFilter,
            onChapterChanged: (value) => setState(() => _chapterFilter = value),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 700;
              final filters = widget.filtersVisible
                  ? _FiltersSidebar(
                      entries: entries,
                      factionFilter: _factionFilter,
                      stateFilter: _stateFilter,
                      onFactionChanged: _setFactionFilter,
                      onStateToggled: (state, value) => setState(() {
                        if (value) {
                          _stateFilter.add(state);
                        } else {
                          _stateFilter.remove(state);
                        }
                      }),
                      onReset: () => setState(() {
                        _factionFilter = null;
                        _chapterFilter = null;
                        _stateFilter.clear();
                      }),
                    )
                  : null;
              final content = _buildResultsColumn(
                l10n: l10n,
                armies: armies,
                recent: recent,
                filtered: filtered,
                entries: entries,
              );

              // En dessous du seuil, les filtres se dessinent au-dessus de
              // la grille (pleine largeur) plutôt qu'à côté — une colonne
              // fixe de 220px ne laisserait quasiment plus de place au
              // contenu sur un écran de téléphone.
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (filters != null) ...[
                      filters,
                      const SizedBox(height: 16),
                    ],
                    content,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (filters != null) ...[
                    SizedBox(width: 220, child: filters),
                    const SizedBox(width: 16),
                  ],
                  Expanded(child: content),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsColumn({
    required AppLocalizations l10n,
    required List<ArmyListItem> armies,
    required List<CollectionItemDetails> recent,
    required List<CollectionItemDetails> filtered,
    required List<CollectionItemDetails> entries,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (armies.isNotEmpty) ...[
          Text(l10n.collectionMyArmiesTitle, style: AppTextStyles.title),
          const SizedBox(height: 12),
          _MyArmiesRow(armies: armies, entries: entries),
          const SizedBox(height: 24),
        ],
        if (recent.isNotEmpty) ...[
          Text(
            l10n.collectionRecentAdditionsTitle,
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 12),
          _RecentAdditionsRow(entries: recent),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.collectionAllItemsTitle,
                style: AppTextStyles.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton<_CollectionSort>(
                  tooltip: l10n.collectionSortTooltip,
                  icon: const Icon(
                    Icons.sort_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  color: AppColors.surface,
                  initialValue: _sort,
                  onSelected: (value) => setState(() => _sort = value),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _CollectionSort.nameAsc,
                      child: Text(
                        l10n.collectionSortName,
                        style: AppTextStyles.body,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CollectionSort.dateAddedDesc,
                      child: Text(
                        l10n.collectionSortDateAdded,
                        style: AppTextStyles.body,
                      ),
                    ),
                    PopupMenuItem(
                      value: _CollectionSort.paintedPctDesc,
                      child: Text(
                        l10n.collectionSortPainted,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
                Tooltip(
                  message: _selectionMode
                      ? l10n.collectionSelectionCancel
                      : l10n.collectionSelectionStart,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: _toggleSelectionMode,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        _selectionMode
                            ? Icons.close_rounded
                            : Icons.checklist_rounded,
                        color: _selectionMode
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                PopupMenuButton<void>(
                  tooltip: l10n.collectionExportTooltip,
                  icon: const Icon(
                    Icons.ios_share_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  color: AppColors.surface,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => _copyExport(
                        context,
                        l10n,
                        CollectionExportFormatter.toCsv(entries),
                      ),
                      child: Text(
                        l10n.collectionExportCsv,
                        style: AppTextStyles.body,
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () => _copyExport(
                        context,
                        l10n,
                        CollectionExportFormatter.toJson(entries),
                      ),
                      child: Text(
                        l10n.collectionExportJson,
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        if (_selectionMode) ...[
          const SizedBox(height: 8),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                l10n.collectionSelectionCount(_selectedIds.length),
                style: AppTextStyles.caption,
              ),
              TextButton.icon(
                onPressed: _selectedIds.isEmpty
                    ? null
                    : () => _markSelectedPainted(entries),
                icon: const Icon(Icons.brush_rounded, size: 16),
                label: Text(l10n.collectionSelectionMarkPainted),
              ),
            ],
          ),
        ],
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
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
                    l10n.collectionNoResultsForFilters,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 340,
              mainAxisExtent: 260,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final entry = filtered[index];
              return _CollectionCard(
                entry: entry,
                selectionMode: _selectionMode,
                selected: _selectedIds.contains(entry.id),
                onToggleSelected: () => _toggleSelected(entry.id),
              );
            },
          ),
      ],
    );
  }
}

class _OverviewStatsRow extends StatelessWidget {
  final List<ArmyListItem> armies;
  final List<CollectionItemDetails> entries;
  final CollectionSummary? summary;
  final BattleDetails? lastBattle;

  const _OverviewStatsRow({
    required this.armies,
    required this.entries,
    required this.summary,
    required this.lastBattle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final quantityByFaction = <String, int>{};
    final paintedByFaction = <String, int>{};
    for (final entry in entries) {
      quantityByFaction[entry.factionName] =
          (quantityByFaction[entry.factionName] ?? 0) + entry.quantity;
      paintedByFaction[entry.factionName] =
          (paintedByFaction[entry.factionName] ?? 0) + entry.painted;
    }
    final completeArmies = armies.where((army) {
      final qty = quantityByFaction[army.factionName] ?? 0;
      final painted = paintedByFaction[army.factionName] ?? 0;
      return qty > 0 && painted >= qty;
    }).length;

    final paintedPct = summary == null
        ? 0
        : (summary!.paintedRatio * 100).round();

    final valueTier = _valueTier(l10n, summary?.totalValue ?? 0);

    final resultLabel = switch (lastBattle?.result) {
      BattleResult.victory => l10n.battleResultVictory,
      BattleResult.defeat => l10n.battleResultDefeat,
      BattleResult.draw => l10n.battleResultDraw,
      null => null,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900 ? 4 : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          // Des tuiles à 2 colonnes sont plus étroites, donc
          // proportionnellement plus hautes pour garder assez de place au
          // texte qu'elles affichent (voir le même correctif sur le
          // Dashboard).
          childAspectRatio: columns == 4 ? 2.0 : 1.4,
          children: [
            _StatTile(
              icon: Icons.groups_rounded,
              label: l10n.dashboardStatArmies,
              value: armies.length.toString(),
              sublabel: l10n.collectionStatArmiesSub(completeArmies),
            ),
            _StatTile(
              icon: Icons.inventory_2_rounded,
              label: l10n.dashboardStatModels,
              value: (summary?.totalModels ?? 0).toString(),
              sublabel: l10n.collectionStatModelsPaintedSub(
                summary?.totalPainted ?? 0,
                paintedPct,
              ),
            ),
            _StatTile(
              icon: Icons.diamond_outlined,
              label: l10n.collectionValueTitle,
              value: valueTier,
              sublabel: l10n.collectionValueUnquantifiedSub,
            ),
            _StatTile(
              icon: Icons.sports_martial_arts_rounded,
              label: l10n.dashboardLastBattleTitle,
              value: lastBattle == null
                  ? '—'
                  : (lastBattle!.opponentName ??
                        lastBattle!.opponentFactionName ??
                        '—'),
              sublabel: resultLabel ?? l10n.dashboardLastBattleEmpty,
            ),
          ],
        );
      },
    );
  }

  String _valueTier(AppLocalizations l10n, double totalValue) {
    if (totalValue >= 1500) return l10n.collectionValueTierLegendary;
    if (totalValue >= 500) return l10n.collectionValueTierEpic;
    if (totalValue >= 100) return l10n.collectionValueTierSolid;
    return l10n.collectionValueTierStarting;
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sublabel;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.heading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            sublabel,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FactionQuickAccessRow extends StatelessWidget {
  final List<CollectionItemDetails> entries;
  final String? factionFilter;
  final String? chapterFilter;
  final ValueChanged<String?> onFactionChanged;
  final ValueChanged<String?> onChapterChanged;

  const _FactionQuickAccessRow({
    required this.entries,
    required this.factionFilter,
    required this.chapterFilter,
    required this.onFactionChanged,
    required this.onChapterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final presentFactions = entries.map((e) => e.factionName).toSet();
    final hasSpaceMarines = presentFactions.any(isSpaceMarineFactionName);
    final otherFactions =
        presentFactions.where((f) => !isSpaceMarineFactionName(f)).toList()
          ..sort();

    if (!hasSpaceMarines && otherFactions.isEmpty) {
      return const SizedBox.shrink();
    }

    final chapters = factionFilter == _spaceMarinesGroupKey
        ? (presentFactions.where(isSpaceMarineFactionName).toList()..sort())
        : const <String>[];

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.collectionQuickAccessFactions.toUpperCase(),
            style: AppTextStyles.eyebrow,
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (hasSpaceMarines)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FactionChip(
                      label: 'Space Marines',
                      selected: factionFilter == _spaceMarinesGroupKey,
                      onTap: () => onFactionChanged(
                        factionFilter == _spaceMarinesGroupKey
                            ? null
                            : _spaceMarinesGroupKey,
                      ),
                    ),
                  ),
                for (final faction in otherFactions)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FactionChip(
                      label: faction,
                      selected: factionFilter == faction,
                      onTap: () => onFactionChanged(
                        factionFilter == faction ? null : faction,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (chapters.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final chapter in chapters)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FactionChip(
                        label: chapter,
                        selected: chapterFilter == chapter,
                        compact: true,
                        onTap: () => onChapterChanged(
                          chapterFilter == chapter ? null : chapter,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FactionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _FactionChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = FactionIconography.forFaction(label).color;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 12,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: .18) : AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!compact) ...[
                FactionBadgeIcon(factionName: label, size: 20),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltersSidebar extends StatelessWidget {
  final List<CollectionItemDetails> entries;
  final String? factionFilter;
  final Set<_PaintState> stateFilter;
  final ValueChanged<String?> onFactionChanged;
  final void Function(_PaintState, bool) onStateToggled;
  final VoidCallback onReset;

  const _FiltersSidebar({
    required this.entries,
    required this.factionFilter,
    required this.stateFilter,
    required this.onFactionChanged,
    required this.onStateToggled,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final quantityByFaction = <String, int>{};
    for (final entry in entries) {
      quantityByFaction[entry.factionName] =
          (quantityByFaction[entry.factionName] ?? 0) + entry.quantity;
    }
    final factions = quantityByFaction.keys.toList()..sort();

    final stateCounts = <_PaintState, int>{
      for (final state in _PaintState.values)
        state: entries.fold<int>(
          0,
          (sum, entry) => sum + _stateCount(entry, state),
        ),
    };
    final stateLabels = {
      _PaintState.unbuilt: l10n.collectionStateUnbuilt,
      _PaintState.assembled: l10n.collectionAssembled,
      _PaintState.primed: l10n.collectionPrimed,
      _PaintState.painted: l10n.collectionPainted,
    };

    final hasActiveFilters = factionFilter != null || stateFilter.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasActiveFilters)
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onReset,
                child: Text(
                  l10n.catalogResetFilters,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          Text(l10n.collectionFilterFactionTitle, style: AppTextStyles.title),
          const SizedBox(height: 10),
          ...factions.map(
            (faction) => _FilterRow(
              label: faction,
              count: quantityByFaction[faction] ?? 0,
              selected: factionFilter == faction,
              onTap: () =>
                  onFactionChanged(factionFilter == faction ? null : faction),
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.collectionFilterStateTitle, style: AppTextStyles.title),
          const SizedBox(height: 10),
          ..._PaintState.values.map(
            (state) => _FilterCheckboxRow(
              label: stateLabels[state]!,
              count: stateCounts[state] ?? 0,
              selected: stateFilter.contains(state),
              onChanged: (value) => onStateToggled(state, value),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterRow({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.border,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('$count', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _FilterCheckboxRow extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _FilterCheckboxRow({
    required this.label,
    required this.count,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!selected),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: selected,
                activeColor: AppColors.primary,
                onChanged: (value) => onChanged(value ?? false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('$count', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _MyArmiesRow extends StatelessWidget {
  final List<ArmyListItem> armies;
  final List<CollectionItemDetails> entries;

  const _MyArmiesRow({required this.armies, required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final quantityByFaction = <String, int>{};
    final paintedByFaction = <String, int>{};
    for (final entry in entries) {
      quantityByFaction[entry.factionName] =
          (quantityByFaction[entry.factionName] ?? 0) + entry.quantity;
      paintedByFaction[entry.factionName] =
          (paintedByFaction[entry.factionName] ?? 0) + entry.painted;
    }

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: armies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final army = armies[index];
          final qty = quantityByFaction[army.factionName] ?? 0;
          final painted = paintedByFaction[army.factionName] ?? 0;
          final ratio = qty == 0 ? 0.0 : (painted / qty).clamp(0, 1);
          final imageFile = LocalCatalogImages.faction(army.factionId);

          return Container(
            width: 220,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: imageFile != null
                          ? Image.file(
                              imageFile,
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 28,
                              height: 28,
                              color: AppColors.surface,
                              child: const Icon(
                                Icons.shield_outlined,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        army.name,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pointsSuffix(army.totalPoints),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio.toDouble(),
                    minHeight: 5,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation(AppColors.success),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$qty · ${(ratio * 100).round()}%',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RecentAdditionsRow extends StatelessWidget {
  final List<CollectionItemDetails> entries;

  const _RecentAdditionsRow({required this.entries});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final entry = entries[index];
          final imageFile = LocalCatalogImages.collectionPhoto(
            entry.datasheetId,
            entry.id,
          );

          return SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageFile != null
                      ? Image.file(
                          imageFile,
                          width: 110,
                          height: 72,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 110,
                          height: 72,
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.shield_outlined,
                            color: AppColors.textSecondary,
                          ),
                        ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.datasheetName,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _WishlistTab extends ConsumerWidget {
  const _WishlistTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(wishlistItemsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: itemsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) =>
            Center(child: Text('$error', style: AppTextStyles.caption)),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(l10n.wishlistEmpty, style: AppTextStyles.caption),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.datasheetName, style: AppTextStyles.body),
                            const SizedBox(height: 4),
                            Text(
                              '${item.factionName} · ${l10n.collectionQuantityLabel(item.quantity)}',
                              style: AppTextStyles.caption,
                            ),
                            if (item.notes != null &&
                                item.notes!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.notes!,
                                style: AppTextStyles.caption,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.wishlistMoveToCollection,
                        icon: const Icon(Icons.inventory_2_outlined),
                        color: AppColors.primary,
                        onPressed: () async {
                          await ref
                              .read(collectionRepositoryProvider)
                              .moveWishlistItemToCollection(item.id);
                          ref.invalidate(wishlistItemsProvider);
                          ref.invalidate(collectionEntriesProvider);
                          ref.invalidate(collectionSummaryProvider);
                          ref.invalidate(recentlyAddedProvider);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textSecondary,
                        onPressed: () async {
                          await ref
                              .read(collectionRepositoryProvider)
                              .deleteWishlistItem(item.id);
                          ref.invalidate(wishlistItemsProvider);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Demande confirmation avant une suppression définitive d'entrée, pour
/// éviter qu'un clic répété sur "-" ou un pas mal calibré ne fasse
/// disparaître une entrée sans que l'utilisateur l'ait vraiment voulu.
Future<bool> _confirmRemoveEntry(
  BuildContext context,
  AppLocalizations l10n,
  String datasheetName,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialogShortcuts(
      onEnter: () => Navigator.of(dialogContext).pop(true),
      child: AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.collectionDeleteConfirmTitle,
          style: AppTextStyles.title,
        ),
        content: Text(
          l10n.collectionDeleteConfirmMessage(datasheetName),
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.armyBuilderCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.collectionDeleteConfirmAction),
          ),
        ],
      ),
    ),
  );
  return confirmed ?? false;
}

class _CollectionCard extends ConsumerWidget {
  final CollectionItemDetails entry;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onToggleSelected;

  const _CollectionCard({
    required this.entry,
    this.selectionMode = false,
    this.selected = false,
    this.onToggleSelected,
  });

  Future<void> _updateCount(WidgetRef ref, String field, int value) async {
    await ref
        .read(collectionRepositoryProvider)
        .updateCounts(
          entry.id,
          assembled: field == 'assembled' ? value : null,
          primed: field == 'primed' ? value : null,
          painted: field == 'painted' ? value : null,
        );
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
    ref.invalidate(xpSummaryProvider);
  }

  Future<void> _removeEntry(WidgetRef ref) async {
    await ref.read(collectionRepositoryProvider).deleteEntry(entry.id);
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
    ref.invalidate(recentlyAddedProvider);
    ref.invalidate(xpSummaryProvider);
  }

  /// Ajuste la quantité possédée de [delta] (positif ou négatif). Si la
  /// nouvelle quantité tomberait à 0 ou moins, on demande confirmation
  /// avant de supprimer l'entrée plutôt que de la laisser à 0.
  Future<void> _adjustQuantity(
    BuildContext context,
    WidgetRef ref,
    int delta,
  ) async {
    final newQuantity = entry.quantity + delta;
    if (newQuantity <= 0) {
      final l10n = AppLocalizations.of(context)!;
      final confirmed = await _confirmRemoveEntry(
        context,
        l10n,
        entry.datasheetName,
      );
      if (!confirmed) return;
      await _removeEntry(ref);
      return;
    }
    await ref
        .read(collectionRepositoryProvider)
        .updateCounts(entry.id, quantity: newQuantity);
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
    ref.invalidate(xpSummaryProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final paintedRatio = entry.quantity == 0
        ? 0.0
        : (entry.painted / entry.quantity).clamp(0, 1);

    final card = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selectionMode && selected ? AppColors.primary : AppColors.border,
          width: selectionMode && selected ? 2 : 1,
        ),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UnitPhotoThumbnail(
                  datasheetId: entry.datasheetId,
                  entryId: entry.id,
                  size: 44,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DatasheetFullPage(datasheetId: entry.datasheetId),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.datasheetName,
                          style: AppTextStyles.body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.factionName,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Tooltip(
                  message: l10n.collectionDeleteEntryTooltip,
                  child: InkWell(
                    key: const Key('delete-entry-button'),
                    borderRadius: BorderRadius.circular(6),
                    onTap: () async {
                      final confirmed = await _confirmRemoveEntry(
                        context,
                        l10n,
                        entry.datasheetName,
                      );
                      if (confirmed) await _removeEntry(ref);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _QuantityAdjustRow(
              quantity: entry.quantity,
              onAdjust: (delta) => _adjustQuantity(context, ref, delta),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: paintedRatio.toDouble(),
                minHeight: 5,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),
            ),
            const SizedBox(height: 10),
            _CountRow(
              label: l10n.collectionAssembled,
              value: entry.assembled,
              max: entry.quantity,
              onChanged: (v) => _updateCount(ref, 'assembled', v),
            ),
            _CountRow(
              label: l10n.collectionPrimed,
              value: entry.primed,
              max: entry.quantity,
              onChanged: (v) => _updateCount(ref, 'primed', v),
            ),
            _CountRow(
              label: l10n.collectionPainted,
              value: entry.painted,
              max: entry.quantity,
              onChanged: (v) => _updateCount(ref, 'painted', v),
            ),
          ],
        ),
      ),
    );

    if (!selectionMode) return card;

    return Stack(
      children: [
        AbsorbPointer(child: card),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onToggleSelected,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Lit un pas d'ajustement depuis un contrôleur de texte : le contenu doit
/// être un entier strictement positif, sinon on retombe sur 1 (comportement
/// équivalent aux boutons +/- simples d'avant).
int _readStep(TextEditingController controller) {
  final parsed = int.tryParse(controller.text.trim());
  if (parsed == null || parsed <= 0) return 1;
  return parsed;
}

/// Champ compact permettant de saisir le pas (le nombre à ajouter ou
/// retirer) utilisé par les boutons +/- environnants.
class _StepField extends StatelessWidget {
  final TextEditingController controller;
  final Key? fieldKey;

  const _StepField({required this.controller, this.fieldKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.collectionStepFieldTooltip,
      child: SizedBox(
        width: 32,
        height: 26,
        child: TextField(
          key: fieldKey,
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 2),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class _QuantityAdjustRow extends StatefulWidget {
  final int quantity;

  /// Reçoit le delta à appliquer (positif pour ajouter, négatif pour
  /// retirer) — laisser l'appelant décider quoi faire si le résultat
  /// tombe à 0 ou moins (typiquement : supprimer l'entrée).
  final ValueChanged<int> onAdjust;

  const _QuantityAdjustRow({required this.quantity, required this.onAdjust});

  @override
  State<_QuantityAdjustRow> createState() => _QuantityAdjustRowState();
}

class _QuantityAdjustRowState extends State<_QuantityAdjustRow> {
  final _stepController = TextEditingController(text: '1');

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = l10n.collectionQuantityLabel(widget.quantity);
    final firstSpace = label.indexOf(' ');
    final numberPart = firstSpace == -1
        ? label
        : label.substring(0, firstSpace);
    final unitPart = firstSpace == -1 ? '' : label.substring(firstSpace + 1);
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  numberPart,
                  key: const Key('quantity-badge-number'),
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (unitPart.isNotEmpty) ...[
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    unitPart,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
        Tooltip(
          message: l10n.collectionDecrementQuantity,
          child: IconButton(
            key: const Key('quantity-decrement-button'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: AppColors.primary,
            onPressed: () => widget.onAdjust(-_readStep(_stepController)),
          ),
        ),
        _StepField(
          controller: _stepController,
          fieldKey: const Key('quantity-step-field'),
        ),
        Tooltip(
          message: l10n.collectionIncrementQuantity,
          child: IconButton(
            key: const Key('quantity-increment-button'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.add_rounded, size: 18),
            color: AppColors.primary,
            onPressed: () => widget.onAdjust(_readStep(_stepController)),
          ),
        ),
      ],
    );
  }
}

class _CountRow extends StatefulWidget {
  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  const _CountRow({
    required this.label,
    required this.value,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_CountRow> createState() => _CountRowState();
}

class _CountRowState extends State<_CountRow> {
  final _stepController = TextEditingController(text: '1');

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final step = _readStep(_stepController);
    return Row(
      children: [
        Expanded(
          child: Text(
            '${widget.label} · ${widget.value}/${widget.max}',
            style: AppTextStyles.caption,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
          color: AppColors.textSecondary,
          onPressed: widget.value <= 0
              ? null
              : () => widget.onChanged(
                  (widget.value - step).clamp(0, widget.max),
                ),
        ),
        _StepField(controller: _stepController),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
          color: AppColors.textSecondary,
          onPressed: widget.value >= widget.max
              ? null
              : () => widget.onChanged(
                  (widget.value + step).clamp(0, widget.max),
                ),
        ),
      ],
    );
  }
}
