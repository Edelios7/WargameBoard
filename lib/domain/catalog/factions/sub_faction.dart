import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'faction.dart';

@immutable
class SubFaction extends Equatable {
  const SubFaction({
    required this.id,
    required this.faction,
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

  /// Faction parente.
  final Faction faction;

  /// Nom de la sous-faction.
  ///
  /// Exemples :
  /// - Blood Angels
  /// - Ultramarines
  /// - Leviathan
  /// - Goffs
  /// - Saim-Hann
  final String name;

  /// Nom court optionnel.
  final String? shortName;

  /// Description de la sous-faction.
  final String? description;

  /// Chemin vers une icône ou un emblème.
  final String? iconPath;

  /// Couleur principale (hexadécimal).
  ///
  /// Exemple : "#CC0000"
  final String? colorHex;

  /// Indique si la sous-faction est jouable.
  final bool isPlayable;

  /// Permet d'archiver une sous-faction.
  final bool isActive;

  SubFaction copyWith({
    String? id,
    Faction? faction,
    String? name,
    String? shortName,
    String? description,
    String? iconPath,
    String? colorHex,
    bool? isPlayable,
    bool? isActive,
  }) {
    return SubFaction(
      id: id ?? this.id,
      faction: faction ?? this.faction,
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
        faction,
        name,
        shortName,
        description,
        iconPath,
        colorHex,
        isPlayable,
        isActive,
      ];
}