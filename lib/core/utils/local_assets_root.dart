import 'dart:io';

import 'package:path/path.dart' as p;

/// Localise le dossier contenant `local_assets/` (images, PDF de règles...),
/// jamais commité ni embarqué dans un build (voir .gitignore) : le
/// développeur le dépose lui-même à côté du projet.
///
/// En `flutter run`, le dossier courant du processus est déjà la racine du
/// projet, donc `local_assets/` s'y trouve directement. Mais un .exe de
/// release lancé par raccourci a pour dossier courant son propre dossier
/// (`build/windows/x64/runner/Release/`), jamais copié par
/// `flutter build` — d'où des images manquantes en dehors de `flutter run`.
/// On remonte donc l'arborescence, depuis le dossier courant puis depuis
/// celui de l'exécutable, jusqu'à trouver un `local_assets/`.
class LocalAssetsRoot {
  LocalAssetsRoot._();

  static String? _cached;
  static bool _resolved = false;

  static String? get path {
    if (!_resolved) {
      _resolved = true;
      _cached =
          _search(Directory.current.path) ??
          _search(p.dirname(Platform.resolvedExecutable));
    }
    return _cached;
  }

  static String? _search(String start) {
    var dir = Directory(start);
    for (var i = 0; i < 8; i++) {
      if (Directory(p.join(dir.path, 'local_assets')).existsSync()) {
        return dir.path;
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
    return null;
  }
}
