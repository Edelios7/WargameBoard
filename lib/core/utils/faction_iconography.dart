import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Icône + couleur d'accent associées à une faction, pour habiller les
/// listes d'armées / parties du Dashboard sans dépendre d'images.
///
/// Ce sont des pictogrammes génériques (Material Icons) choisis pour
/// évoquer chaque faction, pas les logos officiels Games Workshop : on
/// reste dans l'esprit de la charte sans reproduire leurs marques.
class FactionBadge {
  final IconData icon;
  final Color color;

  const FactionBadge(this.icon, this.color);
}

class FactionIconography {
  FactionIconography._();

  static final List<MapEntry<String, FactionBadge>> _entries = [
    MapEntry('blood angels', FactionBadge(Icons.water_drop_rounded, AppColors.error)),
    MapEntry('dark angels', FactionBadge(Icons.nightlight_round, Color(0xFF2E7D5B))),
    MapEntry('space wolves', FactionBadge(Icons.pets_rounded, Color(0xFF6FB7E8))),
    MapEntry('imperial fists', FactionBadge(Icons.shield_rounded, AppColors.warning)),
    MapEntry('ultramarines', FactionBadge(Icons.shield_rounded, AppColors.info)),
    MapEntry('black templars', FactionBadge(Icons.gavel_rounded, Colors.white70)),
    MapEntry('deathwatch', FactionBadge(Icons.remove_red_eye_rounded, Color(0xFF9AA3AD))),
    MapEntry('salamanders', FactionBadge(Icons.local_fire_department_rounded, AppColors.error)),
    MapEntry('raven guard', FactionBadge(Icons.flight_rounded, Color(0xFF9AA3AD))),
    MapEntry('space marines', FactionBadge(Icons.shield_rounded, AppColors.info)),
    MapEntry('adeptus custodes', FactionBadge(Icons.military_tech_rounded, AppColors.warning)),
    MapEntry('adeptus mechanicus', FactionBadge(Icons.precision_manufacturing_rounded, Color(0xFFC0682B))),
    MapEntry('adepta sororitas', FactionBadge(Icons.local_fire_department_rounded, AppColors.error)),
    MapEntry('astra militarum', FactionBadge(Icons.groups_rounded, Color(0xFF8A9A5B))),
    MapEntry('imperial guard', FactionBadge(Icons.groups_rounded, Color(0xFF8A9A5B))),
    MapEntry('grey knights', FactionBadge(Icons.security_rounded, Color(0xFFB8C4CE))),
    MapEntry('imperial knights', FactionBadge(Icons.castle_rounded, Color(0xFF6D6F86))),
    MapEntry('chaos knights', FactionBadge(Icons.castle_rounded, AppColors.error)),
    MapEntry('orks', FactionBadge(Icons.forest_rounded, AppColors.success)),
    MapEntry('tyranids', FactionBadge(Icons.bug_report_rounded, Color(0xFF8E4FBF))),
    MapEntry('necrons', FactionBadge(Icons.settings_suggest_rounded, Color(0xFF3FBFA6))),
    MapEntry('aeldari', FactionBadge(Icons.auto_awesome_rounded, Color(0xFF3FBFA6))),
    MapEntry('eldar', FactionBadge(Icons.auto_awesome_rounded, Color(0xFF3FBFA6))),
    MapEntry('drukhari', FactionBadge(Icons.dark_mode_rounded, Color(0xFF7A4FBF))),
    MapEntry('t\'au', FactionBadge(Icons.rocket_launch_rounded, Color(0xFFE0813F))),
    MapEntry('tau empire', FactionBadge(Icons.rocket_launch_rounded, Color(0xFFE0813F))),
    MapEntry('genestealer cults', FactionBadge(Icons.bug_report_rounded, Color(0xFFB0475B))),
    MapEntry('leagues of votann', FactionBadge(Icons.construction_rounded, Color(0xFFC49A3A))),
    MapEntry('death guard', FactionBadge(Icons.coronavirus_rounded, Color(0xFF6E8A4A))),
    MapEntry('thousand sons', FactionBadge(Icons.local_fire_department_rounded, AppColors.info)),
    MapEntry('world eaters', FactionBadge(Icons.bolt_rounded, AppColors.error)),
    MapEntry('emperor\'s children', FactionBadge(Icons.music_note_rounded, Color(0xFFC85FA8))),
    MapEntry('alpha legion', FactionBadge(Icons.change_history_rounded, AppColors.success)),
    MapEntry('iron warriors', FactionBadge(Icons.fort_rounded, Color(0xFF9AA3AD))),
    MapEntry('chaos space marines', FactionBadge(Icons.whatshot_rounded, AppColors.error)),
    MapEntry('nurgle', FactionBadge(Icons.coronavirus_rounded, AppColors.success)),
    MapEntry('slaanesh', FactionBadge(Icons.auto_awesome_rounded, Color(0xFFC85FA8))),
    MapEntry('tzeentch', FactionBadge(Icons.local_fire_department_rounded, AppColors.info)),
    MapEntry('khorne', FactionBadge(Icons.bolt_rounded, AppColors.error)),
    MapEntry('chaos daemons', FactionBadge(Icons.whatshot_rounded, Color(0xFF7A4FBF))),
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
