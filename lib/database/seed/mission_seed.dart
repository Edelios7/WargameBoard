import 'package:drift/drift.dart';

import '../app_database.dart';

/// Données du pack de missions 11e édition "GDM 2026" : 5 postures de
/// bataille, les 25 missions primaires qui en résultent (croisement de
/// ta posture et de celle de l'adversaire) et les 18 missions
/// secondaires. Texte traduit et condensé pour servir de fiche mémo
/// pendant une partie — à vérifier contre le pack de mission physique en
/// cas de doute.
Future<void> seedMissions(AppDatabase db) async {
  for (final d in _dispositions) {
    await db
        .into(db.missionDispositions)
        .insertOnConflictUpdate(
          MissionDispositionsCompanion.insert(
            id: 'disp-${d.slug}',
            slug: d.slug,
            name: d.name,
          ),
        );
  }

  for (final m in _primaryMissions) {
    await db
        .into(db.primaryMissions)
        .insertOnConflictUpdate(
          PrimaryMissionsCompanion.insert(
            id: 'pm-${m.yourSlug}-vs-${m.opponentSlug}',
            yourDispositionId: 'disp-${m.yourSlug}',
            opponentDispositionId: 'disp-${m.opponentSlug}',
            name: m.name,
            scoring: m.scoring,
            action: Value(m.action),
          ),
        );
  }

  for (final s in _secondaryMissions) {
    await db
        .into(db.secondaryMissions)
        .insertOnConflictUpdate(
          SecondaryMissionsCompanion.insert(
            id: 'sm-${s.slug}',
            slug: s.slug,
            name: s.name,
            isFixed: Value(s.isFixed),
            effect: s.effect,
          ),
        );
  }
}

typedef _Disposition = ({String slug, String name});

typedef _PrimaryMission = ({
  String yourSlug,
  String opponentSlug,
  String name,
  String scoring,
  String? action,
});

typedef _SecondaryMission = ({
  String slug,
  String name,
  bool isFixed,
  String effect,
});

const _dispositions = <_Disposition>[
  (slug: 'take-and-hold', name: 'Prise et Défense'),
  (slug: 'purge-the-foe', name: 'Purge de l’Ennemi'),
  (slug: 'reconnaissance', name: 'Reconnaissance'),
  (slug: 'priority-assets', name: 'Atouts Prioritaires'),
  (slug: 'disruption', name: 'Perturbation'),
];

