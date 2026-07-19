import 'package:drift/drift.dart';

class WeaponKeywordLinks extends Table {
  TextColumn get id => text()();

  TextColumn get weaponId => text()();

  TextColumn get keywordId => text()();

  @override
  Set<Column> get primaryKey => {id};
}