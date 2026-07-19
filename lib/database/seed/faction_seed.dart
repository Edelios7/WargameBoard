import 'package:drift/drift.dart';

import '../app_database.dart';

const String seedGameSystemId = 'gs-w40k';
const String seedEditionId = 'ed-w40k-10e';
const String seedFactionId = 'fac-blood-angels';

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
        ),
      );
}
