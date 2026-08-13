// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission_dao.dart';

// ignore_for_file: type=lint
mixin _$MissionDaoMixin on DatabaseAccessor<AppDatabase> {
  $MissionDispositionsTable get missionDispositions =>
      attachedDatabase.missionDispositions;
  $PrimaryMissionsTable get primaryMissions => attachedDatabase.primaryMissions;
  $SecondaryMissionsTable get secondaryMissions =>
      attachedDatabase.secondaryMissions;
  MissionDaoManager get managers => MissionDaoManager(this);
}

class MissionDaoManager {
  final _$MissionDaoMixin _db;
  MissionDaoManager(this._db);
  $$MissionDispositionsTableTableManager get missionDispositions =>
      $$MissionDispositionsTableTableManager(
        _db.attachedDatabase,
        _db.missionDispositions,
      );
  $$PrimaryMissionsTableTableManager get primaryMissions =>
      $$PrimaryMissionsTableTableManager(
        _db.attachedDatabase,
        _db.primaryMissions,
      );
  $$SecondaryMissionsTableTableManager get secondaryMissions =>
      $$SecondaryMissionsTableTableManager(
        _db.attachedDatabase,
        _db.secondaryMissions,
      );
}
