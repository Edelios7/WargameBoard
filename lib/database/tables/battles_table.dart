import 'package:drift/drift.dart';

import 'armies_table.dart';
import 'factions_table.dart';

enum BattleResult { victory, defeat, draw }

enum BattleType { matched, narrative, tournament, crusade }

/// État d'une partie suivie en direct (voir `BattleDao.startBattle`) — les
/// lignes créées via l'ancien flux rétroactif (`addBattle`) n'ont pas de
/// statut (`null`), toujours traitées comme `completed` côté Dart.
enum BattleStatus { setup, active, completed }

/// Phase du tour de jeu actif (10e/11e éditions) — utilisée uniquement par
/// le suivi de partie en direct, `null` pour les parties rétroactives.
enum BattlePhase { command, movement, shooting, charge, fight, morale }

class Battles extends Table {
  TextColumn get id => text()();

  TextColumn get armyId => text().nullable().references(Armies, #id)();

  /// Armée existante (parmi les miennes) utilisée pour représenter la
  /// liste de l'adversaire, quand elle est connue/enregistrée — permet
  /// de suivre son roster (unités détruites, bonus/malus) comme pour
  /// [armyId]. Optionnel : [opponentName]/[opponentFactionId] restent le
  /// mode "texte libre" par défaut.
  TextColumn get opponentArmyId =>
      text().nullable().references(Armies, #id)();

  TextColumn get opponentName => text().nullable()();

  TextColumn get opponentFactionId =>
      text().nullable().references(Factions, #id)();

  TextColumn get location => text().nullable()();

  TextColumn get missionName => text().nullable()();

  TextColumn get result => textEnum<BattleResult>().nullable()();

  TextColumn get type =>
      textEnum<BattleType>().withDefault(Constant(BattleType.matched.name))();

  IntColumn get myScore => integer().nullable()();

  IntColumn get opponentScore => integer().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Colonnes du suivi de partie en direct (tranche "Bataille" live) — toutes
  // nullable, `null` = ligne créée via l'ancien flux rétroactif.
  TextColumn get status => textEnum<BattleStatus>().nullable()();

  IntColumn get currentRound => integer().nullable()();

  TextColumn get currentPhase => textEnum<BattlePhase>().nullable()();

  IntColumn get myCommandPoints => integer().nullable()();

  IntColumn get opponentCommandPoints => integer().nullable()();

  TextColumn get missionPack => text().nullable()();

  TextColumn get terrain => text().nullable()();

  IntColumn get pointsLimit => integer().nullable()();

  /// `true` = c'est mon tour actif, `false` = celui de l'adversaire.
  BoolColumn get myTurnActive => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
