# -*- coding: utf-8 -*-
"""Applique les fiches parsees (parsed_json/*.json, issues des Faction
Pack PDF anglais 11e ed.) sur la vraie base sqlite de l'appli : met a
jour les profils de modele (M/T/Sv/W/Ld/OC) et les profils d'armes des
datasheets existantes qui matchent par nom (matching tolerant EN/FR par
recouvrement de tokens, la BDD ayant des noms francais).

N'ajoute PAS de nouvelle faction (Emperor's Children / Adeptus
Titanicus n'existent pas encore en base -> ignores, signales dans le
rapport). Ne touche PAS aux mots-cles/aptitudes/points (hors perimetre
"statistiques"). Les armes generiques partagees par plusieurs
datasheets ne sont jamais modifiees en place : on clone l'arme pour
cette datasheet avant de mettre a jour son profil, pour ne pas
impacter les autres fiches qui la referencent.

Usage: python apply_faction_pack_updates.py [--apply] [--only <faction_substr>]
Sans --apply : dry-run (aucune ecriture), juste le rapport.
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

DB_PATH = r"C:\Users\Edelios\Documents\wargame_board.sqlite"
JSON_DIR = r"C:\Projet\wargameboard\local_assets\wh40k_reference\parsed_json"
REPORT_PATH = r"C:\Projet\wargameboard\local_assets\wh40k_reference\faction_pack_update_report.md"

FACTION_MAP = {
    "black_templars": "Black Templars",
    "blood_angels": "Blood Angels",
    "dark_angels": "Dark Angels",
    "deathwatch": "Deathwatch",
    "grey_knights": "Grey Knights",
    "space-marines-": "Space Marines (Adeptus Astartes)",
    "space_wolves": "Space Wolves",
    "aeldari": "Aeldari",
    "drukhari": "Drukhari",
    "genestealer_cults": "Genestealer Cults",
    "leagues_of_votann": "Leagues of Votann",
    "necrons": "Necrons",
    "_orks": "Orks",
    "tau_empire": "T'au Empire",
    "tyranids": "Tyranids",
    "chaos_daemons": "Chaos Daemons",
    "chaos_knights": "Chaos Knights",
    "chaos_space_marines": "Chaos Space Marines",
    "death_guard": "Death Guard",
    "thousand_sons": "Thousand Sons",
    "world_eaters": "World Eaters",
    "adepta_sororitas": "Adepta Sororitas",
    "adeptus_custodes": "Adeptus Custodes",
    "adeptus_mechanicus": "Adeptus Mechanicus",
    "astra_militarum": "Astra Militarum",
    "imperial_agents": "Agents de l'Imperium",
    "imperial_knights": "Imperial Knights",
}
UNMAPPED_NOTE = {
    "emperor_s_children": "Emperor's Children — faction absente de la base (jamais importee), non appliquee.",
    "adeptus_titanicus": "Adeptus Titanicus — faction absente de la base (jeu annexe), non appliquee.",
}

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


def score(a_tokens, b_tokens):
    if not a_tokens or not b_tokens:
        return 0.0
    inter = len(a_tokens & b_tokens)
    union = len(a_tokens | b_tokens)
    return inter / union if union else 0.0


def best_match(parsed_name, candidates):
    """candidates: list of (id, name). Retourne (id, name, score, ambigu)."""
    p_tok = norm_tokens(parsed_name)
    scored = []
    for cid, cname in candidates:
        scored.append((score(p_tok, norm_tokens(cname)), cid, cname))
    scored.sort(reverse=True, key=lambda x: x[0])
    if not scored or scored[0][0] < 0.3:
        return None
    top = scored[0]
    ambiguous = len(scored) > 1 and scored[1][0] >= top[0] - 0.1 and scored[1][0] >= 0.3
    return {"id": top[1], "name": top[2], "score": top[0], "ambiguous": ambiguous}


# Seuil d'application automatique volontairement strict (proche de
# l'egalite de tokens) : un score Jaccard plus bas accepte trop souvent
# des variantes distinctes (ex. "Land Raider" vs "Land Raider Helios")
# comme si c'etait la meme fiche, ce qui ecraserait les stats d'une
# unite avec celles d'une autre. Tout ce qui est en dessous part en
# relecture manuelle plutot que d'etre applique a l'aveugle.
AUTO_APPLY_THRESHOLD = 0.85


def num_or_none(v):
    if v is None:
        return None
    m = re.match(r"-?\d+", str(v))
    return int(m.group(0)) if m else None


def parse_move(v):
    return num_or_none(v)


def parse_save(v):
    return num_or_none(v)


def main():
    apply = "--apply" in sys.argv
    only = None
    if "--only" in sys.argv:
        only = sys.argv[sys.argv.index("--only") + 1]

    if apply:
        backup = DB_PATH + ".bak-faction-pack-" + datetime.now().strftime("%Y%m%d-%H%M%S")
        shutil.copy2(DB_PATH, backup)
        print("Backup:", backup)

    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    report_lines = ["# Rapport de mise a jour depuis les Faction Packs (11e ed.)", ""]
    report_lines.append(f"Mode : {'APPLICATION' if apply else 'DRY-RUN (aucune ecriture)'}")
    report_lines.append("")

    totals = {"applied": 0, "profile_mismatch": 0, "unmatched": 0, "ambiguous": 0,
              "weapons_updated_inplace": 0, "weapons_cloned": 0, "weapons_unmatched": 0}

    for jf in sorted(glob.glob(os.path.join(JSON_DIR, "*.json"))):
        base = os.path.splitext(os.path.basename(jf))[0]
        if only and only not in base:
            continue

        faction_name = None
        for key, fname in FACTION_MAP.items():
            if key in base:
                faction_name = fname
                break
        if faction_name is None:
            for key, note in UNMAPPED_NOTE.items():
                if key in base:
                    report_lines.append(f"## {base}\n\nIGNORE : {note}\n")
            continue

        with open(jf, encoding="utf-8") as fh:
            units = json.load(fh)
        if not units:
            continue

        cur.execute("select id from factions where name=?", (faction_name,))
        row = cur.fetchone()
        if row is None:
            report_lines.append(f"## {faction_name}\n\nIGNORE : faction introuvable en base.\n")
            continue
        faction_id = row[0]

        cur.execute("select id, name from datasheets where faction_id=?", (faction_id,))
        candidates = cur.fetchall()

        report_lines.append(f"## {faction_name} ({base})")
        report_lines.append(f"{len(units)} fiches parsees, {len(candidates)} fiches existantes en base.\n")

        for u in units:
            if not u["models"]:
                report_lines.append(f"- **{u['name']}** : parse incomplet (pas de profil detecte), ignore.")
                totals["unmatched"] += 1
                continue

            m = best_match(u["name"], candidates)
            if m is None:
                report_lines.append(f"- **{u['name']}** : aucune correspondance (nouvelle unite ?), non appliquee.")
                totals["unmatched"] += 1
                continue
            if m["ambiguous"]:
                report_lines.append(
                    f"- **{u['name']}** -> ambigu (meilleur: *{m['name']}*, score {m['score']:.2f}) : "
                    "non applique, a verifier manuellement."
                )
                totals["ambiguous"] += 1
                continue
            if m["score"] < AUTO_APPLY_THRESHOLD:
                report_lines.append(
                    f"- **{u['name']}** -> correspondance faible (*{m['name']}*, score {m['score']:.2f}) : "
                    "non applique, a verifier manuellement."
                )
                totals["ambiguous"] += 1
                continue

            datasheet_id = m["id"]
            cur.execute(
                "select dm.id, dm.name from datasheet_models dm where dm.datasheet_id=? order by dm.display_order",
                (datasheet_id,),
            )
            db_models = cur.fetchall()
            if len(db_models) != len(u["models"]):
                report_lines.append(
                    f"- **{u['name']}** -> *{m['name']}* (score {m['score']:.2f}) : "
                    f"{len(db_models)} profil(s) en base vs {len(u['models'])} parse(s), non applique."
                )
                totals["profile_mismatch"] += 1
                continue

            weapon_summary = []
            for (dm_id, dm_name), pm in zip(db_models, u["models"]):
                movement = parse_move(pm["M"])
                save = parse_save(pm["SV"])
                leadership = parse_save(pm["LD"])
                if apply:
                    cur.execute(
                        "update model_profiles set movement=?, toughness=?, save=?, wounds=?, "
                        "leadership=?, objective_control=?, updated_at=CAST(strftime('%s','now') AS INTEGER) "
                        "where datasheet_model_id=?",
                        (movement, pm["T"], save, pm["W"], leadership, pm["OC"], dm_id),
                    )

                parsed_weapons = {w["name"].strip().lower(): w for w in (u["ranged_weapons"] + u["melee_weapons"])}
                cur.execute(
                    "select dw.id, dw.weapon_id, w.name, w.is_melee "
                    "from datasheet_weapons dw join weapons w on w.id = dw.weapon_id "
                    "where dw.datasheet_model_id=?",
                    (dm_id,),
                )
                for dw_id, weapon_id, wname, is_melee in cur.fetchall():
                    pw = parsed_weapons.get(wname.strip().lower())
                    if pw is None:
                        wtok = norm_tokens(wname)
                        best = None
                        best_s = 0.0
                        for pname, cand in parsed_weapons.items():
                            s = score(wtok, norm_tokens(pname))
                            if s > best_s:
                                best_s, best = s, cand
                        if best_s >= 0.6:
                            pw = best
                    if pw is None:
                        totals["weapons_unmatched"] += 1
                        continue

                    rng = 0 if pw["range"] == "Melee" else num_or_none(pw["range"]) or 0
                    ap = num_or_none(pw["ap"]) or 0
                    skill = num_or_none(pw["skill"])
                    strength = num_or_none(pw["strength"]) or 0

                    cur.execute("select count(*) from datasheet_weapons where weapon_id=?", (weapon_id,))
                    (usage_count,) = cur.fetchone()

                    if usage_count > 1:
                        new_weapon_id = f"{weapon_id}-{datasheet_id}"
                        totals["weapons_cloned"] += 1
                        target_weapon_id = new_weapon_id
                        if apply:
                            cur.execute(
                                "insert or ignore into weapons (id, name, is_melee, is_ranged) values (?,?,?,?)",
                                (new_weapon_id, wname, 1 if is_melee else 0, 0 if is_melee else 1),
                            )
                            cur.execute(
                                "update datasheet_weapons set weapon_id=? where id=?",
                                (new_weapon_id, dw_id),
                            )
                    else:
                        totals["weapons_updated_inplace"] += 1
                        target_weapon_id = weapon_id

                    if apply:
                        cur.execute(
                            "delete from weapon_profiles where weapon_id=?", (target_weapon_id,)
                        )
                        cur.execute(
                            "insert into weapon_profiles (id, weapon_id, name, range, attacks, "
                            "ballistic_skill, weapon_skill, strength, armor_penetration, damage) "
                            "values (?,?,?,?,?,?,?,?,?,?)",
                            (
                                f"wpp-{target_weapon_id}-0", target_weapon_id, wname, rng,
                                pw["attacks"],
                                skill if not is_melee else None,
                                skill if is_melee else None,
                                strength, ap, pw["damage"],
                            ),
                        )
                    weapon_summary.append(wname)

            totals["applied"] += 1
            report_lines.append(
                f"- **{u['name']}** -> *{m['name']}* (score {m['score']:.2f}) : "
                f"profil(s) mis a jour, armes: {', '.join(weapon_summary) if weapon_summary else 'aucune matchee'}."
            )
        report_lines.append("")

    if apply:
        con.commit()
    con.close()

    report_lines.insert(2, f"**Totaux** : {totals['applied']} fiches mises a jour, "
                            f"{totals['ambiguous']} ambigues/faibles a verifier, "
                            f"{totals['profile_mismatch']} avec un nombre de profils different, "
                            f"{totals['unmatched']} sans correspondance (nouvelles unites potentielles). "
                            f"Armes : {totals['weapons_updated_inplace']} maj en place, "
                            f"{totals['weapons_cloned']} clonees (partagees ailleurs), "
                            f"{totals['weapons_unmatched']} non matchees.\n")

    with open(REPORT_PATH, "w", encoding="utf-8") as fh:
        fh.write("\n".join(report_lines))
    print("Rapport:", REPORT_PATH)
    print(totals)


if __name__ == "__main__":
    main()
