import 'package:flutter/material.dart';

/// Couleur d'accent distincte par faction, pour les repérer d'un coup
/// d'œil dans la liste et la barre d'accès rapide du catalogue.
class FactionColors {
  FactionColors._();

  static const Map<String, Color> _byId = {
    'fac-adepta-sororitas': Color(0xFFB8283D),
    'fac-adeptus-custodes': Color(0xFFD4AF37),
    'fac-adeptus-mechanicus': Color(0xFFC1440E),
    'fac-aeldari': Color(0xFF2E8B8B),
    'fac-agents-de-l-imperium': Color(0xFF9C8B7A),
    'fac-astra-militarum': Color(0xFF5A7D2E),
    'fac-black-templars': Color(0xFFE3E6EA),
    'fac-blood-angels': Color(0xFFC81E3A),
    'fac-chaos-daemons': Color(0xFF7B2D8E),
    'fac-chaos-knights': Color(0xFF8C3A3A),
    'fac-chaos-space-marines': Color(0xFF9C2B44),
    'fac-dark-angels': Color(0xFF1B4D3E),
    'fac-death-guard': Color(0xFF8F9779),
    'fac-deathwatch': Color(0xFF4A4F57),
    'fac-drukhari': Color(0xFF5B2C6F),
    'fac-genestealer-cults': Color(0xFFA23B72),
    'fac-grey-knights': Color(0xFFB8C4D8),
    'fac-imperial-knights': Color(0xFF335A8F),
    'fac-leagues-of-votann': Color(0xFFD97706),
    'fac-necrons': Color(0xFF00A86B),
    'fac-orks': Color(0xFF4A7729),
    'fac-space-marines-adeptus-astartes': Color(0xFF2255A4),
    'fac-space-wolves': Color(0xFF6C93A6),
    'fac-t-au-empire': Color(0xFFE07B39),
    'fac-thousand-sons': Color(0xFF3D5AFE),
    'fac-tyranids': Color(0xFFC2185B),
    'fac-world-eaters': Color(0xFFB33F1E),
  };

  // Palette de secours pour toute faction non listée ci-dessus (ex.
  // import futur) : choix déterministe par hash de l'id, pas aléatoire,
  // pour rester stable d'un lancement à l'autre.
  static const List<Color> _fallbackPalette = [
    Color(0xFFE8455F),
    Color(0xFF3D8BFD),
    Color(0xFF2FBF71),
    Color(0xFFE0A429),
    Color(0xFF8E6BC7),
    Color(0xFF3EC6C6),
    Color(0xFFE0435C),
    Color(0xFF9AA5B1),
  ];

  static Color of(String factionId) {
    final known = _byId[factionId];
    if (known != null) return known;
    final hash = factionId.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return _fallbackPalette[hash % _fallbackPalette.length];
  }

  /// Couleur de texte lisible par-dessus [background] (blanc ou
  /// quasi-noir selon la luminance), pour les badges pleins.
  static Color onColor(Color background) {
    return background.computeLuminance() > 0.45
        ? const Color(0xFF14171D)
        : Colors.white;
  }
}
