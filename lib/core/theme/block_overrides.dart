import 'dart:io';

import 'package:flutter/material.dart';

/// Surcharge de fond pour un bloc ou une page précise, choisie en mode
/// personnalisation. [image] et [color] sont mutuellement exclusifs côté UI
/// (choisir l'un efface l'autre) ; si les deux sont présents malgré tout,
/// [image] prime (même priorité que [AppCard.wallpaperOverride] vs
/// `accentColor` aujourd'hui).
class BlockOverride {
  final File? image;
  final Color? color;

  const BlockOverride({this.image, this.color});
}

/// Registre statique mutable des surcharges par identifiant ouvert
/// (`"page.dashboard"`, `"dashboard.welcome_banner"`...) — même patron que
/// [AppWallpapers]/[AppColors] : lu directement par l'UI sans passer par
/// Riverpod, rafraîchi via `themeVersionProvider` après chaque mutation.
/// Contrairement à [WallpaperSlot], l'ensemble des identifiants n'est pas
/// fermé : n'importe quel bloc structurel ou page peut en obtenir un.
class BlockOverrides {
  BlockOverrides._();

  static final Map<String, BlockOverride> _overrides = {};

  static BlockOverride? forId(String id) => _overrides[id];

  static void setImage(String id, File file) {
    _overrides[id] = BlockOverride(image: file);
  }

  static void setColor(String id, Color color) {
    _overrides[id] = BlockOverride(color: color);
  }

  static void clear(String id) {
    _overrides.remove(id);
  }

  static void clearAll() {
    _overrides.clear();
  }
}
