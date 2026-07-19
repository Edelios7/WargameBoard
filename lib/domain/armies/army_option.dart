import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ArmyOption extends Equatable {
  const ArmyOption({
    required this.id,
    required this.name,
    this.value,
  });

  final String id;
  final String name;
  final String? value;

  @override
  List<Object?> get props => [
        id,
        name,
        value,
      ];
}