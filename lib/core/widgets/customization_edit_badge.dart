import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/customization/widgets/hsv_color_picker.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/customization_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_dialog_shortcuts.dart';

/// Petit bouton d'édition affiché en overlay sur un bloc ou une page, visible
/// uniquement en mode personnalisation (voir [customizationModeProvider]) —
/// permet de choisir une image ou une couleur de fond propre à [id]
/// (identifiant [CustomizationIds]), ou de réinitialiser. Même gabarit que
/// le bouton photo de `UnitPhotoThumbnail`, icône différente pour ne pas les
/// confondre.
class CustomizationEditBadge extends ConsumerStatefulWidget {
  final String id;
  final double size;

  const CustomizationEditBadge({super.key, required this.id, this.size = 32});

  @override
  ConsumerState<CustomizationEditBadge> createState() =>
      _CustomizationEditBadgeState();
}

class _CustomizationEditBadgeState
    extends ConsumerState<CustomizationEditBadge> {
  bool _busy = false;

  Future<void> _chooseImage() async {
    setState(() => _busy = true);
    try {
      final ok = await ref
          .read(customizationServiceProvider)
          .pickAndSetBlockImage(widget.id);
      if (ok) {
        ref.read(themeVersionProvider.notifier).state++;
      } else if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.customizationUnsupportedFormat)),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseColor() async {
    final l10n = AppLocalizations.of(context)!;
    final current = ref.read(blockOverrideProvider(widget.id));
    final initial = current?.color ?? AppColors.primary;
    var picked = initial;

    final chosen = await showDialog<Color>(
      context: context,
      builder: (dialogContext) => AppDialogShortcuts(
        child: AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(l10n.blockEditChooseColor, style: AppTextStyles.title),
          content: SizedBox(
            width: 280,
            child: HsvColorPicker(
              initialColor: initial,
              onChanged: (color) => picked = color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.armyBuilderCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () => Navigator.of(dialogContext).pop(picked),
              child: Text(l10n.blockEditApply),
            ),
          ],
        ),
      ),
    );
    if (chosen == null) return;

    await ref
        .read(customizationServiceProvider)
        .setBlockColor(widget.id, chosen);
    ref.read(themeVersionProvider.notifier).state++;
  }

  Future<void> _reset() async {
    await ref.read(customizationServiceProvider).clearBlockOverride(widget.id);
    ref.read(themeVersionProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final override = ref.watch(blockOverrideProvider(widget.id));
    final hasOverride =
        override != null && (override.image != null || override.color != null);

    return PopupMenuButton<String>(
      tooltip: l10n.blockEditTooltip,
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'image') _chooseImage();
        if (value == 'color') _chooseColor();
        if (value == 'reset') _reset();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'image',
          child: Text(l10n.customizationChooseImage),
        ),
        PopupMenuItem(value: 'color', child: Text(l10n.blockEditChooseColor)),
        if (hasOverride)
          PopupMenuItem(value: 'reset', child: Text(l10n.blockEditReset)),
      ],
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: _busy
            ? Padding(
                padding: EdgeInsets.all(widget.size * 0.2),
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Icon(
                Icons.palette_outlined,
                size: widget.size * 0.6,
                color: Colors.white,
              ),
      ),
    );
  }
}
