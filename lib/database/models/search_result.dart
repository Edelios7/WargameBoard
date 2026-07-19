class SearchResult {
  final String id;

  final String name;

  final String type;

  final String? subtitle;

  final String? factionId;

  final String? factionName;

  final String? gameSystemId;

  final String? editionId;

  const SearchResult({
    required this.id,
    required this.name,
    required this.type,
    this.subtitle,
    this.factionId,
    this.factionName,
    this.gameSystemId,
    this.editionId,
  });
}