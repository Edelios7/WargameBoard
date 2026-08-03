import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/customization_ids.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/catalog/common/unit_archetype.dart';
import '../../../domain/rules/rule_document.dart';
import '../../../l10n/app_localizations.dart';

/// Version interactive du guide "chaîne alimentaire des unités" : au lieu
/// d'un mur de texte, on choisit deux archétypes d'unité et l'appli
/// affiche directement qui a l'avantage et pourquoi. Le contenu de
/// référence complet ([RuleDocument.sections]) reste disponible en
/// dessous, replié, pour qui veut creuser.
class FoodChainGuidePage extends StatefulWidget {
  final RuleDocument document;

  const FoodChainGuidePage({super.key, required this.document});

  @override
  State<FoodChainGuidePage> createState() => _FoodChainGuidePageState();
}

class _FoodChainGuidePageState extends State<FoodChainGuidePage> {
  UnitArchetype? _pickA;
  UnitArchetype? _pickB;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final result = (_pickA != null && _pickB != null)
        ? matchupFor(_pickA!, _pickB!)
        : null;

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
            Text(l10n.foodChainPickerTitle, style: AppTextStyles.title),
            const SizedBox(height: 6),
            Text(l10n.foodChainPickerHint, style: AppTextStyles.caption),
            const SizedBox(height: 20),
            _ArchetypePicker(
              label: l10n.foodChainPickLabelA,
              selected: _pickA,
              onSelect: (a) => setState(() => _pickA = a),
            ),
            const SizedBox(height: 16),
            Center(
              child: Icon(
                Icons.swap_vert_rounded,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _ArchetypePicker(
              label: l10n.foodChainPickLabelB,
              selected: _pickB,
              onSelect: (b) => setState(() => _pickB = b),
            ),
            if (result != null) ...[
              const SizedBox(height: 24),
              _MatchupResultCard(
                a: _pickA!,
                b: _pickB!,
                result: result,
                l10n: l10n,
              ),
            ],
            if (widget.document.sections.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                l10n.foodChainMoreDetails.toUpperCase(),
                style: AppTextStyles.eyebrow,
              ),
              const SizedBox(height: 12),
              ...widget.document.sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CollapsibleSection(section: section),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArchetypePicker extends StatelessWidget {
  final String label;
  final UnitArchetype? selected;
  final ValueChanged<UnitArchetype> onSelect;

  const _ArchetypePicker({
    required this.label,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.eyebrow),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final archetype in UnitArchetype.values)
              _ArchetypeChip(
                archetype: archetype,
                selected: selected == archetype,
                onTap: () => onSelect(archetype),
              ),
          ],
        ),
      ],
    );
  }
}

class _ArchetypeChip extends StatelessWidget {
  final UnitArchetype archetype;
  final bool selected;
  final VoidCallback onTap;

  const _ArchetypeChip({
    required this.archetype,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = kArchetypeInfo[archetype]!;
    return SizedBox(
      width: 132,
      child: AppCard(
        onTap: onTap,
        selected: selected,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              info.icon,
              size: 26,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              archetypeName(l10n, archetype),
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchupResultCard extends StatelessWidget {
  final UnitArchetype a;
  final UnitArchetype b;
  final MatchupResult result;
  final AppLocalizations l10n;

  const _MatchupResultCard({
    required this.a,
    required this.b,
    required this.result,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final balanced = result.advantage == null;
    final verdictText = balanced
        ? l10n.foodChainVerdictBalanced
        : l10n.foodChainVerdictAdvantage(
            archetypeName(l10n, result.advantage!),
          );

    return AppCard(
      customizationId: CustomizationIds.rulesFoodChainResult,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ArchetypeBadge(archetype: a, highlighted: result.advantage == a),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'VS',
                  style: AppTextStyles.eyebrow.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              _ArchetypeBadge(archetype: b, highlighted: result.advantage == b),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: balanced
                    ? AppColors.surface
                    : AppColors.success.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: balanced ? AppColors.border : AppColors.success,
                ),
              ),
              child: Text(
                verdictText,
                style: AppTextStyles.body.copyWith(
                  color: balanced ? AppColors.textPrimary : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.explanation,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ArchetypeBadge extends StatelessWidget {
  final UnitArchetype archetype;
  final bool highlighted;

  const _ArchetypeBadge({required this.archetype, required this.highlighted});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = kArchetypeInfo[archetype]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          info.icon,
          size: 28,
          color: highlighted ? AppColors.success : AppColors.textSecondary,
        ),
        const SizedBox(height: 6),
        Text(
          archetypeName(l10n, archetype),
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: highlighted ? AppColors.success : AppColors.textSecondary,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _CollapsibleSection extends StatelessWidget {
  final RuleSection section;

  const _CollapsibleSection({required this.section});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          title: Text(
            section.heading,
            style: AppTextStyles.eyebrow.copyWith(color: AppColors.primary),
          ),
          expandedAlignment: Alignment.centerLeft,
          children: [Text(section.body, style: AppTextStyles.body)],
        ),
      ),
    );
  }
}
