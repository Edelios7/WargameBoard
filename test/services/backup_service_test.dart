import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/services/backup_service.dart';

class _FakePathProvider extends PathProviderPlatform {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getApplicationDocumentsPath() async => path;
}

void main() {
  late AppDatabase database;
  late Directory tempDirectory;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    tempDirectory = Directory.systemTemp.createTempSync('backup_service_test');
    PathProviderPlatform.instance = _FakePathProvider(tempDirectory.path);
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

  test(
    'applyPendingRestore rejects a corrupt/invalid staged file instead of '
    'deleting the real database',
    () async {
      final realDbPath = '${tempDirectory.path}/$databaseFileName';
      File(realDbPath).writeAsStringSync('not actually empty either');

      final stagedPath = '${tempDirectory.path}/$databaseFileName.restore';
      File(stagedPath).writeAsStringSync('this is not a sqlite database');

      await applyPendingRestore();

      expect(
        File(realDbPath).existsSync(),
        isTrue,
        reason: 'the real database must survive an invalid restore attempt',
      );
      expect(
        File(stagedPath).existsSync(),
        isFalse,
        reason: 'the rejected staged file should be cleaned up',
      );
    },
  );

  test(
    'applyPendingRestore swaps in a valid staged database and keeps the '
    'old one instead of deleting it outright',
    () async {
      await database.armyDao.createArmy(
        name: 'Armée à restaurer',
        factionId: seedFactionId,
      );
      final stagedPath = '${tempDirectory.path}/$databaseFileName.restore';
      await database.customStatement('VACUUM INTO ?', [stagedPath]);

      final realDbPath = '${tempDirectory.path}/$databaseFileName';
      File(realDbPath).writeAsStringSync('old database content');

      await applyPendingRestore();

      expect(File(stagedPath).existsSync(), isFalse);
      expect(File(realDbPath).existsSync(), isTrue);
      expect(
        File('$realDbPath.before-restore').existsSync(),
        isTrue,
        reason: 'the previous database should be kept aside, not deleted',
      );

      final restored = AppDatabase.forTesting(
        NativeDatabase(File(realDbPath)),
      );
      final armies = await restored.armyDao.listArmies();
      expect(armies.map((a) => a.name), contains('Armée à restaurer'));
      await restored.close();
    },
  );
}
