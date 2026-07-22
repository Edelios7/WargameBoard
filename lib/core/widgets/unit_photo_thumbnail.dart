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
class UnitPhotoThumbnail extends ConsumerStatefulWidget {
  final String datasheetId;
  final double size;
  final BorderRadius borderRadius;

  const UnitPhotoThumbnail({
    super.key,
    required this.datasheetId,
    this.size = 56,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  @override
  ConsumerState<UnitPhotoThumbnail> createState() => _UnitPhotoThumbnailState();
}

class _UnitPhotoThumbnailState extends ConsumerState<UnitPhotoThumbnail> {
  bool _busy = false;

  Future<void> _choosePhoto() async {
    setState(() => _busy = true);
    try {
      await ref.read(userPhotoServiceProvider).pickAndSave(widget.datasheetId);
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
    await ref.read(userPhotoServiceProvider).remove(widget.datasheetId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userFile = LocalCatalogImages.userPhoto(widget.datasheetId);
    final displayFile =
        userFile ?? LocalCatalogImages.datasheet(widget.datasheetId);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: widget.borderRadius,
            child: Container(
              width: widget.size,
              height: widget.size,
              color: AppColors.surfaceElevated,
              child: displayFile != null
                  ? Image.file(displayFile, fit: BoxFit.cover)
                  : Icon(
                      Icons.shield_outlined,
                      color: AppColors.textSecondary,
                      size: widget.size * 0.5,
                    ),
            ),
          ),
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
                decoration: const BoxDecoration(
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
