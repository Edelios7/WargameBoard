// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_dao.dart';

// ignore_for_file: type=lint
mixin _$CollectionDaoMixin on DatabaseAccessor<AppDatabase> {
  $OwnedMiniaturesTable get ownedMiniatures => attachedDatabase.ownedMiniatures;
  $DatasheetsTable get datasheets => attachedDatabase.datasheets;
  $FactionsTable get factions => attachedDatabase.factions;
  $WishlistItemsTable get wishlistItems => attachedDatabase.wishlistItems;
  CollectionDaoManager get managers => CollectionDaoManager(this);
}

class CollectionDaoManager {
  final _$CollectionDaoMixin _db;
  CollectionDaoManager(this._db);
  $$OwnedMiniaturesTableTableManager get ownedMiniatures =>
      $$OwnedMiniaturesTableTableManager(
        _db.attachedDatabase,
        _db.ownedMiniatures,
      );
  $$DatasheetsTableTableManager get datasheets =>
      $$DatasheetsTableTableManager(_db.attachedDatabase, _db.datasheets);
  $$FactionsTableTableManager get factions =>
      $$FactionsTableTableManager(_db.attachedDatabase, _db.factions);
  $$WishlistItemsTableTableManager get wishlistItems =>
      $$WishlistItemsTableTableManager(_db.attachedDatabase, _db.wishlistItems);
}
