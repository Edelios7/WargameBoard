// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battle_dao.dart';

// ignore_for_file: type=lint
mixin _$BattleDaoMixin on DatabaseAccessor<AppDatabase> {
  $BattlesTable get battles => attachedDatabase.battles;
  $BattleEventsTable get battleEvents => attachedDatabase.battleEvents;
  $BattleUnitStatesTable get battleUnitStates =>
      attachedDatabase.battleUnitStates;
  $BattleUnitModifiersTable get battleUnitModifiers =>
      attachedDatabase.battleUnitModifiers;
  $BattleUnitWoundsTable get battleUnitWounds =>
      attachedDatabase.battleUnitWounds;
  $ArmiesTable get armies => attachedDatabase.armies;
  $FactionsTable get factions => attachedDatabase.factions;
  BattleDaoManager get managers => BattleDaoManager(this);
}

class BattleDaoManager {
  final _$BattleDaoMixin _db;
  BattleDaoManager(this._db);
  $$BattlesTableTableManager get battles =>
      $$BattlesTableTableManager(_db.attachedDatabase, _db.battles);
  $$BattleEventsTableTableManager get battleEvents =>
      $$BattleEventsTableTableManager(_db.attachedDatabase, _db.battleEvents);
  $$BattleUnitStatesTableTableManager get battleUnitStates =>
      $$BattleUnitStatesTableTableManager(
        _db.attachedDatabase,
        _db.battleUnitStates,
      );
  $$BattleUnitModifiersTableTableManager get battleUnitModifiers =>
      $$BattleUnitModifiersTableTableManager(
        _db.attachedDatabase,
        _db.battleUnitModifiers,
      );
  $$BattleUnitWoundsTableTableManager get battleUnitWounds =>
      $$BattleUnitWoundsTableTableManager(
        _db.attachedDatabase,
        _db.battleUnitWounds,
      );
  $$ArmiesTableTableManager get armies =>
      $$ArmiesTableTableManager(_db.attachedDatabase, _db.armies);
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db.attachedDatabase, _db.factions);
}
