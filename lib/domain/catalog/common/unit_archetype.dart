import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Cinq profils de jeu type utilisés pour classer les unités du catalogue
/// et illustrer la logique de contre du guide "chaîne alimentaire" — une
/// simplification pédagogique du jeu, pas une catégorisation officielle.
enum UnitArchetype { horde, elite, armored, antiTank, support }

/// Lit la valeur stockée sur `datasheets.archetype` (nom de l'enum, ex.
/// `"horde"`) — `null` pour une fiche pas encore classée ou une valeur
/// inconnue (ne doit jamais faire planter l'affichage).
UnitArchetype? parseArchetype(String? raw) {
  if (raw == null) return null;
  for (final value in UnitArchetype.values) {
    if (value.name == raw) return value;
  }
  return null;
}

String archetypeName(AppLocalizations l10n, UnitArchetype archetype) {
  switch (archetype) {
    case UnitArchetype.horde:
      return l10n.unitArchetypeHorde;
    case UnitArchetype.elite:
      return l10n.unitArchetypeElite;
    case UnitArchetype.armored:
      return l10n.unitArchetypeArmored;
    case UnitArchetype.antiTank:
      return l10n.unitArchetypeAntiTank;
    case UnitArchetype.support:
      return l10n.unitArchetypeSupport;
  }
}

class ArchetypeInfo {
  final IconData icon;
  final String blurb;

  const ArchetypeInfo({required this.icon, required this.blurb});
}

const Map<UnitArchetype, ArchetypeInfo> kArchetypeInfo = {
  UnitArchetype.horde: ArchetypeInfo(
    icon: Icons.groups_rounded,
    blurb:
        'Beaucoup de figurines, faible Endurance et Sauvegarde. Sature les '
        'objectifs et les tirs adverses.',
  ),
  UnitArchetype.elite: ArchetypeInfo(
    icon: Icons.shield_rounded,
    blurb:
        'Peu de figurines, mais Endurance et Sauvegarde solides. Frappe '
        'fort au contact.',
  ),
  UnitArchetype.armored: ArchetypeInfo(
    icon: Icons.fort_rounded,
    blurb:
        'Grosse Endurance, bonne Sauvegarde et beaucoup de Points de Vie à '
        'faire tomber.',
  ),
  UnitArchetype.antiTank: ArchetypeInfo(
    icon: Icons.gps_fixed_rounded,
    blurb:
        'Peu nombreux, Force et Pénétration d\'Armure très élevées — cher '
        'et fragile s\'il est submergé avant de tirer.',
  ),
  UnitArchetype.support: ArchetypeInfo(
    icon: Icons.auto_awesome_rounded,
    blurb:
        'Fragile, pas fait pour le contact — apporte des bonus ou tient un '
        'objectif en retrait.',
  ),
};

/// Résultat du guide interactif "chaîne alimentaire" : quel archétype a
/// l'avantage (ou aucun, pour un match jugé équilibré) et pourquoi.
class MatchupResult {
  final UnitArchetype? advantage;
  final String explanation;

  const MatchupResult({required this.advantage, required this.explanation});
}

