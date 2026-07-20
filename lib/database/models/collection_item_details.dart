class CollectionItemDetails {
  final String id;
  final String datasheetId;
  final String datasheetName;
  final String factionName;
  final int quantity;
  final int assembled;
  final int primed;
  final int painted;
  final double? purchasePrice;

  const CollectionItemDetails({
    required this.id,
    required this.datasheetId,
    required this.datasheetName,
    required this.factionName,
    required this.quantity,
    required this.assembled,
    required this.primed,
    required this.painted,
    this.purchasePrice,
  });
}

class CollectionSummary {
  final int totalEntries;
  final int totalModels;
  final int totalPainted;
  final double totalValue;

  const CollectionSummary({
    required this.totalEntries,
    required this.totalModels,
    required this.totalPainted,
    this.totalValue = 0,
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
