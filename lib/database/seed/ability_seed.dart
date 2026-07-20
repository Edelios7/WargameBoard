import 'package:drift/drift.dart';

import '../app_database.dart';

const String abLeader = 'ab-leader';
const String abShockAssault = 'ab-shock-assault';
const String abFeelNoPain5 = 'ab-feel-no-pain-5';
const String abBlackRage = 'ab-black-rage';
const String abAngelicVisage = 'ab-angelic-visage';
const String abDeepStrike = 'ab-deep-strike';
const String abLethalHits = 'ab-lethal-hits';
const String abMobRule = 'ab-mob-rule';
const String abEreWeGo = 'ab-ere-we-go';
const String abWaaagh = 'ab-waaagh';

Future<void> seedAbilities(AppDatabase db) async {
  final abilities = <String, ({String name, String description, String type})>{
    abLeader: (
      name: 'Leader',
      description: 'Peut être attaché à une unité Battleline compatible pour la diriger au combat.',
      type: 'Core',
    ),
    abShockAssault: (
      name: 'Shock Assault',
      description: 'Bonus au combat lorsque l\'unité a chargé ce tour-ci.',
      type: 'Faction',
    ),
    abFeelNoPain5: (
      name: 'Feel No Pain 5+',
      description: 'Sur un jet de 5+, ignore une blessure mortelle ou une perte de vie subie.',
      type: 'Core',
    ),
    abBlackRage: (
      name: 'Black Rage',
      description: 'Frénésie héritée de Sanguinius : bonus offensif au prix d\'un contrôle réduit.',
      type: 'Faction',
    ),
    abAngelicVisage: (
      name: 'Angelic Visage',
      description: 'La vue de ces guerriers peut semer la terreur ou l\'admiration chez l\'adversaire.',
      type: 'Faction',
    ),
    abDeepStrike: (
      name: 'Deep Strike',
      description: 'Peut être placée en réserve stratégique et arriver depuis n\'importe quel bord de table.',
      type: 'Core',
    ),
    abLethalHits: (
      name: 'Lethal Hits',
      description: 'Un résultat critique au jet Pour Toucher inflige automatiquement une blessure.',
      type: 'Weapon',
    ),
    abMobRule: (
      name: 'Mob Rule',
      description: 'Le moral d\'une unité Orks s\'appuie sur le nombre de figurines proches.',
      type: 'Faction',
    ),
    abEreWeGo: (
      name: '\'Ere We Go',
      description: 'Relance des jets de charge ratés, portée par l\'excitation du combat.',
      type: 'Faction',
    ),
    abWaaagh: (
      name: 'Waaagh!',
      description: 'La ferveur collective des Orks renforce l\'unité au corps à corps.',
      type: 'Faction',
    ),
  };

  for (final entry in abilities.entries) {
    await db.into(db.abilities).insert(
          AbilitiesCompanion.insert(
            id: entry.key,
            name: entry.value.name,
            description: entry.value.description,
            type: Value(entry.value.type),
          ),
        );
  }
}
