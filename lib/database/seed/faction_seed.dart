import 'package:drift/drift.dart';

import '../app_database.dart';

const String seedGameSystemId = 'gs-w40k';
const String seedEditionId = 'ed-w40k-10e';
const String seedFactionId = 'fac-blood-angels';
const String seedOrksFactionId = 'fac-orks';
const String seedSpaceMarinesFactionId = 'fac-space-marines-adeptus-astartes';

Future<void> seedFactions(AppDatabase db) async {
  await db.into(db.gameSystems).insert(
        GameSystemsCompanion.insert(
          id: seedGameSystemId,
          name: 'Warhammer 40,000',
          shortName: const Value('W40K'),
        ),
      );

  await db.into(db.editions).insert(
        EditionsCompanion.insert(
          id: seedEditionId,
          gameSystemId: seedGameSystemId,
          name: '10th Edition',
          version: 10,
          isCurrent: const Value(true),
        ),
      );

  await db.into(db.factions).insert(
        FactionsCompanion.insert(
          id: seedFactionId,
          gameSystemId: seedGameSystemId,
          name: 'Blood Angels',
          shortName: const Value('BA'),
          description: const Value(
            "Chapitre de Space Marines héritier de Sanguinius, "
            "réputé pour sa noblesse héroïque et sa soif de sang.",
          ),
          displayOrder: const Value(0),
        ),
      );

  await db.into(db.factions).insert(
        FactionsCompanion.insert(
          id: seedOrksFactionId,
          gameSystemId: seedGameSystemId,
          name: 'Orks',
          shortName: const Value('Orks'),
          description: const Value(
            "Race xénos brutale et prolifique, animée par une joie féroce "
            "du combat et une technologie aussi rudimentaire qu'efficace.",
          ),
          displayOrder: const Value(1),
        ),
      );

  // Faction générique, distincte de chaque chapitre (ex. Blood Angels) —
  // reproduit la structure des données réelles importées, où les unités
  // Space Marines "de base" (non propres à un chapitre) vivent sous
  // cette faction plutôt que sous celle du chapitre.
  await db.into(db.factions).insert(
        FactionsCompanion.insert(
          id: seedSpaceMarinesFactionId,
          gameSystemId: seedGameSystemId,
          name: 'Space Marines (Adeptus Astartes)',
          shortName: const Value('SM'),
          description: const Value(
            "Guerriers post-humains de l'Adeptus Astartes, socle commun à "
            "tous les chapitres de Space Marines.",
          ),
          displayOrder: const Value(2),
        ),
      );
}
