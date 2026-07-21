enum RuleCategory { mainRules, missions, faqs, errata, pointsAndProfiles }

/// A rulebook / official document entry shown on the Règles page.
///
/// This is a static, in-memory catalog (no database table yet) — see
/// `rules_data.dart`. [localAssetId], when set, matches a file name under
/// `local_assets/rules/<id>.pdf` (git-ignored, private copy of the PDF).
class RuleDocument {
  final String id;
  final String title;
  final RuleCategory category;
  final String version;
  final DateTime releaseDate;
  final DateTime lastUpdate;
  final String language;
  final bool isCurrent;
  final bool isUpToDate;
  final String publisher;
  final int downloads;
  final int errataCount;
  final String? localAssetId;

  const RuleDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.version,
    required this.releaseDate,
    required this.lastUpdate,
    required this.language,
    required this.isCurrent,
    required this.isUpToDate,
    required this.publisher,
    required this.downloads,
    required this.errataCount,
    this.localAssetId,
  });
}