const _primaryMissions = <_PrimaryMission>[
  (
    yourSlug: 'take-and-hold',
    opponentSlug: 'take-and-hold',
    name: 'Domination du Champ de Bataille',
    scoring: """
PREMIER & DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
2 PV : Vous contrôlez plus d'objectifs que votre adversaire.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
3 PV chacun : Pour chaque objectif que vous contrôlez.
+2 PV chacun (cumulatif) : Pour chacun de ces objectifs (à l'exclusion de votre objectif de camp) si vous contrôlez votre objectif de camp.""",
    action: null,
  ),
  (
    yourSlug: 'take-and-hold',
    opponentSlug: 'disruption',
    name: 'Acquisition Déterminée',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV chacun : Pour chaque objectif que vous contrôlez et que vous ne contrôliez pas au début du tour (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
3 PV chacun : Pour chaque objectif que vous contrôlez.
+3 PV chacun (cumulatif) : Pour chacun de ces objectifs situé dans le territoire de votre adversaire.""",
    action: null,
  ),
  (
    yourSlug: 'take-and-hold',
    opponentSlug: 'purge-the-foe',
    name: 'Objectif Inamovible',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Vous contrôlez un ou plusieurs objectifs centraux.

DU DEUXIÈME AU QUATRIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement
5 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

CINQUIÈME ROUND DE BATAILLE
Fin de votre tour
5 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).""",
    action: null,
  ),
  (
    yourSlug: 'take-and-hold',
    opponentSlug: 'priority-assets',
    name: 'Domination Inéluctable',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Vous contrôlez trois objectifs ou plus.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
5 PV : Vous contrôlez deux objectifs ou plus.
4 PV : Vous contrôlez plus d'objectifs que votre adversaire.

FIN DE PARTIE
5 PV : Vous contrôlez l'objectif de camp de votre adversaire.""",
    action: null,
  ),
  (
    yourSlug: 'take-and-hold',
    opponentSlug: 'reconnaissance',
    name: 'Purger et Sécuriser',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités ennemies ont été détruites ce tour-ci par une unité amie qui était à portée d'un ou plusieurs objectifs.
OU 3 PV : Une ou plusieurs unités ennemies ayant commencé le tour à portée d'un ou plusieurs objectifs ont été détruites ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
3 PV : Vous contrôlez un ou plusieurs objectifs que vous ne contrôliez pas au début du tour (à l'exclusion de votre objectif de camp).""",
    action: null,
  ),
  (
    yourSlug: 'purge-the-foe',
    opponentSlug: 'reconnaissance',
    name: 'Consacrer',
    scoring: """
RÈGLE : Chaque fois qu'une unité amie détruit une unité, cette unité amie devient une unité de consécration. À la fin de votre tour, pour chacune de vos unités de consécration, vous pouvez sélectionner un objectif à portée duquel elle se trouve (à l'exclusion de votre objectif de camp) qui n'a pas été consacré. Si vous le faites, placez un de vos marqueurs d'opération à portée de cet objectif : cet objectif est consacré et cette unité n'est plus une unité de consécration.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Un ou deux objectifs sont consacrés.
OU 6 PV : Trois objectifs ou plus sont consacrés.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
4 PV : Vous contrôlez plus d'objectifs que votre adversaire.

FIN DE PARTIE
5 PV : L'objectif de camp de votre adversaire est consacré.""",
    action: null,
  ),
  (
    yourSlug: 'purge-the-foe',
    opponentSlug: 'priority-assets',
    name: 'Courroux du Destructeur',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités ennemies ont été détruites ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
6 PV : Vous contrôlez plus d'objectifs que votre adversaire.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
4 PV : Plus d'unités ennemies ont été détruites ce tour-ci que d'unités amies détruites au tour précédent.""",
    action: null,
  ),
  (
    yourSlug: 'purge-the-foe',
    opponentSlug: 'purge-the-foe',
    name: 'Le Hachoir',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités ennemies ont été détruites ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
5 PV : Plus d'unités ennemies ont été détruites ce tour-ci que d'unités amies détruites au tour précédent.
5 PV : Vous contrôlez l'objectif de camp de votre adversaire.""",
    action: null,
  ),
  (
    yourSlug: 'purge-the-foe',
    opponentSlug: 'disruption',
    name: 'Châtiment',
    scoring: """
DÉBUT DE VOTRE TOUR : Sélectionnez une à trois unités ennemies présentes sur le champ de bataille et à portée d'objectifs et/ou ayant détruit une ou plusieurs unités amies au tour précédent. Si vous ne le pouvez pas, sélectionnez une unité ennemie présente sur le champ de bataille. Jusqu'au début de votre prochain tour, ces unités sont condamnées.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin d'un tour
5 PV : Une ou plusieurs unités ennemies condamnées ont quitté le champ de bataille ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
5 PV : Vous contrôlez plus d'objectifs que votre adversaire.

FIN DE PARTIE
8 PV : Vous contrôlez l'objectif de camp de votre adversaire.""",
    action: null,
  ),
  (
    yourSlug: 'purge-the-foe',
    opponentSlug: 'take-and-hold',
    name: 'Force Implacable',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités ennemies ont été détruites ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
3 PV : Vous contrôlez un ou plusieurs objectifs que vous ne contrôliez pas au début du tour (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
5 PV : Vous contrôlez un ou plusieurs objectifs centraux.""",
    action: null,
  ),
  (
    yourSlug: 'reconnaissance',
    opponentSlug: 'reconnaissance',
    name: 'Collecte de Renseignements',
    scoring: """
PREMIER ROUND DE BATAILLE
Fin de votre tour
6 PV : Vous contrôlez un ou plusieurs objectifs centraux.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
7 PV chacune : Pour chaque unité amie ayant terminé l'action Extraction de Renseignements ce tour-ci.

FIN DE PARTIE
5 PV : Trois de vos marqueurs d'opération ou plus sont sur le champ de bataille.
5 PV : Un de vos marqueurs d'opération est à portée de l'objectif de camp de votre adversaire.""",
    action: """
EXTRACTION DE RENSEIGNEMENTS – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir, à partir du deuxième round de bataille.
UNITÉS : Une unité à portée d'un objectif (à l'exclusion de votre objectif de camp) qui n'a aucun de vos marqueurs d'opération à portée de lui.
LIMITE D'UTILISATION : Illimitée. Chaque unité qui commence cette action ce tour-ci doit être à portée d'un objectif différent.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Placez un de vos marqueurs d'opération à portée de cet objectif.""",
  ),
  (
    yourSlug: 'reconnaissance',
    opponentSlug: 'take-and-hold',
    name: 'Ratissage de Reconnaissance',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Trois unités amies ou plus sont entièrement dans trois quarts de table différents et ne sont pas à moins de 6" du centre du champ de bataille.
OU 6 PV : Quatre unités amies ou plus sont entièrement dans quatre quarts de table différents et ne sont pas à moins de 6" du centre du champ de bataille.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
1 PV chacune : Pour chaque unité ennemie détruite ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
3 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).""",
    action: null,
  ),
  (
    yourSlug: 'reconnaissance',
    opponentSlug: 'priority-assets',
    name: 'Chercher et Ratisser',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Vous contrôlez un ou plusieurs objectifs centraux.
2 PV : Une ou plusieurs unités ennemies ayant commencé le tour dans une zone de terrain ont été détruites.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
5 PV : Aucune unité ennemie n'est entièrement dans votre territoire.""",
    action: null,
  ),
  (
    yourSlug: 'reconnaissance',
    opponentSlug: 'disruption',
    name: "Surveiller l'Ennemi",
    scoring: """
RÈGLE : Chaque fois qu'une unité amie termine un mouvement à portée d'un objectif ayant un ou plusieurs marqueurs d'opération de votre adversaire à portée de lui, retirez ces marqueurs d'opération du champ de bataille.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Une ou plusieurs unités ennemies ont été surveillées ce tour-ci (voir au dos), sauf si chacune de ces unités est à portée d'un ou plusieurs objectifs ayant un ou plusieurs marqueurs d'opération à portée d'eux.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
4 PV : Vous contrôlez plus d'objectifs que votre adversaire.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
5 PV : Aucun marqueur d'opération de votre adversaire n'est sur le champ de bataille.""",
    action: """
SURVEILLER L'ENNEMI – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie.
LIMITE D'UTILISATION : Illimitée.
TERMINÉE : Immédiatement.
EFFET : Sélectionnez une unité ennemie à moins de 18" de votre unité et visible d'elle, qui n'a pas été surveillée ce tour-ci : jusqu'à la fin du tour, cette unité ennemie est surveillée.""",
  ),
  (
    yourSlug: 'reconnaissance',
    opponentSlug: 'purge-the-foe',
    name: 'Triangulation',
    scoring: """
À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
3 PV : Un objectif est triangulé (voir au dos).
OU 6 PV : Deux objectifs sont triangulés.
OU 10 PV : Trois objectifs ou plus sont triangulés.

FIN DE PARTIE
10 PV : Vous contrôlez quatre objectifs ou plus.""",
    action: """
TRIANGULER – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir, à partir du deuxième round de bataille.
UNITÉS : Une unité amie à portée d'un objectif (à l'exclusion de votre objectif de camp).
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Cet objectif est triangulé : placez un de vos marqueurs d'opération à portée de cet objectif.""",
  ),
  (
    yourSlug: 'priority-assets',
    opponentSlug: 'disruption',
    name: 'Extraction de Relique',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Une unité amie a effectué un balayage radar ce tour-ci.
3 PV : Une ou plusieurs unités ennemies ayant commencé le tour à portée d'un ou plusieurs objectifs ont été détruites.
4 PV : Un seul marqueur d'opération de votre adversaire est sur le champ de bataille, si une ou plusieurs de vos unités sont dans la même zone de terrain que ce marqueur d'opération, et qu'aucune unité ennemie ne se trouve dans cette zone de terrain.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
5 PV : Un seul marqueur d'opération de votre adversaire est sur le champ de bataille, si une ou plusieurs de vos unités sont dans la même zone de terrain que ce marqueur d'opération, et qu'aucune unité ennemie ne se trouve dans cette zone de terrain.""",
    action: """
BALAYAGE RADAR – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif central.
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Votre unité effectue un balayage radar : retirez un marqueur d'opération du champ de bataille.
RESTRICTION : Une unité ne peut pas commencer cette action s'il ne reste qu'un seul marqueur d'opération sur le champ de bataille.""",
  ),
  (
    yourSlug: 'priority-assets',
    opponentSlug: 'priority-assets',
    name: 'Sabotage',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV chacune : Pour chaque unité amie ayant commis un sabotage ce tour-ci (voir au dos).
+2 PV chacune (cumulatif) : Pour chacune de ces unités à portée d'un ou plusieurs objectifs situés dans le territoire de votre adversaire.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).""",
    action: """
SABOTER – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité à portée d'un objectif (à l'exclusion de votre objectif de camp).
LIMITE D'UTILISATION : Illimitée. Chaque unité qui commence cette action ce tour-ci doit être à portée d'un objectif différent.
TERMINÉE : Fin de votre tour, si cette unité contrôle cet objectif.
EFFET : Votre unité commet un sabotage.""",
  ),
  (
    yourSlug: 'priority-assets',
    opponentSlug: 'take-and-hold',
    name: "Sécuriser l'Atout",
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Une unité amie a sécurisé l'atout ce tour-ci (voir au dos).
2 PV : Une ou plusieurs unités ennemies ayant commencé le tour à portée d'un ou plusieurs objectifs centraux ont été détruites.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
4 PV : Vous contrôlez trois objectifs ou plus.""",
    action: """
SÉCURISER L'ATOUT – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif (à l'exclusion de votre objectif de camp).
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Votre unité sécurise l'atout.""",
  ),
  (
    yourSlug: 'priority-assets',
    opponentSlug: 'reconnaissance',
    name: "Opération d'Avant-Garde",
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Une unité amie a effectué une opération d'avant-garde ce tour-ci.
2 PV : Une ou plusieurs unités ennemies ont été détruites ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
10 PV : Vous contrôlez l'objectif de camp de votre adversaire.""",
    action: """
OPÉRATION D'AVANT-GARDE – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie dans une zone de terrain située dans le territoire de votre adversaire.
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si aucune unité ennemie ne se trouve dans cette zone de terrain.
EFFET : Votre unité effectue une opération d'avant-garde.""",
  ),
  (
    yourSlug: 'priority-assets',
    opponentSlug: 'purge-the-foe',
    name: 'Lien Vital',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV : Vous contrôlez un ou plusieurs objectifs centraux.
+1 PV chacun (cumulatif) : Pour chacun de vos marqueurs d'opération à portée de l'un de ces objectifs (voir au dos).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).
+4 PV (cumulatif) : Un ou plusieurs de ces objectifs est un objectif central.

FIN DE PARTIE
10 PV : Vous contrôlez l'objectif de camp de votre adversaire.""",
    action: """
MAINTENIR LE CONTRÔLE – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif central.
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Placez un de vos marqueurs d'opération à portée de cet objectif.""",
  ),
  (
    yourSlug: 'disruption',
    opponentSlug: 'take-and-hold',
    name: 'Piège Mortel',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV chacune : Pour chaque zone de terrain piégée ce tour-ci.
+3 PV chacune (cumulatif) : Pour chacune de ces zones de terrain qui est un objectif.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités ennemies ayant commencé le tour dans une zone de terrain ont été détruites, si cette zone de terrain est piégée.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).""",
    action: """
