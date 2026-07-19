import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class TerrainFeature extends Equatable {
  const TerrainFeature({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
      ];
}