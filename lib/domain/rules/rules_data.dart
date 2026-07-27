import 'rule_document.dart';

/// Static catalog backing the Règles page. See `RuleDocument` for the
/// shape and `local_assets/rules/README.md` for the PDF-file convention.
final List<RuleDocument> kRuleDocuments = [
  RuleDocument(
    id: 'universal-rules-updates-2026-07-22',
    title: 'Mises à Jour des Règles Universelles',
    category: RuleCategory.errata,
    version: '1.0',
    releaseDate: DateTime(2026, 7, 22),
    lastUpdate: DateTime(2026, 7, 22),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 0,
    errataCount: 4,
    intro:
        "Ce document contient des mises à jour qui dépassent le cadre des "
        "Packs de Faction et visent à améliorer le fonctionnement de "
        "certaines mécaniques ou règles de codex pour l'ensemble des "
        "factions. Valide pour le jeu égal à partir du 22 juillet 2026.",
    sections: [
      RuleSection(
        heading: 'Modifier le coût en PC d\'un stratagème',
        body:
            "Les règles qui vous permettent de cibler une unité amie avec "
            "un stratagème pour 0PC, sans préciser le nom du stratagème, "
            "réduisent à la place de 1PC le coût de cette utilisation de "
            "ce stratagème.",
      ),
      RuleSection(
        heading:
            'Stratagèmes qui peuvent être utilisés plus d\'une fois par '
            'phase/tour',
        body:
            "Les parties d'une règle qui permettent à un joueur d'utiliser "
            "un stratagème, même s'il a déjà ciblé une autre unité avec "
            "celui-ci à la même phase peuvent seulement être utilisées si "
            "le nom du stratagème y est précisé. De même, si un stratagème "
            "est limité à une seule utilisation par joueur, par tour, par "
            "round de bataille ou par bataille, les parties d'une telle "
            "règle peuvent être utilisées seulement si le nom du "
            "stratagème y est précisé.",
      ),
      RuleSection(
        heading: 'Stratagèmes qui empêchent des unités d\'être ciblées',
        body:
            "Si un stratagème a un effet qui stipule que l'unité cible "
            '"peut seulement être choisie comme cible d\'une attaque de '
            'tir si la figurine attaquante est à 12" ou moins", ou "ne '
            'peut pas être ciblée par des attaques de tir à moins que la '
            'figurine attaquante soit à 12" ou moins", cet effet est '
            'modifié comme suit : "peut être choisie comme cible d\'une '
            'attaque de tir seulement si la figurine attaquante est à 18" '
            'ou moins."',
      ),
      RuleSection(
        heading: 'Stratagèmes qui ajoutent de nouvelles unités à votre armée',
        body:
            "Si un stratagème a l'effet d'ajouter \"une nouvelle unité à "
            "votre armée, identique à votre unité détruite\", ajoutez la "
            "Restriction suivante à ce stratagème : \"RESTRICTIONS : Vous "
            "pouvez utiliser ce stratagème une seule fois par bataille.\"",
      ),
    ],
  ),
  RuleDocument(
    id: 'warhammer-40000-core-rules',
    title: 'Warhammer 40,000 – Édition 11',
    category: RuleCategory.mainRules,
    version: '11.0',
    releaseDate: DateTime(2025, 7, 16),
    lastUpdate: DateTime(2025, 7, 16),
    language: 'Anglais',
    isCurrent: true,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 12400,
    errataCount: 0,
    localAssetId: 'warhammer-40000-core-rules',
  ),
  RuleDocument(
    id: 'missions-pack-leviathan',
    title: 'Missions Pack – Leviathan',
    category: RuleCategory.missions,
    version: '1.2',
    releaseDate: DateTime(2024, 3, 2),
    lastUpdate: DateTime(2024, 3, 2),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 8700,
    errataCount: 0,
  ),
  RuleDocument(
    id: 'munitorum-field-manual-2024',
    title: 'Munitorum Field Manual 2024',
    category: RuleCategory.pointsAndProfiles,
    version: '1.0',
    releaseDate: DateTime(2024, 2, 20),
    lastUpdate: DateTime(2024, 2, 20),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 6100,
    errataCount: 0,
  ),
  RuleDocument(
    id: 'chapter-approved-2024',
    title: 'Chapter Approved 2024',
    category: RuleCategory.errata,
    version: '1.1',
    releaseDate: DateTime(2024, 1, 10),
    lastUpdate: DateTime(2024, 1, 10),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 5300,
    errataCount: 0,
  ),
  RuleDocument(
    id: 'warhammer-40000-index-factions',
    title: 'Warhammer 40,000 – Index des Factions',
    category: RuleCategory.mainRules,
    version: '10.2.0',
    releaseDate: DateTime(2023, 11, 1),
    lastUpdate: DateTime(2023, 11, 1),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 3900,
    errataCount: 0,
  ),
  RuleDocument(
    id: 'guide-chaine-alimentaire',
    title: 'La chaîne alimentaire des unités',
    category: RuleCategory.tacticalGuides,
    version: '1.0',
    releaseDate: DateTime(2026, 7, 27),
    lastUpdate: DateTime(2026, 7, 27),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Wargame Board',
    downloads: 0,
    errataCount: 0,
    intro:
        "Aucune unité n'est bonne contre tout : chaque profil d'arme est "
        "taillé pour une catégorie de cible précise, et chaque type de "
        "figurine a un rôle dans la liste. Ce guide explique la logique "
        "de contre qui structure une partie de Warhammer 40,000 — pas "
        "pour la réciter, mais pour repérer d'un coup d'œil ce que fait "
        "une unité et ce qui lui pose problème.",
    sections: [
      RuleSection(
        heading: "Les grands rôles d'unité",
        body:
            "Anti-infanterie : cadence de tir élevée (attaques multiples "
            "ou gabarits) mais Force et PA modestes — rentabilisé contre "
            "des cibles nombreuses à faible Endurance et Sauvegarde. "
            "Anti-élite / anti-personnage : peu d'attaques mais Force, PA "
            "et Dégâts élevés — taillé pour percer une poignée de figurines "
            "coriaces plutôt que d'en toucher beaucoup. Anti-char / "
            "anti-véhicule : Force et PA très hauts, Dégâts multiples, "
            "pensé pour les grosses valeurs d'Endurance et de Sauvegarde "
            "des blindés et Monstres. Contrôle d'objectif : Contrôle "
            "d'Objectif élevé et endurance au nombre plutôt que puissance "
            "de feu — sa valeur se mesure au tableau des objectifs, pas "
            "au nombre de figurines tuées. Soutien : buffs, débuffs et "
            "pouvoirs psychiques qui rendent les autres unités meilleures "
            "sans nécessairement infliger de dégâts eux-mêmes.",
      ),
      RuleSection(
        heading: 'Le mot-clé ANTI-X, mécanique centrale du jeu',
        body:
            "Une arme avec [ANTI-INFANTERIE 4+] transforme automatiquement "
            "en touche critique tout jet de Touche non modifié de 4+ "
            "contre une unité INFANTERIE — quelle que soit sa "
            "Compétence de Tir ou de Combat normale. Le même principe "
            "existe pour [ANTI-VÉHICULE X+], [ANTI-MONSTRE X+], "
            "[ANTI-PSYKER X+], etc. C'est ce mot-clé qui matérialise la "
            "chaîne alimentaire dans les règles : une arme peut être "
            "quelconque contre la plupart des cibles mais dévastatrice "
            "dès qu'elle rencontre le mot-clé qu'elle contre. Lire les "
            "mots-clés ANTI-X des armes d'une fiche, c'est lire "
            "directement son rôle voulu par le concepteur.",
      ),
      RuleSection(
        heading: "Une logique de contre, pas un triangle rigide",
        body:
            "Contrairement à un pierre-feuille-ciseaux à trois pointes "
            "fixes, la chaîne 40k est une chaîne de spécialisation à "
            "plusieurs maillons : l'infanterie légère nombreuse tient du "
            "terrain et sature les tirs, mais fond face à un déluge "
            "d'armes anti-infanterie. L'infanterie d'élite encaisse ce "
            "déluge grâce à sa Sauvegarde et son Endurance, mais craint "
            "les armes anti-élite à haute Pénétration d'Armure. Les "
            "véhicules et Monstres dominent la ligne de front par leurs "
            "Dégâts et leur résilience, mais sont la cible de choix des "
            "armes anti-véhicule dédiées. Ces unités anti-véhicule sont "
            "en général peu nombreuses et chères en points, donc "
            "vulnérables si elles sont submergées avant d'avoir tiré ou "
            "chargées par de l'infanterie nombreuse en mêlée — ce qui "
            "boucle la chaîne. Aucun maillon ne bat tous les autres : "
            "chacun a un angle mort.",
      ),
      RuleSection(
        heading: "Repérer le rôle d'une unité sur sa fiche",
        body:
            "Trois choses à regarder sur les armes d'une fiche : la Force "
            "et la Pénétration d'Armure (capacité à percer une bonne "
            "Sauvegarde), les Dégâts (capacité à faire tomber une grosse "
            "Endurance en peu de touches) et les mots-clés entre crochets, "
            "en particulier les ANTI-X. Sur la cible visée, comparer avec "
            "son Endurance, sa Sauvegarde (et Sauvegarde Invulnérable "
            "éventuelle) et ses Points de Vie. Une arme F4 PA0 D1 est "
            "pensée pour de la troupe légère ; une arme F14 PA-3 D6 est "
            "pensée pour un char. Entre les deux, la plupart des profils "
            "sont des compromis à situer sur ce même axe.",
      ),
      RuleSection(
        heading: 'Construire une liste sans trou dans la chaîne',
        body:
            "L'erreur la plus fréquente en liste d'armée est de laisser "
            "un maillon vide : aucune arme anti-char face à un adversaire "
            "qui aligne des blindés, ou aucune arme anti-infanterie de "
            "masse face à une horde d'Orks ou de Tyranides. Avant "
            "d'ajouter une unité de plus dans son rôle favori, il vaut "
            "mieux vérifier que chaque maillon de la chaîne (anti-troupe, "
            "anti-élite, anti-char, contrôle d'objectif) a au moins une "
            "réponse dans la liste — quitte à ce que ce soit la même "
            "unité qui couvre deux rôles grâce à une arme polyvalente.",
      ),
    ],
  ),
  RuleDocument(
    id: 'faqs-core-rules',
    title: 'FAQs – Édition 11',
    category: RuleCategory.faqs,
    version: '1.0',
    releaseDate: DateTime(2025, 7, 16),
    lastUpdate: DateTime(2025, 7, 16),
    language: 'Anglais',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Games Workshop',
    downloads: 4200,
    errataCount: 0,
  ),
];
