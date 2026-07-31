import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color _defaultPrimary = Color(0xFF7F31E6);

  // Couleur d'accent unique — volontairement non-const (au lieu de static
  // final) pour rester mutable : la page de personnalisation change ces
  // valeurs à l'exécution via [applyAccent], puis force un rebuild complet
  // de l'appli (voir themeVersionProvider) pour que tout ce qui lit ces
  // constantes directement (la quasi-totalité de l'UI, en dehors de
  // Theme.of) affiche la nouvelle couleur.
  static Color primary = _defaultPrimary;
  static Color primaryLight = const Color(0xFFB668F6);
  static Color primaryDark = const Color(0xFF551FA0);

  /// Palette de couleurs conseillées pour la couleur d'accent — des tons
  /// saturés à luminosité moyenne choisis pour rester lisibles sur le fond
  /// anthracite très sombre de la DA (évite les couleurs trop pâles/pastel
  /// qui se fondraient dans le fond, ou trop sombres qui perdraient tout
  /// contraste).
  static const List<Color> recommendedAccents = [
    _defaultPrimary,
    Color(0xFFE0435C), // rouge cramoisi
    Color(0xFFE0A429), // ambre
    Color(0xFF2FBF71), // émeraude
    Color(0xFF4C8DFF), // bleu
    Color(0xFF2FBFA8), // turquoise
    Color(0xFFE6317F), // rose vif
    Color(0xFFE67A31), // orange
  ];

  /// Dérive et applique [primaryLight]/[primaryDark] à partir d'une
  /// couleur de base choisie par l'utilisateur, en gardant la même
  /// relation visuelle (plus clair/plus sombre) que la palette d'origine —
  /// évite d'avoir à faire choisir 3 couleurs séparées pour un résultat
  /// cohérent.
  static void applyAccent(Color base) {
    final hsl = HSLColor.fromColor(base);
    primary = base;
    primaryLight = hsl
        .withLightness((hsl.lightness + 0.18).clamp(0.0, 1.0))
        .toColor();
    primaryDark = hsl
        .withLightness((hsl.lightness - 0.18).clamp(0.0, 1.0))
        .toColor();
  }

  static void resetAccent() => applyAccent(_defaultPrimary);

  // Arrière-plans
  static const Color background = Color(0xFF0A0C10);
  static const Color surface = Color(0xFF14171D);
  static const Color surfaceElevated = Color(0xFF1B1F27);

  // Texte
  static const Color textPrimary = Color(0xFFF4F5F7);
  static const Color textSecondary = Color(0xFF8B909C);

  // États
  static const Color success = Color(0xFF2FBF71);
  static const Color warning = Color(0xFFE0A429);
  static const Color error = Color(0xFFE0435C);
  static const Color info = Color(0xFF4C8DFF);

  // Séparateurs
  static const Color border = Color(0xFF262B34);
}
