import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import '../core/utils/user_content_paths.dart';

/// Gère les photos personnelles des unités (les figurines peintes du
/// joueur) : sélection via l'explorateur de fichiers, copie dans
/// local_assets/user_photos/ selon la même convention de nommage que
/// [LocalCatalogImages] (id + extension), suppression.
///
/// Deux niveaux : la photo d'une entrée précise de la Collection (une
/// escouade en particulier, dans `user_photos/entries/`) et la photo par
/// défaut d'un type d'unité (dans `user_photos/`, utilisée partout où la
/// fiche est affichée hors Collection — Armées, Catalogue, Dashboard,
/// Bataille). Choisir une photo pour une entrée de Collection met aussi
/// à jour la photo par défaut du type d'unité, pour qu'elle se propage
/// immédiatement partout ; si plusieurs entrées de la même fiche ont
/// chacune leur propre photo, c'est la dernière choisie qui sert de
/// photo par défaut.
class UserPhotoService {
  const UserPhotoService();

  static const _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  Directory get _folder => Directory(
    p.join(UserContentPaths.baseDirectory, 'local_assets', 'user_photos'),
  );

  Directory get _entriesFolder =>
      Directory(p.join(_folder.path, 'entries'));

  /// Ouvre le sélecteur de fichiers ; si l'utilisateur choisit une image,
  /// la copie comme photo par défaut de `datasheetId` et, si `entryId`
  /// est fourni, aussi comme photo propre à cette entrée de Collection.
  /// Retourne le nouveau fichier de la fiche, `null` si l'utilisateur
  /// annule.
  Future<File?> pickAndSave(String datasheetId, {String? entryId}) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      dialogTitle: 'Choisir une photo',
    );
    final path = result?.files.single.path;
    if (path == null) return null;

    final datasheetFile = await _saveTo(_folder, datasheetId, path);
    if (entryId != null) {
      await _saveTo(_entriesFolder, entryId, path);
    }
    return datasheetFile;
  }

  Future<File> _saveTo(Directory folder, String id, String sourcePath) async {
    await _removeFrom(folder, id);
    await folder.create(recursive: true);
    final extension =
        p.extension(sourcePath).replaceFirst('.', '').toLowerCase();
    final destination = File(p.join(folder.path, '$id.$extension'));
    return File(sourcePath).copy(destination.path);
  }

  /// Supprime la photo par défaut existante pour cette fiche, quelle que
  /// soit son extension.
  Future<void> remove(String datasheetId) => _removeFrom(_folder, datasheetId);

  /// Supprime la photo propre à cette entrée de Collection (la photo par
  /// défaut du type d'unité n'est pas affectée).
  Future<void> removeEntry(String entryId) =>
      _removeFrom(_entriesFolder, entryId);

  Future<void> _removeFrom(Directory folder, String id) async {
    if (!folder.existsSync()) return;
    for (final extension in _extensions) {
      final file = File(p.join(folder.path, '$id.$extension'));
      if (file.existsSync()) await file.delete();
    }
  }
}
