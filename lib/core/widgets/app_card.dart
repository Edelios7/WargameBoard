import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/customization_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_wallpapers.dart';
import 'customization_edit_badge.dart';

/// Carte de base de l'app. Quand [onTap] est fourni (carte "ouvrable" —
/// navigation, sélection, dialogue...), elle grossit légèrement et
/// s'éclaircit au survol de la souris pour signaler clairement qu'elle
/// est interactive — voir aussi [Hoverable] pour habiller un widget qui
/// n'est pas déjà une AppCard.
class AppCard extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool selected;

  /// Fond d'écran à utiliser à la place de [AppWallpapers.cards] — pour
  /// les cartes qui ont leur propre emplacement dédié dans la page
  /// Personnalisation (ex. la bannière d'accueil du Dashboard, qui lit
  /// [AppWallpapers.banner]) plutôt que le réglage générique "Cartes".
  final File? wallpaperOverride;

  /// Teinte de fond optionnelle (ex. la couleur de faction d'une armée) —
  /// mélangée à la couleur de fond habituelle et remplit toute la carte
  /// (pas juste la bordure), pour que la couleur identifie clairement la
  /// carte au premier coup d'œil. Ignorée si un fond d'écran (image) est
  /// actif : les deux se superposeraient mal.
  final Color? accentColor;

  /// Identifiant [CustomizationIds] de ce bloc — si fourni, la carte peut
  /// recevoir une surcharge de fond (image ou couleur) propre en mode
  /// personnalisation, prioritaire sur [wallpaperOverride]/[accentColor]/
  /// [AppWallpapers.cards], et affiche le badge d'édition correspondant
  /// (voir [CustomizationEditBadge]) tant que ce mode est actif. Laisser à
  /// `null` pour les cartes générées en liste (résultats de recherche,
  /// unités, entrées de collection...) qui ne doivent jamais afficher ce
  /// badge.
  final String? customizationId;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
    this.selected = false,
    this.wallpaperOverride,
    this.accentColor,
    this.customizationId,
  });

  @override
  ConsumerState<AppCard> createState() => _AppCardState();
}

class _AppCardState extends ConsumerState<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.onTap != null;
    final hovered = interactive && _hovered;
    final customizationId = widget.customizationId;
    final blockOverride = customizationId != null
        ? ref.watch(blockOverrideProvider(customizationId))
        : null;
    final wallpaper =
        blockOverride?.image ?? widget.wallpaperOverride ?? AppWallpapers.cards;
    final accentColor = wallpaper != null
        ? null
        : blockOverride?.color ?? widget.accentColor;
    final baseColor = wallpaper != null
        ? null
        : accentColor == null
        ? AppColors.surfaceElevated
        : Color.alphaBlend(
            accentColor.withValues(alpha: hovered ? .28 : .20),
            AppColors.surfaceElevated,
          );
    final showEditBadge =
        customizationId != null && ref.watch(customizationModeProvider);

    // La bordure/le fond/l'ombre vivent sur ces widgets externes (pas sur
    // un enfant du Stack plus bas) car Stack donne à ses enfants non
    // positionnés des contraintes "loose" — même quand le Stack lui-même
    // remplit toute la carte, un enfant sans taille explicite ne se
    // dimensionne que sur son contenu (le texte), laissant un grand
    // rectangle vide autour d'une "case" trop petite. Material/DecoratedBox
    // eux prennent toujours exactement la taille donnée par leur parent
    // (que la carte remplisse une case de grille ou s'ajuste à son
    // contenu ailleurs dans l'appli), donc la couleur/bordure suit
    // toujours la vraie taille de la carte.
    // Le badge d'édition vit dans ce Stack externe (non clippé), pas dans
    // celui à l'intérieur du Material plus bas : ce dernier a
    // clipBehavior: Clip.antiAlias pour ses coins arrondis, qui coupait
    // net un badge positionné en négatif (-6,-6) — il ne se voyait
    // quasiment jamais.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MouseRegion(
          onEnter: interactive ? (_) => setState(() => _hovered = true) : null,
          onExit: interactive ? (_) => setState(() => _hovered = false) : null,
          child: AnimatedScale(
            scale: hovered ? 1.02 : 1,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
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
              child: Material(
                color: baseColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
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
                ),
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
                      Padding(padding: widget.padding, child: widget.child),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showEditBadge)
          Positioned(
            right: -8,
            bottom: -8,
            child: CustomizationEditBadge(id: customizationId),
          ),
      ],
    );
  }
}
