import '../../domain/xp/xp_category.dart';
import '../../domain/xp/xp_level_curve.dart';

class XpCategoryProgress {
  final XpCategory category;
  final int xp;
  final LevelProgress level;

  const XpCategoryProgress({
    required this.category,
    required this.xp,
    required this.level,
  });
}

class XpFactionProgress {
  final String factionId;
  final String factionName;
  final int xp;
  final LevelProgress level;

  const XpFactionProgress({
    required this.factionId,
    required this.factionName,
    required this.xp,
    required this.level,
  });
}

class XpSummary {
  final int totalXp;
  final LevelProgress commandantLevel;
  final List<XpCategoryProgress> categories;
  final List<XpFactionProgress> factions;

  const XpSummary({
    required this.totalXp,
    required this.commandantLevel,
    required this.categories,
    required this.factions,
  });
}
