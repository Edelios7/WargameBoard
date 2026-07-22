import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

/// Gère la photo personnelle d'une fiche (les figurines peintes du
/// joueur) : sélection via l'explorateur de fichiers, copie dans
/// local_assets/user_photos/ selon la même convention de nommage que
/// [LocalCatalogImages] (id + extension), suppression.
class UserPhotoService {
  const UserPhotoService();

  static const _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  Directory get _folder =>
      Directory(p.join(Directory.current.path, 'local_assets', 'user_photos'));

  /// Ouvre le sélecteur de fichiers ; si l'utilisateur choisit une image,
  /// la copie dans `local_assets/user_photos/<datasheetId>.<ext>` (après
  /// avoir supprimé toute photo existante pour cette fiche, y compris
  /// sous une autre extension) et retourne le nouveau fichier. `null` si
  /// l'utilisateur annule.
  Future<File?> pickAndSave(String datasheetId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Choisir une photo',
    );
    final path = result?.files.single.path;
    if (path == null) return null;

    await remove(datasheetId);
    await _folder.create(recursive: true);

    final extension = p.extension(path).replaceFirst('.', '').toLowerCase();
    final destination = File(p.join(_folder.path, '$datasheetId.$extension'));
    return File(path).copy(destination.path);
  }

  /// Supprime la photo personnelle existante pour cette fiche, quelle
  /// que soit son extension.
  Future<void> remove(String datasheetId) async {
    if (!_folder.existsSync()) return;
    for (final extension in _extensions) {
      final file = File(p.join(_folder.path, '$datasheetId.$extension'));
      if (file.existsSync()) await file.delete();
    }
  }
}
