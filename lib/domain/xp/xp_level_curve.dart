/// Courbe de progression des niveaux, partagée par le niveau Commandant,
/// les 5 catégories et les niveaux de faction.
///
/// Volontairement isolée ici : c'est le seul endroit à ajuster si la courbe
/// doit être rééquilibrée après usage réel (l'objectif est une progression
/// exponentielle — rapide au début, longue en fin de courbe).
library;

/// XP total requis pour atteindre [level] (niveau 1 = 0 XP).
int xpForLevel(int level) {
  if (level <= 1) return 0;
  return 20 * level * level;
}

/// Progression d'un total d'XP donné dans la courbe de niveaux.
class LevelProgress {
  final int level;
  final int totalXp;
  final int xpAtLevelStart;
  final int xpAtNextLevel;

  const LevelProgress({
    required this.level,
    required this.totalXp,
    required this.xpAtLevelStart,
    required this.xpAtNextLevel,
  });

  int get xpIntoLevel => totalXp - xpAtLevelStart;

  int get xpForNextLevel => xpAtNextLevel - xpAtLevelStart;

  double get progress =>
      xpForNextLevel == 0 ? 1 : (xpIntoLevel / xpForNextLevel).clamp(0, 1);
}

/// Calcule le niveau atteint par un total d'XP donné.
LevelProgress levelForXp(int totalXp) {
  var level = 1;
  while (xpForLevel(level + 1) <= totalXp) {
    level++;
  }
  return LevelProgress(
    level: level,
    totalXp: totalXp,
    xpAtLevelStart: xpForLevel(level),
    xpAtNextLevel: xpForLevel(level + 1),
  );
}
