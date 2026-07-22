enum RuleCategory { mainRules, missions, faqs, errata, pointsAndProfiles }

/// One update/erratum within a [RuleDocument] (a heading and its full
/// rule text), shown on the document's detail page.
class RuleSection {
  final String heading;
  final String body;

  const RuleSection({required this.heading, required this.body});
}

/// A rulebook / official document entry shown on the Règles page.
///
/// This is a static, in-memory catalog (no database table yet) — see
/// `rules_data.dart`. [localAssetId], when set, matches a file name under
/// `local_assets/rules/<id>.pdf` (git-ignored, private copy of the PDF).
/// [sections], when non-empty, is the real text shown on the document's
/// detail page — most entries here are still just a catalog card with no
/// digitized text yet.
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
  final String? intro;
  final List<RuleSection> sections;

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
    this.intro,
    this.sections = const [],
  });
}
