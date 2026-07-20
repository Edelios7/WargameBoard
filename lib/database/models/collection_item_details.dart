class CollectionItemDetails {
  final String id;
  final String datasheetId;
  final String datasheetName;
  final String factionName;
  final int quantity;
  final int assembled;
  final int primed;
  final int painted;

  const CollectionItemDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    required this.factionName,
    required this.quantity,
    required this.assembled,
    required this.primed,
    required this.painted,
  });
}

class CollectionSummary {
  final int totalEntries;
  final int totalModels;
  final int totalPainted;

  const CollectionSummary({
    required this.totalEntries,
    required this.totalModels,
    required this.totalPainted,
  });

  double get paintedRatio =>
      totalModels == 0 ? 0 : totalPainted / totalModels;
}

class WishlistItemDetails {
  final String id;
  final String datasheetId;
  final String datasheetName;
  final String factionName;
  final int quantity;
  final String? notes;

  const WishlistItemDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    required this.factionName,
    required this.quantity,
    this.notes,
  });
}
