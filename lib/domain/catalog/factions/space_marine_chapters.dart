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
/// stricte sur "Space Marines" — mais "Chaos Space Marines" contient
/// aussi cette sous-chaîne (Renégats, pas des loyalistes) : on l'exclut
/// explicitement, sinon un filtre sur "Blood Angels" ou toute autre
/// chapitre remonte aussi des unités Chaos Space Marines.
bool isGenericSpaceMarinesFactionName(String name) {
  final normalized = name.toLowerCase();
  return normalized.contains('space marines') && !normalized.contains('chaos');
}

/// Vrai si [name] est un chapitre de Space Marines OU la faction
/// générique "Space Marines" elle-même.
bool isSpaceMarineFactionName(String name) =>
    spaceMarineChapterFactionNames.contains(name) ||
    isGenericSpaceMarinesFactionName(name);
