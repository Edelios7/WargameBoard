import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/search_result.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/collection_provider.dart';

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
  bool _onlyOwned = false;
  final Map<String, int> _quantities = {};

  int _quantityFor(String id) => _quantities[id] ?? 1;

  void _setQuantity(String id, int value) {
    setState(() => _quantities[id] = value.clamp(1, 20));
  }

  @override
  void initState() {
    super.initState();
    _search('');
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repository = ref.read(catalogRepositoryProvider);
    final results = await repository.search(query, factionId: widget.factionId);
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  Future<void> _addUnit(SearchResult result, {int quantity = 1}) async {
    final repository = ref.read(catalogRepositoryProvider);
    final details = await repository.getDatasheet(result.id);
    if (details == null) {
      // Fiche introuvable (orpheline/corrompue) : mieux vaut ne rien
      // ajouter que d'insérer une unité avec un modelCount de repli
      // arbitraire (1) qui ne correspond à rien de réel.
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.armyBuilderAddUnitFailed(
                result.name,
              ),
            ),
          ),
        );
      }
      return;
    }
    final modelCount = details.unit.defaultSize;
    final armyRepository = ref.read(armyRepositoryProvider);

    for (var i = 0; i < quantity; i++) {
      await armyRepository.addUnit(
        armyId: widget.armyId,
        datasheetId: result.id,
        modelCount: modelCount,
      );
    }

    ref.invalidate(selectedArmyProvider);
    ref.invalidate(armiesListProvider);
    ref.invalidate(armyByIdProvider(widget.armyId));

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final armyAsync = ref.watch(armyByIdProvider(widget.armyId));
    final collectionAsync = ref.watch(collectionEntriesProvider);
    final ownedIds = <String>{
      for (final entry in collectionAsync.value ?? const [])
        if (entry.quantity > 0) entry.datasheetId,
    };
    final visibleResults = _onlyOwned
        ? _results.where((r) => ownedIds.contains(r.id)).toList()
        : _results;

    return AppDialogShortcuts(
      onEnter: () {
        if (visibleResults.isNotEmpty) {
          final first = visibleResults.first;
          _addUnit(first, quantity: _quantityFor(first.id));
        }
      },
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 480,
          height: 520,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.armyBuilderAddUnit,
                        style: AppTextStyles.title,
                      ),
                    ),
                    if (armyAsync.value != null)
                      _PointsBadge(army: armyAsync.value!),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  autofocus: true,
                  onChanged: _search,
                  onSubmitted: (_) {
                    if (visibleResults.isNotEmpty) {
                      final first = visibleResults.first;
                      _addUnit(first, quantity: _quantityFor(first.id));
                    }
                  },
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
                const SizedBox(height: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => setState(() => _onlyOwned = !_onlyOwned),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _onlyOwned,
                            activeColor: AppColors.primary,
                            onChanged: (value) =>
                                setState(() => _onlyOwned = value ?? false),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.armyBuilderOnlyOwnedFilter,
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                      : visibleResults.isEmpty
                      ? Center(
                          child: Text(
                            l10n.catalogEmptyResults,
                            style: AppTextStyles.caption,
                          ),
                        )
                      : ListView.builder(
                          itemCount: visibleResults.length,
                          itemBuilder: (context, index) {
                            final result = visibleResults[index];
                            final owned = ownedIds.contains(result.id);
                            final quantity = _quantityFor(result.id);
                            return Opacity(
                              opacity: owned ? 1 : 0.5,
                              child: ListTile(
                                title: Text(
                                  result.name,
                                  style: AppTextStyles.body,
                                ),
                                subtitle: Row(
                                  children: [
                                    if (result.subtitle != null)
                                      Expanded(
                                        child: Text(
                                          result.subtitle!,
                                          style: AppTextStyles.caption,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    if (result.points != null)
                                      Text(
                                        l10n.pointsSuffix(result.points!),
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    if (!owned) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        l10n.armyBuilderToBuy,
                                        style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _QuantityStepper(
                                      quantity: quantity,
                                      onChanged: (value) =>
                                          _setQuantity(result.id, value),
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      tooltip: l10n.armyBuilderAddUnit,
                                      icon: const Icon(
                                        Icons.add_circle_rounded,
                                      ),
                                      color: AppColors.primary,
                                      onPressed: () =>
                                          _addUnit(result, quantity: quantity),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Total de points de l'armée visible en permanence pendant qu'on
/// ajoute des unités, pour ne pas devoir fermer la fenêtre pour
/// vérifier si on a dépassé la limite.
class _PointsBadge extends StatelessWidget {
  final ArmyDetails army;

  const _PointsBadge({required this.army});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = army.pointsLimit != null
        ? l10n.armyBuilderPointsWithLimit(army.totalPoints, army.pointsLimit!)
        : l10n.pointsSuffix(army.totalPoints);
    final color = army.isOverLimit ? AppColors.error : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Petit stepper -/N/+ pour choisir combien de copies d'une unité
/// ajouter d'un coup (ex. 3 escouades d'Intercessors) sans repasser par
/// "Dupliquer l'unité" une fois l'unité déjà dans la liste.
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            tooltip: l10n.armyBuilderQuantityDecrease,
            icon: Icons.remove_rounded,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          SizedBox(
            width: 22,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
          ),
          _stepperButton(
            tooltip: l10n.armyBuilderQuantityIncrease,
            icon: Icons.add_rounded,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required String tooltip,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 16,
            color: onTap == null
                ? AppColors.textSecondary.withValues(alpha: .4)
                : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
