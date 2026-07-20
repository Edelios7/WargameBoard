import '../database/app_database.dart';
import '../database/models/xp_summary.dart';
import '../domain/xp/xp_level_curve.dart';

class XpRepository {
  final AppDatabase database;

  XpRepository(this.database);

  Future<XpSummary> getSummary() async {
    final categoryTotals = await database.xpDao.getCategoryTotals();
    final factionTotals = await database.xpDao.getFactionTotals();

    final totalXp = categoryTotals.values.fold<int>(0, (a, b) => a + b);

    final categories = categoryTotals.entries
        .map((entry) => XpCategoryProgress(
              category: entry.key,
              xp: entry.value,
              level: levelForXp(entry.value),
            ))
        .toList();

    final factions = factionTotals
        .map((row) => XpFactionProgress(
              factionId: row.factionId,
              factionName: row.factionName,
              xp: row.xp,
              level: levelForXp(row.xp),
            ))
        .toList();

    return XpSummary(
      totalXp: totalXp,
      commandantLevel: levelForXp(totalXp),
      categories: categories,
      factions: factions,
    );
  }
}
