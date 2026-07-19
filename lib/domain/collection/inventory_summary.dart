import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class InventorySummary extends Equatable {
  const InventorySummary({
    required this.totalMiniatures,
    required this.assembled,
    required this.painted,
  });

  final int totalMiniatures;
  final int assembled;
  final int painted;

  @override
  List<Object?> get props => [
        totalMiniatures,
        assembled,
        painted,
      ];
}