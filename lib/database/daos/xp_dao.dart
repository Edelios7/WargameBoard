import 'package:drift/drift.dart';

import '../../domain/xp/xp_category.dart';
import '../app_database.dart';
import '../tables/factions_table.dart';
import '../tables/xp_category_totals_table.dart';
import '../tables/xp_faction_totals_table.dart';

part 'xp_dao.g.dart';

@DriftAccessor(tables: [XpCategoryTotals, XpFactionTotals, Factions])
class XpDao extends DatabaseAccessor<AppDatabase> with _$XpDaoMixin {
  XpDao(AppDatabase db) : super(db);

  /// Crée les 5 lignes de catégories à 0 XP si elles n'existent pas encore
  /// (idempotent — appelé au onCreate et lors de la migration v10).
  Future<void> seedCategories() async {
    for (final category in XpCategory.values) {
      await into(xpCategoryTotals).insertOnConflictUpdate(
        XpCategoryTotalsCompanion.insert(
          category: category.name,
          xp: const Value(0),
        ),
      );
    }
  }

  Future<void> incrementCategory(XpCategory category, int delta) async {
    if (delta == 0) return;
    final row = await (select(xpCategoryTotals)
          ..where((t) => t.category.equals(category.name)))
        .getSingleOrNull();
    final current = row?.xp ?? 0;
    await into(xpCategoryTotals).insertOnConflictUpdate(
      XpCategoryTotalsCompanion.insert(
        category: category.name,
        xp: Value(current + delta),
      ),
    );
  }

  Future<void> incrementFaction(String factionId, int delta) async {
    if (delta == 0) return;
    final row = await (select(xpFactionTotals)
          ..where((t) => t.factionId.equals(factionId)))
        .getSingleOrNull();
    final current = row?.xp ?? 0;
    await into(xpFactionTotals).insertOnConflictUpdate(
      XpFactionTotalsCompanion.insert(
        factionId: factionId,
        xp: Value(current + delta),
      ),
    );
  }

  Future<bool> hasFactionXp(String factionId) async {
    final row = await (select(xpFactionTotals)
          ..where((t) => t.factionId.equals(factionId)))
        .getSingleOrNull();
    return row != null && row.xp > 0;
  }

  Future<Map<XpCategory, int>> getCategoryTotals() async {
    final rows = await select(xpCategoryTotals).get();
    final byName = {for (final row in rows) row.category: row.xp};
    return {
      for (final category in XpCategory.values)
        category: byName[category.name] ?? 0,
    };
  }

  Future<List<({String factionId, String factionName, int xp})>>
      getFactionTotals() async {
    final query = select(xpFactionTotals).join([
      innerJoin(factions, factions.id.equalsExp(xpFactionTotals.factionId)),
    ])
      ..orderBy([OrderingTerm.desc(xpFactionTotals.xp)]);

    final rows = await query.get();
    return rows
        .where((row) => row.readTable(xpFactionTotals).xp > 0)
        .map((row) => (
              factionId: row.readTable(xpFactionTotals).factionId,
              factionName: row.readTable(factions).name,
              xp: row.readTable(xpFactionTotals).xp,
            ))
        .toList();
  }
}
