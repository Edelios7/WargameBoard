import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/local_catalog_images.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/decor_separator.dart';
import '../../../core/widgets/faction_badge_icon.dart';
import '../../../core/widgets/donut_chart.dart';
import '../../../core/widgets/textured_button.dart';
import '../../../database/models/army_details.dart';
import '../../../database/models/battle_details.dart';
import '../../../database/models/collection_item_details.dart';
import '../../../database/models/search_result.dart';
import '../../../database/tables/battles_table.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/army_provider.dart';
import '../../../providers/battle_provider.dart';
import '../../../providers/catalog_provider.dart';
import '../../../providers/collection_provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../shell/navigation.dart';
import '../../armies/widgets/create_army_dialog.dart';
import '../../battle/widgets/log_battle_dialog.dart';
import '../../catalog/pages/datasheet_full_page.dart';
import '../../collection/widgets/add_collection_entry_dialog.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final armiesAsync = ref.watch(armiesListProvider);
    final summaryAsync = ref.watch(collectionSummaryProvider);
    final entriesAsync = ref.watch(collectionEntriesProvider);
    final lastBattleAsync = ref.watch(lastBattleProvider);
    final nextBattleAsync = ref.watch(nextBattleProvider);
    final recentlyAddedAsync = ref.watch(recentlyAddedProvider);
    final recentlyViewedAsync = ref.watch(recentlyViewedDatasheetsProvider);
    final projectsAsync = ref.watch(projectsListProvider);
    final displayName = ref.watch(displayNameProvider);

    void goTo(AppTab tab) => ref.read(selectedTabProvider.notifier).state = tab;

    final armies = armiesAsync.value ?? const <ArmyListItem>[];
    final totalArmyPoints = armies.fold<int>(
      0,
      (sum, a) => sum + a.totalPoints,
    );
    final summary = summaryAsync.value;
    final entries = entriesAsync.value ?? const <CollectionItemDetails>[];
    final heroFactionId = armies.isEmpty
        ? null
        : armies
              .reduce((a, b) => a.totalPoints >= b.totalPoints ? a : b)
              .factionId;

    final ambianceFile = LocalCatalogImages.branding('hero-dashboard');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // L'illustration d'ambiance n'est qu'un fond décoratif : on ne
          // montre qu'une bande réduite en haut de page (pas toute la
          // hauteur défilable) pour limiter le morceau d'image visible, et
          // le dégradé monte vite à une opacité quasi totale pour ne
          // jamais laisser de détails de l'image se lire derrière le texte
          // réel du Dashboard.
          if (ambianceFile != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 260,
              child: Image.file(
                ambianceFile,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          if (ambianceFile != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 260,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: .82),
                      AppColors.background.withValues(alpha: .96),
                      AppColors.background,
                    ],
                    stops: const [0, 0.3, 0.55],
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DashboardHeader(
                  displayName: displayName,
                  heroFactionId: heroFactionId,
                  onOpenSettings: () => goTo(AppTab.settings),
                  onOpenProfile: () => goTo(AppTab.profile),
                  onSearch: (query) {
                    ref.read(catalogSearchQueryProvider.notifier).state = query;
                    goTo(AppTab.catalog);
                  },
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth > 900 ? 4 : 2;
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      // Des tuiles à 2 colonnes sont plus étroites, donc
                      // proportionnellement plus hautes pour garder assez
                      // de place aux 3 lignes de texte qu'elles affichent.
                      childAspectRatio: columns == 4 ? 2.0 : 1.4,
                      children: [
                        _StatTile(
                          icon: Icons.military_tech_rounded,
                          accentColor: AppColors.primary,
                          label: l10n.dashboardStatPoints,
                          value: totalArmyPoints.toString(),
                          sublabel: l10n.dashboardStatPointsSub,
                          onTap: () => goTo(AppTab.armies),
                        ),
                        _StatTile(
                          icon: Icons.inventory_2_rounded,
                          accentColor: AppColors.info,
                          label: l10n.dashboardStatModels,
                          value: (summary?.totalModels ?? 0).toString(),
                          sublabel: l10n.dashboardStatModelsSub,
                          onTap: () => goTo(AppTab.collection),
                        ),
                        _StatTile(
                          icon: Icons.brush_rounded,
                          accentColor: AppColors.success,
                          label: l10n.dashboardStatPainting,
                          value: summary == null
                              ? '—'
                              : '${(summary.paintedRatio * 100).round()}%',
                          sublabel: l10n.dashboardStatPaintingSub,
                          onTap: () => goTo(AppTab.statistics),
                        ),
                        _LastBattleTile(
                          battle: lastBattleAsync.value,
                          onTap: () => goTo(AppTab.battles),
                        ),
                      ],
                    );
                  },
                ),
                const DecorSeparator(),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 980;
                    final cards = [
                      _YourArmiesCard(
                        armies: armies,
                        onSeeAll: () => goTo(AppTab.armies),
                        onOpenArmy: (id) {
                          ref.read(selectedArmyIdProvider.notifier).state = id;
                          goTo(AppTab.armies);
                        },
                      ),
                      _PaintingDonutCard(entries: entries),
                      _FactionBreakdownCard(entries: entries),
                    ];
                    if (!wide) {
                      return Column(
                        children: [
                          for (final card in cards) ...[
                            card,
                            const SizedBox(height: 16),
                          ],
                        ],
                      );
                    }
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 3, child: cards[0]),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: cards[1]),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: cards[2]),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 980;
                    final cards = [
                      _RecentAdditionsCard(
                        entriesAsync: recentlyAddedAsync,
                        onSeeAll: () => goTo(AppTab.collection),
                        onOpenEntry: (datasheetId) =>
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    DatasheetFullPage(datasheetId: datasheetId),
                              ),
                            ),
                      ),
                      _RecentlyViewedCard(
                        resultsAsync: recentlyViewedAsync,
                        onSelect: (id) {
                          ref.read(selectedDatasheetIdProvider.notifier).state =
                              id;
                          goTo(AppTab.catalog);
                        },
                      ),
                      _NextBattleCard(
                        battle: nextBattleAsync.value,
                        armies: armies,
                        onTap: () => goTo(AppTab.battles),
                      ),
                    ];
                    if (!wide) {
                      return Column(
                        children: [
                          for (final card in cards) ...[
                            card,
                            const SizedBox(height: 16),
                          ],
                        ],
                      );
                    }
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 3, child: cards[0]),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: cards[1]),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: cards[2]),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 900;
                    final quickActions = _QuickActionsCard(
                      onNewArmy: () => showDialog(
                        context: context,
                        builder: (_) => const CreateArmyDialog(),
                      ),
                      onAddToCollection: () => showDialog(
                        context: context,
                        builder: (_) => const AddCollectionEntryDialog(),
                      ),
                      onOpenCatalog: () => goTo(AppTab.catalog),
                      onNewBattle: () => showDialog(
                        context: context,
                        builder: (_) => const LogBattleDialog(),
                      ),
                    );
                    final projects = _ProjectsCard(
                      projectsAsync: projectsAsync,
                    );

                    if (!wide) {
                      return Column(
                        children: [
                          quickActions,
                          const SizedBox(height: 16),
                          projects,
                        ],
                      );
                    }
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(flex: 2, child: quickActions),
                          const SizedBox(width: 16),
                          Expanded(flex: 3, child: projects),
                        ],
                      ),
                    );
                  },
                ),
                const _DashboardFooterBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bandeau décoratif discret en pied de Dashboard (voir
/// local_assets/decor/README.md) — absent si l'asset n'est pas présent
/// en local.
class _DashboardFooterBanner extends StatelessWidget {
  const _DashboardFooterBanner();

  @override
  Widget build(BuildContext context) {
    final file = LocalCatalogImages.decor('footer-banner');
    if (file == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Opacity(
        opacity: 0.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            file,
            height: 64,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends ConsumerStatefulWidget {
  final String? displayName;
  final String? heroFactionId;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenProfile;
  final ValueChanged<String> onSearch;

  const _DashboardHeader({
    required this.displayName,
    required this.heroFactionId,
    required this.onOpenSettings,
    required this.onOpenProfile,
    required this.onSearch,
  });

  @override
  ConsumerState<_DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends ConsumerState<_DashboardHeader> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final greeting = widget.displayName == null || widget.displayName!.isEmpty
        ? l10n.dashboardGreetingAnon
        : l10n.dashboardGreetingNamed(widget.displayName!);
    final heroImageId = widget.heroFactionId == null
        ? null
        : ref.watch(factionHeroImageIdProvider(widget.heroFactionId!)).value;
    final heroFile = heroImageId == null
        ? null
        : LocalCatalogImages.unitPhoto(heroImageId);

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 760;
        final greetingBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(greeting, style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              l10n.dashboardEditionLine('Warhammer 40,000', 'Édition 11'),
              style: AppTextStyles.caption,
            ),
          ],
        );

        final actionsRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (wide)
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _searchController,
                  style: AppTextStyles.body,
                  onSubmitted: widget.onSearch,
                  decoration: InputDecoration(
                    hintText: l10n.dashboardSearchHint,
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
            if (wide) const SizedBox(width: 12),
            _BadgeIconButton(
              icon: Icons.notifications_none_rounded,
              badgeCount: 3,
              onTap: widget.onOpenProfile,
            ),
            const SizedBox(width: 8),
            _BadgeIconButton(
              icon: Icons.mail_outline_rounded,
              badgeCount: 1,
              onTap: widget.onOpenProfile,
            ),
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onOpenSettings,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (widget.displayName?.isNotEmpty ?? false)
                        ? widget.displayName![0].toUpperCase()
                        : '?',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

        final content = !wide
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  greetingBlock,
                  const SizedBox(height: 16),
                  actionsRow,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: greetingBlock),
                  actionsRow,
                ],
              );

        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              image: heroFile == null
                  ? null
                  : DecorationImage(
                      image: FileImage(heroFile),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      colorFilter: ColorFilter.mode(
                        AppColors.background.withValues(alpha: .68),
                        BlendMode.darken,
                      ),
                    ),
              border: Border.all(color: AppColors.border),
            ),
            child: content,
          ),
        );
      },
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _BadgeIconButton({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Icon(icon, size: 18, color: AppColors.textSecondary)),
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$badgeCount',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color accentColor;
  final String label;
  final String value;
  final String sublabel;
  final VoidCallback onTap;

  const _StatTile({
    required this.icon,
    required this.accentColor,
    required this.label,
    required this.value,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: AppTextStyles.eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: AppTextStyles.heading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: accentColor),
          ),
        ],
      ),
    );
  }
}

