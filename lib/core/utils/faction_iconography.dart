import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/faction_glyph_icon.dart';
import '../widgets/ork_head_icon.dart';

/// Icône + couleur d'accent associées à une faction, pour habiller les
/// listes d'armées / parties du Dashboard sans dépendre d'images.
///
/// Ce sont des pictogrammes génériques (Material Icons, ou un glyphe
/// dessiné à la main pour les archétypes qui le justifient, comme les
/// Orks) choisis pour évoquer chaque faction, pas les logos officiels
/// Games Workshop : on reste dans l'esprit de la charte sans reproduire
/// leurs marques.
class FactionBadge {
  final IconData icon;
  final Color color;

  /// Glyphe dessiné à la main à utiliser à la place de [icon] quand fourni.
  final Widget Function(double size, Color color)? glyphBuilder;

  const FactionBadge(this.icon, this.color, {this.glyphBuilder});
}

FactionBadge _glyph(GlyphKind kind, Color color, {IconData fallback = Icons.shield_outlined}) {
  return FactionBadge(
    fallback,
    color,
    glyphBuilder: (size, glyphColor) =>
        FactionGlyphIcon(kind: kind, size: size, color: glyphColor),
  );
}

class FactionIconography {
  FactionIconography._();

  static final List<MapEntry<String, FactionBadge>> _entries = [
    MapEntry('blood angels', FactionBadge(Icons.water_drop_rounded, AppColors.error)),
    MapEntry('dark angels', FactionBadge(Icons.nightlight_round, Color(0xFF2E7D5B))),
    MapEntry('space wolves', _glyph(GlyphKind.wolfHead, Color(0xFF6FB7E8))),
    MapEntry('imperial fists', _glyph(GlyphKind.fist, AppColors.warning)),
    MapEntry('black templars', _glyph(GlyphKind.sword, Colors.white70)),
    MapEntry('deathwatch', FactionBadge(Icons.remove_red_eye_rounded, Color(0xFF9AA3AD))),
    MapEntry('salamanders', _glyph(GlyphKind.lizard, Color(0xFF2FBF71))),
    MapEntry('raven guard', _glyph(GlyphKind.raven, Color(0xFF9AA3AD))),
    MapEntry('ultramarines', _glyph(GlyphKind.helmet, AppColors.info)),
    MapEntry('astra militarum', _glyph(GlyphKind.helmet, Color(0xFF8A9A5B))),
    MapEntry('imperial guard', _glyph(GlyphKind.helmet, Color(0xFF8A9A5B))),
    MapEntry('space marines', _glyph(GlyphKind.helmet, AppColors.info)),
    MapEntry('adeptus custodes', _glyph(GlyphKind.spear, AppColors.warning)),
    MapEntry('adeptus mechanicus', FactionBadge(Icons.precision_manufacturing_rounded, Color(0xFFC0682B))),
    MapEntry('adepta sororitas', _glyph(GlyphKind.chalice, AppColors.error)),
    MapEntry('grey knights', FactionBadge(Icons.security_rounded, Color(0xFFB8C4CE))),
    MapEntry('imperial knights', _glyph(GlyphKind.knightMech, Color(0xFF6D6F86))),
    MapEntry('chaos knights', _glyph(GlyphKind.knightMech, AppColors.error)),
    MapEntry('orks', FactionBadge(
      Icons.forest_rounded,
      AppColors.success,
      glyphBuilder: (size, color) => OrkHeadIcon(size: size, color: color),
    )),
    MapEntry('tyranids', _glyph(GlyphKind.claw, Color(0xFF8E4FBF))),
    MapEntry('genestealer cults', _glyph(GlyphKind.claw, Color(0xFFB0475B))),
    MapEntry('necrons', _glyph(GlyphKind.robotSkull, Color(0xFF3FBFA6))),
    MapEntry('aeldari', FactionBadge(Icons.auto_awesome_rounded, Color(0xFF3FBFA6))),
    MapEntry('eldar', FactionBadge(Icons.auto_awesome_rounded, Color(0xFF3FBFA6))),
    MapEntry('drukhari', _glyph(GlyphKind.dagger, Color(0xFF7A4FBF))),
    MapEntry('t\'au', FactionBadge(Icons.rocket_launch_rounded, Color(0xFFE0813F))),
    MapEntry('tau empire', FactionBadge(Icons.rocket_launch_rounded, Color(0xFFE0813F))),
    MapEntry('leagues of votann', _glyph(GlyphKind.anvil, Color(0xFFC49A3A))),
    MapEntry('death guard', _glyph(GlyphKind.plagueSkull, Color(0xFF6E8A4A))),
    MapEntry('nurgle', _glyph(GlyphKind.plagueSkull, AppColors.success)),
    MapEntry('thousand sons', _glyph(GlyphKind.flameEye, AppColors.info)),
    MapEntry('tzeentch', _glyph(GlyphKind.flameEye, Color(0xFF8E4FBF))),
    MapEntry('world eaters', _glyph(GlyphKind.axe, AppColors.error)),
    MapEntry('khorne', _glyph(GlyphKind.axe, Color(0xFFB0332F))),
    MapEntry('emperor\'s children', _glyph(GlyphKind.mask, Color(0xFFC85FA8))),
    MapEntry('slaanesh', _glyph(GlyphKind.mask, Color(0xFFC85FA8))),
    MapEntry('alpha legion', _glyph(GlyphKind.hydra, AppColors.success)),
    MapEntry('iron warriors', FactionBadge(Icons.fort_rounded, Color(0xFF9AA3AD))),
    MapEntry('chaos space marines', _glyph(GlyphKind.hornedSkull, AppColors.error)),
    MapEntry('chaos daemons', _glyph(GlyphKind.hornedSkull, Color(0xFF7A4FBF))),
  ];

  static const List<Color> _fallbackPalette = [
    AppColors.primary,
    AppColors.info,
    AppColors.success,
    AppColors.warning,
    Color(0xFF8E4FBF),
    Color(0xFF3FBFA6),
  ];

  /// Retourne l'icône + couleur associées au nom de faction donné (recherche
  /// insensible à la casse par sous-chaîne). Si aucune entrée connue ne
  /// correspond, retourne une icône générique avec une couleur choisie de
  /// façon stable à partir du nom (pour rester visuellement distincte
  /// d'une faction à l'autre sans être aléatoire à chaque rebuild).
  static FactionBadge forFaction(String factionName) {
    final normalized = factionName.toLowerCase();
    for (final entry in _entries) {
      if (normalized.contains(entry.key)) return entry.value;
    }
    final color = _fallbackPalette[factionName.hashCode.abs() % _fallbackPalette.length];
    return FactionBadge(Icons.shield_outlined, color);
  }
}
