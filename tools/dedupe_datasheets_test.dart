// Supprime les datasheets en double (même faction + même nom) dans la
// vraie base locale. Conserve en priorité celle qui a un coût en points
// renseigné (plus complète), sinon la première par ordre de création.
//
// Usage : flutter test tools/dedupe_datasheets_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  test('remove duplicate datasheets (same faction + name)', () async {
    final dbPath =
        '${Platform.environment['USERPROFILE']}\\Documents\\wargame_board.sqlite';
    final dbFile = File(dbPath);
    if (!dbFile.existsSync()) {
      markTestSkipped('Base introuvable ($dbPath).');
      return;
    }

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    addTearDown(db.close);

    final allSheets = await db.select(db.datasheets).get();
    final costs = await db.select(db.datasheetCosts).get();
    final costedIds = costs.map((c) => c.datasheetId).toSet();

    final groups = <String, List<Datasheet>>{};
    for (final sheet in allSheets) {
      groups.putIfAbsent('${sheet.factionId}::${sheet.name}', () => []).add(sheet);
    }

    var removed = 0;
    for (final group in groups.values) {
      if (group.length < 2) continue;

      group.sort((a, b) {
        final aHasCost = costedIds.contains(a.id) ? 0 : 1;
        final bHasCost = costedIds.contains(b.id) ? 0 : 1;
        if (aHasCost != bHasCost) return aHasCost - bHasCost;
        return a.createdAt.compareTo(b.createdAt);
      });

      final toRemove = group.skip(1);
      for (final sheet in toRemove) {
        await _deleteDatasheet(db, sheet.id);
        removed++;
        // ignore: avoid_print
        print('Supprimé (doublon) : ${sheet.name} [${sheet.id}]');
      }
    }

    // ignore: avoid_print
    print('$removed datasheet(s) en double supprimée(s).');
  });
}

Future<void> _deleteDatasheet(AppDatabase db, String datasheetId) async {
  final models = await (db.select(db.datasheetModels)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .get();

  for (final model in models) {
    await (db.delete(db.modelProfiles)
          ..where((t) => t.datasheetModelId.equals(model.id)))
        .go();
    await (db.delete(db.datasheetWeapons)
          ..where((t) => t.datasheetModelId.equals(model.id)))
        .go();
  }

  await (db.delete(db.datasheetModels)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.datasheetCosts)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.unitSizes)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.datasheetKeywordLinks)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.datasheetAbilityLinks)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.equipmentGroups)
        ..where((t) => t.datasheetId.equals(datasheetId)))
      .go();
  await (db.delete(db.datasheets)..where((t) => t.id.equals(datasheetId)))
      .go();
}
