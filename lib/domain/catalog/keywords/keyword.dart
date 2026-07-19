import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Keyword extends Equatable {
  const Keyword({
    required this.id,
    required this.name,
    this.description,
    this.isFactionKeyword = false,
    this.isCoreKeyword = false,
    this.isActive = true,
  });

  /// Identifiant unique.
  final String id;

  /// Nom du mot-clé.
  ///
  /// Exemples :
  /// - Infantry
  /// - Character
  /// - Vehicle
  /// - Fly
  /// - Adeptus Astartes
  /// - Blood Angels
  final String name;

  /// Description optionnelle.
  final String? description;

  /// Indique si le mot-clé est spécifique à une faction.
  ///
  /// Exemple :
  /// - Adeptus Astartes
  /// - Blood Angels
  final bool isFactionKeyword;

  /// Indique si c'est un mot-clé de base du jeu.
  ///
  /// Exemple :
  /// - Infantry
  /// - Character
  /// - Vehicle
  /// - Monster
  final bool isCoreKeyword;

  /// Permet d'archiver le mot-clé.
  final bool isActive;

  Keyword copyWith({
    String? id,
    String? name,
    String? description,
    bool? isFactionKeyword,
    bool? isCoreKeyword,
    bool? isActive,
  }) {
    return Keyword(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isFactionKeyword: isFactionKeyword ?? this.isFactionKeyword,
      isCoreKeyword: isCoreKeyword ?? this.isCoreKeyword,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        isFactionKeyword,
        isCoreKeyword,
        isActive,
      ];
}