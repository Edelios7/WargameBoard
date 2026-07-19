import 'package:drift/drift.dart';

import 'detachments_table.dart';

class Enhancements extends Table {
  TextColumn get id => text()();

  TextColumn get detachmentId => text().references(Detachments, #id)();

  TextColumn get name => text()();

  IntColumn get points => integer()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
