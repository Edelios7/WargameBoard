import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/providers/locale_provider.dart';
import 'package:wargameboard/providers/shared_preferences_provider.dart';
import 'package:wargameboard/shell/app_shell.dart';

void main() {
  late AppDatabase database;
  late SharedPreferences prefs;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('switching to English updates the UI language',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            final localeOverride = ref.watch(localeOverrideProvider);
            return MaterialApp(
              locale: localeOverride,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const AppShell(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    // La locale par défaut du test runner est l'anglais.
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    expect(find.text('Paramètres'), findsWidgets);
    expect(find.text('Langue'), findsOneWidget);
    expect(prefs.getString(localePreferenceKey), 'fr');
  });
}
