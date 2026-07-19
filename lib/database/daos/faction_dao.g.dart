// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faction_dao.dart';

// ignore_for_file: type=lint
mixin _$FactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $FactionsTable get factions => attachedDatabase.factions;
  FactionDaoManager get managers => FactionDaoManager(this);
}

class FactionDaoManager {
  final _$FactionDaoMixin _db;
  FactionDaoManager(this._db);
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db.attachedDatabase, _db.factions);
}
