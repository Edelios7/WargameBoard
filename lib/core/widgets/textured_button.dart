import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Variante de couleur d'un [TexturedButton].
enum TexturedButtonVariant { primary, danger, neutral }

/// Bouton à dégradé avec halo lumineux, qui grossit légèrement et
/// s'éclaircit au survol (souris) — pensé pour les actions principales
/// d'une page (CTA), pas pour un usage généralisé à tous les boutons.
class TexturedButton extends StatefulWidget {
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

  @override
  State<TexturedButton> createState() => _TexturedButtonState();
}

class _TexturedButtonState extends State<TexturedButton> {
  bool _hovered = false;

  List<Color> get _gradient => switch (widget.variant) {
        TexturedButtonVariant.primary => const [
            AppColors.primaryDark,
            AppColors.primary,
          ],
        TexturedButtonVariant.danger => [
            AppColors.error.withValues(alpha: .55),
            AppColors.error,
          ],
        TexturedButtonVariant.neutral => const [
            AppColors.surfaceElevated,
            AppColors.surface,
          ],
      };

  Color get _glow => switch (widget.variant) {
        TexturedButtonVariant.primary => AppColors.primaryLight,
        TexturedButtonVariant.danger => AppColors.error,
        TexturedButtonVariant.neutral => AppColors.textSecondary,
      };

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 17, color: Colors.white),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label.toUpperCase(),
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _hovered ? 1.035 : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            height: 46,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _gradient,
              ),
              border: Border.all(
                color: _glow.withValues(alpha: _hovered ? 0.95 : 0.4),
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: _glow.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: Opacity(opacity: enabled ? 1 : 0.5, child: content),
          ),
        ),
      ),
    );
  }
}
