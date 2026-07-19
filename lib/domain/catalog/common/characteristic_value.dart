import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class CharacteristicValue extends Equatable {
  const CharacteristicValue({
    required this.value,
    this.modifiedValue,
  });

  final String value;
  final String? modifiedValue;

  CharacteristicValue copyWith({
    String? value,
    String? modifiedValue,
  }) {
    return CharacteristicValue(
      value: value ?? this.value,
      modifiedValue: modifiedValue ?? this.modifiedValue,
    );
  }

  @override
  List<Object?> get props => [
        value,
        modifiedValue,
      ];
}