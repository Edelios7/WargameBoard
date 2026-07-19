import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_system.g.dart';

@JsonSerializable()
class GameSystem extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? version;
  final String? logo;
  final bool enabled;

  const GameSystem({
    required this.id,
    required this.name,
    this.description,
    this.version,
    this.logo,
    this.enabled = true,
  });

  factory GameSystem.fromJson(Map<String, dynamic> json) =>
      _$GameSystemFromJson(json);

  Map<String, dynamic> toJson() => _$GameSystemToJson(this);

  GameSystem copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    String? logo,
    bool? enabled,
  }) {
    return GameSystem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      logo: logo ?? this.logo,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        version,
        logo,
        enabled,
      ];
}