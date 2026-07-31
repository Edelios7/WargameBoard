import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/user_photo_provider.dart';
import '../theme/app_colors.dart';
import '../utils/local_catalog_images.dart';

/// Vignette d'une fiche (datasheet) avec, en overlay, un bouton pour
/// choisir/retirer une photo personnelle des figurines du joueur — voir
/// local_assets/user_photos/README.md. Affiche la photo perso si elle
/// existe, sinon le visuel catalogue générique, sinon une icône neutre.
///
/// Si [entryId] est fourni (contexte Collection), la photo choisie est
/// propre à cette entrée précise en plus de devenir la photo par défaut
/// du type d'unité — voir [UserPhotoService.pickAndSave].
class UnitPhotoThumbnail extends ConsumerStatefulWidget {
  final String datasheetId;
  final String? entryId;
  final double size;

  /// Dimensions à utiliser à la place de [size] si le contexte n'est pas
  /// carré (ex. un bandeau plein-largeur) — chacune repasse sur [size]
  /// si non fournie.
  final double? width;
  final double? height;

  final BorderRadius borderRadius;

  /// Visuel affiché tant qu'aucune photo (perso ou catalogue) n'existe —
  /// par défaut une icône neutre. Les écrans qui ont déjà un visuel de
  /// repli plus riche (ex. l'Army Builder, voir `UnitFallbackVisual`)
  /// peuvent le passer ici pour ne pas perdre cette information dès
  /// qu'une photo perso est proposée.
  final Widget? fallback;

  /// Affiche ou non le bouton d'édition (choisir/retirer) en overlay.
  /// À désactiver dans les contextes où la vignette est elle-même
  /// glissée (`Draggable`) — le bouton interactif entrerait en conflit
  /// avec le geste de glisser-déposer.
  final bool editable;

  const UnitPhotoThumbnail({
    super.key,
    required this.datasheetId,
    this.entryId,
    this.size = 56,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.fallback,
    this.editable = true,
  });

  @override
  ConsumerState<UnitPhotoThumbnail> createState() => _UnitPhotoThumbnailState();
}

class _UnitPhotoThumbnailState extends ConsumerState<UnitPhotoThumbnail> {
  bool _busy = false;

  Future<void> _choosePhoto() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(userPhotoServiceProvider)
          .pickAndSave(widget.datasheetId, entryId: widget.entryId);
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.collectionPhotoSaveError)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removePhoto() async {
    final service = ref.read(userPhotoServiceProvider);
    final entryId = widget.entryId;
    if (entryId != null) {
      await service.removeEntry(entryId);
    } else {
      await service.remove(widget.datasheetId);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entryId = widget.entryId;
    final userFile = entryId != null
        ? LocalCatalogImages.entryPhoto(entryId)
        : LocalCatalogImages.userPhoto(widget.datasheetId);
    final displayFile = entryId != null
        ? LocalCatalogImages.collectionPhoto(widget.datasheetId, entryId)
        : LocalCatalogImages.unitPhoto(widget.datasheetId);

    final effectiveWidth = widget.width ?? widget.size;
    final effectiveHeight = widget.height ?? widget.size;

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius,
            child: Container(
              width: effectiveWidth,
              height: effectiveHeight,
              color: AppColors.surfaceElevated,
              child: displayFile != null
                  ? Image.file(displayFile, fit: BoxFit.cover)
                  : widget.fallback ??
                        Icon(
                          Icons.shield_outlined,
                          color: AppColors.textSecondary,
                          size: widget.size * 0.5,
                        ),
            ),
          ),
          if (widget.editable)
            Positioned(
              right: -6,
              bottom: -6,
              child: PopupMenuButton<String>(
                tooltip: l10n.collectionPhotoTooltip,
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == 'choose') _choosePhoto();
                  if (value == 'remove') _removePhoto();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'choose',
                    child: Text(l10n.collectionChoosePhoto),
                  ),
                  if (userFile != null)
                    PopupMenuItem(
                      value: 'remove',
                      child: Text(l10n.collectionRemovePhoto),
                    ),
                ],
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: _busy
                      ? const Padding(
                          padding: EdgeInsets.all(4),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
