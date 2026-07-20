import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/collection_provider.dart';

class AddCollectionEntryDialog extends ConsumerStatefulWidget {
  final bool wishlist;

  const AddCollectionEntryDialog({super.key, this.wishlist = false});

  @override
  ConsumerState<AddCollectionEntryDialog> createState() =>
      _AddCollectionEntryDialogState();
}

class _AddCollectionEntryDialogState
    extends ConsumerState<AddCollectionEntryDialog> {
  List<SearchResult> _results = const [];
  bool _loading = false;
  SearchResult? _selected;
  final _quantityController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
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

  Future<void> _add() async {
    final selected = _selected;
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
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
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
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
                widget.wishlist ? l10n.wishlistAddItem : l10n.collectionAddEntry,
                style: AppTextStyles.title,
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
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
                            selectedTileColor: AppColors.primary.withValues(alpha: .14),
                            title: Text(result.name, style: AppTextStyles.body),
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
                      style: AppTextStyles.body,
                      decoration: InputDecoration(
                        labelText: l10n.collectionQuantityDialogLabel,
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
                  if (widget.wishlist) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _notesController,
                        style: AppTextStyles.body,
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
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        style: AppTextStyles.body,
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
                    style:
                        FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: _selected == null ? null : _add,
                    child: Text(l10n.armyBuilderCreate),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
