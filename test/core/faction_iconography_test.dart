import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/theme/app_colors.dart';
import 'package:wargameboard/core/utils/faction_iconography.dart';
import 'package:wargameboard/core/widgets/faction_glyph_icon.dart';

void main() {
  tearDown(() => AppColors.resetAccent());

  test('"Chaos Space Marines" resolves to its own dedicated glyph, not the '
      'loyalist "Space Marines" one just because the name contains it', () {
    final chaosMarines = FactionIconography.forFaction('Chaos Space Marines');
    final loyalMarines = FactionIconography.forFaction('Space Marines');

    expect(
      (chaosMarines.glyphBuilder?.call(1, chaosMarines.color)
              as FactionGlyphIcon?)
          ?.kind,
      GlyphKind.hornedSkull,
    );
    expect(
      (loyalMarines.glyphBuilder?.call(1, loyalMarines.color)
              as FactionGlyphIcon?)
          ?.kind,
      GlyphKind.helmet,
    );
  });

  test('the fallback palette for an unrecognized faction name follows a '
      "custom accent color change, instead of staying frozen on whatever "
      'AppColors.primary was the first time a badge was resolved', () {
    // Le choix de couleur au sein de la palette de repli dépend du hash
    // du nom (stable dans une même exécution) — on cherche un nom dont
    // l'index tombe sur AppColors.primary (position 0 de la palette),
    // seule entrée sensible au changement d'accent, plutôt que de
    // supposer un nom précis dont le hash pourrait varier entre
    // versions de Dart.
    String? sensitiveFaction;
    for (var i = 0; i < 50; i++) {
      final candidate = 'Homebrew Faction $i';
      AppColors.applyAccent(const Color(0xFF123456));
      final before = FactionIconography.forFaction(candidate).color;
      AppColors.applyAccent(const Color(0xFF654321));
      final after = FactionIconography.forFaction(candidate).color;
      if (before != after) {
        sensitiveFaction = candidate;
        break;
      }
    }
    expect(
      sensitiveFaction,
      isNotNull,
      reason:
          'expected at least one of 50 candidate names to land on the '
          'accent-color slot of the fallback palette',
    );

    AppColors.applyAccent(const Color(0xFF123456));
    final before = FactionIconography.forFaction(sensitiveFaction!);
    AppColors.applyAccent(const Color(0xFF654321));
    final after = FactionIconography.forFaction(sensitiveFaction);

    expect(before.color, const Color(0xFF123456));
    expect(after.color, const Color(0xFF654321));
  });
}
