import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_wallpapers.dart';
import '../core/utils/user_content_paths.dart';

const String accentColorPreferenceKey = 'customization_accent_color';

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
}
