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
    final (amount, factionId) = await _paintingAmount(
      datasheetId: datasheetId,
      delta: delta,
      squadToggled: squadCompleted,
    );
    await _award(category: XpCategory.painting, amount: amount, factionId: factionId);
  }

  /// Symétrique de [awardPainting] — reprend l'XP quand un compteur de
  /// peinture redescend (bouton "-", ou quantité totale réduite en dessous
  /// du nombre peint) : sans ça, redescendre `painted` à 0 puis remonter
  /// recréditerait l'XP à l'infini pour les mêmes figurines.
  Future<void> revokePainting({
    required String datasheetId,
    required int delta,
    bool squadUncompleted = false,
  }) async {
    final (amount, factionId) = await _paintingAmount(
      datasheetId: datasheetId,
      delta: delta,
      squadToggled: squadUncompleted,
    );
    await _revoke(category: XpCategory.painting, amount: amount, factionId: factionId);
  }

  Future<(int, String?)> _paintingAmount({
    required String datasheetId,
    required int delta,
    required bool squadToggled,
  }) async {
    if (delta <= 0 && !squadToggled) return (0, null);
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    final perModel =
        xpClass == null ? paintingXpStandard : paintingXpPerModel(xpClass);
    final amount = (delta > 0 ? delta * perModel : 0) +
        (squadToggled ? paintingXpSquadComplete : 0);
    return (amount, xpClass?.factionId);
  }

  /// Montage d'un modèle (ou plusieurs) sur une datasheet donnée.
  Future<void> awardAssembly({
    required String datasheetId,
    required int delta,
    bool squadCompleted = false,
  }) async {
    final (amount, factionId) = await _assemblyAmount(
      datasheetId: datasheetId,
      delta: delta,
      squadToggled: squadCompleted,
    );
    await _award(category: XpCategory.assembly, amount: amount, factionId: factionId);
  }

  /// Symétrique de [awardAssembly] — voir [revokePainting].
  Future<void> revokeAssembly({
    required String datasheetId,
    required int delta,
    bool squadUncompleted = false,
  }) async {
    final (amount, factionId) = await _assemblyAmount(
      datasheetId: datasheetId,
      delta: delta,
      squadToggled: squadUncompleted,
    );
    await _revoke(category: XpCategory.assembly, amount: amount, factionId: factionId);
  }

  Future<(int, String?)> _assemblyAmount({
    required String datasheetId,
    required int delta,
    required bool squadToggled,
  }) async {
    if (delta <= 0 && !squadToggled) return (0, null);
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    final perModel =
        xpClass == null ? assemblyXpStandard : assemblyXpPerModel(xpClass);
    final amount = (delta > 0 ? delta * perModel : 0) +
        (squadToggled ? assemblyXpSquadComplete : 0);
    return (amount, xpClass?.factionId);
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
  /// "nouvelle faction" la toute première fois que cette faction rejoint
  /// la collection.
  ///
  /// Le bonus est un jalon PERSISTANT (comme [awardFirstArmyIfNeeded]),
  /// pas un test en direct du style "cette faction a-t-elle 0 XP" : un
  /// test en direct serait manipulable en ajoutant puis supprimant la
  /// seule entrée d'une faction pour retomber à "aucune entrée" et
  /// récupérer le bonus à chaque fois.
  Future<void> awardNewBox(String datasheetId) async {
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    if (xpClass == null) return;

    final milestone = 'first_collection_${xpClass.factionId}';
    final isNewFaction = !await database.xpDao.hasMilestone(milestone);
    if (isNewFaction) await database.xpDao.markMilestone(milestone);

    await _award(
      category: XpCategory.collection,
      amount: collectionXpNewBox +
          (isNewFaction ? collectionXpNewFaction : 0),
      factionId: xpClass.factionId,
    );
  }

  /// Symétrique de [awardNewBox] — reprend uniquement la part fixe
  /// ([collectionXpNewBox]) quand une entrée est supprimée, jamais le
  /// bonus "nouvelle faction" (jalon permanent, jamais repris — cohérent
  /// avec [awardFirstArmyIfNeeded] qui ne l'est pas non plus). Empêche
  /// l'exploit "ajouter une entrée, la supprimer, la rajouter" qui
  /// recréditerait l'XP de base à l'infini.
  Future<void> revokeNewBox(String datasheetId) async {
    final xpClass = await database.datasheetDao.getXpClassification(
      datasheetId,
    );
    if (xpClass == null) return;

    await _revoke(
      category: XpCategory.collection,
      amount: collectionXpNewBox,
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
