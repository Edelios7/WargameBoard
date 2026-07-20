// Importe tous les documents JSON de local_assets/wh40k_reference/import_json/
// dans la vraie base de l'application (Documents/wargame_board.sqlite).
//
// `dart run` ne peut pas exécuter ce projet directement : la chaîne
// d'imports (app_database.dart -> database_connection.dart ->
// path_provider) dépend de dart:ui, disponible uniquement sous la VM
// patchée de Flutter. On passe donc par le harnais `flutter test`, qui
// fournit cette VM, plutôt que par `dart run`/`flutter pub run`.
//
// Usage : flutter test tools/bulk_import_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/services/catalog_import_service.dart';

void main() {
  test('bulk import all converted reference JSON files', () async {
    final dir = Directory('local_assets/wh40k_reference/import_json');
    if (!dir.existsSync()) {
      markTestSkipped('Dossier import_json absent — rien à importer.');
      return;
    }

    final dbPath =
        '${Platform.environment['USERPROFILE']}\\Documents\\wargame_board.sqlite';
    final dbFile = File(dbPath);
    if (!dbFile.existsSync()) {
      markTestSkipped('Base introuvable ($dbPath) — lance l\'app une fois.');
      return;
    }

    final database = AppDatabase.forTesting(NativeDatabase(dbFile));
    final service = CatalogImportService(database);
    addTearDown(database.close);

    var totalDatasheets = 0;
    var failures = 0;
    for (final file
        in dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json'))) {
      try {
        final result = await service.importJson(file.readAsStringSync());
        totalDatasheets += result.datasheets;
        // ignore: avoid_print
        print('OK    ${file.path} — ${result.datasheets} datasheets');
      } on CatalogImportException catch (e) {
        failures++;
        // ignore: avoid_print
        print('ERREUR ${file.path} — $e');
      }
    }

    // ignore: avoid_print
    print('Total : $totalDatasheets datasheets importées, $failures échecs.');
    expect(failures, 0);
  });
}
