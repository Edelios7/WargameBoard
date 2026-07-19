// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_system_dao.dart';

// ignore_for_file: type=lint
mixin _$GameSystemDaoMixin on DatabaseAccessor<AppDatabase> {
  $GameSystemsTable get gameSystems => attachedDatabase.gameSystems;
  GameSystemDaoManager get managers => GameSystemDaoManager(this);
}

class GameSystemDaoManager {
  final _$GameSystemDaoMixin _db;
  GameSystemDaoManager(this._db);
  $$GameSystemsTableTableManager get gameSystems =>
      $$GameSystemsTableTableManager(_db.attachedDatabase, _db.gameSystems);
}
