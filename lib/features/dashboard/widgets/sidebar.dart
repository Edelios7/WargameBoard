import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(.05),
          ),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wargame Board",
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 40),

          _item(
            0,
            Icons.home_rounded,
            "Dashboard",
          ),

          _item(
            1,
            Icons.groups_rounded,
            "Armées",
          ),

          _item(
            2,
            Icons.sports_martial_arts_rounded,
            "Batailles",
          ),

          _item(
            3,
            Icons.inventory_2_rounded,
            "Collection",
          ),

          _item(
            4,
            Icons.bar_chart_rounded,
            "Statistiques",
          ),

          const Spacer(),

          Opacity(
            opacity: .45,
            child: Text(
              "Version 0.1",
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