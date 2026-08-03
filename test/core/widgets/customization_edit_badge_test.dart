import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/core/theme/block_overrides.dart';
import 'package:wargameboard/core/utils/user_content_paths.dart';
import 'package:wargameboard/core/widgets/customization_edit_badge.dart';
import 'package:wargameboard/features/customization/widgets/hsv_color_picker.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/customization_provider.dart';
import 'package:wargameboard/providers/shared_preferences_provider.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  late SharedPreferences prefs;
  late Directory tempDirectory;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    tempDirectory = Directory.systemTemp.createTempSync(
      'customization_edit_badge_test',
    );
    PathProviderPlatform.instance = _FakePathProvider(tempDirectory.path);
    await UserContentPaths.initialize();
  });

  tearDown(() {
    BlockOverrides.clearAll();
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  Widget wrap() {
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        locale: const Locale('fr'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: CustomizationEditBadge(id: 'dashboard.test'),
        ),
      ),
    );
  }

  Future<void> openColorDialog(WidgetTester tester) async {
    await tester.pumpWidget(wrap());
    await tester.tap(find.byType(CustomizationEditBadge));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choisir une couleur'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'dragging on the saturation square previews the color immediately, '
    'before any button is pressed',
    (tester) async {
      await openColorDialog(tester);

      expect(BlockOverrides.forId('dashboard.test'), isNull);

      final saturationSquare = find
          .descendant(
            of: find.byType(HsvColorPicker),
            matching: find.byType(GestureDetector),
          )
          .first;
      await tester.drag(saturationSquare, const Offset(40, 20));
      await tester.pump();

      expect(BlockOverrides.forId('dashboard.test')?.color, isNotNull);
    },
  );

  testWidgets('"Annuler" reverts the live preview instead of keeping it', (
    tester,
  ) async {
    BlockOverrides.setColor('dashboard.test', const Color(0xFF223344));
    await openColorDialog(tester);

    final saturationSquare = find
        .descendant(
          of: find.byType(HsvColorPicker),
          matching: find.byType(GestureDetector),
        )
        .first;
    await tester.drag(saturationSquare, const Offset(40, 20));
    await tester.pump();
    expect(
      BlockOverrides.forId('dashboard.test')?.color,
      isNot(const Color(0xFF223344)),
    );

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(
      BlockOverrides.forId('dashboard.test')?.color,
      const Color(0xFF223344),
    );
  });

  testWidgets('"Appliquer" keeps the previewed color', (tester) async {
    await openColorDialog(tester);

    final saturationSquare = find
        .descendant(
          of: find.byType(HsvColorPicker),
          matching: find.byType(GestureDetector),
        )
        .first;
    await tester.drag(saturationSquare, const Offset(40, 20));
    await tester.pump();
    final previewed = BlockOverrides.forId('dashboard.test')?.color;
    expect(previewed, isNotNull);

    await tester.tap(find.text('Appliquer'));
    await tester.pumpAndSettle();

    expect(BlockOverrides.forId('dashboard.test')?.color, previewed);
  });
}
