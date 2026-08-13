import 'package:drift/drift.dart';

import '../app_database.dart';
import '../models/mission_options.dart';
import '../tables/mission_dispositions_table.dart';
import '../tables/primary_missions_table.dart';
import '../tables/secondary_missions_table.dart';

part 'mission_dao.g.dart';

/// Données de référence du pack de missions (postures, missions
/// primaires/secondaires) — voir [seedMissions]. Ces données ne
/// dépendent d'aucune partie précise ; [BattleDao] s'occupe du lien
/// entre une bataille suivie et les missions choisies.
@DriftAccessor(
  tables: [MissionDispositions, PrimaryMissions, SecondaryMissions],
)
class MissionDao extends DatabaseAccessor<AppDatabase> with _$MissionDaoMixin {
  MissionDao(AppDatabase db) : super(db);

  Future<List<DispositionOption>> listDispositions() async {
    final rows = await select(missionDispositions).get();
    return rows
        .map(
          (d) => DispositionOption(id: d.id, slug: d.slug, name: d.name),
        )
        .toList();
  }

  Future<PrimaryMissionDetails?> getPrimaryMission({
    required String yourDispositionId,
    required String opponentDispositionId,
  }) async {
    final row = await (select(primaryMissions)..where(
          (t) =>
              t.yourDispositionId.equals(yourDispositionId) &
              t.opponentDispositionId.equals(opponentDispositionId),
        ))
        .getSingleOrNull();
    if (row == null) return null;
    return PrimaryMissionDetails(
      id: row.id,
      name: row.name,
      scoring: row.scoring,
      action: row.action,
    );
  }

  Future<List<SecondaryMissionOption>> listSecondaryMissions() async {
    final rows =
        await (select(secondaryMissions)
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return rows
        .map(
          (s) => SecondaryMissionOption(
            id: s.id,
            name: s.name,
            isFixed: s.isFixed,
            effect: s.effect,
          ),
        )
        .toList();
  }
}
