import 'package:flutter/material.dart';

import '../../domain/catalog/common/unit_archetype.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Petit signe distinctif rond indiquant l'archétype de jeu estimé d'une
/// unité (Horde/Élite/Blindé-Monstre/Spécialiste anti-char/Soutien, voir
/// [UnitArchetype]) — affiché en médaillon sur la vignette du catalogue,
/// et en badge nommé sur le détail d'une fiche via [ArchetypeChip].
class ArchetypeBadge extends StatelessWidget {
  final UnitArchetype archetype;
  final double size;

  const ArchetypeBadge({super.key, required this.archetype, this.size = 22});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = kArchetypeInfo[archetype]!;
    return Tooltip(
      message: archetypeName(l10n, archetype),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.2),
        ),
        child: Icon(info.icon, size: size * 0.6, color: AppColors.primary),
      ),
    );
  }
}

/// Version "chip" nommée du même signe distinctif, pour un en-tête de
/// fiche détaillée où il y a la place d'afficher le nom en toutes lettres.
class ArchetypeChip extends StatelessWidget {
  final UnitArchetype archetype;

  const ArchetypeChip({super.key, required this.archetype});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = kArchetypeInfo[archetype]!;
    return Tooltip(
      message: info.blurb,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.primary.withValues(alpha: .4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(info.icon, size: 13, color: AppColors.primaryLight),
            const SizedBox(width: 5),
            Text(
              archetypeName(l10n, archetype),
              style: AppTextStyles.eyebrow.copyWith(
                color: AppColors.primaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
