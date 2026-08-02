import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import '../core/utils/user_content_paths.dart';
import '../database/app_database.dart';
import 'customization_service.dart';

/// Suffixe du fichier de réglages de personnalisation associé à une
/// sauvegarde (voir [BackupService.exportBackup]/[BackupService.stageRestore])
/// — couleur d'accent, fonds d'écran... Ces réglages vivent dans
/// SharedPreferences, pas dans la base de données, donc une simple copie
/// du `.sqlite` ne les emporterait pas.
const _customizationSuffix = '.customization.json';

/// Suffixe du dossier des photos perso associé à une sauvegarde — voir
/// [BackupService.exportBackup]/[BackupService.stageRestore]. Les photos
/// (voir UserPhotoService) sont des fichiers indépendants de la base de
/// données ; sans les emporter, une restauration sur une installation
/// neuve ferait disparaître silencieusement toutes les photos perso du
/// joueur alors que la base continue de les référencer.
const _photosSuffix = '_photos';

/// Nom du fichier de base de données réel — voir
/// `lib/database/database_connection.dart`.
const databaseFileName = 'wargame_board.sqlite';

/// Suffixe du fichier de restauration en attente : une restauration ne
/// remplace jamais la base pendant que l'app tourne dessus (verrou de
/// fichier, risque de corruption) — elle est mise de côté ici et
/// appliquée par [applyPendingRestore] au prochain lancement, avant que
/// la connexion Drift ne soit ouverte.
const _pendingRestoreSuffix = '.restore';

/// Résultat de [BackupService.stageRestore] — distingue l'annulation
/// (l'utilisateur ferme le sélecteur sans choisir de fichier, rien à
/// signaler) des deux façons dont un fichier choisi peut être rejeté,
/// pour que l'appelant affiche le bon message.
enum RestoreStageResult { staged, cancelled, invalidFile, unsupportedSchema }

/// Sauvegarde et restauration de la base de données locale — la seule
/// copie des données du joueur (armées, collection, historique de
/// parties...), jamais synchronisée ailleurs.
class BackupService {
  const BackupService(this.database, {this.customizationService});

  final AppDatabase database;

  /// `null` dans les contextes qui n'ont pas besoin d'exporter/restaurer
  /// la personnalisation (ex. tests existants de sauvegarde de la base) —
  /// dans ce cas [exportBackup] n'écrit pas de fichier de réglages, et
  /// [stageRestore] ignore silencieusement celui d'une sauvegarde choisie.
  final CustomizationService? customizationService;

  /// Ouvre un sélecteur de dossier et y écrit une copie complète et
  /// cohérente de la base (`VACUUM INTO`, qui inclut les écritures encore
  /// en journal — une simple copie du fichier .sqlite pourrait les
  /// manquer), accompagnée d'un petit fichier `.customization.json` avec
  /// la couleur d'accent et les fonds d'écran. Retourne le chemin du
  /// fichier `.sqlite` créé, `null` si annulé.
  Future<String?> exportBackup() async {
    final directory = await FilePicker.getDirectoryPath(
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

    final settingsService = customizationService;
    if (settingsService != null) {
      final settings = await settingsService.exportSettings();
      await File(
        '$destination$_customizationSuffix',
      ).writeAsString(jsonEncode(settings));
    }

    final photosDirectory = Directory(
      p.join(UserContentPaths.baseDirectory, 'local_assets', 'user_photos'),
    );
    if (photosDirectory.existsSync()) {
      await copyDirectoryRecursively(
        photosDirectory,
        Directory('$destination$_photosSuffix'),
      );
    }

    return destination;
  }

  /// Ouvre un sélecteur de fichier pour choisir une sauvegarde `.sqlite`
  /// et la met en attente de restauration — voir [_pendingRestoreSuffix].
  ///
  /// Le fichier choisi est validé ICI (lisibilité SQLite + version de
  /// schéma) plutôt qu'au redémarrage suivant : un fichier invalide
  /// programmé sans contrôle ne serait rejeté qu'à ce moment-là par
  /// [applyPendingRestore], en silence — l'utilisateur croirait sa
  /// restauration effective alors qu'elle n'a jamais eu lieu.
  Future<RestoreStageResult> stageRestore() async {
    final result = await FilePicker.pickFiles(
      dialogTitle: 'Choisir une sauvegarde à restaurer',
      type: FileType.custom,
      allowedExtensions: ['sqlite'],
    );
    final path = result?.files.single.path;
    if (path == null) return RestoreStageResult.cancelled;

    final picked = File(path);
    if (!_isValidSqliteDatabase(picked)) {
      return RestoreStageResult.invalidFile;
    }
    final pickedSchemaVersion = _readSchemaVersion(picked);
    if (pickedSchemaVersion != null &&
        pickedSchemaVersion > database.schemaVersion) {
      // La sauvegarde vient d'une version plus récente de l'appli, dont
      // le schéma de base contient des colonnes/tables que cette version
      // installée ne connaît pas — Drift ne sait migrer que vers l'avant
      // (onUpgrade), pas revenir en arrière. Mieux vaut refuser
      // clairement ici que de remplacer la base et planter au prochain
      // lancement, une fois l'originale déjà mise de côté.
      return RestoreStageResult.unsupportedSchema;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(
        documentsDirectory.path,
        '$databaseFileName$_pendingRestoreSuffix',
      ),
    );
    await picked.copy(staged.path);

    // La personnalisation (SharedPreferences) n'est pas verrouillée par
    // une connexion Drift active comme la base l'est : contrairement à
    // celle-ci, rien n'empêche de l'appliquer tout de suite plutôt que de
    // la mettre en attente jusqu'au prochain lancement.
    final settingsService = customizationService;
    if (settingsService != null) {
      final settingsFile = File('$path$_customizationSuffix');
      if (settingsFile.existsSync()) {
        try {
          final data = jsonDecode(await settingsFile.readAsString());
          if (data is Map<String, dynamic>) {
            await settingsService.importSettings(data);
          }
        } catch (_) {
          // Fichier de réglages corrompu/illisible : la restauration de la
          // base reste valable, seule la personnalisation est ignorée —
          // ne doit jamais faire échouer une restauration par ailleurs
          // valide pour un simple réglage cosmétique.
        }
      }
    }

    // Les photos ne sont pas verrouillées par une connexion Drift active
    // comme la base — rien n'empêche de les restaurer tout de suite,
    // même principe que la personnalisation ci-dessus.
    final photosBackup = Directory('$path$_photosSuffix');
    if (photosBackup.existsSync()) {
      final photosDirectory = Directory(
        p.join(UserContentPaths.baseDirectory, 'local_assets', 'user_photos'),
      );
      await copyDirectoryRecursively(photosBackup, photosDirectory);
    }

    return RestoreStageResult.staged;
  }

  /// Annule une restauration programmée mais pas encore appliquée.
  Future<void> cancelPendingRestore() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(
        documentsDirectory.path,
        '$databaseFileName$_pendingRestoreSuffix',
      ),
    );
    if (staged.existsSync()) await staged.delete();
  }

  static Future<bool> hasPendingRestore() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final staged = File(
      p.join(
        documentsDirectory.path,
        '$databaseFileName$_pendingRestoreSuffix',
      ),
    );
    return staged.existsSync();
  }
}

