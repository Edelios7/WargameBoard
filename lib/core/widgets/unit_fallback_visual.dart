import 'package:flutter/material.dart';

import '../../domain/catalog/common/unit_archetype.dart';
import '../utils/faction_iconography.dart';

/// Icône de rôle à afficher au premier plan d'une carte d'unité sans
/// photo — dérivée de signaux réels (Warlord, Personnage, archétype de
/// jeu déjà calculé en base), jamais devinée au hasard.
///
/// Priorité : le Warlord se distingue de tout le reste de l'armée, un
/// Personnage se distingue d'une escouade, puis l'archétype (horde /
/// élite / blindé / anti-char / soutien — les mêmes icônes que le guide
/// "chaîne alimentaire" et le radar de profil d'armée, pour rester
/// cohérent visuellement dans toute l'appli) donne le dernier niveau de
/// précision quand la fiche est classée.
IconData unitRoleIcon({
  required bool isWarlord,
  required bool isCharacter,
  required UnitArchetype? archetype,
  required String battlefieldRole,
}) {
  if (isWarlord) return Icons.military_tech_rounded;
  if (isCharacter) return Icons.accessibility_new_rounded;
  if (archetype != null) return kArchetypeInfo[archetype]!.icon;

  final role = battlefieldRole.toLowerCase();
  if (role.contains('ligne') ||
      role.contains('troop') ||
      role.contains('battleline')) {
    return Icons.groups_rounded;
  }
  return Icons.shield_moon_rounded;
}

/// Visuel de repli d'une fiche sans photo : le glyphe de sa faction (déjà
/// utilisé ailleurs dans l'appli pour les badges d'armée/Dashboard) en
/// filigrane dans un coin, et une icône de rôle nette au centre — deux
/// axes de lecture (quelle faction / quel genre d'unité) au lieu d'un
/// même symbole neutre répété sur chaque carte.
class UnitFallbackVisual extends StatelessWidget {
  final String factionName;
  final IconData roleIcon;
  final double size;

  const UnitFallbackVisual({
    super.key,
    required this.factionName,
    required this.roleIcon,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    final badge = FactionIconography.forFaction(factionName);
    final glyphSize = size * 0.85;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          right: -glyphSize * 0.18,
          bottom: -glyphSize * 0.18,
          child: Opacity(
            opacity: .16,
            child: badge.glyphBuilder != null
                ? badge.glyphBuilder!(glyphSize, badge.color)
                : Icon(badge.icon, size: glyphSize, color: badge.color),
          ),
        ),
        Center(
          child: Icon(
            roleIcon,
            size: size * 0.36,
            color: badge.color.withValues(alpha: .92),
          ),
        ),
      ],
    );
  }
}
