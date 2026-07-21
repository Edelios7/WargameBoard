import 'package:flutter/material.dart';

import '../utils/faction_iconography.dart';

/// Petit badge rond coloré affichant un pictogramme générique associé à
/// une faction (voir [FactionIconography]), pour habiller les listes
/// d'armées / de parties sans dépendre d'images.
class FactionBadgeIcon extends StatelessWidget {
  final String factionName;
  final double size;

  const FactionBadgeIcon({
    super.key,
    required this.factionName,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
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
