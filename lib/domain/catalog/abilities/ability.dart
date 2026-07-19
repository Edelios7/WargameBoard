import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Ability extends Equatable {
  const Ability({
    required this.id,
    required this.name,
    this.description,
    this.flavorText,
    this.isCore = false,
    this.isPassive = true,
    this.isActive = true,
  });

  /// Identifiant unique.
  final String id;

  /// Nom de la capacité.
  final String name;

  /// Description complète de la règle.
  final String? description;

  /// Texte d'ambiance optionnel.
  final String? flavorText;

  /// Capacité de base du jeu.
  ///
  /// Exemples :
  /// - Deep Strike
  /// - Leader
  /// - Scouts
  final bool isCore;

  /// Passive ou activable.
  final bool isPassive;

  /// Permet d'archiver la capacité.
  final bool isActive;

  Ability copyWith({
    String? id,
    String? name,
    String? description,
    String? flavorText,
    bool? isCore,
    bool? isPassive,
    bool? isActive,
  }) {
    return Ability(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      flavorText: flavorText ?? this.flavorText,
      isCore: isCore ?? this.isCore,
      isPassive: isPassive ?? this.isPassive,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        flavorText,
        isCore,
        isPassive,
        isActive,
      ];
}