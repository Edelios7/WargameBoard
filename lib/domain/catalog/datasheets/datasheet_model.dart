import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../abilities/ability.dart';
import '../weapons/weapon.dart';
import 'model_profile.dart';

@immutable
class DatasheetModel extends Equatable {
  const DatasheetModel({
    required this.id,
    required this.name,
    required this.profile,
    this.weapons = const [],
    this.abilities = const [],
  });

  final String id;
  final String name;

  final ModelProfile profile;

  final List<Weapon> weapons;

  final List<Ability> abilities;

  DatasheetModel copyWith({
    String? id,
    String? name,
    ModelProfile? profile,
    List<Weapon>? weapons,
    List<Ability>? abilities,
  }) {
    return DatasheetModel(
      id: id ?? this.id,
      name: name ?? this.name,
      profile: profile ?? this.profile,
      weapons: weapons ?? this.weapons,
      abilities: abilities ?? this.abilities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profile,
        weapons,
        abilities,
      ];
}