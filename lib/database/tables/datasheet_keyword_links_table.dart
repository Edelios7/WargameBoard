import 'package:drift/drift.dart';

class DatasheetKeywordLinks extends Table {
  TextColumn get id => text()();

  TextColumn get datasheetId => text()();

  TextColumn get keywordId => text()();

  @override
  Set<Column> get primaryKey => {id};
}