// Calcule et enregistre l'archétype de jeu (Horde/Élite/Blindé-Monstre/
// Spécialiste anti-char/Soutien, voir lib/domain/catalog/common/
// unit_archetype.dart) pour chaque fiche active de la vraie base locale,
// via l'heuristique `classifyArchetype` (mots-clés, effectif, armes).
//
// Usage : flutter test tools/backfill_unit_archetypes_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/domain/catalog/common/unit_archetype.dart';

void main() {
  test('backfill datasheets.archetype for every active datasheet', () async {
    final dbPath =
        '${Platform.environment['USERPROFILE']}\\Documents\\wargame_board.sqlite';
    final dbFile = File(dbPath);
    if (!dbFile.existsSync()) {
      markTestSkipped('Base introuvable ($dbPath) — lance l\'app une fois.');
      return;
    }

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    addTearDown(db.close);

    final activeIds = await (db.select(db.datasheets)
          ..where((t) => t.isActive.equals(true)))
        .map((row) => row.id)
        .get();

    final counts = <UnitArchetype, int>{};
    var updated = 0;
    var skippedNoModel = 0;

    for (final id in activeIds) {
      final sheet = await db.datasheetDao.getDatasheet(id);
      if (sheet == null || sheet.models.isEmpty) {
        skippedNoModel++;
        continue;
      }

      // `unit_sizes`/`unit_compositions` sont quasi vides dans cette base
      // (voir notes de session) : le nombre de figurines réel se lit bien
      // plus fiablement dans les paliers de coût (`datasheet_costs.model_
      // count`), présents pour ~72% des fiches.
      final costModelCounts = sheet.costBrackets
          .map((b) => b.modelCount)
          .whereType<int>();
      final maxModelSize = costModelCounts.isNotEmpty
          ? costModelCounts.reduce((a, b) => a > b ? a : b)
          : (sheet.unit.maximumSize > 0
                ? sheet.unit.maximumSize
                : sheet.unit.defaultSize);
      final hasDedicatedAntiTankWeapon = sheet.weapons.any(
        (w) => w.profiles.any(
          (p) =>
              p.armorPenetration <= -3 &&
              p.strength >= 9 &&
              p.damage != '1',
        ),
      );

      final archetype = classifyArchetype(
        keywords: sheet.keywords,
        maxModelSize: maxModelSize,
        baseToughness: sheet.models.first.toughness,
        hasDedicatedAntiTankWeapon: hasDedicatedAntiTankWeapon,
      );

      await (db.update(db.datasheets)..where((t) => t.id.equals(id))).write(
        DatasheetsCompanion(archetype: Value(archetype.name)),
      );
      counts[archetype] = (counts[archetype] ?? 0) + 1;
      updated++;
    }

    // ignore: avoid_print
    print('$updated fiche(s) classée(s), $skippedNoModel sans modèle ignorée(s).');
    for (final entry in counts.entries) {
      // ignore: avoid_print
      print('  ${entry.key.name}: ${entry.value}');
    }
  });
}
