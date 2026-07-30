import '../database/app_database.dart';
import '../database/models/collection_item_details.dart';
import '../services/xp_service.dart';

class CollectionRepository {
  final AppDatabase database;
  final XpService xpService;

  CollectionRepository(this.database, this.xpService);

  Future<List<CollectionItemDetails>> listEntries() {
    return database.collectionDao.listEntries();
  }

  Future<CollectionSummary> getSummary() {
    return database.collectionDao.getSummary();
  }

  Future<int> getOwnedQuantity(String datasheetId) {
    return database.collectionDao.getOwnedQuantity(datasheetId);
  }

  Future<String> addEntry({
    required String datasheetId,
    required int quantity,
    double? purchasePrice,
  }) async {
    final id = await database.collectionDao.addEntry(
      datasheetId: datasheetId,
      quantity: quantity,
      purchasePrice: purchasePrice,
    );
    await xpService.awardNewBox(datasheetId);
    return id;
  }

  Future<void> deleteEntry(String id) async {
    // Reprend l'XP "nouvelle boîte" créditée à l'ajout — sinon
    // ajouter/supprimer/rajouter la même entrée créditerait l'XP à
    // l'infini pour la même figurine jamais réellement acquise deux fois.
    final entry = await database.collectionDao.getEntry(id);
    await database.collectionDao.deleteEntry(id);
    if (entry != null) {
      await xpService.revokeNewBox(entry.datasheetId);
    }
  }

  Future<void> setPurchasePrice(String id, double? purchasePrice) {
    return database.collectionDao.setPurchasePrice(id, purchasePrice);
  }

  Future<void> updateCounts(
    String id, {
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
  }) async {
    final result = await database.collectionDao.updateCounts(
      id,
      quantity: quantity,
      assembled: assembled,
      primed: primed,
      painted: painted,
    );

    final before = result.before;
    final after = result.after;

    // Le "juste complété" ne doit récompenser qu'une vraie progression
    // (montage/peinture d'un modèle de plus) qui atteint la quantité — pas
    // une simple réduction de `quantity` qui, via le clamp de
    // `CollectionDao.updateCounts`, ferait mécaniquement rejoindre
    // `assembled`/`painted` sans qu'aucun modèle n'ait été touché.
    final assembledDelta = after.assembled - before.assembled;
    final assembledJustCompleted = assembledDelta > 0 &&
        after.assembled == after.quantity &&
        before.assembled != before.quantity;
    if (assembledDelta > 0 || assembledJustCompleted) {
      await xpService.awardAssembly(
        datasheetId: after.datasheetId,
        delta: assembledDelta > 0 ? assembledDelta : 0,
        squadCompleted: assembledJustCompleted,
      );
    } else if (assembledDelta < 0 && assembled != null) {
      // Symétrique de l'award ci-dessus, mais seulement pour une baisse
      // EXPLICITEMENT demandée (bouton "-" sur `assembled`) : sans ça,
      // redescendre puis remonter le compteur recréditerait l'XP à
      // l'infini pour les mêmes figurines. On ignore en revanche la baisse
      // provoquée en effet de bord par une réduction de `quantity` (le
      // clamp de `CollectionDao.updateCounts`) — aucun modèle n'a alors
      // été réellement "démonté", `quantity` est une notion distincte du
      // travail de montage/peinture déjà accompli.
      final wasComplete = before.assembled == before.quantity;
      final stillComplete = after.assembled == after.quantity;
      await xpService.revokeAssembly(
        datasheetId: after.datasheetId,
        delta: -assembledDelta,
        squadUncompleted: wasComplete && !stillComplete,
      );
    }

    final paintedDelta = after.painted - before.painted;
    final paintedJustCompleted = paintedDelta > 0 &&
        after.painted == after.quantity &&
        before.painted != before.quantity;
    if (paintedDelta > 0 || paintedJustCompleted) {
      await xpService.awardPainting(
        datasheetId: after.datasheetId,
        delta: paintedDelta > 0 ? paintedDelta : 0,
        squadCompleted: paintedJustCompleted,
      );
    } else if (paintedDelta < 0 && painted != null) {
      // Voir le commentaire équivalent pour l'assemblage ci-dessus : on ne
      // reprend l'XP que sur une baisse explicite de `painted`, jamais sur
      // un clamp induit par une réduction de `quantity`.
      final wasComplete = before.painted == before.quantity;
      final stillComplete = after.painted == after.quantity;
      await xpService.revokePainting(
        datasheetId: after.datasheetId,
        delta: -paintedDelta,
        squadUncompleted: wasComplete && !stillComplete,
      );
    }
  }

  Future<List<WishlistItemDetails>> listWishlistItems() {
    return database.collectionDao.listWishlistItems();
  }

  Future<String> addWishlistItem({
    required String datasheetId,
    int quantity = 1,
    String? notes,
  }) {
    return database.collectionDao.addWishlistItem(
      datasheetId: datasheetId,
      quantity: quantity,
      notes: notes,
    );
  }

  Future<void> deleteWishlistItem(String id) {
    return database.collectionDao.deleteWishlistItem(id);
  }

  Future<void> moveWishlistItemToCollection(String id) async {
    final datasheetId =
        await database.collectionDao.moveWishlistItemToCollection(id);
    await xpService.awardNewBox(datasheetId);
  }

  Future<List<CollectionItemDetails>> listRecentPurchases({int limit = 5}) {
    return database.collectionDao.listRecentPurchases(limit: limit);
  }

  Future<List<CollectionItemDetails>> listRecentlyAdded({int limit = 5}) {
    return database.collectionDao.listRecentlyAdded(limit: limit);
  }

  Future<List<CollectionGap>> getCollectionGaps({int limit = 5}) {
    return database.collectionDao.getCollectionGaps(limit: limit);
  }
}
