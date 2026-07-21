import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../domain/rules/rule_document.dart';
import '../../../domain/rules/rules_data.dart';
import '../../../l10n/app_localizations.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  int _tab = 0;
  String _query = '';
  RuleCategory? _category;

  List<RuleDocument> get _filtered {
    return kRuleDocuments.where((doc) {
      final matchesQuery =
          doc.title.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == null || doc.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _openBook(BuildContext context, AppLocalizations l10n, RuleDocument doc) {
    final message = doc.localAssetId != null
        ? l10n.rulesOpenBookSnackbar(
            'local_assets/rules/${doc.localAssetId}.pdf')
        : l10n.rulesOpenBookMissing;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hero = kRuleDocuments.firstWhere((d) => d.isCurrent);
    final documents = _filtered;
    final recent = documents.take(5).toList();
    final popular = [...documents]..sort((a, b) => b.downloads.compareTo(a.downloads));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RulesHeader(
              onSearch: (value) => setState(() => _query = value),
              onAdd: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.rulesAddButton)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _TabChip(
                  label: l10n.rulesTabMain,
                  selected: _tab == 0,
                  onTap: () => setState(() => _tab = 0),
                ),
                const SizedBox(width: 20),
                _TabChip(
                  label: l10n.rulesTabAdditional,
                  selected: _tab == 1,
                  onTap: () => setState(() => _tab = 1),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _HeroCard(
              document: hero,
              l10n: l10n,
              onOpenBook: () => _openBook(context, l10n, hero),
              onViewErrata: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.rulesViewErrata(hero.errataCount))),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.rulesCategoryAll.toUpperCase(), style: AppTextStyles.eyebrow),
            const SizedBox(height: 12),
            _CategoriesGrid(
              selected: _category,
              onSelect: (category) => setState(() => _category = category),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 900;
                final recentCard = _RecentDocumentsCard(
                  documents: recent,
                  l10n: l10n,
                );
                final popularCard = _PopularRulesCard(
                  documents: popular.take(5).toList(),
                  l10n: l10n,
                );
                if (!wide) {
                  return Column(
                    children: [
                      recentCard,
                      const SizedBox(height: 16),
                      popularCard,
                    ],
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 3, child: recentCard),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: popularCard),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _HelpRow(l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _RulesHeader extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final VoidCallback onAdd;

  const _RulesHeader({required this.onSearch, required this.onAdd});

  @override
  State<_RulesHeader> createState() => _RulesHeaderState();
}

class _RulesHeaderState extends State<_RulesHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 760;
        final title = Text(l10n.navRules.toUpperCase(), style: AppTextStyles.heading);

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: wide ? 280 : 180,
              child: TextField(
                controller: _searchController,
                onChanged: widget.onSearch,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: l10n.rulesSearchHint,
                  hintStyle: AppTextStyles.caption,
                  filled: true,
                  fillColor: AppColors.surface,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.tune_rounded,
                  size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.rulesAddButton),
            ),
          ],
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 16),
              actions,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [title, actions],
        );
      },
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final RuleDocument document;
  final AppLocalizations l10n;
  final VoidCallback onOpenBook;
  final VoidCallback onViewErrata;

  const _HeroCard({
    required this.document,
    required this.l10n,
    required this.onOpenBook,
    required this.onViewErrata,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 720;

          final cover = Container(
            width: wide ? 220 : double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withValues(alpha: .28),
                  AppColors.surfaceElevated,
                ],
              ),
            ),
            child: const Center(
              child: Icon(Icons.shield_moon_rounded,
                  size: 56, color: AppColors.primaryLight),
            ),
          );

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.rulesBadgeMain, style: AppTextStyles.eyebrow),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: Text(document.title, style: AppTextStyles.title),
                  ),
                  if (document.isCurrent) ...[
                    const SizedBox(width: 10),
                    _StatusBadge(
                      label: l10n.rulesBadgeCurrent,
                      color: AppColors.primary,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 16,
                runSpacing: 6,
                children: [
                  _MetaItem(icon: Icons.business_rounded, label: document.publisher),
                  _MetaItem(
                    icon: Icons.event_rounded,
                    label: dateFormat.format(document.releaseDate),
                  ),
                  _MetaItem(icon: Icons.language_rounded, label: document.language),
                  if (document.isUpToDate)
                    _MetaItem(
                      icon: Icons.check_circle_rounded,
                      label: l10n.rulesBadgeUpToDate,
                      color: AppColors.success,
                    ),
                ],
              ),
            ],
          );

          final sidePanel = Container(
            width: wide ? 240 : double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.rulesVersionLabel, style: AppTextStyles.eyebrow),
                        const SizedBox(height: 4),
                        Text(document.version, style: AppTextStyles.title),
                      ],
                    ),
                    if (document.isUpToDate)
                      _StatusBadge(
                        label: l10n.rulesBadgeUpToDate,
                        color: AppColors.success,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(l10n.rulesLastUpdateLabel, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(dateFormat.format(document.lastUpdate), style: AppTextStyles.body),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: onOpenBook,
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    label: Text(l10n.rulesOpenBook),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: onViewErrata,
                    child: Text(
                      l10n.rulesViewErrata(document.errataCount),
                      style: AppTextStyles.body,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cover,
                const SizedBox(height: 16),
                content,
                const SizedBox(height: 16),
                sidePanel,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cover,
              const SizedBox(width: 20),
              Expanded(child: content),
              const SizedBox(width: 20),
              sidePanel,
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.eyebrow.copyWith(color: color),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: color ?? AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _CategoriesGrid extends StatelessWidget {
  final RuleCategory? selected;
  final ValueChanged<RuleCategory?> onSelect;

  const _CategoriesGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    int countFor(RuleCategory? category) => category == null
        ? kRuleDocuments.length
        : kRuleDocuments.where((d) => d.category == category).length;

    final entries = <(RuleCategory?, IconData, String)>[
      (null, Icons.bookmark_rounded, l10n.rulesCategoryAll),
      (RuleCategory.mainRules, Icons.menu_book_rounded, l10n.rulesCategoryMain),
      (RuleCategory.missions, Icons.track_changes_rounded, l10n.rulesCategoryMissions),
      (RuleCategory.faqs, Icons.help_outline_rounded, l10n.rulesCategoryFaqs),
      (RuleCategory.errata, Icons.description_rounded, l10n.rulesCategoryErrata),
      (RuleCategory.pointsAndProfiles, Icons.shield_rounded, l10n.rulesCategoryProfiles),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 980
            ? 6
            : constraints.maxWidth > 640
                ? 3
                : 2;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.7,
          children: [
            for (final entry in entries)
              AppCard(
                selected: selected == entry.$1,
                onTap: () => onSelect(selected == entry.$1 ? null : entry.$1),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(entry.$2,
                        size: 18,
                        color: selected == entry.$1
                            ? AppColors.primary
                            : AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text(
                      entry.$3,
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.rulesDocumentsCount(countFor(entry.$1)),
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RecentDocumentsCard extends StatelessWidget {
  final List<RuleDocument> documents;
  final AppLocalizations l10n;

  const _RecentDocumentsCard({required this.documents, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.rulesRecentDocuments.toUpperCase(), style: AppTextStyles.eyebrow),
              TextButton(
                onPressed: () {},
                child: Text(
                  l10n.rulesSeeAll,
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (documents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(l10n.rulesEmpty, style: AppTextStyles.caption),
            )
          else
            ...documents.map(
              (doc) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.surface,
                      ),
                      child: const Icon(Icons.description_rounded,
                          size: 18, color: AppColors.primaryLight),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.title,
                            style: AppTextStyles.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'v${doc.version} • ${dateFormat.format(doc.lastUpdate)} • ${doc.language}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.bookmark_border_rounded,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 12),
                    const Icon(Icons.more_vert_rounded,
                        size: 18, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PopularRulesCard extends StatelessWidget {
  final List<RuleDocument> documents;
  final AppLocalizations l10n;

  const _PopularRulesCard({required this.documents, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.rulesPopularRules.toUpperCase(), style: AppTextStyles.eyebrow),
              TextButton(
                onPressed: () {},
                child: Text(
                  l10n.rulesSeeAll,
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (documents.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(l10n.rulesEmpty, style: AppTextStyles.caption),
            )
          else
            ...documents.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final doc = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      child: Text(
                        '$rank',
                        style: AppTextStyles.title.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.surface,
                      ),
                      child: const Icon(Icons.description_rounded,
                          size: 16, color: AppColors.primaryLight),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc.title,
                            style: AppTextStyles.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${(doc.downloads / 1000).toStringAsFixed(1)}k • v${doc.version}',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.download_rounded,
                        size: 18, color: AppColors.textSecondary),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  final AppLocalizations l10n;

  const _HelpRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String)>[
      (Icons.help_outline_rounded, l10n.rulesHelpHowToPlay, l10n.rulesHelpHowToPlaySub),
      (Icons.play_circle_outline_rounded, l10n.rulesHelpVideos, l10n.rulesHelpVideosSub),
      (Icons.balance_rounded, l10n.rulesHelpApplication, l10n.rulesHelpApplicationSub),
      (Icons.menu_book_outlined, l10n.rulesHelpGlossary, l10n.rulesHelpGlossarySub),
    ];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.rulesHelpTitle.toUpperCase(), style: AppTextStyles.eyebrow),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 560
                      ? 2
                      : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 3.2,
                children: [
                  for (final item in items)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(item.$1, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item.$2,
                                    style: AppTextStyles.body
                                        .copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text(item.$3,
                                    style: AppTextStyles.caption,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 16, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
