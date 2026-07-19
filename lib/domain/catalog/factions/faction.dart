import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Faction extends Equatable {
  const Faction({
    required this.id,
    required this.name,
    this.shortName,
    this.description,
    this.iconPath,
    this.colorHex,
    this.isPlayable = true,
    this.isActive = true,
  });

  /// Identifiant unique.
  final String id;

  /// Nom de la faction.
  ///
  /// Exemples :
  /// - Space Marines
  /// - Tyranids
  /// - Orks
  final String name;

  /// Nom court optionnel.
  final String? shortName;

  /// Description de la faction.
  final String? description;

  /// Chemin vers l'icône ou le logo.
  final String? iconPath;

  /// Couleur principale (hexadécimal).
  ///
  /// Exemple : "#0055A4"
  final String? colorHex;

  /// Indique si la faction est jouable.
  final bool isPlayable;

  /// Permet d'archiver une faction.
  final bool isActive;

  Faction copyWith({
    String? id,
    String? name,
    String? shortName,
    String? description,
    String? iconPath,
    String? colorHex,
    bool? isPlayable,
    bool? isActive,
  }) {
    return Faction(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      colorHex: colorHex ?? this.colorHex,
      isPlayable: isPlayable ?? this.isPlayable,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        shortName,
        description,
        iconPath,
        colorHex,
        isPlayable,
        isActive,
      ];
}