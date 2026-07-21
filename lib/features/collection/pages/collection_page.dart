import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/collection_export_formatter.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/xp_provider.dart';
import '../widgets/add_collection_entry_dialog.dart';

enum _PaintState { unbuilt, assembled, primed, painted }

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
                final title = Text(l10n.navCollection, style: AppTextStyles.heading);
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
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 0),
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
                      tooltip: null,
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
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) =>
                            AddCollectionEntryDialog(wishlist: isWishlistTab),
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        isWishlistTab
                            ? l10n.wishlistAddItem
                            : l10n.collectionAddEntry,
                      ),
                    ),
                  ],
                );

                if (!wide) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      const SizedBox(height: 12),
                      controls,
                    ],
                  );
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [title, controls],
                );
              },
            ),
            const SizedBox(height: 16),
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
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.collectionExportedToClipboard)),
  );
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
  final Set<_PaintState> _stateFilter = {};

  bool _matches(CollectionItemDetails entry) {
    if (widget.searchQuery.isNotEmpty &&
        !entry.datasheetName
            .toLowerCase()
            .contains(widget.searchQuery.toLowerCase())) {
      return false;
    }
    if (_factionFilter != null && entry.factionName != _factionFilter) {
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
        child: Text(l10n.collectionEmpty, style: AppTextStyles.caption),
      );
    }

    final filtered = entries.where(_matches).toList();

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.filtersVisible) ...[
                  SizedBox(
                    width: 220,
                    child: _FiltersSidebar(
                      entries: entries,
                      factionFilter: _factionFilter,
                      stateFilter: _stateFilter,
                      onFactionChanged: (value) =>
                          setState(() => _factionFilter = value),
                      onStateToggled: (state, value) => setState(() {
                        if (value) {
                          _stateFilter.add(state);
                        } else {
                          _stateFilter.remove(state);
                        }
                      }),
                      onReset: () => setState(() {
                        _factionFilter = null;
                        _stateFilter.clear();
                      }),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (armies.isNotEmpty) ...[
                        Text(l10n.collectionMyArmiesTitle,
                            style: AppTextStyles.title),
                        const SizedBox(height: 12),
                        _MyArmiesRow(armies: armies, entries: entries),
                        const SizedBox(height: 24),
                      ],
                      if (recent.isNotEmpty) ...[
                        Text(l10n.collectionRecentAdditionsTitle,
                            style: AppTextStyles.title),
                        const SizedBox(height: 12),
                        _RecentAdditionsRow(entries: recent),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(l10n.collectionAllItemsTitle,
                              style: AppTextStyles.title),
                          PopupMenuButton<void>(
                            tooltip: '',
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
                      const SizedBox(height: 12),
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            l10n.collectionNoResultsForFilters,
                            style: AppTextStyles.caption,
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 340,
                            mainAxisExtent: 220,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            return _CollectionCard(entry: filtered[index]);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
      ),
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
          childAspectRatio: 2.0,
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
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.primary),
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
                          ? Image.file(imageFile,
                              width: 28, height: 28, fit: BoxFit.cover)
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
                        style: AppTextStyles.body
                            .copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pointsSuffix(army.totalPoints),
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio.toDouble(),
                    minHeight: 5,
                    backgroundColor: AppColors.background,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.success),
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
          final imageFile = LocalCatalogImages.datasheet(entry.datasheetId);

          return SizedBox(
            width: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageFile != null
                      ? Image.file(imageFile,
                          width: 110, height: 72, fit: BoxFit.cover)
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
        error: (error, _) => Center(
          child: Text('$error', style: AppTextStyles.caption),
        ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            if (item.notes != null && item.notes!.isNotEmpty) ...[
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

class _CollectionCard extends ConsumerWidget {
  final CollectionItemDetails entry;

  const _CollectionCard({required this.entry});

  Future<void> _updateCount(
    WidgetRef ref,
    String field,
    int value,
  ) async {
    await ref.read(collectionRepositoryProvider).updateCounts(
          entry.id,
          assembled: field == 'assembled' ? value : null,
          primed: field == 'primed' ? value : null,
          painted: field == 'painted' ? value : null,
        );
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
    ref.invalidate(xpSummaryProvider);
  }

  Future<void> _incrementQuantity(WidgetRef ref) async {
    await ref.read(collectionRepositoryProvider).updateCounts(
          entry.id,
          quantity: entry.quantity + 1,
        );
    ref.invalidate(collectionEntriesProvider);
    ref.invalidate(collectionSummaryProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.collectionQuantityLabel(entry.quantity),
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary),
                  ),
                ),
                Tooltip(
                  message: l10n.collectionIncrementQuantity,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _incrementQuantity(ref),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.exposure_plus_1_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
  }
}

class _CountRow extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: AppTextStyles.caption),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
          color: AppColors.textSecondary,
          onPressed: value <= 0 ? null : () => onChanged(value - 1),
        ),
        SizedBox(
          width: 20,
          child: Text(
            '$value',
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
          color: AppColors.textSecondary,
          onPressed: value >= max ? null : () => onChanged(value + 1),
        ),
      ],
    );
  }
}