MatchupResult matchupFor(UnitArchetype a, UnitArchetype b) {
  if (a == b) {
    return const MatchupResult(
      advantage: null,
      explanation:
          'Même profil des deux côtés : ici, c\'est le déploiement, les '
          'stratagèmes et l\'exécution qui font la différence, pas la '
          'fiche.',
    );
  }

  // Normalise l'ordre pour n'écrire chaque paire qu'une fois.
  final pair = a.index < b.index ? (a, b) : (b, a);

  switch (pair) {
    case (UnitArchetype.horde, UnitArchetype.elite):
      return const MatchupResult(
        advantage: null,
        explanation:
            'Équilibré : la Sauvegarde de l\'Élite encaisse bien les '
            'attaques faibles de la Horde en mêlée directe, mais la Horde '
            'compense en tenant plus d\'objectifs et en saturant plus '
            'd\'actions à la fois.',
      );
    case (UnitArchetype.horde, UnitArchetype.armored):
      return const MatchupResult(
        advantage: UnitArchetype.armored,
        explanation:
            'Le Blindé encaisse sans mal les armes légères de la Horde, '
            'sauf si celle-ci parvient à le submerger en mêlée en très '
            'grand nombre avant qu\'il n\'ait pu tirer.',
      );
    case (UnitArchetype.horde, UnitArchetype.antiTank):
      return const MatchupResult(
        advantage: UnitArchetype.horde,
        explanation:
            'Le spécialiste anti-char a peu d\'attaques et une Sauvegarde '
            'moyenne : submergé en nombre ou simplement ignoré, il n\'a '
            'pas de réponse efficace contre une Horde qui va chercher les '
            'objectifs ailleurs.',
      );
    case (UnitArchetype.horde, UnitArchetype.support):
      return const MatchupResult(
        advantage: UnitArchetype.horde,
        explanation:
            'Le Soutien est fragile et n\'est pas fait pour encaisser : '
            'une Horde qui l\'atteint le nettoie très vite.',
      );
    case (UnitArchetype.elite, UnitArchetype.armored):
      return const MatchupResult(
        advantage: null,
        explanation:
            'Ça dépend surtout des armes emportées par l\'Élite : sans '
            'arme à Pénétration d\'Armure élevée, elle peine à blesser le '
            'Blindé, qui de son côté perce sa Sauvegarde sans difficulté.',
      );
    case (UnitArchetype.elite, UnitArchetype.antiTank):
      return const MatchupResult(
        advantage: UnitArchetype.elite,
        explanation:
            'Le profil du spécialiste anti-char est taillé pour percer de '
            'l\'Endurance et de la Sauvegarde de Blindé, pas pour '
            'affronter de l\'infanterie coriace en face à face.',
      );
    case (UnitArchetype.elite, UnitArchetype.support):
      return const MatchupResult(
        advantage: UnitArchetype.elite,
        explanation:
            'L\'Élite écrase sans effort une unité de Soutien fragile dès '
            'qu\'elle l\'atteint.',
      );
    case (UnitArchetype.armored, UnitArchetype.antiTank):
      return const MatchupResult(
        advantage: UnitArchetype.antiTank,
        explanation:
            'C\'est exactement sa fonction : Force, Pénétration d\'Armure '
            'et Dégâts sont taillés pour faire tomber l\'Endurance et la '
            'Sauvegarde du Blindé.',
      );
    case (UnitArchetype.armored, UnitArchetype.support):
      return const MatchupResult(
        advantage: UnitArchetype.armored,
        explanation:
            'Le Blindé encaisse sans problème tout ce qu\'un Soutien '
            'fragile peut lui infliger, et le détruit sans effort en '
            'retour.',
      );
    case (UnitArchetype.antiTank, UnitArchetype.support):
      return const MatchupResult(
        advantage: UnitArchetype.antiTank,
        explanation:
            'Ce n\'est pas la cible idéale pour ses armes, mais le '
            'Spécialiste anti-char a bien assez de Force pour tuer un '
            'Soutien fragile qui n\'a, lui, aucune réponse.',
      );
    default:
      // Inatteignable : toutes les paires non ordonnées sont couvertes
      // ci-dessus pour les 5 valeurs de UnitArchetype.
      return const MatchupResult(advantage: null, explanation: '');
  }
}

/// Estime l'archétype d'une fiche à partir de ses mots-clés, de son
/// effectif et de ses armes — une heuristique indicative (pas une vérité
/// officielle) appliquée une fois par [tools/backfill_unit_archetypes_test
/// .dart] et stockée sur `datasheets.archetype`. Prend des primitives
/// plutôt qu'un `DatasheetDetails` pour éviter une dépendance circulaire
/// entre ce fichier (domain/catalog) et database/models.
UnitArchetype classifyArchetype({
  required List<String> keywords,
  required int maxModelSize,
  required int baseToughness,
  required bool hasDedicatedAntiTankWeapon,
}) {
  final normalizedKeywords = keywords
      .map((k) => stripAccents(k.toUpperCase()))
      .toSet();
  final isVehicleOrMonster =
      normalizedKeywords.contains('VEHICULE') ||
      normalizedKeywords.contains('MONSTRE');
  if (isVehicleOrMonster) {
    return UnitArchetype.armored;
  }

  if (hasDedicatedAntiTankWeapon && maxModelSize <= 3) {
    return UnitArchetype.antiTank;
  }

  if (maxModelSize >= 6 && baseToughness <= 5) {
    return UnitArchetype.horde;
  }

  final hasPsyker = normalizedKeywords.contains('PSYKER');
  if (hasPsyker && maxModelSize <= 3 && !hasDedicatedAntiTankWeapon) {
    return UnitArchetype.support;
  }

  return UnitArchetype.elite;
}

/// Retire les diacritiques latins usuels — utilisé pour normaliser des
/// noms d'unités avant comparaison (classification d'archétype, matching
/// texte→fiche dans `tools/backfill_army_synergies_test.dart`).
String stripAccents(String input) {
  const withDiacritics = 'ÀÂÄÁÃÅÈÉÊËÌÍÎÏÒÓÔÖÕÙÚÛÜÇÑ';
  const withoutDiacritics = 'AAAAAAEEEEIIIIOOOOOUUUUCN';
  var result = input;
  for (var i = 0; i < withDiacritics.length; i++) {
    result = result.replaceAll(withDiacritics[i], withoutDiacritics[i]);
  }
  return result;
}
