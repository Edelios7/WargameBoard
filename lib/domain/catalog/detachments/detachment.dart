import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../abilities/ability.dart';
import '../enhancements/enhancement.dart';
import '../stratagems/stratagem.dart';

@immutable
class Detachment extends Equatable {
  const Detachment({
    required this.id,
    required this.name,
    this.description,
    this.ability,
    this.enhancements = const [],
    this.stratagems = const [],
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? description;

  final Ability? ability;

  final List<Enhancement> enhancements;
  final List<Stratagem> stratagems;

  final bool isActive;

  Detachment copyWith({
    String? id,
    String? name,
    String? description,
    Ability? ability,
    List<Enhancement>? enhancements,
    List<Stratagem>? stratagems,
    bool? isActive,
  }) {
    return Detachment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ability: ability ?? this.ability,
      enhancements: enhancements ?? this.enhancements,
      stratagems: stratagems ?? this.stratagems,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        ability,
        enhancements,
        stratagems,
        isActive,
      ];
}