// Construit une table de co-occurrence d'unités à partir des styles de
// liste par faction du guide "Exemples de listes d'armée"
// (lib/domain/rules/rules_data.dart, document id 'guide-listes-d-armee') :
// deux unités qui apparaissent dans le même style de liste sont
// considérées "synergiques". Le résultat sert de base aux recommandations
// d'unités complémentaires dans l'army builder
// (lib/domain/armies/army_recommendations.dart).
//
// Usage : flutter test tools/backfill_army_synergies_test.dart --run-skipped

@Skip('Outil ponctuel, pas un test automatisé — exécuter via --run-skipped')
library;

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/domain/catalog/common/unit_archetype.dart';
import 'package:wargameboard/domain/rules/army_list_style_parser.dart';
import 'package:wargameboard/domain/rules/rules_data.dart';

const _chapterFactionNames = {
  'Blood Angels',
  'Dark Angels',
  'Space Wolves',
  'Black Templars',
  'Deathwatch',
};

String _normalize(String name) => stripAccents(name.toUpperCase());

void main() {
  test('build army_unit_synergies.json from the army-list style guide', () async {
    final dbPath =
        '${Platform.environment['USERPROFILE']}\\Documents\\wargame_board.sqlite';
    final dbFile = File(dbPath);
    if (!dbFile.existsSync()) {
      markTestSkipped('Base introuvable ($dbPath) — lance l\'app une fois.');
      return;
    }

    final db = AppDatabase.forTesting(NativeDatabase(dbFile));
    addTearDown(db.close);

    final factionRows = await db.select(db.factions).get();
    final factionIdByName = {for (final f in factionRows) f.name: f.id};

    // Élargit une faction "chapitre successeur" à son pool générique de
    // troupes Space Marines, même logique que le reste de la session.
    Set<String> factionIdsFor(String factionName) {
      final ids = <String>{};
      final ownId = factionIdByName[factionName];
      if (ownId != null) ids.add(ownId);
      if (_chapterFactionNames.contains(factionName)) {
        for (final entry in factionIdByName.entries) {
          if (entry.key.contains('Space Marines') &&
              !entry.key.contains('Chaos')) {
            ids.add(entry.value);
          }
        }
      }
      return ids;
    }

    final doc = kRuleDocuments.firstWhere(
      (d) => d.id == 'guide-listes-d-armee',
    );
    final byFaction = groupStyleSectionsByFaction(doc.sections);

    final coOccurrence = <String, Map<String, int>>{};
    var stylesProcessed = 0;
    var unitLinesMatched = 0;
    final unmatched = <String>{};

    for (final entry in byFaction.entries) {
      final factionName = entry.key;
      final factionIds = factionIdsFor(factionName);
      if (factionIds.isEmpty) {
        // ignore: avoid_print
        print('Faction introuvable en base : "$factionName" — ignorée.');
        continue;
      }

      final datasheetRows =
          await (db.select(db.datasheets)..where(
                (t) => t.factionId.isIn(factionIds) & t.isActive.equals(true),
              ))
              .get();
      final idByNormalizedName = {
        for (final row in datasheetRows) _normalize(row.name): row.id,
      };

      for (final style in entry.value) {
        stylesProcessed++;
        final ids = <String>{};
        for (final unit in style.units) {
          final id = idByNormalizedName[_normalize(unit.name)];
          if (id == null) {
            unmatched.add('$factionName / ${unit.name}');
            continue;
          }
          ids.add(id);
          unitLinesMatched++;
        }

        for (final a in ids) {
          for (final b in ids) {
            if (a == b) continue;
            final row = coOccurrence.putIfAbsent(a, () => {});
            row[b] = (row[b] ?? 0) + 1;
          }
        }
      }
    }

    final outFile = File(
      r'C:\Projet\wargameboard\assets\data\army_unit_synergies.json',
    );
    outFile.parent.createSync(recursive: true);
    outFile.writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert(coOccurrence),
    );

    // ignore: avoid_print
    print(
      '$stylesProcessed style(s) traité(s), $unitLinesMatched ligne(s) '
      'd\'unité matchée(s), ${unmatched.length} non matchée(s).',
    );
    if (unmatched.isNotEmpty) {
      // ignore: avoid_print
      print('Non matchées (premières 30) :');
      for (final name in unmatched.take(30)) {
        // ignore: avoid_print
        print('  - $name');
      }
    }
    // ignore: avoid_print
    print('Écrit : ${outFile.path}');
  });
}
