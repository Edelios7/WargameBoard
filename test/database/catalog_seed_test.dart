import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';
import 'package:wargameboard/database/seed/faction_seed.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('seeded Blood Angels datasheets are searchable', () async {
    final results = await database.datasheetDao.search('Sanguinary');

    expect(results, hasLength(1));
    expect(results.single.name, 'Sanguinary Guard');
    expect(results.single.factionName, 'Blood Angels');
  });

  test(
      'filtering by a Space Marines chapter also surfaces generic Space Marines units',
      () async {
    final results = await database.datasheetDao.search(
      '',
      factionId: seedFactionId, // Blood Angels
    );

    expect(results.map((r) => r.name), contains('Captain'));
    expect(results.map((r) => r.name), contains('Intercessor Squad'));
  });

  test(
      'filtering by the generic Space Marines faction does NOT surface chapter-specific units',
      () async {
    final results = await database.datasheetDao.search(
      '',
      factionId: seedSpaceMarinesFactionId,
    );

    expect(results.map((r) => r.name), contains('Intercessor Squad'));
    expect(results.map((r) => r.name), isNot(contains('Captain')));
  });

  test('filtering by a non-Space-Marines faction is unaffected', () async {
    final results = await database.datasheetDao.search(
      '',
      factionId: seedOrksFactionId,
    );

    expect(results, isNotEmpty);
    expect(results.every((r) => r.factionName == 'Orks'), isTrue);
  });

  test('getDatasheet resolves full details including weapons and keywords', () async {
    final results = await database.datasheetDao.search('Death Company');
    final details = await database.datasheetDao.getDatasheet(results.single.id);

    expect(details, isNotNull);
    expect(details!.factionName, 'Blood Angels');
    expect(details.points, greaterThan(0));
    expect(details.keywords, contains('Death Company'));
    expect(details.abilities.map((a) => a.name), contains('Feel No Pain 5+'));
    expect(details.weapons, isNotEmpty);
    expect(details.unit.minimumSize, 5);
    expect(details.unit.maximumSize, 10);
  });

  test('unknown datasheet id returns null', () async {
    final details = await database.datasheetDao.getDatasheet('does-not-exist');
    expect(details, isNull);
  });

  test('search filters by faction', () async {
    // 3 fiches propres à Blood Angels + Intercessor Squad (Space
    // Marines générique), voir le test dédié plus haut sur ce
    // comportement.
    final matching = await database.datasheetDao
        .search('', factionId: 'fac-blood-angels');
    expect(matching, hasLength(4));

    final none =
        await database.datasheetDao.search('', factionId: 'fac-unknown');
    expect(none, isEmpty);
  });

  test('weapons expose their seeded profiles', () async {
    final results = await database.datasheetDao.search('Captain');
    final details =
        await database.datasheetDao.getDatasheet(results.single.id);

    final plasmaPistol = details!.weapons
        .firstWhere((weapon) => weapon.name == 'Plasma pistol');
    expect(plasmaPistol.profiles, hasLength(1));
    final profile = plasmaPistol.profiles.single;
    expect(profile.range, 12);
    expect(profile.isMelee, isFalse);
    expect(profile.summary, contains('CT2+'));
    expect(profile.summary, contains('PA-2'));

    final powerWeapon = details.weapons.firstWhere(
        (weapon) => weapon.name == 'Master-crafted power weapon');
    expect(powerWeapon.profiles.single.isMelee, isTrue);
    expect(powerWeapon.profiles.single.summary, startsWith('Mêlée'));
  });

  test('search filters by keyword', () async {
    final flying =
        await database.datasheetDao.search('', keywordIds: {'kw-fly'});
    expect(flying, hasLength(1));
    expect(flying.single.name, 'Sanguinary Guard');

    final deathCompany = await database.datasheetDao
        .search('', keywordIds: {'kw-death-company'});
    expect(deathCompany.single.name, 'Death Company Marines');
  });

  test('search filters by multiple keywords with AND semantics', () async {
    final results = await database.datasheetDao.search(
      '',
      keywordIds: {'kw-death-company', 'kw-fly'},
    );
    // Aucune fiche du seed ne porte les deux mots-clés à la fois.
    expect(results, isEmpty);

    final bothPresent = await database.datasheetDao.search(
      '',
      keywordIds: {'kw-death-company', 'kw-infantry'},
    );
    expect(bothPresent.map((d) => d.name), contains('Death Company Marines'));
  });

  test('Orks are seeded as a distinct faction', () async {
    final orks = await database.datasheetDao.search('', factionId: 'fac-orks');
    expect(orks.map((d) => d.name), containsAll(['Warboss', 'Boyz', 'Nobz']));
    expect(orks.every((d) => d.factionName == 'Orks'), isTrue);

    final factions = await database.factionDao.getAll();
    expect(factions.map((f) => f.name), containsAll(['Blood Angels', 'Orks']));
  });

  test('Ork Boyz datasheet resolves with mob keywords', () async {
    final results = await database.datasheetDao.search('Boyz');
    final details =
        await database.datasheetDao.getDatasheet(results.single.id);

    expect(details, isNotNull);
    expect(details!.factionName, 'Orks');
    expect(details.keywords, contains('Mob'));
    expect(details.abilities.map((a) => a.name), contains('Mob Rule'));
    expect(details.unit.minimumSize, 10);
    expect(details.unit.maximumSize, 20);
  });
}
