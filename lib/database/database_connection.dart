import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../services/backup_service.dart';

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

    return NativeDatabase.createInBackground(databaseFile);
  });
}