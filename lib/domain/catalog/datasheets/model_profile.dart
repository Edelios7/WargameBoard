import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../common/characteristic_value.dart';

@immutable
class ModelProfile extends Equatable {
  const ModelProfile({
    required this.movement,
    required this.toughness,
    required this.save,
    required this.wounds,
    required this.leadership,
    required this.objectiveControl,
    this.invulnerableSave,
  });

  final CharacteristicValue movement;
  final CharacteristicValue toughness;
  final CharacteristicValue save;
  final CharacteristicValue wounds;
  final CharacteristicValue leadership;
  final CharacteristicValue objectiveControl;
  final CharacteristicValue? invulnerableSave;

  ModelProfile copyWith({
    CharacteristicValue? movement,
    CharacteristicValue? toughness,
    CharacteristicValue? save,
    CharacteristicValue? wounds,
    CharacteristicValue? leadership,
    CharacteristicValue? objectiveControl,
    CharacteristicValue? invulnerableSave,
  }) {
    return ModelProfile(
      movement: movement ?? this.movement,
      toughness: toughness ?? this.toughness,
      save: save ?? this.save,
      wounds: wounds ?? this.wounds,
      leadership: leadership ?? this.leadership,
      objectiveControl: objectiveControl ?? this.objectiveControl,
      invulnerableSave: invulnerableSave ?? this.invulnerableSave,
    );
  }

  @override
  List<Object?> get props => [
        movement,
        toughness,
        save,
        wounds,
        leadership,
        objectiveControl,
        invulnerableSave,
      ];
}