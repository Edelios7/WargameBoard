import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'edition.dart';

@immutable
class GameMode extends Equatable {
  const GameMode({
    required this.id,
    required this.edition,
    required this.name,
    this.description,
    this.minPoints,
    this.maxPoints,
    this.isDefault = false,
    this.isActive = true,
  });

  /// Identifiant unique.
  final String id;

  /// Édition à laquelle appartient ce mode de jeu.
  final Edition edition;

  /// Nom du mode de jeu.
  ///
  /// Exemples :
  /// - Combat Patrol
  /// - Incursion
  /// - Strike Force
  /// - Onslaught
  final String name;

  /// Description optionnelle.
  final String? description;

  /// Nombre minimum de points recommandé.
  final int? minPoints;

  /// Nombre maximum de points recommandé.
  final int? maxPoints;

  /// Indique s'il s'agit du mode par défaut.
  final bool isDefault;

  /// Permet de désactiver un mode sans le supprimer.
  final bool isActive;

  GameMode copyWith({
    String? id,
    Edition? edition,
    String? name,
    String? description,
    int? minPoints,
    int? maxPoints,
    bool? isDefault,
    bool? isActive,
  }) {
    return GameMode(
      id: id ?? this.id,
      edition: edition ?? this.edition,
      name: name ?? this.name,
      description: description ?? this.description,
      minPoints: minPoints ?? this.minPoints,
      maxPoints: maxPoints ?? this.maxPoints,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        edition,
        name,
        description,
        minPoints,
        maxPoints,
        isDefault,
        isActive,
      ];
}