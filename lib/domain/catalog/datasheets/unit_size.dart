import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UnitSize extends Equatable {
  const UnitSize({
    required this.minModels,
    required this.maxModels,
    required this.defaultModels,
  });

  final int minModels;
  final int maxModels;
  final int defaultModels;

  UnitSize copyWith({
    int? minModels,
    int? maxModels,
    int? defaultModels,
  }) {
    return UnitSize(
      minModels: minModels ?? this.minModels,
      maxModels: maxModels ?? this.maxModels,
      defaultModels: defaultModels ?? this.defaultModels,
    );
  }

  @override
  List<Object?> get props => [
        minModels,
        maxModels,
        defaultModels,
      ];
}