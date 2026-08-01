import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/core/theme/app_colors.dart';
import 'package:wargameboard/core/theme/app_wallpapers.dart';
import 'package:wargameboard/services/customization_service.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() {
    // Les statics sont partagés entre tests (même patron que AppColors
    // partout ailleurs dans l'appli) : on les remet à l'état par défaut
    // pour ne pas faire fuiter un réglage d'un test à l'autre.
    AppColors.resetAccent();
    AppWallpapers.dimming = 0.78;
    for (final slot in WallpaperSlot.values) {
      AppWallpapers.setSlot(slot, null);
    }
  });

  test('setAccentColor mutates AppColors.primary and persists it', () async {
    final service = CustomizationService(prefs);
    const chosen = Color(0xFF2FBF71);

    await service.setAccentColor(chosen);

    expect(AppColors.primary, chosen);
    expect(prefs.getInt(accentColorPreferenceKey), chosen.toARGB32());
  });

  test(
    'resetAccentColor restores the default and clears the saved value',
    () async {
      final service = CustomizationService(prefs);
      await service.setAccentColor(const Color(0xFFE0435C));

      await service.resetAccentColor();

      expect(AppColors.primary, const Color(0xFF7F31E6));
      expect(prefs.getInt(accentColorPreferenceKey), isNull);
    },
  );

  test('loadIntoStatics re-applies a previously saved accent color on a '
      'fresh service instance, as happens at app startup', () async {
    await CustomizationService(prefs).setAccentColor(const Color(0xFF4C8DFF));
    AppColors.resetAccent(); // simule un redémarrage : statics remis à zéro

    CustomizationService(prefs).loadIntoStatics();

    expect(AppColors.primary, const Color(0xFF4C8DFF));
  });

  test(
    'clearWallpaper removes the in-memory slot and the persisted path',
    () async {
      final service = CustomizationService(prefs);
      await prefs.setString('customization_wallpaper_cards', '/tmp/x.png');
      AppWallpapers.setSlot(WallpaperSlot.cards, null); // pas de vrai fichier

      await service.clearWallpaper(WallpaperSlot.cards);

      expect(AppWallpapers.cards, isNull);
      expect(prefs.getString('customization_wallpaper_cards'), isNull);
    },
  );

  test(
    'setWallpaperDimming mutates AppWallpapers.dimming and persists it',
    () async {
      final service = CustomizationService(prefs);

      await service.setWallpaperDimming(0.5);

      expect(AppWallpapers.dimming, 0.5);
      expect(prefs.getDouble(wallpaperDimmingPreferenceKey), 0.5);
    },
  );

  test('loadIntoStatics re-applies a previously saved dimming value on a '
      'fresh service instance', () async {
    await CustomizationService(prefs).setWallpaperDimming(0.4);
    AppWallpapers.dimming = 0.78; // simule un redémarrage

    CustomizationService(prefs).loadIntoStatics();

    expect(AppWallpapers.dimming, 0.4);
  });

  test('resetAll restores the default accent color, clears every wallpaper '
      'slot and the persisted dimming value, in a single call', () async {
    final service = CustomizationService(prefs);
    await service.setAccentColor(const Color(0xFFE0435C));
    await prefs.setString('customization_wallpaper_app', '/tmp/a.png');
    AppWallpapers.setSlot(WallpaperSlot.app, null); // pas de vrai fichier
    await service.setWallpaperDimming(0.4);

    await service.resetAll();

    expect(AppColors.primary, const Color(0xFF7F31E6));
    expect(prefs.getInt(accentColorPreferenceKey), isNull);
    expect(AppWallpapers.app, isNull);
    expect(prefs.getString('customization_wallpaper_app'), isNull);
    expect(AppWallpapers.dimming, 0.78);
    expect(prefs.getDouble(wallpaperDimmingPreferenceKey), 0.78);
  });
}
