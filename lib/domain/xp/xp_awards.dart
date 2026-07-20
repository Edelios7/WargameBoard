/// Barème centralisé des gains d'XP (v1 — voir le plan pour les actions
/// volontairement reportées : armée complètement peinte, palier 2000 pts,
/// recherche effectuée, badges/saisons/défis).
library;

/// Classification légère d'une datasheet, utilisée pour moduler l'XP de
/// peinture/montage (une figurine standard ne vaut pas un véhicule).
class DatasheetXpClass {
  final String factionId;
  final bool isCharacterTier;
  final bool isVehicleTier;

  const DatasheetXpClass({
    required this.factionId,
    this.isCharacterTier = false,
    this.isVehicleTier = false,
  });
}

/// -------- Peinture (Artiste) --------
const int paintingXpStandard = 20;
const int paintingXpCharacter = 80;
const int paintingXpVehicle = 120;
const int paintingXpSquadComplete = 100;

int paintingXpPerModel(DatasheetXpClass xpClass) {
  if (xpClass.isCharacterTier) return paintingXpCharacter;
  if (xpClass.isVehicleTier) return paintingXpVehicle;
  return paintingXpStandard;
}

/// -------- Montage (Hobbyiste) --------
const int assemblyXpStandard = 5;
const int assemblyXpVehicle = 25;
const int assemblyXpSquadComplete = 40;

int assemblyXpPerModel(DatasheetXpClass xpClass) {
  if (xpClass.isVehicleTier) return assemblyXpVehicle;
  return assemblyXpStandard;
}

/// -------- Parties (Stratège) --------
const int battleXpPlayed = 100;
const int battleXpResult = 25;
const int battleXpNarrativeBonus = 50;
const int battleXpTournamentBonus = 300;

/// -------- Collection (Collectionneur) --------
const int collectionXpNewBox = 50;
const int collectionXpNewFaction = 500;
const int collectionXpFirstArmy = 100;

/// -------- Archiviste (consultation) --------
const int loreXpDatasheetViewed = 1;
const int loreXpCatalogOpened = 1;
