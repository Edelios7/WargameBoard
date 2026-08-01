import '../../core/theme/app_wallpapers.dart';

/// Instantané nommé d'une combinaison couleur d'accent + fonds d'écran +
/// intensité du voile, pour permettre de basculer rapidement entre
/// plusieurs looks déjà réglés sans devoir tout reconfigurer à la main.
/// Contrairement à [CustomizationService.exportSettings] (utilisé pour la
/// sauvegarde/restauration inter-machines), un préréglage référence juste
/// les chemins des fichiers déjà copiés dans le dossier applicatif —
/// aucune raison de dupliquer les octets tant qu'on reste sur la même
/// installation.
class ThemePreset {
  final String name;
  final int accentColor;
  final double wallpaperDimming;
  final Map<WallpaperSlot, String> wallpaperPaths;

  const ThemePreset({
    required this.name,
    required this.accentColor,
    required this.wallpaperDimming,
    required this.wallpaperPaths,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'accentColor': accentColor,
    'wallpaperDimming': wallpaperDimming,
    'wallpaperPaths': wallpaperPaths.map(
      (slot, path) => MapEntry(slot.name, path),
    ),
  };

  static ThemePreset? fromJson(Object? json) {
    if (json is! Map) return null;
    final name = json['name'];
    final accentColor = json['accentColor'];
    final dimming = json['wallpaperDimming'];
    if (name is! String || accentColor is! int || dimming is! num) {
      return null;
    }
    final wallpaperPaths = <WallpaperSlot, String>{};
    final rawPaths = json['wallpaperPaths'];
    if (rawPaths is Map) {
      for (final slot in WallpaperSlot.values) {
        final path = rawPaths[slot.name];
        if (path is String) wallpaperPaths[slot] = path;
      }
    }
    return ThemePreset(
      name: name,
      accentColor: accentColor,
      wallpaperDimming: dimming.toDouble(),
      wallpaperPaths: wallpaperPaths,
    );
  }
}
