import 'package:drift/drift.dart';

import 'datasheet_models_table.dart';

class ModelProfiles extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetModelId =>
      text().references(DatasheetModels, #id)();

  TextColumn get name => text()();

  IntColumn get movement => integer()();

  IntColumn get toughness => integer()();

  IntColumn get save => integer()();

  IntColumn get wounds => integer()();

  IntColumn get leadership => integer()();

  IntColumn get objectiveControl => integer()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}