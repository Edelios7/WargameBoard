import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../catalog/datasheets/datasheet.dart';

@immutable
class ArmyUnit extends Equatable {
  const ArmyUnit({
    required this.id,
    required this.datasheet,
    required this.modelCount,
  });

  final String id;
  final Datasheet datasheet;

  final int modelCount;

  ArmyUnit copyWith({
    String? id,
    Datasheet? datasheet,
    int? modelCount,
  }) {
    return ArmyUnit(
      id: id ?? this.id,
      datasheet: datasheet ?? this.datasheet,
      modelCount: modelCount ?? this.modelCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        datasheet,
        modelCount,
      ];
}