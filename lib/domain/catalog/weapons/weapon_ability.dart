import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class WeaponAbility extends Equatable {
  const WeaponAbility({
    required this.id,
    required this.name,
    this.description,
    this.value,
    this.isCore = false,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? description;

  /// Valeur éventuelle.
  /// Exemples :
  /// Sustained Hits 2
  /// Devastating Wounds 4+
  final String? value;

  final bool isCore;
  final bool isActive;

  WeaponAbility copyWith({
    String? id,
    String? name,
    String? description,
    String? value,
    bool? isCore,
    bool? isActive,
  }) {
    return WeaponAbility(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
      isCore: isCore ?? this.isCore,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        value,
        isCore,
        isActive,
      ];
}