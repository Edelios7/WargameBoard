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

  final List<String> abilities;

  final List<ModelDetails> models;

  final List<WeaponDetails> weapons;

  final List<EquipmentDetails> equipment;

  final UnitDetails unit;

  final int points;

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
    required this.unit,
    required this.points,
  });
}