class _LastBattleTile extends ConsumerWidget {
  final BattleDetails? battle;
  final VoidCallback onTap;

  const _LastBattleTile({required this.battle, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (battle == null) {
      return AppCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.sports_martial_arts_rounded,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.dashboardLastBattleTitle.toUpperCase(),
                    style: AppTextStyles.eyebrow,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.dashboardLastBattleEmpty,
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }

    final isVictory = battle!.result == BattleResult.victory;
    final resultLabel = switch (battle!.result) {
      BattleResult.victory => l10n.battleResultVictory,
      BattleResult.defeat => l10n.battleResultDefeat,
      BattleResult.draw => l10n.battleResultDraw,
      null => null,
    };

    final opponentFactionId = battle!.opponentFactionId;
    final heroImageId = opponentFactionId == null
        ? null
        : ref.watch(factionHeroImageIdProvider(opponentFactionId)).value;
    final heroFile = heroImageId == null
        ? null
        : LocalCatalogImages.unitPhoto(heroImageId);

    return Material(
      color: AppColors.surfaceElevated,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(14),
            image: heroFile == null
                ? null
                : DecorationImage(
                    image: FileImage(heroFile),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppColors.surfaceElevated.withValues(alpha: .55),
                      BlendMode.darken,
                    ),
                  ),
            gradient: heroFile != null
                ? null
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: .18),
                      AppColors.surfaceElevated,
                    ],
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.sports_martial_arts_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.dashboardLastBattleTitle.toUpperCase(),
                      style: AppTextStyles.eyebrow,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                battle!.opponentName ?? battle!.opponentFactionName ?? '—',
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (resultLabel != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: (isVictory ? AppColors.success : AppColors.error)
                        .withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    resultLabel,
                    style: AppTextStyles.eyebrow.copyWith(
                      fontSize: 13,
                      color: isVictory ? AppColors.success : AppColors.error,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _YourArmiesCard extends StatelessWidget {
  final List<ArmyListItem> armies;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onOpenArmy;

  const _YourArmiesCard({
    required this.armies,
    required this.onSeeAll,
    required this.onOpenArmy,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shown = armies.take(4).toList();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.dashboardYourArmies,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (armies.isNotEmpty)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    l10n.dashboardSeeAll,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (shown.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardNoArmiesYet,
                style: AppTextStyles.caption,
              ),
            )
          else
            ...shown.map(
              (army) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ArmyRow(army: army, onTap: () => onOpenArmy(army.id)),
              ),
            ),
          const SizedBox(height: 4),
          TexturedButton(
            label: l10n.dashboardCreateArmyShort,
            icon: Icons.add_rounded,
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const CreateArmyDialog(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArmyRow extends StatelessWidget {
  final ArmyListItem army;
  final VoidCallback onTap;

  const _ArmyRow({required this.army, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              FactionBadgeIcon(
                factionName: army.factionName,
                factionId: army.factionId,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      army.name,
                      style: AppTextStyles.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(army.factionName, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color:
                      (army.isOverLimit ? AppColors.error : AppColors.success)
                          .withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  army.isOverLimit
                      ? l10n.dashboardArmyStatusWarning
                      : l10n.dashboardArmyStatusOk,
                  style: AppTextStyles.eyebrow.copyWith(
                    color: army.isOverLimit
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaintingDonutCard extends StatelessWidget {
  final List<CollectionItemDetails> entries;

  const _PaintingDonutCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    var painted = 0;
    var assembledOnly = 0;
    var unbuilt = 0;
    for (final entry in entries) {
      painted += entry.painted;
      assembledOnly += (entry.assembled - entry.painted).clamp(
        0,
        entry.quantity,
      );
      unbuilt += (entry.quantity - entry.assembled).clamp(0, entry.quantity);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardPaintingBreakdown, style: AppTextStyles.title),
          const SizedBox(height: 16),
          DonutChart(
            segments: [
              DonutSegment(
                label: l10n.dashboardStatusPainted,
                value: painted,
                color: AppColors.success,
              ),
              DonutSegment(
                label: l10n.dashboardStatusAssembled,
                value: assembledOnly,
                color: AppColors.primary,
              ),
              DonutSegment(
                label: l10n.dashboardStatusUnbuilt,
                value: unbuilt,
                color: AppColors.border,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactionBreakdownCard extends StatelessWidget {
  final List<CollectionItemDetails> entries;

  const _FactionBreakdownCard({required this.entries});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final factionTotals = <String, int>{};
    for (final entry in entries) {
      factionTotals[entry.factionName] =
          (factionTotals[entry.factionName] ?? 0) + entry.quantity;
    }
    const factionColors = [
      AppColors.primary,
      AppColors.primaryLight,
      AppColors.warning,
      AppColors.success,
      AppColors.textSecondary,
    ];
    final factionSegments = <DonutSegment>[];
    var colorIndex = 0;
    for (final e in factionTotals.entries) {
      factionSegments.add(
        DonutSegment(
          label: e.key,
          value: e.value,
          color: factionColors[colorIndex % factionColors.length],
        ),
      );
      colorIndex++;
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardFactionBreakdown, style: AppTextStyles.title),
          const SizedBox(height: 16),
          if (factionSegments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardNoArmiesYet,
                style: AppTextStyles.caption,
              ),
            )
          else
            DonutChart(segments: factionSegments),
        ],
      ),
    );
  }
}

class _RecentAdditionsCard extends StatelessWidget {
  final AsyncValue<List<CollectionItemDetails>> entriesAsync;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onOpenEntry;

  const _RecentAdditionsCard({
    required this.entriesAsync,
    required this.onSeeAll,
    required this.onOpenEntry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = entriesAsync.value ?? const <CollectionItemDetails>[];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.dashboardRecentAdditionsTitle,
                  style: AppTextStyles.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entries.isNotEmpty)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    l10n.dashboardSeeAll,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardRecentAdditionsEmpty,
                style: AppTextStyles.caption,
              ),
            )
          else
            ...entries
                .take(4)
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => onOpenEntry(entry.datasheetId),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _thumbnail(entry.datasheetId, 40),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.datasheetName,
                                    style: AppTextStyles.body,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    entry.factionName,
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              l10n.collectionQuantityLabel(entry.quantity),
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _RecentlyViewedCard extends StatelessWidget {
  final AsyncValue<List<SearchResult>> resultsAsync;
  final ValueChanged<String> onSelect;

  const _RecentlyViewedCard({
    required this.resultsAsync,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final results = resultsAsync.value ?? const <SearchResult>[];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardRecentlyViewedTitle, style: AppTextStyles.title),
          const SizedBox(height: 8),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardRecentlyViewedEmpty,
                style: AppTextStyles.caption,
              ),
            )
          else
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final result = results[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => onSelect(result.id),
                    child: SizedBox(
                      width: 72,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _thumbnail(result.id, 64),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            result.name,
                            style: AppTextStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
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
    );
  }
}

class _NextBattleCard extends StatelessWidget {
  final BattleDetails? battle;
  final List<ArmyListItem> armies;
  final VoidCallback onTap;

  const _NextBattleCard({
    required this.battle,
    required this.armies,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardNextBattleTitle, style: AppTextStyles.title),
          const SizedBox(height: 8),
          if (battle == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.dashboardNextBattleEmpty,
                style: AppTextStyles.caption,
              ),
            )
          else ...[
            Text(
              MaterialLocalizations.of(
                context,
              ).formatMediumDate(battle!.playedAt),
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                final myArmy = armies.where((a) => a.id == battle!.armyId);
                final myFactionName = myArmy.isEmpty
                    ? null
                    : myArmy.first.factionName;
                final myFactionId = myArmy.isEmpty
                    ? null
                    : myArmy.first.factionId;
                final opponentFactionName = battle!.opponentFactionName;

                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          FactionBadgeIcon(
                            factionName:
                                myFactionName ?? battle!.armyName ?? '?',
                            factionId: myFactionId,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            myFactionName ?? battle!.armyName ?? '—',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        l10n.dashboardVersus,
                        style: AppTextStyles.caption,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          FactionBadgeIcon(
                            factionName:
                                opponentFactionName ??
                                battle!.opponentName ??
                                '?',
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opponentFactionName ?? battle!.opponentName ?? '—',
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            if (battle!.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(battle!.location!, style: AppTextStyles.caption),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  final VoidCallback onNewArmy;
  final VoidCallback onAddToCollection;
  final VoidCallback onOpenCatalog;
  final VoidCallback onNewBattle;

  const _QuickActionsCard({
    required this.onNewArmy,
    required this.onAddToCollection,
    required this.onOpenCatalog,
    required this.onNewBattle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardQuickActionsTitle, style: AppTextStyles.title),
          const SizedBox(height: 12),
          _actionButton(
            icon: Icons.groups_rounded,
            label: l10n.dashboardQuickActionNewArmy,
            onTap: onNewArmy,
          ),
          const SizedBox(height: 8),
          _actionButton(
            icon: Icons.inventory_2_rounded,
            label: l10n.dashboardQuickActionAddToCollection,
            onTap: onAddToCollection,
          ),
          const SizedBox(height: 8),
          _actionButton(
            icon: Icons.auto_stories_rounded,
            label: l10n.dashboardQuickActionOpenCatalog,
            onTap: onOpenCatalog,
          ),
          const SizedBox(height: 8),
          _actionButton(
            icon: Icons.sports_martial_arts_rounded,
            label: l10n.dashboardQuickActionNewBattle,
            onTap: onNewBattle,
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectsCard extends ConsumerStatefulWidget {
  final AsyncValue projectsAsync;

  const _ProjectsCard({required this.projectsAsync});

  @override
  ConsumerState<_ProjectsCard> createState() => _ProjectsCardState();
}

class _ProjectsCardState extends ConsumerState<_ProjectsCard> {
  final _newProjectController = TextEditingController();

  @override
  void dispose() {
    _newProjectController.dispose();
    super.dispose();
  }

  Future<void> _addProject() async {
    final title = _newProjectController.text.trim();
    if (title.isEmpty) return;
    await ref.read(projectRepositoryProvider).addProject(title);
    _newProjectController.clear();
    ref.invalidate(projectsListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final projects = (widget.projectsAsync.value ?? const []) as List;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.dashboardProjectsTitle, style: AppTextStyles.title),
          const SizedBox(height: 12),
          if (projects.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                l10n.dashboardProjectsEmpty,
                style: AppTextStyles.caption,
              ),
            )
          else
            ...projects.map(
              (project) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ProjectRow(project: project),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newProjectController,
                  style: AppTextStyles.body,
                  onSubmitted: (_) => _addProject(),
                  decoration: InputDecoration(
                    hintText: l10n.dashboardAddProjectHint,
                    hintStyle: AppTextStyles.caption,
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: _addProject,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectRow extends ConsumerWidget {
  final dynamic project;

  const _ProjectRow({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool done = project.done as bool;
    final String title = project.title as String;
    final int? progressPercent = project.progressPercent as int?;
    final String id = project.id as String;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: Checkbox(
                  value: done,
                  activeColor: AppColors.primary,
                  onChanged: (value) async {
                    await ref
                        .read(projectRepositoryProvider)
                        .setDone(id, value ?? false);
                    ref.invalidate(projectsListProvider);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    decoration: done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: done
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (!done && progressPercent != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercent / 100,
                minHeight: 5,
                backgroundColor: AppColors.background,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Widget _thumbnail(String datasheetId, double size) {
  final imageFile = LocalCatalogImages.unitPhoto(datasheetId);
  if (imageFile != null) {
    return Image.file(imageFile, width: size, height: size, fit: BoxFit.cover);
  }
  return Container(
    width: size,
    height: size,
    color: AppColors.surface,
    child: const Icon(
      Icons.shield_outlined,
      color: AppColors.textSecondary,
      size: 20,
    ),
  );
}
