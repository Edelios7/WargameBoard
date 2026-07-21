import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool accent;

  /// Affiche une petite croix cliquable en fin de chip quand fourni —
  /// utilisé pour les chips "filtre actif" qu'on peut retirer d'un tap.
  final VoidCallback? onDeleted;

  const AppChip({
    super.key,
    required this.label,
    this.accent = false,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final color = accent ? AppColors.primaryLight : AppColors.textSecondary;
    return Container(
      padding: EdgeInsets.only(
        left: 9,
        right: onDeleted != null ? 4 : 9,
        top: 4,
        bottom: 4,
      ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.eyebrow.copyWith(color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 4),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onDeleted,
              child: Icon(Icons.close_rounded, size: 13, color: color),
            ),
          ],
        ],
      ),
    );
  }
}
