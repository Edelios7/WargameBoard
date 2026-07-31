import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/core/theme/app_colors.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/providers/shared_preferences_provider.dart';
import 'package:wargameboard/shell/app_shell.dart';

void main() {
  late AppDatabase database;
  late SharedPreferences prefs;

  Widget wrap() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AppShell(),
      ),
    );
  }

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  tearDown(() async {
    await database.close();
    AppColors.resetAccent();
  });

  testWidgets(
    'opening Personnalisation from the sidebar and tapping a recommended '
    'swatch changes the accent color and persists it',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(wrap());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Personnalisation'));
      await tester.pumpAndSettle();

      expect(find.text('Personnaliser l\'application'), findsOneWidget);

      final defaultColor = AppColors.primary;
      final swatch = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).shape == BoxShape.circle &&
            (w.decoration as BoxDecoration).color != null &&
            (w.decoration as BoxDecoration).color != defaultColor,
      );
      expect(swatch, findsWidgets);

      await tester.tap(swatch.first, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(AppColors.primary, isNot(defaultColor));
      expect(prefs.getInt('customization_accent_color'), isNotNull);
    },
  );
}