PIÈGE EXPLOSIF – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif (à l'exclusion de votre objectif de camp) ou dans une zone de terrain qui n'est pas dans votre zone de déploiement, que vous n'avez pas encore piégée.
LIMITE D'UTILISATION : Illimitée. Chaque unité qui commence cette action ce tour-ci doit être dans une zone de terrain différente.
TERMINÉE : Immédiatement.
EFFET : Cette zone de terrain est piégée : placez un de vos marqueurs d'opération dans cette zone de terrain.""",
  ),
  (
    yourSlug: 'disruption',
    opponentSlug: 'purge-the-foe',
    name: 'Action Retardatrice',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV chacune : Pour chaque unité ennemie détruite ce tour-ci.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion des objectifs de camp).

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre tour
3 PV : Vous contrôlez un ou plusieurs objectifs centraux et un ou plusieurs objectifs d'expansion.""",
    action: null,
  ),
  (
    yourSlug: 'disruption',
    opponentSlug: 'priority-assets',
    name: 'Localiser et Refuser',
    scoring: """
DÉBUT DE PARTIE : Sélectionnez cinq zones de terrain qui ne sont pas dans votre zone de déploiement ; pour chacune d'elles, placez un de vos marqueurs d'opération à l'intérieur. Si vous ne le pouvez pas, faites-le pour chaque zone de terrain qui n'est pas dans votre zone de déploiement.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
4 PV : Une ou plusieurs unités ennemies ayant commencé le tour à portée d'un ou plusieurs objectifs ont été détruites.
4 PV : Un seul de vos marqueurs d'opération est sur le champ de bataille, si une ou plusieurs de vos unités sont dans la même zone de terrain que ce marqueur, et qu'aucune unité ennemie ne se trouve dans cette zone de terrain.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
5 PV : Un seul de vos marqueurs d'opération est sur le champ de bataille, si une ou plusieurs de vos unités sont dans la même zone de terrain que ce marqueur, et qu'aucune unité ennemie ne se trouve dans cette zone de terrain.""",
    action: """
BALAYAGE RADAR – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif central.
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Votre unité effectue un balayage radar : retirez un marqueur d'opération du champ de bataille.
RESTRICTION : Une unité ne peut pas commencer cette action s'il ne reste qu'un seul marqueur d'opération sur le champ de bataille.""",
  ),
  (
    yourSlug: 'disruption',
    opponentSlug: 'disruption',
    name: 'Prendre de Vitesse',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
10 PV : Vous contrôlez l'objectif de camp de votre adversaire.

PREMIER ROUND DE BATAILLE
Fin de votre tour
4 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

DEUXIÈME & TROISIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement
5 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).

