import 'ability_details.dart';
import 'cost_bracket.dart';
import 'equipment_details.dart';
import 'model_details.dart';
import 'unit_details.dart';
import 'weapon_details.dart';

class DatasheetDetails {
  final String id;

  final String name;

  final String? description;

  final String factionId;

  final String factionName;

  final String gameSystemId;

  final String editionId;

  final List<String> keywords;

  final List<AbilityDetails> abilities;

  final List<ModelDetails> models;

  final List<WeaponDetails> weapons;

  final List<EquipmentDetails> equipment;

  /// Groupes d'équipement optionnel (choix d'armes) avec assez de
  /// détail (id d'option, arme liée) pour piloter une sélection dans
  /// l'army builder — contrairement à [equipment] qui n'expose que des
  /// noms pour l'affichage catalogue.
  final List<EquipmentGroupDetails> equipmentGroups;

  final UnitDetails unit;

  final int points;

  /// Paliers de coût connus pour cette datasheet (voir [CostBracket]) —
  /// [points] est déjà le coût résolu pour la taille par défaut de
  /// l'unité ; cette liste permet d'afficher/recalculer le coût pour un
  /// autre effectif (ex. quand l'utilisateur choisit un autre nombre de
  /// figurines dans l'army builder).
  final List<CostBracket> costBrackets;

  const DatasheetDetails({
    required this.id,
    required this.name,
    this.description,
    required this.factionId,
    required this.factionName,
    required this.gameSystemId,
    required this.editionId,
    required this.keywords,
    required this.abilities,
    required this.models,
    required this.weapons,
    required this.equipment,
    this.equipmentGroups = const [],
    required this.unit,
    required this.points,
    this.costBrackets = const [],
  });
}