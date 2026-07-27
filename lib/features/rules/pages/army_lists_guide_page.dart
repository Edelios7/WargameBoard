import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/rules/rule_document.dart';
import '../../../l10n/app_localizations.dart';

/// Un style de liste pour une faction donnée, extrait d'un [RuleSection]
/// dont le heading suit la convention `"{Faction} — {Style}"` et le body
/// `"{description}\n\n{unités séparées par \n} — Total : {N} pts"` (voir
/// le générateur qui a produit `rules_data.dart`).
class _ArmyListStyle {
  final String name;
  final String description;
  final List<_ArmyListUnit> units;
  final int totalPoints;

  const _ArmyListStyle({
    required this.name,
    required this.description,
    required this.units,
    required this.totalPoints,
  });
}

class _ArmyListUnit {
  final int quantity;
  final String name;

  /// Total en points pour cette ligne (déjà multiplié par [quantity] dans
  /// le texte source, ex. "3 × Boyz — 240 pts") — pas le coût à l'unité.
  final int lineTotalPoints;

  const _ArmyListUnit({
    required this.quantity,
    required this.name,
    required this.lineTotalPoints,
  });
}

const _totalSeparator = ' — Total : ';

/// Regroupe les [RuleSection] du document par faction (heading
/// `"Faction — Style"`) en conservant l'ordre d'origine, et convertit
/// chaque section en [_ArmyListStyle] structuré pour un rendu soigné —
/// au lieu du bloc de texte brut affiché par [RuleDocumentDetailPage].
Map<String, List<_ArmyListStyle>> _groupByFaction(List<RuleSection> sections) {
  final byFaction = <String, List<_ArmyListStyle>>{};
  for (final section in sections) {
    final sepIndex = section.heading.indexOf(' — ');
    if (sepIndex == -1) continue;
    final faction = section.heading.substring(0, sepIndex);
    final styleName = section.heading.substring(sepIndex + 3);
    final style = _parseStyle(styleName, section.body);
    if (style == null) continue;
    byFaction.putIfAbsent(faction, () => []).add(style);
  }
  return byFaction;
}

