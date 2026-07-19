import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../abilities/ability.dart';
import '../costs/points_cost.dart';
import '../factions/faction.dart';
import '../factions/sub_faction.dart';
import '../game/game_mode.dart';
import '../keywords/keyword.dart';
import 'datasheet_model.dart';
import 'datasheet_role.dart';
import 'datasheet_type.dart';
import 'unit_size.dart';

@immutable
class Datasheet extends Equatable {
  const Datasheet({
    required this.id,
    required this.name,
    required this.gameMode,
    required this.faction,
    this.subFaction,
    required this.type,
    required this.role,
    required this.unitSize,
    this.models = const [],
    this.abilities = const [],
    this.keywords = const [],
    this.points = const [],
    this.flavorText,
    this.description,
    this.isNamedCharacter = false,
    this.isLegend = false,
    this.isActive = true,
  });

  final String id;

  final String name;

  final GameMode gameMode;

  final Faction faction;

  final SubFaction? subFaction;

  final DatasheetType type;

  final DatasheetRole role;

  final UnitSize unitSize;

  final List<DatasheetModel> models;

  final List<Ability> abilities;

  final List<Keyword> keywords;

  final List<PointsCost> points;

  final String? flavorText;

  final String? description;

  final bool isNamedCharacter;

  final bool isLegend;

  final bool isActive;

  Datasheet copyWith({
    String? id,
    String? name,
    GameMode? gameMode,
    Faction? faction,
    SubFaction? subFaction,
    DatasheetType? type,
    DatasheetRole? role,
    UnitSize? unitSize,
    List<DatasheetModel>? models,
    List<Ability>? abilities,
    List<Keyword>? keywords,
    List<PointsCost>? points,
    String? flavorText,
    String? description,
    bool? isNamedCharacter,
    bool? isLegend,
    bool? isActive,
  }) {
    return Datasheet(
      id: id ?? this.id,
      name: name ?? this.name,
      gameMode: gameMode ?? this.gameMode,
      faction: faction ?? this.faction,
      subFaction: subFaction ?? this.subFaction,
      type: type ?? this.type,
      role: role ?? this.role,
      unitSize: unitSize ?? this.unitSize,
      models: models ?? this.models,
      abilities: abilities ?? this.abilities,
      keywords: keywords ?? this.keywords,
      points: points ?? this.points,
      flavorText: flavorText ?? this.flavorText,
      description: description ?? this.description,
      isNamedCharacter: isNamedCharacter ?? this.isNamedCharacter,
      isLegend: isLegend ?? this.isLegend,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        gameMode,
        faction,
        subFaction,
        type,
        role,
        unitSize,
        models,
        abilities,
        keywords,
        points,
        flavorText,
        description,
        isNamedCharacter,
        isLegend,
        isActive,
      ];
}