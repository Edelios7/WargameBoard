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
  String get navRules => 'Règles';

  @override
  String get navArmies => 'Armées';

  @override
  String get navBattles => 'Batailles';

  @override
  String get navCollection => 'Collection';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get versionLabel => 'Version 0.1';

  @override
  String get settingsProfileTitle => 'Profil';

  @override
  String get settingsDisplayNameLabel => 'Ton nom';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsImportTitle => 'Import de données';

  @override
  String get settingsImportDescription =>
      'Importer des datasheets au format JSON (mise à jour si l\'id existe déjà).';

  @override
  String get settingsImportButton => 'Importer du JSON';

  @override
  String get settingsBackupTitle => 'Sauvegarde';

  @override
  String get settingsBackupDescription =>
      'Tes données (armées, collection, historique de parties...) ne vivent que sur cette machine — exporte une sauvegarde de temps en temps pour ne rien perdre en cas de problème.';

  @override
  String get settingsBackupExportButton => 'Exporter';

  @override
  String settingsBackupExportSuccess(String path) {
    return 'Sauvegarde enregistrée : $path';
  }

  @override
  String get settingsBackupExportError =>
      'Impossible d\'enregistrer la sauvegarde';

  @override
  String get settingsBackupRestoreButton => 'Restaurer';

  @override
  String get settingsBackupRestoreConfirmTitle =>
      'Restaurer cette sauvegarde ?';

  @override
  String get settingsBackupRestoreConfirmBody =>
      'Toutes les données actuelles (armées, collection, historique de parties...) seront remplacées par celles de la sauvegarde choisie. Cette action est irréversible. L\'application doit être relancée pour l\'appliquer.';

  @override
  String get settingsBackupRestoreConfirmAction =>
      'Restaurer et relancer plus tard';

  @override
  String get settingsBackupRestoreStaged =>
      'Sauvegarde prête — ferme et relance l\'application pour l\'appliquer.';

  @override
  String get settingsBackupRestoreCancel =>
      'Annuler la restauration en attente';

  @override
  String get settingsImportPasteHint => 'Colle ici le document JSON...';

  @override
  String get settingsImportRun => 'Importer';

  @override
  String settingsImportSuccess(int count) {
    return '$count éléments importés';
  }

  @override
  String get catalogSearchHint => 'Rechercher une unité...';

  @override
  String get catalogEmptyResults => 'Aucune unité trouvée';

  @override
  String get catalogAddFavoriteTooltip => 'Ajouter aux favoris';

  @override
  String get catalogRemoveFavoriteTooltip => 'Retirer des favoris';

  @override
  String get catalogFavoritesOnlyOn => 'Afficher uniquement les favoris';

  @override
  String get catalogFavoritesOnlyOff => 'Afficher toutes les fiches';

  @override
  String get catalogSelectPrompt => 'Sélectionnez une unité pour voir sa fiche';

  @override
  String catalogLoadError(String error) {
    return 'Erreur de chargement du catalogue : $error';
  }

  @override
  String get catalogFilterAllFactions => 'Toutes les factions';

  @override
  String get catalogResetFilters => 'Réinitialiser';

  @override
  String catalogResultsCount(int count) {
    return '$count résultat(s)';
  }

  @override
  String get catalogFilterAllKeywords => 'Tous les mots-clés';

  @override
  String get catalogFilterAllRoles => 'Tous les rôles';

  @override
  String get catalogFilterAllUnitTypes => 'Tous les types';

  @override
  String get catalogFilterAllEditions => 'Toutes les éditions';

  @override
  String get catalogFilterTitle => 'Filtres';

  @override
  String get catalogQuickAccessFactions => 'Accès rapide aux factions';

  @override
  String get catalogFilterFaction => 'Faction';

  @override
  String get catalogFilterRole => 'Rôle';

  @override
  String get catalogFilterKeywords => 'Mots-clés';

  @override
  String get catalogAddKeywordFilter => 'Ajouter un mot-clé';

  @override
  String get catalogKeywordSearchHint => 'Rechercher un mot-clé...';

  @override
  String catalogOwnedBadge(int count) {
    return 'Possédé ×$count';
  }

  @override
  String get catalogAllFactionsChip => 'Toutes';

  @override
  String get catalogActiveFiltersTitle => 'Filtres actifs';

  @override
  String get catalogApplyFilters => 'Appliquer';

  @override
  String get catalogFilterCost => 'Coût (pts)';

  @override
  String get catalogFilterEdition => 'Édition';

  @override
  String get catalogFilterUnitType => 'Type d\'unité';

  @override
  String get catalogBreadcrumbAllUnits => 'Toutes les unités';

  @override
  String catalogCostBracketLabel(int models, int points) {
    return '$models fig. : $points pts';
  }

  @override
  String get catalogSortLabel => 'Trier par :';

  @override
  String get catalogSortNameAsc => 'Nom (A-Z)';

  @override
  String get catalogSortPointsAsc => 'Points (croissant)';

  @override
  String get catalogSortPointsDesc => 'Points (décroissant)';

  @override
  String catalogUnitsCount(int count) {
    return '$count UNITÉS';
  }

  @override
  String get catalogSeeMore => 'Voir plus';

  @override
  String get catalogSeeLess => 'Voir moins';

  @override
  String get catalogViewFullSheet => 'Voir la fiche complète';

  @override
  String get catalogBackToCatalog => 'Catalogue';

  @override
  String get catalogWeaponsButton => 'Armes';

  @override
  String get catalogWeaponsTitle => 'Inventaire des armes';

  @override
  String get catalogWeaponsSearchHint => 'Rechercher une arme...';

  @override
  String catalogWeaponsCount(int count) {
    return '$count armes';
  }

  @override
  String get catalogWeaponsFilterAll => 'Toutes';

  @override
  String get catalogWeaponsFilterRanged => 'Tir';

  @override
  String get catalogWeaponsFilterMelee => 'Mêlée';

  @override
  String get catalogWeaponsFilterMissingProfile => 'Profil manquant';

  @override
  String catalogWeaponsUsedBy(int count) {
    return '$count fiches';
  }

  @override
  String get catalogWeaponsNoProfile => 'Aucun profil de statistiques importé';

  @override
  String get catalogWeaponsEmpty => 'Aucune arme ne correspond';

  @override
  String get sectionDescription => 'Description';

  @override
  String get sectionUnitSize => 'Effectif';

  @override
  String get statMovement => 'Mouvement';

  @override
  String get statToughness => 'Endurance';

  @override
  String get statSave => 'Sauvegarde';

  @override
  String get statWounds => 'Points de vie';

  @override
  String get statLeadership => 'Commandement';

  @override
  String get statObjectiveControl => 'Contrôle d\'objectif';

  @override
  String get sectionProfiles => 'Profils';

  @override
  String get sectionWeapons => 'Armes';

  @override
  String get weaponColName => 'Arme';

  @override
  String get weaponColRange => 'Portée';

  @override
  String get weaponColAttacks => 'A';

  @override
  String get weaponColStrength => 'F';

  @override
  String get weaponColAp => 'PA';

  @override
  String get weaponColDamage => 'D';

  @override
  String get weaponMelee => 'Mêlée';

  @override
  String get sectionKeywords => 'Mots-clés';

  @override
  String get sectionAbilities => 'Capacités';

  @override
  String get abilityGenericRuleTag => 'Règle générique';

  @override
  String get abilityNoTextAvailable =>
      'Règle propre à la faction — texte non disponible dans cette fiche, voir le livre de règles.';

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
  String get armyBuilderCopyList => 'Copier la liste';

  @override
  String get armyBuilderCopiedToClipboard =>
      'Liste copiée dans le presse-papier';

  @override
  String get armyBuilderDuplicate => 'Dupliquer l\'armée';

  @override
  String get armyBuilderDuplicateUnit => 'Dupliquer l\'unité';

  @override
  String armyBuilderOwnedShortage(int owned, int needed) {
    return 'Tu ne possèdes que $owned figurine(s) sur $needed nécessaires dans cette armée.';
  }

  @override
  String get armyBuilderChangeDetachment => 'Changer de détachement';

  @override
  String get armyBuilderOnlyOwnedFilter => 'Uniquement ma collection';

  @override
  String get armyBuilderToBuy => 'À acheter';

  @override
  String armyBuilderEnhancementsReset(int count) {
    return '$count amélioration(s) réinitialisée(s) suite au changement de détachement.';
  }

  @override
  String get armyBuilderWarlord => 'Warlord';

  @override
  String get armyBuilderSetWarlord => 'Désigner comme Warlord';

  @override
  String get armyBuilderUnsetWarlord => 'Retirer le statut de Warlord';

  @override
  String get armyValidationNoWarlord => 'Aucun Warlord désigné';

  @override
  String get armyBuilderNotesLabel => 'Notes';

  @override
  String get armyBuilderDuplicateNameLabel => 'Nom de la copie';

  @override
  String armyBuilderDuplicateSuffix(String name) {
    return '$name (copie)';
  }

  @override
  String get armyBuilderDetachmentLabel => 'Détachement (optionnel)';

  @override
  String get armyBuilderDetachmentNone => 'Aucun';

  @override
  String get armyBuilderEnhancementLabel => 'Enhancement';

  @override
  String get armyBuilderEnhancementNone => 'Aucun';

  @override
  String get armyBuilderChooseEnhancement => 'Choisir un enhancement';

  @override
  String get armyBuilderStratagems => 'Stratagèmes';

  @override
  String armyBuilderStratagemCp(int cp) {
    return '$cp PC';
  }

  @override
  String get armyBuilderNoStratagems => 'Aucun stratagème pour ce détachement';

  @override
  String armyBuilderModelCount(int count) {
    return '$count figurines';
  }

  @override
  String armyBuilderUnitCount(int count) {
    return '$count unités';
  }

  @override
  String get armyBuilderListValid => 'Liste valide';

  @override
  String get armyBuilderListInvalid => 'Liste invalide';

  @override
  String get armyBuilderRoleOther => 'Autres';

  @override
  String get armyBuilderNoUnitsYet =>
      'Ajoute des unités pour construire ta liste';

  @override
  String get armyBuilderPointsLimitLabel => 'Limite de points (optionnel)';

  @override
  String armyBuilderPointsWithLimit(int points, int limit) {
    return '$points / $limit pts';
  }

  @override
  String get armyBuilderOverLimit => 'Limite de points dépassée';

  @override
  String get armyValidationEmptyArmy => 'Armée vide — ajoute des unités';

  @override
  String get armyValidationNoDetachment => 'Aucun détachement sélectionné';

  @override
  String get armyValidationTooManyEnhancements =>
      'Trop d\'enhancements (max 3)';

  @override
  String get armyBuilderBack => 'Retour';

  @override
  String get armyBuilderStatPoints => 'Points';

  @override
  String get armyBuilderStatUnits => 'Unités';

  @override
  String get armyBuilderStatBattleline => 'Battleline';

  @override
  String get armyBuilderStatEnhancements => 'Améliorations';

  @override
  String get armyBuilderDetachmentSection => 'Détachement';

  @override
  String get armyBuilderNoDetachment => 'Aucun détachement';

  @override
  String get armyBuilderRulesSection => 'Règles';

  @override
  String get armyBuilderViewAllRules => 'Voir toutes les règles';

  @override
  String get armyBuilderUnitsSection => 'Unités';

  @override
  String get armyBuilderUnitDetailsTitle => 'Détails de l\'unité';

  @override
  String get armyBuilderSelectUnitPrompt =>
      'Sélectionnez une unité pour voir ses détails';

  @override
  String get armyBuilderEditUnit => 'Modifier l\'unité';

  @override
  String get armyBuilderRemoveUnit => 'Retirer l\'unité';

  @override
  String get armyBuilderModelCountLabel => 'Nombre de figurines';

  @override
  String get armyBuilderPickOne => 'Choisis une option';

  @override
  String armyBuilderPickUpTo(int count) {
    return 'Choisis jusqu\'à $count options';
  }

  @override
  String get armyBuilderSave => 'Enregistrer';

  @override
  String get armyBuilderRemoveUnitConfirmTitle => 'Retirer cette unité ?';

  @override
  String armyBuilderRemoveUnitConfirmMessage(String name) {
    return '$name sera retirée de la liste. Cette action est définitive.';
  }

  @override
  String get armyBuilderDeleteArmyConfirmTitle => 'Supprimer cette armée ?';

  @override
  String armyBuilderDeleteArmyConfirmMessage(String name) {
    return '$name et toutes ses unités seront supprimées définitivement.';
  }

  @override
  String get collectionAddEntry => 'Ajouter à la collection';

  @override
  String get collectionExportTooltip => 'Exporter';

  @override
  String get collectionExportCsv => 'Copier en CSV';

  @override
  String get collectionExportJson => 'Copier en JSON';

  @override
  String get collectionSortTooltip => 'Trier';

  @override
  String get collectionSortName => 'Nom (A-Z)';

  @override
  String get collectionSortDateAdded => 'Date d\'ajout (plus récent d\'abord)';

  @override
  String get collectionSortPainted => '% peint';

  @override
  String get collectionSelectionStart => 'Sélection multiple';

  @override
  String get collectionSelectionCancel => 'Annuler la sélection';

  @override
  String collectionSelectionCount(int count) {
    return '$count sélectionnée(s)';
  }

  @override
  String get collectionSelectionMarkPainted => 'Marquer entièrement peint';

  @override
  String get collectionExportedToClipboard =>
      'Collection copiée dans le presse-papier';

  @override
  String get collectionEmpty => 'Ta collection est vide';

  @override
  String collectionQuantityLabel(int count) {
    return '$count possédées';
  }

  @override
  String get collectionAssembled => 'Montées';

  @override
  String get collectionPrimed => 'Apprêtées';

  @override
  String get collectionPainted => 'Peintes';

  @override
  String get collectionIncrementQuantity =>
      'Ajouter le nombre saisi à la quantité';

  @override
  String get collectionDecrementQuantity =>
      'Retirer le nombre saisi à la quantité';

  @override
  String get collectionStepFieldTooltip => 'Nombre à ajouter ou retirer';

  @override
  String get collectionQuickAccessFactions => 'Accès rapide aux factions';

  @override
  String get collectionDeleteEntryTooltip => 'Retirer de la collection';

  @override
  String get collectionChoosePhoto => 'Choisir une photo';

  @override
  String get collectionRemovePhoto => 'Retirer la photo';

  @override
  String get collectionPhotoTooltip => 'Photo de l\'unité';

  @override
  String get collectionPhotoSaveError => 'Impossible d\'enregistrer la photo';

  @override
  String get collectionDeleteConfirmTitle => 'Retirer cette entrée ?';

  @override
  String collectionDeleteConfirmMessage(String name) {
    return 'Cela retirera $name et sa progression de montage/peinture de votre collection.';
  }

  @override
  String get collectionDeleteConfirmAction => 'Retirer';

  @override
  String get collectionQuantityDialogLabel => 'Quantité';

  @override
  String get collectionPriceDialogLabel => 'Prix (optionnel)';

  @override
  String collectionSummaryLine(int entries, int models, int painted) {
    return '$entries unités · $models figurines · $painted peintes';
  }

  @override
  String collectionTotalValue(String value) {
    return 'Valeur : $value';
  }

  @override
  String get collectionTabOwned => 'Collection';

  @override
  String get collectionTabWishlist => 'Liste d\'envies';

  @override
  String get wishlistAddItem => 'Ajouter à la liste d\'envies';

  @override
  String get wishlistEmpty => 'Ta liste d\'envies est vide';

  @override
  String get wishlistMoveToCollection => 'Marquer comme acquis';

  @override
  String get wishlistNotesDialogLabel => 'Notes (optionnel)';

  @override
  String get collectionSearchHint => 'Rechercher dans la collection...';

  @override
  String collectionStatArmiesSub(int complete) {
    return '$complete complètes';
  }

  @override
  String collectionStatModelsPaintedSub(int count, int percent) {
    return 'Peintes : $count ($percent%)';
  }

  @override
  String get collectionValueTitle => 'Valeur de la collection';

  @override
  String get collectionValueUnquantifiedSub => 'Non quantifiable';

  @override
  String get collectionValueTierStarting => 'Naissante';

  @override
  String get collectionValueTierSolid => 'Solide';

  @override
  String get collectionValueTierEpic => 'Épique';

  @override
  String get collectionValueTierLegendary => 'Légendaire';

  @override
  String get collectionFilterFactionTitle => 'Faction';

  @override
  String get collectionFilterStateTitle => 'État';

  @override
  String get collectionStateUnbuilt => 'Non assemblées';

  @override
  String get collectionMyArmiesTitle => 'Mes armées';

  @override
  String get collectionRecentAdditionsTitle => 'Ajouts récents';

  @override
  String get collectionAllItemsTitle => 'Toute la collection';

  @override
  String get collectionNoResultsForFilters =>
      'Aucune figurine ne correspond aux filtres';

  @override
  String get statsArmiesCount => 'Armées créées';

  @override
  String get statsCollectionEntries => 'Unités en collection';

  @override
  String get statsCollectionModels => 'Figurines en collection';

  @override
  String get statsCollectionPainted => 'Figurines peintes';

  @override
  String get statsPaintingProgress => 'Progression peinture';

  @override
  String get statsPointsByArmy => 'Points par armée';

  @override
  String get statsNoArmies => 'Pas encore d\'armée créée';

  @override
  String get statsNoCollection => 'Pas encore de figurines en collection';

  @override
  String get statsProgressionTitle => 'Progression';

  @override
  String get statsRecentFormTitle => 'Forme récente';

  @override
  String get statsBattleOutcomesTitle => 'Victoires / défaites / nuls';

  @override
  String get statsBattlesByFactionTitle => 'Parties par faction adverse';

  @override
  String get statsUnknownFaction => 'Faction inconnue';

  @override
  String get statsGamesPlayed => 'Parties jouées';

  @override
  String get statsVictories => 'Victoires';

  @override
  String get statsDefeats => 'Défaites';

  @override
  String get statsWinRate => 'Taux de victoire';

  @override
  String statsBattleRecord(int victories, int defeats, int draws) {
    return 'Bilan ${victories}V / ${defeats}D / ${draws}N';
  }

  @override
  String get battleNewBattle => 'Nouvelle partie';

  @override
  String get battleOpponentLabel => 'Adversaire';

  @override
  String get battleMissionLabel => 'Mission';

  @override
  String get battleArmyLabel => 'Armée utilisée';

  @override
  String get battleArmyNone => 'Aucune';

  @override
  String get battleResultLabel => 'Résultat';

  @override
  String get battleResultVictory => 'Victoire';

  @override
  String get battleResultDefeat => 'Défaite';

  @override
  String get battleResultDraw => 'Match nul';

  @override
  String get battleNotPlayedYet => 'Pas encore jouée (planifiée)';

  @override
  String get battleMyScoreLabel => 'Mon score';

  @override
  String get battleOpponentScoreLabel => 'Score adverse';

  @override
  String get battleNotesLabel => 'Notes (optionnel)';

  @override
  String get battleEmptyList => 'Aucune partie enregistrée';

  @override
  String battleScoreLine(int my, int opponent) {
    return '$my - $opponent';
  }

  @override
  String get dashboardWelcome => 'Bienvenue sur Wargame Board';

  @override
  String get dashboardArmiesSubtitle =>
      'Crée, modifie et organise toutes tes armées.';

  @override
  String get dashboardBattlesSubtitle =>
      'Prépare tes parties et consulte leur historique.';

  @override
  String get dashboardCollectionSubtitle =>
      'Gère tes figurines, peintures et boîtes.';

  @override
  String get dashboardStatisticsSubtitle =>
      'Analyse tes performances et l\'évolution de tes armées.';

  @override
  String get dashboardStatArmies => 'Armées';

  @override
  String get dashboardStatArmiesSub => 'Listes créées';

  @override
  String get dashboardStatCollection => 'Collection';

  @override
  String get dashboardStatCollectionSub => 'Figurines possédées';

  @override
  String get dashboardStatPoints => 'Points cumulés';

  @override
  String get dashboardStatPointsSub => 'Sur toutes les armées';

  @override
  String get dashboardStatPainting => 'Progression peinture';

  @override
  String get dashboardStatPaintingSub => 'Figurines peintes';

  @override
  String get dashboardYourArmies => 'Vos armées';

  @override
  String get dashboardSeeAll => 'Voir tout';

  @override
  String get dashboardNoArmiesYet => 'Aucune armée créée pour l\'instant';

  @override
  String get dashboardPaintingBreakdown => 'État de la collection';

  @override
  String get dashboardFactionBreakdown => 'Répartition par faction';

  @override
  String get dashboardStatusPainted => 'Peintes';

  @override
  String get dashboardStatusAssembled => 'Montées';

  @override
  String get dashboardStatusUnbuilt => 'Sur grappe';

  @override
  String dashboardGreetingNamed(String name) {
    return 'Bonjour $name';
  }

  @override
  String get dashboardGreetingAnon => 'Bonjour !';

  @override
  String dashboardEditionLine(String system, String edition) {
    return '$system • $edition';
  }

  @override
  String get dashboardStatModels => 'Figurines';

  @override
  String get dashboardStatModelsSub => 'Total possédé';

  @override
  String get dashboardStatCollectionEntries => 'Collection';

  @override
  String get dashboardStatCollectionEntriesSub => 'Unités distinctes';

  @override
  String get dashboardStatValue => 'Valeur estimée';

  @override
  String get dashboardStatValueSub => 'Prix d\'achat cumulé';

  @override
  String get dashboardModifiedToday => 'Aujourd\'hui';

  @override
  String get dashboardModifiedYesterday => 'Hier';

  @override
  String dashboardModifiedDaysAgo(int days) {
    return 'Il y a $days jours';
  }

  @override
  String dashboardModifiedLabel(String when) {
    return 'Modifié $when';
  }

  @override
  String get dashboardRecentlyViewedTitle => 'Dernières fiches consultées';

  @override
  String get dashboardRecentlyViewedEmpty =>
      'Aucune fiche consultée pour l\'instant';

  @override
  String get dashboardFavoritesTitle => 'Favoris';

  @override
  String get dashboardFavoritesEmpty =>
      'Ajoute des unités à tes armées pour voir tes favoris';

  @override
  String get dashboardFavoritesSubtitle => 'Les plus utilisées dans vos armées';

  @override
  String get dashboardCollectionValueTitle => 'Valeur de la collection';

  @override
  String get dashboardPurchaseTotalLabel => 'Prix d\'achat total';

  @override
  String get dashboardRecentPurchasesTitle => 'Derniers achats';

  @override
  String get dashboardRecentPurchasesEmpty => 'Aucun achat enregistré';

  @override
  String get dashboardSuggestionsTitle => 'Suggestions';

  @override
  String get dashboardSuggestionsEmpty =>
      'Rien à signaler, ta collection couvre tes armées';

  @override
  String dashboardSuggestionMissing(int count, String name) {
    return 'Il te manque $count $name pour compléter tes armées';
  }

  @override
  String get dashboardHobbyScoreTitle => 'Hobby Score';

  @override
  String get dashboardHobbyScoreCollection => 'Collection';

  @override
  String get dashboardHobbyScorePainting => 'Peinture';

  @override
  String get dashboardHobbyScoreGames => 'Parties';

  @override
  String get dashboardHobbyScoreOrganization => 'Organisation';

  @override
  String get dashboardQuickActionsTitle => 'Accès rapides';

  @override
  String get dashboardQuickActionNewArmy => 'Créer une armée';

  @override
  String get dashboardQuickActionAddToCollection => 'Ajouter à la collection';

  @override
  String get dashboardQuickActionOpenCatalog => 'Ouvrir le catalogue';

  @override
  String get dashboardQuickActionNewBattle => 'Nouvelle partie';

  @override
  String get dashboardCatalogStatsTitle => 'Statistiques du catalogue';

  @override
  String get dashboardStatsUnits => 'Unités';

  @override
  String get dashboardStatsProfiles => 'Profils';

  @override
  String get dashboardStatsWeapons => 'Armes';

  @override
  String get dashboardStatsAbilities => 'Capacités';

  @override
  String get dashboardStatsKeywords => 'Mots-clés';

  @override
  String get dashboardLastBattleTitle => 'Dernière partie jouée';

  @override
  String get dashboardLastBattleEmpty => 'Aucune partie jouée pour l\'instant';

  @override
  String get dashboardNextBattleTitle => 'Prochaine partie';

  @override
  String get dashboardNextBattleEmpty => 'Aucune partie programmée';

  @override
  String get dashboardViewCalendar => 'Voir le calendrier';

  @override
  String get dashboardViewBattleDetails => 'Voir les détails de la partie';

  @override
  String get dashboardProjectsTitle => 'Projets en cours';

  @override
  String get dashboardProjectsEmpty => 'Aucun projet pour l\'instant';

  @override
  String get dashboardAddProjectHint => 'Nouveau projet...';

  @override
  String get dashboardSearchHint => 'Rechercher (Ctrl+K)';

  @override
  String get dashboardArmyStatusOk => 'Valide';

  @override
  String get dashboardArmyStatusWarning => 'Attention';

  @override
  String get dashboardCreateArmyShort => 'Créer une nouvelle armée';

  @override
  String get dashboardVersus => 'vs';

  @override
  String get dashboardRecentAdditionsTitle => 'Derniers ajouts';

  @override
  String get dashboardRecentAdditionsEmpty => 'Aucun ajout récent';

  @override
  String get battleScheduleLabel => 'Date de la partie';

  @override
  String get battleLocationLabel => 'Lieu (optionnel)';

  @override
  String get battleOpponentFactionLabel => 'Faction adverse (optionnel)';

  @override
  String get rulesSearchHint => 'Rechercher une règle, une faction...';

  @override
  String get rulesAddButton => 'Ajouter une règle';

  @override
  String get rulesAddComingSoon =>
      'L\'ajout d\'un document de règles personnalisé n\'est pas encore disponible';

  @override
  String rulesComingSoon(String feature) {
    return '$feature : pas encore disponible';
  }

  @override
  String get rulesTabMain => 'Règles principales';

  @override
  String get rulesTabAdditional => 'Règles additionnelles';

  @override
  String get rulesCategoryAll => 'Toutes';

  @override
  String get rulesCategoryMain => 'Règles principales';

  @override
  String get rulesCategoryMissions => 'Missions';

  @override
  String get rulesCategoryFaqs => 'FAQs';

  @override
  String get rulesCategoryErrata => 'Erratas';

  @override
  String get rulesCategoryProfiles => 'Points et profils';

  @override
  String rulesDocumentsCount(int count) {
    return '$count documents';
  }

  @override
  String get rulesBadgeMain => 'RÈGLE PRINCIPALE';

  @override
  String get rulesBadgeCurrent => 'ACTUELLE';

  @override
  String get rulesBadgeUpToDate => 'À jour';

  @override
  String get rulesVersionLabel => 'VERSION';

  @override
  String get rulesLastUpdateLabel => 'Dernière mise à jour';

  @override
  String get rulesOpenBook => 'Ouvrir le livre de règles';

  @override
  String rulesViewErrata(int count) {
    return 'Voir les erratas ($count)';
  }

  @override
  String rulesOpenBookSnackbar(String path) {
    return 'PDF stocké localement : $path';
  }

  @override
  String get rulesOpenBookMissing =>
      'Aucun PDF local pour ce document pour le moment';

  @override
  String get rulesRecentDocuments => 'Documents récents';

  @override
  String get rulesPopularRules => 'Règles populaires';

  @override
  String get rulesSeeAll => 'Voir tout';

  @override
  String get rulesHelpTitle => 'Besoin d\'aide ?';

  @override
  String get rulesHelpHowToPlay => 'Comment jouer ?';

  @override
  String get rulesHelpHowToPlaySub => 'Apprendre les bases';

  @override
  String get rulesHelpVideos => 'Vidéos explicatives';

  @override
  String get rulesHelpVideosSub => 'Tutoriels et exemples';

  @override
  String get rulesHelpApplication => 'Application des règles';

  @override
  String get rulesHelpApplicationSub => 'Cas pratiques';

  @override
  String get rulesHelpGlossary => 'Glossaire';

  @override
  String get rulesHelpGlossarySub => 'Tous les termes';

  @override
  String get rulesEmpty => 'Aucun document trouvé';

  @override
  String get rulesNoDigitizedContent =>
      'Ce document n\'a pas encore de contenu numérisé dans l\'application.';

  @override
  String get rulesBackToList => 'Retour aux règles';

  @override
  String get profileCommandant => 'Commandant';

  @override
  String profileLevelShort(int level) {
    return 'Niveau $level';
  }

  @override
  String get profilePageTitle => 'Profil du Commandant';

  @override
  String get profilePageSubtitle =>
      'Ta progression dans le hobby, toutes spécialités confondues.';

  @override
  String get profileCategoriesTitle => 'Spécialités';

  @override
  String get profileFactionsTitle => 'Factions';

  @override
  String get profileNoFactionXp =>
      'Aucune XP de faction pour l\'instant — peins, monte, joue ou agrandis ta collection pour commencer.';

  @override
  String profileXpProgress(int current, int total) {
    return '$current / $total XP';
  }

  @override
  String get xpCategoryPainting => 'Artiste';

  @override
  String get xpCategoryAssembly => 'Hobbyiste';

  @override
  String get xpCategoryBattle => 'Stratège';

  @override
  String get xpCategoryCollection => 'Collectionneur';

  @override
  String get xpCategoryLore => 'Archiviste';

  @override
  String get battleTypeLabel => 'Type de partie';

  @override
  String get battleTypeMatched => 'Partie normale';

  @override
  String get battleTypeNarrative => 'Narrative';

  @override
  String get battleTypeTournament => 'Tournoi';

  @override
  String get battleTypeCrusade => 'Croisade';

  @override
  String get battleSetupTitle => 'Préparation de la partie';

  @override
  String get battleSetupHint =>
      'Tous les champs ci-dessous sont facultatifs — renseigne ce qui t\'aidera à retrouver cette partie plus tard.';

  @override
  String get battleSetupStart => 'Lancer la partie';

  @override
  String get battlePointsLimitLabel => 'Format (points)';

  @override
  String get battleMissionPackLabel => 'Pack de missions (optionnel)';

  @override
  String get battleTerrainLabel => 'Terrain (optionnel)';

  @override
  String get battleLogExistingGame => 'Enregistrer une partie déjà jouée';

  @override
  String get battleDashboardResume => 'Partie en cours';

  @override
  String get battleDashboardResumeSubtitle => 'Reprendre la partie en cours';

  @override
  String battleDashboardRound(int round) {
    return 'Round $round';
  }

  @override
  String get battlePhaseCommand => 'Commandement';

  @override
  String get battlePhaseMovement => 'Mouvement';

  @override
  String get battlePhaseShooting => 'Tir';

  @override
  String get battlePhaseCharge => 'Charge';

  @override
  String get battlePhaseFight => 'Combat';

  @override
  String get battlePhaseMorale => 'Moral';

  @override
  String get battleBeginnerModeLabel =>
      'Mode débutant (afficher les règles de la phase)';

  @override
  String get battlePhaseHelpCommand =>
      'Résous les capacités et stratagèmes de phase de Commandement, fais un test de Choc des bataillons pour toute unité en dessous de la moitié de son effectif/ses PV de départ, puis gagne tes Command Points.';

  @override
  String get battlePhaseHelpMovement =>
      'Déplace tes unités : mouvement Normal, Avancer (lance un dé, ajoute-le au Mouvement, empêche généralement de tirer/charger ensuite), ou Repli hors d\'un combat. Les unités en réserve peuvent arriver maintenant si les règles le permettent.';

  @override
  String get battlePhaseHelpShooting =>
      'Choisis pour chaque unité qui n\'a pas encore tiré des cibles à portée et en ligne de vue, lance les jets Pour Toucher, Pour Blesser, laisse l\'adversaire faire ses sauvegardes, puis retire les pertes.';

  @override
  String get battlePhaseHelpCharge =>
      'Déclare une charge contre une ou plusieurs unités ennemies à moins de 12\", lance 2D6 pour la distance de charge, puis déplace l\'unité chargeante pour qu\'elle termine à portée d\'engagement de toutes les unités ciblées.';

  @override
  String get battlePhaseHelpFight =>
      'Les unités se rapprochent (Pile in), puis combattent : jets Pour Toucher, Pour Blesser, sauvegardes, puis regroupement (Consolidate). L\'ordre et l\'éligibilité peuvent varier selon les règles — vérifie le livre de règles en cas de doute.';

  @override
  String get battlePhaseHelpMorale =>
      'Effets de Choc des bataillons/Moral pour les unités affaiblies — les règles exactes varient selon l\'édition, vérifie le livre de règles pour le déclencheur et les conséquences précises.';

  @override
  String get battleDashboardNextPhase => 'Phase suivante';

  @override
  String get battleEndOfRoundTitle => 'Fin de round';

  @override
  String get battleEndOfRoundReminder =>
      'Avant de continuer, pense à :\n• Marquer tes points d\'objectifs primaire/secondaires\n• Vérifier le Choc des bataillons pour les unités affaiblies\n• Retirer les effets temporaires qui expirent ce round\n• Noter les pertes de ce round';

  @override
  String get battleEndOfRoundDismiss => 'Compris';

  @override
  String get battleDashboardScoreTitle => 'Score';

  @override
  String get battleDashboardCpTitle => 'Points de commandement';

  @override
  String get battleDashboardMyCp => 'Mes PC';

  @override
  String get battleDashboardOpponentCp => 'PC adverses';

  @override
  String get battleOpponentArmyLabel =>
      'Armée adverse (optionnel, parmi tes armées enregistrées)';

  @override
  String get battleDashboardRoster => 'Mon roster';

  @override
  String get battleDashboardOpponentRoster => 'Roster adverse';

  @override
  String get battleUnitDestroyed => 'Détruite';

  @override
  String get battleUnitMarkDestroyed => 'Marquer comme détruite';

  @override
  String get battleUnitRestore => 'Restaurer l\'unité';

  @override
  String get battleUnitManageTooltip =>
      'Toucher pour gérer cette unité (PV, dégâts, bonus/malus)';

  @override
  String battleUnitManageTooltipWithModifiers(int count) {
    return '$count bonus/malus actif(s) — toucher pour gérer cette unité';
  }

  @override
  String get battleUnitViewTooltip => 'Toucher pour voir la fiche';

  @override
  String get battleUnitWoundsTitle => 'PV';

  @override
  String get battleUnitWoundsSingleLabel => 'PV';

  @override
  String battleUnitWoundsModelLabel(int index) {
    return 'Modèle $index';
  }

  @override
  String get battleUnitModifiersTitle => 'Bonus / malus';

  @override
  String get battleUnitAddModifier => 'Ajouter un bonus/malus';

  @override
  String get battleUnitModifierLabelHint => 'Raison (optionnel)';

  @override
  String get battleUnitModifierValueHint => 'Valeur (ex. 1 ou -1)';

  @override
  String get battleUnitViewFullSheet => 'Voir la fiche complète';

  @override
  String get battleUnitStatsTitle => 'Caractéristiques';

  @override
  String get battleUnitWeaponsTitle => 'Armes';

  @override
  String get battleUnitNoModifiers => 'Aucun bonus/malus actif';

  @override
  String get battleDashboardEvents => 'Journal de bataille';

  @override
  String get battleDashboardAddEvent => 'Ajouter un événement';

  @override
  String get battleDashboardEventHint => 'Que s\'est-il passé ?';

  @override
  String get battleDashboardEventsEmpty =>
      'Aucun événement enregistré pour l\'instant';

  @override
  String get battleDashboardUndoEvent => 'Annuler cet événement';

  @override
  String get battleDiceTitle => 'Lanceur de dés';

  @override
  String get battleDiceCount => 'Dés';

  @override
  String get battleDiceRoll => 'Lancer';

  @override
  String get battleDiceEmpty => 'Lance pour voir les résultats';

  @override
  String get battleDiceTotal => 'Total';

  @override
  String get battleDiceLogRoll => 'Ajouter au journal';

  @override
  String get battleDashboardNotesTitle => 'Notes';

  @override
  String get battleDashboardNotesHint =>
      'Note tout ce qui vaut la peine d\'être retenu...';

  @override
  String get battleDetailTitle => 'Récapitulatif de la partie';

  @override
  String get battleDetailBack => 'Retour à l\'historique';

  @override
  String get battleStratagemAssistantTitle => 'Stratagèmes pour cette phase';

  @override
  String get battleStratagemAssistantOpponentTitle =>
      'Stratagèmes adverses pour cette phase';

  @override
  String battleStratagemUse(int cp) {
    return 'Utiliser (-$cp PC)';
  }

  @override
  String get battleDashboardFinish => 'Terminer la partie';
}
