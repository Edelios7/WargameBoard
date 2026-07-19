import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../abilities/ability.dart';

@immutable
class Enhancement extends Equatable {
  const Enhancement({
    required this.id,
    required this.name,
    required this.points,
    this.description,
    this.ability,
    this.isActive = true,
  });

  final String id;
  final String name;
  final int points;

  final String? description;

  final Ability? ability;

  final bool isActive;

  Enhancement copyWith({
    String? id,
    String? name,
    int? points,
    String? description,
    Ability? ability,
    bool? isActive,
  }) {
    return Enhancement(
      id: id ?? this.id,
      name: name ?? this.name,
      points: points ?? this.points,
      description: description ?? this.description,
      ability: ability ?? this.ability,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        points,
        description,
        ability,
        isActive,
      ];
}