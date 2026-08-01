import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/backup_service.dart';
import 'customization_provider.dart';
import 'database_provider.dart';

final backupServiceProvider = Provider<BackupService>((ref) {
  final database = ref.watch(databaseProvider);
  final customizationService = ref.watch(customizationServiceProvider);
  return BackupService(database, customizationService: customizationService);
});

/// Une restauration a-t-elle été programmée mais pas encore appliquée
/// (application pas encore relancée) — voir [BackupService.stageRestore].
final pendingRestoreProvider = FutureProvider<bool>((ref) {
  return BackupService.hasPendingRestore();
});
