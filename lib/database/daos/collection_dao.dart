import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../models/collection_item_details.dart';
import '../tables/datasheets_table.dart';
import '../tables/factions_table.dart';
import '../tables/owned_miniatures_table.dart';

part 'collection_dao.g.dart';

@DriftAccessor(
  tables: [
    OwnedMiniatures,
    Datasheets,
    Factions,
  ],
)
class CollectionDao extends DatabaseAccessor<AppDatabase>
    with _$CollectionDaoMixin {
  CollectionDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<String> addEntry({
    required String datasheetId,
    required int quantity,
  }) async {
    final id = _uuid.v4();
    await into(ownedMiniatures).insert(
      OwnedMiniaturesCompanion.insert(
        id: id,
        datasheetId: datasheetId,
        quantity: quantity,
      ),
    );
    return id;
  }

  Future<void> deleteEntry(String id) {
    return (delete(ownedMiniatures)..where((t) => t.id.equals(id))).go();
  }

  /// Met à jour les compteurs d'une entrée, bornés entre 0 et la quantité
  /// possédée.
  Future<void> updateCounts(
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
      );
    }).toList();
  }

  Future<CollectionSummary> getSummary() async {
    final entries = await listEntries();
    var totalModels = 0;
    var totalPainted = 0;
    for (final entry in entries) {
      totalModels += entry.quantity;
      totalPainted += entry.painted;
    }
    return CollectionSummary(
      totalEntries: entries.length,
      totalModels: totalModels,
      totalPainted: totalPainted,
    );
  }
}
