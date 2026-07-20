import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/battle_details.dart';
import '../tables/armies_table.dart';
import '../tables/battles_table.dart';
import '../tables/factions_table.dart';

part 'battle_dao.g.dart';

@DriftAccessor(
  tables: [
    Battles,
    Armies,
    Factions,
  ],
)
class BattleDao extends DatabaseAccessor<AppDatabase> with _$BattleDaoMixin {
  BattleDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<String> addBattle({
    String? armyId,
    String? opponentName,
    String? opponentFactionId,
    String? location,
    String? missionName,
    BattleResult? result,
    BattleType type = BattleType.matched,
    int? myScore,
    int? opponentScore,
    String? notes,
    DateTime? playedAt,
  }) async {
    final id = _uuid.v4();
    await into(battles).insert(
      BattlesCompanion.insert(
        id: id,
        armyId: Value(armyId),
        opponentName: Value(opponentName),
        opponentFactionId: Value(opponentFactionId),
        location: Value(location),
        missionName: Value(missionName),
        result: Value(result),
        type: Value(type),
        myScore: Value(myScore),
        opponentScore: Value(opponentScore),
        notes: Value(notes),
        playedAt: playedAt != null ? Value(playedAt) : const Value.absent(),
      ),
    );
    return id;
  }

  Future<void> deleteBattle(String id) {
    return (delete(battles)..where((t) => t.id.equals(id))).go();
  }

  BattleDetails _fromRow(TypedResult row) {
    final battle = row.readTable(battles);
    final army = row.readTableOrNull(armies);
    final opponentFaction = row.readTableOrNull(factions);
    return BattleDetails(
      id: battle.id,
      armyId: army?.id,
      armyName: army?.name,
      opponentName: battle.opponentName,
      opponentFactionId: opponentFaction?.id,
      opponentFactionName: opponentFaction?.name,
      location: battle.location,
      missionName: battle.missionName,
      result: battle.result,
      type: battle.type,
      myScore: battle.myScore,
      opponentScore: battle.opponentScore,
      notes: battle.notes,
      playedAt: battle.playedAt,
    );
  }

  Future<List<BattleDetails>> listBattles() async {
    final query = select(battles).join([
      leftOuterJoin(armies, armies.id.equalsExp(battles.armyId)),
      leftOuterJoin(
        factions,
        factions.id.equalsExp(battles.opponentFactionId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(battles.playedAt)]);

    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  /// Prochaine partie programmée (date future, sans résultat renseigné).
  Future<BattleDetails?> getNextUpcoming() async {
    final query = select(battles).join([
      leftOuterJoin(armies, armies.id.equalsExp(battles.armyId)),
      leftOuterJoin(
        factions,
        factions.id.equalsExp(battles.opponentFactionId),
      ),
    ])
      ..where(
        battles.playedAt.isBiggerThanValue(DateTime.now()) &
            battles.result.isNull(),
      )
      ..orderBy([OrderingTerm.asc(battles.playedAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// Dernière partie jouée (résultat renseigné), la plus récente.
  Future<BattleDetails?> getLastPlayed() async {
    final query = select(battles).join([
      leftOuterJoin(armies, armies.id.equalsExp(battles.armyId)),
      leftOuterJoin(
        factions,
        factions.id.equalsExp(battles.opponentFactionId),
      ),
    ])
      ..where(battles.result.isNotNull())
      ..orderBy([OrderingTerm.desc(battles.playedAt)])
      ..limit(1);

    final row = await query.getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }
}
