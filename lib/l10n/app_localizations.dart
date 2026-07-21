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

  /// No description provided for @navRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles'**
  String get navRules;

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

  /// No description provided for @settingsProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get settingsProfileTitle;

  /// No description provided for @settingsDisplayNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ton nom'**
  String get settingsDisplayNameLabel;

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

  /// No description provided for @catalogResetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get catalogResetFilters;

  /// No description provided for @catalogResultsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} résultat(s)'**
  String catalogResultsCount(int count);

  /// No description provided for @catalogFilterAllKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Tous les mots-clés'**
  String get catalogFilterAllKeywords;

  /// No description provided for @catalogFilterAllRoles.
  ///
  /// In fr, this message translates to:
  /// **'Tous les rôles'**
  String get catalogFilterAllRoles;

  /// No description provided for @catalogFilterAllUnitTypes.
  ///
  /// In fr, this message translates to:
  /// **'Tous les types'**
  String get catalogFilterAllUnitTypes;

  /// No description provided for @catalogFilterAllEditions.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les éditions'**
  String get catalogFilterAllEditions;

  /// No description provided for @catalogFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get catalogFilterTitle;

  /// No description provided for @catalogFilterFaction.
  ///
  /// In fr, this message translates to:
  /// **'Faction'**
  String get catalogFilterFaction;

  /// No description provided for @catalogFilterRole.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get catalogFilterRole;

  /// No description provided for @catalogFilterKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Mots-clés'**
  String get catalogFilterKeywords;

  /// No description provided for @catalogFilterCost.
  ///
  /// In fr, this message translates to:
  /// **'Coût (pts)'**
  String get catalogFilterCost;

  /// No description provided for @catalogFilterEdition.
  ///
  /// In fr, this message translates to:
  /// **'Édition'**
  String get catalogFilterEdition;

  /// No description provided for @catalogFilterUnitType.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'unité'**
  String get catalogFilterUnitType;

  /// No description provided for @catalogBreadcrumbAllUnits.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les unités'**
  String get catalogBreadcrumbAllUnits;

  /// No description provided for @catalogSortLabel.
  ///
  /// In fr, this message translates to:
  /// **'Trier par :'**
  String get catalogSortLabel;

  /// No description provided for @catalogSortNameAsc.
  ///
  /// In fr, this message translates to:
  /// **'Nom (A-Z)'**
  String get catalogSortNameAsc;

  /// No description provided for @catalogSortPointsAsc.
  ///
  /// In fr, this message translates to:
  /// **'Points (croissant)'**
  String get catalogSortPointsAsc;

  /// No description provided for @catalogSortPointsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Points (décroissant)'**
  String get catalogSortPointsDesc;

  /// No description provided for @catalogUnitsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} UNITÉS'**
  String catalogUnitsCount(int count);

  /// No description provided for @catalogSeeMore.
  ///
  /// In fr, this message translates to:
  /// **'Voir plus'**
  String get catalogSeeMore;

  /// No description provided for @catalogSeeLess.
  ///
  /// In fr, this message translates to:
  /// **'Voir moins'**
  String get catalogSeeLess;

  /// No description provided for @catalogViewFullSheet.
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche complète'**
  String get catalogViewFullSheet;

  /// No description provided for @catalogBackToCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get catalogBackToCatalog;

  /// No description provided for @sectionDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get sectionDescription;

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

  /// No description provided for @weaponColName.
  ///
  /// In fr, this message translates to:
  /// **'Arme'**
  String get weaponColName;

  /// No description provided for @weaponColRange.
  ///
  /// In fr, this message translates to:
  /// **'Portée'**
  String get weaponColRange;

  /// No description provided for @weaponColAttacks.
  ///
  /// In fr, this message translates to:
  /// **'A'**
  String get weaponColAttacks;

  /// No description provided for @weaponColStrength.
  ///
  /// In fr, this message translates to:
  /// **'F'**
  String get weaponColStrength;

  /// No description provided for @weaponColAp.
  ///
  /// In fr, this message translates to:
  /// **'PA'**
  String get weaponColAp;

  /// No description provided for @weaponColDamage.
  ///
  /// In fr, this message translates to:
  /// **'D'**
  String get weaponColDamage;

  /// No description provided for @weaponMelee.
  ///
  /// In fr, this message translates to:
  /// **'Mêlée'**
  String get weaponMelee;

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

  /// No description provided for @armyBuilderDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer l\'armée'**
  String get armyBuilderDuplicate;

  /// No description provided for @armyBuilderNotesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get armyBuilderNotesLabel;

  /// No description provided for @armyBuilderDuplicateNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la copie'**
  String get armyBuilderDuplicateNameLabel;

  /// No description provided for @armyBuilderDuplicateSuffix.
  ///
  /// In fr, this message translates to:
  /// **'{name} (copie)'**
  String armyBuilderDuplicateSuffix(String name);

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

  /// No description provided for @armyBuilderUnitCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} unités'**
  String armyBuilderUnitCount(int count);

  /// No description provided for @armyBuilderListValid.
  ///
  /// In fr, this message translates to:
  /// **'Liste valide'**
  String get armyBuilderListValid;

  /// No description provided for @armyBuilderListInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Liste invalide'**
  String get armyBuilderListInvalid;

  /// No description provided for @armyBuilderRoleOther.
  ///
  /// In fr, this message translates to:
  /// **'Autres'**
  String get armyBuilderRoleOther;

  /// No description provided for @armyBuilderNoUnitsYet.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des unités pour construire ta liste'**
  String get armyBuilderNoUnitsYet;

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

  /// No description provided for @armyValidationEmptyArmy.
  ///
  /// In fr, this message translates to:
  /// **'Armée vide — ajoute des unités'**
  String get armyValidationEmptyArmy;

  /// No description provided for @armyValidationNoDetachment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun détachement sélectionné'**
  String get armyValidationNoDetachment;

  /// No description provided for @armyValidationTooManyEnhancements.
  ///
  /// In fr, this message translates to:
  /// **'Trop d\'enhancements (max 3)'**
  String get armyValidationTooManyEnhancements;

  /// No description provided for @armyBuilderBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get armyBuilderBack;

  /// No description provided for @armyBuilderStatPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points'**
  String get armyBuilderStatPoints;

  /// No description provided for @armyBuilderStatUnits.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get armyBuilderStatUnits;

  /// No description provided for @armyBuilderStatBattleline.
  ///
  /// In fr, this message translates to:
  /// **'Battleline'**
  String get armyBuilderStatBattleline;

  /// No description provided for @armyBuilderStatEnhancements.
  ///
  /// In fr, this message translates to:
  /// **'Améliorations'**
  String get armyBuilderStatEnhancements;

  /// No description provided for @armyBuilderDetachmentSection.
  ///
  /// In fr, this message translates to:
  /// **'Détachement'**
  String get armyBuilderDetachmentSection;

  /// No description provided for @armyBuilderNoDetachment.
  ///
  /// In fr, this message translates to:
  /// **'Aucun détachement'**
  String get armyBuilderNoDetachment;

  /// No description provided for @armyBuilderRulesSection.
  ///
  /// In fr, this message translates to:
  /// **'Règles'**
  String get armyBuilderRulesSection;

  /// No description provided for @armyBuilderViewAllRules.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les règles'**
  String get armyBuilderViewAllRules;

  /// No description provided for @armyBuilderUnitsSection.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get armyBuilderUnitsSection;

  /// No description provided for @armyBuilderUnitDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails de l\'unité'**
  String get armyBuilderUnitDetailsTitle;

  /// No description provided for @armyBuilderSelectUnitPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez une unité pour voir ses détails'**
  String get armyBuilderSelectUnitPrompt;

  /// No description provided for @armyBuilderEditUnit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'unité'**
  String get armyBuilderEditUnit;

  /// No description provided for @armyBuilderRemoveUnit.
  ///
  /// In fr, this message translates to:
  /// **'Retirer l\'unité'**
  String get armyBuilderRemoveUnit;

  /// No description provided for @armyBuilderModelCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de figurines'**
  String get armyBuilderModelCountLabel;

  /// No description provided for @collectionAddEntry.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la collection'**
  String get collectionAddEntry;

  /// No description provided for @collectionExportCsv.
  ///
  /// In fr, this message translates to:
  /// **'Copier en CSV'**
  String get collectionExportCsv;

  /// No description provided for @collectionExportJson.
  ///
  /// In fr, this message translates to:
  /// **'Copier en JSON'**
  String get collectionExportJson;

  /// No description provided for @collectionExportedToClipboard.
  ///
  /// In fr, this message translates to:
  /// **'Collection copiée dans le presse-papier'**
  String get collectionExportedToClipboard;

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

  /// No description provided for @collectionIncrementQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter 1 à la quantité'**
  String get collectionIncrementQuantity;

  /// No description provided for @collectionQuantityDialogLabel.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get collectionQuantityDialogLabel;

  /// No description provided for @collectionPriceDialogLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix (optionnel)'**
  String get collectionPriceDialogLabel;

  /// No description provided for @collectionSummaryLine.
  ///
  /// In fr, this message translates to:
  /// **'{entries} unités · {models} figurines · {painted} peintes'**
  String collectionSummaryLine(int entries, int models, int painted);

  /// No description provided for @collectionTotalValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur : {value}'**
  String collectionTotalValue(String value);

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

  /// No description provided for @wishlistNotesDialogLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes (optionnel)'**
  String get wishlistNotesDialogLabel;

  /// No description provided for @collectionSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans la collection...'**
  String get collectionSearchHint;

  /// No description provided for @collectionStatArmiesSub.
  ///
  /// In fr, this message translates to:
  /// **'{complete} complètes'**
  String collectionStatArmiesSub(int complete);

  /// No description provided for @collectionStatModelsPaintedSub.
  ///
  /// In fr, this message translates to:
  /// **'Peintes : {count} ({percent}%)'**
  String collectionStatModelsPaintedSub(int count, int percent);

  /// No description provided for @collectionValueTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valeur de la collection'**
  String get collectionValueTitle;

  /// No description provided for @collectionValueUnquantifiedSub.
  ///
  /// In fr, this message translates to:
  /// **'Non quantifiable'**
  String get collectionValueUnquantifiedSub;

  /// No description provided for @collectionValueTierStarting.
  ///
  /// In fr, this message translates to:
  /// **'Naissante'**
  String get collectionValueTierStarting;

  /// No description provided for @collectionValueTierSolid.
  ///
  /// In fr, this message translates to:
  /// **'Solide'**
  String get collectionValueTierSolid;

  /// No description provided for @collectionValueTierEpic.
  ///
  /// In fr, this message translates to:
  /// **'Épique'**
  String get collectionValueTierEpic;

  /// No description provided for @collectionValueTierLegendary.
  ///
  /// In fr, this message translates to:
  /// **'Légendaire'**
  String get collectionValueTierLegendary;

  /// No description provided for @collectionFilterFactionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Faction'**
  String get collectionFilterFactionTitle;

  /// No description provided for @collectionFilterStateTitle.
  ///
  /// In fr, this message translates to:
  /// **'État'**
  String get collectionFilterStateTitle;

  /// No description provided for @collectionStateUnbuilt.
  ///
  /// In fr, this message translates to:
  /// **'Non assemblées'**
  String get collectionStateUnbuilt;

  /// No description provided for @collectionMyArmiesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes armées'**
  String get collectionMyArmiesTitle;

  /// No description provided for @collectionRecentAdditionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouts récents'**
  String get collectionRecentAdditionsTitle;

  /// No description provided for @collectionAllItemsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Toute la collection'**
  String get collectionAllItemsTitle;

  /// No description provided for @collectionNoResultsForFilters.
  ///
  /// In fr, this message translates to:
  /// **'Aucune figurine ne correspond aux filtres'**
  String get collectionNoResultsForFilters;

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

  /// No description provided for @battleNotPlayedYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore jouée (planifiée)'**
  String get battleNotPlayedYet;

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

  /// No description provided for @dashboardStatArmies.
  ///
  /// In fr, this message translates to:
  /// **'Armées'**
  String get dashboardStatArmies;

  /// No description provided for @dashboardStatArmiesSub.
  ///
  /// In fr, this message translates to:
  /// **'Listes créées'**
  String get dashboardStatArmiesSub;

  /// No description provided for @dashboardStatCollection.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get dashboardStatCollection;

  /// No description provided for @dashboardStatCollectionSub.
  ///
  /// In fr, this message translates to:
  /// **'Figurines possédées'**
  String get dashboardStatCollectionSub;

  /// No description provided for @dashboardStatPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points cumulés'**
  String get dashboardStatPoints;

  /// No description provided for @dashboardStatPointsSub.
  ///
  /// In fr, this message translates to:
  /// **'Sur toutes les armées'**
  String get dashboardStatPointsSub;

  /// No description provided for @dashboardStatPainting.
  ///
  /// In fr, this message translates to:
  /// **'Progression peinture'**
  String get dashboardStatPainting;

  /// No description provided for @dashboardStatPaintingSub.
  ///
  /// In fr, this message translates to:
  /// **'Figurines peintes'**
  String get dashboardStatPaintingSub;

  /// No description provided for @dashboardYourArmies.
  ///
  /// In fr, this message translates to:
  /// **'Vos armées'**
  String get dashboardYourArmies;

  /// No description provided for @dashboardSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get dashboardSeeAll;

  /// No description provided for @dashboardNoArmiesYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune armée créée pour l\'instant'**
  String get dashboardNoArmiesYet;

  /// No description provided for @dashboardPaintingBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'État de la collection'**
  String get dashboardPaintingBreakdown;

  /// No description provided for @dashboardFactionBreakdown.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par faction'**
  String get dashboardFactionBreakdown;

  /// No description provided for @dashboardStatusPainted.
  ///
  /// In fr, this message translates to:
  /// **'Peintes'**
  String get dashboardStatusPainted;

  /// No description provided for @dashboardStatusAssembled.
  ///
  /// In fr, this message translates to:
  /// **'Montées'**
  String get dashboardStatusAssembled;

  /// No description provided for @dashboardStatusUnbuilt.
  ///
  /// In fr, this message translates to:
  /// **'Sur grappe'**
  String get dashboardStatusUnbuilt;

  /// No description provided for @dashboardGreetingNamed.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name}'**
  String dashboardGreetingNamed(String name);

  /// No description provided for @dashboardGreetingAnon.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour !'**
  String get dashboardGreetingAnon;

  /// No description provided for @dashboardEditionLine.
  ///
  /// In fr, this message translates to:
  /// **'{system} • {edition}'**
  String dashboardEditionLine(String system, String edition);

  /// No description provided for @dashboardStatModels.
  ///
  /// In fr, this message translates to:
  /// **'Figurines'**
  String get dashboardStatModels;

  /// No description provided for @dashboardStatModelsSub.
  ///
  /// In fr, this message translates to:
  /// **'Total possédé'**
  String get dashboardStatModelsSub;

  /// No description provided for @dashboardStatCollectionEntries.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get dashboardStatCollectionEntries;

  /// No description provided for @dashboardStatCollectionEntriesSub.
  ///
  /// In fr, this message translates to:
  /// **'Unités distinctes'**
  String get dashboardStatCollectionEntriesSub;

  /// No description provided for @dashboardStatValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur estimée'**
  String get dashboardStatValue;

  /// No description provided for @dashboardStatValueSub.
  ///
  /// In fr, this message translates to:
  /// **'Prix d\'achat cumulé'**
  String get dashboardStatValueSub;

  /// No description provided for @dashboardModifiedToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get dashboardModifiedToday;

  /// No description provided for @dashboardModifiedYesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get dashboardModifiedYesterday;

  /// No description provided for @dashboardModifiedDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {days} jours'**
  String dashboardModifiedDaysAgo(int days);

  /// No description provided for @dashboardModifiedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Modifié {when}'**
  String dashboardModifiedLabel(String when);

  /// No description provided for @dashboardRecentlyViewedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernières fiches consultées'**
  String get dashboardRecentlyViewedTitle;

  /// No description provided for @dashboardRecentlyViewedEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune fiche consultée pour l\'instant'**
  String get dashboardRecentlyViewedEmpty;

  /// No description provided for @dashboardFavoritesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get dashboardFavoritesTitle;

  /// No description provided for @dashboardFavoritesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des unités à tes armées pour voir tes favoris'**
  String get dashboardFavoritesEmpty;

  /// No description provided for @dashboardFavoritesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les plus utilisées dans vos armées'**
  String get dashboardFavoritesSubtitle;

  /// No description provided for @dashboardCollectionValueTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valeur de la collection'**
  String get dashboardCollectionValueTitle;

  /// No description provided for @dashboardPurchaseTotalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix d\'achat total'**
  String get dashboardPurchaseTotalLabel;

  /// No description provided for @dashboardRecentPurchasesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Derniers achats'**
  String get dashboardRecentPurchasesTitle;

  /// No description provided for @dashboardRecentPurchasesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun achat enregistré'**
  String get dashboardRecentPurchasesEmpty;

  /// No description provided for @dashboardSuggestionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suggestions'**
  String get dashboardSuggestionsTitle;

  /// No description provided for @dashboardSuggestionsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien à signaler, ta collection couvre tes armées'**
  String get dashboardSuggestionsEmpty;

  /// No description provided for @dashboardSuggestionMissing.
  ///
  /// In fr, this message translates to:
  /// **'Il te manque {count} {name} pour compléter tes armées'**
  String dashboardSuggestionMissing(int count, String name);

  /// No description provided for @dashboardHobbyScoreTitle.
  ///
  /// In fr, this message translates to:
  /// **'Hobby Score'**
  String get dashboardHobbyScoreTitle;

  /// No description provided for @dashboardHobbyScoreCollection.
  ///
  /// In fr, this message translates to:
  /// **'Collection'**
  String get dashboardHobbyScoreCollection;

  /// No description provided for @dashboardHobbyScorePainting.
  ///
  /// In fr, this message translates to:
  /// **'Peinture'**
  String get dashboardHobbyScorePainting;

  /// No description provided for @dashboardHobbyScoreGames.
  ///
  /// In fr, this message translates to:
  /// **'Parties'**
  String get dashboardHobbyScoreGames;

  /// No description provided for @dashboardHobbyScoreOrganization.
  ///
  /// In fr, this message translates to:
  /// **'Organisation'**
  String get dashboardHobbyScoreOrganization;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Accès rapides'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardQuickActionNewArmy.
  ///
  /// In fr, this message translates to:
  /// **'Créer une armée'**
  String get dashboardQuickActionNewArmy;

  /// No description provided for @dashboardQuickActionAddToCollection.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la collection'**
  String get dashboardQuickActionAddToCollection;

  /// No description provided for @dashboardQuickActionOpenCatalog.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le catalogue'**
  String get dashboardQuickActionOpenCatalog;

  /// No description provided for @dashboardQuickActionNewBattle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get dashboardQuickActionNewBattle;

  /// No description provided for @dashboardCatalogStatsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques du catalogue'**
  String get dashboardCatalogStatsTitle;

  /// No description provided for @dashboardStatsUnits.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get dashboardStatsUnits;

  /// No description provided for @dashboardStatsProfiles.
  ///
  /// In fr, this message translates to:
  /// **'Profils'**
  String get dashboardStatsProfiles;

  /// No description provided for @dashboardStatsWeapons.
  ///
  /// In fr, this message translates to:
  /// **'Armes'**
  String get dashboardStatsWeapons;

  /// No description provided for @dashboardStatsAbilities.
  ///
  /// In fr, this message translates to:
  /// **'Capacités'**
  String get dashboardStatsAbilities;

  /// No description provided for @dashboardStatsKeywords.
  ///
  /// In fr, this message translates to:
  /// **'Mots-clés'**
  String get dashboardStatsKeywords;

  /// No description provided for @dashboardLastBattleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernière partie jouée'**
  String get dashboardLastBattleTitle;

  /// No description provided for @dashboardLastBattleEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie jouée pour l\'instant'**
  String get dashboardLastBattleEmpty;

  /// No description provided for @dashboardNextBattleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine partie'**
  String get dashboardNextBattleTitle;

  /// No description provided for @dashboardNextBattleEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune partie programmée'**
  String get dashboardNextBattleEmpty;

  /// No description provided for @dashboardViewCalendar.
  ///
  /// In fr, this message translates to:
  /// **'Voir le calendrier'**
  String get dashboardViewCalendar;

  /// No description provided for @dashboardViewBattleDetails.
  ///
  /// In fr, this message translates to:
  /// **'Voir les détails de la partie'**
  String get dashboardViewBattleDetails;

  /// No description provided for @dashboardProjectsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Projets en cours'**
  String get dashboardProjectsTitle;

  /// No description provided for @dashboardProjectsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun projet pour l\'instant'**
  String get dashboardProjectsEmpty;

  /// No description provided for @dashboardAddProjectHint.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau projet...'**
  String get dashboardAddProjectHint;

  /// No description provided for @dashboardSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher (Ctrl+K)'**
  String get dashboardSearchHint;

  /// No description provided for @dashboardArmyStatusOk.
  ///
  /// In fr, this message translates to:
  /// **'Valide'**
  String get dashboardArmyStatusOk;

  /// No description provided for @dashboardArmyStatusWarning.
  ///
  /// In fr, this message translates to:
  /// **'Attention'**
  String get dashboardArmyStatusWarning;

  /// No description provided for @dashboardCreateArmyShort.
  ///
  /// In fr, this message translates to:
  /// **'Créer une nouvelle armée'**
  String get dashboardCreateArmyShort;

  /// No description provided for @dashboardVersus.
  ///
  /// In fr, this message translates to:
  /// **'vs'**
  String get dashboardVersus;

  /// No description provided for @dashboardRecentAdditionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Derniers ajouts'**
  String get dashboardRecentAdditionsTitle;

  /// No description provided for @dashboardRecentAdditionsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun ajout récent'**
  String get dashboardRecentAdditionsEmpty;

  /// No description provided for @battleScheduleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date de la partie'**
  String get battleScheduleLabel;

  /// No description provided for @battleLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu (optionnel)'**
  String get battleLocationLabel;

  /// No description provided for @battleOpponentFactionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Faction adverse (optionnel)'**
  String get battleOpponentFactionLabel;

  /// No description provided for @rulesSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une règle, une faction...'**
  String get rulesSearchHint;

  /// No description provided for @rulesAddButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une règle'**
  String get rulesAddButton;

  /// No description provided for @rulesTabMain.
  ///
  /// In fr, this message translates to:
  /// **'Règles principales'**
  String get rulesTabMain;

  /// No description provided for @rulesTabAdditional.
  ///
  /// In fr, this message translates to:
  /// **'Règles additionnelles'**
  String get rulesTabAdditional;

  /// No description provided for @rulesCategoryAll.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get rulesCategoryAll;

  /// No description provided for @rulesCategoryMain.
  ///
  /// In fr, this message translates to:
  /// **'Règles principales'**
  String get rulesCategoryMain;

  /// No description provided for @rulesCategoryMissions.
  ///
  /// In fr, this message translates to:
  /// **'Missions'**
  String get rulesCategoryMissions;

  /// No description provided for @rulesCategoryFaqs.
  ///
  /// In fr, this message translates to:
  /// **'FAQs'**
  String get rulesCategoryFaqs;

  /// No description provided for @rulesCategoryErrata.
  ///
  /// In fr, this message translates to:
  /// **'Erratas'**
  String get rulesCategoryErrata;

  /// No description provided for @rulesCategoryProfiles.
  ///
  /// In fr, this message translates to:
  /// **'Points et profils'**
  String get rulesCategoryProfiles;

  /// No description provided for @rulesDocumentsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} documents'**
  String rulesDocumentsCount(int count);

  /// No description provided for @rulesBadgeMain.
  ///
  /// In fr, this message translates to:
  /// **'RÈGLE PRINCIPALE'**
  String get rulesBadgeMain;

  /// No description provided for @rulesBadgeCurrent.
  ///
  /// In fr, this message translates to:
  /// **'ACTUELLE'**
  String get rulesBadgeCurrent;

  /// No description provided for @rulesBadgeUpToDate.
  ///
  /// In fr, this message translates to:
  /// **'À jour'**
  String get rulesBadgeUpToDate;

  /// No description provided for @rulesVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'VERSION'**
  String get rulesVersionLabel;

  /// No description provided for @rulesLastUpdateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Dernière mise à jour'**
  String get rulesLastUpdateLabel;

  /// No description provided for @rulesOpenBook.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le livre de règles'**
  String get rulesOpenBook;

  /// No description provided for @rulesViewErrata.
  ///
  /// In fr, this message translates to:
  /// **'Voir les erratas ({count})'**
  String rulesViewErrata(int count);

  /// No description provided for @rulesOpenBookSnackbar.
  ///
  /// In fr, this message translates to:
  /// **'PDF stocké localement : {path}'**
  String rulesOpenBookSnackbar(String path);

  /// No description provided for @rulesOpenBookMissing.
  ///
  /// In fr, this message translates to:
  /// **'Aucun PDF local pour ce document pour le moment'**
  String get rulesOpenBookMissing;

  /// No description provided for @rulesRecentDocuments.
  ///
  /// In fr, this message translates to:
  /// **'Documents récents'**
  String get rulesRecentDocuments;

  /// No description provided for @rulesPopularRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles populaires'**
  String get rulesPopularRules;

  /// No description provided for @rulesSeeAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get rulesSeeAll;

  /// No description provided for @rulesHelpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d\'aide ?'**
  String get rulesHelpTitle;

  /// No description provided for @rulesHelpHowToPlay.
  ///
  /// In fr, this message translates to:
  /// **'Comment jouer ?'**
  String get rulesHelpHowToPlay;

  /// No description provided for @rulesHelpHowToPlaySub.
  ///
  /// In fr, this message translates to:
  /// **'Apprendre les bases'**
  String get rulesHelpHowToPlaySub;

  /// No description provided for @rulesHelpVideos.
  ///
  /// In fr, this message translates to:
  /// **'Vidéos explicatives'**
  String get rulesHelpVideos;

  /// No description provided for @rulesHelpVideosSub.
  ///
  /// In fr, this message translates to:
  /// **'Tutoriels et exemples'**
  String get rulesHelpVideosSub;

  /// No description provided for @rulesHelpApplication.
  ///
  /// In fr, this message translates to:
  /// **'Application des règles'**
  String get rulesHelpApplication;

  /// No description provided for @rulesHelpApplicationSub.
  ///
  /// In fr, this message translates to:
  /// **'Cas pratiques'**
  String get rulesHelpApplicationSub;

  /// No description provided for @rulesHelpGlossary.
  ///
  /// In fr, this message translates to:
  /// **'Glossaire'**
  String get rulesHelpGlossary;

  /// No description provided for @rulesHelpGlossarySub.
  ///
  /// In fr, this message translates to:
  /// **'Tous les termes'**
  String get rulesHelpGlossarySub;

  /// No description provided for @rulesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun document trouvé'**
  String get rulesEmpty;

  /// No description provided for @profileCommandant.
  ///
  /// In fr, this message translates to:
  /// **'Commandant'**
  String get profileCommandant;

  /// No description provided for @profileLevelShort.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String profileLevelShort(int level);

  /// No description provided for @profilePageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil du Commandant'**
  String get profilePageTitle;

  /// No description provided for @profilePageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta progression dans le hobby, toutes spécialités confondues.'**
  String get profilePageSubtitle;

  /// No description provided for @profileCategoriesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Spécialités'**
  String get profileCategoriesTitle;

  /// No description provided for @profileFactionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Factions'**
  String get profileFactionsTitle;

  /// No description provided for @profileNoFactionXp.
  ///
  /// In fr, this message translates to:
  /// **'Aucune XP de faction pour l\'instant — peins, monte, joue ou agrandis ta collection pour commencer.'**
  String get profileNoFactionXp;

  /// No description provided for @profileXpProgress.
  ///
  /// In fr, this message translates to:
  /// **'{current} / {total} XP'**
  String profileXpProgress(int current, int total);

  /// No description provided for @xpCategoryPainting.
  ///
  /// In fr, this message translates to:
  /// **'Artiste'**
  String get xpCategoryPainting;

  /// No description provided for @xpCategoryAssembly.
  ///
  /// In fr, this message translates to:
  /// **'Hobbyiste'**
  String get xpCategoryAssembly;

  /// No description provided for @xpCategoryBattle.
  ///
  /// In fr, this message translates to:
  /// **'Stratège'**
  String get xpCategoryBattle;

  /// No description provided for @xpCategoryCollection.
  ///
  /// In fr, this message translates to:
  /// **'Collectionneur'**
  String get xpCategoryCollection;

  /// No description provided for @xpCategoryLore.
  ///
  /// In fr, this message translates to:
  /// **'Archiviste'**
  String get xpCategoryLore;

  /// No description provided for @battleTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de partie'**
  String get battleTypeLabel;

  /// No description provided for @battleTypeMatched.
  ///
  /// In fr, this message translates to:
  /// **'Partie normale'**
  String get battleTypeMatched;

  /// No description provided for @battleTypeNarrative.
  ///
  /// In fr, this message translates to:
  /// **'Narrative'**
  String get battleTypeNarrative;

  /// No description provided for @battleTypeTournament.
  ///
  /// In fr, this message translates to:
  /// **'Tournoi'**
  String get battleTypeTournament;
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
