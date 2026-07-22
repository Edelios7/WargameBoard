# -*- coding: utf-8 -*-
"""Parse le Munitorum Field Manual (points values officiels) et met a
jour datasheet_costs pour les datasheets existantes qui matchent par
nom (meme matcher tolerant EN/FR que apply_faction_pack_updates.py,
la base ayant des noms francais).

Le schema stocke un cout par palier de taille d'unite (colonne
datasheet_costs.model_count) : quand le MFM liste plusieurs paliers
(ex. 5 modeles = 85 pts, 10 modeles = 160 pts), on ecrit une ligne par
palier au lieu de ne garder que le moins cher — beaucoup d'unites
Warhammer 40k ne montent pas en cout de facon lineaire avec l'effectif.
Necessite que l'appli ait deja applique sa migration de schema (qui
ajoute cette colonne) avant de lancer ce script avec --apply.

On rattache aussi tout a l'edition existante 'ed-w40k-10e' : l'appli ne
modelise pas encore plusieurs editions, cette ligne fait office
d'edition "courante" unique (marquee is_current), donc on ne cree pas
de nouvelle edition pour ne rien casser ailleurs.

Usage: python apply_mfm_points.py [--apply] [--only <faction_substr>]
"""
import difflib
import glob
import json
import os
import re
import shutil
import sqlite3
import sys
import unicodedata
from datetime import datetime

from pypdf import PdfReader

MFM_PATH = (
    r"C:\Projet\wargameboard\local_assets\wh40k_reference\PDFS"
    r"\eng_12-11_wh40k_munitorum_field_manual-oxvdqehej9-uocmdbsqid.pdf"
)
DB_PATH = r"C:\Users\Edelios\Documents\wargame_board.sqlite"
REPORT_PATH = r"C:\Projet\wargameboard\local_assets\wh40k_reference\mfm_points_report.md"
EDITION_ID = "ed-w40k-10e"

FACTION_TITLE_MAP = {
    "adepta sororitas": "Adepta Sororitas",
    "adeptus custodes": "Adeptus Custodes",
    "adeptus mechanicus": "Adeptus Mechanicus",
    "aeldari": "Aeldari",
    "astra militarum": "Astra Militarum",
    "black templars": "Black Templars",
    "blood angels": "Blood Angels",
    "chaos daemons": "Chaos Daemons",
    "chaos knights": "Chaos Knights",
    "chaos space marines": "Chaos Space Marines",
    "dark angels": "Dark Angels",
    "death guard": "Death Guard",
    "deathwatch": "Deathwatch",
    "drukhari": "Drukhari",
    "genestealer cults": "Genestealer Cults",
    "grey knights": "Grey Knights",
    "imperial agents": "Agents de l'Imperium",
    "imperial knights": "Imperial Knights",
    "leagues of votann": "Leagues of Votann",
    "necrons": "Necrons",
    "orks": "Orks",
    "space marines": "Space Marines (Adeptus Astartes)",
    "space wolves": "Space Wolves",
    "t'au empire": "T'au Empire",
    "tau empire": "T'au Empire",
    "thousand sons": "Thousand Sons",
    "tyranids": "Tyranids",
    "world eaters": "World Eaters",
}
SKIP_TITLES = {"adeptus titanicus", "emperor's children", "emperor s children"}

HEADER_RE = re.compile(r"^(CODEX|INDEX)(\s+SUPPLEMENT)?\s*:\s*(.*)$", re.IGNORECASE)
COST_RE = re.compile(r"^(.+?)\.{2,}\s*([\d,]+)\s*pts\.?\s*$")
FORGE_WORLD_HDR = "FORGE WORLD POINTS VALUES"
ENHANCEMENTS_HDR = "DETACHMENT ENHANCEMENTS"

STOPWORDS = {
    "squad", "escouade", "with", "avec", "de", "du", "des", "la", "le", "les",
    "d", "in", "en", "a", "the", "of", "et", "and", "au", "aux", "un", "une",
    "unit", "unite", "on", "for", "an", "l",
}
SYNONYMS = {
    "assaut": "assault", "tactique": "tactical", "veterans": "veteran",
    "veteran": "veteran", "eclaireur": "scout", "eclaireurs": "scout",
    "lourde": "heavy", "lourd": "heavy", "moto": "bike", "motos": "bike",
    "capitaine": "captain", "chapelain": "chaplain", "archiviste": "librarian",
    "sergent": "sergeant", "predateur": "predator",
}
AUTO_APPLY_THRESHOLD = 0.85

