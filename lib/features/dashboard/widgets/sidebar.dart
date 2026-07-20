import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shell/navigation.dart';
import '../../profile/widgets/commandant_footer.dart';
import 'sidebar_item.dart';

class Sidebar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final titleParts = l10n.appTitle.split(' ');
    final titleTop = titleParts.isNotEmpty ? titleParts.first : l10n.appTitle;
    final titleBottom =
        titleParts.length > 1 ? titleParts.sublist(1).join(' ') : '';

    return Container(
      width: 232,
      decoration: BoxDecoration(
        color: AppColors.background,
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
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryLight, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shield_moon_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titleTop.toUpperCase(),
                        style: AppTextStyles.title.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (titleBottom.isNotEmpty)
                        Text(
                          titleBottom.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: AppColors.primaryLight,
                            height: 1.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
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
                  const SizedBox(height: 12),
                  Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 12),
                  _item(7, Icons.settings_rounded, l10n.navSettings),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          CommandantFooter(
            selected: selectedIndex == AppTab.values.indexOf(AppTab.profile),
            onTap: () =>
                onItemSelected(AppTab.values.indexOf(AppTab.profile)),
          ),

          const SizedBox(height: 12),
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
