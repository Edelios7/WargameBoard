import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'game_system.dart';

@immutable
class Edition extends Equatable {
  const Edition({
    required this.id,
    required this.gameSystem,
    required this.name,
    required this.version,
    this.releaseDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
  });

  /// Identifiant unique.
  final String id;

  /// Système de jeu auquel appartient cette édition.
  final GameSystem gameSystem;

  /// Nom affiché.
  ///
  /// Exemples :
  /// - 11th Edition
  /// - 10th Edition
  /// - 4th Edition
  final String name;

  /// Numéro d'édition.
  final int version;

  /// Date de sortie.
  final DateTime? releaseDate;

  /// Date de fin (si connue).
  final DateTime? endDate;

  /// Indique si cette édition est la plus récente.
  final bool isCurrent;

  /// Description optionnelle.
  final String? description;

  Edition copyWith({
    String? id,
    GameSystem? gameSystem,
    String? name,
    int? version,
    DateTime? releaseDate,
    DateTime? endDate,
    bool? isCurrent,
    String? description,
  }) {
    return Edition(
      id: id ?? this.id,
      gameSystem: gameSystem ?? this.gameSystem,
      name: name ?? this.name,
      version: version ?? this.version,
      releaseDate: releaseDate ?? this.releaseDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        gameSystem,
        name,
        version,
        releaseDate,
        endDate,
        isCurrent,
        description,
      ];
}