import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/factions_table.dart';

part 'faction_dao.g.dart';

@DriftAccessor(tables: [Factions])
class FactionDao extends DatabaseAccessor<AppDatabase>
    with _$FactionDaoMixin {
  FactionDao(AppDatabase db) : super(db);

  Future<List<Faction>> getAll() {
    return select(factions).get();
  }

  Future<Faction?> getById(String id) {
    return (select(factions)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<Faction?> getByName(String name) {
    return (select(factions)
          ..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  Future<void> insertFaction(FactionsCompanion faction) async {
    await into(factions).insert(faction);
  }

  Future<bool> updateFaction(Faction faction) {
    return update(factions).replace(faction);
  }

  Future<int> deleteFaction(String id) {
    return (delete(factions)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> clear() async {
    await delete(factions).go();
  }

  Future<bool> exists(String id) async {
    final faction = await getById(id);
    return faction != null;
  }
}