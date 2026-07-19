import 'package:flutter/material.dart';

import '../features/dashboard/pages/dashboard_page.dart';
import '../features/dashboard/widgets/sidebar.dart';
import '../features/armies/pages/armies_page.dart';
import '../features/battle/pages/battle_page.dart';
import '../features/catalog/pages/catalog_page.dart';
import '../features/collection/pages/collection_page.dart';
import '../features/statistics/pages/statistics_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    CatalogPage(),
    ArmiesPage(),
    BattlePage(),
    CollectionPage(),
    StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: KeyedSubtree(
                key: ValueKey(selectedIndex),
                child: pages[selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}