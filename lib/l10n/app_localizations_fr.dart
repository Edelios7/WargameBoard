// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Wargame Board';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navCatalog => 'Catalogue';

  @override
  String get navArmies => 'Armées';

  @override
  String get navBattles => 'Batailles';

  @override
  String get navCollection => 'Collection';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get versionLabel => 'Version 0.1';

  @override
  String get catalogSearchHint => 'Rechercher une unité...';

  @override
  String get catalogEmptyResults => 'Aucune unité trouvée';

  @override
  String get catalogSelectPrompt => 'Sélectionnez une unité pour voir sa fiche';

  @override
  String catalogLoadError(String error) {
    return 'Erreur de chargement du catalogue : $error';
  }

  @override
  String get sectionUnitSize => 'Effectif';

  @override
  String get sectionProfiles => 'Profils';

  @override
  String get sectionWeapons => 'Armes';

  @override
  String get sectionKeywords => 'Mots-clés';

  @override
  String get sectionAbilities => 'Capacités';

  @override
  String get sectionEquipment => 'Équipement';

  @override
  String unitSizeRange(int min, int max, int defaultSize) {
    return '$min - $max figurines (par défaut : $defaultSize)';
  }

  @override
  String pointsSuffix(int points) {
    return '$points pts';
  }

  @override
  String get armyBuilderNewArmy => 'Nouvelle armée';

  @override
  String get armyBuilderArmyName => 'Nom de l\'armée';

  @override
  String get armyBuilderFaction => 'Faction';

  @override
  String get armyBuilderCreate => 'Créer';

  @override
  String get armyBuilderCancel => 'Annuler';

  @override
  String get armyBuilderEmptyList => 'Aucune armée pour l\'instant';

  @override
  String get armyBuilderSelectPrompt =>
      'Sélectionnez une armée ou créez-en une nouvelle';

  @override
  String get armyBuilderAddUnit => 'Ajouter une unité';

  @override
  String get armyBuilderEmptyUnits => 'Aucune unité dans cette armée';

  @override
  String get armyBuilderDeleteArmy => 'Supprimer l\'armée';

  @override
  String armyBuilderModelCount(int count) {
    return '$count figurines';
  }

  @override
  String get armyBuilderPointsLimitLabel => 'Limite de points (optionnel)';

  @override
  String armyBuilderPointsWithLimit(int points, int limit) {
    return '$points / $limit pts';
  }

  @override
  String get armyBuilderOverLimit => 'Limite de points dépassée';
}
