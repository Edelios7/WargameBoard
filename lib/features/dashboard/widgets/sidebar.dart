import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import 'sidebar_item.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: Colors.white.withValues(alpha: .05),
          ),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appTitle,
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 40),

          _item(
            0,
            Icons.home_rounded,
            l10n.navDashboard,
          ),

          _item(
            1,
            Icons.auto_stories_rounded,
            l10n.navCatalog,
          ),

          _item(
            2,
            Icons.groups_rounded,
            l10n.navArmies,
          ),

          _item(
            3,
            Icons.sports_martial_arts_rounded,
            l10n.navBattles,
          ),

          _item(
            4,
            Icons.inventory_2_rounded,
            l10n.navCollection,
          ),

          _item(
            5,
            Icons.bar_chart_rounded,
            l10n.navStatistics,
          ),

          const Spacer(),

          Opacity(
            opacity: .45,
            child: Text(
              l10n.versionLabel,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    int index,
    IconData icon,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onItemSelected(index),
        child: SidebarItem(
          icon: icon,
          title: title,
          selected: selectedIndex == index,
        ),
      ),
    );
  }
}
