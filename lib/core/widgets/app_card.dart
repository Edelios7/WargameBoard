import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Carte de base de l'app. Quand [onTap] est fourni (carte "ouvrable" —
/// navigation, sélection, dialogue...), elle grossit légèrement et
/// s'éclaircit au survol de la souris pour signaler clairement qu'elle
/// est interactive — voir aussi [Hoverable] pour habiller un widget qui
/// n'est pas déjà une AppCard.
class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool selected;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.selected = false,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;
    final hovered = interactive && _hovered;

    return MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedScale(
        scale: hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Material(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            hoverColor: Colors.white.withValues(alpha: .05),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              padding: widget.padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: widget.selected
                      ? AppColors.primary
                      : hovered
                      ? AppColors.primary.withValues(alpha: .5)
                      : AppColors.border,
                  width: widget.selected ? 1.4 : 1,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: .18),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : const [],
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
