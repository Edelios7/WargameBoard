import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PowerLevel extends Equatable {
  const PowerLevel({
    required this.value,
  });

  final int value;

  PowerLevel copyWith({
    int? value,
  }) {
    return PowerLevel(
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [value];
}