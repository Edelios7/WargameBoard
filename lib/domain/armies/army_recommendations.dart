import '../../database/models/army_details.dart';
import '../../database/models/datasheet_details.dart';
import '../catalog/common/unit_archetype.dart';

enum UnitSuggestionReason { synergy, roleGap }

/// Une unité complémentaire suggérée pendant la construction d'une
/// armée, avec la raison de la suggestion :
/// - [UnitSuggestionReason.synergy] : cette unité apparaît souvent aux
///   côtés de [synergyPartnerName] dans les styles de liste par faction
///   du guide "Exemples de listes d'armée" (voir `army_synergy_data.dart`).
/// - [UnitSuggestionReason.roleGap] : l'armée n'a encore aucune unité de
///   l'archétype [missingArchetype] (horde/élite/blindé/anti-char/soutien).
class UnitSuggestion {
  final String datasheetId;
  final String datasheetName;
  final UnitSuggestionReason reason;
  final String? synergyPartnerName;
  final UnitArchetype? missingArchetype;

  const UnitSuggestion({
    required this.datasheetId,
    required this.datasheetName,
    required this.reason,
    this.synergyPartnerName,
    this.missingArchetype,
  });
}

/// Suggère jusqu'à [max] unités complémentaires pour [army], parmi
/// [factionCatalog] (les fiches de la faction de l'armée — et, pour les
/// chapitres successeurs, du pool générique Space Marines, comme pour le
/// reste du catalogue).
///
/// Priorité à la co-occurrence issue de [synergy] (unités qui
/// apparaissent souvent avec celles déjà dans l'armée dans les listes de
/// style par faction) ; si ça ne suffit pas à remplir [max] suggestions
/// (armée neuve, faction peu couverte), complète par un repli sur les
/// "trous de rôle" : un archétype absent de l'armée → l'unité la moins
/// chère de cet archétype dans le catalogue.
///
/// Ne lance jamais d'exception : une entrée de synergie pointant vers un
/// id absent de [factionCatalog], ou une fiche sans coût connu, est
/// simplement ignorée.
///
/// [remainingPoints], quand l'armée a une limite de points définie, est
/// le budget qu'il reste (`pointsLimit - totalPoints`) : une unité dont
/// le coût le dépasse n'est jamais suggérée — ce ne serait pas une
/// suggestion utile de cliquer dessus pour dépasser aussitôt sa limite.
/// `null` désactive ce filtre (armée sans limite de points).
List<UnitSuggestion> suggestUnits({
  required ArmyDetails army,
  required Map<String, Map<String, int>> synergy,
  required List<DatasheetDetails> factionCatalog,
  int max = 3,
  int? remainingPoints,
}) {
  final alreadyInArmy = army.units.map((u) => u.datasheetId).toSet();
  final catalogById = {for (final d in factionCatalog) d.id: d};
  bool fitsBudget(int? points) =>
      remainingPoints == null || (points != null && points <= remainingPoints);

  final synergyWeight = <String, int>{};
  final bestPartnerName = <String, String>{};
  final bestPartnerWeight = <String, int>{};

  for (final unit in army.units) {
    final partners = synergy[unit.datasheetId];
    if (partners == null) continue;
    for (final entry in partners.entries) {
      final candidateId = entry.key;
      if (alreadyInArmy.contains(candidateId)) continue;
      if (!catalogById.containsKey(candidateId)) continue;

      synergyWeight[candidateId] = (synergyWeight[candidateId] ?? 0) + entry.value;
      if (entry.value > (bestPartnerWeight[candidateId] ?? 0)) {
        bestPartnerWeight[candidateId] = entry.value;
        bestPartnerName[candidateId] = unit.datasheetName;
      }
    }
  }

  final sortedSynergyIds = synergyWeight.keys.toList()
    ..sort((a, b) => synergyWeight[b]!.compareTo(synergyWeight[a]!));

  final suggestions = <UnitSuggestion>[];
  final suggestedIds = <String>{};

  for (final id in sortedSynergyIds) {
    if (suggestions.length >= max) break;
    final sheet = catalogById[id];
    if (sheet == null) continue;
    if (!fitsBudget(sheet.points)) continue;
    suggestions.add(
      UnitSuggestion(
        datasheetId: id,
        datasheetName: sheet.name,
        reason: UnitSuggestionReason.synergy,
        synergyPartnerName: bestPartnerName[id],
      ),
    );
    suggestedIds.add(id);
  }

  if (suggestions.length < max) {
    final presentArchetypes = <UnitArchetype>{};
    for (final unit in army.units) {
      final archetype = catalogById[unit.datasheetId]?.archetype;
      if (archetype != null) presentArchetypes.add(archetype);
    }
    final missingArchetypes = UnitArchetype.values.where(
      (a) => !presentArchetypes.contains(a),
    );

    for (final archetype in missingArchetypes) {
      if (suggestions.length >= max) break;
      final candidates =
          factionCatalog
              .where(
                (d) =>
                    d.archetype == archetype &&
                    d.points != null &&
                    fitsBudget(d.points) &&
                    !alreadyInArmy.contains(d.id) &&
                    !suggestedIds.contains(d.id),
              )
              .toList()
            ..sort((a, b) => a.points!.compareTo(b.points!));
      if (candidates.isEmpty) continue;
      final pick = candidates.first;
      suggestions.add(
        UnitSuggestion(
          datasheetId: pick.id,
          datasheetName: pick.name,
          reason: UnitSuggestionReason.roleGap,
          missingArchetype: archetype,
        ),
      );
      suggestedIds.add(pick.id);
    }
  }

  return suggestions;
}
