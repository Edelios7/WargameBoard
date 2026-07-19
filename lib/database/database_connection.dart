import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Creates the SQLite connection used by Drift.
///
/// The database is stored inside the application's documents directory.
/// Drift opens the database lazily and runs SQLite on a background isolate.
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();

    final databaseFile = File(
      p.join(
        documentsDirectory.path,
        'wargame_board.sqlite',
      ),
    );

    return NativeDatabase.createInBackground(databaseFile);
  });
}