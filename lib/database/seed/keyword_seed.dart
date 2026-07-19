import '../app_database.dart';

const String kwInfantry = 'kw-infantry';
const String kwCharacter = 'kw-character';
const String kwFly = 'kw-fly';
const String kwDeathCompany = 'kw-death-company';
const String kwAdeptusAstartes = 'kw-adeptus-astartes';
const String kwBloodAngels = 'kw-blood-angels';
const String kwImperium = 'kw-imperium';
const String kwPistol = 'kw-pistol';
const String kwAssault = 'kw-assault';

Future<void> seedKeywords(AppDatabase db) async {
  final keywordNames = <String, String>{
    kwInfantry: 'Infantry',
    kwCharacter: 'Character',
    kwFly: 'Fly',
    kwDeathCompany: 'Death Company',
    kwAdeptusAstartes: 'Adeptus Astartes',
    kwBloodAngels: 'Blood Angels',
    kwImperium: 'Imperium',
    kwPistol: 'Pistol',
    kwAssault: 'Assault',
  };

  for (final entry in keywordNames.entries) {
    await db.into(db.keywords).insert(
          KeywordsCompanion.insert(
            id: entry.key,
            name: entry.value,
          ),
        );
  }
}
