import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/battle_details.dart';
import '../models/battle_event_details.dart';
import '../models/battle_unit_modifier_details.dart';
import '../models/battle_unit_state_details.dart';
import '../models/battle_unit_wound_details.dart';
import '../tables/armies_table.dart';
import '../tables/battle_events_table.dart';
import '../tables/battle_unit_modifiers_table.dart';
import '../tables/battle_unit_states_table.dart';
import '../tables/battle_unit_wounds_table.dart';
import '../tables/battles_table.dart';
import '../tables/factions_table.dart';

part 'battle_dao.g.dart';

/// Ordre des phases d'un tour (10e/11e éditions) suivi par
/// [BattleDao.advancePhase].
const _battlePhaseOrder = [
  BattlePhase.command,
  BattlePhase.movement,
  BattlePhase.shooting,
  BattlePhase.charge,
  BattlePhase.fight,
  BattlePhase.morale,
];

@DriftAccessor(
  tables: [
    Battles,
    BattleEvents,
    BattleUnitStates,
    BattleUnitModifiers,
    BattleUnitWounds,
    Armies,
    Factions,
  ],
)
class BattleDao extends DatabaseAccessor<AppDatabase> with _$BattleDaoMixin {
  BattleDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  /// La table `armies` est jointe deux fois (mon armée, armée adverse) —
  /// un alias est nécessaire pour la seconde occurrence.
  late final $ArmiesTable _opponentArmies = alias(armies, 'opponentArmies');

  List<Join> _baseJoins() => [
    leftOuterJoin(armies, armies.id.equalsExp(battles.armyId)),
    leftOuterJoin(
      _opponentArmies,
      _opponentArmies.id.equalsExp(battles.opponentArmyId),
    ),
    leftOuterJoin(factions, factions.id.equalsExp(battles.opponentFactionId)),
  ];

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

  Future<void> deleteBattle(String id) async {
    await (delete(battleEvents)..where((t) => t.battleId.equals(id))).go();
    await (delete(battles)..where((t) => t.id.equals(id))).go();
  }

  BattleDetails _fromRow(TypedResult row) {
    final battle = row.readTable(battles);
    final army = row.readTableOrNull(armies);
    final opponentArmy = row.readTableOrNull(_opponentArmies);
    final opponentFaction = row.readTableOrNull(factions);
    return BattleDetails(
      id: battle.id,
      armyId: army?.id,
      armyName: army?.name,
      opponentArmyId: opponentArmy?.id,
      opponentArmyName: opponentArmy?.name,
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
      status: battle.status,
      currentRound: battle.currentRound,
      currentPhase: battle.currentPhase,
      myCommandPoints: battle.myCommandPoints,
      opponentCommandPoints: battle.opponentCommandPoints,
      missionPack: battle.missionPack,
      terrain: battle.terrain,
      pointsLimit: battle.pointsLimit,
      myTurnActive: battle.myTurnActive,
    );
  }

  /// Historique des parties terminées — exclut les parties en cours de
  /// suivi en direct (voir [getActiveBattle]), sans quoi une partie non
  /// finalisée polluerait l'historique et les statistiques.
  Future<List<BattleDetails>> listBattles() async {
    final query =
        select(battles).join(_baseJoins())
          ..where(
            battles.status.isNull() |
                battles.status.equalsValue(BattleStatus.completed),
          )
          ..orderBy([OrderingTerm.desc(battles.playedAt)]);

    final rows = await query.get();
    return rows.map(_fromRow).toList();
  }

