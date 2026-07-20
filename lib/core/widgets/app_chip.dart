import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool accent;

  const AppChip({super.key, required this.label, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: accent
            ? AppColors.primary.withValues(alpha: .16)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: accent
              ? AppColors.primary.withValues(alpha: .4)
              : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.eyebrow.copyWith(
          color: accent ? AppColors.primaryLight : AppColors.textSecondary,
        ),
      ),
    );
  }
}
