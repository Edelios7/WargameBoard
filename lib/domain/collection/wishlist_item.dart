import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../catalog/datasheets/datasheet.dart';

@immutable
class WishlistItem extends Equatable {
  const WishlistItem({
    required this.id,
    required this.datasheet,
    required this.quantity,
  });

  final String id;
  final Datasheet datasheet;
  final int quantity;

  @override
  List<Object?> get props => [
        id,
        datasheet,
        quantity,
      ];
}