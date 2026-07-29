import 'rule_document.dart';

/// Un style de liste pour une faction donnée, extrait d'un [RuleSection]
/// dont le heading suit la convention `"{Faction} — {Style}"` et le body
/// `"{description}\n\n{unités séparées par \n} — Total : {N} pts"` (voir
/// le générateur qui a produit `rules_data.dart`).
///
/// Partagé entre le guide interactif ([ArmyListsGuidePage] dans
/// `army_lists_guide_page.dart`) et le script de backfill des synergies
/// d'unités (`tools/backfill_army_synergies_test.dart`) — une seule
/// implémentation du format texte, pas deux qui pourraient diverger.
class ArmyListStyle {
  final String name;
  final String description;
  final List<ArmyListUnit> units;
  final int totalPoints;

  const ArmyListStyle({
    required this.name,
    required this.description,
    required this.units,
    required this.totalPoints,
  });
}

class ArmyListUnit {
  final int quantity;
  final String name;

  /// Total en points pour cette ligne (déjà multiplié par [quantity] dans
  /// le texte source, ex. "3 × Boyz — 240 pts") — pas le coût à l'unité.
  final int lineTotalPoints;

  const ArmyListUnit({
    required this.quantity,
    required this.name,
    required this.lineTotalPoints,
  });
}

const _totalSeparator = ' — Total : ';

/// Regroupe les [RuleSection] du document par faction (heading
/// `"Faction — Style"`) en conservant l'ordre d'origine, et convertit
/// chaque section en [ArmyListStyle] structuré.
Map<String, List<ArmyListStyle>> groupStyleSectionsByFaction(
  List<RuleSection> sections,
) {
  final byFaction = <String, List<ArmyListStyle>>{};
  for (final section in sections) {
    final sepIndex = section.heading.indexOf(' — ');
    if (sepIndex == -1) continue;
    final faction = section.heading.substring(0, sepIndex);
    final styleName = section.heading.substring(sepIndex + 3);
    final style = parseStyleBody(styleName, section.body);
    if (style == null) continue;
    byFaction.putIfAbsent(faction, () => []).add(style);
  }
  return byFaction;
}

/// Parse le `body` d'une [RuleSection] du document `guide-listes-d-armee`.
/// Retourne `null` si le format ne correspond pas à ce qui est attendu
/// (ne doit jamais lancer d'exception — le contenu vient d'un catalogue
/// statique édité à la main).
ArmyListStyle? parseStyleBody(String styleName, String body) {
  final descSplit = body.indexOf('\n\n');
  if (descSplit == -1) return null;
  final description = body.substring(0, descSplit);
  final rest = body.substring(descSplit + 2);

  final totalIndex = rest.lastIndexOf(_totalSeparator);
  if (totalIndex == -1) return null;
  final unitBlock = rest.substring(0, totalIndex);
  final totalText = rest.substring(totalIndex + _totalSeparator.length);
  final totalPoints = int.tryParse(totalText.replaceAll(RegExp(r'[^0-9]'), ''));
  if (totalPoints == null) return null;

  final units = <ArmyListUnit>[];
  for (final line in unitBlock.split('\n')) {
    final dashIndex = line.lastIndexOf(' — ');
    if (dashIndex == -1) continue;
    var namePart = line.substring(0, dashIndex);
    final pointsPart = line.substring(dashIndex + 3);
    final lineTotalPoints = int.tryParse(
      pointsPart.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (lineTotalPoints == null) continue;

    var quantity = 1;
    final qtyMatch = RegExp(r'^(\d+)\s*×\s*').firstMatch(namePart);
    if (qtyMatch != null) {
      quantity = int.parse(qtyMatch.group(1)!);
      namePart = namePart.substring(qtyMatch.end);
    }
    units.add(
      ArmyListUnit(
        quantity: quantity,
        name: namePart,
        lineTotalPoints: lineTotalPoints,
      ),
    );
  }

  return ArmyListStyle(
    name: styleName,
    description: description,
    units: units,
    totalPoints: totalPoints,
  );
}
