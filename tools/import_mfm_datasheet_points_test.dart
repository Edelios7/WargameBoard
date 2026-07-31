// Met à jour les coûts en points des fiches (DatasheetCosts) avec les
// valeurs réelles du site mfm.warhammer-community.com/fr, désormais publiées
// par unité (pas seulement par détachement/amélioration comme lors du
// premier import, voir tools/import_mfm_enhancements_test.dart).
// Voir local_assets/wh40k_reference/mfm_web/datasheet_points_updates.json
// (capturé + apparié aux fiches existantes via match_mfm_points_to_db.py) :
// {datasheetId: [[modelCount, points], ...]}.
//
// Ne touche qu'aux fiches déjà présentes dans le catalogue (appariées par
// nom, en tolérant les caractères mojibake `<27>` issus d'un bug d'import
// PDF antérieur) — n'en crée aucune. Un palier de coût existant est mis à
// jour ; un palier absent est ajouté ; les paliers non couverts par le MFM
// (legends, etc.) restent inchangés.
//
// Usage : flutter test tools/import_mfm_datasheet_points_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  test('update datasheet points from the live MFM site', () async {
    final file = File(
      'local_assets/wh40k_reference/mfm_web/datasheet_points_updates.json',
    );
    if (!file.existsSync()) {
      markTestSkipped('datasheet_points_updates.json absent.');
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
    final data =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

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

        final existing = await (database.select(database.datasheetCosts)
              ..where(
                (t) =>
                    t.datasheetId.equals(datasheetId) &
                    t.editionId.equals(editionId) &
                    t.modelCount.equals(modelCount),
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
                  id: 'cost-mfm-$datasheetId-$modelCount',
                  datasheetId: datasheetId,
                  editionId: editionId,
                  points: points,
                  modelCount: Value(modelCount),
                ),
              );
          inserted++;
        }
      }
    }

    // ignore: avoid_print
    print(
      'TOTAL : $updated palier(s) mis à jour, $inserted créé(s), '
      '$skippedMissingDatasheet fiche(s) introuvable(s) en base.',
    );
    expect(updated + inserted, greaterThan(0));
  });
}
