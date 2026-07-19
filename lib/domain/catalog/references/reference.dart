import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Reference extends Equatable {
  const Reference({
    required this.id,
    required this.source,
    required this.page,
  });

  final String id;
  final String source;
  final int page;

  Reference copyWith({
    String? id,
    String? source,
    int? page,
  }) {
    return Reference(
      id: id ?? this.id,
      source: source ?? this.source,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
        id,
        source,
        page,
      ];
}