// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSystem _$GameSystemFromJson(Map<String, dynamic> json) => GameSystem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  version: json['version'] as String?,
  logo: json['logo'] as String?,
  enabled: json['enabled'] as bool? ?? true,
);

Map<String, dynamic> _$GameSystemToJson(GameSystem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'version': instance.version,
      'logo': instance.logo,
      'enabled': instance.enabled,
    };
