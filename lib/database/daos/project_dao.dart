import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/projects_table.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [Projects])
class ProjectDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectDaoMixin {
  ProjectDao(AppDatabase db) : super(db);

  static const _uuid = Uuid();

  Future<List<Project>> listProjects() {
    return (select(projects)
          ..orderBy([
            (t) => OrderingTerm.asc(t.done),
            (t) => OrderingTerm.asc(t.displayOrder),
          ]))
        .get();
  }

  Future<String> addProject(String title) async {
    final id = _uuid.v4();
    await into(projects).insert(
      ProjectsCompanion.insert(id: id, title: title),
    );
    return id;
  }

  Future<void> setDone(String id, bool done) {
    return (update(projects)..where((t) => t.id.equals(id)))
        .write(ProjectsCompanion(done: Value(done)));
  }

  Future<void> setProgress(String id, int? progressPercent) {
    return (update(projects)..where((t) => t.id.equals(id))).write(
      ProjectsCompanion(progressPercent: Value(progressPercent)),
    );
  }

  Future<void> deleteProject(String id) {
    return (delete(projects)..where((t) => t.id.equals(id))).go();
  }
}
