import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/collection_export_formatter.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/collection_provider.dart';
import '../widgets/add_collection_entry_dialog.dart';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.navCollection, style: AppTextStyles.heading),
                FilledButton.icon(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.primary),
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
                children: const [
                  _CollectionTab(),
                  _WishlistTab(),
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

class _CollectionTab extends ConsumerWidget {
  const _CollectionTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entriesAsync = ref.watch(collectionEntriesProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: summaryAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (summary) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.collectionSummaryLine(
                        summary.totalEntries,
                        summary.totalModels,
                        summary.totalPainted,
                      ),
                      style: AppTextStyles.caption,
                    ),
                    if (summary.totalValue > 0)
                      Text(
                        l10n.collectionTotalValue(
                          ref.read(collectionServiceProvider).formatValue(
                                summary.totalValue,
                                Localizations.localeOf(context).languageCode,
                              ),
                        ),
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.primary),
                      ),
                  ],
                ),
              ),
            ),
            entriesAsync.maybeWhen(
              data: (entries) => entries.isEmpty
                  ? const SizedBox.shrink()
                  : PopupMenuButton<void>(
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
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: entriesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (error, _) => Center(
              child: Text('$error', style: AppTextStyles.caption),
            ),
            data: (entries) {
              if (entries.isEmpty) {
                return Center(
                  child: Text(
                    l10n.collectionEmpty,
                    style: AppTextStyles.caption,
                  ),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  mainAxisExtent: 220,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return _CollectionCard(entry: entries[index]);
                },
              );
            },
          ),
        ),
      ],
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
            Text(
              l10n.collectionQuantityLabel(entry.quantity),
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
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
