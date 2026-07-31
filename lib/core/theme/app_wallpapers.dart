import 'dart:io';

/// Emplacements où l'utilisateur peut poser une image de fond personnelle
/// (page Personnalisation) — volontairement une liste fermée de zones
/// réellement partagées dans l'appli plutôt que "n'importe où", pour que
/// chaque réglage ait un effet visible et prévisible.
enum WallpaperSlot { app, sidebar, cards, banner }

/// Fichiers de fond d'écran actuellement appliqués, un par [WallpaperSlot]
/// — même patron que [AppColors] (statics mutables lues directement par
/// l'UI, sans passer par Riverpod/InheritedWidget) : la page de
/// personnalisation les modifie puis force un rebuild complet de l'appli
/// (voir themeVersionProvider) pour que tout ce qui les lit se
/// rafraîchisse.
class AppWallpapers {
  AppWallpapers._();

  static File? app;
  static File? sidebar;
  static File? cards;
  static File? banner;

  static File? forSlot(WallpaperSlot slot) {
    switch (slot) {
      case WallpaperSlot.app:
        return app;
      case WallpaperSlot.sidebar:
        return sidebar;
      case WallpaperSlot.cards:
        return cards;
      case WallpaperSlot.banner:
        return banner;
    }
  }

  static void setSlot(WallpaperSlot slot, File? file) {
    switch (slot) {
      case WallpaperSlot.app:
        app = file;
        break;
      case WallpaperSlot.sidebar:
        sidebar = file;
        break;
      case WallpaperSlot.cards:
        cards = file;
        break;
      case WallpaperSlot.banner:
        banner = file;
        break;
    }
  }
}
