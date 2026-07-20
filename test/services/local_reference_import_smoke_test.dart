@Skip('Smoke test local uniquement : dépend de local_assets (non commité)')
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/services/catalog_import_service.dart';

void main() {
  test('imports the converted Aeldari reference file end-to-end', () async {
    final file = File(
      'local_assets/wh40k_reference/import_json/index-aeldari-fr.json',
    );
    if (!file.existsSync()) {
      markTestSkipped('Fichier de référence local absent.');
      return;
    }

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final result = await CatalogImportService(database)
        .importJson(file.readAsStringSync());

    expect(result.datasheets, greaterThan(50));

    final search = await database.datasheetDao.search('Avatar');
    final details =
        await database.datasheetDao.getDatasheet(search.single.id);
    expect(details!.factionName, 'Aeldari');
    expect(details.models, isNotEmpty);
    expect(details.models.single.toughness, 12);
    expect(details.weapons, isNotEmpty);
  });
}
