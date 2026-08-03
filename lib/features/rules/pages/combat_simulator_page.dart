import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/datasheet_details.dart';
import '../../../database/models/weapon_details.dart';
import '../../../domain/combat/combat_simulator.dart';
import '../../../domain/rules/rule_document.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/catalog_provider.dart';

/// Une paire (arme, profil) aplatie depuis `DatasheetDetails.weapons` —
/// une arme peut avoir plusieurs profils (ex. mode rapproché/longue
/// portée), chacun sélectionnable indépendamment.
class _WeaponChoice {
  final WeaponDetails weapon;
  final WeaponProfileDetails profile;

  const _WeaponChoice(this.weapon, this.profile);

  String get label => '${weapon.name} — ${profile.summary}';
}

List<_WeaponChoice> _flattenWeapons(DatasheetDetails sheet) {
  return [
    for (final weapon in sheet.weapons)
      for (final profile in weapon.profiles) _WeaponChoice(weapon, profile),
  ];
}

/// Outil interactif : choisir une unité attaquante (+ une arme) et une
/// unité défenseure, puis simuler plusieurs vagues d'attaques complètes
/// (pas juste un nombre de dés) pour estimer les chances de l'attaquant.
/// Cœur du combat uniquement (Toucher/Blesser/Sauvegarde/Dégâts) — voir
/// [simulateCombat] pour le détail de ce qui n'est pas modélisé.
///
/// Le nombre de vagues et les résultats restent en haut de la page (avant
/// le formulaire de sélection) pour rester visibles pendant qu'on ajuste
/// les unités plus bas.
class CombatSimulatorPage extends StatefulWidget {
  final RuleDocument document;

  const CombatSimulatorPage({super.key, required this.document});

  @override
  State<CombatSimulatorPage> createState() => _CombatSimulatorPageState();
}

class _CombatSimulatorPageState extends State<CombatSimulatorPage> {
  String? _attackerFactionId;
  DatasheetDetails? _attackerUnit;
  _WeaponChoice? _weapon;
  int _attackerModelCount = 1;

  String? _defenderFactionId;
  DatasheetDetails? _defenderUnit;
  int _defenderModelCount = 1;

  int _trials = 100;
  CombatSimulationResult? _result;

  bool get _canRun =>
      _attackerUnit != null && _weapon != null && _defenderUnit != null;

