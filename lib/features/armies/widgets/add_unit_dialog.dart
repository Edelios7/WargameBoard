import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_dialog_shortcuts.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/cost_bracket.dart';
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

  /// Ajoute `quantity` escouades de `modelCount` figurines chacune — reste
  /// ouvert après l'ajout (contrairement au comportement historique qui
  /// fermait la fenêtre) pour permettre d'enchaîner plusieurs unités sans
  /// rouvrir "Ajouter une unité" à chaque fois.
  Future<void> _addUnit(
    SearchResult result, {
    required int modelCount,
    required int quantity,
  }) async {
    final armyRepository = ref.read(armyRepositoryProvider);
    Object? failure;

    try {
      for (var i = 0; i < quantity; i++) {
        await armyRepository.addUnit(
          armyId: widget.armyId,
          datasheetId: result.id,
          modelCount: modelCount,
        );
      }
    } catch (e) {
      failure = e;
    } finally {
      // Même si une escouade sur `quantity` échoue en cours de route, les
      // précédentes ont bien été ajoutées en base — invalider pour que
      // l'armée affichée reflète ce qui a réellement été écrit, plutôt que
      // de rester figée sur l'état d'avant l'échec.
      ref.invalidate(selectedArmyProvider);
      ref.invalidate(armiesListProvider);
      ref.invalidate(armyByIdProvider(widget.armyId));
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          failure == null
              ? l10n.armyBuilderUnitAdded(result.name)
              : l10n.armyBuilderAddUnitError(result.name),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
      child: Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: SizedBox(
          width: 520,
          height: 560,
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
                    if (armyAsync.value != null) ...[
                      _PointsBadge(army: armyAsync.value!),
                      const SizedBox(width: 8),
                    ],
                    IconButton(
                      tooltip: l10n.armyBuilderClose,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textSecondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
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
                      ? Center(
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
                            return _ResultTile(
                              key: ValueKey(result.id),
                              armyId: widget.armyId,
                              result: result,
                              owned: owned,
                              onAdd: (modelCount, quantity) => _addUnit(
                                result,
                                modelCount: modelCount,
                                quantity: quantity,
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

/// Une ligne de résultat : nom, taille d'escouade (avec coût résolu pour
/// cette taille) et nombre d'escouades à ajouter — les deux notions sont
/// distinctes et affichées séparément, pour ne plus avoir à "tricher" en
/// ajoutant 2 escouades de 5 pour simuler 1 escouade de 10 à un coût
/// différent.
class _ResultTile extends ConsumerStatefulWidget {
  final String armyId;
  final SearchResult result;
  final bool owned;
  final void Function(int modelCount, int quantity) onAdd;

  const _ResultTile({
    super.key,
    required this.armyId,
    required this.result,
    required this.owned,
    required this.onAdd,
  });

  @override
  ConsumerState<_ResultTile> createState() => _ResultTileState();
}

class _ResultTileState extends ConsumerState<_ResultTile> {
  int? _modelCount;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = widget.result;
    final detailsAsync = ref.watch(datasheetByIdProvider(result.id));
    final sheet = detailsAsync.value;

    // Une fois la fiche chargée, initialise la taille par défaut une
    // seule fois (ne doit pas écraser un choix déjà fait par l'utilisateur
    // sur un rebuild ultérieur du provider).
    if (sheet != null && _modelCount == null) {
      _modelCount = sheet.unit.defaultSize;
    }

    final canResize =
        sheet != null && sheet.unit.maximumSize > sheet.unit.minimumSize;
    // Tailles officiellement chiffrées (ex. 5 et 10 figurines) — quand il y
    // en a peu, des puces à toucher sont bien plus explicites qu'un
    // stepper +/- discret pour répondre à "comment je fais une escouade de
    // 10 ?".
    final knownSizes = sheet == null
        ? const <int>[]
        : (sheet.costBrackets
              .where((b) => b.modelCount != null)
              .map((b) => b.modelCount!)
              .toSet()
              .toList()
            ..sort());
    final useSizeChips =
        canResize && knownSizes.length >= 2 && knownSizes.length <= 4;
    // Certaines unités coûtent plus cher à partir de leur 3e exemplaire
    // dans la même liste (voir CostBracket.minCopyIndex) — il faut donc
    // savoir combien d'exemplaires de cette datasheet sont déjà dans
    // l'armée pour prévisualiser le bon prix avant même de confirmer
    // l'ajout.
    final existingCount =
        ref
            .watch(existingUnitCountProvider((widget.armyId, result.id)))
            .value ??
        0;
    final nextCopyIndex = existingCount + 1;
    final unitPoints = sheet == null
        ? result.points
        : (resolveCostForModelCount(
                sheet.costBrackets,
                _modelCount ?? sheet.unit.defaultSize,
                copyIndex: nextCopyIndex,
              ) ??
              sheet.points);
    // Total réel du lot en cours d'ajout : chaque escouade supplémentaire
    // avance d'une copie (nextCopyIndex, +1, +2...), donc la somme n'est
    // pas forcément `unitPoints * _quantity` si un seuil de surcoût est
    // franchi en cours de lot.
    int? batchTotal;
    if (sheet != null && _quantity > 1) {
      var runningTotal = 0;
      var hasUnknown = false;
      for (var i = 0; i < _quantity; i++) {
        final points = resolveCostForModelCount(
          sheet.costBrackets,
          _modelCount ?? sheet.unit.defaultSize,
          copyIndex: nextCopyIndex + i,
        );
        if (points == null) {
          hasUnknown = true;
          break;
        }
        runningTotal += points;
      }
      batchTotal = hasUnknown ? null : runningTotal;
    }

    return Opacity(
      opacity: widget.owned ? 1 : 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result.name, style: AppTextStyles.body),
                      Row(
                        children: [
                          if (result.subtitle != null)
                            Expanded(
                              child: Text(
                                result.subtitle!,
                                style: AppTextStyles.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          if (!widget.owned)
                            Text(
                              l10n.armyBuilderToBuy,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (unitPoints != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text(
                      l10n.armyBuilderPointsPerSquad(unitPoints),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            if (canResize) ...[
              const SizedBox(height: 8),
              Text(
                l10n.armyBuilderUnitSize,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              if (useSizeChips)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final size in knownSizes)
                      _SizeChip(
                        size: size,
                        points: resolveCostForModelCount(
                          sheet.costBrackets,
                          size,
                          copyIndex: nextCopyIndex,
                        ),
                        selected: _modelCount == size,
                        onTap: () => setState(() => _modelCount = size),
                      ),
                  ],
                )
              else
                _LabeledStepper(
                  label: '',
                  value: _modelCount!,
                  min: sheet.unit.minimumSize,
                  max: sheet.unit.maximumSize,
                  onChanged: (value) => setState(() => _modelCount = value),
                ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                _LabeledStepper(
                  label: l10n.armyBuilderSquadCount,
                  value: _quantity,
                  min: 1,
                  max: 20,
                  onChanged: (value) => setState(() => _quantity = value),
                ),
                const Spacer(),
                IconButton(
                  tooltip: l10n.armyBuilderAddUnit,
                  icon: const Icon(Icons.add_circle_rounded),
                  color: AppColors.primary,
                  onPressed: sheet == null
                      ? null
                      : () {
                          widget.onAdd(_modelCount!, _quantity);
                          setState(() => _quantity = 1);
                        },
                ),
              ],
            ),
            // N'affiche le total du lot que quand il diffère du simple
            // `unitPoints * quantité` — c'est-à-dire quand ajouter ce lot
            // franchit un seuil de surcoût (voir CostBracket.minCopyIndex),
            // pour ne pas surcharger l'écran dans le cas courant.
            if (batchTotal != null &&
                (unitPoints == null || batchTotal != unitPoints * _quantity))
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.armyBuilderBatchTotalPoints(batchTotal),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Puce "5 figurines — 90 pts" tapable pour choisir directement une taille
/// d'escouade chiffrée, plus explicite qu'un stepper +/- pour répondre à
/// "comment je fais une escouade de 10 ?".
class _SizeChip extends StatelessWidget {
  final int size;
  final int? points;
  final bool selected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.size,
    required this.points,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.armyBuilderModelsCount(size),
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (points != null)
              Text(
                l10n.pointsSuffix(points!),
                style: AppTextStyles.caption.copyWith(
                  color: selected
                      ? Colors.white.withValues(alpha: .85)
                      : AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Petit stepper `[-] N [+]` avec un libellé au-dessus, utilisé pour la
/// taille d'escouade et le nombre d'escouades dans [_ResultTile].
class _LabeledStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _LabeledStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 2),
        ],
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _stepperButton(
                icon: Icons.remove_rounded,
                onTap: value > min ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 26,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ),
              _stepperButton(
                icon: Icons.add_rounded,
                onTap: value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepperButton({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
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
