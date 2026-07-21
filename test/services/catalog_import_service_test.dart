import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';
import 'package:wargameboard/services/catalog_import_service.dart';

void main() {
  late AppDatabase database;
  late CatalogImportService service;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    service = CatalogImportService(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('imports a new datasheet with weapon, keyword and cost', () async {
    final result = await service.importJson(jsonEncode({
      'keywords': [
        {'id': 'kw-test-jump', 'name': 'Jump Pack'},
      ],
      'abilities': [
        {
          'id': 'ab-test-fury',
          'name': 'Fury',
          'description': 'Relance les 1 en charge.',
        },
      ],
      'weapons': [
        {
          'id': 'wp-test-sword',
          'name': 'Test sword',
          'isMelee': true,
          'profiles': [
            {
              'range': 0,
              'attacks': '5',
              'weaponSkill': 2,
              'strength': 5,
              'armorPenetration': -2,
              'damage': '2',
            },
          ],
        },
      ],
      'datasheets': [
        {
          'id': 'ds-test-assault',
          'name': 'Assault Intercessors',
          'factionId': seedFactionId,
          'battlefieldRole': 'Battleline',
          'unitType': 'Infantry',
          'points': 75,
          'editionId': seedEditionId,
          'minimumModels': 5,
          'maximumModels': 10,
          'defaultModels': 5,
          'keywordIds': ['kw-test-jump'],
          'abilityIds': ['ab-test-fury'],
        },
      ],
    }));

    expect(result.datasheets, 1);
    expect(result.weapons, 1);
    expect(result.total, 4);

    final search = await database.datasheetDao.search('Assault');
    final details =
        await database.datasheetDao.getDatasheet(search.single.id);
    expect(details!.points, 75);
    expect(details.keywords, contains('Jump Pack'));
    expect(details.abilities.map((a) => a.name), contains('Fury'));
    expect(details.unit.maximumSize, 10);
  });

  test('re-importing the same id updates points instead of duplicating',
      () async {
    Map<String, dynamic> doc(int points) => {
          'datasheets': [
            {
              'id': 'ds-test-upsert',
              'name': 'Upsert Squad',
              'factionId': seedFactionId,
              'battlefieldRole': 'Elites',
              'unitType': 'Infantry',
              'points': points,
              'editionId': seedEditionId,
            },
          ],
        };

    await service.importJson(jsonEncode(doc(100)));
    await service.importJson(jsonEncode(doc(85)));

    final search = await database.datasheetDao.search('Upsert');
    expect(search, hasLength(1));
    final details =
        await database.datasheetDao.getDatasheet(search.single.id);
    expect(details!.points, 85);
  });

  test('imports per-model-count cost brackets and resolves them correctly',
      () async {
    await service.importJson(jsonEncode({
      'datasheets': [
        {
          'id': 'ds-test-bracketed',
          'name': 'Bracketed Squad',
          'factionId': seedFactionId,
          'battlefieldRole': 'Battleline',
          'unitType': 'Infantry',
          'editionId': seedEditionId,
          'costs': [
            {'models': 5, 'points': 90},
            {'models': 10, 'points': 160},
          ],
          'minimumModels': 5,
          'maximumModels': 10,
          'defaultModels': 5,
        },
      ],
    }));

    final search = await database.datasheetDao.search('Bracketed');
    final datasheetId = search.single.id;

    final details = await database.datasheetDao.getDatasheet(datasheetId);
    // Le coût affiché par défaut correspond au palier de la taille par
    // défaut (5), pas un coût arbitraire ou une moyenne des paliers.
    expect(details!.points, 90);

    expect(
      await database.datasheetDao.getCostForModelCount(datasheetId, 5),
      90,
    );
    expect(
      await database.datasheetDao.getCostForModelCount(datasheetId, 10),
      160,
    );
    // Pas un simple doublement du coût à 5 figurines.
    expect(
      await database.datasheetDao.getCostForModelCount(datasheetId, 10),
      isNot(90 * 2),
    );
  });

  test('imports a new faction with a datasheet, models and weapons',
      () async {
    await service.importJson(jsonEncode({
      'factions': [
        {
          'id': 'fac-test-tyranids',
          'gameSystemId': seedGameSystemId,
          'name': 'Tyranids',
        },
      ],
      'weapons': [
        {'id': 'wp-test-talons', 'name': 'Monstrous talons', 'isMelee': true},
      ],
      'datasheets': [
        {
          'id': 'ds-test-tervigon',
          'name': 'Tervigon',
          'factionId': 'fac-test-tyranids',
          'battlefieldRole': 'Monstre',
          'unitType': 'Monster',
          'weaponIds': ['wp-test-talons'],
          'models': [
            {
              'name': 'Tervigon',
              'movement': 8,
              'toughness': 11,
              'save': 2,
              'wounds': 16,
              'leadership': 8,
              'objectiveControl': 4,
            },
          ],
        },
      ],
    }));

    final search = await database.datasheetDao.search('Tervigon');
    final details =
        await database.datasheetDao.getDatasheet(search.single.id);
    expect(details!.factionName, 'Tyranids');
    expect(details.models, hasLength(1));
    expect(details.models.single.toughness, 11);
    expect(details.weapons.single.name, 'Monstrous talons');
  });

  test('re-importing models replaces them instead of accumulating',
      () async {
    Map<String, dynamic> doc(int wounds) => {
          'datasheets': [
            {
              'id': 'ds-test-models',
              'name': 'Model Squad',
              'factionId': seedFactionId,
              'battlefieldRole': 'Elites',
              'unitType': 'Infantry',
              'models': [
                {
                  'name': 'Fighter',
                  'movement': 6,
                  'toughness': 4,
                  'save': 3,
                  'wounds': wounds,
                  'leadership': 6,
                  'objectiveControl': 1,
                },
              ],
            },
          ],
        };

    await service.importJson(jsonEncode(doc(2)));
    await service.importJson(jsonEncode(doc(3)));

    final search = await database.datasheetDao.search('Model Squad');
    final details =
        await database.datasheetDao.getDatasheet(search.single.id);
    expect(details!.models, hasLength(1));
    expect(details.models.single.wounds, 3);
  });

  test('rejects invalid JSON and unknown factions without partial writes',
      () async {
    expect(
      () => service.importJson('pas du json'),
      throwsA(isA<CatalogImportException>()),
    );

    await expectLater(
      service.importJson(jsonEncode({
        'keywords': [
          {'id': 'kw-should-not-persist', 'name': 'Ghost'},
        ],
        'datasheets': [
          {
            'id': 'ds-orphan',
            'name': 'Orphan',
            'factionId': 'fac-does-not-exist',
            'battlefieldRole': 'HQ',
            'unitType': 'Infantry',
          },
        ],
      })),
      throwsA(isA<CatalogImportException>()),
    );

    // La transaction doit avoir tout annulé, y compris le keyword valide.
    final keyword =
        await database.keywordDao.getById('kw-should-not-persist');
    expect(keyword, isNull);
  });
}
