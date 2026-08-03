// Importe les paliers de coût "à partir de la Ne copie" (voir
// DatasheetCosts.minCopyIndex) — le MFM tarife de nombreuses unités plus
// cher à partir d'un certain nombre d'exemplaires dans la même liste
// (ex. "de la 1re à la 2e unité : 150 pts", "3e unité et suivantes :
// 165 pts"). Ce mécanisme est distinct de import_mfm_datasheet_points_test
// (qui ne gère que le palier de base, 1re copie) : les deux tools peuvent
// tourner l'un après l'autre sans se marcher dessus, ils touchent des
// lignes différentes (distinguées par minCopyIndex).
//
// Voir local_assets/wh40k_reference/mfm_web/datasheet_copy_thresholds.json :
// {datasheetId: [[modelCount, points, minCopyIndex], ...]}
// où minCopyIndex est le seuil réel affiché par le MFM (2, 3, 4...), pas
// le palier de base (celui-là reste dans datasheet_points_updates.json).
//
// Ne touche qu'aux fiches déjà présentes dans le catalogue — n'en crée
// aucune.
//
// Usage : flutter test tools/import_mfm_copy_thresholds_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  test('update per-copy surcharge tiers from the live MFM site', () async {
    final file = File(
      'local_assets/wh40k_reference/mfm_web/datasheet_copy_thresholds.json',
    );
    if (!file.existsSync()) {
      markTestSkipped('datasheet_copy_thresholds.json absent.');
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

    const editionId = 'ed-w40k-10e';
    final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

    var updated = 0;
    var inserted = 0;
    var skippedMissingDatasheet = 0;

    for (final entry in data.entries) {
      final datasheetId = entry.key;
      final tiers = (entry.value as List).cast<List>();

      final datasheetExists = await (database.select(database.datasheets)
            ..where((t) => t.id.equals(datasheetId)))
          .getSingleOrNull();
      if (datasheetExists == null) {
        skippedMissingDatasheet++;
        continue;
      }

      for (final tier in tiers) {
        final modelCount = tier[0] as int;
        final points = tier[1] as int;
        final minCopyIndex = tier[2] as int;

        final existing = await (database.select(database.datasheetCosts)
              ..where(
                (t) =>
                    t.datasheetId.equals(datasheetId) &
                    t.editionId.equals(editionId) &
                    t.modelCount.equals(modelCount) &
                    t.minCopyIndex.equals(minCopyIndex),
              ))
            .getSingleOrNull();

        if (existing != null) {
          if (existing.points != points) {
            await (database.update(database.datasheetCosts)
                  ..where((t) => t.id.equals(existing.id)))
                .write(DatasheetCostsCompanion(points: Value(points)));
            updated++;
          }
        } else {
          await database.into(database.datasheetCosts).insert(
                DatasheetCostsCompanion.insert(
                  id: 'cost-mfm-copy-$datasheetId-$modelCount-$minCopyIndex',
                  datasheetId: datasheetId,
                  editionId: editionId,
                  points: points,
                  modelCount: Value(modelCount),
                  minCopyIndex: Value(minCopyIndex),
                ),
              );
          inserted++;
        }
      }
    }

    // ignore: avoid_print
    print(
      'TOTAL : $updated palier(s) de surcoût mis à jour, $inserted créé(s), '
      '$skippedMissingDatasheet fiche(s) introuvable(s) en base.',
    );
    expect(updated + inserted, greaterThan(0));
  });
}
