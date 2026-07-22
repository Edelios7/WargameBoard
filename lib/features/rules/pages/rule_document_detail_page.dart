import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/rules/rule_document.dart';
import '../../../l10n/app_localizations.dart';

/// Page affichée après avoir ouvert un document depuis la page Règles :
/// son texte réel (titre, intro, sections) quand [RuleDocument.sections]
/// a été renseigné, sinon un état vide honnête — la plupart des entrées
/// du catalogue statique (`kRuleDocuments`) n'ont pas encore de contenu
/// numérisé, seulement leurs métadonnées.
class RuleDocumentDetailPage extends StatelessWidget {
  final RuleDocument document;

  const RuleDocumentDetailPage({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('dd/MM/yyyy');

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
                    document.title,
                    style: AppTextStyles.heading,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _MetaChip(
                    icon: Icons.numbers_rounded,
                    label: '${l10n.rulesVersionLabel} ${document.version}',
                  ),
                  _MetaChip(
                    icon: Icons.event_rounded,
                    label: dateFormat.format(document.lastUpdate),
                  ),
                  _MetaChip(
                    icon: Icons.business_rounded,
                    label: document.publisher,
                  ),
                  _MetaChip(
                    icon: Icons.language_rounded,
                    label: document.language,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (document.sections.isEmpty)
              AppCard(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      l10n.rulesNoDigitizedContent,
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else ...[
              if (document.intro != null) ...[
                Text(document.intro!, style: AppTextStyles.body),
                const SizedBox(height: 24),
              ],
              ...document.sections.map(
                (section) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          section.heading.toUpperCase(),
                          style: AppTextStyles.eyebrow.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(section.body, style: AppTextStyles.body),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
