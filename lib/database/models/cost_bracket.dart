/// Un palier de coût pour une datasheet : le coût en points qui
/// s'applique à un nombre de figurines donné, à partir d'une certaine
/// copie de cette datasheet dans la liste (voir [minCopyIndex]).
///
/// `modelCount` est nul pour les coûts "à taille fixe" (héritage de
/// données important avant l'introduction des paliers, ou unité dont le
/// coût ne dépend pas de l'effectif) : ce coût s'applique alors quel que
/// soit le nombre de figurines demandé.
class CostBracket {
  final int? modelCount;
  final int points;

  /// À partir de quelle copie de cette datasheet (1 = la 1re) ce palier
  /// s'applique. `null` équivaut à 1 (s'applique dès la 1re copie) —
  /// c'est le cas de l'immense majorité des unités, qui ne coûtent pas
  /// plus cher selon le nombre d'exemplaires pris dans la liste.
  final int? minCopyIndex;

  const CostBracket({
    required this.modelCount,
    required this.points,
    this.minCopyIndex,
  });
}

/// Résout le coût en points applicable pour un nombre de figurines et une
/// "copie" donnés (1re, 2e, 3e escouade identique dans la même liste...),
/// à partir des paliers de coût connus d'une datasheet.
///
/// Warhammer 40k tarife souvent une unité différemment selon la taille
/// choisie (ex. 90 pts à 5 figurines, 160 pts à 10) — ce n'est PAS un
/// simple multiple du coût de base, donc on ne peut pas se contenter de
/// `coûtDeBase * nombreDeFigurines`. Il tarife aussi parfois différemment
/// selon le nombre d'exemplaires de cette même unité déjà pris dans la
/// liste (ex. "de la 1re à la 2e : 150 pts", "3e et suivantes : 165 pts") —
/// voir [CostBracket.minCopyIndex].
///
/// Règle de résolution :
/// 0. parmi les paliers partageant un même `modelCount`, ne garder que
///    celui dont le `minCopyIndex` (traité comme 1 si nul) est le plus
///    élevé tout en restant <= `copyIndex` — c'est le palier de prix
///    applicable à cette copie précise ;
/// 1. un palier dont le `modelCount` correspond exactement -> ce coût ;
/// 2. sinon, parmi les paliers chiffrés, celui dont la taille est la
///    plus proche en dessous du nombre demandé ;
/// 3. si le nombre demandé est inférieur à tous les paliers connus, le
///    plus petit palier disponible (on ne descend jamais sous le prix
///    plancher officiel) ;
/// 4. à défaut de tout palier chiffré, un coût "à taille fixe" ;
/// 5. sinon `null` — aucune donnée de coût pour cette datasheet. Ne
///    JAMAIS retourner 0 dans ce cas : une datasheet sans donnée de
///    coût n'est pas gratuite, l'appelant doit distinguer "coût
///    inconnu" de "coûte réellement 0 pt" (les deux existent dans le
///    catalogue) au lieu de fausser silencieusement le total d'une
///    liste et la validation de limite de points.
int? resolveCostForModelCount(
  List<CostBracket> brackets,
  int modelCount, {
  int copyIndex = 1,
}) {
  if (brackets.isEmpty) return null;

  // Pour chaque taille de figurines, ne garder que le palier de prix
  // applicable à `copyIndex` (le seuil de déclenchement le plus élevé
  // qui reste atteint).
  final byModelCount = <int?, CostBracket>{};
  for (final bracket in brackets) {
    final threshold = bracket.minCopyIndex ?? 1;
    if (threshold > copyIndex) continue;
    final current = byModelCount[bracket.modelCount];
    final currentThreshold = current?.minCopyIndex ?? 1;
    if (current == null || threshold >= currentThreshold) {
      byModelCount[bracket.modelCount] = bracket;
    }
  }

  // Si `copyIndex` est en dessous de tous les seuils connus pour une
  // taille donnée (ne devrait pas arriver, `minCopyIndex` vaut 1 par
  // défaut), on retombe sur le palier le moins cher de cette taille
  // plutôt que de perdre la donnée.
  if (byModelCount.isEmpty) {
    final cheapestByModelCount = <int?, CostBracket>{};
    for (final bracket in brackets) {
      final current = cheapestByModelCount[bracket.modelCount];
      if (current == null || bracket.points < current.points) {
        cheapestByModelCount[bracket.modelCount] = bracket;
      }
    }
    byModelCount.addAll(cheapestByModelCount);
  }

  final effective = byModelCount.values.toList();

  final sized = effective.where((b) => b.modelCount != null).toList()
    ..sort((a, b) => a.modelCount!.compareTo(b.modelCount!));

  if (sized.isEmpty) {
    return effective.first.points;
  }

  for (final bracket in sized) {
    if (bracket.modelCount == modelCount) return bracket.points;
  }

  CostBracket? bestBelow;
  for (final bracket in sized) {
    if (bracket.modelCount! <= modelCount) {
      bestBelow = bracket;
    }
  }
  return (bestBelow ?? sized.first).points;
}
