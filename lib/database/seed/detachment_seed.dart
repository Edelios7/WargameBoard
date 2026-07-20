import 'package:drift/drift.dart';

import '../app_database.dart';
import 'faction_seed.dart';

const String detAngelicHost = 'det-angelic-host';

const String enhAngelusBlade = 'enh-angelus-blade';
const String enhDeathVisions = 'enh-death-visions';
const String enhArtificerArmour = 'enh-artificer-armour';

Future<void> seedDetachments(AppDatabase db) async {
  await db.into(db.detachments).insert(
        DetachmentsCompanion.insert(
          id: detAngelicHost,
          factionId: seedFactionId,
          name: 'Angelic Host',
          description: const Value(
            'Détachement orienté assaut aérien, mettant à l\'honneur les '
            'unités dotées de Fly et les charges héroïques.',
          ),
        ),
      );

  final enhancements = <String, ({String name, int points, String description})>{
    enhAngelusBlade: (
      name: 'Angelus Blade',
      points: 15,
      description: 'Une lame héritée du Chapitre, mortelle au corps à corps.',
    ),
    enhDeathVisions: (
      name: 'Death Visions of Sanguinius',
      points: 25,
      description: 'Des visions prophétiques qui aiguisent l\'instinct tactique du porteur.',
    ),
    enhArtificerArmour: (
      name: 'Artificer Armour',
      points: 10,
      description: 'Une armure d\'exception offrant une protection accrue.',
    ),
  };

  for (final entry in enhancements.entries) {
    await db.into(db.enhancements).insert(
          EnhancementsCompanion.insert(
            id: entry.key,
            detachmentId: detAngelicHost,
            name: entry.value.name,
            points: entry.value.points,
            description: Value(entry.value.description),
          ),
        );
  }

  final stratagems = <String, ({String name, int cp, String phase, String description})>{
    'strat-no-escape': (
      name: 'No Escape',
      cp: 1,
      phase: 'Phase de combat',
      description: 'Poursuis un ennemi qui tente de fuir le combat pour l\'achever.',
    ),
    'strat-honour-the-chapter': (
      name: 'Honour the Chapter',
      cp: 1,
      phase: 'N\'importe quelle phase',
      description: 'Relance des jets de blessure ratés pour une unité clé.',
    ),
    'strat-wings-of-fire': (
      name: 'Wings of Fire',
      cp: 2,
      phase: 'Phase de mouvement',
      description: 'Une unité dotée de Fly gagne une mobilité accrue ce tour-ci.',
    ),
  };

  for (final entry in stratagems.entries) {
    await db.into(db.stratagems).insert(
          StratagemsCompanion.insert(
            id: entry.key,
            detachmentId: detAngelicHost,
            name: entry.value.name,
            commandPoints: entry.value.cp,
            phase: Value(entry.value.phase),
            description: Value(entry.value.description),
          ),
        );
  }
}
