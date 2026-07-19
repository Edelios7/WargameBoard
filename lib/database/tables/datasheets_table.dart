import 'package:drift/drift.dart';

import 'factions_table.dart';
import 'sub_factions_table.dart';

class Datasheets extends Table {
  TextColumn get id => text()();

  TextColumn get factionId =>
      text().references(Factions, #id)();

  TextColumn get subFactionId =>
      text()
          .nullable()
          .references(SubFactions, #id)();

  TextColumn get name => text()();

  TextColumn get battlefieldRole => text()();

  TextColumn get unitType => text()();

  BoolColumn get isNamedCharacter =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isEpicHero =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isLegend =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}