  void _run() {
    final unit = _attackerUnit;
    final weapon = _weapon;
    final defender = _defenderUnit;
    if (unit == null || weapon == null || defender == null) return;
    if (defender.models.isEmpty) return;

    setState(() {
      _result = simulateCombat(
        weaponProfile: weapon.profile,
        attackerModelCount: _attackerModelCount,
        defenderModel: defender.models.first,
        defenderModelCount: _defenderModelCount,
        trials: _trials,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: l10n.rulesBackToList,
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.document.title,
                    style: AppTextStyles.heading,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (widget.document.intro != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 44),
                child: Text(
                  widget.document.intro!,
                  style: AppTextStyles.caption,
                ),
              ),
            ],
            const SizedBox(height: 28),
            // Vagues de simulation + lancement + résultats : en haut, pour
            // rester visibles pendant qu'on ajuste les unités plus bas.
            Text(l10n.combatSimTrials, style: AppTextStyles.eyebrow),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final count in const [10, 100, 1000])
                  _TrialsChip(
                    count: count,
                    selected: _trials == count,
                    onTap: () => setState(() {
                      _trials = count;
                      _result = null;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _canRun ? _run : null,
                icon: const Icon(Icons.casino_rounded),
                label: Text(l10n.combatSimRun),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              _CombatResultCard(
                result: _result!,
                defenderModelCount: _defenderModelCount,
                l10n: l10n,
              ),
            ] else ...[
              const SizedBox(height: 20),
              Text(l10n.combatSimEmptyState, style: AppTextStyles.caption),
            ],
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 760;
                final attacker = _UnitPicker(
                  label: l10n.combatSimAttacker,
                  factionId: _attackerFactionId,
                  unit: _attackerUnit,
                  modelCount: _attackerModelCount,
                  weaponChoice: _weapon,
                  onFactionChanged: (id) => setState(() {
                    _attackerFactionId = id;
                    _attackerUnit = null;
                    _weapon = null;
                    _result = null;
                  }),
                  onUnitChanged: (sheet) => setState(() {
                    _attackerUnit = sheet;
                    _attackerModelCount = sheet?.unit.defaultSize ?? 1;
                    _weapon = null;
                    _result = null;
                  }),
                  onWeaponChanged: (choice) => setState(() {
                    _weapon = choice;
                    _result = null;
                  }),
                  onModelCountChanged: (count) => setState(() {
                    _attackerModelCount = count;
                    _result = null;
                  }),
                );
                final defender = _UnitPicker(
                  label: l10n.combatSimDefender,
                  factionId: _defenderFactionId,
                  unit: _defenderUnit,
                  modelCount: _defenderModelCount,
                  weaponChoice: null,
                  onFactionChanged: (id) => setState(() {
                    _defenderFactionId = id;
                    _defenderUnit = null;
                    _result = null;
                  }),
                  onUnitChanged: (sheet) => setState(() {
                    _defenderUnit = sheet;
                    _defenderModelCount = sheet?.unit.defaultSize ?? 1;
                    _result = null;
                  }),
                  onWeaponChanged: null,
                  onModelCountChanged: (count) => setState(() {
                    _defenderModelCount = count;
                    _result = null;
                  }),
                );

                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: attacker),
                      const SizedBox(width: 20),
                      Expanded(child: defender),
                    ],
                  );
                }
                return Column(
                  children: [
                    attacker,
                    const SizedBox(height: 20),
                    defender,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// En-tête repliable/dépliable pour une étape du formulaire (Faction,
/// Unité, Nombre de modèles, Arme). Se replie automatiquement dès qu'une
/// valeur est choisie (affiche alors un résumé à la place du contenu),
/// et reste cliquable pour la rouvrir et changer la sélection.
class _CollapsibleSection extends StatefulWidget {
  final String title;
  final String? summary;
  final Widget child;

  const _CollapsibleSection({
    super.key,
    required this.title,
    required this.summary,
    required this.child,
  });

  @override
  State<_CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<_CollapsibleSection> {
  bool _expanded = true;

  @override
  void initState() {
    super.initState();
    _expanded = widget.summary == null;
  }

  @override
  void didUpdateWidget(covariant _CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se replie dès qu'une nouvelle valeur vient d'être choisie — que ce
    // soit le tout premier choix ou un changement fait en rouvrant la
    // section manuellement.
    if (widget.summary != oldWidget.summary && widget.summary != null) {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: AppTextStyles.eyebrow),
                ),
                if (!_expanded && widget.summary != null) ...[
                  Flexible(
                    child: Text(
                      widget.summary!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Icon(
                  _expanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[const SizedBox(height: 8), widget.child],
      ],
    );
  }
}

/// Sélectionne une faction, puis une unité de cette faction (et,
/// optionnellement, une arme qu'elle porte) via des puces cliquables —
/// même style que le picker de faction d'`ArmyListsGuidePage`, plutôt
/// qu'un menu déroulant natif moins lisible sur de longues listes.
/// Chaque étape se replie une fois choisie ; l'étape "Unité" a sa propre
/// barre de recherche pour filtrer les listes de fiches longues.
class _UnitPicker extends ConsumerStatefulWidget {
  final String label;
  final String? factionId;
  final DatasheetDetails? unit;
  final int modelCount;
  final _WeaponChoice? weaponChoice;
  final ValueChanged<String?> onFactionChanged;
  final ValueChanged<DatasheetDetails?> onUnitChanged;
  final ValueChanged<_WeaponChoice?>? onWeaponChanged;
  final ValueChanged<int> onModelCountChanged;

  const _UnitPicker({
    required this.label,
    required this.factionId,
    required this.unit,
    required this.modelCount,
    required this.weaponChoice,
    required this.onFactionChanged,
    required this.onUnitChanged,
    required this.onWeaponChanged,
    required this.onModelCountChanged,
  });

  @override
  ConsumerState<_UnitPicker> createState() => _UnitPickerState();
}

class _UnitPickerState extends ConsumerState<_UnitPicker> {
  String _unitQuery = '';
  final _searchController = TextEditingController();

  @override
  void didUpdateWidget(covariant _UnitPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.factionId != widget.factionId) {
      _unitQuery = '';
      _searchController.clear();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final factionsAsync = ref.watch(factionsListProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label, style: AppTextStyles.title),
          const SizedBox(height: 14),
          factionsAsync.when(
            data: (factions) {
              final match = factions.where((f) => f.id == widget.factionId);
              final selectedName = match.isEmpty ? null : match.first.name;
              return _CollapsibleSection(
                key: ValueKey('${widget.label}-faction-section'),
                title: l10n.combatSimSelectFaction,
                summary: selectedName,
                child: Wrap(
                  key: ValueKey('${widget.label}-faction-choices'),
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final faction in factions)
                      _ChoiceChip(
                        label: faction.name,
                        selected: widget.factionId == faction.id,
                        onTap: () => widget.onFactionChanged(faction.id),
                      ),
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(minHeight: 2),
            error: (_, _) => const SizedBox.shrink(),
          ),
          if (widget.factionId != null) ...[
            const SizedBox(height: 16),
            _CollapsibleSection(
              key: ValueKey('${widget.label}-unit-section'),
              title: l10n.combatSimSelectUnit,
              summary: widget.unit?.name,
              child: Builder(
                builder: (context) {
                  final catalogAsync = ref.watch(
                    factionCatalogDetailsProvider(widget.factionId!),
                  );
                  return catalogAsync.when(
                    data: (sheets) {
                      final sorted = [...sheets]
                        ..sort((a, b) => a.name.compareTo(b.name));
                      final query = _unitQuery.trim().toLowerCase();
                      final filtered = query.isEmpty
                          ? sorted
                          : sorted
                                .where(
                                  (s) => s.name.toLowerCase().contains(query),
                                )
                                .toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: _searchController,
                            onChanged: (value) =>
                                setState(() => _unitQuery = value),
                            style: AppTextStyles.body,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: l10n.catalogSearchHint,
                              hintStyle: AppTextStyles.caption,
                              filled: true,
                              fillColor: AppColors.surface,
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                size: 18,
                                color: AppColors.textSecondary,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (filtered.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: Text(
                                l10n.catalogEmptyResults,
                                style: AppTextStyles.caption,
                              ),
                            )
                          else
                            Wrap(
                              key: ValueKey('${widget.label}-unit-choices'),
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final sheet in filtered)
                                  _ChoiceChip(
                                    label: sheet.name,
                                    selected: widget.unit?.id == sheet.id,
                                    onTap: () =>
                                        widget.onUnitChanged(sheet),
                                  ),
                              ],
                            ),
                        ],
                      );
                    },
                    loading: () =>
                        const LinearProgressIndicator(minHeight: 2),
                    error: (_, _) => const SizedBox.shrink(),
                  );
                },
              ),
            ),
          ],
          if (widget.unit != null) ...[
            const SizedBox(height: 16),
            _CollapsibleSection(
              key: ValueKey('${widget.label}-count-section'),
              title: l10n.combatSimModelCount,
              summary: '${widget.modelCount}',
              child: _ModelCountStepper(
                count: widget.modelCount,
                min: widget.unit!.unit.minimumSize > 0
                    ? widget.unit!.unit.minimumSize
                    : 1,
                max: widget.unit!.unit.maximumSize > 0
                    ? widget.unit!.unit.maximumSize
                    : 20,
                onChanged: widget.onModelCountChanged,
              ),
            ),
          ],
          if (widget.unit != null && widget.onWeaponChanged != null) ...[
            const SizedBox(height: 16),
            _CollapsibleSection(
              key: ValueKey('${widget.label}-weapon-section'),
              title: l10n.combatSimSelectWeapon,
              summary: widget.weaponChoice?.label,
              child: Builder(
                builder: (context) {
                  final choices = _flattenWeapons(widget.unit!);
                  return Wrap(
                    key: ValueKey('${widget.label}-weapon-choices'),
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final choice in choices)
                        _ChoiceChip(
                          label: choice.label,
                          selected:
                              widget.weaponChoice?.weapon.id ==
                                  choice.weapon.id &&
                              widget.weaponChoice?.profile.name ==
                                  choice.profile.name,
                          onTap: () => widget.onWeaponChanged!(choice),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      selected: selected,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: selected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _ModelCountStepper extends StatelessWidget {
  final int count;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _ModelCountStepper({
    required this.count,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline_rounded),
          onPressed: count > min ? () => onChanged(count - 1) : null,
        ),
        Text('$count', style: AppTextStyles.body),
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded),
          onPressed: count < max ? () => onChanged(count + 1) : null,
        ),
      ],
    );
  }
}

class _TrialsChip extends StatelessWidget {
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _TrialsChip({
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: AppCard(
        onTap: onTap,
        selected: selected,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        child: Center(
          child: Text(
            'x$count',
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _CombatResultCard extends StatelessWidget {
  final CombatSimulationResult result;
  final int defenderModelCount;
  final AppLocalizations l10n;

  const _CombatResultCard({
    required this.result,
    required this.defenderModelCount,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (result.destructionProbability * 100).toStringAsFixed(1);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.combatSimResultsTitle, style: AppTextStyles.title),
          const SizedBox(height: 14),
          Text(
            l10n.combatSimAvgKills(
              result.averageModelsKilled.toStringAsFixed(1),
              '$defenderModelCount',
            ),
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.combatSimDestroyProbability('$percent%'),
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.combatSimAvgDamage(
              result.averageDamageDealt.toStringAsFixed(1),
            ),
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