# Correspondances EN (nom MFM) -> FR (nom exact en base) verifiees a la
# main pour les cas ou le score echoue (traduction complete, pas juste
# une variante orthographique). Cle en minuscules. Seules les paires ou
# je suis confiant qu'il s'agit bien de la meme datasheet sont listees
# ici : les MFM units dont la meilleure candidate en base est en realite
# une AUTRE unite sont volontairement laissees de cote pour ne pas leur
# attribuer un cout errone.
GLOBAL_ALIASES = {
    "saint celestine": "sainte célestine",
    "allarus custodians": "custodiens allarus",
    "blade champion": "champion des lames",
    "knight-centura": "chevalier-centura",
    "shield-captain": "capitaine-rempart",
    "kataphron breachers": "brécheurs kataphron",
    "skitarii marshal": "maréchal skitarii",
    "skorpius disintegrator": "désintégrateur skorpius",
    "fire dragons": "dragons flamboyants",
    "howling banshees": "banshees huantes",
    "striking scorpions": "scorpions foudroyants",
    "warlock conclave": "conclave de psycharques",
    "wave serpent": "serpent ondoyant",
    "cadian castellan": "castellan cadien",
    "gaunt's ghosts": "fantômes de gaunt",
    "militarum tempestus command squad": "escouade d’état-major du militarum tempestus",
    "ratlings": "snipers ratlings",
    "rogal dorn battle tank": "char de combat rogal dorn",
    "tempestus scions": "fils du tempestus",
    "emperor's champion": "le champion de l ’empereur",
    "chief librarian mephiston": "maître archiviste méphiston",
    "commander dante": "commandeur dante",
    "beasts of nurgle": "bêtes de nurgle",
    "contorted epitome": "épitome tortueux",
    "daemon prince of chaos": "prince démon du chaos",
    "daemon prince of chaos with wings": "prince démon du chaos",
    "keeper of secrets": "gardien des secrets",
    "the blue scribes": "les scribes bleus",
    "abaddon the despoiler": "abaddon le fléau",
    "chaos lord": "seigneur du chaos",
    "heretic astartes daemon prince": "prince démon de l ’hereticus astartes",
    "master of executions": "maître des exécutions",
    "master of possession": "maître de la possession",
    "warp talons": "serres du warp",
    "land speeder vengeance": "land speeder vengeance de la ravenwing",
    "biologus putrifier": "biologus putréfacteur",
    "lord of contagion": "seigneur de la contagion",
    "lord of virulence": "seigneur de la virulence",
    "plague marines": "marines de la peste",
    "watch captain artemis": "capitaine du guet artemis",
    "goliath rockgrinder": "concasseur goliath",
    "jackal alphus": "alphus chacal",
    "brother-captain": "frère-capitaine",
    "brotherhood champion": "champion de confrérie",
    "brotherhood chaplain": "chapelain de confrérie",
    "brotherhood librarian": "archiviste de confrérie",
    "brotherhood techmarine": "techmarine de confrérie",
    "brotherhood terminator squad": "escouade terminator de confrérie",
    "grand master": "grand maître",
    "grand master in nemesis dreadknight": "grand maître en cuirasse némésis",
    "grand master voldus": "grand maître voldus",
    "land raider redeemer": "land raider redeemer des grey knights",
    "nemesis dreadknight": "cuirassier némésis",
    "inquisitor coteaz": "inquisiteur coteaz",
    "inquisitor greyfax": "inquisitrice greyfax",
    "knight castellan": "chevalier castellan",
    "knight errant": "chevalier errant",
    "knight paladin": "chevalier paladin",
    "cthonian beserks": "beserks cthoniens",
    "ûthar the destined": "ûthar le destiné",
    "canoptek reanimator": "réanimateur canoptek",
    "convergence of dominion": "convergence de domination",
    "lokhust lord": "seigneur lokhust",
    "orikan the diviner": "orikan le devin",
    "royal warden": "garde royal",
    "skorpekh lord": "seigneur skorpekh",
    "tesseract vault": "crypte tesseract",
    "trazyn the infinite": "trazyn l ’infini",
    "big mek in mega armour": "gros mek en méga-armure",
    "kustom boosta-blasta": "boosta-klata kustom",
    "shokkjump dragsta": "dragsta shokk",
    "apothecary biologis": "apothicaire biologis",
    "bladeguard ancient": "doyen bladeguard",
    "captain in gravis armour": "capitaine en armure gravis",
    "captain in phobos armour": "capitaine en armure phobos",
    "captain in terminator armour": "capitaine en armure terminator",
    "cato sicarius": "capitaine sicarius",
    "centurion assault squad": "escouade d’assaut centurion",
    "chaplain in terminator armour": "chapelain en armure terminator",
    "chief librarian tigurius": "maître archiviste tigurius",
    "firestrike servo-turrets": "servo-tourelles firestrike",
    "invader atv": "quad invader",
    "librarian in phobos armour": "archiviste en armure phobos",
    "librarian in terminator armour": "archiviste en armure terminator",
    "lieutenant in phobos armour": "lieutenant en armure phobos",
    "lieutenant in reiver armour": "lieutenant en armure reiver",
    "marneus calgar in armour of antilochus": "marneus calgar",
    "ulrik the slayer": "ulrik le tueur",
    "commander farsight": "commandant farsight",
    "commander shadowsun": "commandante shadowsun",
    "hammerhead gunship": "char hammerhead",
    "sky ray gunship": "char sky ray",
    "sun shark bomber": "bombardier sun shark",
    "infernal master": "maître infernal",
    "magnus the red": "magnus le rouge",
    "rubric marines": "marines rubricae",
    "tzaangor shaman": "chaman tzaangor",
    "mucolid spores": "spores mucolides",
    "spore mines": "spores mines",
    "von ryan's leapers": "bondisseurs de von ryan",
    "khârn the betrayer": "khârn le félon",
    "khorne berzerkers": "berzerks de khorne",
    "lord invocatus": "seigneur invocatus",
    "battle sisters squad": "escouade de sœurs de bataille",
    "canoness": "chanoinesse",
    "canoness with jump pack": "chanoinesse",
    "celestian sacresants": "célestes sacro-saintes",
    "dominion squad": "escouade dominion",
    "hospitaller": "hospitalière",
    "imagifier": "imagifère",
    "ministorum priest": "prêcheur",
    "mortifiers": "machines de pénitence",
    "paragon warsuits": "exo-harnais parangon",
    "penitent engines": "machines de pénitence",
    "repentia squad": "escouade repentia",
    "retributor squad": "escouade retributor",
    "sanctifiers": "célestes sacro-saintes",
    "seraphim squad": "escouade séraphine",
    "sisters novitiate squad": "escouade de sœurs novices",
    "zephyrim squad": "escouade zéphyrine",
    "sororitas rhino": "rhino sororitas",
    "custodian guard": "garde custodienne",
    "custodian wardens": "gardes custodiens",
    "witchseekers": "chercheuses de sorcières",
    "shield-captain on dawneagle jetbike": "capitaine-rempart sur motojet dawneagle",
    "custodian guard": "gardes custodiens",
    "allarus terminator armour": "capitaine-rempart en armure terminator allarus",
    "ironstrider ballistarii": "ferro-échassiers ballistarii",
    "onager dunecrawler": "onagre des dunes",
    "sicarian infiltrators": "infiltrateurs sicariens",
    "sicarian ruststalkers": "corrôdeurs sicariens",
    "tech-priest dominus": "technoprêtre dominus",
    "tech-priest manipulus": "technoprêtre manipulus",
    "tech-priest enginseer": "technaugure",
    "kataphron destroyers": "destructeurs kataphron",
    "cybernetica datasmith": "compilateur cybernétique",
    "skorpius dunerider": "glisseur skorpius",
    "serberys raiders": "hussards serberys",
    "serberys sulphurhounds": "soufredogues serberys",
    "pteraxii skystalkers": "vautours pteraxii",
    "pteraxii sterylizors": "stérilisateurs pteraxii",
    "skitarii vanguard": "patrouilleurs skitarii",
    "corpuscarii electro-priests": "électroprêtres corpuscarii",
    "fulgurite electro-priests": "électroprêtres fulgurites",
    "servitor battleclade": "servitors",
    "autarch": "autarque",
    "autarch wayleaper": "autarque sautevoie",
    "dark reapers": "faucheurs noirs",
    "death jester": "bouffon tragique",
    "dire avengers": "vengeurs lugubres",
    "falcon": "faucon",
    "farseer": "psycharque",
    "farseer skyrunner": "psycharque coureur céleste",
    "fire prism": "prisme de feu",
    "guardian defenders": "gardiens défenseurs",
    "night spinner": "tisseur de nuit",
    "shadowseer": "prophète de l’ombre",
    "shining spears": "lances étincelantes",
    "shroud runners": "coureurs mirages",
    "skyweavers": "tisseurs célestes",
    "starweaver": "tisseur stellaire",
    "storm guardians": "gardiens de choc",
    "swooping hawks": "éperviers voltigeurs",
    "warlock skyrunners": "conclave de psycharques coureurs célestes",
    "warp spiders": "araignées spectrales",
    "windriders": "gardiens du vent",
    "wraithguard": "gardes fantômes",
    "wraithblades": "guerriers fantômes",
    "wraithknight": "chevalier fantôme",
    "wraithlord": "seigneur fantôme",
    "the visarch": "le visarque",
    "war walker": "marcheurs de guerre",
    "aegis defence line": "ligne de défense aegis",
    "attilan rough riders": "cavaliers d’attila",
    "bullgryn squad": "escouade de taurogryns",
    "cadian command squad": "escouade d’état-major cadienne",
    "cadian shock troops": "troupes de choc cadiennes",
    "catachan jungle fighters": "combattants des jungles de catachan",
    "ogryn bodyguard": "garde du corps ogryn",
    "ogryn squad": "escouade d’ogryns",
    "leman russ battle tank": "char de combat leman russ",
    "lord solar leontus": "seigneur solaire leontus",
    "armoured sentinels": "sentinel blindés",
    "scout sentinels": "sentinel de reconnaissance",
    "artillery team": "batterie d’artillerie",
    "sword brethren": "frères d’épée primaris",
    "high marshal helbrecht": "grand sénéchal helbrecht",
    "marshal": "maréchal",
    "death company dreadnought": "dreadnought de la compagnie de la mort",
    "sanguinary priest": "prêtre sanguinien",
    "plaguebearers": "portepestes",
    "bloodletters": "sanguinaires",
    "pink horrors": "horreurs roses",
    "blue horrors": "horreurs bleues",
    "plague drones": "bourdons de la peste",
    "flesh hounds": "molosses de khorne",
    "screamers": "hurleurs",
    "flamers": "incendiaires",
    "exalted flamer": "incendiaire exalté",
    "great unclean one": "grand immonde",
    "bloodthirster": "buveur de sang",
    "skull cannon": "canon à crânes",
    "skull altar": "autel des crânes",
    "skullmaster": "maître des crânes",
    "bloodmaster": "maître du sang",
    "poxbringer": "porte-vérole",
    "rendmaster on blood throne": "mutileur sur trône de sang",
    "tormentbringer": "tourmenteuse sur char traqueur exalté",
    "feculent gnarlmaw": "gueule noueuse immonde",
    "lord of change": "duc du changement",
    "infernal enrapturess": "séductrice infernale",
    "tranceweaver": "tissetranse",
    "knight abominant": "chevalier abominable",
    "knight desecrator": "chevalier profanateur",
    "knight despoiler": "chevalier pillard",
    "knight rampager": "chevalier saccageur",
    "war dog brigand": "dogue brigand",
    "war dog executioner": "dogue exécuteur",
    "war dog karnivore": "dogue karnivore",
    "war dog huntsman": "dogue chasseur",
    "war dog stalker": "dogue rabatteur",
    "chaos lord in terminator armour": "seigneur du chaos en armure terminator",
    "chaos spawn": "rejetons du chaos",
    "sorcerer": "sorcier",
    "sorcerer in terminator armour": "sorcier en armure terminator",
    "dark apostle": "apôtre noir",
    "chosen": "élus",
    "warpsmith": "techmancien",
    "helbrute": "métabrutus",
    "heldrake": "métaragne",
    "lord discordant on helstalker": "seigneur de la discorde sur métarôdeur",
    "khorne lord of skulls": "seigneur des crânes de khorne",
    "traitor guardsmen squad": "escouade de gardes renégats",
    "fellgor beastmen": "hommes-bêtes affregors",
    "cultist mob": "bande de cultistes",
    "accursed cultists": "cultistes maudits",
    "defiler": "profanateur",
    "raptors": "rapaces",
    "chaos bikers": "motards du chaos",
    "noctilith crown": "couronne de noctilithe",
    "blightlord terminators": "terminators rouillarques",
    "deathshroud terminators": "terminators du linceul",
    "foetid bloat-drone": "drone fétide",
    "myphitic blight-haulers": "semi-chenillés méphitiques",
    "foul blightspawn": "essaimeur répugnant",
    "icon bearer": "porte-icône de la death guard",
    "plague surgeon": "chirurgien de la peste",
    "tallyman": "intendant",
    "noxious blightbringer": "corrupteur nidoreux",
    "watch master": "maître du guet",
    "hand of the archon": "cour de l’archonte",
    "kabalite warriors": "guerriers kabalites",
    "ravager": "ravageur",
    "reavers": "écumeurs",
    "acolyte iconward": "acolyte garde-icône",
    "purestrain genestealers": "genestealers pure-souche",
    "goliath truck": "camion goliath",
    "neophyte hybrids": "hybrides néophytes",
    "atalan jackals": "chacals atalans",
    "achilles ridgerunners": "tout-terrain achilles",
    "purgation squad": "escouade purgator",
    "purifier squad": "escouade purificator",
    "inquisitor draxus": "dame inquisitrice kyria draxus",
    "exaction squad": "escouade d’exaction",
    "voidsmen-at-arms": "cosmomarins en armes",
    "imperial navy breachers": "sapeurs de la marine impériale",
    "armiger warglaive": "armigères hastaires",
    "knight gallant": "chevalier galant",
    "knight preceptor": "chevalier précepteur",
    "knight valiant": "chevalier vaillant",
    "knight warden": "chevalier vigilant",
    "knight crusader": "chevalier croisé",
    "hearthkyn warriors": "guerriers âtrekogs",
    "brôkhyr thunderkyn": "tonnekogs brokhyrs",
    "hernkyn pioneers": "pionniers hernkogs",
    "einhyr hearthguard": "âtregardes einhyrs",
    "hekaton land fortress": "forteresse mobile hekaton",
    "overlord": "dynaste",
    "necron warriors": "guerriers nécrons",
    "annihilation barge": "console d’annihilation",
    "catacomb command barge": "console de commandement",
    "c'tan shard of the nightbringer": "écharde c’tan du nyctophore",
    "c'tan shard of the void dragon": "écharde c’tan du dragon du néant",
    "lokhust destroyers": "destroyers lokhusts",
    "lokhust heavy destroyers": "destroyers lourds lokhusts",
    "skorpekh destroyers": "destroyers skorpekhs",
    "ophydian destroyers": "destroyers ophydiens",
    "triarch praetorians": "prétoriens du triarcat",
    "triarch stalker": "rôdeur du triarcat",
    "cryptothralls": "cryptoserfs",
    "imotekh the stormlord": "imotekh le seigneur des tempêtes",
    "the silent king": "le roi silencieux",
    "big mek with shokk attack gun": "gros mek avec kanon shokk",
    "apothecary": "apothicaire primaris",
    "lieutenant with combi-weapon": "lieutenant avec arme combinée",
    "judiciar": "judicateur",
    "iron father feirros": "révérend de fer feirros",
    "assault intercessor squad": "escouade d’assaut intercessor",
    "sternguard veteran squad": "escouade de vétérans sternguards",
    "vanguard veteran squad with jump packs": "escouade de vétérans vanguards à réacteurs dorsaux",
    "bladeguard veteran squad": "escouade de vétérans bladeguards",
    "terminator assault squad": "escouade d’assaut terminator",
    "scout squad": "escouade de scouts",
    "ancient": "doyen primaris",
    "ancient in terminator armour": "doyen en armure terminator",
    "captain with jump pack": "capitaine à réacteur dorsal",
    "chaplain with jump pack": "chapelain à réacteur dorsal",
    "drop pod": "module de largage",
    "invictor tactical warsuit": "exo-harnais tactique invictor",
    "desolation squad": "escouade desolator",
    "blood claws": "griffes sanglantes",
    "grey hunters": "chasseurs gris",
    "bjorn the fell-handed": "björn main funeste",
    "fenrisian wolves": "loups fenrissiens",
    "wolf guard battle leader": "chef de meute garde loup",
    "wolf guard terminators": "terminators gardes loups",
    "wolf guard headtakers": "gardes loups",
    "iron priest": "prêtre de fer",
    "wolf scouts": "scouts space wolves",
    "thunderwolf cavalry": "cavalerie sur loups tonnerre",
    "breacher team": "équipe de brécheurs",
    "cadre fireblade": "sabre de feu",
    "commander in coldstar battlesuit": "commandant en exo-armure coldstar",
    "commander in enforcer battlesuit": "commandant en exo-armure enforcer",
    "broadside battlesuits": "exo-armures broadside",
    "ghostkeel battlesuit": "exo-armure ghostkeel",
    "kroot carnivores": "carnivores kroots",
    "kroot hounds": "chiens kroots",
    "kroot trail shaper": "exorôdeurs kroots",
    "kroot flesh shaper": "mentor kroot",
    "krootox riders": "cavaliers krootox",
    "stealth battlesuits": "exo-armures stealth",
    "riptide battlesuit": "exo-armure riptide",
    "tidewall shieldline": "ligne-bouclier tidewall",
    "tidewall gunrig": "tourelle tidewall",
    "vespid stingwings": "frelons vespides",
    "exalted sorcerer": "sorcier exalté",
    "exalted sorcerer on disc of tzeentch": "sorcier exalté sur disque de tzeentch",
    "tzaangor enlightened": "tzaangors éclairés",
    "mutalith vortex beast": "mutalithe à vortex",
    "scarab occult terminators": "terminators du scarabée occulte",
    "raveners": "rôdeurs",
    "hive guard": "gardes des ruches",
    "gargoyles": "gargouilles",
    "hive tyrant": "tyran des ruches",
    "winged hive tyrant": "tyran des ruches ailé",
    "old one eye": "le vieux borgne",
    "sporocyst": "sporokyste",
    "the swarmlord": "le maître des essaims",
    "tyranid warriors with melee bio-weapons": "guerriers tyranides avec bio-armes de mêlée",
    "tyranid warriors with ranged bio-weapons": "guerriers tyranides avec bio-armes de tir",
    "tyrant guard": "gardes tyranides",
    "winged tyranid prime": "primat tyranide ailé",
    "jakhals": "chakhals",
    "eightbound": "octoliés",
    "exalted eightbound": "octoliés exaltés",
}

