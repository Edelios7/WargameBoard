import '../database/app_database.dart';
import '../database/tables/battles_table.dart';
import '../domain/xp/xp_awards.dart';
import '../domain/xp/xp_category.dart';

/// Point d'entrée unique pour créditer de l'XP suite à une action du
/// hobbyiste. Appelé depuis les repositories existants après leur écriture
/// principale — voir le plan XP pour la liste des points de câblage.
class XpService {
  final AppDatabase database;

  XpService(this.database);

  Future<void> _award({
    required XpCategory category,
    required int amount,
    String? factionId,
  }) async {
    if (amount <= 0) return;
    await database.xpDao.incrementCategory(category, amount);
    if (factionId != null) {
      await database.xpDao.incrementFaction(factionId, amount);
    }
  }

  /// Symétrique de [_award] — reprend l'XP créditée pour une action
  /// ensuite annulée (ex. suppression d'une partie journalisée). Les
  /// totaux ne descendent jamais sous 0 (voir `XpDao.incrementCategory`/
  /// `incrementFaction`).
  Future<void> _revoke({
    required XpCategory category,
    required int amount,
    String? factionId,
  }) async {
    if (amount <= 0) return;
    await database.xpDao.incrementCategory(category, -amount);
    if (factionId != null) {
      await database.xpDao.incrementFaction(factionId, -amount);
    }
  }

  /// Peinture d'un modèle (ou plusieurs, `delta` figurines) sur une
  /// datasheet donnée. `squadCompleted` ajoute le bonus d'escouade
  /// entièrement peinte.
  Future<void> awardPainting({
    required String datasheetId,
    required int delta,
    bool squadCompleted = false,
  }) async {
    if (delta <= 0 && !squadCompleted) return;
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    final perModel =
        xpClass == null ? paintingXpStandard : paintingXpPerModel(xpClass);
    final amount = (delta > 0 ? delta * perModel : 0) +
        (squadCompleted ? paintingXpSquadComplete : 0);
    await _award(
      category: XpCategory.painting,
      amount: amount,
      factionId: xpClass?.factionId,
    );
  }

  /// Montage d'un modèle (ou plusieurs) sur une datasheet donnée.
  Future<void> awardAssembly({
    required String datasheetId,
    required int delta,
    bool squadCompleted = false,
  }) async {
    if (delta <= 0 && !squadCompleted) return;
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    final perModel =
        xpClass == null ? assemblyXpStandard : assemblyXpPerModel(xpClass);
    final amount = (delta > 0 ? delta * perModel : 0) +
        (squadCompleted ? assemblyXpSquadComplete : 0);
    await _award(
      category: XpCategory.assembly,
      amount: amount,
      factionId: xpClass?.factionId,
    );
  }

  Future<void> awardBattle({
    String? armyId,
    BattleResult? result,
    BattleType type = BattleType.matched,
    required DateTime playedAt,
  }) async {
    // Une partie planifiée dans le futur (pas encore jouée, pas de
    // résultat) ne doit pas créditer l'XP "partie jouée" tant qu'elle n'a
    // pas réellement eu lieu.
    if (result == null && playedAt.isAfter(DateTime.now())) return;

    var amount = battleXpPlayed;
    if (result != null) amount += battleXpResult;
    if (type == BattleType.narrative) amount += battleXpNarrativeBonus;
    if (type == BattleType.tournament) amount += battleXpTournamentBonus;

    final factionId =
        armyId == null ? null : await database.armyDao.getFactionId(armyId);

    await _award(
      category: XpCategory.battle,
      amount: amount,
      factionId: factionId,
    );
  }

  /// Reprend l'XP créditée par [awardBattle] pour la même partie — appelé
  /// quand une partie qui avait déjà reçu son XP (journalisée
  /// rétroactivement, ou terminée en direct via `finishBattle`) est
  /// supprimée, pour empêcher un exploit "créer une partie fictive,
  /// encaisser l'XP, la supprimer, recommencer".
  Future<void> revokeBattle({
    String? armyId,
    BattleResult? result,
    BattleType type = BattleType.matched,
    required DateTime playedAt,
  }) async {
    if (result == null && playedAt.isAfter(DateTime.now())) return;

    var amount = battleXpPlayed;
    if (result != null) amount += battleXpResult;
    if (type == BattleType.narrative) amount += battleXpNarrativeBonus;
    if (type == BattleType.tournament) amount += battleXpTournamentBonus;

    final factionId =
        armyId == null ? null : await database.armyDao.getFactionId(armyId);

    await _revoke(
      category: XpCategory.battle,
      amount: amount,
      factionId: factionId,
    );
  }

  /// Nouvelle entrée de collection ("nouvelle boîte"), plus le bonus
  /// "nouvelle faction" si c'est la première fois que cette faction est
  /// représentée dans la collection.
  Future<void> awardNewBox(String datasheetId) async {
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    if (xpClass == null) return;

    final isNewFaction =
        !await database.xpDao.hasFactionXp(xpClass.factionId);

    await _award(
      category: XpCategory.collection,
      amount: collectionXpNewBox +
          (isNewFaction ? collectionXpNewFaction : 0),
      factionId: xpClass.factionId,
    );
  }

  /// Création de la toute première armée (une seule fois, tous historiques
  /// confondus — un jalon persistant, pas un `COUNT(*)` live : celui-ci
  /// retomberait à 1 après une suppression puis recréation, ce qui
  /// permettait de récupérer le bonus à l'infini).
  Future<void> awardFirstArmyIfNeeded(String factionId) async {
    const milestone = 'first_army';
    if (await database.xpDao.hasMilestone(milestone)) return;
    await database.xpDao.markMilestone(milestone);
    await _award(
      category: XpCategory.collection,
      amount: collectionXpFirstArmy,
      factionId: factionId,
    );
  }

  Future<void> awardDatasheetViewed(String datasheetId) async {
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    await _award(
      category: XpCategory.lore,
      amount: loreXpDatasheetViewed,
      factionId: xpClass?.factionId,
    );
  }

  Future<void> awardCatalogOpened() async {
    await _award(category: XpCategory.lore, amount: loreXpCatalogOpened);
  }
}
