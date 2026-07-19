// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_dao.dart';

// ignore_for_file: type=lint
mixin _$BattleDaoMixin on DatabaseAccessor<AppDatabase> {
  $BattlesTable get battles => attachedDatabase.battles;
  $ArmiesTable get armies => attachedDatabase.armies;
  BattleDaoManager get managers => BattleDaoManager(this);
}

class BattleDaoManager {
  final _$BattleDaoMixin _db;
  BattleDaoManager(this._db);
  $$BattlesTableTableManager get battles =>
      $$BattlesTableTableManager(_db.attachedDatabase, _db.battles);
  $$ArmiesTableTableManager get armies =>
      $$ArmiesTableTableManager(_db.attachedDatabase, _db.armies);
}
