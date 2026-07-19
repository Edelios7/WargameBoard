import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/game_systems_table.dart';

part 'game_system_dao.g.dart';

@DriftAccessor(tables: [GameSystems])
class GameSystemDao extends DatabaseAccessor<AppDatabase>
    with _$GameSystemDaoMixin {
  GameSystemDao(AppDatabase db) : super(db);

  /// Retourne tous les systèmes de jeu
  Future<List<GameSystem>> getAll() {
    return select(gameSystems).get();
  }

  /// Retourne un système par son ID
  Future<GameSystem?> getById(String id) {
    return (select(gameSystems)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Retourne un système par son nom
  Future<GameSystem?> getByName(String name) {
    return (select(gameSystems)
          ..where((tbl) => tbl.name.equals(name)))
        .getSingleOrNull();
  }

  /// Insère un système
  Future<void> insertSystem(GameSystemsCompanion system) async {
    await into(gameSystems).insert(system);
  }

  /// Met à jour un système
  Future<bool> updateSystem(GameSystem system) {
    return update(gameSystems).replace(system);
  }

  /// Supprime un système
  Future<int> deleteById(String id) {
    return (delete(gameSystems)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  /// Vérifie l'existence d'un système
  Future<bool> exists(String id) async {
    final result = await (select(gameSystems)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    return result != null;
  }

  /// Nombre de systèmes enregistrés
  Future<int> count() async {
    final query = selectOnly(gameSystems)
      ..addColumns([gameSystems.id.count()]);

    final row = await query.getSingle();

    return row.read(gameSystems.id.count()) ?? 0;
  }

  /// Supprime tous les systèmes
  Future<void> clear() async {
    await delete(gameSystems).go();
  }
}