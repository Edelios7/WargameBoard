import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Dossier applicatif où l'app écrit elle-même du contenu à l'exécution
/// (photos perso choisies par le joueur) — contrairement au catalogue
/// (local_assets/datasheets/...), qui n'est jamais écrit par l'app, mais
/// seulement lu depuis le dossier du projet/build par des outils externes
/// (voir tools/), et reste donc résolu séparément.
///
/// Utilise le même dossier applicatif que la base de données (voir
/// lib/database/database_connection.dart) pour être cohérent sur toutes
/// les plateformes, y compris Android où « le dossier courant » du
/// processus n'a pas de sens exploitable.
class UserContentPaths {
  UserContentPaths._();

  static String? _baseDirectory;

  /// À appeler une fois avant `runApp`. Les appels ultérieurs de
  /// [baseDirectory] sont synchrones, appuyés sur ce résultat mis en
  /// cache.
  static Future<void> initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    _baseDirectory = directory.path;
  }

  /// Replie sur le dossier courant du processus si [initialize] n'a pas
  /// été appelé (tests, outils, ou tout contexte hors `main()`) — c'est le
  /// comportement historique, toujours correct sur Windows en dev/CI.
  static String get baseDirectory => _baseDirectory ?? Directory.current.path;
}
