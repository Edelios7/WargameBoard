import '../app_database.dart';
import 'ability_seed.dart';
import 'datasheet_seed.dart';
import 'faction_seed.dart';
import 'keyword_seed.dart';

Future<void> seedCatalog(AppDatabase db) async {
  await db.transaction(() async {
    await seedFactions(db);
    await seedKeywords(db);
    await seedAbilities(db);
    await seedDatasheets(db);
  });
}
