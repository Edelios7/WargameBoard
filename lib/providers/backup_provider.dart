import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/backup_service.dart';
import 'database_provider.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final database = ref.watch(databaseProvider);
  return BackupService(database);
});

/// Une restauration a-t-elle été programmée mais pas encore appliquée
/// (application pas encore relancée) — voir [BackupService.stageRestore].
final pendingRestoreProvider = FutureProvider<bool>((ref) {
  return BackupService.hasPendingRestore();
});
