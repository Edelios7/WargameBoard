import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../database/models/xp_summary.dart';
import '../../../domain/xp/xp_category.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/xp_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final summaryAsync = ref.watch(xpSummaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.profilePageTitle, style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(l10n.profilePageSubtitle, style: AppTextStyles.caption),
            const SizedBox(height: 24),
            summaryAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (error, _) => Text(
                error.toString(),
                style: AppTextStyles.caption,
              ),
              data: (summary) => _ProfileContent(summary: summary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final XpSummary summary;

  const _ProfileContent({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommandantHeader(summary: summary),
        const SizedBox(height: 28),
        Text(l10n.profileCategoriesTitle, style: AppTextStyles.title),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 560
                    ? 2
                    : 1;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.4,
              children: summary.categories
                  .map((category) => _CategoryCard(category: category))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 28),
        Text(l10n.profileFactionsTitle, style: AppTextStyles.title),
        const SizedBox(height: 12),
        if (summary.factions.isEmpty)
          AppCard(
            child: Text(
              l10n.profileNoFactionXp,
              style: AppTextStyles.caption,
            ),
          )
        else
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < summary.factions.length; i++) ...[
                  if (i > 0) const SizedBox(height: 14),
                  _FactionRow(faction: summary.factions[i]),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _CommandantHeader extends StatelessWidget {
  final XpSummary summary;

  const _CommandantHeader({required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final level = summary.commandantLevel;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.profileCommandant, style: AppTextStyles.caption),
                  Text(
                    l10n.profileLevelShort(level.level),
                    style: AppTextStyles.heading,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: level.progress,
              minHeight: 8,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileXpProgress(level.xpIntoLevel, level.xpForNextLevel),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final XpCategoryProgress category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final meta = _categoryMeta(category.category, l10n);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(meta.icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  meta.label.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileLevelShort(category.level.level),
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category.level.progress,
              minHeight: 5,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactionRow extends StatelessWidget {
  final XpFactionProgress faction;

  const _FactionRow({required this.faction});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            faction.factionName,
            style: AppTextStyles.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 64,
          child: Text(
            l10n.profileLevelShort(faction.level.level),
            style: AppTextStyles.caption,
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: faction.level.progress,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation(AppColors.primaryLight),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryMeta {
  final IconData icon;
  final String label;

  const _CategoryMeta(this.icon, this.label);
}

_CategoryMeta _categoryMeta(XpCategory category, AppLocalizations l10n) {
  switch (category) {
    case XpCategory.painting:
      return _CategoryMeta(Icons.brush_rounded, l10n.xpCategoryPainting);
    case XpCategory.assembly:
      return _CategoryMeta(Icons.handyman_rounded, l10n.xpCategoryAssembly);
    case XpCategory.battle:
      return _CategoryMeta(
        Icons.sports_martial_arts_rounded,
        l10n.xpCategoryBattle,
      );
    case XpCategory.collection:
      return _CategoryMeta(
        Icons.inventory_2_rounded,
        l10n.xpCategoryCollection,
      );
    case XpCategory.lore:
      return _CategoryMeta(Icons.auto_stories_rounded, l10n.xpCategoryLore);
  }
}