_ArmyListStyle? _parseStyle(String styleName, String body) {
  final descSplit = body.indexOf('\n\n');
  if (descSplit == -1) return null;
  final description = body.substring(0, descSplit);
  final rest = body.substring(descSplit + 2);

  final totalIndex = rest.lastIndexOf(_totalSeparator);
  if (totalIndex == -1) return null;
  final unitBlock = rest.substring(0, totalIndex);
  final totalText = rest.substring(totalIndex + _totalSeparator.length);
  final totalPoints = int.tryParse(totalText.replaceAll(RegExp(r'[^0-9]'), ''));
  if (totalPoints == null) return null;

  final units = <_ArmyListUnit>[];
  for (final line in unitBlock.split('\n')) {
    final dashIndex = line.lastIndexOf(' — ');
    if (dashIndex == -1) continue;
    var namePart = line.substring(0, dashIndex);
    final pointsPart = line.substring(dashIndex + 3);
    final lineTotalPoints = int.tryParse(
      pointsPart.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (lineTotalPoints == null) continue;

    var quantity = 1;
    final qtyMatch = RegExp(r'^(\d+)\s*×\s*').firstMatch(namePart);
    if (qtyMatch != null) {
      quantity = int.parse(qtyMatch.group(1)!);
      namePart = namePart.substring(qtyMatch.end);
    }
    units.add(
      _ArmyListUnit(
        quantity: quantity,
        name: namePart,
        lineTotalPoints: lineTotalPoints,
      ),
    );
  }

  return _ArmyListStyle(
    name: styleName,
    description: description,
    units: units,
    totalPoints: totalPoints,
  );
}

/// Icône indicative choisie par mots-clés dans le nom du style — purement
/// décoratif, pas une classification officielle (cf. [UnitArchetype] pour
/// la vraie catégorisation des fiches).
IconData _iconForStyle(String styleName) {
  final normalized = styleName.toLowerCase();
  const hordeWords = ['horde', 'marée', 'nuée', 'multitude', 'tide'];
  const armoredWords = [
    'blindé',
    'blindée',
    'colonne',
    'mécanis',
    'titans',
    'cohorte de titans',
  ];
  const strikeWords = ['charge', 'frappe', 'raid', 'éclair', 'assaut', 'blitz'];
  const gunlineWords = ['gunline', 'firebase', 'statique', 'ligne'];
  const eliteWords = ['deathstar', 'muraille', 'cohorte', 'panthéon', 'coven'];

  if (hordeWords.any(normalized.contains)) return Icons.groups_rounded;
  if (armoredWords.any(normalized.contains)) return Icons.fort_rounded;
  if (strikeWords.any(normalized.contains)) return Icons.bolt_rounded;
  if (gunlineWords.any(normalized.contains)) return Icons.gps_fixed_rounded;
  if (eliteWords.any(normalized.contains)) return Icons.shield_rounded;
  return Icons.style_rounded;
}

/// Version interactive du guide "Exemples de listes d'armée" : on choisit
/// une faction, et ses styles de liste (horde, blindée, alpha strike...)
/// apparaissent avec les unités qui les composent, plutôt qu'un mur de
/// texte à faire défiler pour les 27 factions à la suite.
class ArmyListsGuidePage extends StatefulWidget {
  final RuleDocument document;

  const ArmyListsGuidePage({super.key, required this.document});

  @override
  State<ArmyListsGuidePage> createState() => _ArmyListsGuidePageState();
}

class _ArmyListsGuidePageState extends State<ArmyListsGuidePage> {
  late final Map<String, List<_ArmyListStyle>> _byFaction;
  String? _selectedFaction;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _byFaction = _groupByFaction(widget.document.sections);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final factions = _byFaction.keys.where((f) {
      return _query.isEmpty || f.toLowerCase().contains(_query.toLowerCase());
    }).toList();
    final selectedStyles = _selectedFaction == null
        ? null
        : _byFaction[_selectedFaction!];

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
            Text(l10n.armyGuidePickerTitle, style: AppTextStyles.title),
            const SizedBox(height: 6),
            Text(l10n.armyGuidePickerHint, style: AppTextStyles.caption),
            const SizedBox(height: 16),
            TextField(
              onChanged: (v) => setState(() => _query = v),
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: l10n.armyGuideSearchHint,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final faction in factions)
                  _FactionChip(
                    label: faction,
                    styleCount: _byFaction[faction]!.length,
                    selected: _selectedFaction == faction,
                    onTap: () => setState(
                      () => _selectedFaction = _selectedFaction == faction
                          ? null
                          : faction,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            if (selectedStyles == null)
              _EmptySelectionHint(text: l10n.armyGuideNoFactionSelected)
            else ...[
              Text(
                l10n.armyGuideStylesCount(selectedStyles.length),
                style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              ...selectedStyles.map(
                (style) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _StyleCard(style: style, l10n: l10n),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FactionChip extends StatelessWidget {
  final String label;
  final int styleCount;
  final bool selected;
  final VoidCallback onTap;

  const _FactionChip({
    required this.label,
    required this.styleCount,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      selected: selected,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_moon_rounded,
            size: 16,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: selected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySelectionHint extends StatelessWidget {
  final String text;

  const _EmptySelectionHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Icon(Icons.touch_app_rounded, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final _ArmyListStyle style;
  final AppLocalizations l10n;

  const _StyleCard({required this.style, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _iconForStyle(style.name),
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(style.name, style: AppTextStyles.title)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  l10n.armyGuideTotalPoints(style.totalPoints),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(style.description, style: AppTextStyles.caption),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          for (final unit in style.units)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  if (unit.quantity > 1) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '×${unit.quantity}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ] else
                    const SizedBox(width: 30),
                  Expanded(child: Text(unit.name, style: AppTextStyles.body)),
                  Text(
                    '${unit.lineTotalPoints} pts',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
