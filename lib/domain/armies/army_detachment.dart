import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../catalog/detachments/detachment.dart';

@immutable
class ArmyDetachment extends Equatable {
  const ArmyDetachment({
    required this.detachment,
  });

  final Detachment detachment;

  @override
  List<Object?> get props => [
        detachment,
      ];
}