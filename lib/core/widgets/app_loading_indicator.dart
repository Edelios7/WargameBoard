import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// État de chargement générique pour un `AsyncValue.when(loading: ...)`
/// occupant toute la zone de contenu — un seul style de spinner dans toute
/// l'app plutôt qu'un `Center(child: CircularProgressIndicator(color: ...))`
/// répété (et parfois légèrement différent) d'un écran à l'autre.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }
}
