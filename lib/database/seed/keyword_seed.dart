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
const String kwOrks = 'kw-orks';
const String kwMob = 'kw-mob';
const String kwVehicle = 'kw-vehicle';

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
    kwOrks: 'Orks',
    kwMob: 'Mob',
    kwVehicle: 'Vehicle',
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
