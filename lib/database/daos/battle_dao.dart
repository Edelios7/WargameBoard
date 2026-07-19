import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/battle_details.dart';
import '../tables/armies_table.dart';
import '../tables/battles_table.dart';

part 'battle_dao.g.dart';

@DriftAccessor(
  tables: [
    Battles,
    Armies,
  ],
)
class BattleDao extends DatabaseAccessor<AppDatabase> with _$BattleDaoMixin {
  BattleDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<String> addBattle({
    String? armyId,
    String? opponentName,
    String? missionName,
    BattleResult? result,
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
        missionName: Value(missionName),
        result: Value(result),
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

  Future<List<BattleDetails>> listBattles() async {
    final query = select(battles).join([
      leftOuterJoin(armies, armies.id.equalsExp(battles.armyId)),
    ])
      ..orderBy([OrderingTerm.desc(battles.playedAt)]);

    final rows = await query.get();
    return rows.map((row) {
      final battle = row.readTable(battles);
      final army = row.readTableOrNull(armies);
      return BattleDetails(
        id: battle.id,
        armyId: army?.id,
        armyName: army?.name,
        opponentName: battle.opponentName,
        missionName: battle.missionName,
        result: battle.result,
        myScore: battle.myScore,
        opponentScore: battle.opponentScore,
        notes: battle.notes,
        playedAt: battle.playedAt,
      );
    }).toList();
  }
}
