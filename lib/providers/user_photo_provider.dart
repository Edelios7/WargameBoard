import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/user_photo_service.dart';

final userPhotoServiceProvider = Provider<UserPhotoService>(
  (ref) => const UserPhotoService(),
);

/// Incrémenté chaque fois qu'une photo perso (datasheet ou entrée) est
/// choisie ou retirée, n'importe où dans l'appli — regardé par
/// `UnitPhotoThumbnail` pour se reconstruire même quand ce n'est pas
/// l'instance qui a déclenché le changement (ex. la fiche latérale de
/// l'Army Builder doit se mettre à jour quand la photo est changée
/// depuis le panneau de détails). Même principe que `themeVersionProvider`
/// pour la couleur d'accent, volontairement grossier plutôt que ciblé par
/// id — le nombre de vignettes visibles à la fois reste faible.
final photoVersionProvider = StateProvider<int>((ref) => 0);
