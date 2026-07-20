import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/dashboard_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString(localePreferenceKey);
  final savedDisplayName = prefs.getString(displayNamePreferenceKey);
  final savedRecentlyViewed =
      prefs.getStringList(recentlyViewedPreferenceKey) ?? const [];

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        localeOverrideProvider.overrideWith(
          (ref) => savedLocaleCode != null ? Locale(savedLocaleCode) : null,
        ),
        displayNameProvider.overrideWith((ref) => savedDisplayName),
        recentlyViewedProvider.overrideWith(
          (ref) => RecentlyViewedNotifier(ref, savedRecentlyViewed),
        ),
      ],
      child: const WargameBoardApp(),
    ),
  );
}
