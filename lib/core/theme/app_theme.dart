import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Retour visuel au survol/appui, cohérent avec l'accent unique de la DA
  /// et avec les patrons déjà établis ([AppCard], [Hoverable]) : pas de
  /// ripple qui se propage (le thème désactive volontairement
  /// [NoSplash]), juste un léger voile teinté qui apparaît/disparaît —
  /// sans ça, [NoSplash.splashFactory] laisse tous les boutons Material
  /// standards (Elevated/Text/Outlined/Filled/IconButton) sans aucun
  /// signal d'interactivité.
  static WidgetStateProperty<Color?> _overlay({
    required Color base,
    double hovered = .08,
    double pressed = .16,
    double focused = .1,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return base.withValues(alpha: pressed);
      }
      if (states.contains(WidgetState.hovered)) {
        return base.withValues(alpha: hovered);
      }
      if (states.contains(WidgetState.focused)) {
        return base.withValues(alpha: focused);
      }
      return null;
    });
  }

  static ThemeData get darkTheme {
    final buttonOverlay = _overlay(base: AppColors.primary);
    final neutralOverlay = _overlay(base: Colors.white, hovered: .06, pressed: .12, focused: .08);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: AppColors.border,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: Color(0x33C81E3A),
        selectionHandleColor: AppColors.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(overlayColor: buttonOverlay),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(overlayColor: buttonOverlay),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(overlayColor: buttonOverlay),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(overlayColor: buttonOverlay),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(overlayColor: neutralOverlay),
      ),
    );
  }
}
