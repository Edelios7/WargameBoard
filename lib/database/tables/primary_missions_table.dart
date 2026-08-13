import 'package:drift/drift.dart';

import 'mission_dispositions_table.dart';

/// Mission primaire résultant du croisement de ta posture et de celle de
/// l'adversaire (25 lignes : 5 postures × 5 postures adverses). [scoring]
/// contient le texte complet des conditions de score, [action] le texte
/// de l'Action au dos de la carte quand la mission en a une (`null`
/// sinon).
class PrimaryMissions extends Table {
  TextColumn get id => text()();

  TextColumn get yourDispositionId =>
      text().references(MissionDispositions, #id)();

  TextColumn get opponentDispositionId =>
      text().references(MissionDispositions, #id)();

  TextColumn get name => text()();

  TextColumn get scoring => text()();

  TextColumn get action => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
