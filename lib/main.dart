import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'providers/locale_provider.dart';
import 'providers/shared_preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final savedLocaleCode = prefs.getString(localePreferenceKey);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        localeOverrideProvider.overrideWith(
          (ref) => savedLocaleCode != null ? Locale(savedLocaleCode) : null,
        ),
      ],
      child: const WargameBoardApp(),
    ),
  );
}
