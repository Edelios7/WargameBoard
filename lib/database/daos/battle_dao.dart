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

  /// Supprime une partie et tout ce qui lui est propre — le journal,
  /// mais aussi l'état par unité de cette partie précise (unités
  /// marquées détruites, bonus/malus, PV), qui resterait sinon orphelin
  /// (aucun `ON DELETE CASCADE` en base).
  /// Ligne brute d'une partie (pas de jointure) — utilisé par
  /// [BattleRepository.deleteBattle] pour savoir si de l'XP a été
  /// créditée pour cette partie avant de la supprimer.
  Future<Battle?> getBattleRow(String id) {
    return (select(battles)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> deleteBattle(String id) async {
    await (delete(battleEvents)..where((t) => t.battleId.equals(id))).go();
    await (delete(battleUnitStates)..where((t) => t.battleId.equals(id))).go();
    await (delete(
      battleUnitModifiers,
    )..where((t) => t.battleId.equals(id))).go();
    await (delete(battleUnitWounds)..where((t) => t.battleId.equals(id))).go();
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
    final query = select(battles).join(_baseJoins())
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
    final query = select(battles).join(_baseJoins())
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
    final query = select(battles).join(_baseJoins())
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
    final query = select(battles).join(_baseJoins())
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

  /// Revient à la phase précédente — un joueur qui a avancé par erreur
  /// (dés en main, écran vite tapé) n'a pas à recompter manuellement où
  /// il en était. Ne fait rien si déjà à la toute première phase du
  /// round 1 (rien à annuler).
  ///
  /// Annule aussi la variation de PC des événements de la phase qu'on
  /// quitte (comme [deleteEvent]) — sinon le round/phase affichés
  /// reviendraient en arrière alors que des PC dépensés pendant cette
  /// phase resteraient décomptés, désynchronisant l'affichage et le
  /// journal. Ne supprime PAS l'événement lui-même quand il ne porte
  /// aucune variation de PC (une simple note ou un jet de dés logué à la
  /// main) : le journal de bataille est la seule trace de ce qui a été
  /// fait pendant la partie, un retour en arrière de phase ne doit pas
  /// faire disparaître silencieusement ce que le joueur a pris le temps
  /// de noter.
  Future<void> previousPhase(String battleId) async {
    final battle = await (select(
      battles,
    )..where((t) => t.id.equals(battleId))).getSingle();

    final currentPhase = battle.currentPhase ?? _battlePhaseOrder.first;
    final currentIndex = _battlePhaseOrder.indexOf(currentPhase);
    final currentRound = battle.currentRound ?? 1;
    final isFirstPhase = currentIndex == 0;
    if (isFirstPhase && currentRound <= 1) return;

    final eventsInLeavingPhase =
        await (select(battleEvents)..where(
              (t) =>
                  t.battleId.equals(battleId) &
                  t.round.equals(currentRound) &
                  t.phase.equalsValue(currentPhase),
            ))
            .get();
    for (final event in eventsInLeavingPhase) {
      if (event.cpDelta != null || event.opponentCpDelta != null) {
        // deleteEvent annule la variation de CP de l'événement supprimé,
        // donc les PC affichés restent cohérents avec le journal.
        await deleteEvent(event.id);
      }
    }

    await updateLiveState(
      battleId,
      currentPhase: Value(
        isFirstPhase
            ? _battlePhaseOrder.last
            : _battlePhaseOrder[currentIndex - 1],
      ),
      currentRound: isFirstPhase
          ? Value(currentRound - 1)
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

  /// Dépense des CP (ex. coût d'un stratagème) et journalise l'événement
  /// en une seule opération transactionnelle : relit le total actuel
  /// depuis la base juste avant d'écrire, plutôt que de faire confiance à
  /// une valeur passée par l'appelant — deux appels concurrents (double
  /// clic, deux stratagèmes coup sur coup avant que l'UI ne se
  /// reconstruise) se sérialisent alors correctement au lieu d'écraser le
  /// même total et de journaliser deux dépenses pour une seule déduction
  /// réellement appliquée.
  /// Retire `amount` PC et journalise la dépense — retourne `false` (et ne
  /// touche à rien) si le solde actuel est insuffisant, plutôt que
  /// d'accepter silencieusement une dépense partielle : sans ce garde-fou,
  /// deux stratagèmes cliqués coup sur coup avec 1PC en réserve pouvaient
  /// tous les deux "réussir" (le second ramenant simplement le solde de 0
  /// à 0) alors qu'un seul aurait dû passer.
  Future<bool> spendCommandPoints(
    String battleId, {
    required bool mine,
    required int amount,
    required String label,
    int? round,
    BattlePhase? phase,
  }) async {
    return transaction(() async {
      final battle = await (select(
        battles,
      )..where((t) => t.id.equals(battleId))).getSingle();

      final current = mine
          ? (battle.myCommandPoints ?? 0)
          : (battle.opponentCommandPoints ?? 0);
      if (current < amount) {
        return false;
      }
      final next = current - amount;

      await (update(battles)..where((t) => t.id.equals(battleId))).write(
        BattlesCompanion(
          myCommandPoints: mine ? Value(next) : const Value.absent(),
          opponentCommandPoints: mine ? const Value.absent() : Value(next),
        ),
      );

      await into(battleEvents).insert(
        BattleEventsCompanion.insert(
          id: _uuid.v4(),
          battleId: battleId,
          round: Value(round),
          phase: Value(phase),
          label: label,
          cpDelta: mine ? Value(-amount) : const Value.absent(),
          opponentCpDelta: mine ? const Value.absent() : Value(-amount),
        ),
      );
      return true;
    });
  }

  /// Ajoute (ou retire) `delta` au score d'un camp, en relisant la valeur
  /// actuelle en base à l'intérieur d'une transaction — pas depuis une
  /// valeur déjà chargée côté widget, qui peut être périmée. Sans cette
  /// relecture, deux clics rapprochés sur "+" (avant que le premier ait eu
  /// le temps de se répercuter dans l'état Riverpod) partaient tous les
  /// deux de la même valeur de départ et ne faisaient gagner qu'un seul
  /// point net au lieu de deux.
  Future<void> adjustScore(
    String battleId, {
    required bool mine,
    required int delta,
  }) {
    return transaction(() async {
      final battle = await (select(
        battles,
      )..where((t) => t.id.equals(battleId))).getSingle();
      final current = mine
          ? (battle.myScore ?? 0)
          : (battle.opponentScore ?? 0);
      final next = (current + delta).clamp(0, 1 << 30);

      await (update(battles)..where((t) => t.id.equals(battleId))).write(
        BattlesCompanion(
          myScore: mine ? Value(next) : const Value.absent(),
          opponentScore: mine ? const Value.absent() : Value(next),
        ),
      );
    });
  }

  /// Ajoute (ou retire) `delta` aux PC d'un camp et journalise l'écart
  /// réellement appliqué (borné à 0) — même relecture en transaction que
  /// [adjustScore], pour la même raison (deux clics rapprochés sur "+1
  /// PC" ne doivent pas partir de la même valeur de départ périmée).
  Future<void> adjustCommandPoints(
    String battleId, {
    required bool mine,
    required int delta,
    required String label,
    int? round,
    BattlePhase? phase,
  }) {
    return transaction(() async {
      final battle = await (select(
        battles,
      )..where((t) => t.id.equals(battleId))).getSingle();
      final current = mine
          ? (battle.myCommandPoints ?? 0)
          : (battle.opponentCommandPoints ?? 0);
      final next = (current + delta).clamp(0, 1 << 30);
      final appliedDelta = next - current;

      await (update(battles)..where((t) => t.id.equals(battleId))).write(
        BattlesCompanion(
          myCommandPoints: mine ? Value(next) : const Value.absent(),
          opponentCommandPoints: mine ? const Value.absent() : Value(next),
        ),
      );

      if (appliedDelta != 0) {
        await into(battleEvents).insert(
          BattleEventsCompanion.insert(
            id: _uuid.v4(),
            battleId: battleId,
            round: Value(round),
            phase: Value(phase),
            label: label,
            cpDelta: mine ? Value(appliedDelta) : const Value.absent(),
            opponentCpDelta: mine ? const Value.absent() : Value(appliedDelta),
          ),
        );
      }
    });
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
                  t.battleId.equals(battleId) & t.armyUnitId.equals(armyUnitId),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (update(battleUnitStates)..where((t) => t.id.equals(existing.id)))
          .write(BattleUnitStatesCompanion(destroyed: Value(destroyed)));
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
    final rows =
        await (select(battleUnitStates)..where(
              (t) => t.battleId.equals(battleId) & t.destroyed.equals(true),
            ))
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
    final rows =
        await (select(battleUnitModifiers)
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
    final existing =
        await (select(battleUnitWounds)..where(
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
