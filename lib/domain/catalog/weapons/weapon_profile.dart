import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../common/characteristic_value.dart';
import 'weapon_ability.dart';

@immutable
class WeaponProfile extends Equatable {
  const WeaponProfile({
    required this.id,
    required this.range,
    required this.attacks,
    required this.skill,
    required this.strength,
    required this.armourPenetration,
    required this.damage,
    this.abilities = const [],
  });

  final String id;

  final CharacteristicValue range;
  final CharacteristicValue attacks;
  final CharacteristicValue skill;
  final CharacteristicValue strength;
  final CharacteristicValue armourPenetration;
  final CharacteristicValue damage;

  final List<WeaponAbility> abilities;

  WeaponProfile copyWith({
    String? id,
    CharacteristicValue? range,
    CharacteristicValue? attacks,
    CharacteristicValue? skill,
    CharacteristicValue? strength,
    CharacteristicValue? armourPenetration,
    CharacteristicValue? damage,
    List<WeaponAbility>? abilities,
  }) {
    return WeaponProfile(
      id: id ?? this.id,
      range: range ?? this.range,
      attacks: attacks ?? this.attacks,
      skill: skill ?? this.skill,
      strength: strength ?? this.strength,
      armourPenetration: armourPenetration ?? this.armourPenetration,
      damage: damage ?? this.damage,
      abilities: abilities ?? this.abilities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        range,
        attacks,
        skill,
        strength,
        armourPenetration,
        damage,
        abilities,
      ];
}