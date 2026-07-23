import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../database/app_database.dart';

/// Nom du fichier de base de données réel — voir
/// `lib/database/database_connection.dart`.
const databaseFileName = 'wargame_board.sqlite';

/// Suffixe du fichier de restauration en attente : une restauration ne
/// remplace jamais la base pendant que l'app tourne dessus (verrou de
/// fichier, risque de corruption) — elle est mise de côté ici et
/// appliquée par [applyPendingRestore] au prochain lancement, avant que
/// la connexion Drift ne soit ouverte.
const _pendingRestoreSuffix = '.restore';

/// Sauvegarde et restauration de la base de données locale — la seule
/// copie des données du joueur (armées, collection, historique de
/// parties...), jamais synchronisée ailleurs.
class BackupService {
  const BackupService(this.database);

  final AppDatabase database;

  /// Ouvre un sélecteur de dossier et y écrit une copie complète et
  /// cohérente de la base (`VACUUM INTO`, qui inclut les écritures encore
  /// en journal — une simple copie du fichier .sqlite pourrait les
  /// manquer). Retourne le chemin du fichier créé, `null` si annulé.
  Future<String?> exportBackup() async {
    final directory = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choisir où enregistrer la sauvegarde',
    );
    if (directory == null) return null;

    final timestamp = DateTime.now();
    final stamp =
        '${timestamp.year.toString().padLeft(4, '0')}'
        '${timestamp.month.toString().padLeft(2, '0')}'
        '${timestamp.day.toString().padLeft(2, '0')}-'
        '${timestamp.hour.toString().padLeft(2, '0')}'
        '${timestamp.minute.toString().padLeft(2, '0')}';
    final destination = p.join(directory, 'wargameboard_backup_$stamp.sqlite');

    final file = File(destination);
    if (file.existsSync()) await file.delete();
    await database.customStatement('VACUUM INTO ?', [destination]);
    return destination;
  }

  /// Ouvre un sélecteur de fichier pour choisir une sauvegarde `.sqlite`
  /// et la met en attente de restauration — voir [_pendingRestoreSuffix].
  /// Retourne `true` si une restauration a bien été programmée.
  Future<bool> stageRestore() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Choisir une sauvegarde à restaurer',
      type: FileType.custom,
      allowedExtensions: ['sqlite'],
    );
    final path = result?.files.single.path;
    if (path == null) return false;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(documentsDirectory.path, '$databaseFileName$_pendingRestoreSuffix'),
    );
    await File(path).copy(staged.path);
    return true;
  }

  /// Annule une restauration programmée mais pas encore appliquée.
  Future<void> cancelPendingRestore() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(documentsDirectory.path, '$databaseFileName$_pendingRestoreSuffix'),
    );
    if (staged.existsSync()) await staged.delete();
  }

  static Future<bool> hasPendingRestore() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(documentsDirectory.path, '$databaseFileName$_pendingRestoreSuffix'),
    );
    return staged.existsSync();
  }
}

/// Si une restauration a été programmée (voir [BackupService.stageRestore]),
/// remplace la base actuelle par le fichier mis en attente — appelé avant
/// l'ouverture de la connexion Drift, jamais pendant qu'elle est active.
Future<void> applyPendingRestore() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final staged = File(
    p.join(documentsDirectory.path, '$databaseFileName$_pendingRestoreSuffix'),
  );
  if (!staged.existsSync()) return;

  final databaseFile = File(p.join(documentsDirectory.path, databaseFileName));
  if (databaseFile.existsSync()) await databaseFile.delete();

  // Les fichiers annexes du journal WAL d'une session précédente ne
  // doivent pas survivre au remplacement de la base qu'ils accompagnent.
  for (final suffix in ['-wal', '-shm', '-journal']) {
    final sidecar = File('${databaseFile.path}$suffix');
    if (sidecar.existsSync()) await sidecar.delete();
  }

  await staged.rename(databaseFile.path);
}
