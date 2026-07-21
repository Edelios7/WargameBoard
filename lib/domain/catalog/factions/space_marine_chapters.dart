/// Noms de chapitres de Space Marines : chaque chapitre est sa propre
/// faction en base (voir `Factions`), il n'y a pas de hiérarchie
/// explicite modélisée entre "Space Marines" générique et ses chapitres.
const spaceMarineChapterFactionNames = <String>{
  'Blood Angels',
  'Dark Angels',
  'Space Wolves',
  'Imperial Fists',
  'Black Templars',
  'Deathwatch',
  'Salamanders',
  'Raven Guard',
  'Ultramarines',
};

/// Vrai si [name] désigne la faction générique "Space Marines". Les
/// données réelles importées la nomment "Space Marines (Adeptus
/// Astartes)", d'où un test par sous-chaîne plutôt qu'une égalité
/// stricte sur "Space Marines".
bool isGenericSpaceMarinesFactionName(String name) =>
    name.toLowerCase().contains('space marines');

/// Vrai si [name] est un chapitre de Space Marines OU la faction
/// générique "Space Marines" elle-même.
bool isSpaceMarineFactionName(String name) =>
    spaceMarineChapterFactionNames.contains(name) ||
    isGenericSpaceMarinesFactionName(name);
