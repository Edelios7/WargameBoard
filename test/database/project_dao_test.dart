import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/database/app_database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('deleteProject removes the project from listProjects', () async {
    final id = await database.projectDao.addProject('Peindre les Intercessors');
    expect(
      (await database.projectDao.listProjects()).map((p) => p.id),
      contains(id),
    );

    await database.projectDao.deleteProject(id);

    expect(
      (await database.projectDao.listProjects()).map((p) => p.id),
      isNot(contains(id)),
    );
  });
}
