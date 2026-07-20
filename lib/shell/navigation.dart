import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Onglet actuellement affiché dans l'AppShell.
///
/// Index partagé entre la Sidebar et les raccourcis (ex : cartes du
/// Dashboard) pour que les deux puissent changer d'onglet.
enum AppTab {
  dashboard,
  catalog,
  explorer,
  armies,
  battles,
  collection,
  statistics,
  settings,
}

final selectedTabProvider = StateProvider<AppTab>((ref) => AppTab.dashboard);
