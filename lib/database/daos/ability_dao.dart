import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/abilities_table.dart';

part 'ability_dao.g.dart';

@DriftAccessor(tables: [Abilities])
class AbilityDao extends DatabaseAccessor<AppDatabase>
    with _$AbilityDaoMixin {
  AbilityDao(AppDatabase db) : super(db);

  Future<List<Ability>> getAll() {
    return select(abilities).get();
  }

  Future<Ability?> getById(String id) {
    return (select(abilities)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Ability>> search(String text) {
    return (select(abilities)
          ..where((tbl) => tbl.name.contains(text)))
        .get();
  }

  Future<void> insertAbility(AbilitiesCompanion ability) async {
    await into(abilities).insert(ability);
  }

  Future<bool> updateAbility(Ability ability) {
    return update(abilities).replace(ability);
  }

  Future<int> deleteAbility(String id) {
    return (delete(abilities)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> clear() async {
    await delete(abilities).go();
  }
}