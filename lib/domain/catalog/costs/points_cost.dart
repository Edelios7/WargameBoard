import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PointsCost extends Equatable {
  const PointsCost({
    required this.models,
    required this.points,
  });

  final int models;
  final int points;

  PointsCost copyWith({
    int? models,
    int? points,
  }) {
    return PointsCost(
      models: models ?? this.models,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [
        models,
        points,
      ];
}