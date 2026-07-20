import 'package:drift/drift.dart';

import 'factions_table.dart';

/// Totaux d'XP cumulés par faction, calculés en parallèle des totaux par
/// catégorie (même XP, vue différente) pour afficher la progression du
/// joueur faction par faction ("Blood Angels niveau 27", etc.).
class XpFactionTotals extends Table {
  TextColumn get factionId => text().references(Factions, #id)();

  IntColumn get xp => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {factionId};
}
