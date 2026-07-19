import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/collection_provider.dart';
import '../widgets/add_collection_entry_dialog.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final entriesAsync = ref.watch(collectionEntriesProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);

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
                    builder: (_) => const AddCollectionEntryDialog(),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(l10n.collectionAddEntry),
                ),
              ],
            ),
            const SizedBox(height: 8),
            summaryAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (summary) => Text(
                l10n.collectionSummaryLine(
                  summary.totalEntries,
                  summary.totalModels,
                  summary.totalPainted,
                ),
                style: AppTextStyles.caption,
              ),
            ),
            const SizedBox(height: 24),
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(entry.datasheetName, style: AppTextStyles.body),
          const SizedBox(height: 2),
          Text(entry.factionName, style: AppTextStyles.caption),
          const SizedBox(height: 8),
          Text(
            l10n.collectionQuantityLabel(entry.quantity),
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
          const Spacer(),
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
