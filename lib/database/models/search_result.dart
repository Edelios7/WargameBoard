import '../../domain/catalog/common/unit_archetype.dart';

class SearchResult {
  final String id;

  final String name;

  final String type;

  final String? subtitle;

  final String? factionId;

  final String? factionName;

  final String? gameSystemId;

  final String? editionId;

  final String? unitType;

  final int? points;

  /// Archétype de jeu estimé (voir [classifyArchetype]) — `null` si pas
  /// encore calculé pour cette fiche, ou pour un résultat non-datasheet.
  final UnitArchetype? archetype;

  const SearchResult({
    required this.id,
    required this.name,
    required this.type,
    this.subtitle,
    this.factionId,
    this.factionName,
    this.gameSystemId,
    this.editionId,
    this.unitType,
    this.points,
    this.archetype,
  });
}