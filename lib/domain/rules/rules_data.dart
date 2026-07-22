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
