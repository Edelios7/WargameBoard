import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ArmyValidation extends Equatable {
  const ArmyValidation({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  final bool isValid;

  final List<String> errors;

  final List<String> warnings;

  @override
  List<Object?> get props => [
        isValid,
        errors,
        warnings,
      ];
}