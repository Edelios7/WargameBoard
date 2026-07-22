// Importe les détachements + enhancements (avec coût réel en points,
// absent des Faction Pack PDF) depuis mfm.warhammer-community.com, voir
// local_assets/wh40k_reference/mfm_detachments_json/*.json (capturé et
// parsé via parse_mfm_web.py). Fusionne avec les détachements déjà
// importés depuis les PDF (tools/import_faction_pack_rules_test.dart) :
// un détachement existant n'est jamais écrasé (sa description issue du
// PDF est conservée), on ajoute juste ses enhancements.
//
// Usage : flutter test tools/import_mfm_enhancements_test.dart --run-skipped

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
  test('import mfm detachments/enhancements into the real database',
      () async {
    final dir =
        Directory('local_assets/wh40k_reference/mfm_detachments_json');
    if (!dir.existsSync()) {
      markTestSkipped('Dossier mfm_detachments_json absent.');
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

    var newDetachments = 0;
    var reusedDetachments = 0;
    var newEnhancements = 0;
    var updatedEnhancements = 0;

    for (final file in dir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.json'))) {
      final factionId = file.uri.pathSegments.last.replaceAll('.json', '');
      final factionExists = await (database.select(database.factions)
            ..where((t) => t.id.equals(factionId)))
          .getSingleOrNull();
      if (factionExists == null) {
        // ignore: avoid_print
        print('SKIP $factionId — faction inconnue en base');
        continue;
      }

      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final detachmentsJson = (data['detachments'] as List).cast<Map>();

      for (final det in detachmentsJson) {
        final name = det['name'] as String;
        final category = det['category'] as String?;
        final commandPoints = det['commandPoints'] as int?;
        final detachmentId = 'det-$factionId-${slugify(name)}';

        final existing = await (database.select(database.detachments)
              ..where((t) => t.id.equals(detachmentId)))
            .getSingleOrNull();
        if (existing == null) {
          final meta = [
            if (commandPoints != null) '$commandPoints PDD',
            if (category != null) category,
          ].join(' · ');
          await database.into(database.detachments).insert(
                DetachmentsCompanion.insert(
                  id: detachmentId,
                  factionId: factionId,
                  name: name,
                  description:
                      Value(meta.isEmpty ? null : '[$meta]'),
                ),
              );
          newDetachments++;
        } else {
          reusedDetachments++;
        }

        for (final enh in (det['enhancements'] as List).cast<Map>()) {
          final enhName = enh['name'] as String?;
          final points = enh['points'] as int?;
          if (enhName == null || enhName.isEmpty || points == null) continue;
          final enhId = 'enh-$detachmentId-${slugify(enhName)}';
          final existingEnh = await (database.select(database.enhancements)
                ..where((t) => t.id.equals(enhId)))
              .getSingleOrNull();
          await database.into(database.enhancements).insertOnConflictUpdate(
                EnhancementsCompanion.insert(
                  id: enhId,
                  detachmentId: detachmentId,
                  name: enhName,
                  points: points,
                ),
              );
          if (existingEnh == null) {
            newEnhancements++;
          } else {
            updatedEnhancements++;
          }
        }
      }
      // ignore: avoid_print
      print('OK $factionId — ${detachmentsJson.length} détachements traités');
    }

    // ignore: avoid_print
    print(
      'TOTAL : $newDetachments détachement(s) créé(s), '
      '$reusedDetachments réutilisé(s), '
      '$newEnhancements enhancement(s) créé(s), '
      '$updatedEnhancements mis à jour.',
    );
    expect(newEnhancements + updatedEnhancements, greaterThan(0));
  });
}
