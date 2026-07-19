import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../catalog/factions/faction.dart';
import '../catalog/game/game_mode.dart';
import 'army_unit.dart';

@immutable
class Army extends Equatable {
  const Army({
    required this.id,
    required this.name,
    required this.gameMode,
    required this.faction,
    this.units = const [],
    this.notes,
  });

  final String id;
  final String name;

  final GameMode gameMode;
  final Faction faction;

  final List<ArmyUnit> units;

  final String? notes;

  Army copyWith({
    String? id,
    String? name,
    GameMode? gameMode,
    Faction? faction,
    List<ArmyUnit>? units,
    String? notes,
  }) {
    return Army(
      id: id ?? this.id,
      name: name ?? this.name,
      gameMode: gameMode ?? this.gameMode,
      faction: faction ?? this.faction,
      units: units ?? this.units,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        gameMode,
        faction,
        units,
        notes,
      ];
}