/// Copie récursivement le contenu de [source] vers [destination] (créé si
/// besoin) — pas de dépendance à un package de zip pour un simple dossier
/// de photos, une copie de fichiers plate suffit. Public (et non préfixé
/// `_`) uniquement pour rester testable directement, sans passer par
/// [BackupService.exportBackup]/[stageRestore] qui dépendent de
/// `FilePicker` (non simulable dans les tests existants de ce projet).
Future<void> copyDirectoryRecursively(
  Directory source,
  Directory destination,
) async {
  await destination.create(recursive: true);
  await for (final entity in source.list(recursive: false)) {
    final name = p.basename(entity.path);
    if (entity is Directory) {
      await copyDirectoryRecursively(
        entity,
        Directory(p.join(destination.path, name)),
      );
    } else if (entity is File) {
      await entity.copy(p.join(destination.path, name));
    }
  }
}

/// `true` si [file] s'ouvre comme une base SQLite lisible et cohérente
/// (`PRAGMA integrity_check`) — un fichier renommé en `.sqlite` par erreur,
/// tronqué, ou corrompu doit être rejeté avant de toucher à la vraie base,
/// pas découvert au redémarrage suivant une fois l'originale déjà effacée.
bool _isValidSqliteDatabase(File file) {
  sqlite3.Database? db;
  try {
    db = sqlite3.sqlite3.open(file.path, mode: sqlite3.OpenMode.readOnly);
    final result = db.select('PRAGMA integrity_check');
    return result.isNotEmpty && result.first.values.first == 'ok';
  } catch (_) {
    return false;
  } finally {
    db?.dispose();
  }
}

/// Lit `PRAGMA user_version` (là où Drift range `schemaVersion`) d'un
/// fichier `.sqlite` sans l'ouvrir via Drift. `null` si le fichier n'est
/// pas une base SQLite lisible.
int? _readSchemaVersion(File file) {
  sqlite3.Database? db;
  try {
    db = sqlite3.sqlite3.open(file.path, mode: sqlite3.OpenMode.readOnly);
    final result = db.select('PRAGMA user_version');
    return result.isEmpty ? null : result.first.values.first as int;
  } catch (_) {
    return null;
  } finally {
    db?.dispose();
  }
}

/// Si une restauration a été programmée (voir [BackupService.stageRestore]),
/// remplace la base actuelle par le fichier mis en attente — appelé avant
/// l'ouverture de la connexion Drift, jamais pendant qu'elle est active.
///
/// Le fichier en attente est validé avant que quoi que ce soit ne soit
/// touché à la base réelle, et celle-ci est mise de côté (renommée) plutôt
/// que supprimée directement, pour ne jamais se retrouver sans base
/// utilisable ni traiter les données du joueur comme jetables si une
/// étape échoue en cours de route.
Future<void> applyPendingRestore() async {
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final staged = File(
    p.join(documentsDirectory.path, '$databaseFileName$_pendingRestoreSuffix'),
  );
  if (!staged.existsSync()) return;

  if (!_isValidSqliteDatabase(staged)) {
    await staged.delete();
    return;
  }

  final databaseFile = File(p.join(documentsDirectory.path, databaseFileName));
  if (databaseFile.existsSync()) {
    await databaseFile.rename('${databaseFile.path}.before-restore');
  }

  // Les fichiers annexes du journal WAL d'une session précédente ne
  // doivent pas survivre au remplacement de la base qu'ils accompagnent.
  for (final suffix in ['-wal', '-shm', '-journal']) {
    final sidecar = File('${databaseFile.path}$suffix');
    if (sidecar.existsSync()) await sidecar.delete();
  }

  await staged.rename(databaseFile.path);
}
