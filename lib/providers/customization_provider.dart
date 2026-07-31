import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_wallpapers.dart';
import '../services/customization_service.dart';
import 'shared_preferences_provider.dart';

final customizationServiceProvider = Provider<CustomizationService>((ref) {
  return CustomizationService(ref.watch(sharedPreferencesProvider));
});

/// Incrémenté à chaque changement de couleur d'accent ou de fond d'écran —
/// observé à la racine de l'appli (voir app.dart) pour forcer un rebuild
/// complet de tout l'arbre de widgets. Nécessaire car [AppColors] et
/// [AppWallpapers] sont des statics mutables lus directement (pas via
/// Theme.of/InheritedWidget) : sans ce coup de fouet, les widgets déjà
/// construits ne relisent jamais la nouvelle valeur.
final themeVersionProvider = StateProvider<int>((ref) => 0);

/// Couleur d'accent actuelle, pour que la page de personnalisation puisse
/// afficher l'état courant (sélection active dans la palette, position du
/// sélecteur HSV) sans dupliquer sa propre copie de [AppColors.primary].
final accentColorProvider = Provider<Color>((ref) {
  ref.watch(themeVersionProvider);
  return AppColors.primary;
});

final wallpaperProvider = Provider.family<File?, WallpaperSlot>((ref, slot) {
  ref.watch(themeVersionProvider);
  return AppWallpapers.forSlot(slot);
});
