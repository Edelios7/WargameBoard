import 'dart:io';

import 'package:path/path.dart' as p;

/// Résout une image de référence locale (datasheet, faction...) si elle
/// existe.
///
/// Ces images ne sont jamais commitées dans le dépôt (voir .gitignore) :
/// voir local_assets/datasheets/README.md pour la convention de nommage.
class LocalCatalogImages {
  LocalCatalogImages._();

  static const _extensions = ['png', 'jpg', 'jpeg', 'webp'];

  static File? _find(String folder, String id) {
    for (final extension in _extensions) {
      final file = File(
        p.join(Directory.current.path, 'local_assets', folder, '$id.$extension'),
      );
      if (file.existsSync()) return file;
    }
    return null;
  }

  static File? datasheet(String datasheetId) => _find('datasheets', datasheetId);

  static File? faction(String factionId) => _find('factions', factionId);
}