# Cas ou le meme nom MFM apparait pour plusieurs factions (Chaos Land
# Raider, Predator...) avec un nom de fiche different par faction : cle
# (titre de faction MFM en minuscules, nom MFM en minuscules).
FACTION_ALIASES = {
    ("death guard", "chaos land raider"): "land raider de la death guard",
    ("death guard", "chaos predator annihilator"): "predator annihilator de la death guard",
    ("death guard", "chaos predator destructor"): "predator destructor de la death guard",
    ("thousand sons", "chaos land raider"): "land raider des thousand sons",
    ("thousand sons", "chaos predator annihilator"): "predator annihilator des thousand sons",
    ("thousand sons", "chaos predator destructor"): "predator destructor des thousand sons",
    ("world eaters", "chaos land raider"): "land raider des world eaters",
    ("world eaters", "chaos predator annihilator"): "predator annihilator des world eaters",
    ("world eaters", "chaos predator destructor"): "predator destructor des world eaters",
    ("grey knights", "land raider"): "land raider des grey knights",
    ("grey knights", "razorback"): "razorback des grey knights",
    ("grey knights", "rhino"): "rhino des grey knights",
    ("grey knights", "land raider crusader"): "land raider crusader des grey knights",
    ("grey knights", "venerable dreadnought"): "dreadnought vénérable des grey knights",
    ("space wolves", "venerable dreadnought"): "dreadnought vénérable des space wolves",
    ("astra militarum", "ministorum priest"): "prêcheur régimentaire",
    ("astra militarum", "tech-priest enginseer"): "technaugure régimentaire",
    ("blood angels", "blood angels captain"): "captain",
    ("blood angels", "death company marines with bolt rifles"): "intercessors de la compagnie de la mort",
    ("blood angels", "death company marines with jump packs"): "marines de la compagnie de la mort à réacteurs dorsaux",
    ("death guard", "chaos rhino"): "rhino de la death guard",
    ("death guard", "defiler"): "profanateur de la death guard",
    ("death guard", "daemon prince of nurgle"): "prince démon de la death guard",
    ("death guard", "daemon prince of nurgle with wings"): "prince démon de la death guard ailé",
    ("thousand sons", "sorcerer"): "sorcier des thousand sons",
    ("thousand sons", "sorcerer in terminator armour"): "sorcier des thousand sons en armure terminator",
    ("thousand sons", "daemon prince of tzeentch"): "prince démon des thousand sons",
    ("thousand sons", "daemon prince of tzeentch with wings"): "prince démon des thousand sons ailé",
    ("thousand sons", "chaos rhino"): "rhino des thousand sons",
    ("thousand sons", "chaos vindicator"): "vindicator des thousand sons",
    ("thousand sons", "chaos spawn"): "rejetons du chaos des thousand sons",
    ("thousand sons", "defiler"): "profanateur des thousand sons",
    ("thousand sons", "helbrute"): "métabrutus des thousand sons",
    ("world eaters", "chaos terminators"): "escouade terminator des world eaters",
    ("world eaters", "daemon prince of khorne"): "prince démon des world eaters",
    ("world eaters", "daemon prince of khorne with wings"): "prince démon des world eaters ailé",
    ("world eaters", "chaos rhino"): "rhino des world eaters",
    ("world eaters", "chaos spawn"): "rejetons du chaos des world eaters",
    ("world eaters", "defiler"): "profanateur des world eaters",
    ("world eaters", "helbrute"): "métabrutus des world eaters",
}


