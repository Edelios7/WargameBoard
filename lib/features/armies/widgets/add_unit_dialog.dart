import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/catalog_provider.dart';

class AddUnitDialog extends ConsumerStatefulWidget {
  final String armyId;
  final String factionId;

  const AddUnitDialog({
    super.key,
    required this.armyId,
    required this.factionId,
  });

  @override
  ConsumerState<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends ConsumerState<AddUnitDialog> {
  List<SearchResult> _results = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repository = ref.read(catalogRepositoryProvider);
    final results = await repository.search(
      query,
      factionId: widget.factionId,
    );
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  Future<void> _addUnit(SearchResult result) async {
    final repository = ref.read(catalogRepositoryProvider);
    final details = await repository.getDatasheet(result.id);
    final modelCount = details?.unit.defaultSize ?? 1;

    await ref.read(armyRepositoryProvider).addUnit(
          armyId: widget.armyId,
          datasheetId: result.id,
          modelCount: modelCount,
        );

    ref.invalidate(selectedArmyProvider);
    ref.invalidate(armiesListProvider);

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
        height: 480,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.armyBuilderAddUnit, style: AppTextStyles.title),
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
              const SizedBox(height: 16),
              Expanded(
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              l10n.catalogEmptyResults,
                              style: AppTextStyles.caption,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final result = _results[index];
                              return ListTile(
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
                                trailing: result.points != null
                                    ? Text(
                                        l10n.pointsSuffix(result.points!),
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : null,
                                onTap: () => _addUnit(result),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
