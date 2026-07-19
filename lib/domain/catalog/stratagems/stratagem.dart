import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Stratagem extends Equatable {
  const Stratagem({
    required this.id,
    required this.name,
    required this.commandPoints,
    this.description,
    this.isActive = true,
  });

  final String id;
  final String name;

  final int commandPoints;

  final String? description;

  final bool isActive;

  Stratagem copyWith({
    String? id,
    String? name,
    int? commandPoints,
    String? description,
    bool? isActive,
  }) {
    return Stratagem(
      id: id ?? this.id,
      name: name ?? this.name,
      commandPoints: commandPoints ?? this.commandPoints,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        commandPoints,
        description,
        isActive,
      ];
}