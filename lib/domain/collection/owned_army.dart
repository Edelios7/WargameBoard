import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'owned_miniature.dart';

@immutable
class OwnedArmy extends Equatable {
  const OwnedArmy({
    required this.id,
    required this.name,
    this.units = const [],
  });

  final String id;
  final String name;

  final List<OwnedMiniature> units;

  OwnedArmy copyWith({
    String? id,
    String? name,
    List<OwnedMiniature>? units,
  }) {
    return OwnedArmy(
      id: id ?? this.id,
      name: name ?? this.name,
      units: units ?? this.units,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        units,
      ];
}