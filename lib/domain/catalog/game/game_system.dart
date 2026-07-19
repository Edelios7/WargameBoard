import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class GameSystem extends Equatable {
  const GameSystem({
    required this.id,
    required this.name,
    this.description,
    this.isActive = true,
  });

  /// Identifiant unique.
  final String id;

  /// Nom du système de jeu.
  ///
  /// Exemples :
  /// - Warhammer 40,000
  /// - Age of Sigmar
  /// - Kill Team
  /// - Horus Heresy
  final String name;

  /// Description optionnelle.
  final String? description;

  /// Permet d'archiver un système de jeu sans le supprimer.
  final bool isActive;

  GameSystem copyWith({
    String? id,
    String? name,
    String? description,
    bool? isActive,
  }) {
    return GameSystem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isActive,
      ];
}