// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Wargame Board';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCatalog => 'Catalog';

  @override
  String get navRules => 'Rules';

  @override
  String get navArmies => 'Armies';

  @override
  String get navBattles => 'Battles';

  @override
  String get navCollection => 'Collection';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get navSettings => 'Settings';

  @override
  String get versionLabel => 'Version 0.1';

  @override
  String get settingsProfileTitle => 'Profile';

  @override
  String get settingsDisplayNameLabel => 'Your name';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsImportTitle => 'Data import';

  @override
  String get settingsImportDescription =>
      'Import datasheets from JSON (existing ids get updated).';

  @override
  String get settingsImportButton => 'Import JSON';

  @override
  String get settingsImportPasteHint => 'Paste the JSON document here...';

  @override
  String get settingsImportRun => 'Import';

  @override
  String settingsImportSuccess(int count) {
    return '$count items imported';
  }

  @override
  String get catalogSearchHint => 'Search for a unit...';

  @override
  String get catalogEmptyResults => 'No unit found';

  @override
  String get catalogSelectPrompt => 'Select a unit to see its datasheet';

  @override
  String catalogLoadError(String error) {
    return 'Error loading catalog: $error';
  }

  @override
  String get catalogFilterAllFactions => 'All factions';

  @override
  String get catalogResetFilters => 'Reset';

  @override
  String catalogResultsCount(int count) {
    return '$count result(s)';
  }

  @override
  String get catalogFilterAllKeywords => 'All keywords';

  @override
  String get catalogFilterAllRoles => 'All roles';

  @override
  String get catalogFilterAllUnitTypes => 'All types';

  @override
  String get catalogFilterAllEditions => 'All editions';

  @override
  String get catalogFilterTitle => 'Filters';

  @override
  String get catalogQuickAccessFactions => 'Quick access to factions';

  @override
  String get catalogFilterFaction => 'Faction';

  @override
  String get catalogFilterRole => 'Role';

  @override
  String get catalogFilterKeywords => 'Keywords';

  @override
  String get catalogAddKeywordFilter => 'Add a keyword';

  @override
  String get catalogKeywordSearchHint => 'Search for a keyword...';

  @override
  String catalogOwnedBadge(int count) {
    return 'Owned ×$count';
  }

  @override
  String get catalogAllFactionsChip => 'All';

  @override
  String get catalogActiveFiltersTitle => 'Active filters';

  @override
  String get catalogApplyFilters => 'Apply';

  @override
  String get catalogFilterCost => 'Cost (pts)';

  @override
  String get catalogFilterEdition => 'Edition';

  @override
  String get catalogFilterUnitType => 'Unit type';

  @override
  String get catalogBreadcrumbAllUnits => 'All units';

  @override
  String catalogCostBracketLabel(int models, int points) {
    return '$models models: $points pts';
  }

  @override
  String get catalogSortLabel => 'Sort by:';

  @override
  String get catalogSortNameAsc => 'Name (A-Z)';

  @override
  String get catalogSortPointsAsc => 'Points (ascending)';

  @override
  String get catalogSortPointsDesc => 'Points (descending)';

  @override
  String catalogUnitsCount(int count) {
    return '$count UNITS';
  }

  @override
  String get catalogSeeMore => 'See more';

  @override
  String get catalogSeeLess => 'See less';

  @override
  String get catalogViewFullSheet => 'View full datasheet';

  @override
  String get catalogBackToCatalog => 'Catalog';

  @override
  String get catalogWeaponsButton => 'Weapons';

  @override
  String get catalogWeaponsTitle => 'Weapons inventory';

  @override
  String get catalogWeaponsSearchHint => 'Search for a weapon...';

  @override
  String catalogWeaponsCount(int count) {
    return '$count weapons';
  }

  @override
  String get catalogWeaponsFilterAll => 'All';

  @override
  String get catalogWeaponsFilterRanged => 'Ranged';

  @override
  String get catalogWeaponsFilterMelee => 'Melee';

  @override
  String get catalogWeaponsFilterMissingProfile => 'Missing profile';

  @override
  String catalogWeaponsUsedBy(int count) {
    return '$count datasheets';
  }

  @override
  String get catalogWeaponsNoProfile => 'No stat profile imported';

  @override
  String get catalogWeaponsEmpty => 'No weapon matches';

  @override
  String get sectionDescription => 'Description';

  @override
  String get sectionUnitSize => 'Unit size';

  @override
  String get statMovement => 'Movement';

  @override
  String get statToughness => 'Toughness';

  @override
  String get statSave => 'Save';

  @override
  String get statWounds => 'Wounds';

  @override
  String get statLeadership => 'Leadership';

  @override
  String get statObjectiveControl => 'Objective Control';

  @override
  String get sectionProfiles => 'Profiles';

  @override
  String get sectionWeapons => 'Weapons';

  @override
  String get weaponColName => 'Weapon';

  @override
  String get weaponColRange => 'Range';

  @override
  String get weaponColAttacks => 'A';

  @override
  String get weaponColStrength => 'S';

  @override
  String get weaponColAp => 'AP';

  @override
  String get weaponColDamage => 'D';

  @override
  String get weaponMelee => 'Melee';

  @override
  String get sectionKeywords => 'Keywords';

  @override
  String get sectionAbilities => 'Abilities';

  @override
  String get abilityGenericRuleTag => 'Generic rule';

  @override
  String get abilityNoTextAvailable =>
      'Faction-specific rule — text not available on this datasheet, check the rulebook.';

  @override
  String get sectionEquipment => 'Equipment';

  @override
  String unitSizeRange(int min, int max, int defaultSize) {
    return '$min - $max models (default: $defaultSize)';
  }

  @override
  String pointsSuffix(int points) {
    return '$points pts';
  }

  @override
  String get armyBuilderNewArmy => 'New army';

  @override
  String get armyBuilderArmyName => 'Army name';

  @override
  String get armyBuilderFaction => 'Faction';

  @override
  String get armyBuilderCreate => 'Create';

  @override
  String get armyBuilderCancel => 'Cancel';

  @override
  String get armyBuilderEmptyList => 'No armies yet';

  @override
  String get armyBuilderSelectPrompt => 'Select an army or create a new one';

  @override
  String get armyBuilderAddUnit => 'Add a unit';

  @override
  String get armyBuilderEmptyUnits => 'No units in this army';

  @override
  String get armyBuilderDeleteArmy => 'Delete army';

  @override
  String get armyBuilderCopyList => 'Copy list';

  @override
  String get armyBuilderCopiedToClipboard => 'List copied to clipboard';

  @override
  String get armyBuilderDuplicate => 'Duplicate army';

  @override
  String get armyBuilderDuplicateUnit => 'Duplicate unit';

  @override
  String armyBuilderOwnedShortage(int owned, int needed) {
    return 'You only own $owned model(s) out of the $needed needed in this army.';
  }

  @override
  String get armyBuilderChangeDetachment => 'Change detachment';

  @override
  String get armyBuilderOnlyOwnedFilter => 'Only my collection';

  @override
  String get armyBuilderToBuy => 'To buy';

  @override
  String armyBuilderEnhancementsReset(int count) {
    return '$count enhancement(s) reset after changing detachment.';
  }

  @override
  String get armyBuilderWarlord => 'Warlord';

  @override
  String get armyBuilderSetWarlord => 'Set as Warlord';

  @override
  String get armyBuilderUnsetWarlord => 'Remove Warlord status';

  @override
  String get armyValidationNoWarlord => 'No Warlord selected';

  @override
  String get armyBuilderNotesLabel => 'Notes';

  @override
  String get armyBuilderDuplicateNameLabel => 'Copy name';

  @override
  String armyBuilderDuplicateSuffix(String name) {
    return '$name (copy)';
  }

  @override
  String get armyBuilderDetachmentLabel => 'Detachment (optional)';

  @override
  String get armyBuilderDetachmentNone => 'None';

  @override
  String get armyBuilderEnhancementLabel => 'Enhancement';

  @override
  String get armyBuilderEnhancementNone => 'None';

  @override
  String get armyBuilderChooseEnhancement => 'Choose an enhancement';

  @override
  String get armyBuilderStratagems => 'Stratagems';

  @override
  String armyBuilderStratagemCp(int cp) {
    return '$cp CP';
  }

  @override
  String get armyBuilderNoStratagems => 'No stratagems for this detachment';

  @override
  String armyBuilderModelCount(int count) {
    return '$count models';
  }

  @override
  String armyBuilderUnitCount(int count) {
    return '$count units';
  }

  @override
  String get armyBuilderListValid => 'Valid list';

  @override
  String get armyBuilderListInvalid => 'Invalid list';

  @override
  String get armyBuilderRoleOther => 'Other';

  @override
  String get armyBuilderNoUnitsYet => 'Add units to build your roster';

  @override
  String get armyBuilderPointsLimitLabel => 'Points limit (optional)';

  @override
  String armyBuilderPointsWithLimit(int points, int limit) {
    return '$points / $limit pts';
  }

  @override
  String get armyBuilderOverLimit => 'Points limit exceeded';

  @override
  String get armyValidationEmptyArmy => 'Empty army — add some units';

  @override
  String get armyValidationNoDetachment => 'No detachment selected';

  @override
  String get armyValidationTooManyEnhancements =>
      'Too many enhancements (max 3)';

  @override
  String get armyBuilderBack => 'Back';

  @override
  String get armyBuilderStatPoints => 'Points';

  @override
  String get armyBuilderStatUnits => 'Units';

  @override
  String get armyBuilderStatBattleline => 'Battleline';

  @override
  String get armyBuilderStatEnhancements => 'Enhancements';

  @override
  String get armyBuilderDetachmentSection => 'Detachment';

  @override
  String get armyBuilderNoDetachment => 'No detachment';

  @override
  String get armyBuilderRulesSection => 'Rules';

  @override
  String get armyBuilderViewAllRules => 'View all rules';

  @override
  String get armyBuilderUnitsSection => 'Units';

  @override
  String get armyBuilderUnitDetailsTitle => 'Unit details';

  @override
  String get armyBuilderSelectUnitPrompt => 'Select a unit to see its details';

  @override
  String get armyBuilderEditUnit => 'Edit unit';

  @override
  String get armyBuilderRemoveUnit => 'Remove unit';

  @override
  String get armyBuilderModelCountLabel => 'Model count';

  @override
  String get armyBuilderPickOne => 'Pick an option';

  @override
  String armyBuilderPickUpTo(int count) {
    return 'Pick up to $count options';
  }

  @override
  String get armyBuilderSave => 'Save';

  @override
  String get armyBuilderRemoveUnitConfirmTitle => 'Remove this unit?';

  @override
  String armyBuilderRemoveUnitConfirmMessage(String name) {
    return '$name will be removed from the list. This action is permanent.';
  }

  @override
  String get armyBuilderDeleteArmyConfirmTitle => 'Delete this army?';

  @override
  String armyBuilderDeleteArmyConfirmMessage(String name) {
    return '$name and all its units will be permanently deleted.';
  }

  @override
  String get collectionAddEntry => 'Add to collection';

  @override
  String get collectionExportTooltip => 'Export';

  @override
  String get collectionExportCsv => 'Copy as CSV';

  @override
  String get collectionExportJson => 'Copy as JSON';

  @override
  String get collectionExportedToClipboard => 'Collection copied to clipboard';

  @override
  String get collectionEmpty => 'Your collection is empty';

  @override
  String collectionQuantityLabel(int count) {
    return '$count owned';
  }

  @override
  String get collectionAssembled => 'Assembled';

  @override
  String get collectionPrimed => 'Primed';

  @override
  String get collectionPainted => 'Painted';

  @override
  String get collectionIncrementQuantity => 'Add the amount to quantity';

  @override
  String get collectionDecrementQuantity => 'Remove the amount from quantity';

  @override
  String get collectionStepFieldTooltip => 'Amount to add or remove';

  @override
  String get collectionQuickAccessFactions => 'Quick access to factions';

  @override
  String get collectionDeleteEntryTooltip => 'Remove from collection';

  @override
  String get collectionDeleteConfirmTitle => 'Remove this entry?';

  @override
  String collectionDeleteConfirmMessage(String name) {
    return 'This will remove $name and its assembly/painting progress from your collection.';
  }

  @override
  String get collectionDeleteConfirmAction => 'Remove';

  @override
  String get collectionQuantityDialogLabel => 'Quantity';

  @override
  String get collectionPriceDialogLabel => 'Price (optional)';

  @override
  String collectionSummaryLine(int entries, int models, int painted) {
    return '$entries units · $models models · $painted painted';
  }

  @override
  String collectionTotalValue(String value) {
    return 'Value: $value';
  }

  @override
  String get collectionTabOwned => 'Collection';

  @override
  String get collectionTabWishlist => 'Wishlist';

  @override
  String get wishlistAddItem => 'Add to wishlist';

  @override
  String get wishlistEmpty => 'Your wishlist is empty';

  @override
  String get wishlistMoveToCollection => 'Mark as acquired';

  @override
  String get wishlistNotesDialogLabel => 'Notes (optional)';

  @override
  String get collectionSearchHint => 'Search the collection...';

  @override
  String collectionStatArmiesSub(int complete) {
    return '$complete complete';
  }

  @override
  String collectionStatModelsPaintedSub(int count, int percent) {
    return 'Painted: $count ($percent%)';
  }

  @override
  String get collectionValueTitle => 'Collection value';

  @override
  String get collectionValueUnquantifiedSub => 'Unquantifiable';

  @override
  String get collectionValueTierStarting => 'Starting out';

  @override
  String get collectionValueTierSolid => 'Solid';

  @override
  String get collectionValueTierEpic => 'Epic';

  @override
  String get collectionValueTierLegendary => 'Legendary';

  @override
  String get collectionFilterFactionTitle => 'Faction';

  @override
  String get collectionFilterStateTitle => 'State';

  @override
  String get collectionStateUnbuilt => 'Unbuilt';

  @override
  String get collectionMyArmiesTitle => 'My armies';

  @override
  String get collectionRecentAdditionsTitle => 'Recent additions';

  @override
  String get collectionAllItemsTitle => 'Whole collection';

  @override
  String get collectionNoResultsForFilters =>
      'No miniature matches the filters';

  @override
  String get statsArmiesCount => 'Armies created';

  @override
  String get statsCollectionEntries => 'Units in collection';

  @override
  String get statsCollectionModels => 'Models in collection';

  @override
  String get statsCollectionPainted => 'Models painted';

  @override
  String get statsPaintingProgress => 'Painting progress';

  @override
  String get statsPointsByArmy => 'Points by army';

  @override
  String get statsNoArmies => 'No army created yet';

  @override
  String get statsNoCollection => 'No models in your collection yet';

  @override
  String get statsGamesPlayed => 'Games played';

  @override
  String get statsVictories => 'Victories';

  @override
  String get statsDefeats => 'Defeats';

  @override
  String get statsWinRate => 'Win rate';

  @override
  String statsBattleRecord(int victories, int defeats, int draws) {
    return 'Record ${victories}W / ${defeats}L / ${draws}D';
  }

  @override
  String get battleNewBattle => 'New battle';

  @override
  String get battleOpponentLabel => 'Opponent';

  @override
  String get battleMissionLabel => 'Mission';

  @override
  String get battleArmyLabel => 'Army used';

  @override
  String get battleArmyNone => 'None';

  @override
  String get battleResultLabel => 'Result';

  @override
  String get battleResultVictory => 'Victory';

  @override
  String get battleResultDefeat => 'Defeat';

  @override
  String get battleResultDraw => 'Draw';

  @override
  String get battleNotPlayedYet => 'Not played yet (scheduled)';

  @override
  String get battleMyScoreLabel => 'My score';

  @override
  String get battleOpponentScoreLabel => 'Opponent score';

  @override
  String get battleNotesLabel => 'Notes (optional)';

  @override
  String get battleEmptyList => 'No battles logged yet';

  @override
  String battleScoreLine(int my, int opponent) {
    return '$my - $opponent';
  }

  @override
  String get dashboardWelcome => 'Welcome to Wargame Board';

  @override
  String get dashboardArmiesSubtitle =>
      'Create, edit and organize all your armies.';

  @override
  String get dashboardBattlesSubtitle =>
      'Prepare your games and check their history.';

  @override
  String get dashboardCollectionSubtitle =>
      'Manage your models, painting and boxes.';

  @override
  String get dashboardStatisticsSubtitle =>
      'Analyze your performance and army progress.';

  @override
  String get dashboardStatArmies => 'Armies';

  @override
  String get dashboardStatArmiesSub => 'Lists created';

  @override
  String get dashboardStatCollection => 'Collection';

  @override
  String get dashboardStatCollectionSub => 'Models owned';

  @override
  String get dashboardStatPoints => 'Total points';

  @override
  String get dashboardStatPointsSub => 'Across all armies';

  @override
  String get dashboardStatPainting => 'Painting progress';

  @override
  String get dashboardStatPaintingSub => 'Models painted';

  @override
  String get dashboardYourArmies => 'Your armies';

  @override
  String get dashboardSeeAll => 'See all';

  @override
  String get dashboardNoArmiesYet => 'No army created yet';

  @override
  String get dashboardPaintingBreakdown => 'Collection status';

  @override
  String get dashboardFactionBreakdown => 'Breakdown by faction';

  @override
  String get dashboardStatusPainted => 'Painted';

  @override
  String get dashboardStatusAssembled => 'Assembled';

  @override
  String get dashboardStatusUnbuilt => 'Unbuilt';

  @override
  String dashboardGreetingNamed(String name) {
    return 'Hello $name';
  }

  @override
  String get dashboardGreetingAnon => 'Hello!';

  @override
  String dashboardEditionLine(String system, String edition) {
    return '$system • $edition';
  }

  @override
  String get dashboardStatModels => 'Models';

  @override
  String get dashboardStatModelsSub => 'Total owned';

  @override
  String get dashboardStatCollectionEntries => 'Collection';

  @override
  String get dashboardStatCollectionEntriesSub => 'Distinct units';

  @override
  String get dashboardStatValue => 'Estimated value';

  @override
  String get dashboardStatValueSub => 'Total purchase price';

  @override
  String get dashboardModifiedToday => 'Today';

  @override
  String get dashboardModifiedYesterday => 'Yesterday';

  @override
  String dashboardModifiedDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String dashboardModifiedLabel(String when) {
    return 'Updated $when';
  }

  @override
  String get dashboardRecentlyViewedTitle => 'Recently viewed';

  @override
  String get dashboardRecentlyViewedEmpty => 'No datasheet viewed yet';

  @override
  String get dashboardFavoritesTitle => 'Favorites';

  @override
  String get dashboardFavoritesEmpty =>
      'Add units to your armies to see your favorites';

  @override
  String get dashboardFavoritesSubtitle => 'Most used across your armies';

  @override
  String get dashboardCollectionValueTitle => 'Collection value';

  @override
  String get dashboardPurchaseTotalLabel => 'Total purchase price';

  @override
  String get dashboardRecentPurchasesTitle => 'Recent additions';

  @override
  String get dashboardRecentPurchasesEmpty => 'No entries recorded yet';

  @override
  String get dashboardSuggestionsTitle => 'Suggestions';

  @override
  String get dashboardSuggestionsEmpty =>
      'Nothing to flag, your collection covers your armies';

  @override
  String dashboardSuggestionMissing(int count, String name) {
    return 'You\'re missing $count $name to complete your armies';
  }

  @override
  String get dashboardHobbyScoreTitle => 'Hobby Score';

  @override
  String get dashboardHobbyScoreCollection => 'Collection';

  @override
  String get dashboardHobbyScorePainting => 'Painting';

  @override
  String get dashboardHobbyScoreGames => 'Games';

  @override
  String get dashboardHobbyScoreOrganization => 'Organization';

  @override
  String get dashboardQuickActionsTitle => 'Quick actions';

  @override
  String get dashboardQuickActionNewArmy => 'Create an army';

  @override
  String get dashboardQuickActionAddToCollection => 'Add to collection';

  @override
  String get dashboardQuickActionOpenCatalog => 'Open the catalog';

  @override
  String get dashboardQuickActionNewBattle => 'New battle';

  @override
  String get dashboardCatalogStatsTitle => 'Catalog stats';

  @override
  String get dashboardStatsUnits => 'Units';

  @override
  String get dashboardStatsProfiles => 'Profiles';

  @override
  String get dashboardStatsWeapons => 'Weapons';

  @override
  String get dashboardStatsAbilities => 'Abilities';

  @override
  String get dashboardStatsKeywords => 'Keywords';

  @override
  String get dashboardLastBattleTitle => 'Last battle played';

  @override
  String get dashboardLastBattleEmpty => 'No battle played yet';

  @override
  String get dashboardNextBattleTitle => 'Next battle';

  @override
  String get dashboardNextBattleEmpty => 'No battle scheduled';

  @override
  String get dashboardViewCalendar => 'View calendar';

  @override
  String get dashboardViewBattleDetails => 'View battle details';

  @override
  String get dashboardProjectsTitle => 'Ongoing projects';

  @override
  String get dashboardProjectsEmpty => 'No project yet';

  @override
  String get dashboardAddProjectHint => 'New project...';

  @override
  String get dashboardSearchHint => 'Search (Ctrl+K)';

  @override
  String get dashboardArmyStatusOk => 'Valid';

  @override
  String get dashboardArmyStatusWarning => 'Warning';

  @override
  String get dashboardCreateArmyShort => 'Create a new army';

  @override
  String get dashboardVersus => 'vs';

  @override
  String get dashboardRecentAdditionsTitle => 'Recent additions';

  @override
  String get dashboardRecentAdditionsEmpty => 'No recent additions';

  @override
  String get battleScheduleLabel => 'Battle date';

  @override
  String get battleLocationLabel => 'Location (optional)';

  @override
  String get battleOpponentFactionLabel => 'Opponent faction (optional)';

  @override
  String get rulesSearchHint => 'Search for a rule, a faction...';

  @override
  String get rulesAddButton => 'Add a rule';

  @override
  String get rulesAddComingSoon =>
      'Adding a custom rule document isn\'t available yet';

  @override
  String rulesComingSoon(String feature) {
    return '$feature: not available yet';
  }

  @override
  String get rulesTabMain => 'Main rules';

  @override
  String get rulesTabAdditional => 'Additional rules';

  @override
  String get rulesCategoryAll => 'All';

  @override
  String get rulesCategoryMain => 'Main rules';

  @override
  String get rulesCategoryMissions => 'Missions';

  @override
  String get rulesCategoryFaqs => 'FAQs';

  @override
  String get rulesCategoryErrata => 'Errata';

  @override
  String get rulesCategoryProfiles => 'Points and profiles';

  @override
  String rulesDocumentsCount(int count) {
    return '$count documents';
  }

  @override
  String get rulesBadgeMain => 'MAIN RULE';

  @override
  String get rulesBadgeCurrent => 'CURRENT';

  @override
  String get rulesBadgeUpToDate => 'Up to date';

  @override
  String get rulesVersionLabel => 'VERSION';

  @override
  String get rulesLastUpdateLabel => 'Last update';

  @override
  String get rulesOpenBook => 'Open the rulebook';

  @override
  String rulesViewErrata(int count) {
    return 'View errata ($count)';
  }

  @override
  String rulesOpenBookSnackbar(String path) {
    return 'PDF stored locally: $path';
  }

  @override
  String get rulesOpenBookMissing => 'No local PDF for this document yet';

  @override
  String get rulesRecentDocuments => 'Recent documents';

  @override
  String get rulesPopularRules => 'Popular rules';

  @override
  String get rulesSeeAll => 'See all';

  @override
  String get rulesHelpTitle => 'Need help?';

  @override
  String get rulesHelpHowToPlay => 'How to play?';

  @override
  String get rulesHelpHowToPlaySub => 'Learn the basics';

  @override
  String get rulesHelpVideos => 'Explainer videos';

  @override
  String get rulesHelpVideosSub => 'Tutorials and examples';

  @override
  String get rulesHelpApplication => 'Applying the rules';

  @override
  String get rulesHelpApplicationSub => 'Practical cases';

  @override
  String get rulesHelpGlossary => 'Glossary';

  @override
  String get rulesHelpGlossarySub => 'All the terms';

  @override
  String get rulesEmpty => 'No document found';

  @override
  String get rulesNoDigitizedContent =>
      'This document has no digitized content in the app yet.';

  @override
  String get rulesBackToList => 'Back to rules';

  @override
  String get profileCommandant => 'Commander';

  @override
  String profileLevelShort(int level) {
    return 'Level $level';
  }

  @override
  String get profilePageTitle => 'Commander profile';

  @override
  String get profilePageSubtitle =>
      'Your hobby progression, across every specialization.';

  @override
  String get profileCategoriesTitle => 'Specializations';

  @override
  String get profileFactionsTitle => 'Factions';

  @override
  String get profileNoFactionXp =>
      'No faction XP yet — paint, assemble, play or grow your collection to get started.';

  @override
  String profileXpProgress(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String get xpCategoryPainting => 'Artist';

  @override
  String get xpCategoryAssembly => 'Hobbyist';

  @override
  String get xpCategoryBattle => 'Strategist';

  @override
  String get xpCategoryCollection => 'Collector';

  @override
  String get xpCategoryLore => 'Archivist';

  @override
  String get battleTypeLabel => 'Game type';

  @override
  String get battleTypeMatched => 'Matched play';

  @override
  String get battleTypeNarrative => 'Narrative';

  @override
  String get battleTypeTournament => 'Tournament';

  @override
  String get battleTypeCrusade => 'Crusade';

  @override
  String get battleSetupTitle => 'New battle setup';

  @override
  String get battleSetupStart => 'Start battle';

  @override
  String get battlePointsLimitLabel => 'Points limit';

  @override
  String get battleMissionPackLabel => 'Mission pack (optional)';

  @override
  String get battleTerrainLabel => 'Terrain (optional)';

  @override
  String get battleLogExistingGame => 'Log a game already played';

  @override
  String get battleDashboardResume => 'Battle in progress';

  @override
  String get battleDashboardResumeSubtitle => 'Resume your ongoing battle';

  @override
  String battleDashboardRound(int round) {
    return 'Round $round';
  }

  @override
  String get battlePhaseCommand => 'Command';

  @override
  String get battlePhaseMovement => 'Movement';

  @override
  String get battlePhaseShooting => 'Shooting';

  @override
  String get battlePhaseCharge => 'Charge';

  @override
  String get battlePhaseFight => 'Fight';

  @override
  String get battlePhaseMorale => 'Morale';

  @override
  String get battleBeginnerModeLabel => 'Beginner mode (show phase rules)';

  @override
  String get battlePhaseHelpCommand =>
      'Resolve Command phase abilities and stratagems, take a Battle-shock test for any unit under half its starting models/wounds, then gain Command Points.';

  @override
  String get battlePhaseHelpMovement =>
      'Move your units — a Normal move, an Advance (roll a die, add to Movement, can\'t shoot or charge after with most weapons), or a Fall Back from combat. Units in Reserves may arrive now if the rules allow it.';

  @override
  String get battlePhaseHelpShooting =>
      'Pick eligible targets in range and line of sight for each unit that hasn\'t fired, then roll to hit, to wound, and let the opponent make saving throws. Remove destroyed models.';

  @override
  String get battlePhaseHelpCharge =>
      'Declare a charge against one or more enemy units within 12\", roll 2D6 for the charge distance, then move the charging unit so it ends within Engagement Range of every unit it charged.';

  @override
  String get battlePhaseHelpFight =>
      'Units pile in, then fight — resolve melee attacks (to hit, to wound, saves), then consolidate. Order and eligibility can vary by rule — check the rulebook if unsure.';

  @override
  String get battlePhaseHelpMorale =>
      'Battle-shock/Morale effects for weakened units — exact rules vary by edition, check the rulebook for the precise trigger and consequences.';

  @override
  String get battleDashboardNextPhase => 'Next phase';

  @override
  String get battleEndOfRoundTitle => 'End of round';

  @override
  String get battleEndOfRoundReminder =>
      'Before moving on, don\'t forget to:\n• Score your primary/secondary objective points\n• Check Battle-shock for any weakened unit\n• Remove temporary effects that expire this round\n• Note down this round\'s losses';

  @override
  String get battleEndOfRoundDismiss => 'Got it';

  @override
  String get battleDashboardScoreTitle => 'Score';

  @override
  String get battleDashboardCpTitle => 'Command points';

  @override
  String get battleDashboardMyCp => 'My CP';

  @override
  String get battleDashboardOpponentCp => 'Opponent CP';

  @override
  String get battleOpponentArmyLabel =>
      'Opponent\'s army (optional, from your saved armies)';

  @override
  String get battleDashboardRoster => 'My roster';

  @override
  String get battleDashboardOpponentRoster => 'Opponent roster';

  @override
  String get battleUnitDestroyed => 'Destroyed';

  @override
  String get battleUnitMarkDestroyed => 'Mark as destroyed';

  @override
  String get battleUnitRestore => 'Restore unit';

  @override
  String get battleUnitModifiersTitle => 'Bonuses / penalties';

  @override
  String get battleUnitAddModifier => 'Add a bonus/penalty';

  @override
  String get battleUnitModifierLabelHint => 'Reason (optional)';

  @override
  String get battleUnitModifierValueHint => 'Value (e.g. 1 or -1)';

  @override
  String get battleUnitViewFullSheet => 'View full datasheet';

  @override
  String get battleUnitNoModifiers => 'No active bonus/penalty';

  @override
  String get battleDashboardEvents => 'Battle log';

  @override
  String get battleDashboardAddEvent => 'Add event';

  @override
  String get battleDashboardEventHint => 'What happened?';

  @override
  String get battleDashboardEventsEmpty => 'No events logged yet';

  @override
  String get battleDashboardNotesTitle => 'Notes';

  @override
  String get battleDashboardNotesHint => 'Write anything worth remembering...';

  @override
  String get battleDetailTitle => 'Battle recap';

  @override
  String get battleDetailBack => 'Back to history';

  @override
  String get battleStratagemAssistantTitle => 'Stratagems for this phase';

  @override
  String get battleStratagemAssistantOpponentTitle =>
      'Opponent stratagems for this phase';

  @override
  String battleStratagemUse(int cp) {
    return 'Use (-$cp CP)';
  }

  @override
  String get battleDashboardFinish => 'Finish battle';
}
