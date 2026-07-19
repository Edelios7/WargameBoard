import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class OwnedBox extends Equatable {
  const OwnedBox({
    required this.id,
    required this.name,
    this.opened = false,
  });

  final String id;
  final String name;
  final bool opened;

  @override
  List<Object?> get props => [
        id,
        name,
        opened,
      ];
}