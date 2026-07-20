import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/pages/dashboard_page.dart';
import '../features/dashboard/widgets/sidebar.dart';
import '../features/armies/pages/armies_page.dart';
import '../features/battle/pages/battle_page.dart';
import '../features/catalog/pages/catalog_page.dart';
import '../features/collection/pages/collection_page.dart';
import '../features/explorer/pages/explorer_page.dart';
import '../features/profile/pages/profile_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/statistics/pages/statistics_page.dart';
import 'navigation.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const _pages = <AppTab, Widget>{
    AppTab.dashboard: DashboardPage(),
    AppTab.catalog: CatalogPage(),
    AppTab.explorer: ExplorerPage(),
    AppTab.armies: ArmiesPage(),
    AppTab.battles: BattlePage(),
    AppTab.collection: CollectionPage(),
    AppTab.statistics: StatisticsPage(),
    AppTab.settings: SettingsPage(),
    AppTab.profile: ProfilePage(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: AppTab.values.indexOf(selectedTab),
            onItemSelected: (index) {
              ref.read(selectedTabProvider.notifier).state =
                  AppTab.values[index];
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: KeyedSubtree(
                key: ValueKey(selectedTab),
                child: _pages[selectedTab]!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
