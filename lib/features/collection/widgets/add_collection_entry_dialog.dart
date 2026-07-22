import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/xp_provider.dart';

class AddCollectionEntryDialog extends ConsumerStatefulWidget {
  final bool wishlist;

  /// Datasheet pré-sélectionnée (ex. depuis le Catalogue) : évite à
  /// l'utilisateur de retaper la recherche pour l'unité qu'il vient de
  /// consulter.
  final SearchResult? initialResult;

  const AddCollectionEntryDialog({
    super.key,
    this.wishlist = false,
    this.initialResult,
  });

  @override
  ConsumerState<AddCollectionEntryDialog> createState() =>
      _AddCollectionEntryDialogState();
}

class _AddCollectionEntryDialogState
    extends ConsumerState<AddCollectionEntryDialog> {
  List<SearchResult> _results = const [];
  bool _loading = false;
  SearchResult? _selected;
  late final _searchController = TextEditingController(
    text: widget.initialResult?.name ?? '',
  );
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialResult;
    _search(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repository = ref.read(catalogRepositoryProvider);
    final results = await repository.search(query);
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  int get _quantity => int.tryParse(_quantityController.text.trim()) ?? 1;

  void _setQuantity(int value) {
    setState(() {
      _quantityController.text = '${value < 1 ? 1 : value}';
    });
  }

  Future<void> _add() async {
    final selected = _selected;
    final quantity = _quantity;
    if (selected == null || quantity < 1) return;

    final repository = ref.read(collectionRepositoryProvider);
    if (widget.wishlist) {
      final notes = _notesController.text.trim();
      await repository.addWishlistItem(
        datasheetId: selected.id,
        quantity: quantity,
        notes: notes.isEmpty ? null : notes,
      );
      ref.invalidate(wishlistItemsProvider);
    } else {
      await repository.addEntry(
        datasheetId: selected.id,
        quantity: quantity,
        purchasePrice: double.tryParse(
          _priceController.text.trim().replaceAll(',', '.'),
        ),
      );
      ref.invalidate(collectionEntriesProvider);
      ref.invalidate(collectionSummaryProvider);
      ref.invalidate(recentlyAddedProvider);
      ref.invalidate(xpSummaryProvider);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppDialogShortcuts(
      onEnter: _selected == null ? null : _add,
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 420,
          height: 520,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.wishlist
                      ? l10n.wishlistAddItem
                      : l10n.collectionAddEntry,
                  style: AppTextStyles.title,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  autofocus: widget.initialResult == null,
                  onChanged: _search,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: l10n.catalogSearchHint,
                    hintStyle: AppTextStyles.caption,
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final result = _results[index];
                            final selected = result.id == _selected?.id;
                            return ListTile(
                              selected: selected,
                              selectedTileColor: AppColors.primary.withValues(
                                alpha: .14,
                              ),
                              title: Text(
                                result.name,
                                style: AppTextStyles.body,
                              ),
                              subtitle: result.subtitle != null
                                  ? Text(
                                      result.subtitle!,
                                      style: AppTextStyles.caption,
                                    )
                                  : null,
                              onTap: () => setState(() => _selected = result),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body,
                        onSubmitted: (_) => _selected == null ? null : _add(),
                        decoration: InputDecoration(
                          labelText: l10n.collectionQuantityDialogLabel,
                          labelStyle: AppTextStyles.caption,
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.remove_rounded, size: 18),
                            color: AppColors.textSecondary,
                            onPressed: () => _setQuantity(_quantity - 1),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_rounded, size: 18),
                            color: AppColors.textSecondary,
                            onPressed: () => _setQuantity(_quantity + 1),
                          ),
                        ),
                      ),
                    ),
                    if (widget.wishlist) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _notesController,
                          style: AppTextStyles.body,
                          onSubmitted: (_) => _selected == null ? null : _add(),
                          decoration: InputDecoration(
                            labelText: l10n.wishlistNotesDialogLabel,
                            labelStyle: AppTextStyles.caption,
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (!widget.wishlist) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTextStyles.body,
                          onSubmitted: (_) => _selected == null ? null : _add(),
                          decoration: InputDecoration(
                            labelText: l10n.collectionPriceDialogLabel,
                            labelStyle: AppTextStyles.caption,
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: _selected == null ? null : _add,
                      child: Text(l10n.armyBuilderCreate),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
