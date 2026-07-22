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

  /// Photo perso de la propre unité du joueur (ses figurines peintes),
  /// voir local_assets/user_photos/README.md — prioritaire sur
  /// [datasheet] partout où [unitPhoto] est utilisé.
  static File? userPhoto(String datasheetId) =>
      _find('user_photos', datasheetId);

  /// Meilleure image disponible pour une fiche : la photo perso du
  /// joueur si elle existe, sinon le visuel catalogue générique.
  static File? unitPhoto(String datasheetId) =>
      userPhoto(datasheetId) ?? datasheet(datasheetId);

  /// Photo perso d'une entrée précise de la collection (une escouade en
  /// particulier), voir local_assets/user_photos/README.md — prioritaire
  /// sur [userPhoto] partout où [collectionPhoto] est utilisé.
  static File? entryPhoto(String entryId) =>
      _find('user_photos/entries', entryId);

  /// Meilleure image disponible pour une entrée de la Collection : sa
  /// propre photo si elle existe, sinon la photo par défaut du type
  /// d'unité, sinon le visuel catalogue générique.
  static File? collectionPhoto(String datasheetId, String entryId) =>
      entryPhoto(entryId) ?? unitPhoto(datasheetId);

  static File? faction(String factionId) => _find('factions', factionId);

  /// Bannière large illustrant une faction (voir local_assets/banners/),
  /// pensée pour habiller l'arrière-plan d'une ligne/section plutôt que
  /// comme icône — contrairement à [faction] qui est un portrait carré.
  static File? factionBanner(String factionId) => _find('banners', factionId);

  /// Visuels d'habillage fixes (fond de page, bannières...), voir
  /// local_assets/branding/. Jamais commités (contenu généré, esthétique
  /// proche de l'imagerie GW).
  static File? branding(String name) => _find('branding', name);

  /// Éléments décoratifs génériques (séparateurs, coins, bordures de
  /// cadre, filigranes...), voir local_assets/decor/README.md — pas
  /// liés à une faction ou une fiche précise.
  static File? decor(String name) => _find('decor', name);
}
