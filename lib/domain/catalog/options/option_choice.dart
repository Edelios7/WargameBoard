import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class OptionChoice extends Equatable {
  const OptionChoice({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  OptionChoice copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return OptionChoice(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
      ];
}