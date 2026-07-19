import 'dart:io';

import 'package:path/path.dart' as p;

/// Résout une image de référence locale pour une datasheet, si elle existe.
///
/// Ces images ne sont jamais commitées dans le dépôt (voir .gitignore) :
/// voir local_assets/datasheets/README.md pour la convention de nommage.
class LocalDatasheetImages {
  LocalDatasheetImages._();

  static const _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  static File? find(String datasheetId) {
    for (final extension in _extensions) {
      final file = File(
        p.join(
          Directory.current.path,
          'local_assets',
          'datasheets',
          '$datasheetId.$extension',
        ),
      );
      if (file.existsSync()) return file;
    }
    return null;
  }
}
