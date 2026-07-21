import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/features/catalog/pages/catalog_page.dart';
import 'package:wargameboard/l10n/app_localizations.dart';
import 'package:wargameboard/providers/database_provider.dart';
import 'package:wargameboard/providers/shared_preferences_provider.dart';

Future<void> _loadFont(String family, String path) async {
  final bytes = await File(path).readAsBytes();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

void main() {
  // Outil de capture manuel pour la revue de design, pas un test de
  // correction : ignoré par défaut (n'écrit rien sans CATALOG_SCREENSHOT_PATH),
  // à lancer explicitement via `CATALOG_SCREENSHOT_PATH=out.png flutter test
  // test/features/catalog_screenshot_test.dart`.
  setUpAll(() async {
    final fontsRoot = Platform.environment['FLUTTER_MATERIAL_FONTS_DIR'];
    if (fontsRoot != null) {
      await _loadFont('Roboto', '$fontsRoot/roboto-regular.ttf');
      await _loadFont('MaterialIcons', '$fontsRoot/materialicons-regular.otf');
    }
  });

  testWidgets(
    'catalog page screenshot',
    skip: Platform.environment['CATALOG_SCREENSHOT_PATH'] == null,
    (tester) async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      tester.view.physicalSize = const Size(1600, 960);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final boundaryKey = GlobalKey();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(database),
            sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: RepaintBoundary(
            key: boundaryKey,
            child: MaterialApp(
              locale: const Locale('fr'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                fontFamily: 'Roboto',
                scaffoldBackgroundColor: const Color(0xFF0A0C10),
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFC81E3A),
                  secondary: Color(0xFFE8455F),
                  surface: Color(0xFF14171D),
                  error: Color(0xFFE0435C),
                ),
              ),
              home: const CatalogPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'Sanguinary');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sanguinary Guard'));
      await tester.pumpAndSettle();

      final boundary =
          boundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 1.0);
        final byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        final bytes = byteData!.buffer.asUint8List();

        final outPath =
            Platform.environment['CATALOG_SCREENSHOT_PATH'] ??
            'catalog_screenshot.png';
        final file = File(outPath);
        file.parent.createSync(recursive: true);
        file.writeAsBytesSync(bytes);
      });

      await database.close();
    },
  );
}
