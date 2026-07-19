import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../catalog/datasheets/datasheet.dart';

@immutable
class OwnedMiniature extends Equatable {
  const OwnedMiniature({
    required this.id,
    required this.datasheet,
    required this.quantity,
    this.assembled = 0,
    this.primed = 0,
    this.painted = 0,
  });

  final String id;
  final Datasheet datasheet;
  final int quantity;

  final int assembled;
  final int primed;
  final int painted;

  OwnedMiniature copyWith({
    String? id,
    Datasheet? datasheet,
    int? quantity,
    int? assembled,
    int? primed,
    int? painted,
  }) {
    return OwnedMiniature(
      id: id ?? this.id,
      datasheet: datasheet ?? this.datasheet,
      quantity: quantity ?? this.quantity,
      assembled: assembled ?? this.assembled,
      primed: primed ?? this.primed,
      painted: painted ?? this.painted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        datasheet,
        quantity,
        assembled,
        primed,
        painted,
      ];
}