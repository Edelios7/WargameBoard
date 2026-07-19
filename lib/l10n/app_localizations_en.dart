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
  String get navArmies => 'Armies';

  @override
  String get navBattles => 'Battles';

  @override
  String get navCollection => 'Collection';

  @override
  String get navStatistics => 'Statistics';

  @override
  String get versionLabel => 'Version 0.1';

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
}
