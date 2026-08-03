import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/customization_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_wallpapers.dart';
import '../theme/customization_ids.dart';
import 'customization_edit_badge.dart';

/// Superpose la surcharge de fond propre à une page (`page.<pageId>`, voir
/// [CustomizationIds]) au-dessus de [child], au-dessus de laquelle rien
/// d'autre n'est affiché tant que le mode personnalisation n'est pas actif
/// ni qu'aucune surcharge n'existe — le fond d'écran global "Application"
/// (voir [AppWallpapers.app], géré par `AppShell`) continue alors de
/// s'afficher exactement comme avant, sans changement de comportement pour
/// les utilisateurs qui n'y touchent pas.
class PageBackground extends ConsumerWidget {
  final String pageId;
  final Widget child;

  const PageBackground({super.key, required this.pageId, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(blockOverrideProvider('page.$pageId'));
    final customizationMode = ref.watch(customizationModeProvider);

    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (override?.image != null)
          Positioned.fill(
            child: Image.file(override!.image!, fit: BoxFit.cover),
          ),
        if (override?.image != null)
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.background.withValues(
                alpha: AppWallpapers.dimming,
              ),
            ),
          )
        else if (override?.color != null)
          Positioned.fill(child: ColoredBox(color: override!.color!)),
        child,
        if (customizationMode)
          Positioned(
            right: 16,
            bottom: 16,
            child: CustomizationEditBadge(id: 'page.$pageId', size: 36),
          ),
      ],
    );
  }
}
