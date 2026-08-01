// Importe les noms anglais officiels des fiches (DatasheetAliases) pour
// que la recherche trouve une fiche affichée en français en tapant son
// nom anglais, et inversement (voir lib/core/utils/search_normalize.dart
// et DatasheetDao.search). Les paires anglais/français sont déduites en
// corrélant, pour chaque faction, les unités du site MFM anglais et
// français qui partagent exactement les mêmes paliers de coût (voir
// local_assets/wh40k_reference/match_en_fr_aliases.py) — seules les
// correspondances non ambiguës sont conservées, le reste est ignoré
// plutôt que deviné.
//
// Usage : flutter test tools/import_datasheet_aliases_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  test('import english datasheet aliases into the real database', () async {
    final file = File(
      'local_assets/wh40k_reference/mfm_web/datasheet_english_aliases.json',
    );
    if (!file.existsSync()) {
      markTestSkipped('datasheet_english_aliases.json absent.');
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
    addTearDown(database.close);

    final data =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

    var inserted = 0;
    var skippedMissingDatasheet = 0;

    for (final entry in data.entries) {
      final datasheetId = entry.key;
      final englishName = entry.value as String;

      final datasheetExists = await (database.select(database.datasheets)
            ..where((t) => t.id.equals(datasheetId)))
          .getSingleOrNull();
      if (datasheetExists == null) {
        skippedMissingDatasheet++;
        continue;
      }

      await database.into(database.datasheetAliases).insertOnConflictUpdate(
            DatasheetAliasesCompanion.insert(
              id: 'alias-en-$datasheetId',
              datasheetId: datasheetId,
              name: englishName,
            ),
          );
      inserted++;
    }

    // ignore: avoid_print
    print(
      'TOTAL : $inserted alias(es) importé(s)/mis à jour, '
      '$skippedMissingDatasheet fiche(s) introuvable(s) en base.',
    );
    expect(inserted, greaterThan(0));
  });
}
