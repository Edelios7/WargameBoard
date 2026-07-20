import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Wargame Board'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get navCatalog;

  /// No description provided for @navExplorer.
  ///
  /// In fr, this message translates to:
  /// **'Règles'**
  String get navExplorer;

  /// No description provided for @navArmies.
  ///
  /// In fr, this message translates to:
  /// **'Armées'**
  String get navArmies;

  /// No description provided for @navBattles.
  ///
  /// In fr, this message translates to:
  /// **'Batailles'**
  String get navBattles;

  /// No description provided for @navCollection.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @navStatistics.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get navStatistics;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get navSettings;

  /// No description provided for @versionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version 0.1'**
  String get versionLabel;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsImportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Import de données'**
  String get settingsImportTitle;

  /// No description provided for @settingsImportDescription.
  ///
  /// In fr, this message translates to:
  /// **'Importer des datasheets au format JSON (mise à jour si l\'id existe déjà).'**
  String get settingsImportDescription;

  /// No description provided for @settingsImportButton.
  ///
  /// In fr, this message translates to:
  /// **'Importer du JSON'**
  String get settingsImportButton;

  /// No description provided for @settingsImportPasteHint.
  ///
  /// In fr, this message translates to:
  /// **'Colle ici le document JSON...'**
  String get settingsImportPasteHint;

  /// No description provided for @settingsImportRun.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get settingsImportRun;

  /// No description provided for @settingsImportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'{count} éléments importés'**
  String settingsImportSuccess(int count);

  /// No description provided for @catalogSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une unité...'**
  String get catalogSearchHint;

  /// No description provided for @catalogEmptyResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucune unité trouvée'**
  String get catalogEmptyResults;

  /// No description provided for @catalogSelectPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une unité pour voir sa fiche'**
  String get catalogSelectPrompt;

  /// No description provided for @catalogLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement du catalogue : {error}'**
  String catalogLoadError(String error);

  /// No description provided for @catalogFilterAllFactions.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les factions'**
  String get catalogFilterAllFactions;

  /// No description provided for @catalogFilterAllKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Tous les mots-clés'**
  String get catalogFilterAllKeywords;

  /// No description provided for @sectionUnitSize.
  ///
  /// In fr, this message translates to:
  /// **'Effectif'**
  String get sectionUnitSize;

  /// No description provided for @sectionProfiles.
  ///
  /// In fr, this message translates to:
  /// **'Profils'**
  String get sectionProfiles;

  /// No description provided for @sectionWeapons.
  ///
  /// In fr, this message translates to:
  /// **'Armes'**
  String get sectionWeapons;

  /// No description provided for @sectionKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Mots-clés'**
  String get sectionKeywords;

  /// No description provided for @sectionAbilities.
  ///
  /// In fr, this message translates to:
  /// **'Capacités'**
  String get sectionAbilities;

  /// No description provided for @sectionEquipment.
  ///
  /// In fr, this message translates to:
  /// **'Équipement'**
  String get sectionEquipment;

  /// No description provided for @unitSizeRange.
  ///
  /// In fr, this message translates to:
  /// **'{min} - {max} figurines (par défaut : {defaultSize})'**
  String unitSizeRange(int min, int max, int defaultSize);

  /// No description provided for @pointsSuffix.
  ///
  /// In fr, this message translates to:
  /// **'{points} pts'**
  String pointsSuffix(int points);

  /// No description provided for @armyBuilderNewArmy.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle armée'**
  String get armyBuilderNewArmy;

  /// No description provided for @armyBuilderArmyName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'armée'**
  String get armyBuilderArmyName;

  /// No description provided for @armyBuilderFaction.
  ///
  /// In fr, this message translates to:
  /// **'Faction'**
  String get armyBuilderFaction;

  /// No description provided for @armyBuilderCreate.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get armyBuilderCreate;

  /// No description provided for @armyBuilderCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get armyBuilderCancel;

  /// No description provided for @armyBuilderEmptyList.
  ///
  /// In fr, this message translates to:
  /// **'Aucune armée pour l\'instant'**
  String get armyBuilderEmptyList;

  /// No description provided for @armyBuilderSelectPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une armée ou créez-en une nouvelle'**
  String get armyBuilderSelectPrompt;

  /// No description provided for @armyBuilderAddUnit.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une unité'**
  String get armyBuilderAddUnit;

  /// No description provided for @armyBuilderEmptyUnits.
  ///
  /// In fr, this message translates to:
  /// **'Aucune unité dans cette armée'**
  String get armyBuilderEmptyUnits;

  /// No description provided for @armyBuilderDeleteArmy.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'armée'**
  String get armyBuilderDeleteArmy;

  /// No description provided for @armyBuilderCopyList.
  ///
  /// In fr, this message translates to:
  /// **'Copier la liste'**
  String get armyBuilderCopyList;

  /// No description provided for @armyBuilderCopiedToClipboard.
  ///
  /// In fr, this message translates to:
  /// **'Liste copiée dans le presse-papier'**
  String get armyBuilderCopiedToClipboard;

  /// No description provided for @armyBuilderDetachmentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Détachement (optionnel)'**
  String get armyBuilderDetachmentLabel;

  /// No description provided for @armyBuilderDetachmentNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get armyBuilderDetachmentNone;

  /// No description provided for @armyBuilderEnhancementLabel.
  ///
  /// In fr, this message translates to:
  /// **'Enhancement'**
  String get armyBuilderEnhancementLabel;

  /// No description provided for @armyBuilderEnhancementNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun'**
  String get armyBuilderEnhancementNone;

  /// No description provided for @armyBuilderChooseEnhancement.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un enhancement'**
  String get armyBuilderChooseEnhancement;

  /// No description provided for @armyBuilderStratagems.
  ///
  /// In fr, this message translates to:
  /// **'Stratagèmes'**
  String get armyBuilderStratagems;

  /// No description provided for @armyBuilderStratagemCp.
  ///
  /// In fr, this message translates to:
  /// **'{cp} PC'**
  String armyBuilderStratagemCp(int cp);

  /// No description provided for @armyBuilderNoStratagems.
  ///
  /// In fr, this message translates to:
  /// **'Aucun stratagème pour ce détachement'**
  String get armyBuilderNoStratagems;

  /// No description provided for @armyBuilderModelCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} figurines'**
  String armyBuilderModelCount(int count);

  /// No description provided for @armyBuilderPointsLimitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Limite de points (optionnel)'**
  String get armyBuilderPointsLimitLabel;

  /// No description provided for @armyBuilderPointsWithLimit.
  ///
  /// In fr, this message translates to:
  /// **'{points} / {limit} pts'**
  String armyBuilderPointsWithLimit(int points, int limit);

  /// No description provided for @armyBuilderOverLimit.
  ///
  /// In fr, this message translates to:
  /// **'Limite de points dépassée'**
  String get armyBuilderOverLimit;

  /// No description provided for @collectionAddEntry.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la collection'**
  String get collectionAddEntry;

  /// No description provided for @collectionEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ta collection est vide'**
  String get collectionEmpty;

  /// No description provided for @collectionQuantityLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count} possédées'**
  String collectionQuantityLabel(int count);

  /// No description provided for @collectionAssembled.
  ///
  /// In fr, this message translates to:
  /// **'Montées'**
  String get collectionAssembled;

  /// No description provided for @collectionPrimed.
  ///
  /// In fr, this message translates to:
  /// **'Apprêtées'**
  String get collectionPrimed;

  /// No description provided for @collectionPainted.
  ///
  /// In fr, this message translates to:
  /// **'Peintes'**
  String get collectionPainted;

  /// No description provided for @collectionQuantityDialogLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get collectionQuantityDialogLabel;

  /// No description provided for @collectionSummaryLine.
  ///
  /// In fr, this message translates to:
  /// **'{entries} unités · {models} figurines · {painted} peintes'**
  String collectionSummaryLine(int entries, int models, int painted);

  /// No description provided for @collectionTabOwned.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get collectionTabOwned;

  /// No description provided for @collectionTabWishlist.
  ///
  /// In fr, this message translates to:
  /// **'Liste d\'envies'**
  String get collectionTabWishlist;

  /// No description provided for @wishlistAddItem.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la liste d\'envies'**
  String get wishlistAddItem;

  /// No description provided for @wishlistEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ta liste d\'envies est vide'**
  String get wishlistEmpty;

  /// No description provided for @wishlistMoveToCollection.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme acquis'**
  String get wishlistMoveToCollection;

  /// No description provided for @statsArmiesCount.
  ///
  /// In fr, this message translates to:
  /// **'Armées créées'**
  String get statsArmiesCount;

  /// No description provided for @statsCollectionEntries.
  ///
  /// In fr, this message translates to:
  /// **'Unités en collection'**
  String get statsCollectionEntries;

  /// No description provided for @statsCollectionModels.
  ///
  /// In fr, this message translates to:
  /// **'Figurines en collection'**
  String get statsCollectionModels;

  /// No description provided for @statsCollectionPainted.
  ///
  /// In fr, this message translates to:
  /// **'Figurines peintes'**
  String get statsCollectionPainted;

  /// No description provided for @statsPaintingProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progression peinture'**
  String get statsPaintingProgress;

  /// No description provided for @statsPointsByArmy.
  ///
  /// In fr, this message translates to:
  /// **'Points par armée'**
  String get statsPointsByArmy;

  /// No description provided for @statsNoArmies.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore d\'armée créée'**
  String get statsNoArmies;

  /// No description provided for @statsNoCollection.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de figurines en collection'**
  String get statsNoCollection;

  /// No description provided for @statsGamesPlayed.
  ///
  /// In fr, this message translates to:
  /// **'Parties jouées'**
  String get statsGamesPlayed;

  /// No description provided for @statsVictories.
  ///
  /// In fr, this message translates to:
  /// **'Victoires'**
  String get statsVictories;

  /// No description provided for @statsDefeats.
  ///
  /// In fr, this message translates to:
  /// **'Défaites'**
  String get statsDefeats;

  /// No description provided for @statsWinRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de victoire'**
  String get statsWinRate;

  /// No description provided for @statsBattleRecord.
  ///
  /// In fr, this message translates to:
  /// **'Bilan {victories}V / {defeats}D / {draws}N'**
  String statsBattleRecord(int victories, int defeats, int draws);

  /// No description provided for @battleNewBattle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get battleNewBattle;

  /// No description provided for @battleOpponentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adversaire'**
  String get battleOpponentLabel;

  /// No description provided for @battleMissionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mission'**
  String get battleMissionLabel;

  /// No description provided for @battleArmyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Armée utilisée'**
  String get battleArmyLabel;

  /// No description provided for @battleArmyNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get battleArmyNone;

  /// No description provided for @battleResultLabel.
  ///
  /// In fr, this message translates to:
  /// **'Résultat'**
  String get battleResultLabel;

  /// No description provided for @battleResultVictory.
  ///
  /// In fr, this message translates to:
  /// **'Victoire'**
  String get battleResultVictory;

  /// No description provided for @battleResultDefeat.
  ///
  /// In fr, this message translates to:
  /// **'Défaite'**
  String get battleResultDefeat;

  /// No description provided for @battleResultDraw.
  ///
  /// In fr, this message translates to:
  /// **'Match nul'**
  String get battleResultDraw;

  /// No description provided for @battleMyScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mon score'**
  String get battleMyScoreLabel;

  /// No description provided for @battleOpponentScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Score adverse'**
  String get battleOpponentScoreLabel;

  /// No description provided for @battleNotesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes (optionnel)'**
  String get battleNotesLabel;

  /// No description provided for @battleEmptyList.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie enregistrée'**
  String get battleEmptyList;

  /// No description provided for @battleScoreLine.
  ///
  /// In fr, this message translates to:
  /// **'{my} - {opponent}'**
  String battleScoreLine(int my, int opponent);

  /// No description provided for @dashboardWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Wargame Board'**
  String get dashboardWelcome;

  /// No description provided for @dashboardArmiesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Crée, modifie et organise toutes tes armées.'**
  String get dashboardArmiesSubtitle;

  /// No description provided for @dashboardBattlesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Prépare tes parties et consulte leur historique.'**
  String get dashboardBattlesSubtitle;

  /// No description provided for @dashboardCollectionSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gère tes figurines, peintures et boîtes.'**
  String get dashboardCollectionSubtitle;

  /// No description provided for @dashboardStatisticsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse tes performances et l\'évolution de tes armées.'**
  String get dashboardStatisticsSubtitle;

  /// No description provided for @explorerTabKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Mots-clés'**
  String get explorerTabKeywords;

  /// No description provided for @explorerTabAbilities.
  ///
  /// In fr, this message translates to:
  /// **'Capacités'**
  String get explorerTabAbilities;

  /// No description provided for @explorerSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une règle...'**
  String get explorerSearchHint;

  /// No description provided for @explorerEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune règle trouvée'**
  String get explorerEmpty;

  /// No description provided for @explorerViewInCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Voir les unités'**
  String get explorerViewInCatalog;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
