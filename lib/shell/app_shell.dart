import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_wallpapers.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/dashboard/widgets/sidebar.dart';
import '../features/armies/pages/armies_page.dart';
import '../features/battle/pages/battle_page.dart';
import '../features/catalog/pages/catalog_page.dart';
import '../features/collection/pages/collection_page.dart';
import '../features/customization/pages/customization_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/rules/pages/rules_page.dart';
import '../l10n/app_localizations.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/statistics/pages/statistics_page.dart';
import 'navigation.dart';

/// En dessous de cette largeur, la sidebar fixe (232px) ne laisse plus
/// assez de place pour le contenu — on bascule vers un menu tiroir
/// (AppBar + Drawer), patron standard mobile.
const _narrowLayoutBreakpoint = 700.0;

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const _pages = <AppTab, Widget>{
    AppTab.dashboard: DashboardPage(),
    AppTab.catalog: CatalogPage(),
    AppTab.rules: RulesPage(),
    AppTab.armies: ArmiesPage(),
    AppTab.battles: BattlePage(),
    AppTab.collection: CollectionPage(),
    AppTab.statistics: StatisticsPage(),
    AppTab.settings: SettingsPage(),
    AppTab.customization: CustomizationPage(),
    AppTab.profile: ProfilePage(),
  };

  String _tabTitle(AppLocalizations l10n, AppTab tab) {
    switch (tab) {
      case AppTab.dashboard:
        return l10n.navDashboard;
      case AppTab.catalog:
        return l10n.navCatalog;
      case AppTab.rules:
        return l10n.navRules;
      case AppTab.armies:
        return l10n.navArmies;
      case AppTab.battles:
        return l10n.navBattles;
      case AppTab.collection:
        return l10n.navCollection;
      case AppTab.statistics:
        return l10n.navStatistics;
      case AppTab.settings:
        return l10n.navSettings;
      case AppTab.customization:
        return l10n.navCustomization;
      case AppTab.profile:
        return l10n.appTitle;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTab = ref.watch(selectedTabProvider);

    void selectTab(int index) {
      ref.read(selectedTabProvider.notifier).state = AppTab.values[index];
    }

    final content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: KeyedSubtree(
        key: ValueKey(selectedTab),
        child: _pages[selectedTab]!,
      ),
    );

    final appWallpaper = AppWallpapers.app;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _narrowLayoutBreakpoint) {
          return Scaffold(
            backgroundColor: appWallpaper == null ? null : Colors.transparent,
            body: _withAppWallpaper(
              appWallpaper,
              Row(
                children: [
                  Sidebar(
                    selectedIndex: AppTab.values.indexOf(selectedTab),
                    onItemSelected: selectTab,
                  ),
                  Expanded(child: content),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: appWallpaper == null
              ? AppColors.background
              : Colors.transparent,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.textPrimary,
            title: Text(_tabTitle(l10n, selectedTab)),
          ),
          drawer: Drawer(
            backgroundColor: AppColors.background,
            child: Sidebar(
              selectedIndex: AppTab.values.indexOf(selectedTab),
              onItemSelected: (index) {
                Navigator.of(context).pop();
                selectTab(index);
              },
            ),
          ),
          body: _withAppWallpaper(appWallpaper, content),
        );
      },
    );
  }

  /// Pose le fond d'écran "Application" (voir page Personnalisation)
  /// derrière `child`, avec un voile sombre pour la lisibilité — visible
  /// dans les interstices que les pages ne recouvrent pas déjà de leur
  /// propre fond opaque (la plupart le font aujourd'hui ; ce fond global
  /// reste donc surtout visible sur le Dashboard et derrière le menu).
  Widget _withAppWallpaper(File? wallpaper, Widget child) {
    if (wallpaper == null) return child;
    return Stack(
      children: [
        Positioned.fill(child: Image.file(wallpaper, fit: BoxFit.cover)),
        Positioned.fill(
          child: ColoredBox(color: AppColors.background.withValues(alpha: .74)),
        ),
        child,
      ],
    );
  }
}
