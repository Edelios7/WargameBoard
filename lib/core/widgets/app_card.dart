import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_wallpapers.dart';

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

  /// Fond d'écran à utiliser à la place de [AppWallpapers.cards] — pour
  /// les cartes qui ont leur propre emplacement dédié dans la page
  /// Personnalisation (ex. la bannière d'accueil du Dashboard, qui lit
  /// [AppWallpapers.banner]) plutôt que le réglage générique "Cartes".
  final File? wallpaperOverride;

  /// Teinte d'accent optionnelle (ex. la couleur de faction d'une armée) —
  /// se limite à la bordure de la carte, le fond reste neutre. Un fond
  /// entièrement teinté écrasait le titre (petit texte) sous un gros
  /// aplat de couleur et donnait une impression de décalage/déséquilibre ;
  /// la bordure suffit à identifier la carte sans dominer visuellement.
  /// Ignorée si un fond d'écran (image) est actif : les deux se
  /// superposeraient mal.
  final Color? accentColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.selected = false,
    this.wallpaperOverride,
    this.accentColor,
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
    final wallpaper = widget.wallpaperOverride ?? AppWallpapers.cards;
    final accentColor = widget.accentColor;
    final baseColor = wallpaper != null ? null : AppColors.surfaceElevated;

    return MouseRegion(
      onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
      onExit: interactive ? (_) => setState(() => _hovered = false) : null,
      child: AnimatedScale(
        scale: hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Material(
          color: baseColor,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            hoverColor: Colors.white.withValues(alpha: .05),
            child: Stack(
              children: [
                if (wallpaper != null)
                  Positioned.fill(
                    child: Image.file(wallpaper, fit: BoxFit.cover),
                  ),
                if (wallpaper != null)
                  // Voile pour garder le contenu de la carte lisible
                  // par-dessus une image arbitraire choisie par
                  // l'utilisateur.
                  Positioned.fill(
                    child: ColoredBox(
                      color: AppColors.surfaceElevated.withValues(
                        alpha: AppWallpapers.dimming,
                      ),
                    ),
                  ),
                AnimatedContainer(
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
                          : accentColor?.withValues(alpha: .6) ??
                                AppColors.border,
                      width: widget.selected
                          ? 1.4
                          : accentColor != null
                          ? 1.4
                          : 1,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