# unicodedata NFKD ne decompose PAS les ligatures (oe/ae) : "SŒURS" perd
# le "O" en le passant en ascii ("SURS") si on ne le fait pas nous-memes
# avant, ce qui casse le matching de tout mot contenant ce caractere
# (frequent en francais : sœurs, cœur, manœuvre...).
_LIGATURES = str.maketrans({"œ": "oe", "Œ": "OE", "æ": "ae", "Æ": "AE"})


def _fold_ascii(name):
    s = name.translate(_LIGATURES)
    return unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode()


def norm_tokens(name):
    s = re.sub(r"[^a-zA-Z0-9\s]", " ", _fold_ascii(name)).lower()
    tokens = set()
    for t in s.split():
        t = SYNONYMS.get(t, t)
        if t in STOPWORDS or len(t) < 2:
            continue
        tokens.add(t)
    return tokens


def norm_string(name):
    s = re.sub(r"[^a-zA-Z0-9\s]", " ", _fold_ascii(name)).lower()
    return re.sub(r"\s+", " ", s).strip()


def score(a, b):
    if not a or not b:
        return 0.0
    inter = len(a & b)
    union = len(a | b)
    return inter / union if union else 0.0


def best_match(name, candidates):
    p_tok = norm_tokens(name)
    p_str = norm_string(name)

    def combined(cname):
        # Le score par tokens attrape les traductions mot-a-mot dans le
        # desordre ("Ironclad Dreadnought" / "Dreadnought Ironclad") ; le
        # ratio caractere-a-caractere attrape les variantes d'orthographe
        # tres proches qui ne partagent aucun token identique une fois
        # normalisees ("Daemonifuge" / "Demonifuge", "Imagifier" /
        # "Imagifiere") sans risquer de confondre deux unites vraiment
        # differentes (une famille "X" / "X Variant" reste loin des deux
        # cotes, voir les seuils testes a la main).
        tok_score = score(p_tok, norm_tokens(cname))
        char_score = difflib.SequenceMatcher(None, p_str, norm_string(cname)).ratio()
        return max(tok_score, char_score)

    scored = sorted(
        ((combined(cname), cid, cname) for cid, cname in candidates),
        reverse=True, key=lambda x: x[0],
    )
    if not scored or scored[0][0] < 0.3:
        return None
    top = scored[0]
    ambiguous = len(scored) > 1 and scored[1][0] >= top[0] - 0.1 and scored[1][0] >= 0.3
    return {"id": top[1], "name": top[2], "score": top[0], "ambiguous": ambiguous}