À PARTIR DU QUATRIÈME ROUND DE BATAILLE
Fin de votre tour
6 PV chacun : Pour chaque objectif que vous contrôlez (à l'exclusion de votre objectif de camp).""",
    action: null,
  ),
  (
    yourSlug: 'disruption',
    opponentSlug: 'reconnaissance',
    name: 'Fumée et Miroirs',
    scoring: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV chacun : Pour chaque objectif leurré (voir au dos).
+2 PV chacun (cumulatif) : Pour chacun de ces objectifs situé dans le territoire de votre adversaire.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin de votre phase de Commandement (ou fin de votre tour au cinquième round de bataille)
4 PV : Vous contrôlez un ou plusieurs objectifs (à l'exclusion de votre objectif de camp).

FIN DE PARTIE
10 PV : Quatre objectifs ou plus sont leurrés.""",
    action: """
LEURRER – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif (à l'exclusion de votre objectif de camp) qui n'est pas leurré.
LIMITE D'UTILISATION : Illimitée. Chaque unité qui commence cette action ce tour-ci doit être à portée d'un objectif différent.
TERMINÉE : Fin de votre tour, si votre unité contrôle cet objectif.
EFFET : Cet objectif est leurré : placez un de vos marqueurs d'opération à portée de cet objectif.""",
  ),
];

const _secondaryMissions = <_SecondaryMission>[
  (
    slug: 'a-grievous-blow',
    name: 'Un Coup Cruel',
    isFixed: true,
    effect: """
QUAND PIOCHÉE : S'il n'y a aucune unité ennemie avec un effectif de départ de 13 ou plus sur le champ de bataille, vous pouvez défausser cette carte et piocher une nouvelle carte Mission Secondaire.

N'IMPORTE QUEL ROUND DE BATAILLE · FIXE
Fin d'un tour
4 PV chacune : Pour chaque unité ennemie avec un effectif de départ de 13 ou plus détruite ce tour-ci.

N'IMPORTE QUEL ROUND DE BATAILLE · TACTIQUE
Fin du tour de l'un ou l'autre joueur
5 PV : Une ou plusieurs unités ennemies avec un effectif de départ de 13 ou plus ont été détruites ce tour-ci.""",
  ),
  (
    slug: 'a-tempting-target',
    name: 'Une Cible Alléchante',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : Votre adversaire sélectionne un objectif (à l'exclusion des objectifs de camp) dans le No Man's Land pour être votre cible alléchante.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
5 PV : Vous contrôlez votre cible alléchante.""",
  ),
  (
    slug: 'assassination',
    name: 'Assassinat',
    isFixed: true,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE · FIXE
Tant que cette carte est active
3 PV chacun : Pour chaque modèle PERSONNAGE ennemi détruit ce tour-ci.
+1 PV (cumulatif) : Pour chacun de ces modèles avec une caractéristique de Blessures (B) de 4 ou plus.

N'IMPORTE QUEL ROUND DE BATAILLE · TACTIQUE
Fin du tour de l'un ou l'autre joueur
5 PV : Un ou plusieurs modèles PERSONNAGE ennemis ont été détruits ce tour-ci.
OU 5 PV : Tous les modèles PERSONNAGE ennemis ont été détruits pendant la partie.""",
  ),
  (
    slug: 'beacon',
    name: 'Balise',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : Sélectionnez une unité amie sur le champ de bataille ou embarquée dans un TRANSPORT sur le champ de bataille pour être votre unité balise.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin du tour de votre adversaire ou fin du cinquième round de bataille (la première éventualité prévalant)
3 PV : Votre unité balise est sur le champ de bataille et n'est pas dans votre zone de déploiement.
OU 5 PV : Votre unité balise est sur le champ de bataille et n'est pas dans votre territoire.""",
  ),
  (
    slug: 'behind-enemy-lines',
    name: 'Derrière les Lignes Ennemies',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : S'il s'agit du premier round de bataille, vous pouvez piocher une nouvelle carte Mission Secondaire et remélanger cette carte dans votre paquet de Missions Secondaires.

N'IMPORTE QUEL ROUND DE BATAILLE · MAX 5 PV
Fin de votre tour
3 PV chacune : Pour chaque unité amie (à l'exclusion des unités AÉRONEF et des unités sous le choc) entièrement dans la zone de déploiement de votre adversaire.""",
  ),
  (
    slug: 'bring-it-down',
    name: 'Abattre',
    isFixed: true,
    effect: """
QUAND PIOCHÉE : S'il n'y a aucun modèle ennemi avec une caractéristique de Blessures de 10 ou plus sur le champ de bataille, vous pouvez défausser cette carte et piocher une nouvelle carte Mission Secondaire.

N'IMPORTE QUEL ROUND DE BATAILLE · FIXE
Fin d'un tour
4 PV chacun : Pour chaque modèle ennemi avec une caractéristique de Blessures de 10 ou plus détruit ce tour-ci.

N'IMPORTE QUEL ROUND DE BATAILLE · TACTIQUE
Fin d'un tour
5 PV : Un ou plusieurs modèles ennemis avec une caractéristique de Blessures de 10 ou plus ont été détruits ce tour-ci.""",
  ),
  (
    slug: 'burden-of-trust',
    name: 'Fardeau de la Confiance',
    isFixed: false,
    effect: """
QUAND PIOCHÉE / DÉBUT DE VOTRE TOUR : Pour chaque objectif, vous pouvez sélectionner une unité amie sur le champ de bataille pour garder cet objectif. Jusqu'au début de votre prochain tour, tant que cette unité est à portée de cet objectif et que vous contrôlez cet objectif, cet objectif est gardé par votre armée.

N'IMPORTE QUEL ROUND DE BATAILLE · MAX 5 PV
Fin du tour de votre adversaire ou fin du cinquième round de bataille (la première éventualité prévalant)
2 PV chacun : Pour chaque objectif gardé par votre armée.""",
  ),
  (
    slug: 'centre-ground',
    name: 'Terrain Central',
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités amies (à l'exclusion des unités AÉRONEF et des unités sous le choc) sont à moins de 3" du centre du champ de bataille, et aucune unité ennemie n'est à moins de 3" du centre du champ de bataille.
OU 5 PV : Une ou plusieurs unités amies (à l'exclusion des unités AÉRONEF et des unités sous le choc) sont à moins de 3" du centre du champ de bataille, et aucune unité ennemie n'est à moins de 6" du centre du champ de bataille.""",
  ),
  (
    slug: 'cleanse',
    name: 'Purifier',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : Si la Mission Secondaire Piller est active pour vous, vous pouvez piocher une nouvelle carte Mission Secondaire et remélanger cette carte dans votre paquet de Missions Secondaires.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV : Un objectif a été purifié par votre armée ce tour-ci.
OU 5 PV : Deux objectifs ou plus ont été purifiés par votre armée ce tour-ci.

PURIFIER – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité amie à portée d'un objectif (à l'exclusion de votre objectif de camp).
LIMITE D'UTILISATION : Illimitée. Chaque unité qui commence cette action ce tour-ci doit être à portée d'un objectif différent.
TERMINÉE : Fin de votre tour, si cette unité contrôle cet objectif.
EFFET : Cet objectif est purifié par votre armée.""",
  ),
  (
    slug: 'defend-stronghold',
    name: 'Défendre le Bastion',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : S'il s'agit du premier round de bataille, piochez une nouvelle carte Mission Secondaire et remélangez cette carte dans votre paquet de Missions Secondaires.

À PARTIR DU DEUXIÈME ROUND DE BATAILLE
Fin du tour de votre adversaire ou fin du cinquième round de bataille (la première éventualité prévalant)
3 PV : Vous contrôlez votre objectif de camp.
+2 PV (cumulatif) : Aucune unité ennemie n'est dans votre zone de déploiement.""",
  ),
  (
    slug: 'display-of-might',
    name: 'Démonstration de Force',
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
2 PV : Il y a plus d'unités amies que d'unités ennemies (à l'exclusion des unités AÉRONEF et des unités sous le choc) entièrement dans le No Man's Land.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin du tour de votre adversaire
5 PV : Il y a plus d'unités amies que d'unités ennemies (à l'exclusion des unités AÉRONEF et des unités sous le choc) entièrement dans le No Man's Land.""",
  ),
  (
    slug: 'engage-on-all-fronts',
    name: 'Combattre sur Tous les Fronts',
    isFixed: true,
    effect: """
RÈGLE : Si une ou plusieurs unités amies (à l'exclusion des unités AÉRONEF et des unités sous le choc) sont entièrement dans un quart de table, et que ces unités ne sont pas à moins de 6" du centre du champ de bataille, vous avez une présence dans ce quart de table.

N'IMPORTE QUEL ROUND DE BATAILLE · FIXE
Fin de votre tour
2 PV : Vous avez une présence dans trois quarts de table.
OU 4 PV : Vous avez une présence dans quatre quarts de table.

N'IMPORTE QUEL ROUND DE BATAILLE · TACTIQUE
Fin de votre tour
3 PV : Vous avez une présence dans trois quarts de table.
OU 5 PV : Vous avez une présence dans quatre quarts de table.""",
  ),
  (
    slug: 'forward-position',
    name: 'Position Avancée',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : S'il s'agit du premier round de bataille, vous pouvez piocher une nouvelle carte Mission Secondaire et remélanger cette carte dans votre paquet de Missions Secondaires.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
5 PV : Vous contrôlez l'objectif de camp de votre adversaire et/ou chaque objectif d'expansion.""",
  ),
  (
    slug: 'no-prisoners',
    name: 'Pas de Quartier',
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE · MAX 5 PV
Fin d'un tour
2 PV chacune : Pour chaque unité ennemie détruite ce tour-ci.""",
  ),
  (
    slug: 'outflank',
    name: 'Prendre à Revers',
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
3 PV : Une ou plusieurs unités amies (à l'exclusion des unités AÉRONEF et des unités sous le choc) sont à moins de 6" d'un ou plusieurs bords de champ de bataille et ne sont pas dans votre territoire.
OU 5 PV : Deux unités amies ou plus (à l'exclusion des unités AÉRONEF et des unités sous le choc) sont à moins de 6" de bords de champ de bataille opposés, et une ou plusieurs de ces unités ne sont pas dans votre territoire.

Note du concepteur : Les bords de champ de bataille opposés sont ceux qui sont parallèles entre eux.""",
  ),
  (
    slug: 'overwhelming-force',
    name: 'Force Écrasante',
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE · MAX 5 PV
Fin d'un tour
3 PV chacune : Pour chaque unité ennemie ayant commencé le tour à portée d'un ou plusieurs objectifs et détruite.""",
  ),
  (
    slug: 'plunder',
    name: 'Piller',
    isFixed: false,
    effect: """
QUAND PIOCHÉE : Si la Mission Secondaire Purifier est active pour vous, vous pouvez piocher une nouvelle carte Mission Secondaire et remélanger cette carte dans votre paquet de Missions Secondaires.

N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
5 PV : Une zone de terrain a été pillée ce tour-ci.

PILLER – ACTION D'OBJECTIF
DÉBUT : Votre phase de Tir.
UNITÉS : Une unité dans une zone de terrain qui n'est pas dans votre territoire.
LIMITE D'UTILISATION : Une fois par tour.
TERMINÉE : Immédiatement.
EFFET : Cette zone de terrain est pillée.""",
  ),
  (
    slug: 'secure-no-man-s-land',
    name: "Sécuriser le No Man's Land",
    isFixed: false,
    effect: """
N'IMPORTE QUEL ROUND DE BATAILLE
Fin de votre tour
5 PV : Vous contrôlez deux objectifs ou plus dans le No Man's Land (à l'exclusion de votre objectif de camp).""",
  ),
];
