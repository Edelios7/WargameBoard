import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
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
    // dart:io n'a pas accès au système de fichiers local sur le web ; ces
    // visuels ne sont de toute façon jamais servis hors machine locale.
    if (kIsWeb) return null;
    for (final extension in _extensions) {
      final file = File(
        p.join(
          Directory.current.path,
          'local_assets',
          folder,
          '$id.$extension',
        ),
      );
      if (file.existsSync()) return file;
    }
    return null;
  }

  static File? datasheet(String datasheetId) =>
      _find('datasheets', datasheetId);

  static File? faction(String factionId) => _find('factions', factionId);

  /// Visuels d'habillage fixes (fond de page, bannières...), voir
  /// local_assets/branding/. Jamais commités (contenu généré, esthétique
  /// proche de l'imagerie GW).
  static File? branding(String name) => _find('branding', name);
}