def alias_match(title, mfm_name, candidates):
    key = mfm_name.strip().lower()
    target = FACTION_ALIASES.get((title, key)) or GLOBAL_ALIASES.get(key)
    if target is None:
        return None
    target_norm = norm_string(target)
    for cid, cname in candidates:
        if norm_string(cname) == target_norm:
            return {"id": cid, "name": cname, "score": 1.0, "ambiguous": False}
    return None


def parse_mfm(path):
    reader = PdfReader(path)
    factions = {}  # title -> [{"name": unit, "costs": [(size, pts)]}]
    current_title = None
    current_unit = None
    in_enhancements = False
    pending_title_continuation = False

    for page in reader.pages:
        text = page.extract_text() or ""
        for raw in text.splitlines():
            line = raw.strip().replace("’", "'").replace("‘", "'")
            # Glitch d'extraction pypdf : la paire de caracteres "Ta"/"Ya"
            # ressort avec un espace injecte au milieu ("T ank", "T aser",
            # "Y aegirs"...), probablement un probleme de kerning dans la
            # police du PDF. Sans danger a corriger ici : ce document est une
            # liste de noms d'unites/couts, pas de prose, donc le risque de
            # recoller par erreur deux vrais mots distincts est negligeable.
            line = re.sub(r"\b([A-Z]) a(?=[a-z])", r"\1a", line)
            if not line:
                continue

            if pending_title_continuation:
                current_title = line.strip().lower()
                factions.setdefault(current_title, [])
                current_unit = None
                in_enhancements = False
                pending_title_continuation = False
                continue

            m = HEADER_RE.match(line)
            if m:
                title = m.group(3).strip()
                if not title:
                    pending_title_continuation = True
                else:
                    current_title = title.lower()
                    factions.setdefault(current_title, [])
                    current_unit = None
                    in_enhancements = False
                continue

            if line.upper() == ENHANCEMENTS_HDR:
                in_enhancements = True
                current_unit = None
                continue
            if line.upper() == FORGE_WORLD_HDR:
                continue
            if in_enhancements or current_title is None:
                continue
            if re.match(r"^\d+$", line):
                continue  # numero de page

            cm = COST_RE.match(line)
            if cm and re.match(r"^\d", cm.group(1).strip()):
                label = cm.group(1).strip()
                pts = int(cm.group(2).replace(",", ""))
                size_m = re.match(r"^(\d+)", label)
                size = int(size_m.group(1)) if size_m else 0
                if current_unit is not None:
                    current_unit["costs"].append((size, pts))
                continue

            # nouvelle ligne de nom d'unite
            current_unit = {"name": line, "costs": []}
            factions[current_title].append(current_unit)

    # nettoie les entrees sans cout (sous-titres type "YNNARI")
    for title, units in factions.items():
        factions[title] = [u for u in units if u["costs"]]
    return factions


