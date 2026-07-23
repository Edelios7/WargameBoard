import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';

void main() {
  late AppDatabase database;
  late Directory tempDirectory;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    tempDirectory = Directory.systemTemp.createTempSync('backup_service_test');
  });

  tearDown(() async {
    await database.close();
    if (tempDirectory.existsSync()) {
      tempDirectory.deleteSync(recursive: true);
    }
  });

  test('VACUUM INTO produces a standalone copy readable by a fresh connection',
      () async {
    await database.armyDao.createArmy(
      name: 'Ma liste de sauvegarde',
      factionId: seedFactionId,
    );

    final destination = '${tempDirectory.path}/backup.sqlite';
    await database.customStatement('VACUUM INTO ?', [destination]);

    expect(File(destination).existsSync(), isTrue);

    final restored = AppDatabase.forTesting(
      NativeDatabase(File(destination)),
    );
    final armies = await restored.armyDao.listArmies();
    expect(armies.map((a) => a.name), contains('Ma liste de sauvegarde'));
    await restored.close();
  });
}
