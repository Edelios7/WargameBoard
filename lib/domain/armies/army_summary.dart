import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ArmySummary extends Equatable {
  const ArmySummary({
    required this.totalUnits,
    required this.totalModels,
    required this.totalPoints,
  });

  final int totalUnits;
  final int totalModels;
  final int totalPoints;

  @override
  List<Object?> get props => [
        totalUnits,
        totalModels,
        totalPoints,
      ];
}