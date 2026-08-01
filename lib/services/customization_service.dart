import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_wallpapers.dart';
import '../core/utils/user_content_paths.dart';

const String accentColorPreferenceKey = 'customization_accent_color';
const String wallpaperDimmingPreferenceKey = 'customization_wallpaper_dimming';

String _wallpaperPreferenceKey(WallpaperSlot slot) =>
    'customization_wallpaper_${slot.name}';

/// Applique et persiste la couleur d'accent et les fonds d'écran choisis
/// par l'utilisateur (page Personnalisation). Mute directement les
/// statics [AppColors]/[AppWallpapers] — voir leurs commentaires pour
/// pourquoi ce n'est pas passé par Riverpod/Theme.of comme le reste de
/// l'appli aurait dû être conçu dès le départ pour être vraiment
/// personnalisable, mais reprendre chaque écran maintenant serait un
/// chantier disproportionné par rapport à la demande.
class CustomizationService {
  final SharedPreferences prefs;

  const CustomizationService(this.prefs);

  static const _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  Directory get _wallpapersFolder => Directory(
    p.join(UserContentPaths.baseDirectory, 'local_assets', 'wallpapers'),
  );

  /// Recharge la couleur d'accent et les fonds d'écran déjà persistés —
  /// à appeler une fois au démarrage (voir main.dart), avant `runApp`, pour
  /// que le premier rendu reflète déjà les réglages du joueur au lieu de
  /// clignoter entre les valeurs par défaut et les siennes.
  void loadIntoStatics() {
    final colorValue = prefs.getInt(accentColorPreferenceKey);
    if (colorValue != null) {
      AppColors.applyAccent(Color(colorValue));
    }
    for (final slot in WallpaperSlot.values) {
      final path = prefs.getString(_wallpaperPreferenceKey(slot));
      if (path != null && File(path).existsSync()) {
        AppWallpapers.setSlot(slot, File(path));
      }
    }
    final dimming = prefs.getDouble(wallpaperDimmingPreferenceKey);
    if (dimming != null) {
      AppWallpapers.dimming = dimming;
    }
  }

  Future<void> setWallpaperDimming(double value) async {
    AppWallpapers.dimming = value;
    await prefs.setDouble(wallpaperDimmingPreferenceKey, value);
  }

  /// Remet la couleur d'accent et les 4 fonds d'écran à zéro en un seul
  /// geste — plus pratique que de devoir retirer chaque zone une par une
  /// pour repartir de la présentation par défaut.
  Future<void> resetAll() async {
    await resetAccentColor();
    for (final slot in WallpaperSlot.values) {
      await clearWallpaper(slot);
    }
    await setWallpaperDimming(0.78);
  }

  Future<void> setAccentColor(Color color) async {
    AppColors.applyAccent(color);
    await prefs.setInt(accentColorPreferenceKey, color.toARGB32());
  }

  Future<void> resetAccentColor() async {
    AppColors.resetAccent();
    await prefs.remove(accentColorPreferenceKey);
  }

  /// Ouvre le sélecteur de fichiers ; si l'utilisateur choisit une image,
  /// la copie dans le dossier applicatif (comme [UserPhotoService], même
  /// convention) et l'applique à `slot`. Retourne `false` si l'utilisateur
  /// annule ou si le format n'est pas pris en charge.
  Future<bool> pickAndSetWallpaper(WallpaperSlot slot) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      dialogTitle: 'Choisir une image',
    );
    final sourcePath = result?.files.single.path;
    if (sourcePath == null) return false;

    final extension = p
        .extension(sourcePath)
        .replaceFirst('.', '')
        .toLowerCase();
    if (!_extensions.contains(extension)) return false;

    await _wallpapersFolder.create(recursive: true);
    final destination = File(
      p.join(_wallpapersFolder.path, '${slot.name}.$extension'),
    );
    // Retire d'anciennes versions à extension différente pour ce même
    // emplacement, sinon la précédente resterait sur le disque sans être
    // jamais relue (fichier orphelin) et gonflerait le dossier au fil du
    // temps.
    await _removeWallpaperFiles(slot);
    final saved = await File(sourcePath).copy(destination.path);

    AppWallpapers.setSlot(slot, saved);
    await prefs.setString(_wallpaperPreferenceKey(slot), saved.path);
    return true;
  }

  Future<void> clearWallpaper(WallpaperSlot slot) async {
    await _removeWallpaperFiles(slot);
    AppWallpapers.setSlot(slot, null);
    await prefs.remove(_wallpaperPreferenceKey(slot));
  }

  Future<void> _removeWallpaperFiles(WallpaperSlot slot) async {
    if (!_wallpapersFolder.existsSync()) return;
    for (final extension in _extensions) {
      final file = File(
        p.join(_wallpapersFolder.path, '${slot.name}.$extension'),
      );
      if (file.existsSync()) await file.delete();
    }
  }

  /// Sérialise la couleur d'accent, l'intensité du voile et chaque fond
  /// d'écran (image encodée en base64, embarquée directement plutôt que
  /// juste son chemin — un chemin local n'aurait aucun sens une fois
  /// restauré sur une autre machine) — voir [BackupService], qui écrit ce
  /// résultat à côté de la sauvegarde de la base de données. La base
  /// elle-même ne connaît pas ces réglages : ils vivent dans
  /// SharedPreferences, un stockage séparé.
  Future<Map<String, dynamic>> exportSettings() async {
    final wallpapers = <String, dynamic>{};
    for (final slot in WallpaperSlot.values) {
      final file = AppWallpapers.forSlot(slot);
      if (file == null) continue;
      wallpapers[slot.name] = {
        'extension': p.extension(file.path).replaceFirst('.', ''),
        'bytes': base64Encode(await file.readAsBytes()),
      };
    }
    return {
      'accentColor': AppColors.primary.toARGB32(),
      'wallpaperDimming': AppWallpapers.dimming,
      'wallpapers': wallpapers,
    };
  }

  /// Réapplique un export produit par [exportSettings] — utilisé par
  /// [BackupService.stageRestore] quand une sauvegarde a un fichier de
  /// réglages associé. Contrairement à la restauration de la base (mise en
  /// attente jusqu'au prochain lancement, voir [BackupService]), ces
  /// réglages vivent dans SharedPreferences, pas dans la base verrouillée
  /// par la connexion Drift active : rien n'empêche de les appliquer tout
  /// de suite.
  Future<void> importSettings(Map<String, dynamic> data) async {
    final accentColor = data['accentColor'];
    if (accentColor is int) {
      await setAccentColor(Color(accentColor));
    }
    final dimming = data['wallpaperDimming'];
    if (dimming is num) {
      await setWallpaperDimming(dimming.toDouble());
    }
    final wallpapers = data['wallpapers'];
    if (wallpapers is Map) {
      await _wallpapersFolder.create(recursive: true);
      for (final slot in WallpaperSlot.values) {
        final entry = wallpapers[slot.name];
        if (entry is! Map) continue;
        final extension = entry['extension'];
        final bytes = entry['bytes'];
        if (extension is! String || bytes is! String) continue;
        await _removeWallpaperFiles(slot);
        final destination = File(
          p.join(_wallpapersFolder.path, '${slot.name}.$extension'),
        );
        final saved = await destination.writeAsBytes(base64Decode(bytes));
        AppWallpapers.setSlot(slot, saved);
        await prefs.setString(_wallpaperPreferenceKey(slot), saved.path);
      }
    }
  }
}
