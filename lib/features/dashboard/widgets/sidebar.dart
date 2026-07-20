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
      width: 232,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shield_moon_rounded,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.appTitle,
                    style: AppTextStyles.title.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _item(0, Icons.home_rounded, l10n.navDashboard),
                  _item(1, Icons.auto_stories_rounded, l10n.navCatalog),
                  _item(2, Icons.menu_book_rounded, l10n.navExplorer),
                  _item(3, Icons.groups_rounded, l10n.navArmies),
                  _item(
                    4,
                    Icons.sports_martial_arts_rounded,
                    l10n.navBattles,
                  ),
                  _item(5, Icons.inventory_2_rounded, l10n.navCollection),
                  _item(6, Icons.bar_chart_rounded, l10n.navStatistics),
                  _item(7, Icons.settings_rounded, l10n.navSettings),
                ],
              ),
            ),
          ),

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
