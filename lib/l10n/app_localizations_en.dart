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
  String get navExplorer => 'Rules';

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
  String get catalogFilterAllKeywords => 'All keywords';

  @override
  String get sectionUnitSize => 'Unit size';

  @override
  String get sectionProfiles => 'Profiles';

  @override
  String get sectionWeapons => 'Weapons';

  @override
  String get sectionKeywords => 'Keywords';

  @override
  String get sectionAbilities => 'Abilities';

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
  String get collectionAddEntry => 'Add to collection';

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
  String get explorerTabKeywords => 'Keywords';

  @override
  String get explorerTabAbilities => 'Abilities';

  @override
  String get explorerSearchHint => 'Search for a rule...';

  @override
  String get explorerEmpty => 'No rule found';

  @override
  String get explorerViewInCatalog => 'View units';
}
