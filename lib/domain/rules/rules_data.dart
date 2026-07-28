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
    version: '1.1',
    releaseDate: DateTime(2026, 7, 27),
    lastUpdate: DateTime(2026, 7, 27),
    language: 'Français',
    isCurrent: false,
    isUpToDate: true,
    publisher: 'Wargame Board',
    downloads: 0,
    errataCount: 0,
    intro:
        "Plusieurs styles de liste par faction — inspirés des façons de "
        "jouer réellement rencontrées en partie (horde, colonne blindée, "
        "alpha strike, gunline, deathstar d'élite...), pas d'un remplissage "
        "algorithmique au hasard. Chaque liste est construite uniquement "
        "avec des unités et des coûts réellement présents dans le "
        "catalogue de l'application, à environ 2000 pts. Ce ne sont pas "
        "forcément les listes les plus optimisées du moment (le méta "
        "évolue sans arrêt) mais des bases concrètes et légales pour "
        "démarrer une faction dans un style de jeu donné.",
    sections: [
      RuleSection(
        heading: 'Adepta Sororitas — Croisade Zélote',
        body:
            'Une ruée de foi fanatique où novices, repentia et arco-flagellants submergent l\'ennemi au corps à corps sous la protection des Séraphines et Zéphyrines.\n\nChanoinesse — 75 pts\nSainte Célestine — 150 pts\nPalatine — 50 pts\n3 × Escouade De Sœurs De Bataille — 315 pts\n3 × Escouade Repentia — 225 pts\n2 × Escouade Séraphine — 160 pts\n2 × Escouade Zéphyrine — 160 pts\n3 × Arco-flagellants — 135 pts\n2 × Escouade Dominion — 230 pts\n3 × Escouade De Sœurs Novices — 300 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Adepta Sororitas — Colonne Blindée',
        body:
            'Une force mécanisée qui avance derrière un mur de Rhino, Immolator, Exorcist et Castigator, avec Morvenn Vahl en fer de lance.\n\nMorvenn Vahl — 170 pts\n2 × Exorcist — 420 pts\n2 × Castigator — 320 pts\n2 × Rhino Sororitas — 150 pts\n2 × Immolator — 230 pts\n3 × Escouade De Sœurs De Bataille — 315 pts\nEscouade Retributor — 105 pts\nExo-harnais Parangon — 210 pts — Total : 1920 pts',
      ),
      RuleSection(
        heading: 'Adepta Sororitas — Ligne de Feu Sacrée',
        body:
            'Une gunline statique où Exorcist et Retributor pilonnent l\'ennemi à distance sans jamais avancer, protégée par des Sœurs de Bataille et bénie par la Chanoinesse.\n\nChanoinesse — 75 pts\nImagifère — 65 pts\nPrêcheur — 50 pts\n2 × Escouade De Sœurs De Bataille — 210 pts\n2 × Célestes Sacro-saintes — 140 pts\n4 × Escouade Retributor — 420 pts\n4 × Exorcist — 840 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Adeptus Custodes — Muraille Dorée',
        body:
            'Un mur d\'élite compact de Gardes Custodiens et Custodiens Allarus, épaulé par un Land Raider et un Dreadnought Contemptor, qui avance lentement et écrase tout sur son passage.\n\nTrajann Valoris — 140 pts\n3 × Gardes Custodiens — 630 pts\n2 × Custodiens Allarus — 240 pts\nCapitaine-rempart En Armure Terminator Allarus — 130 pts\nLand Raider Vénérable — 220 pts\nDreadnought Contemptor Vénérable — 170 pts\nAleya — 65 pts\nChevalier-centura — 55 pts\n2 × Prosecutors — 80 pts\nValerian — 110 pts\nChampion Des Lames — 120 pts — Total : 1960 pts',
      ),
      RuleSection(
        heading: 'Adeptus Custodes — Charge Ailée',
        body:
            'Une frappe rapide de Praetors Vertus et de Vigilators déferlant sur les flancs, menée par un Capitaine-Rempart sur motojet Dawneagle.\n\nCapitaine-rempart Sur Motojet Dawneagle — 150 pts\n5 × Vertus Praetors — 750 pts\n6 × Vigilators — 300 pts\n3 × Prosecutors — 120 pts\nTrajann Valoris — 140 pts\nChampion Des Lames — 120 pts\nAleya — 65 pts\nChevalier-centura — 55 pts\nValerian — 110 pts — Total : 1810 pts',
      ),
      RuleSection(
        heading: 'Adeptus Custodes — Colonne de Fer Doré',
        body:
            'Une colonne mécanisée de Land Raiders et de Dreadnoughts Vénérables transporte des Custodiens Allarus au contact, un axe blindé distinct du mur d\'infanterie et de la cavalerie ailée.\n\nCapitaine-rempart En Armure Terminator Allarus — 130 pts\nValerian — 110 pts\n3 × Land Raider Vénérable — 660 pts\n3 × Dreadnought Contemptor Vénérable — 510 pts\n2 × Rhino Anathema Psykana — 150 pts\n2 × Prosecutors — 80 pts\n2 × Custodiens Allarus — 240 pts — Total : 1880 pts',
      ),
      RuleSection(
        heading: 'Adeptus Mechanicus — Horde Skitarii',
        body:
            'Un essaim de troupes Skitarii bon marché (Rangers, Patrouilleurs, éclaireurs et cavaliers Serberys) qui submerge le nombre d\'objectifs.\n\nMaréchal Skitarii — 35 pts\n3 × Rangers Skitarii — 255 pts\n3 × Patrouilleurs Skitarii — 285 pts\n2 × Électroprêtres Corpuscarii — 130 pts\n2 × Électroprêtres Fulgurites — 140 pts\n2 × Vautours Pteraxii — 140 pts\n2 × Hussards Serberys — 120 pts\n2 × Soufredogues Serberys — 110 pts\n2 × Infiltrateurs Sicariens — 140 pts\n2 × Corrôdeurs Sicariens — 150 pts\n2 × Stérilisateurs Pteraxii — 160 pts\nTechnaugure — 55 pts\nTechnoarchéologue — 45 pts\n2 × Servitors — 120 pts — Total : 1885 pts',
      ),
      RuleSection(
        heading: 'Adeptus Mechanicus — Légion Robotique',
        body:
            'Un mur de robots et de cyborgs (Kastelan, Kataphron, Onagres, Ballistarii) coordonné par Belisarius Cawl pour un tir massif à distance.\n\nBelisarius Cawl — 175 pts\n2 × Robots Kastelan — 360 pts\n2 × Brécheurs Kataphron — 320 pts\n2 × Destructeurs Kataphron — 210 pts\n2 × Onagre Des Dunes — 310 pts\n2 × Ferro-échassiers Ballistarii — 150 pts\nRangers Skitarii — 85 pts\nTechnoprêtre Dominus — 65 pts\nDésintégrateur Skorpius — 165 pts — Total : 1840 pts',
      ),
      RuleSection(
        heading: 'Adeptus Mechanicus — Chevauchée Skitarii',
        body:
            'Une force rapide de cavaliers Serberys et d\'infanterie Pteraxii à réacteur dorsal harcèle et déborde l\'adversaire, un axe de vitesse distinct de la horde de troupes bon marché et du mur de robots lourds.\n\nMaréchal Skitarii — 35 pts\nTechnoprêtre Manipulus — 60 pts\nTechnaugure — 55 pts\nTechnoprêtre Dominus — 65 pts\n5 × Hussards Serberys — 300 pts\n5 × Soufredogues Serberys — 275 pts\n3 × Vautours Pteraxii — 210 pts\n3 × Stérilisateurs Pteraxii — 240 pts\n2 × Ferro-échassiers Ballistarii — 150 pts\n2 × Infiltrateurs Sicariens — 140 pts\nRangers Skitarii — 85 pts\n2 × Glisseur Skorpius — 170 pts\nDésintégrateur Skorpius — 165 pts — Total : 1950 pts',
      ),
      RuleSection(
        heading: 'Aeldari — Hôte des Aspects',
        body:
            'Quatre Seigneurs Phénix mènent chacun leur guerrier d\'Aspect dans une frappe rapide et chirurgicale visant les points faibles de l\'ennemi.\n\nAsurmen — 125 pts\nFuegan — 120 pts\nJain Zar — 105 pts\nMaugan Ra — 100 pts\n2 × Faucheurs Noirs — 180 pts\n2 × Dragons Flamboyants — 240 pts\n2 × Banshees Huantes — 190 pts\n2 × Scorpions Foudroyants — 170 pts\n2 × Gardiens Défenseurs — 200 pts\n2 × Éperviers Voltigeurs — 170 pts\n2 × Lances Étincelantes — 220 pts — Total : 1820 pts',
      ),
      RuleSection(
        heading: 'Aeldari — Muraille Spectrale',
        body:
            'Un noyau de constructions Fantômes (Seigneur, Chevalier, Guerriers et Gardes Fantômes) avance lentement, invulnérable, soutenu par les pouvoirs psychiques d\'Eldrad Ulthran.\n\nSeigneur Fantôme — 140 pts\nChevalier Fantôme — 435 pts\n2 × Guerriers Fantômes — 320 pts\n2 × Gardes Fantômes — 340 pts\nEldrad Ulthran — 110 pts\n2 × Gardiens De Choc — 200 pts\nPsycharque — 70 pts\n2 × Marcheurs De Guerre — 170 pts\n2 × Vypers — 130 pts — Total : 1915 pts',
      ),
      RuleSection(
        heading: 'Aeldari — Escadre Corsaire',
        body:
            'Une flotte légère de Faucons, Prismes de Feu et Tisseurs de Nuit fond sur l\'ennemi en piqué et dépose Gardiens et Rangers sur les objectifs, un axe de raid mécanisé distinct de l\'alpha strike des Aspects et du mur de Fantômes.\n\nAutarque Sautevoie — 80 pts\nBaharroth — 115 pts\n2 × Gardiens Défenseurs — 200 pts\n2 × Vypers — 130 pts\n2 × Faucon — 260 pts\n2 × Prisme De Feu — 300 pts\n2 × Tisseur De Nuit — 380 pts\n2 × Serpent Ondoyant — 250 pts\n2 × Rangers — 110 pts\nPsycharque Coureur Céleste — 80 pts — Total : 1905 pts',
      ),
      RuleSection(
        heading: 'Agents de l\'Imperium — Temple des Assassins',
        body:
            'Les quatre types d\'Assassins de la Temple Assassinorum, doublés pour la redondance, frappent en profondeur pendant qu\'un léger cordon de suite tient les objectifs.\n\n2 × Assassin Vindicare — 220 pts\n2 × Assassin Culexus — 170 pts\n2 × Assassin Eversor — 220 pts\n2 × Assassin Callidus — 200 pts\nInquisiteur Coteaz — 75 pts\n4 × Cosmomarins En Armes — 200 pts\n2 × Escouade Vigilant — 170 pts\n2 × Escouade Subductor — 170 pts\n2 × Escouade D’Exaction — 180 pts\n2 × Sapeurs De La Marine Impériale — 180 pts\nInquisiteur — 55 pts — Total : 1840 pts',
      ),
      RuleSection(
        heading: 'Agents de l\'Imperium — Cellule d\'Inquisition',
        body:
            'Un état-major d\'Inquisiteurs (Draxus, Greyfax, Coteaz) dirige un vaste réseau de suites impériales, avec un soutien ponctuel d\'Assassins pour les cibles prioritaires.\n\nDame Inquisitrice Kyria Draxus — 75 pts\nInquisitrice Greyfax — 65 pts\nInquisiteur Coteaz — 75 pts\n2 × Inquisiteur — 110 pts\n3 × Escouade Vigilant — 255 pts\n6 × Cosmomarins En Armes — 300 pts\n3 × Escouade D’Exaction — 270 pts\n3 × Escouade Subductor — 255 pts\n3 × Sapeurs De La Marine Impériale — 270 pts\nAssassin Culexus — 85 pts\nAssassin Callidus — 100 pts — Total : 1860 pts',
      ),
      RuleSection(
        heading: 'Agents de l\'Imperium — Réseau d\'Opérations',
        body:
            'Un vaste réseau de suites de la Marine Impériale (Cosmomarins, Vigilants, Sapeurs, Subductors, Exaction) noyaute tous les objectifs, appuyé par un seul Assassin Vindicare pour les cibles prioritaires — un axe de nombre distinct des listes centrées sur les Assassins ou sur les Inquisiteurs.\n\nInquisiteur — 55 pts\nDame Inquisitrice Kyria Draxus — 75 pts\nAssassin Vindicare — 110 pts\n6 × Cosmomarins En Armes — 300 pts\n4 × Escouade Vigilant — 340 pts\n4 × Sapeurs De La Marine Impériale — 360 pts\n4 × Escouade Subductor — 340 pts\n4 × Escouade D’Exaction — 360 pts — Total : 1940 pts',
      ),
      RuleSection(
        heading: 'Astra Militarum — Colonne Blindée',
        body:
            'Une escorte d\'infanterie minimale protège un mur de chars Leman Russ et un Baneblade qui encaissent et pulvérisent tout ce qui bouge.\n\nSeigneur Solaire Leontus — 130 pts\nTroupes De Choc Cadiennes — 65 pts\nChar De Combat Rogal Dorn — 250 pts\n2 × Char De Combat Leman Russ — 370 pts\nLeman Russ Demolisher — 190 pts\n2 × Basilisk — 280 pts\nHellhound — 125 pts\nChimera — 85 pts\nBaneblade — 450 pts — Total : 1945 pts',
      ),
      RuleSection(
        heading: 'Astra Militarum — Marée Humaine',
        body:
            'Des dizaines de fantassins bon marché, encadrés d\'officiers et de commissaires, submergent l\'adversaire par le nombre pur.\n\nUrsula Creed — 85 pts\nCastellan Cadien — 55 pts\nCommissaire — 30 pts\nPrêcheur Régimentaire — 35 pts\nPsyker Primaris — 60 pts\n6 × Troupes De Choc Cadiennes — 390 pts\n5 × Death Korps De Krieg — 325 pts\n2 × Combattants Des Jungles De Catachan — 130 pts\nFantômes De Gaunt — 100 pts\nKasrkin — 110 pts\nSnipers Ratlings — 60 pts\nCavaliers D’Attila — 60 pts\n2 × Escouade D’Ogryns — 120 pts\nEscouade De Taurogryns — 100 pts\nNork Deddog — 60 pts\nGarde Du Corps Ogryn — 40 pts\nBatterie D’Artillerie — 95 pts — Total : 1855 pts',
      ),
      RuleSection(
        heading: 'Astra Militarum — Parc d\'Artillerie',
        body:
            'Une batterie statique de tubes lourds (Basilisk, Manticore, Wyvern, Deathstrike, Hydra) qui pilonne l\'ennemi à distance derrière un maigre écran d\'infanterie.\n\nCastellan Cadien — 55 pts\n2 × Troupes De Choc Cadiennes — 130 pts\n3 × Basilisk — 420 pts\n2 × Manticore — 330 pts\n2 × Wyvern — 220 pts\nDeathstrike — 145 pts\n2 × Hydra — 190 pts\n2 × Batterie D’Artillerie — 190 pts\nChimera — 85 pts\nSentinel De Reconnaissance — 55 pts\nTechnaugure Régimentaire — 45 pts\nPrêcheur Régimentaire — 35 pts — Total : 1900 pts',
      ),
      RuleSection(
        heading: 'Black Templars — Poing Blindé',
        body:
            'Gladiators, Repulsors et Land Raider avancent en formation pour écraser l\'ennemi sous un déluge de tirs mécanisés.\n\nCapitaine En Armure Gravis — 80 pts\nMaréchal — 80 pts\nEscouade Intercessor — 80 pts\n2 × Gladiator Lancer — 320 pts\nGladiator Reaper — 160 pts\nGladiator Valiant — 150 pts\nRepulsor — 180 pts\nRepulsor Executioner — 220 pts\n2 × Impulsor — 160 pts\nLand Raider Crusader — 220 pts\nDreadnought Redemptor — 195 pts — Total : 1845 pts',
      ),
      RuleSection(
        heading: 'Black Templars — Croisade Vengeresse',
        body:
            'Le Sénéchal, le Champion de l\'Empereur et des escouades Terminator embarquées en Land Raider foncent au corps-à-corps dès le premier tour.\n\nGrand Sénéchal Helbrecht — 120 pts\nLe Champion De L’Empereur — 90 pts\nChapelain Grimaldus — 110 pts\nChapelain En Armure Terminator — 75 pts\n2 × Frères D’Épée Primaris — 210 pts\nEscouade D’Assaut Terminator — 180 pts\nEscouade Terminator — 170 pts\nEscouade D’Assaut Intercessor — 75 pts\nLand Raider Crusader — 220 pts\nLand Raider Redeemer — 270 pts\nEscouade De Vétérans Bladeguards — 80 pts\nDreadnought Brutalis — 160 pts\nEscouade Infernus — 90 pts\nTechmarine — 55 pts — Total : 1905 pts',
      ),
      RuleSection(
        heading: 'Black Templars — Rempart d\'Acier',
        body:
            'Une croisade entièrement à pied, un mur d\'escouades Intercessor et Tactique appuyé par des armes lourdes, sans un seul véhicule.\n\nMaréchal — 80 pts\nChapelain — 60 pts\n4 × Escouade Intercessor — 320 pts\n2 × Escouade D’Assaut Intercessor — 150 pts\n2 × Escouade Lourde Intercessor — 200 pts\n2 × Escouade Tactique — 280 pts\n2 × Frères D’Épée Primaris — 210 pts\nApothicaire Primaris — 50 pts\nDoyen Primaris — 50 pts\n2 × Escouade Hellblaster — 220 pts\nEscouade Devastator — 120 pts\nEscouade De Vétérans Sternguards — 100 pts\nTechmarine — 55 pts — Total : 1895 pts',
      ),
      RuleSection(
        heading: 'Blood Angels — Charge Écarlate',
        body:
            'La Compagnie de la Mort et la Garde Sanguinaire, portées par le Sanguinor et Astorath, plongent en avant pour un assaut au corps-à-corps dès le tour 1.\n\nCommandeur Dante — 120 pts\nLemartes — 100 pts\nPrêtre Sanguinien — 75 pts\n4 × Death Company Marines — 340 pts\n3 × Marines De La Compagnie De La Mort À Réacteurs Dorsaux — 360 pts\n2 × Sanguinary Guard — 250 pts\nLe Sanguinor — 140 pts\nAstorath — 95 pts\nEscouade D’Assaut Intercessor — 75 pts\nDreadnought De La Compagnie De La Mort — 160 pts\nIntercessors De La Compagnie De La Mort — 85 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Blood Angels — Colonne Blindée du Sang',
        body:
            'Predator Baal et Land Raiders avancent en escadron mécanisé pendant que Méphiston appuie la percée de ses pouvoirs psychiques.\n\nCaptain — 80 pts\nMaître Archiviste Méphiston — 120 pts\nEscouade Intercessor — 80 pts\n3 × Predator Baal — 375 pts\n2 × Rhino — 150 pts\nRazorback — 95 pts\nLand Raider Crusader — 220 pts\nLand Raider Redeemer — 270 pts\nVindicator — 185 pts\nDreadnought — 135 pts\nWhirlwind — 190 pts — Total : 1900 pts',
      ),
      RuleSection(
        heading: 'Blood Angels — Rempart Sanguinaire',
        body:
            'Une gunline statique de Devastators et de Whirlwinds qui tient le fond de table et arrose l\'ennemi à distance plutôt que de charger.\n\nCaptain — 80 pts\nLieutenant — 65 pts\n2 × Escouade Tactique — 280 pts\n2 × Escouade Intercessor — 160 pts\n3 × Escouade Devastator — 360 pts\n2 × Whirlwind — 380 pts\nPredator Destructor — 140 pts\nPrêtre Sanguinien — 75 pts\nEscouade Eradicator — 100 pts\nTechmarine — 55 pts\nEscouade Hellblaster — 110 pts\nApothicaire Primaris — 50 pts\nEscouade De Scouts — 70 pts — Total : 1925 pts',
      ),
      RuleSection(
        heading: 'Chaos Daemons — Horde de Khorne',
        body:
            'Une masse de Sanguinaires et de Molosses, précédée par de grands démons du Sang, fonce au corps-à-corps sans jamais s\'arrêter.\n\nMaître Du Sang — 65 pts\nMaître Des Crânes — 100 pts\nKaranak — 75 pts\n4 × Sanguinaires — 440 pts\n3 × Molosses De Khorne — 225 pts\n2 × Canon À Crânes — 190 pts\nMutileur Sur Trône De Sang — 165 pts\nBuveur De Sang — 305 pts\nSkarbrand — 305 pts — Total : 1870 pts',
      ),
      RuleSection(
        heading: 'Chaos Daemons — Panthéon des Grands Démons',
        body:
            'Be\'lakor et les Grands Démons des quatre Dieux Sombres forment une deathstar de monstres, soutenue par de petites lignes démoniaques jetables.\n\nBe’Lakor — 375 pts\nGrand Immonde — 250 pts\nDuc Du Changement — 260 pts\nGardien Des Secrets — 270 pts\nKairos Fateweaver — 270 pts\nPrince Démon Du Chaos — 180 pts\nHorreurs Bleues — 125 pts\nDémonettes — 100 pts\nNurglings — 40 pts\nEpidemius — 80 pts — Total : 1950 pts',
      ),
      RuleSection(
        heading: 'Chaos Daemons — Peste Rampante',
        body:
            'Une horde de Nurgle qui noie la table sous les Portepestes, les Nurglings et les Bêtes de Nurgle, soutenue par le Grand Immonde et des Bourdons de la Peste volants.\n\nGrand Immonde — 250 pts\nPorte-vérole — 55 pts\nEpidemius — 80 pts\n6 × Portepestes — 660 pts\n4 × Nurglings — 160 pts\n4 × Bêtes De Nurgle — 260 pts\n3 × Bourdons De La Peste — 330 pts\nHorticulous Slimux — 120 pts — Total : 1915 pts',
      ),
      RuleSection(
        heading: 'Chaos Knights — Meute de Dogues',
        body:
            'Une nuée de petits Chevaliers Dogues rapides et nombreux quadrille le champ de bataille pour saturer les objectifs, épaulée par un unique titan lourd.\n\nDogue Rabatteur — 140 pts\n4 × Dogue Exécuteur — 520 pts\n2 × Dogue Karnivore — 300 pts\n2 × Dogue Brigand — 280 pts\n2 × Dogue Chasseur — 280 pts\nChevalier Abominable — 355 pts — Total : 1875 pts',
      ),
      RuleSection(
        heading: 'Chaos Knights — Cohorte de Titans',
        body:
            'Une poignée de Chevaliers Titanesques massifs, à peine accompagnés de deux Dogues pour tenir les lignes, écrase tout sur son passage à coups de canons lourds.\n\nChevalier Pillard — 375 pts\nChevalier Profanateur — 365 pts\nChevalier Saccageur — 365 pts\nChevalier Abominable — 355 pts\n2 × Dogue Exécuteur — 260 pts\nDogue Rabatteur — 140 pts — Total : 1860 pts',
      ),
      RuleSection(
        heading: 'Chaos Knights — Maison Mixte',
        body:
            'Une escouade de guerre équilibrée mêlant à parts égales petits Dogues rapides et grands Chevaliers imposants, sans excès dans un sens ou l\'autre.\n\nDogue Rabatteur — 140 pts\n2 × Dogue Exécuteur — 260 pts\nDogue Karnivore — 150 pts\nDogue Brigand — 140 pts\nDogue Chasseur — 140 pts\nChevalier Pillard — 375 pts\nChevalier Profanateur — 365 pts\nChevalier Abominable — 355 pts — Total : 1925 pts',
      ),
      RuleSection(
        heading: 'Chaos Space Marines — Horde de Renégats',
        body:
            'Une marée de cultistes et de légionnaires bon marché, portée par des porte-voix qui les jettent au combat en masse.\n\n4 × Bande De Cultistes — 200 pts\n2 × Escouade De Gardes Renégats — 140 pts\n2 × Hommes-bêtes Affregors — 140 pts\n4 × Légionnaires — 360 pts\n3 × Cultistes Maudits — 270 pts\n2 × Apôtre Noir — 130 pts\nSeigneur Du Chaos — 90 pts\nMaître Des Exécutions — 80 pts\nHuron Blackheart — 80 pts\nObliterators — 160 pts\nÉlus — 125 pts\n2 × Motards Du Chaos — 140 pts — Total : 1915 pts',
      ),
      RuleSection(
        heading: 'Chaos Space Marines — Colonne Blindée du Chaos',
        body:
            'Une colonne de chars et d\'engins démoniaques qui écrase l\'ennemi sous un déluge de blindage, menée depuis un Métarôdeur.\n\nSeigneur De La Discorde Sur Métarôdeur — 160 pts\nLand Raider Du Chaos — 220 pts\n2 × Predator Annihilator Du Chaos — 270 pts\nPredator Destructor Du Chaos — 140 pts\nVindicator Du Chaos — 185 pts\nProfanateur — 190 pts\nMétabrutus — 130 pts\n2 × Rhino Du Chaos — 150 pts\n2 × Légionnaires — 180 pts\nMétaragne — 205 pts — Total : 1830 pts',
      ),
      RuleSection(
        heading: 'Chaos Space Marines — Nuée Ailée du Chaos',
        body:
            'Rapaces, Serres du Warp, motards et rejetons montés déferlent en éclaireurs rapides pour contourner l\'ennemi par les flancs sans jamais s\'arrêter, sans aucun blindage lourd.\n\nHaarken Worldclaimer — 90 pts\nHuron Blackheart — 80 pts\nTechmancien — 70 pts\n2 × Légionnaires — 180 pts\n4 × Rapaces — 360 pts\n4 × Serres Du Warp — 500 pts\n5 × Motards Du Chaos — 350 pts\n3 × Rejetons Du Chaos — 210 pts — Total : 1840 pts',
      ),
      RuleSection(
        heading: 'Dark Angels — Deathwing - Deathstar Terminator',
        body:
            'Un noyau de Terminators de la Deathwing débarqués par des Land Raiders, conçu pour percer n\'importe quelle ligne ennemie au corps-à-corps comme à distance.\n\nAzraël — 115 pts\nBélial — 85 pts\nAsmodaï — 70 pts\n4 × Escouade Terminator De La Deathwing — 720 pts\nArchiviste En Armure Terminator — 75 pts\n2 × Land Raider Crusader — 440 pts\nLand Raider Redeemer — 270 pts\nEscouade Intercessor — 80 pts — Total : 1855 pts',
      ),
      RuleSection(
        heading: 'Dark Angels — Ravenwing - Frappe Éclair Blindée',
        body:
            'Une colonne rapide de motos et de véhicules légers de la Ravenwing qui frappe vite, contourne les lignes et se disperse avant la riposte.\n\nSammaël — 115 pts\nLazarus — 70 pts\nCapitaine À Réacteur Dorsal — 75 pts\n2 × Darkshroud De La Ravenwing — 200 pts\n2 × Land Speeder Vengeance De La Ravenwing — 240 pts\n5 × Escouade Outrider — 400 pts\n3 × Escouade D’Assaut Intercessor — 225 pts\nStorm Speeder Hammerstrike — 125 pts\nStorm Speeder Thunderstrike — 150 pts\n2 × Quad Invader — 120 pts\n2 × Escouade Suppressor — 150 pts — Total : 1870 pts',
      ),
      RuleSection(
        heading: 'Dark Angels — Croisade des Unforgiven',
        body:
            'Une force combinée classique de Chapitre, Intercessors et Devastators appuyés par des Gladiators et un Dreadnought Redemptor, sans spécialisation Deathwing ni Ravenwing.\n\nCapitaine — 80 pts\nLieutenant — 65 pts\nÉzékiel — 75 pts\n3 × Escouade Intercessor — 240 pts\nEscouade Tactique — 140 pts\n2 × Escouade Devastator — 240 pts\nGladiator Lancer — 160 pts\nGladiator Reaper — 160 pts\nGladiator Valiant — 150 pts\nDreadnought Redemptor — 195 pts\n2 × Razorback — 190 pts\nEscouade Hellblaster — 110 pts — Total : 1805 pts',
      ),
      RuleSection(
        heading: 'Death Guard — Colonne Blindée Putride',
        body:
            'Des Rhinos et Predators rouillés escortent un Land Raider et des drones pourrisseurs pour une avancée mécanisée lente mais increvable.\n\nSeigneur De La Contagion — 120 pts\nPorte-icône De La Death Guard — 45 pts\n3 × Marines De La Peste — 285 pts\n3 × Rhino De La Death Guard — 255 pts\nLand Raider De La Death Guard — 240 pts\n2 × Predator Annihilator De La Death Guard — 270 pts\nPredator Destructor De La Death Guard — 145 pts\nProfanateur De La Death Guard — 165 pts\n2 × Semi-chenillés Méphitiques — 200 pts\nDrone Fétide — 100 pts — Total : 1825 pts',
      ),
      RuleSection(
        heading: 'Death Guard — Deathstar Démoniaque de Mortarion',
        body:
            'Mortarion en personne ouvre la voie à des Terminators corrompus et un Prince Démon ailé, une liste d\'élite pensée pour un assaut dévastateur.\n\nMortarion — 380 pts\nTyphus — 100 pts\nSeigneur De La Virulence — 100 pts\nSeigneur De La Contagion — 120 pts\n3 × Terminators Rouillarques — 345 pts\n2 × Terminators Du Linceul — 320 pts\n2 × Marines De La Peste — 190 pts\nCorrupteur Nidoreux — 50 pts\nPrince Démon De La Death Guard Ailé — 195 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Death Guard — Marée Pourrissante à Pied',
        body:
            'Des vagues de Marines de la Peste sans aucun véhicule, épaulées par des essaims putrides et des soutiens médicaux, avancent lentement et increvablement au contact.\n\nSeigneur De La Virulence — 100 pts\nSeigneur De La Contagion — 120 pts\nIntendant — 50 pts\nChirurgien De La Peste — 50 pts\nBiologus Putréfacteur — 60 pts\nPorte-icône De La Death Guard — 45 pts\n10 × Marines De La Peste — 950 pts\n4 × Essaimeur Répugnant — 300 pts\n3 × Corrupteur Nidoreux — 150 pts — Total : 1825 pts',
      ),
      RuleSection(
        heading: 'Deathwatch — Kill Teams Interarmes',
        body:
            'Plusieurs Kill Teams spécialisées, chacune taillée pour une mission différente, coordonnées par un Maître du Guet.\n\nMaître Du Guet — 95 pts\nCapitaine Du Guet Artemis — 65 pts\nCapitaine En Armure Terminator — 95 pts\n2 × Kill Team Fortis — 360 pts\nKill Team Indomitor — 250 pts\nKill Team Spectrus — 180 pts\n3 × Vétérans Deathwatch — 300 pts\n2 × Escouade Terminator Deathwatch — 380 pts\nEscouade Intercessor — 80 pts — Total : 1805 pts',
      ),
      RuleSection(
        heading: 'Deathwatch — Frappe Téléportée Terminator',
        body:
            'Une masse de Terminators Deathwatch et alliés qui se téléporte au cœur de la bataille pour un choc frontal immédiat.\n\nMaître Du Guet — 95 pts\nCapitaine Du Guet Artemis — 65 pts\nCapitaine En Armure Terminator — 95 pts\nArchiviste En Armure Terminator — 75 pts\n4 × Escouade Terminator Deathwatch — 760 pts\nEscouade D’Assaut Terminator — 180 pts\nKill Team Indomitor — 250 pts\n2 × Vétérans Deathwatch — 200 pts\nEscouade Intercessor — 80 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Deathwatch — Colonne Blindée des Veilleurs',
        body:
            'Des Vétérans Deathwatch et Intercessors embarqués en Razorbacks et Impulsors avancent en formation mécanisée derrière un Repulsor Executioner, sans Terminators ni Kill Teams spéciales.\n\nMaître Du Guet — 95 pts\nCapitaine En Armure Gravis — 80 pts\nLieutenant — 65 pts\n2 × Escouade Intercessor — 160 pts\n4 × Vétérans Deathwatch — 400 pts\n4 × Razorback — 380 pts\n3 × Impulsor — 240 pts\nRepulsor Executioner — 220 pts\n3 × Rhino — 225 pts — Total : 1865 pts',
      ),
      RuleSection(
        heading: 'Drukhari — Raid Kabalite Éclair',
        body:
            'Guerriers Kabalites et Ravageurs embarqués en Venoms pour frapper vite au poison, prendre les objectifs et se replier avant la contre-attaque.\n\nArchonte — 80 pts\nDrazhar — 85 pts\n4 × Guerriers Kabalites — 460 pts\n4 × Venom — 280 pts\n3 × Ravageur — 345 pts\n2 × Hellions — 170 pts\n2 × Écumeurs — 140 pts\n2 × Cour De L’Archonte — 250 pts — Total : 1810 pts',
      ),
      RuleSection(
        heading: 'Drukhari — Coven de la Souffrance',
        body:
            'Talos et Cronos des Coteries d\'Hémoncules encadrent des tueuses d\'élite pour une attrition au corps-à-corps que rien n\'arrête.\n\nLelith Hesperax — 85 pts\nDrazhar — 85 pts\nArchonte — 80 pts\n4 × Talos — 320 pts\n4 × Cronos — 220 pts\n3 × Guerriers Kabalites — 345 pts\n2 × Venom — 140 pts\nRavageur — 115 pts\n2 × Hellions — 170 pts\n2 × Cour De L’Archonte — 250 pts — Total : 1810 pts',
      ),
      RuleSection(
        heading: 'Drukhari — Culte Wych — Charge Sauvage',
        body:
            'Une horde d\'infanterie de mêlée pure, sans Venoms ni engins des Covens, où Hellions, Écumeurs et championnes d\'élite submergent l\'ennemi au corps-à-corps dès l\'engagement.\n\nArchonte — 80 pts\nDrazhar — 85 pts\nLelith Hesperax — 85 pts\n5 × Hellions — 425 pts\n4 × Écumeurs — 280 pts\n3 × Guerriers Kabalites — 345 pts\n4 × Cour De L’Archonte — 500 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Genestealer Cults — Nuée du Culte',
        body:
            'Une horde d\'infiltrés et de mutants qui submerge l\'adversaire par le nombre avant qu\'il ne comprenne d\'où vient l\'attaque.\n\n5 × Hybrides Néophytes — 325 pts\n4 × Genestealers Pure-souche — 300 pts\n3 × Aberrants — 405 pts\n2 × Hybrides Métamorphes — 140 pts\nAbominant — 85 pts\nPatriarche — 75 pts\nMagus — 50 pts\nPrimus — 70 pts\nNexos — 60 pts\nKelermorphe — 60 pts\nLocus — 45 pts\nAcolyte Garde-icône — 50 pts\nSanctus — 50 pts\nClamavus — 50 pts\nSaboteur Reductus — 65 pts\nBiophagus — 50 pts — Total : 1880 pts',
      ),
      RuleSection(
        heading: 'Genestealer Cults — Blitz Mécanisé',
        body:
            'Un raid rapide sur roues et chenilles, où camions et tout-terrains déposent les cultistes au contact avant que la ligne adverse ne réagisse.\n\n4 × Tout-terrain Achilles — 380 pts\n3 × Concasseur Goliath — 360 pts\n3 × Camion Goliath — 255 pts\n4 × Chacals Atalans — 340 pts\n2 × Alphus Chacal — 110 pts\n2 × Hybrides Néophytes — 130 pts\nPrimus — 70 pts\nMagus — 50 pts\nKelermorphe — 60 pts\nSanctus — 50 pts — Total : 1805 pts',
      ),
      RuleSection(
        heading: 'Genestealer Cults — Insurrection Souterraine',
        body:
            'Une vague de créatures corps-à-corps pures (Aberrants et Genestealers Pure-Souche) menée par le Patriarche et son cercle de personnages spéciaux, sans aucun véhicule.\n\nPatriarche — 75 pts\nMagus — 50 pts\nAbominant — 85 pts\n6 × Aberrants — 810 pts\n6 × Genestealers Pure-souche — 450 pts\n2 × Hybrides Néophytes — 130 pts\nSanctus — 50 pts\nLocus — 45 pts\nPrimus — 70 pts\nKelermorphe — 60 pts\nNexos — 60 pts — Total : 1885 pts',
      ),
      RuleSection(
        heading: 'Grey Knights — Frappe Téléportée',
        body:
            'Toute l\'armée arrive par téléportation en une seule vague pour écraser un point de la table dès le premier tour.\n\n2 × Escouade Terminator De Confrérie — 320 pts\n2 × Escouade Paladin — 360 pts\n2 × Escouade Purificator — 250 pts\n2 × Escouade Interceptor — 260 pts\n2 × Escouade Purgator — 250 pts\nGrand Maître Voldus — 110 pts\nGrand Maître — 95 pts\nFrère-capitaine — 90 pts\nChapelain De Confrérie — 65 pts — Total : 1800 pts',
      ),
      RuleSection(
        heading: 'Grey Knights — Colonne Blindée',
        body:
            'Land Raiders et Dreadknights avancent en formation compacte, blindage lourd en tête pour percer n\'importe quelle ligne.\n\nLand Raider Des Grey Knights — 220 pts\nLand Raider Crusader Des Grey Knights — 220 pts\nLand Raider Redeemer Des Grey Knights — 270 pts\n2 × Cuirassier Némésis — 420 pts\nGrand Maître En Cuirasse Némésis — 225 pts\nDreadnought Vénérable Des Grey Knights — 140 pts\nRazorback Des Grey Knights — 85 pts\nRhino Des Grey Knights — 80 pts\nEscouade Terminator De Confrérie — 160 pts — Total : 1820 pts',
      ),
      RuleSection(
        heading: 'Grey Knights — Ligne Psychique à Pied',
        body:
            'Une gunline d\'infanterie Psyker pure (Purgators, Purifiers, Interceptors) épaulée par des personnages de soutien, sans Terminators déployés en profondeur ni colonne blindée.\n\nGrand Maître Voldus — 110 pts\n2 × Archiviste De Confrérie — 160 pts\nChapelain De Confrérie — 65 pts\nTechmarine De Confrérie — 70 pts\nChampion De Confrérie — 70 pts\nEscouade Terminator De Confrérie — 160 pts\n4 × Escouade Purgator — 500 pts\n4 × Escouade Purificator — 500 pts\n2 × Escouade Interceptor — 260 pts — Total : 1895 pts',
      ),
      RuleSection(
        heading: 'Imperial Knights — Cohorte Armigère',
        body:
            'Une meute de chevaliers légers et rapides qui submerge le flanc adverse par le nombre plutôt que par la puissance de feu brute.\n\n4 × Armigères Helvériens — 560 pts\n4 × Armigères Hastaires — 560 pts\nChevalier Errant — 375 pts\nChevalier Castellan — 410 pts — Total : 1905 pts',
      ),
      RuleSection(
        heading: 'Imperial Knights — Marche des Titans',
        body:
            'Une poignée de chevaliers lourds et quadri-armés qui avancent lentement mais rasent tout ce qui se trouve sur leur passage.\n\nChevalier Castellan — 410 pts\nCanis Rex — 415 pts\nChevalier Croisé — 395 pts\nChevalier Vigilant — 385 pts\n2 × Armigères Helvériens — 280 pts — Total : 1885 pts',
      ),
      RuleSection(
        heading: 'Imperial Knights — Cohorte Équilibrée',
        body:
            'Un mélange de gros châssis (Castellan, Errant, Paladin) et d\'Armigères des deux types, ni tout léger ni tout lourd, pour une force polyvalente.\n\nChevalier Castellan — 410 pts\nChevalier Errant — 375 pts\nChevalier Paladin — 375 pts\n3 × Armigères Helvériens — 420 pts\n2 × Armigères Hastaires — 280 pts — Total : 1860 pts',
      ),
      RuleSection(
        heading: 'Leagues of Votann — Poing Blindé',
        body:
            'Forteresses mobiles et transports blindés amènent guerriers et walkers Tonnekogs directement au contact, protégés par du blindage épais.\n\n3 × Forteresse Mobile Hekaton — 720 pts\n3 × Sagitaur — 285 pts\n3 × Tonnekogs Brokhyrs — 240 pts\n2 × Guerriers Âtrekogs — 200 pts\nKâhl — 70 pts\nChampion Einhyr — 70 pts\nÛthar Le Destiné — 95 pts\n2 × Pionniers Hernkogs — 160 pts — Total : 1840 pts',
      ),
      RuleSection(
        heading: 'Leagues of Votann — Infanterie Lourde des Loges',
        body:
            'Une masse de guerriers en armure lourde et d\'Einhyrs d\'élite qui tient le terrain et gagne les combats d\'usure.\n\n4 × Guerriers Âtrekogs — 400 pts\n4 × Âtregardes Einhyrs — 540 pts\n3 × Beserks Cthoniens — 300 pts\n3 × Grimnyr — 195 pts\n2 × Pionniers Hernkogs — 160 pts\nÛthar Le Destiné — 95 pts\nKâhl — 70 pts\nChampion Einhyr — 70 pts — Total : 1830 pts',
      ),
      RuleSection(
        heading: 'Leagues of Votann — Colonne de Reconnaissance Âtrekog',
        body:
            'Une force mobile et légère bâtie autour des Pionniers Hernkogs et des Sagitaurs, appuyée par de l\'infanterie de choc, plutôt que sur les forteresses Hekaton ou l\'infanterie lourde statique.\n\nKâhl — 70 pts\nChampion Einhyr — 70 pts\nGrimnyr — 65 pts\n4 × Pionniers Hernkogs — 320 pts\n4 × Sagitaur — 380 pts\n3 × Guerriers Âtrekogs — 300 pts\n3 × Beserks Cthoniens — 300 pts\n3 × Tonnekogs Brokhyrs — 240 pts\nÂtregardes Einhyrs — 135 pts\nÛthar Le Destiné — 95 pts — Total : 1975 pts',
      ),
      RuleSection(
        heading: 'Necrons — Marée Nécrontyr',
        body:
            'Des rangs de guerriers et immortels qui se relèvent sans cesse, appuyés par des cryptecs et un Monolithe pour une gunline increvable.\n\n5 × Guerriers Nécrons — 450 pts\n3 × Immortels — 210 pts\n2 × Réanimateur Canoptek — 150 pts\nTechnomancien — 80 pts\nChronomancien — 65 pts\nPlasmancien — 55 pts\nImotekh Le Seigneur Des Tempêtes — 100 pts\nMonolithe — 400 pts\n2 × Cryptoserfs — 120 pts\nRôdeur Du Triarcat — 110 pts\nConsole D’Annihilation — 105 pts — Total : 1845 pts',
      ),
      RuleSection(
        heading: 'Necrons — Culte des Destroyers',
        body:
            'Des essaims de Destroyers volants frappent vite et loin derrière les lignes ennemies, soutenus par un éclat de C’tan.\n\n3 × Destroyers Skorpekhs — 270 pts\n3 × Destroyers Ophydiens — 240 pts\n2 × Prétoriens Du Triarcat — 180 pts\n4 × Destroyers Lourds Lokhusts — 220 pts\n4 × Destroyers Lokhusts — 160 pts\nSeigneur Skorpekh — 90 pts\nSeigneur Lokhust — 80 pts\nÉcharde C’Tan Du Dragon Du Néant — 300 pts\n2 × Immortels — 140 pts\nDestroyer Hexmark — 75 pts\nCryptoserfs — 60 pts — Total : 1815 pts',
      ),
      RuleSection(
        heading: 'Necrons — Convergence Canoptek et Éclats du Triarcat',
        body:
            'Une force de constructs élite centrée sur deux Éclats C\'tan et les machines du Triarcat (Rôdeurs, Prétoriens, Réanimateurs Canoptek), à l\'opposé de la gunline Warriors/Monolithe et du culte des Destroyers rapides.\n\nÉcharde C’Tan Du Nyctophore — 305 pts\nÉcharde C’Tan Du Dragon Du Néant — 300 pts\n3 × Rôdeur Du Triarcat — 330 pts\n3 × Prétoriens Du Triarcat — 270 pts\n3 × Réanimateur Canoptek — 225 pts\nConsole D’Annihilation — 105 pts\n2 × Guerriers Nécrons — 180 pts\nTechnomancien — 80 pts\nChronomancien — 65 pts — Total : 1860 pts',
      ),
      RuleSection(
        heading: 'Orks — Marée Verte',
        body:
            'Une horde tout-terrain de Boyz, Gretchins et Nobz qui submerge l\'adversaire par le nombre et l\'usure, portée par Ghazghkull Thraka.\n\n4 × Boyz — 320 pts\n4 × Gretchins — 160 pts\n4 × Nobz — 420 pts\n3 × Kommandos — 360 pts\n2 × Méganobz — 130 pts\nGhazghkull Thraka — 235 pts\nBoss Snikrot — 75 pts\nMek — 45 pts\nZodgrod Wortsnagga — 90 pts — Total : 1835 pts',
      ),
      RuleSection(
        heading: 'Orks — Waaagh! Mécanisée',
        body:
            'Une colonne de marcheurs et véhicules kustom (Gorkanautes, Morkanaute) qui écrase l\'ennemi sous le blindage et la puissance de feu, escortée par Mozrog Skragbad.\n\n3 × Gorkanaute — 795 pts\nMorkanaute — 280 pts\n2 × Boosta-klata Kustom — 140 pts\n2 × Dragsta Shokk — 140 pts\nMozrog Skragbad — 145 pts\nGros Mek En Méga-armure — 90 pts\nGros Mek Avec Kanon Shokk — 80 pts\nMek — 45 pts\n2 × Boyz — 160 pts — Total : 1875 pts',
      ),
      RuleSection(
        heading: 'Orks — Kommandos de la Jungle',
        body:
            'Une force d\'infiltration légère de Kommandos, Nobz et véhicules kustom rapides qui frappe dans le dos de l\'ennemi sans les gros blindés ni la horde de Boyz.\n\nBoss Snikrot — 75 pts\nZodgrod Wortsnagga — 90 pts\n4 × Kommandos — 480 pts\n3 × Méganobz — 195 pts\n3 × Nobz — 315 pts\n3 × Gretchins — 120 pts\n4 × Boosta-klata Kustom — 280 pts\n3 × Dragsta Shokk — 210 pts\nMek — 45 pts — Total : 1810 pts',
      ),
      RuleSection(
        heading: 'Space Marines (Adeptus Astartes) — Colonne Blindée Gladiator',
        body:
            'Une percée blindée rapide construite autour des chars Gladiator et Predator, appuyée par des Intercessors en Impulsor pour prendre les objectifs.\n\nCapitaine En Armure Gravis — 80 pts\nTechmarine — 55 pts\n2 × Escouade Intercessor — 160 pts\n2 × Impulsor — 160 pts\nGladiator Lancer — 160 pts\n2 × Gladiator Reaper — 320 pts\nGladiator Valiant — 150 pts\n2 × Predator Annihilator — 270 pts\nRepulsor Executioner — 220 pts\nDreadnought Brutalis — 160 pts\nDreadnought — 135 pts — Total : 1870 pts',
      ),
      RuleSection(
        heading:
            'Space Marines (Adeptus Astartes) — Gunline Terminators & Devastators',
        body:
            'Une ligne statique de Terminators et d\'armes lourdes qui tient le terrain et pilonne l\'adversaire de loin, menée par Darnath Lysander.\n\nDarnath Lysander — 100 pts\nCapitaine En Armure Terminator — 95 pts\nChapelain En Armure Terminator — 75 pts\n2 × Escouade Intercessor — 160 pts\nEscouade Lourde Intercessor — 100 pts\n2 × Escouade Terminator — 340 pts\nEscouade D’Assaut Terminator — 180 pts\n2 × Escouade Devastator — 240 pts\nEscouade Eliminator — 85 pts\nEscouade Desolator — 200 pts\nEscouade Hellblaster — 110 pts\nWhirlwind — 190 pts — Total : 1875 pts',
      ),
      RuleSection(
        heading: 'Space Marines (Adeptus Astartes) — Le Marteau de l\'Empereur',
        body:
            'Une vague aéroportée d\'Aggressors, Inceptors et Suppressors qui plonge en profondeur derrière les lignes ennemies pour un choc immédiat, menée par Kayvaan Shrike.\n\nKayvaan Shrike — 100 pts\nChapelain À Réacteur Dorsal — 75 pts\n2 × Escouade D’Assaut Intercessor — 150 pts\n4 × Escouade Aggressor — 400 pts\n4 × Escouade Inceptor — 480 pts\n4 × Escouade Suppressor — 300 pts\n2 × Escouade De Vétérans Vanguards À Réacteurs Dorsaux — 190 pts\nEscouade De Vétérans Sternguards — 100 pts\nApothicaire Primaris — 50 pts — Total : 1845 pts',
      ),
      RuleSection(
        heading: 'Space Wolves — Meute Sauvage',
        body:
            'Un raid éclair de Loups Tonnerre, Wulfen et Griffes Sanglantes qui charge dès le premier tour derrière Ragnar Blackmane et Arjac Rockfist.\n\nRagnar Blackmane — 100 pts\nArjac Rockfist — 105 pts\nChef De Meute Garde Loup — 65 pts\n3 × Cavalerie Sur Loups Tonnerre — 345 pts\n3 × Wulfen — 255 pts\n2 × Loups Fenrissiens — 80 pts\n2 × Griffes Sanglantes — 270 pts\n2 × Terminators Gardes Loups — 340 pts\nDreadnought Wulfen — 145 pts\nMurderfang — 160 pts — Total : 1865 pts',
      ),
      RuleSection(
        heading: 'Space Wolves — Chasseurs Gris Mécanisés',
        body:
            'Une ligne de bataille solide de Chasseurs Gris et de Terminators Gardes Loups qui tient les objectifs et matraque à distance, autour de Logan Grimnar et Björn.\n\nLogan Grimnar — 110 pts\nBjörn Main Funeste — 170 pts\nPrêtre De Fer — 60 pts\n2 × Chasseurs Gris — 360 pts\nEscouade Lourde Intercessor — 100 pts\n2 × Terminators Gardes Loups — 340 pts\n2 × Gardes Loups — 170 pts\n2 × Escouade Devastator — 240 pts\nDreadnought Vénérable Des Space Wolves — 140 pts\nWhirlwind — 190 pts — Total : 1880 pts',
      ),
      RuleSection(
        heading: 'Space Wolves — Horde à Pied de Fenris',
        body:
            'Une marée d\'infanterie à pied (Griffes Sanglantes, Scouts et Gardes Loups) qui submerge le terrain par le nombre, sans cavalerie ni blindé, derrière Ulrik le Tueur.\n\nUlrik Le Tueur — 70 pts\nLieutenant — 65 pts\nChapelain — 60 pts\n4 × Griffes Sanglantes — 540 pts\n3 × Scouts Space Wolves — 315 pts\n2 × Escouade De Scouts — 140 pts\n4 × Gardes Loups — 340 pts\n3 × Loups Fenrissiens — 120 pts\n2 × Escouade Intercessor — 160 pts — Total : 1810 pts',
      ),
      RuleSection(
        heading: 'T\'au Empire — Firebase Statique',
        body:
            'Une ligne de tir immobile de Brécheurs, Broadsides et Riptide protégée par des fortifications Tidewall, avec le Stormsurge comme pièce maîtresse.\n\nÉthéré — 50 pts\nDarkstrider — 60 pts\nSabre De Feu — 50 pts\n3 × Équipe De Brécheurs — 300 pts\n3 × Exo-armures Broadside — 240 pts\n2 × Exo-armure Riptide — 380 pts\nStormsurge — 400 pts\nChar Sky Ray — 140 pts\nLigne-bouclier Tidewall — 85 pts\nTourelle Tidewall — 90 pts — Total : 1795 pts',
      ),
      RuleSection(
        heading: 'T\'au Empire — Raid Kroot & Skyfleet',
        body:
            'Une force mobile de tribus Kroot en éclaireurs et de véhicules volants (Piranhas, Hammerhead, Sun Shark) qui frappe vite et se disperse, menée par des commandants en exo-armure de saut.\n\nCommandante Shadowsun — 100 pts\nCommandant Farsight — 85 pts\nCommandant En Exo-armure Coldstar — 95 pts\nMentor Kroot — 45 pts\n3 × Carnivores Kroots — 195 pts\n3 × Chiens Kroots — 120 pts\n3 × Cavaliers Krootox — 120 pts\n2 × Exorôdeurs Kroots — 110 pts\nExo-armures Stealth — 110 pts\nExo-armure Ghostkeel — 160 pts\n2 × Frelons Vespides — 130 pts\n2 × Piranha — 120 pts\n2 × Char Hammerhead — 290 pts\nDevilfish — 85 pts\nBombardier Sun Shark — 160 pts — Total : 1925 pts',
      ),
      RuleSection(
        heading: 'T\'au Empire — Nuée Kroot',
        body:
            'Une masse d\'infanterie Kroot (Carnivores, Chiens, Krootox, Exorôdeurs) qui déborde l\'ennemi de toutes parts, sans exo-armures ni véhicules lourds, appuyée par une escorte Fire Caste minimale.\n\nMentor Kroot — 45 pts\nCommandant En Exo-armure Enforcer — 80 pts\n8 × Carnivores Kroots — 520 pts\n8 × Chiens Kroots — 320 pts\n8 × Cavaliers Krootox — 320 pts\n6 × Exorôdeurs Kroots — 330 pts\n2 × Équipe De Brécheurs — 200 pts — Total : 1815 pts',
      ),
      RuleSection(
        heading: 'Thousand Sons — Colonne Blindée de Tzeentch',
        body:
            'Un mur de chars (Land Raider, Predators, Vindicators, Profanateurs) qui avance en formation pour écraser l\'adversaire à distance et en force de choc, avec juste assez d\'infanterie embarquée pour tenir les objectifs.\n\nLand Raider Des Thousand Sons — 220 pts\n2 × Predator Annihilator Des Thousand Sons — 260 pts\n2 × Predator Destructor Des Thousand Sons — 280 pts\n2 × Vindicator Des Thousand Sons — 370 pts\n2 × Profanateur Des Thousand Sons — 330 pts\nMétabrutus Des Thousand Sons — 110 pts\nRhino Des Thousand Sons — 90 pts\nMarines Rubricae — 105 pts\nSorcier Exalté — 80 pts — Total : 1845 pts',
      ),
      RuleSection(
        heading: 'Thousand Sons — Cohorte Psychique de Magnus',
        body:
            'Magnus le Rouge et sa cour de sorciers déversent des dégâts psychiques massifs pendant que les Marines Rubricae et Terminators du Scarabée Occulte encaissent et tiennent le terrain.\n\nMagnus Le Rouge — 435 pts\nAhriman — 100 pts\n3 × Marines Rubricae — 315 pts\n2 × Terminators Du Scarabée Occulte — 360 pts\nSorcier Exalté Sur Disque De Tzeentch — 100 pts\nMaître Infernal — 95 pts\n3 × Rejetons Du Chaos Des Thousand Sons — 195 pts\nPrince Démon Des Thousand Sons Ailé — 170 pts\nSorcier Des Thousand Sons — 85 pts — Total : 1855 pts',
      ),
      RuleSection(
        heading: 'Thousand Sons — Légion des Rubriques',
        body:
            'Des vagues de Marines Rubricae immortels avancent à pied, encadrées par une cour de sorciers psykers qui les maintiennent debout et pilonnent l\'ennemi à distance.\n\nAhriman — 100 pts\n8 × Marines Rubricae — 840 pts\n2 × Tzaangors — 140 pts\n3 × Sorcier Des Thousand Sons — 255 pts\nMaître Infernal — 95 pts\n3 × Rhino Des Thousand Sons — 270 pts\nSorcier Exalté — 80 pts\nProfanateur Des Thousand Sons — 165 pts — Total : 1945 pts',
      ),
      RuleSection(
        heading: 'Tyranids — Multitude Infinie',
        body:
            'Une marée de Termagants, Hormagaunts, Gargouilles et Genestealers déferle en nombre pour saturer le champ de bataille, portée par le Tervigon et Le Maître des Essaims qui régénèrent l\'essaim.\n\n4 × Termagants — 240 pts\n4 × Hormagaunts — 260 pts\n2 × Gargouilles — 170 pts\n3 × Genestealers — 225 pts\nTervigon — 160 pts\nLe Maître Des Essaims — 220 pts\n2 × Neurogaunts — 90 pts\n2 × Venomthropes — 140 pts\nZoanthropes — 100 pts\n2 × Biovores — 100 pts\n2 × Barbgaunts — 110 pts — Total : 1815 pts',
      ),
      RuleSection(
        heading: 'Tyranids — Monstres du Grand Dévoreur',
        body:
            'Une ménagerie de grosses créatures (Tyrannofex, Exocrine, Carnifex, Trygons, Haruspex) déferle en peu d\'unités mais très résistantes, difficiles à retirer de la table et dévastatrices en corps-à-corps comme à distance.\n\nTyran Des Ruches — 195 pts\nTyrannofex — 200 pts\nExocrine — 140 pts\nHaruspex — 125 pts\n2 × Carnifex — 230 pts\n2 × Trygon — 280 pts\nMawloc — 135 pts\nToxicrène — 150 pts\nMaleceptor — 170 pts\nPsychophage — 110 pts\nTermagants — 60 pts\nBarbgaunts — 55 pts — Total : 1850 pts',
      ),
      RuleSection(
        heading: 'Tyranids — Essaim Souterrain',
        body:
            'Lictors, Rôdeurs et Genestealers-cousins jaillissent du sol ou surgissent des Tyrannocytes pour frapper les flancs et l\'arrière ennemis avant de disparaître.\n\nParasite De Mortrex — 80 pts\n4 × Lictor — 240 pts\n3 × Rôdeurs — 375 pts\n3 × Gardes Tyranides — 240 pts\nNeurotyran — 105 pts\n2 × Tyrannocyte — 210 pts\nTermagants — 60 pts\nSporokyste — 145 pts\n2 × Spores Mucolides — 60 pts\n2 × Bondisseurs De Von Ryan — 140 pts\n3 × Pyrovores — 120 pts\nBarbgaunts — 55 pts — Total : 1830 pts',
      ),
      RuleSection(
        heading: 'World Eaters — Charge Sanglante de Khorne',
        body:
            'Angron, Khârn et des vagues de Berzerkers et Chakhals se ruent au corps-à-corps dès le premier tour pour trancher l\'adversaire avant qu\'il ne puisse riposter.\n\nAngron — 360 pts\nKhârn Le Félon — 100 pts\nSeigneur Invocatus — 110 pts\n3 × Berzerks De Khorne — 540 pts\n3 × Chakhals — 195 pts\nOctoliés — 135 pts\nOctoliés Exaltés — 140 pts\nRejetons Du Chaos Des World Eaters — 90 pts\nEscouade Terminator Des World Eaters — 175 pts — Total : 1845 pts',
      ),
      RuleSection(
        heading: 'World Eaters — Colonne Blindée de Khorne',
        body:
            'Un Prince Démon mène une colonne de Land Raider, Predators, Profanateur et Rhinos qui transportent les Berzerkers au contact tout en pilonnant l\'ennemi à distance.\n\nLand Raider Des World Eaters — 220 pts\n2 × Predator Annihilator Des World Eaters — 290 pts\n2 × Predator Destructor Des World Eaters — 290 pts\nProfanateur Des World Eaters — 180 pts\nMétabrutus Des World Eaters — 120 pts\n2 × Rhino Des World Eaters — 170 pts\n2 × Berzerks De Khorne — 360 pts\nPrince Démon Des World Eaters — 200 pts — Total : 1830 pts',
      ),
      RuleSection(
        heading: 'World Eaters — Seigneur des Crânes',
        body:
            'Un Seigneur des Crânes de Khorne titanesque avance en centre de table, escorté par des champions et des escouades légères qui protègent ses flancs jusqu\'à l\'impact.\n\nSeigneur Des Crânes De Khorne — 505 pts\nKhârn Le Félon — 100 pts\nSeigneur Invocatus — 110 pts\nPrince Démon Des World Eaters Ailé — 180 pts\n2 × Berzerks De Khorne — 360 pts\n2 × Chakhals — 130 pts\nOctoliés — 135 pts\n2 × Rejetons Du Chaos Des World Eaters — 180 pts\n2 × Rhino Des World Eaters — 170 pts — Total : 1870 pts',
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
