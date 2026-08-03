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
  static const String dashboardWelcomeBanner = 'dashboard.welcome_banner';
  static const String dashboardQuickActions = 'dashboard.quick_actions';
  static const String dashboardRecentAdditions = 'dashboard.recent_additions';

  static const String armiesProfileCard = 'armies.profile_card';

  static const String battleSummaryCard = 'battle.summary_card';
  static const String battleStratagemAssistant = 'battle.stratagem_assistant';

  static const String catalogFiltersHeader = 'catalog.filters_header';

  static const String collectionSummaryCard = 'collection.summary_card';

  static const String statisticsFactionBreakdown =
      'statistics.faction_breakdown';
  static const String statisticsXpProgress = 'statistics.xp_progress';
  static const String statisticsRecentForm = 'statistics.recent_form';

  static const String profileCommanderCard = 'profile.commander_card';

  static const String rulesIndexCard = 'rules.index_card';
}
