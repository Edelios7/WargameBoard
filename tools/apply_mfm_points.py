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


def norm_tokens(name):
    s = unicodedata.normalize("NFKD", name).encode("ascii", "ignore").decode()
    s = re.sub(r"[^a-zA-Z0-9\s]", " ", s).lower()
    tokens = set()
    for t in s.split():
        t = SYNONYMS.get(t, t)
        if t in STOPWORDS or len(t) < 2:
            continue
        tokens.add(t)
    return tokens


def score(a, b):
    if not a or not b:
        return 0.0
    inter = len(a & b)
    union = len(a | b)
    return inter / union if union else 0.0


def best_match(name, candidates):
    p_tok = norm_tokens(name)
    scored = sorted(
        ((score(p_tok, norm_tokens(cname)), cid, cname) for cid, cname in candidates),
        reverse=True, key=lambda x: x[0],
    )
    if not scored or scored[0][0] < 0.3:
        return None
    top = scored[0]
    ambiguous = len(scored) > 1 and scored[1][0] >= top[0] - 0.1 and scored[1][0] >= 0.3
    return {"id": top[1], "name": top[2], "score": top[0], "ambiguous": ambiguous}


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

            m = best_match(u["name"], candidates)
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