  /// Prochaine partie programmée (date future, sans résultat renseigné).
  Future<BattleDetails?> getNextUpcoming() async {
    final query =
        select(battles).join(_baseJoins())
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
    final query =
        select(battles).join(_baseJoins())
          ..where(battles.result.isNotNull())
          ..orderBy([OrderingTerm.desc(battles.playedAt)])
          ..limit(1);

    final row = await query.getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  // =========================
  // Suivi de partie en direct
  // =========================

  /// Démarre une nouvelle partie suivie en direct (écran Bataille) :
  /// round 1, phase Commandement, CP à 0.
  Future<String> startBattle({
    String? armyId,
    String? opponentArmyId,
    String? opponentName,
    String? opponentFactionId,
    int? pointsLimit,
    String? missionName,
    String? missionPack,
    String? terrain,
    BattleType type = BattleType.matched,
  }) async {
    final id = _uuid.v4();
    await into(battles).insert(
      BattlesCompanion.insert(
        id: id,
        armyId: Value(armyId),
        opponentArmyId: Value(opponentArmyId),
        opponentName: Value(opponentName),
        opponentFactionId: Value(opponentFactionId),
        missionName: Value(missionName),
        type: Value(type),
        status: const Value(BattleStatus.setup),
        currentRound: const Value(1),
        currentPhase: const Value(BattlePhase.command),
        myCommandPoints: const Value(0),
        opponentCommandPoints: const Value(0),
        missionPack: Value(missionPack),
        terrain: Value(terrain),
        pointsLimit: Value(pointsLimit),
        myTurnActive: const Value(true),
      ),
    );
    return id;
  }

  /// Partie en cours de suivi en direct (setup ou active), la plus
  /// récente — permet de proposer de reprendre la partie au redémarrage
  /// de l'app.
  Future<BattleDetails?> getActiveBattle() async {
    final query =
        select(battles).join(_baseJoins())
          ..where(
            battles.status.equalsValue(BattleStatus.setup) |
                battles.status.equalsValue(BattleStatus.active),
          )
          ..orderBy([OrderingTerm.desc(battles.createdAt)])
          ..limit(1);

    final row = await query.getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  /// Mise à jour partielle de l'état en direct d'une partie — seuls les
  /// champs passés en [Value] non absente sont modifiés.
  Future<void> updateLiveState(
    String battleId, {
    Value<BattleStatus?> status = const Value.absent(),
    Value<int?> currentRound = const Value.absent(),
    Value<BattlePhase?> currentPhase = const Value.absent(),
    Value<int?> myCommandPoints = const Value.absent(),
    Value<int?> opponentCommandPoints = const Value.absent(),
    Value<int?> myScore = const Value.absent(),
    Value<int?> opponentScore = const Value.absent(),
    Value<bool?> myTurnActive = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) {
    return (update(battles)..where((t) => t.id.equals(battleId))).write(
      BattlesCompanion(
        status: status,
        currentRound: currentRound,
        currentPhase: currentPhase,
        myCommandPoints: myCommandPoints,
        opponentCommandPoints: opponentCommandPoints,
        myScore: myScore,
        opponentScore: opponentScore,
        myTurnActive: myTurnActive,
        notes: notes,
      ),
    );
  }

  /// Passe à la phase suivante du round courant ; après Moral, repart en
  /// Commandement du round suivant. Passe aussi le statut à `active` s'il
  /// était encore `setup`.
  Future<void> advancePhase(String battleId) async {
    final battle = await (select(
      battles,
    )..where((t) => t.id.equals(battleId))).getSingle();

    final currentIndex = battle.currentPhase == null
        ? -1
        : _battlePhaseOrder.indexOf(battle.currentPhase!);
    final isLastPhase = currentIndex == _battlePhaseOrder.length - 1;

    await updateLiveState(
      battleId,
      status: const Value(BattleStatus.active),
      currentPhase: Value(
        isLastPhase
            ? _battlePhaseOrder.first
            : _battlePhaseOrder[currentIndex + 1],
      ),
      currentRound: isLastPhase
          ? Value((battle.currentRound ?? 1) + 1)
          : const Value.absent(),
    );
  }

  Future<void> logEvent(
    String battleId, {
    required String label,
    int? cpDelta,
    int? opponentCpDelta,
    int? round,
    BattlePhase? phase,
  }) async {
    await into(battleEvents).insert(
      BattleEventsCompanion.insert(
        id: _uuid.v4(),
        battleId: battleId,
        label: label,
        cpDelta: Value(cpDelta),
        opponentCpDelta: Value(opponentCpDelta),
        round: Value(round),
        phase: Value(phase),
      ),
    );
  }

  Future<List<BattleEventDetails>> getEvents(String battleId) async {
    final rows =
        await (select(battleEvents)
              ..where((t) => t.battleId.equals(battleId))
              ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
            .get();
    return rows
        .map(
          (row) => BattleEventDetails(
            id: row.id,
            battleId: row.battleId,
            round: row.round,
            phase: row.phase,
            label: row.label,
            cpDelta: row.cpDelta,
            opponentCpDelta: row.opponentCpDelta,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  /// Supprime un événement du journal ("annuler") — si l'événement portait
  /// une variation de CP (mienne et/ou adverse), la variation est
  /// annulée en sens inverse sur la partie en cours, bornée à 0.
  Future<void> deleteEvent(String eventId) async {
    final event = await (select(
      battleEvents,
    )..where((t) => t.id.equals(eventId))).getSingleOrNull();
    if (event == null) return;

    await (delete(battleEvents)..where((t) => t.id.equals(eventId))).go();

    if (event.cpDelta == null && event.opponentCpDelta == null) return;

    final battle = await (select(
      battles,
    )..where((t) => t.id.equals(event.battleId))).getSingleOrNull();
    if (battle == null) return;

    await updateLiveState(
      event.battleId,
      myCommandPoints: event.cpDelta == null
          ? const Value.absent()
          : Value(
              ((battle.myCommandPoints ?? 0) - event.cpDelta!).clamp(
                0,
                1 << 30,
              ),
            ),
      opponentCommandPoints: event.opponentCpDelta == null
          ? const Value.absent()
          : Value(
              ((battle.opponentCommandPoints ?? 0) - event.opponentCpDelta!)
                  .clamp(0, 1 << 30),
            ),
    );
  }

  /// Finalise une partie suivie en direct — bascule son statut à
  /// `completed`, ce qui la fait apparaître dans l'historique/les stats.
  Future<void> finishBattle(
    String battleId, {
    BattleResult? result,
    int? myScore,
    int? opponentScore,
    String? notes,
  }) {
    return (update(battles)..where((t) => t.id.equals(battleId))).write(
      BattlesCompanion(
        status: const Value(BattleStatus.completed),
        result: Value(result),
        myScore: Value(myScore),
        opponentScore: Value(opponentScore),
        notes: Value(notes),
      ),
    );
  }

  // =========================
  // État des unités en direct
  // =========================

  /// Marque une unité comme détruite ou de nouveau vivante. Une ligne
  /// n'existe en base que pour les unités touchées au moins une fois
  /// (voir [BattleUnitStates]) : upsert manuel plutôt qu'un simple
  /// update, faute de contrainte d'unicité (battleId, armyUnitId) sur
  /// laquelle s'appuyer côté SQL.
  Future<void> setUnitDestroyed(
    String battleId,
    String armyUnitId, {
    required bool destroyed,
  }) async {
    final existing =
        await (select(battleUnitStates)..where(
              (t) =>
                  t.battleId.equals(battleId) &
                  t.armyUnitId.equals(armyUnitId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (update(
        battleUnitStates,
      )..where((t) => t.id.equals(existing.id))).write(
        BattleUnitStatesCompanion(destroyed: Value(destroyed)),
      );
      return;
    }

    await into(battleUnitStates).insert(
      BattleUnitStatesCompanion.insert(
        id: _uuid.v4(),
        battleId: battleId,
        armyUnitId: armyUnitId,
        destroyed: Value(destroyed),
      ),
    );
  }

  /// Unités marquées détruites pour cette partie — les unités absentes de
  /// la liste sont considérées vivantes par défaut.
  Future<List<BattleUnitStateDetails>> getUnitStates(String battleId) async {
    final rows = await (select(
      battleUnitStates,
    )..where((t) => t.battleId.equals(battleId) & t.destroyed.equals(true)))
        .get();
    return rows
        .map(
          (row) => BattleUnitStateDetails(
            armyUnitId: row.armyUnitId,
            destroyed: row.destroyed,
          ),
        )
        .toList();
  }

  Future<String> addUnitModifier(
    String battleId,
    String armyUnitId, {
    required BattleStatKey statKey,
    required int delta,
    String? label,
  }) async {
    final id = _uuid.v4();
    await into(battleUnitModifiers).insert(
      BattleUnitModifiersCompanion.insert(
        id: id,
        battleId: battleId,
        armyUnitId: armyUnitId,
        statKey: statKey,
        delta: delta,
        label: Value(label),
      ),
    );
    return id;
  }

  Future<void> removeUnitModifier(String modifierId) {
    return (delete(
      battleUnitModifiers,
    )..where((t) => t.id.equals(modifierId))).go();
  }

  /// Modificateurs actifs pour cette partie, toutes unités confondues —
  /// à filtrer côté appelant par `armyUnitId`.
  Future<List<BattleUnitModifierDetails>> getUnitModifiers(
    String battleId,
  ) async {
    final rows = await (select(battleUnitModifiers)
          ..where((t) => t.battleId.equals(battleId))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows
        .map(
          (row) => BattleUnitModifierDetails(
            id: row.id,
            armyUnitId: row.armyUnitId,
            statKey: row.statKey,
            delta: row.delta,
            label: row.label,
            createdAt: row.createdAt,
          ),
        )
        .toList();
  }

  // =========================
  // PV des modèles en direct
  // =========================

  /// Fixe les PV restants d'un modèle précis d'une unité (son numéro dans
  /// l'escouade, 1 à modelCount). Une fois revenu à son [maxWounds] (ou
  /// au-delà), la ligne est supprimée plutôt que gardée à sa valeur max —
  /// cohérent avec le reste du suivi en direct (absence = valeur par
  /// défaut).
  Future<void> setModelWounds(
    String battleId,
    String armyUnitId,
    int modelIndex, {
    required int currentWounds,
    required int maxWounds,
  }) async {
    final clamped = currentWounds.clamp(0, maxWounds);
    final existing = await (select(battleUnitWounds)..where(
          (t) =>
              t.battleId.equals(battleId) &
              t.armyUnitId.equals(armyUnitId) &
              t.modelIndex.equals(modelIndex),
        ))
        .getSingleOrNull();

    if (clamped >= maxWounds) {
      if (existing != null) {
        await (delete(
          battleUnitWounds,
        )..where((t) => t.id.equals(existing.id))).go();
      }
      return;
    }

    if (existing != null) {
      await (update(
        battleUnitWounds,
      )..where((t) => t.id.equals(existing.id))).write(
        BattleUnitWoundsCompanion(
          currentWounds: Value(clamped),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return;
    }

    await into(battleUnitWounds).insert(
      BattleUnitWoundsCompanion.insert(
        id: _uuid.v4(),
        battleId: battleId,
        armyUnitId: armyUnitId,
        modelIndex: modelIndex,
        currentWounds: clamped,
      ),
    );
  }

  /// Modèles blessés pour cette partie, toutes unités confondues — les
  /// modèles absents de la liste sont à leur maximum de PV par défaut.
  Future<List<BattleUnitWoundDetails>> getUnitWounds(String battleId) async {
    final rows = await (select(
      battleUnitWounds,
    )..where((t) => t.battleId.equals(battleId))).get();
    return rows
        .map(
          (row) => BattleUnitWoundDetails(
            armyUnitId: row.armyUnitId,
            modelIndex: row.modelIndex,
            currentWounds: row.currentWounds,
          ),
        )
        .toList();
  }
}
