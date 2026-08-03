/// Identifiants stables utilisés par [BlockOverrides] pour cibler un bloc
/// structurel ou le fond d'une grosse page en mode personnalisation.
/// Toujours des littéraux fixes (jamais dérivés d'un texte localisé) pour
/// que les réglages de l'utilisateur survivent à un changement de langue.
class CustomizationIds {
  CustomizationIds._();

  // Fonds de page — un par grosse page de l'appli.
  static const String pageDashboard = 'page.dashboard';
  static const String pageArmies = 'page.armies';
  static const String pageBattle = 'page.battle';
  static const String pageCatalog = 'page.catalog';
  static const String pageCollection = 'page.collection';
  static const String pageStatistics = 'page.statistics';
  static const String pageSettings = 'page.settings';
  static const String pageProfile = 'page.profile';
  static const String pageRules = 'page.rules';

  // Blocs structurels — cartes fixes de chaque page, hors listes générées.
  static const String dashboardHeader = 'dashboard.header';
  static const String dashboardWelcomeBanner = 'dashboard.welcome_banner';
  static const String dashboardQuickActions = 'dashboard.quick_actions';
  static const String dashboardRecentAdditions = 'dashboard.recent_additions';
  static const String dashboardStatPoints = 'dashboard.stat_points';
  static const String dashboardStatModels = 'dashboard.stat_models';
  static const String dashboardStatPainting = 'dashboard.stat_painting';
  static const String dashboardLastBattle = 'dashboard.last_battle';
  static const String dashboardYourArmies = 'dashboard.your_armies';
  static const String dashboardPaintingDonut = 'dashboard.painting_donut';
  static const String dashboardFactionBreakdown =
      'dashboard.faction_breakdown';
  static const String dashboardRecentlyViewed = 'dashboard.recently_viewed';
  static const String dashboardNextBattle = 'dashboard.next_battle';
  static const String dashboardProjects = 'dashboard.projects';

  static const String armiesProfileCard = 'armies.profile_card';

  static const String battleSummaryCard = 'battle.summary_card';
  static const String battleStratagemAssistant = 'battle.stratagem_assistant';
  static const String battleScoreBlock = 'battle.score_block';
  static const String battlePhaseBlock = 'battle.phase_block';
  static const String battleCommandPoints = 'battle.command_points';
  static const String battleRosterMine = 'battle.roster_mine';
  static const String battleRosterOpponent = 'battle.roster_opponent';
  static const String battleDiceRoller = 'battle.dice_roller';
  static const String battleEventsBlock = 'battle.events_block';
  static const String battleNotesBlock = 'battle.notes_block';

  static const String catalogFiltersHeader = 'catalog.filters_header';

  static const String collectionSummaryCard = 'collection.summary_card';
  static const String collectionStatArmies = 'collection.stat_armies';
  static const String collectionStatModels = 'collection.stat_models';
  static const String collectionStatFactions = 'collection.stat_factions';
  static const String collectionStatLastBattle =
      'collection.stat_last_battle';
  static const String collectionFiltersPanel = 'collection.filters_panel';

  static const String statisticsFactionBreakdown =
      'statistics.faction_breakdown';
  static const String statisticsXpProgress = 'statistics.xp_progress';
  static const String statisticsRecentForm = 'statistics.recent_form';
  static const String statisticsStatArmies = 'statistics.stat_armies';
  static const String statisticsStatEntries = 'statistics.stat_entries';
  static const String statisticsStatModels = 'statistics.stat_models';
  static const String statisticsStatPainted = 'statistics.stat_painted';
  static const String statisticsStatGames = 'statistics.stat_games';
  static const String statisticsStatVictories = 'statistics.stat_victories';
  static const String statisticsStatDefeats = 'statistics.stat_defeats';
  static const String statisticsStatWinRate = 'statistics.stat_win_rate';
  static const String statisticsBattleOutcomes =
      'statistics.battle_outcomes';

  static const String settingsProfileCard = 'settings.profile_card';
  static const String settingsLanguageCard = 'settings.language_card';
  static const String settingsImportCard = 'settings.import_card';
  static const String settingsBackupCard = 'settings.backup_card';

  static const String profileCommanderCard = 'profile.commander_card';
  static const String profileFactionsCard = 'profile.factions_card';

  static const String rulesIndexCard = 'rules.index_card';
  static const String rulesCategoryDocuments = 'rules.category_documents';
  static const String rulesRecentDocuments = 'rules.recent_documents';
  static const String rulesPopularDocuments = 'rules.popular_documents';
  static const String rulesHelpRow = 'rules.help_row';
  static const String rulesArmyListsEmptyHint = 'rules.army_lists_empty_hint';
  static const String rulesFoodChainResult = 'rules.food_chain_result';
  static const String rulesDocumentEmptyState = 'rules.document_empty_state';
  static const String rulesCombatSimControls = 'rules.combat_sim_controls';
  static const String rulesCombatSimAttacker = 'rules.combat_sim_attacker';
  static const String rulesCombatSimDefender = 'rules.combat_sim_defender';
}
