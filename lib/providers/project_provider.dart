import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../repositories/project_repository.dart';
import 'database_provider.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ProjectRepository(database);
});

final projectsListProvider = FutureProvider<List<Project>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.listProjects();
});
