// Importe les détachements/stratagèmes parsés (parse_faction_pack_updates_fr.py,
// depuis les "Faction Pack v1.1" du 22/07/2026, voir
// local_assets/wh40k_reference/detachments_json/*.json) dans la vraie
// base de l'application (Documents/wargame_board.sqlite).
//
// Les enhancements ("OPTIMISATIONS") ne sont volontairement pas
// importés : leur coût en points n'est jamais réimprimé dans ces packs
// de mise à jour (probablement inchangé depuis le codex de base, qu'on
// n'a pas), et la colonne enhancements.points est NOT NULL — on
// préfère ne rien importer plutôt qu'inventer un coût.
//
// Certains stratagèmes référencent un nom de détachement qui n'a pas
// sa propre section "RÈGLES DE DÉTACHEMENT" dans ce pack (rien n'a
// changé pour ce détachement ce cycle-ci, donc son texte de règle
// n'est pas réimprimé) : on crée quand même un Detachment minimal
// (description nulle) pour ces noms, afin de ne perdre aucun
// stratagème.
//
// Usage : flutter test tools/import_faction_pack_rules_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

String slugify(String input) {
  final normalized = input
      .toLowerCase()
      .replaceAll(RegExp(r'[àâä]'), 'a')
      .replaceAll(RegExp(r'[éèêë]'), 'e')
      .replaceAll(RegExp(r'[ìîï]'), 'i')
      .replaceAll(RegExp(r'[òôö]'), 'o')
      .replaceAll(RegExp(r'[ùûü]'), 'u')
      .replaceAll('ç', 'c')
      .replaceAll('œ', 'oe');
  final slug = normalized
      .replaceAll(RegExp(r"[^a-z0-9]+"), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isEmpty ? 'x' : slug;
}

void main() {
  test('import parsed detachments/stratagems into the real database',
      () async {
    final dir =
        Directory('local_assets/wh40k_reference/detachments_json');
    if (!dir.existsSync()) {
      markTestSkipped('Dossier detachments_json absent — rien à importer.');
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

    var totalDetachments = 0;
    var totalStratagems = 0;
    var totalFactionsMissing = 0;

    for (final file in dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))) {
      final factionId =
          file.uri.pathSegments.last.replaceAll('.json', '');

      final factionExists = await (database.select(database.factions)
            ..where((t) => t.id.equals(factionId)))
          .getSingleOrNull();
      if (factionExists == null) {
        totalFactionsMissing++;
        // ignore: avoid_print
        print('SKIP $factionId — faction inconnue en base');
        continue;
      }

      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final detachmentsJson = (data['detachments'] as List).cast<Map>();
      final stratagemsJson = (data['stratagems'] as List).cast<Map>();

      // id de détachement par nom en MAJUSCULES (tel qu'imprimé dans le
      // PDF), pour relier les stratagèmes qui référencent ce même nom.
      final detachmentIdByName = <String, String>{};

      Future<String> upsertDetachment(String name, String? description) async {
        final existingId = detachmentIdByName[name];
        if (existingId != null) return existingId;
        final id = 'det-$factionId-${slugify(name)}';
        await database.into(database.detachments).insertOnConflictUpdate(
              DetachmentsCompanion.insert(
                id: id,
                factionId: factionId,
                name: name,
                description: Value(description),
              ),
            );
        detachmentIdByName[name] = id;
        totalDetachments++;
        return id;
      }

      for (final det in detachmentsJson) {
        final name = det['name'] as String;
        final description = det['description'] as String?;
        await upsertDetachment(
          name,
          (description != null && description.trim().isNotEmpty)
              ? description
              : null,
        );
      }

      for (final strat in stratagemsJson) {
        final detName = (strat['detachment_name'] as String?)?.trim();
        final cost = strat['cost'] as int?;
        final name = strat['name'] as String?;
        if (detName == null ||
            detName.isEmpty ||
            cost == null ||
            name == null ||
            name.isEmpty) {
          continue;
        }
        final detachmentId = await upsertDetachment(detName, null);
        final stratId = 'strat-$detachmentId-${slugify(name)}';
        await database.into(database.stratagems).insertOnConflictUpdate(
              StratagemsCompanion.insert(
                id: stratId,
                detachmentId: detachmentId,
                name: name,
                commandPoints: cost,
                phase: Value(strat['phase'] as String?),
                description: Value(strat['description'] as String?),
              ),
            );
        totalStratagems++;
      }

      // ignore: avoid_print
      print(
        'OK $factionId — ${detachmentIdByName.length} détachements, '
        '${stratagemsJson.length} stratagèmes',
      );
    }

    // ignore: avoid_print
    print(
      'TOTAL : $totalDetachments détachements, $totalStratagems stratagèmes, '
      '$totalFactionsMissing faction(s) inconnue(s) ignorée(s).',
    );
    expect(totalStratagems, greaterThan(0));
  });
}
