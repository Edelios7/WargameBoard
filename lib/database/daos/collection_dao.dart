import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/collection_item_details.dart';
import '../tables/army_units_table.dart';
import '../tables/datasheets_table.dart';
import '../tables/factions_table.dart';
import '../tables/owned_miniatures_table.dart';
import '../tables/wishlist_items_table.dart';

part 'collection_dao.g.dart';

@DriftAccessor(
  tables: [
    OwnedMiniatures,
    Datasheets,
    Factions,
    WishlistItems,
    ArmyUnits,
  ],
)
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<String> addEntry({
    required String datasheetId,
    required int quantity,
    double? purchasePrice,
  }) async {
    final id = _uuid.v4();
    await into(ownedMiniatures).insert(
      OwnedMiniaturesCompanion.insert(
        id: id,
        datasheetId: datasheetId,
        quantity: quantity,
        purchasePrice: Value(purchasePrice),
        purchaseDate:
            purchasePrice == null ? const Value.absent() : Value(DateTime.now()),
      ),
    );
    return id;
  }

  Future<void> deleteEntry(String id) {
    return (delete(ownedMiniatures)..where((t) => t.id.equals(id))).go();
  }

  /// Met à jour les compteurs d'une entrée, bornés entre 0 et la quantité
  /// possédée. Retourne l'entrée avant/après, pour permettre au repository
  /// de calculer les deltas assembled/painted (gains d'XP notamment) sans
  /// requête supplémentaire.
  Future<({OwnedMiniature before, OwnedMiniature after})> updateCounts(
    String id, {
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
  }) async {
    final entry =
        await (select(ownedMiniatures)..where((t) => t.id.equals(id)))
            .getSingle();

    final newQuantity = quantity ?? entry.quantity;
    int clamp(int? value, int fallback) =>
        (value ?? fallback).clamp(0, newQuantity);

    await (update(ownedMiniatures)..where((t) => t.id.equals(id))).write(
      OwnedMiniaturesCompanion(
        quantity: Value(newQuantity),
        assembled: Value(clamp(assembled, entry.assembled)),
        primed: Value(clamp(primed, entry.primed)),
        painted: Value(clamp(painted, entry.painted)),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final updated =
        await (select(ownedMiniatures)..where((t) => t.id.equals(id)))
            .getSingle();
    return (before: entry, after: updated);
  }

  Future<List<CollectionItemDetails>> listEntries() async {
    final query = select(ownedMiniatures).join([
      innerJoin(
        datasheets,
        datasheets.id.equalsExp(ownedMiniatures.datasheetId),
      ),
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
    ])
      ..orderBy([OrderingTerm.asc(datasheets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      final entry = row.readTable(ownedMiniatures);
      final datasheet = row.readTable(datasheets);
      final faction = row.readTable(factions);
      return CollectionItemDetails(
        id: entry.id,
        datasheetId: datasheet.id,
        datasheetName: datasheet.name,
        factionName: faction.name,
        quantity: entry.quantity,
        assembled: entry.assembled,
        primed: entry.primed,
        painted: entry.painted,
        purchasePrice: entry.purchasePrice,
        purchaseDate: entry.purchaseDate,
        createdAt: entry.createdAt,
      );
    }).toList();
  }

  /// Dernières entrées ajoutées à la collection, du plus récent au plus
  /// ancien.
  Future<List<CollectionItemDetails>> listRecentlyAdded({
    int limit = 5,
  }) async {
    final entries = await listEntries();
    final sorted = [...entries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  /// Achats récents (entrées avec un prix renseigné), du plus récent au
  /// plus ancien.
  Future<List<CollectionItemDetails>> listRecentPurchases({
    int limit = 5,
  }) async {
    final entries = await listEntries();
    final withPrice = entries.where((e) => e.purchaseDate != null).toList()
      ..sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));
    return withPrice.take(limit).toList();
  }

  /// Compare la quantité possédée par datasheet au total requis à travers
  /// toutes les armées, pour repérer les manques ("il vous manque N X").
  Future<List<CollectionGap>> getCollectionGaps({int limit = 5}) async {
    final owned = <String, int>{};
    for (final entry in await listEntries()) {
      owned[entry.datasheetId] = (owned[entry.datasheetId] ?? 0) + entry.quantity;
    }

    final query = select(armyUnits).join([
      innerJoin(datasheets, datasheets.id.equalsExp(armyUnits.datasheetId)),
    ]);
    final rows = await query.get();
    final needed = <String, int>{};
    final names = <String, String>{};
    for (final row in rows) {
      final unit = row.readTable(armyUnits);
      final datasheet = row.readTable(datasheets);
      needed[datasheet.id] = (needed[datasheet.id] ?? 0) + unit.modelCount;
      names[datasheet.id] = datasheet.name;
    }

    final gaps = <CollectionGap>[];
    for (final entry in needed.entries) {
      final ownedCount = owned[entry.key] ?? 0;
      if (entry.value > ownedCount) {
        gaps.add(CollectionGap(
          datasheetId: entry.key,
          datasheetName: names[entry.key]!,
          owned: ownedCount,
          neededAcrossArmies: entry.value,
        ));
      }
    }
    gaps.sort((a, b) => b.missing.compareTo(a.missing));
    return gaps.take(limit).toList();
  }

  Future<void> setPurchasePrice(String id, double? purchasePrice) {
    return (update(ownedMiniatures)..where((t) => t.id.equals(id))).write(
      OwnedMiniaturesCompanion(
        purchasePrice: Value(purchasePrice),
        purchaseDate:
            purchasePrice == null ? const Value(null) : Value(DateTime.now()),
      ),
    );
  }

  Future<CollectionSummary> getSummary() async {
    final entries = await listEntries();
    var totalModels = 0;
    var totalPainted = 0;
    var totalValue = 0.0;
    for (final entry in entries) {
      totalModels += entry.quantity;
      totalPainted += entry.painted;
      totalValue += entry.purchasePrice ?? 0;
    }
    return CollectionSummary(
      totalEntries: entries.length,
      totalModels: totalModels,
      totalPainted: totalPainted,
      totalValue: totalValue,
    );
  }

  Future<String> addWishlistItem({
    required String datasheetId,
    int quantity = 1,
    String? notes,
  }) async {
    final id = _uuid.v4();
    await into(wishlistItems).insert(
      WishlistItemsCompanion.insert(
        id: id,
        datasheetId: datasheetId,
        quantity: Value(quantity),
        notes: Value(notes),
      ),
    );
    return id;
  }

  Future<void> deleteWishlistItem(String id) {
    return (delete(wishlistItems)..where((t) => t.id.equals(id))).go();
  }

  Future<List<WishlistItemDetails>> listWishlistItems() async {
    final query = select(wishlistItems).join([
      innerJoin(
        datasheets,
        datasheets.id.equalsExp(wishlistItems.datasheetId),
      ),
      innerJoin(factions, factions.id.equalsExp(datasheets.factionId)),
    ])
      ..orderBy([OrderingTerm.asc(datasheets.name)]);

    final rows = await query.get();
    return rows.map((row) {
      final item = row.readTable(wishlistItems);
      final datasheet = row.readTable(datasheets);
      final faction = row.readTable(factions);
      return WishlistItemDetails(
        id: item.id,
        datasheetId: datasheet.id,
        datasheetName: datasheet.name,
        factionName: faction.name,
        quantity: item.quantity,
        notes: item.notes,
      );
    }).toList();
  }

  /// Déplace un élément de la wishlist vers la collection possédée
  /// (l'ajoute comme entrée de collection puis le retire de la wishlist).
  Future<void> moveWishlistItemToCollection(String wishlistItemId) async {
    final item = await (select(wishlistItems)
          ..where((t) => t.id.equals(wishlistItemId)))
        .getSingle();

    await addEntry(datasheetId: item.datasheetId, quantity: item.quantity);
    await deleteWishlistItem(wishlistItemId);
  }
}
