import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/dashboard/widgets/sidebar.dart';
import '../features/armies/pages/armies_page.dart';
import '../features/battle/pages/battle_page.dart';
import '../features/catalog/pages/catalog_page.dart';
import '../features/collection/pages/collection_page.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _narrowLayoutBreakpoint) {
          return Scaffold(
            body: Row(
              children: [
                Sidebar(
                  selectedIndex: AppTab.values.indexOf(selectedTab),
                  onItemSelected: selectTab,
                ),
                Expanded(child: content),
              ],
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
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
          body: content,
        );
      },
    );
  }
}
