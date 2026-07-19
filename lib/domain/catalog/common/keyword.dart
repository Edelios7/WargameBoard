import 'package:equatable/equatable.dart';

class Keyword extends Equatable {
  final String id;
  final String gameSystemId;

  final String name;
  final String description;

  final bool core;
  final bool enabled;

  const Keyword({
    required this.id,
    required this.gameSystemId,
    required this.name,
    required this.description,
    this.core = false,
    this.enabled = true,
  });

  Keyword copyWith({
    String? id,
    String? gameSystemId,
    String? name,
    String? description,
    bool? core,
    bool? enabled,
  }) {
    return Keyword(
      id: id ?? this.id,
      gameSystemId: gameSystemId ?? this.gameSystemId,
      name: name ?? this.name,
      description: description ?? this.description,
      core: core ?? this.core,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        gameSystemId,
        name,
        description,
        core,
        enabled,
      ];
}