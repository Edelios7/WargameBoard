# -*- coding: utf-8 -*-
"""Applique les points du site officiel mfm.warhammer-community.com
(scrape live, voir all_factions.json produit via le navigateur) sur
datasheet_costs, en reutilisant le meme matcher EN/FR et les memes
tables d'alias que apply_mfm_points.py (le PDF MFM local devient
obsolete des qu'une mise a jour de points sort sur le site officiel).

Contrairement a apply_mfm_points.py (qui ajoute/complete des paliers),
celui-ci EFFACE puis REECRIT tous les paliers de chaque datasheet
matchee, pour que la base refletela liste de paliers actuelle du site
(un ancien palier retire cote officiel doit disparaitre aussi cote
base).

Usage: python apply_mfm_live.py [--apply] [--only <faction_substr>]
"""
import json
import re
import shutil
import sqlite3
import sys
from datetime import datetime

sys.path.insert(0, r"C:\Projet\wargameboard\tools")
from apply_mfm_points import (  # noqa: E402
    FACTION_TITLE_MAP,
    GLOBAL_ALIASES,
    FACTION_ALIASES,
    alias_match,
    best_match,
)

DATA_PATH = (
    r"C:\Users\Edelios\AppData\Local\Temp\claude\C--Projet-wargameboard"
    r"\9ee87ebc-ac89-4941-8f6b-6ce7493718e9\scratchpad\mfm_live\all_factions.json"
)
DB_PATH = r"C:\Users\Edelios\Documents\wargame_board.sqlite"
REPORT_PATH = r"C:\Projet\wargameboard\local_assets\wh40k_reference\mfm_live_report.md"
EDITION_ID = "ed-w40k-10e"
AUTO_APPLY_THRESHOLD = 0.85

# Slug du site -> titre utilise par FACTION_TITLE_MAP (mfm.warhammer-community.com
# utilise des slugs, apply_mfm_points.py des titres PDF en minuscules).
SLUG_TITLE = {
    "adepta-sororitas": "adepta sororitas",
    "adeptus-custodes": "adeptus custodes",
    "adeptus-mechanicus": "adeptus mechanicus",
    "aeldari": "aeldari",
    "astra-militarum": "astra militarum",
    "black-templars": "black templars",
    "blood-angels": "blood angels",
    "chaos-daemons": "chaos daemons",
    "chaos-knights": "chaos knights",
    "chaos-space-marines": "chaos space marines",
    "chaos-titan-legions": None,  # pas de faction correspondante en base
    "dark-angels": "dark angels",
    "death-guard": "death guard",
    "deathwatch": "deathwatch",
    "drukhari": "drukhari",
    "emperors-children": None,  # SKIP_TITLES cote apply_mfm_points.py
    "genestealer-cults": "genestealer cults",
    "grey-knights": "grey knights",
    "imperial-agents": "imperial agents",
    "imperial-knights": "imperial knights",
    "leagues-of-votann": "leagues of votann",
    "necrons": "necrons",
    "orks": "orks",
    "space-marines": "space marines",
    "space-wolves": "space wolves",
    "tau-empire": "tau empire",
    "thousand-sons": "thousand sons",
    "titan-legions": None,
    "tyranids": "tyranids",
    "world-eaters": "world eaters",
}

# Paliers "Nieme copie et plus" : le libelle indique a partir de quelle
# copie ce cout s'applique. None = palier de base (aucun min_copy_index).
COPY_LABEL_RE = re.compile(
    r"YOUR\s+(\d+)(?:ST|ND|RD|TH)?\s*\+\s*UNIT", re.IGNORECASE
)


def parse_models(label):
    # La plupart des libelles sont juste "N models"/"N model" (un seul
    # nombre). Certaines unites (Crusader Squad, Gretchin, Wolf Guard
    # Headtakers...) decrivent en revanche leur composition en toutes
    # lettres ("1 Sword Brother, 4 Neophytes, 5 Initiates" = 10 figurines
    # au total) : un simple ^(\d+) ne recupererait que le premier nombre
    # (1) au lieu du total reel (10), ce qui a cause des faux conflits de
    # palier lors du premier passage. On additionne donc tous les groupes
    # de chiffres du libelle, ce qui redonne le bon total dans les deux
    # cas (un seul nombre => inchange, plusieurs => somme).
    nums = re.findall(r"\d+", label)
    return sum(int(n) for n in nums) if nums else None


