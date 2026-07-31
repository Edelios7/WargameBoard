import 'package:drift/drift.dart';

import 'armies_table.dart';
import 'datasheets_table.dart';
import 'enhancements_table.dart';

class ArmyUnits extends Table {
  TextColumn get id => text()();

  TextColumn get armyId => text().references(Armies, #id)();

  TextColumn get datasheetId => text().references(Datasheets, #id)();

  TextColumn get enhancementId =>
      text().nullable().references(Enhancements, #id)();

  /// Unité de la même armée à laquelle cette figurine-personnage est
  /// attachée (concept de "Leader" 10e/11e édition) — `null` pour une
  /// unité non attachée. Auto-référence : uniquement rempli sur la ligne
  /// du personnage, jamais sur celle de l'escouade hôte.
  TextColumn get attachedToUnitId =>
      text().nullable().references(ArmyUnits, #id)();

  IntColumn get modelCount => integer()();

  /// Une seule unité par armée peut être le Warlord (concept obligatoire
  /// des règles 10e/11e éditions) — l'unicité est appliquée côté DAO,
  /// pas par une contrainte SQL.
  BoolColumn get isWarlord =>
      boolean().withDefault(const Constant(false))();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
