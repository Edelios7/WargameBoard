import 'package:drift/drift.dart';

class Projects extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  BoolColumn get done => boolean().withDefault(const Constant(false))();

  IntColumn get progressPercent => integer().nullable()();

  IntColumn get displayOrder =>
      integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
