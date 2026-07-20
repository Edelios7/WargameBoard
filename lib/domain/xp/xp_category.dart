/// Les 5 spécialisations du hobby suivies par le système d'XP.
///
/// `name` (généré par l'enum) est utilisé tel quel comme clé de stockage
/// dans `XpCategoryTotals` — ne pas réordonner/renommer sans migration.
enum XpCategory {
  /// Artiste — peinture.
  painting,

  /// Hobbyiste — montage.
  assembly,

  /// Stratège — parties jouées.
  battle,

  /// Collectionneur — collection, boîtes, armées.
  collection,

  /// Archiviste — consultation du catalogue et des règles.
  lore,
}
