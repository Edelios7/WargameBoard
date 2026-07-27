import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;

import 'local_assets_root.dart';

/// Résout les octets d'un PDF de règles officiel, jamais commité (voir
/// local_assets/rules/README.md et .gitignore) — deux sources possibles
/// selon la plateforme :
///
/// - Windows/dev : fichier local sous `local_assets/rules/<id>.pdf`, résolu
///   depuis le dossier courant du processus (comme [LocalCatalogImages]) —
///   jamais embarqué dans un build, l'utilisateur le dépose lui-même.
/// - Mobile perso : asset Flutter embarqué sous `assets/rulebook/<id>.pdf`
///   (même convention que assets/seed_data/, voir database_connection.dart)
///   — copié manuellement par l'utilisateur avant `flutter build apk`,
///   jamais commité non plus.
///
/// Retourne `null` si le PDF n'est disponible nulle part, auquel cas
/// l'appelant garde le comportement existant (bouton désactivé/message).
class RulePdfSource {
  RulePdfSource._();

  static Future<Uint8List?> resolve(String localAssetId) async {
    if (!kIsWeb) {
      final root = LocalAssetsRoot.path ?? Directory.current.path;
      final file = File(
        p.join(root, 'local_assets', 'rules', '$localAssetId.pdf'),
      );
      if (file.existsSync()) return file.readAsBytes();
    }

    try {
      final data = await rootBundle.load(
        'assets/rulebook/$localAssetId.pdf',
      );
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (_) {
      return null;
    }
  }
}
