// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'army_dao.dart';

// ignore_for_file: type=lint
mixin _$ArmyDaoMixin on DatabaseAccessor<AppDatabase> {
  $ArmiesTable get armies => attachedDatabase.armies;
  $ArmyUnitsTable get armyUnits => attachedDatabase.armyUnits;
  $ArmyUnitEquipmentSelectionsTable get armyUnitEquipmentSelections =>
      attachedDatabase.armyUnitEquipmentSelections;
  $FactionsTable get factions => attachedDatabase.factions;
  $DatasheetsTable get datasheets => attachedDatabase.datasheets;
  $DatasheetCostsTable get datasheetCosts => attachedDatabase.datasheetCosts;
  $EditionsTable get editions => attachedDatabase.editions;
  $UnitSizesTable get unitSizes => attachedDatabase.unitSizes;
  $DetachmentsTable get detachments => attachedDatabase.detachments;
  $EnhancementsTable get enhancements => attachedDatabase.enhancements;
  $StratagemsTable get stratagems => attachedDatabase.stratagems;
  $BattlesTable get battles => attachedDatabase.battles;
  $BattleUnitStatesTable get battleUnitStates =>
      attachedDatabase.battleUnitStates;
  $BattleUnitModifiersTable get battleUnitModifiers =>
      attachedDatabase.battleUnitModifiers;
  $BattleUnitWoundsTable get battleUnitWounds =>
      attachedDatabase.battleUnitWounds;
  ArmyDaoManager get managers => ArmyDaoManager(this);
}

class ArmyDaoManager {
  final _$ArmyDaoMixin _db;
  ArmyDaoManager(this._db);
  $$ArmiesTableTableManager get armies =>
      $$ArmiesTableTableManager(_db.attachedDatabase, _db.armies);
  $$ArmyUnitsTableTableManager get armyUnits =>
      $$ArmyUnitsTableTableManager(_db.attachedDatabase, _db.armyUnits);
  $$ArmyUnitEquipmentSelectionsTableTableManager
  get armyUnitEquipmentSelections =>
      $$ArmyUnitEquipmentSelectionsTableTableManager(
        _db.attachedDatabase,
        _db.armyUnitEquipmentSelections,
      );
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db.attachedDatabase, _db.factions);
  $$DatasheetsTableTableManager get datasheets =>
      $$DatasheetsTableTableManager(_db.attachedDatabase, _db.datasheets);
  $$DatasheetCostsTableTableManager get datasheetCosts =>
      $$DatasheetCostsTableTableManager(
        _db.attachedDatabase,
        _db.datasheetCosts,
      );
  $$EditionsTableTableManager get editions =>
      $$EditionsTableTableManager(_db.attachedDatabase, _db.editions);
  $$UnitSizesTableTableManager get unitSizes =>
      $$UnitSizesTableTableManager(_db.attachedDatabase, _db.unitSizes);
  $$DetachmentsTableTableManager get detachments =>
      $$DetachmentsTableTableManager(_db.attachedDatabase, _db.detachments);
  $$EnhancementsTableTableManager get enhancements =>
      $$EnhancementsTableTableManager(_db.attachedDatabase, _db.enhancements);
  $$StratagemsTableTableManager get stratagems =>
      $$StratagemsTableTableManager(_db.attachedDatabase, _db.stratagems);
  $$BattlesTableTableManager get battles =>
      $$BattlesTableTableManager(_db.attachedDatabase, _db.battles);
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
}
