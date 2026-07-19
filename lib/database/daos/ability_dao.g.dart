// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ability_dao.dart';

// ignore_for_file: type=lint
mixin _$AbilityDaoMixin on DatabaseAccessor<AppDatabase> {
  $AbilitiesTable get abilities => attachedDatabase.abilities;
  AbilityDaoManager get managers => AbilityDaoManager(this);
}

class AbilityDaoManager {
  final _$AbilityDaoMixin _db;
  AbilityDaoManager(this._db);
  $$AbilitiesTableTableManager get abilities =>
      $$AbilitiesTableTableManager(_db.attachedDatabase, _db.abilities);
}
