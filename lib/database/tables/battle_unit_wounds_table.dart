import 'package:drift/drift.dart';

import 'army_units_table.dart';
import 'battles_table.dart';

/// PV restants d'un modèle précis au sein d'une unité (escouade) pour une
/// partie donnée. Une ligne n'existe que si le modèle a perdu des PV (voir
/// [BattleDao.setModelWounds]) — son absence vaut "à son maximum de PV",
/// pour éviter de pré-créer une ligne par modèle à chaque démarrage de
/// partie (une escouade de 20 Boyz n'a pas 20 lignes tant que personne n'a
/// été blessé).
class BattleUnitWounds extends Table {
  TextColumn get id => text()();

  TextColumn get battleId => text().references(Battles, #id)();

  TextColumn get armyUnitId => text().references(ArmyUnits, #id)();

  /// Position du modèle au sein de l'unité (1 à modelCount) — une escouade
  /// de 5 Intercessors a des modèles 1 à 5, chacun suivi indépendamment.
  IntColumn get modelIndex => integer()();

  IntColumn get currentWounds => integer()();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
