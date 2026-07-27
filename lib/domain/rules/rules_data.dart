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
    id: 'guide-listes-d-armee',
    title: "Exemples de listes d'armée",
    category: RuleCategory.armyLists,
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
        "Une liste par faction, à ~2000 pts, construite uniquement avec des "
        "unités et des coûts réellement présents dans le catalogue de "
        "l'application — pour avoir un point de départ concret plutôt qu'une "
        "page blanche en ouvrant l'Army Builder. Ce ne sont pas forcément "
        "les listes les plus optimisées du moment (le méta évolue sans "
        "arrêt), et certaines factions ont un total légèrement inférieur à "
        "2000 pts quand leur catalogue actuel ne compte pas encore assez "
        "d'unités chiffrées pour aller plus loin.",
    sections: [
      RuleSection(
        heading: 'Adepta Sororitas',
        body:
            'Exemple de liste à environ 1995 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Imagifère — 65 pts\nEscouade De Sœurs De Bataille — 105 pts\nExo-harnais Parangon — 210 pts\nSainte Célestine — 150 pts\nEscouade Dominion — 115 pts\nExorcist — 210 pts\nEscouade Retributor — 105 pts\nEscouade De Sœurs Novices — 100 pts\n2 × Castigator — 320 pts\nEscouade Séraphine — 80 pts\nImmolator — 115 pts\nEscouade Zéphyrine — 80 pts\nMachines De Pénitence — 75 pts\nEscouade Repentia — 75 pts\nRhino Sororitas — 75 pts\nCélestes Sacro-saintes — 70 pts\nArco-flagellants — 45 pts'
            ' — Total : 1995 pts',
      ),
      RuleSection(
        heading: 'Adeptus Custodes',
        body:
            'Exemple de liste à environ 1980 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Champion Des Lames — 120 pts\nProsecutors — 40 pts\n2 × Gardes Custodiens — 420 pts\n2 × Land Raider Vénérable — 440 pts\n2 × Vertus Praetors — 300 pts\nVigilators — 50 pts\n2 × Dreadnought Contemptor Vénérable — 340 pts\nCustodiens Allarus — 120 pts\n2 × Rhino Anathema Psykana — 150 pts'
            ' — Total : 1980 pts',
      ),
      RuleSection(
        heading: 'Adeptus Mechanicus',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Technaugure — 55 pts\nRangers Skitarii — 85 pts\nPatrouilleurs Skitarii — 95 pts\n2 × Robots Kastelan — 360 pts\nBrécheurs Kataphron — 160 pts\nStérilisateurs Pteraxii — 80 pts\nDésintégrateur Skorpius — 165 pts\nDestructeurs Kataphron — 105 pts\nCorrôdeurs Sicariens — 75 pts\nOnagre Des Dunes — 155 pts\nÉlectroprêtres Fulgurites — 70 pts\nGlisseur Skorpius — 85 pts\nVautours Pteraxii — 70 pts\nFerro-échassiers Ballistarii — 75 pts\nInfiltrateurs Sicariens — 70 pts\nÉlectroprêtres Corpuscarii — 65 pts\nHussards Serberys — 60 pts\nServitors — 60 pts\n2 × Soufredogues Serberys — 110 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Aeldari',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Maugan Ra — 100 pts\nGardiens Défenseurs — 100 pts\nGardiens De Choc — 100 pts\nChevalier Fantôme — 435 pts\nGardes Fantômes — 170 pts\nDragons Flamboyants — 120 pts\nConclave De Psycharques Coureurs Célestes — 45 pts\nTisseur De Nuit — 190 pts\nGuerriers Fantômes — 160 pts\nLances Étincelantes — 110 pts\nPrisme De Feu — 150 pts\nTisseurs Célestes — 95 pts\nBanshees Huantes — 95 pts\nFaucon — 130 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Agents de l\'Imperium',
        body:
            'Exemple de liste à environ 1385 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Assassin Culexus — 85 pts\n3 × Cosmomarins En Armes — 150 pts\n3 × Escouade Vigilant — 255 pts\n3 × Sapeurs De La Marine Impériale — 270 pts\n3 × Escouade D’exaction — 270 pts\n3 × Escouade Subductor — 255 pts\nAssassin Callidus — 100 pts'
            ' — Total : 1385 pts',
      ),
      RuleSection(
        heading: 'Astra Militarum',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Sly Marbo — 55 pts\nTroupes De Choc Cadiennes — 65 pts\nDeath Korps De Krieg — 65 pts\nCombattants Des Jungles De Catachan — 65 pts\nStormsword — 465 pts\n2 × Batterie D’artillerie — 190 pts\nEscouade De Taurogryns — 100 pts\nKasrkin — 110 pts\nBanesword — 450 pts\nEscouade D’État-Major Du Militarum Tempestus — 85 pts\nFantômes De Gaunt — 100 pts\nChar De Combat Rogal Dorn — 250 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Black Templars',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Chapelain En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\n2 × Escouade Lourde Intercessor — 200 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nLand Raider — 220 pts\nQuad Invader — 60 pts\nEscouade Centurion Devastator — 165 pts\nEscouade Terminator — 170 pts\nRepulsor Executioner — 220 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Blood Angels',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Doyen En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\n2 × Escouade Lourde Intercessor — 200 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nRepulsor Executioner — 220 pts\nQuad Invader — 60 pts\nEscouade Centurion Devastator — 165 pts\nEscouade Terminator — 170 pts\nLand Raider Crusader — 220 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Chaos Daemons',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Epidemius — 80 pts\nNurglings — 40 pts\nDémonettes — 100 pts\n2 × Sanguinaires — 220 pts\n2 × Bourdons De La Peste — 220 pts\n2 × Horreurs Roses — 280 pts\nCanon À Crânes — 95 pts\n2 × Horreurs Bleues — 250 pts\nBêtes De Nurgle — 65 pts\n2 × Portepestes — 220 pts\nHurleurs — 80 pts\nMolosses De Khorne — 75 pts\nIncendiaires — 65 pts\n2 × Autel Des Crânes — 210 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Chaos Knights',
        body:
            'Exemple de liste à environ 1980 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            '2 × Dogue Rabatteur — 280 pts\nDogue Exécuteur — 130 pts\n2 × Dogue Brigand — 280 pts\n2 × Chevalier Abominable — 710 pts\n2 × Dogue Karnivore — 300 pts\n2 × Dogue Chasseur — 280 pts'
            ' — Total : 1980 pts',
      ),
      RuleSection(
        heading: 'Chaos Space Marines',
        body:
            'Exemple de liste à environ 1970 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Maître Des Exécutions — 80 pts\nBande De Cultistes — 50 pts\nLégionnaires — 90 pts\nSeigneur Des Crânes De Khorne — 450 pts\nObliterators — 160 pts\nEscouade Terminator Du Chaos — 180 pts\nLand Raider Du Chaos — 220 pts\nHavocs — 125 pts\nÉlus — 125 pts\nMétaragne — 205 pts\nFabius Bile — 85 pts\nSerres Du Warp — 125 pts\nRhino Du Chaos — 75 pts'
            ' — Total : 1970 pts',
      ),
      RuleSection(
        heading: 'Dark Angels',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Doyen En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\nEscouade Lourde Intercessor — 100 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nRepulsor Executioner — 220 pts\nQuad Invader — 60 pts\nEscouade Centurion Devastator — 165 pts\nEscouade Terminator De La Deathwing — 180 pts\nLand Raider — 220 pts\nEscouade Infernus — 90 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Death Guard',
        body:
            'Exemple de liste à environ 1965 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Biologus Putréfacteur — 60 pts\nMarines De La Peste — 95 pts\n2 × Land Raider De La Death Guard — 480 pts\n2 × Terminators Du Linceul — 320 pts\n2 × Profanateur De La Death Guard — 330 pts\nTerminators Rouillarques — 115 pts\nPredator Destructor De La Death Guard — 145 pts\nPredator Annihilator De La Death Guard — 135 pts\nSemi-chenillés Méphitiques — 100 pts\nDrone Fétide — 100 pts\nRhino De La Death Guard — 85 pts'
            ' — Total : 1965 pts',
      ),
      RuleSection(
        heading: 'Deathwatch',
        body:
            'Exemple de liste à environ 1980 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Chapelain En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\nEscouade Lourde Intercessor — 100 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nKill Team Indomitor — 250 pts\nEscouade Terminator Deathwatch — 190 pts\nRepulsor Executioner — 220 pts\nQuad Invader — 60 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nDreadnought Redemptor — 195 pts'
            ' — Total : 1980 pts',
      ),
      RuleSection(
        heading: 'Drukhari',
        body:
            'Exemple de liste à environ 1955 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Drazhar — 85 pts\n3 × Guerriers Kabalites — 345 pts\n3 × Ravageur — 345 pts\n3 × Cour De L’archonte — 375 pts\n2 × Talos — 160 pts\n3 × Hellions — 255 pts\n2 × Venom — 140 pts\n2 × Écumeurs — 140 pts\n2 × Cronos — 110 pts'
            ' — Total : 1955 pts',
      ),
      RuleSection(
        heading: 'Genestealer Cults',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Hybrides Néophytes — 65 pts\n2 × Concasseur Goliath — 240 pts\n2 × Aberrants — 270 pts\nChacals Atalans — 85 pts\nPatriarche — 75 pts\n2 × Tout-terrain Achilles — 190 pts\nAbominant — 85 pts\nGenestealers Pure-souche — 75 pts\nMagus — 50 pts\n2 × Camion Goliath — 170 pts\n2 × Primus — 140 pts\nHybrides Métamorphes — 70 pts\nSaboteur Reductus — 65 pts\nKelermorphe — 60 pts\nNexos — 60 pts\nAlphus Chacal — 55 pts\nAcolyte Garde-icône — 50 pts\nBiophagus — 50 pts\nClamavus — 50 pts\nSanctus — 50 pts\nLocus — 45 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Grey Knights',
        body:
            'Exemple de liste à environ 1955 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Castellan Crowe — 90 pts\nEscouade Terminator De Confrérie — 160 pts\nLand Raider Redeemer Des Grey Knights — 270 pts\nEscouade Paladin — 180 pts\nLand Raider Des Grey Knights — 220 pts\nEscouade Interceptor — 130 pts\nLand Raider Crusader Des Grey Knights — 220 pts\nEscouade Purificator — 125 pts\nCuirassier Némésis — 210 pts\nEscouade Purgator — 125 pts\nDreadnought Vénérable Des Grey Knights — 140 pts\nRazorback Des Grey Knights — 85 pts'
            ' — Total : 1955 pts',
      ),
      RuleSection(
        heading: 'Imperial Knights',
        body:
            'Exemple de liste à environ 1885 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Chevalier Castellan — 410 pts\nArmigères Helvériens — 140 pts\nArmigères Hastaires — 140 pts\nCanis Rex — 415 pts\nChevalier Croisé — 395 pts\nChevalier Vigilant — 385 pts'
            ' — Total : 1885 pts',
      ),
      RuleSection(
        heading: 'Leagues of Votann',
        body:
            'Exemple de liste à environ 1975 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            '2 × Guerriers Âtrekogs — 200 pts\n2 × Forteresse Mobile Hekaton — 480 pts\n2 × Âtregardes Einhyrs — 270 pts\n2 × Beserks Cthoniens — 200 pts\n2 × Sagitaur — 190 pts\n2 × Ûthar Le Destiné — 190 pts\n2 × Pionniers Hernkogs — 160 pts\nTonnekogs Brokhyrs — 80 pts\nKâhl — 70 pts\nChampion Einhyr — 70 pts\nGrimnyr — 65 pts'
            ' — Total : 1975 pts',
      ),
      RuleSection(
        heading: 'Necrons',
        body:
            'Exemple de liste à environ 1985 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Orikan Le Devin — 80 pts\nImmortels — 70 pts\nGuerriers Nécrons — 90 pts\nCrypte Tesseract — 425 pts\nDestroyers Lourds Lokhusts — 55 pts\nDestroyers Skorpekhs — 90 pts\nPrétoriens Du Triarcat — 90 pts\nMonolithe — 400 pts\nCryptoserfs — 60 pts\nDestroyers Ophydiens — 80 pts\n2 × Rôdeur Du Triarcat — 220 pts\nDestroyers Lokhusts — 40 pts\n2 × Console D’annihilation — 210 pts\nRéanimateur Canoptek — 75 pts'
            ' — Total : 1985 pts',
      ),
      RuleSection(
        heading: 'Orks',
        body:
            'Exemple de liste à environ 1955 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Gros Mek En Méga-armure — 90 pts\nBoyz — 80 pts\n2 × Morkanaute — 560 pts\nMéganobz — 65 pts\n2 × Kommandos — 240 pts\n2 × Gorkanaute — 530 pts\n2 × Nobz — 210 pts\nBoosta-klata Kustom — 70 pts\nGretchins — 40 pts\nDragsta Shokk — 70 pts'
            ' — Total : 1955 pts',
      ),
      RuleSection(
        heading: 'Space Marines (Adeptus Astartes)',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Chapelain En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\n2 × Escouade Lourde Intercessor — 200 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nRepulsor Executioner — 220 pts\nQuad Invader — 60 pts\nEscouade Centurion Devastator — 165 pts\nEscouade Terminator — 170 pts\nLand Raider Crusader — 220 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'Space Wolves',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Doyen En Armure Terminator — 75 pts\nEscouade D’assaut Intercessor — 75 pts\nEscouade Intercessor — 80 pts\nEscouade Lourde Intercessor — 100 pts\nLand Raider Redeemer — 270 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade D’assaut Terminator — 180 pts\nRepulsor Executioner — 220 pts\nQuad Invader — 60 pts\nEscouade Centurion Devastator — 165 pts\nChasseurs Gris — 180 pts\nLand Raider — 220 pts\nEscouade Infernus — 90 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'T\'au Empire',
        body:
            'Exemple de liste à environ 1990 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Commandant En Exo-armure Enforcer — 80 pts\nÉquipe De Brécheurs — 100 pts\nStormsurge — 400 pts\nExo-armures Stealth — 110 pts\n2 × Carnivores Kroots — 130 pts\nExo-armure Riptide — 190 pts\nExorôdeurs Kroots — 55 pts\nFrelons Vespides — 65 pts\nExo-armure Ghostkeel — 160 pts\nCavaliers Krootox — 40 pts\nChiens Kroots — 40 pts\nBombardier Sun Shark — 160 pts\nChar Hammerhead — 145 pts\nChar Sky Ray — 140 pts\nTourelle Tidewall — 90 pts\nDevilfish — 85 pts'
            ' — Total : 1990 pts',
      ),
      RuleSection(
        heading: 'Thousand Sons',
        body:
            'Exemple de liste à environ 1995 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Sorcier Des Thousand Sons En Armure Terminator — 85 pts\nTzaangors — 70 pts\nMarines Rubricae — 105 pts\n2 × Land Raider Des Thousand Sons — 440 pts\nRejetons Du Chaos Des Thousand Sons — 65 pts\nTerminators Du Scarabée Occulte — 180 pts\nVindicator Des Thousand Sons — 185 pts\nTzaangors Éclairés — 55 pts\nMutalithe À Vortex — 175 pts\nProfanateur Des Thousand Sons — 165 pts\nPredator Destructor Des Thousand Sons — 140 pts\nPredator Annihilator Des Thousand Sons — 130 pts\nMétabrutus Des Thousand Sons — 110 pts\nRhino Des Thousand Sons — 90 pts'
            ' — Total : 1995 pts',
      ),
      RuleSection(
        heading: 'Tyranids',
        body:
            'Exemple de liste à environ 2000 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Neurotyran — 105 pts\nTermagants — 60 pts\nHormagaunts — 65 pts\nGargouilles — 85 pts\nTyrannofex — 200 pts\nRôdeurs — 125 pts\nZoanthropes — 100 pts\nMaleceptor — 170 pts\n2 × Gardes Des Ruches — 180 pts\nGuerriers Tyranides Avec Bio-armes De Mêlée — 75 pts\nToxicrène — 150 pts\nGardes Tyranides — 80 pts\nGenestealers — 75 pts\nTrygon — 140 pts\nLictor — 60 pts\nVenomthropes — 70 pts\nExocrine — 140 pts\nBiovores — 50 pts\nBondisseurs De Von Ryan — 70 pts'
            ' — Total : 2000 pts',
      ),
      RuleSection(
        heading: 'World Eaters',
        body:
            'Exemple de liste à environ 1945 pts, construite à partir des coûts '
            'réellement recensés dans le catalogue — une base solide et légale pour découvrir la faction, pas forcément la liste la plus optimisée du moment (le méta évolue, et certains coûts ne sont pas encore renseignés).\n\n'
            'Seigneur Invocatus — 110 pts\nChakhals — 65 pts\nBerzerks De Khorne — 180 pts\nSeigneur Des Crânes De Khorne — 505 pts\nOctoliés Exaltés — 140 pts\nEscouade Terminator Des World Eaters — 175 pts\nLand Raider Des World Eaters — 220 pts\nOctoliés — 135 pts\nProfanateur Des World Eaters — 180 pts\nRejetons Du Chaos Des World Eaters — 90 pts\nPredator Annihilator Des World Eaters — 145 pts'
            ' — Total : 1945 pts',
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
