/// Un palier de coût pour une datasheet : le coût en points qui
/// s'applique à un nombre de figurines donné.
///
/// `modelCount` est nul pour les coûts "à taille fixe" (héritage de
/// données important avant l'introduction des paliers, ou unité dont le
/// coût ne dépend pas de l'effectif) : ce coût s'applique alors quel que
/// soit le nombre de figurines demandé.
class CostBracket {
  final int? modelCount;
  final int points;

  const CostBracket({required this.modelCount, required this.points});
}

/// Résout le coût en points applicable pour un nombre de figurines donné,
/// à partir des paliers de coût connus d'une datasheet.
///
/// Warhammer 40k tarife souvent une unité différemment selon la taille
/// choisie (ex. 90 pts à 5 figurines, 160 pts à 10) — ce n'est PAS un
/// simple multiple du coût de base, donc on ne peut pas se contenter de
/// `coûtDeBase * nombreDeFigurines`.
///
/// Règle de résolution :
/// 1. un palier dont le `modelCount` correspond exactement -> ce coût ;
/// 2. sinon, parmi les paliers chiffrés, celui dont la taille est la
///    plus proche en dessous du nombre demandé ;
/// 3. si le nombre demandé est inférieur à tous les paliers connus, le
///    plus petit palier disponible (on ne descend jamais sous le prix
///    plancher officiel) ;
/// 4. à défaut de tout palier chiffré, un coût "à taille fixe" ;
/// 5. sinon 0 (aucune donnée de coût pour cette datasheet).
int resolveCostForModelCount(List<CostBracket> brackets, int modelCount) {
  if (brackets.isEmpty) return 0;

  final sized = brackets.where((b) => b.modelCount != null).toList()
    ..sort((a, b) => a.modelCount!.compareTo(b.modelCount!));

  if (sized.isEmpty) {
    return brackets.first.points;
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
