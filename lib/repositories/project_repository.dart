import '../database/app_database.dart';

class ProjectRepository {
  final AppDatabase database;

  ProjectRepository(this.database);

  Future<List<Project>> listProjects() {
    return database.projectDao.listProjects();
  }

  Future<String> addProject(String title) {
    return database.projectDao.addProject(title);
  }

  Future<void> setDone(String id, bool done) {
    return database.projectDao.setDone(id, done);
  }

  Future<void> deleteProject(String id) {
    return database.projectDao.deleteProject(id);
  }
}
