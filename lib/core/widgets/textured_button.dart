import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/local_catalog_images.dart';

/// Variante de couleur d'un [TexturedButton] — voir
/// local_assets/decor/README.md (section `button-bg-*`).
enum TexturedButtonVariant { primary, danger, neutral }

/// Bouton habillé de la texture de plaque 40K recadrée depuis les
/// planches de référence PDF (fond ornemental, coins bagués), avec le
/// libellé rendu par Flutter par-dessus — jamais gravé dans l'image, pour
/// rester traduisible EN/FR.
///
/// Retombe sur un [FilledButton] classique si l'asset n'est pas présent
/// en local (contenu jamais commité, voir .gitignore).
class TexturedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final TexturedButtonVariant variant;
  final IconData? icon;

  const TexturedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = TexturedButtonVariant.primary,
    this.icon,
  });

  String get _colorName => switch (variant) {
        TexturedButtonVariant.primary => 'purple-corrupted',
        TexturedButtonVariant.danger => 'red-chaos',
        TexturedButtonVariant.neutral => 'silver-skull',
      };

  Color get _fallbackColor => switch (variant) {
        TexturedButtonVariant.primary => AppColors.primary,
        TexturedButtonVariant.danger => AppColors.error,
        TexturedButtonVariant.neutral => AppColors.surfaceElevated,
      };

  @override
  Widget build(BuildContext context) {
    final file = LocalCatalogImages.decor('button-bg-$_colorName');
    if (file == null) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: _fallbackColor),
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: Text(label),
      );
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 8),
        ],
        Text(
          label.toUpperCase(),
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            height: 46,
            decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(file), fit: BoxFit.fill),
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
