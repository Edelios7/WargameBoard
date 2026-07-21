import 'package:flutter/material.dart';

import '../utils/faction_iconography.dart';
import '../utils/local_catalog_images.dart';

/// Petit badge rond affichant le visuel d'une faction : l'image locale
/// recadrée depuis local_assets/factions/<id>.png si elle existe (jamais
/// commitée, voir le README de ce dossier), sinon le pictogramme
/// générique dessiné à la main ([FactionIconography]) pour ne pas
/// dépendre d'images sur une machine où elles ne sont pas présentes.
class FactionBadgeIcon extends StatelessWidget {
  final String factionName;
  final String? factionId;
  final double size;

  const FactionBadgeIcon({
    super.key,
    required this.factionName,
    this.factionId,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    final imageFile = factionId != null
        ? LocalCatalogImages.faction(factionId!)
        : null;
    if (imageFile != null) {
      return ClipOval(
        child: Image.file(
          imageFile,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }

    final badge = FactionIconography.forFaction(factionName);
    final glyphSize = size * 0.6;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: badge.glyphBuilder != null
          ? badge.glyphBuilder!(glyphSize, badge.color)
          : Icon(badge.icon, size: size * 0.55, color: badge.color),
    );
  }
}
