import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../shell/navigation.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              "Dashboard",
              style: AppTextStyles.title.copyWith(
                fontSize: 34,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Bienvenue sur Wargame Board",
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
                    title: "Armées",
                    subtitle:
                        "Crée, modifie et organise toutes tes armées.",
                    onTap: () => goTo(AppTab.armies),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/battles.png",
                    title: "Batailles",
                    subtitle:
                        "Prépare tes parties et consulte leur historique.",
                    onTap: () => goTo(AppTab.battles),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/collection.png",
                    title: "Collection",
                    subtitle:
                        "Gère tes figurines, peintures et boîtes.",
                    onTap: () => goTo(AppTab.collection),
                  ),

                  DashboardCard(
                    image: "assets/images/dashboard/statistics.png",
                    title: "Statistiques",
                    subtitle:
                        "Analyse tes performances et l'évolution de tes armées.",
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
