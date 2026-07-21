/// Résumés (dans nos propres mots, pas le texte officiel du livre) des
/// règles génériques ("Core rules") les plus souvent référencées sur les
/// fiches sans description associée. Ces règles ne sont imprimées qu'une
/// fois dans le livre de règles de base — les fiches se contentent d'y
/// faire référence par leur nom (ex: "Frappe en Profondeur", parfois
/// suivi d'un paramètre comme "Éclaireurs 6\"") — donc le parseur PDF n'a
/// jamais de texte à extraire pour elles.
///
/// Volontairement limité aux règles génériques, stables d'une faction à
/// l'autre : les règles propres à une faction ou une légion (ex:
/// "Waaagh!", "Synapse", "Protocoles de Réanimation") ne sont pas
/// couvertes ici, le risque de se tromper sur leur texte exact (qui varie
/// et évolue par codex) étant trop grand sans la source complète.
library;

const Map<String, String> kCoreAbilityGlossary = {
  'meneur':
      'Un modèle PERSONNAGE dont la règle Meneur mentionne cette unité '
          'peut la rejoindre pour former une seule unité combinée, tant '
          'qu\'aucune restriction ne l\'en empêche.',
  'frappe en profondeur':
      'Cette unité peut être placée en Réserve avant la bataille. Depuis '
          'la Réserve Stratégique, elle peut être déployée n\'importe où '
          'sur le champ de bataille à plus de 9" de tout modèle ennemi.',
  'infiltrateurs':
      'Pendant le déploiement, cette unité peut être installée n\'importe '
          'où sur le champ de bataille à plus de 9" de la zone de '
          'déploiement adverse et de tout modèle ennemi, plutôt que dans '
          'sa propre zone de déploiement.',
  'discretion':
      'Chaque fois qu\'une attaque à distance est allouée à une unité '
          'avec cette capacité, si le tireur est à plus de 12" du modèle '
          'le plus proche de cette unité, la Capacité de Tir de l\'arme '
          'utilisée est dégradée d\'1 point.',
  'insensible a la douleur':
      'Chaque fois qu\'un modèle avec cette capacité devrait perdre un '
          'point de vie, jetez un dé : au score indiqué (affiché après le '
          'nom de la règle) ou plus, ce point de vie n\'est pas perdu.',
  'eclaireurs':
      'Au début de la bataille, avant le premier tour de jeu, cette unité '
          'peut effectuer un mouvement normal de la distance indiquée '
          '(affichée après le nom de la règle), à condition de rester à '
          'plus de 9" de tout modèle ennemi.',
  'combat en premier':
      'Pendant la phase de Combat, les modèles de cette unité combattent '
          'lors de l\'étape "Combattants en premier", avant les unités '
          'qui n\'ont pas cette capacité.',
  'agent solitaire':
      'Ce modèle ne peut être choisi comme cible d\'une attaque à '
          'distance que par un modèle attaquant situé à moins de 12" de '
          'lui (les effets qui ne ciblent pas une unité spécifique ne '
          'sont pas concernés).',
  'destruction nefaste':
      'Chaque fois qu\'une attaque effectuée avec cette arme obtient une '
          'Touche Critique, elle inflige le nombre de blessures mortelles '
          'indiqué (affiché après le nom de la règle) au lieu des '
          'dégâts normaux, sans autre jet à effectuer.',
};

/// Normalise un nom d'aptitude pour la recherche dans le glossaire :
/// minuscules, accents retirés, et paramètre numérique/dé final retiré
/// (ex: `Éclaireurs 6"` -> `eclaireurs`, `Insensible à la Douleur 5+` ->
/// `insensible a la douleur`).
String _normalizeAbilityName(String name) {
  const accents = {
    'à': 'a', 'â': 'a', 'ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'î': 'i', 'ï': 'i',
    'ô': 'o', 'ö': 'o',
    'ù': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c',
  };
  var normalized = name.toLowerCase();
  accents.forEach((accented, plain) {
    normalized = normalized.replaceAll(accented, plain);
  });
  normalized = normalized.replaceAll(RegExp(r'''[’']'''), ' ');
  // Retire un paramètre final type `6"`, `5+`, `d3`, `d6+2`, `1`.
  normalized =
      normalized.replaceAll(RegExp(r'\s+[\d"+]*d?\d*\+?"?\s*$'), '').trim();
  normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
  return normalized;
}

/// Retourne un résumé générique pour [name] si elle fait partie des
/// règles Core couvertes par ce glossaire, sinon `null`.
String? lookupCoreAbilityDescription(String name) {
  return kCoreAbilityGlossary[_normalizeAbilityName(name)];
}
