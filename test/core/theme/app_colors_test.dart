import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/theme/app_colors.dart';

void main() {
  tearDown(() => AppColors.resetAccent());

  group('AppColors.onPrimary', () {
    test('is white on the default dark purple accent', () {
      AppColors.resetAccent();
      expect(AppColors.onPrimary, Colors.white);
    });

    test('is dark on a pale/light custom accent instead of staying white', () {
      // Rien n'empêche l'utilisateur de choisir une couleur très claire
      // dans le sélecteur — sans ce contraste calculé, le texte/icônes
      // blancs fixes (menu de gauche, avatar, en-tête Commandant...)
      // deviendraient illisibles dessus.
      AppColors.applyAccent(const Color(0xFFF5F0C8));
      expect(AppColors.onPrimary, isNot(Colors.white));
    });

    test('is white on a dark custom accent', () {
      AppColors.applyAccent(const Color(0xFF1A0B33));
      expect(AppColors.onPrimary, Colors.white);
    });
  });
}