def _has_model_count_column(cur):
    cur.execute("pragma table_info(datasheet_costs)")
    return any(row[1] == "model_count" for row in cur.fetchall())


def main():
    apply = "--apply" in sys.argv
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None

    factions = parse_mfm(MFM_PATH)

    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    if apply and not _has_model_count_column(cur):
        con.close()
        print(
            "ERREUR : la colonne datasheet_costs.model_count n'existe pas encore "
            "dans cette base. Lance l'appli une fois (elle applique la migration "
            "de schema au demarrage) avant de relancer ce script avec --apply."
        )
        sys.exit(1)

    if apply:
        backup = DB_PATH + ".bak-mfm-points-" + datetime.now().strftime("%Y%m%d-%H%M%S")
        shutil.copy2(DB_PATH, backup)
        print("Backup:", backup)

    report = ["# Rapport de mise a jour des points (Munitorum Field Manual)", ""]
    totals = {"applied": 0, "ambiguous": 0, "unmatched": 0, "skipped_faction": 0}

    for title, units in sorted(factions.items()):
        if only and only not in title:
            continue
        if title in SKIP_TITLES:
            report.append(f"## {title.title()}\n\nIGNORE : faction absente de la base.\n")
            totals["skipped_faction"] += len(units)
            continue
        faction_name = FACTION_TITLE_MAP.get(title)
        if faction_name is None:
            report.append(f"## {title.title()} (non reconnu, ignore)\n")
            continue

        cur.execute("select id from factions where name=?", (faction_name,))
        row = cur.fetchone()
        if row is None:
            report.append(f"## {faction_name}\n\nIGNORE : faction introuvable en base.\n")
            continue
        faction_id = row[0]
        cur.execute("select id, name from datasheets where faction_id=?", (faction_id,))
        candidates = cur.fetchall()

        report.append(f"## {faction_name}")
        report.append(f"{len(units)} unites listees dans le MFM, {len(candidates)} fiches en base.\n")

        for u in units:
            # Deduplique par taille (une meme taille peut apparaitre deux
            # fois si la mise en page PDF repete une ligne), garde le
            # premier cout rencontre pour chaque taille.
            brackets = {}
            for size, pts in u["costs"]:
                brackets.setdefault(size, pts)
            sorted_brackets = sorted(brackets.items())
            base_size, base_pts = sorted_brackets[0]

            m = alias_match(title, u["name"], candidates) or best_match(u["name"], candidates)
            if m is None:
                report.append(f"- **{u['name']}** ({base_pts} pts / {base_size} mod.) : aucune correspondance, non applique.")
                totals["unmatched"] += 1
                continue
            if m["ambiguous"] or m["score"] < AUTO_APPLY_THRESHOLD:
                report.append(
                    f"- **{u['name']}** ({base_pts} pts) -> "
                    f"{'ambigu' if m['ambiguous'] else 'faible'} (*{m['name']}*, score {m['score']:.2f}) : "
                    "non applique, a verifier manuellement."
                )
                totals["ambiguous"] += 1
                continue

            datasheet_id = m["id"]
            if apply:
                # Retire l'ancienne ligne "cout unique" (sans palier) si
                # elle existe, pour ne pas laisser une valeur perimee a
                # cote des paliers qu'on va ecrire.
                cur.execute(
                    "delete from datasheet_costs where id = ?",
                    (f"cost-{datasheet_id}",),
                )
                for size, pts in sorted_brackets:
                    cur.execute(
                        "insert into datasheet_costs "
                        "(id, datasheet_id, edition_id, points, model_count) "
                        "values (?,?,?,?,?) "
                        "on conflict(id) do update set points=excluded.points, "
                        "model_count=excluded.model_count",
                        (f"cost-{datasheet_id}-{size}", datasheet_id, EDITION_ID, pts, size),
                    )
            totals["applied"] += 1
            multi = (
                " (" + ", ".join(f"{s} mod. = {p} pts" for s, p in sorted_brackets) + ")"
                if len(sorted_brackets) > 1
                else ""
            )
            report.append(
                f"- **{u['name']}** -> *{m['name']}* (score {m['score']:.2f}) : "
                f"{base_pts} pts{multi}."
            )
        report.append("")

    if apply:
        con.commit()
    con.close()

    report.insert(2, f"**Mode** : {'APPLICATION' if apply else 'DRY-RUN'}")
    report.insert(3, f"**Totaux** : {totals['applied']} fiches avec un cout applique, "
                      f"{totals['ambiguous']} ambigues/faibles a verifier, "
                      f"{totals['unmatched']} sans correspondance, "
                      f"{totals['skipped_faction']} ignorees (faction absente de la base).\n")

    with open(REPORT_PATH, "w", encoding="utf-8") as fh:
        fh.write("\n".join(report))
    print("Rapport:", REPORT_PATH)
    print(totals)


if __name__ == "__main__":
    main()
