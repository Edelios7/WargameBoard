// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_dao.dart';

// ignore_for_file: type=lint
mixin _$XpDaoMixin on DatabaseAccessor<AppDatabase> {
  $XpCategoryTotalsTable get xpCategoryTotals =>
      attachedDatabase.xpCategoryTotals;
  $XpFactionTotalsTable get xpFactionTotals => attachedDatabase.xpFactionTotals;
  $FactionsTable get factions => attachedDatabase.factions;
  XpDaoManager get managers => XpDaoManager(this);
}

class XpDaoManager {
  final _$XpDaoMixin _db;
  XpDaoManager(this._db);
  $$XpCategoryTotalsTableTableManager get xpCategoryTotals =>
      $$XpCategoryTotalsTableTableManager(
        _db.attachedDatabase,
        _db.xpCategoryTotals,
      );
  $$XpFactionTotalsTableTableManager get xpFactionTotals =>
      $$XpFactionTotalsTableTableManager(
        _db.attachedDatabase,
        _db.xpFactionTotals,
      );
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db.attachedDatabase, _db.factions);
}
