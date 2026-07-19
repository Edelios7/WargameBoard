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

  IntColumn get modelCount => integer()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
