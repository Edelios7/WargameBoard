import 'package:drift/drift.dart';

import 'detachments_table.dart';

class Stratagems extends Table {
  TextColumn get id => text()();

  TextColumn get detachmentId => text().references(Detachments, #id)();

  TextColumn get name => text()();

  IntColumn get commandPoints => integer()();

  TextColumn get phase => text().nullable()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
