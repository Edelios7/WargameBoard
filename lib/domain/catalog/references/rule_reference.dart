import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class RuleReference extends Equatable {
  const RuleReference({
    required this.book,
    required this.page,
  });

  final String book;
  final int page;

  @override
  List<Object?> get props => [
        book,
        page,
      ];
}