def parse_pts(label):
    s = label.replace(",", "").replace("pts", "").strip()
    m = re.match(r"^(\d+)$", s)
    return int(m.group(1)) if m else None


def min_copy_index_for_label(label):
    m = COPY_LABEL_RE.search(label)
    return int(m.group(1)) if m else None


def _has_model_count_column(cur):
    cur.execute("pragma table_info(datasheet_costs)")
    return any(row[1] == "model_count" for row in cur.fetchall())


def main():
    apply = "--apply" in sys.argv
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None

    with open(DATA_PATH, encoding="utf-8") as f:
        all_factions = json.load(f)

    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    if apply and not _has_model_count_column(cur):
        con.close()
        print("ERREUR : colonne datasheet_costs.model_count absente.")
        sys.exit(1)

    if apply:
        backup = DB_PATH + ".bak-mfm-live-" + datetime.now().strftime("%Y%m%d-%H%M%S")
        shutil.copy2(DB_PATH, backup)
        print("Backup:", backup)

    report = ["# Rapport de mise a jour des points (site officiel MFM live)", ""]
    totals = {"applied": 0, "ambiguous": 0, "unmatched": 0, "skipped_faction": 0}
    unmatched_by_faction = {}

    for slug in sorted(all_factions.keys()):
        title = SLUG_TITLE.get(slug)
        if only and only not in slug:
            continue
        if title is None:
            report.append(f"## {slug} (faction absente de la base, ignoree)\n")
            totals["skipped_faction"] += len(all_factions[slug])
            continue
        faction_name = FACTION_TITLE_MAP.get(title)
        if faction_name is None:
            report.append(f"## {slug} (non reconnu, ignore)\n")
            continue

        cur.execute("select id from factions where name=?", (faction_name,))
        row = cur.fetchone()
        if row is None:
            report.append(f"## {faction_name}\n\nIGNORE : faction introuvable en base.\n")
            continue
        faction_id = row[0]
        cur.execute("select id, name from datasheets where faction_id=?", (faction_id,))
        candidates = cur.fetchall()

        units = [u for u in all_factions[slug] if u.get("name")]
        report.append(f"## {faction_name}")
        report.append(f"{len(units)} unites listees, {len(candidates)} fiches en base.\n")

        # Accumule les paliers par datasheet_id AVANT d'ecrire quoi que ce
        # soit : plusieurs unites du site (ex. Canoness / Canoness with
        # Jump Pack) peuvent aliaser vers la MEME fiche francaise
        # (Chanoinesse) ; ecrire (delete+insert) unite par unite ecraserait
        # la premiere des que la seconde est traitee, au lieu d'accumuler
        # leurs paliers respectifs sur la fiche partagee.
        per_datasheet = {}  # datasheet_id -> {"name": ..., "matches": [(unit_name, score, brackets)]}

        for u in units:
            name = u["name"]
            # Construit la liste de paliers (model_count, points, min_copy_index)
            # a partir des blocs "tiers" du site, en ignorant WARGEAR OPTIONS
            # (couts d'amelioration d'equipement, pas des couts d'unite).
            brackets = []  # (model_count, points, min_copy_index)
            for tier in u.get("tiers", []):
                label = (tier.get("label") or "").upper()
                if "WARGEAR" in label:
                    continue
                mci = min_copy_index_for_label(label)
                for item in tier.get("items", []):
                    raw_models = item.get("models", "").strip()
                    # Certaines unites glissent un cout d'option a
                    # l'interieur meme du bloc "YOUR UNIT COSTS" (pas sous
                    # "WARGEAR OPTIONS") : "+ 1 Invader ATV" (Outrider
                    # Squad), "+ 1 Tidewall Defence Platform" (Tidewall
                    # Shieldline)... Ce n'est pas un palier de taille
                    # d'unite, on l'ignore comme les WARGEAR OPTIONS.
                    if raw_models.startswith("+") or raw_models.lower().startswith("per "):
                        continue
                    models = parse_models(raw_models)
                    pts = parse_pts(item.get("pts", ""))
                    if models is None or pts is None:
                        continue
                    brackets.append((models, pts, mci))

            if not brackets:
                continue

            m = alias_match(title, name, candidates) or best_match(name, candidates)
            if m is None:
                report.append(f"- **{name}** : aucune correspondance en base (fiche absente), non applique.")
                totals["unmatched"] += 1
                unmatched_by_faction.setdefault(faction_name, []).append(name)
                continue
            if m["ambiguous"] or m["score"] < AUTO_APPLY_THRESHOLD:
                report.append(
                    f"- **{name}** -> "
                    f"{'ambigu' if m['ambiguous'] else 'faible'} (*{m['name']}*, score {m['score']:.2f}) : "
                    "non applique, a verifier manuellement."
                )
                totals["ambiguous"] += 1
                continue

            datasheet_id = m["id"]
            entry = per_datasheet.setdefault(datasheet_id, {"name": m["name"], "sources": []})
            entry["sources"].append((name, m["score"], brackets))

        for datasheet_id, entry in per_datasheet.items():
            # Fusionne les paliers de toutes les unites-source qui partagent
            # cette fiche (ex. Canoness / Canoness with Jump Pack -> la
            # meme fiche Chanoinesse, faute d'option d'equipement modelisee
            # separement en base). En cas de cle (models, mci) identique
            # avec un cout different entre deux sources, la fiche ne peut
            # representer qu'une seule valeur : on garde la PREMIERE
            # rencontree (le tri alphabetique place quasi-toujours la
            # variante "de base" avant sa variante equipee, ex. "CANONESS"
            # avant "CANONESS WITH JUMP PACK") et on signale le conflit au
            # lieu de l'ecraser silencieusement.
            merged = {}  # (models, mci) -> (pts, src_name)
            conflicts = []
            for src_name, src_score, brackets in entry["sources"]:
                for models, pts, mci in brackets:
                    key = (models, mci)
                    if key in merged and merged[key][0] != pts:
                        conflicts.append((key, merged[key][1], merged[key][0], src_name, pts))
                        continue
                    merged.setdefault(key, (pts, src_name))

            if apply:
                cur.execute(
                    "delete from datasheet_costs where datasheet_id = ? and edition_id = ?",
                    (datasheet_id, EDITION_ID),
                )
                for (models, mci), (pts, _src) in merged.items():
                    if mci is None:
                        cid = f"cost-{datasheet_id}-{models}"
                    else:
                        cid = f"cost-mfm-copy-{datasheet_id}-{models}-{mci}"
                    cur.execute(
                        "insert into datasheet_costs "
                        "(id, datasheet_id, edition_id, points, model_count, min_copy_index) "
                        "values (?,?,?,?,?,?) "
                        "on conflict(id) do update set points=excluded.points, "
                        "model_count=excluded.model_count, min_copy_index=excluded.min_copy_index",
                        (cid, datasheet_id, EDITION_ID, pts, models, mci),
                    )

            for src_name, src_score, brackets in entry["sources"]:
                totals["applied"] += 1
                detail = ", ".join(
                    f"{models} mod.{' (a partir copie ' + str(mci) + ')' if mci else ''} = {pts} pts"
                    for models, pts, mci in brackets
                )
                report.append(f"- **{src_name}** -> *{entry['name']}* (score {src_score:.2f}) : {detail}.")
            for (models, mci), kept_name, kept_pts, other_name, other_pts in conflicts:
                report.append(
                    f"  ATTENTION conflit sur *{entry['name']}* a {models} mod."
                    f"{' (copie ' + str(mci) + '+)' if mci else ''} : "
                    f"{kept_name} = {kept_pts} pts (retenu) vs {other_name} = {other_pts} pts "
                    "(ecarte) - la fiche ne distingue pas ces deux unites en base."
                )
        report.append("")

    if apply:
        con.commit()
    con.close()

    report.insert(2, f"**Mode** : {'APPLICATION' if apply else 'DRY-RUN'}")
    report.insert(
        3,
        f"**Totaux** : {totals['applied']} fiches avec un cout applique, "
        f"{totals['ambiguous']} ambigues/faibles a verifier, "
        f"{totals['unmatched']} sans correspondance (fiche absente de la base), "
        f"{totals['skipped_faction']} ignorees (faction absente de la base).\n",
    )

    report.append("\n# Fiches absentes de la base (a importer si besoin)\n")
    for faction_name, names in sorted(unmatched_by_faction.items()):
        report.append(f"## {faction_name}")
        for n in names:
            report.append(f"- {n}")
        report.append("")

    with open(REPORT_PATH, "w", encoding="utf-8") as fh:
        fh.write("\n".join(report))
    print("Rapport:", REPORT_PATH)
    print(totals)


if __name__ == "__main__":
    main()
