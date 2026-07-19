import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'weapon_profile.dart';

@immutable
class Weapon extends Equatable {
  const Weapon({
    required this.id,
    required this.name,
    required this.profiles,
    this.description,
    this.isMelee = false,
    this.isActive = true,
  });

  final String id;
  final String name;
  final List<WeaponProfile> profiles;

  final String? description;

  final bool isMelee;
  final bool isActive;

  Weapon copyWith({
    String? id,
    String? name,
    List<WeaponProfile>? profiles,
    String? description,
    bool? isMelee,
    bool? isActive,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      profiles: profiles ?? this.profiles,
      description: description ?? this.description,
      isMelee: isMelee ?? this.isMelee,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profiles,
        description,
        isMelee,
        isActive,
      ];
}