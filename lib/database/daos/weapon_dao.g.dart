// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weapon_dao.dart';

// ignore_for_file: type=lint
mixin _$WeaponDaoMixin on DatabaseAccessor<AppDatabase> {
  $WeaponsTable get weapons => attachedDatabase.weapons;
  $WeaponProfilesTable get weaponProfiles => attachedDatabase.weaponProfiles;
  WeaponDaoManager get managers => WeaponDaoManager(this);
}

class WeaponDaoManager {
  final _$WeaponDaoMixin _db;
  WeaponDaoManager(this._db);
  $$WeaponsTableTableManager get weapons =>
      $$WeaponsTableTableManager(_db.attachedDatabase, _db.weapons);
  $$WeaponProfilesTableTableManager get weaponProfiles =>
      $$WeaponProfilesTableTableManager(
        _db.attachedDatabase,
        _db.weaponProfiles,
      );
}
