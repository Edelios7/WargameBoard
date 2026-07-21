import 'package:drift/drift.dart';

/// Choix d'équipement optionnel fait pour une unité d'armée précise
/// (ex. "cette Escouade Tactique a pris le lance-flammes plutôt que le
/// bolter lourd") — une ligne par option retenue dans un groupe
/// d'équipement (`EquipmentGroups`) de la datasheet. Absence de ligne
/// pour un groupe = options par défaut de la datasheet (`isDefault`).
class ArmyUnitEquipmentSelections extends Table {
  TextColumn get id => text()();

  TextColumn get armyUnitId => text()();

  TextColumn get groupId => text()();

  TextColumn get optionId => text()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
