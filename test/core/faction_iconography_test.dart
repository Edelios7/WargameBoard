import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/utils/faction_iconography.dart';
import 'package:wargameboard/core/widgets/faction_glyph_icon.dart';

void main() {
  test(
    '"Chaos Space Marines" resolves to its own dedicated glyph, not the '
    'loyalist "Space Marines" one just because the name contains it',
    () {
      final chaosMarines = FactionIconography.forFaction('Chaos Space Marines');
      final loyalMarines = FactionIconography.forFaction('Space Marines');

      expect(
        (chaosMarines.glyphBuilder?.call(1, chaosMarines.color) as FactionGlyphIcon?)
            ?.kind,
        GlyphKind.hornedSkull,
      );
      expect(
        (loyalMarines.glyphBuilder?.call(1, loyalMarines.color) as FactionGlyphIcon?)
            ?.kind,
        GlyphKind.helmet,
      );
    },
  );
}
