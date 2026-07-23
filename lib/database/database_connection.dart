import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/backup_service.dart';

/// Base pré-remplie (catalogue complet + éventuelles données perso) livrée
/// dans les builds perso — voir assets/seed_data/ (jamais commitée). Copiée
/// telle quelle au tout premier lancement si présente ; sans elle, l'appli
/// démarre avec le catalogue minimal seedé par la migration `onCreate`.
const _seedAssetPath = 'assets/seed_data/$databaseFileName';

/// Creates the SQLite connection used by Drift.
///
/// The database is stored inside the application's documents directory.
/// Drift opens the database lazily and runs SQLite on a background isolate.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    // Une restauration programmée (voir BackupService.stageRestore) doit
    // remplacer le fichier avant que quoi que ce soit n'ouvre une
    // connexion dessus.
    await applyPendingRestore();

    final documentsDirectory = await getApplicationDocumentsDirectory();

    final databaseFile = File(
      p.join(
        documentsDirectory.path,
        databaseFileName,
      ),
    );

    if (!databaseFile.existsSync()) {
      await _bootstrapFromSeedAsset(databaseFile);
    }

    return NativeDatabase.createInBackground(databaseFile);
  });
}

Future<void> _bootstrapFromSeedAsset(File databaseFile) async {
  try {
    final bytes = await rootBundle.load(_seedAssetPath);
    await databaseFile.create(recursive: true);
    await databaseFile.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
  } catch (_) {
    // Pas de base pré-remplie dans ce build (cas normal en dev/CI) — on
    // laisse la migration onCreate seeder le catalogue minimal comme avant.
  }
}