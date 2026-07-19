import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shell/navigation.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    void goTo(AppTab tab) =>
        ref.read(selectedTabProvider.notifier).state = tab;

    return Scaffold(
      backgroundColor: const Color(0xFF111318),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.navDashboard,
              style: AppTextStyles.title.copyWith(
                fontSize: 34,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              l10n.dashboardWelcome,
              style: AppTextStyles.body,
            ),

            const SizedBox(height: 32),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 24,
                mainAxisSpacing: 24,
                childAspectRatio: 1.9,
                children: [
                  DashboardCard(
                    image: "assets/images/dashboard/armies.png",
                    title: l10n.navArmies,
                    subtitle: l10n.dashboardArmiesSubtitle,
                    onTap: () => goTo(AppTab.armies),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/battles.png",
                    title: l10n.navBattles,
                    subtitle: l10n.dashboardBattlesSubtitle,
                    onTap: () => goTo(AppTab.battles),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/collection.png",
                    title: l10n.navCollection,
                    subtitle: l10n.dashboardCollectionSubtitle,
                    onTap: () => goTo(AppTab.collection),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/statistics.png",
                    title: l10n.navStatistics,
                    subtitle: l10n.dashboardStatisticsSubtitle,
                    onTap: () => goTo(AppTab.statistics),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
