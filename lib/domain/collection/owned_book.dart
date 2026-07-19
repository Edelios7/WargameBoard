import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class OwnedBook extends Equatable {
  const OwnedBook({
    required this.id,
    required this.title,
    this.edition,
  });

  final String id;
  final String title;
  final String? edition;

  @override
  List<Object?> get props => [
        id,
        title,
        edition,
      ];
}