import 'package:drift/drift.dart';

class DatasheetAbilityLinks extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get abilityId => text()();

  @override
  Set<Column> get primaryKey => {id};
}