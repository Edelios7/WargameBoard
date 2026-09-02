# -*- coding: utf-8 -*-
"""Applique le sous-ensemble SUR des changements d'errata parses par
parse_faction_pack_updates.py : reecritures completes d'aptitudes et
substitutions simples ("Remplacez X par Y") sur des aptitudes propres a
une ou plusieurs fiches nommees explicitement, plus ajout de mots-cles.

Volontairement HORS PERIMETRE de cette passe automatisee (rapportes
mais jamais appliques, car trop risque de mal les representer) :
- reecritures de profils d'armes (tableaux de stats) ;
- textes de composition d'unite / capacite de transport ;
- regles de detachement, stratagemes, regles d'armee (avant "FICHES
  TECHNIQUES") ;
- tout changement dont le nom de cible ne matche aucune fiche avec
  confiance, ou dont l'aptitude visee est partagee avec une fiche NON
  nommee dans l'errata (ecraser sa description casserait cette autre
  fiche).

Usage: python apply_faction_pack_errata.py [--apply] [--only <slug_substr>]
"""
import json
import os
import re
import shutil
import sqlite3
import sys
from datetime import datetime

sys.path.insert(0, r"C:\Projet\wargameboard\tools")
from apply_mfm_points import best_match, norm_string  # noqa: E402

IN_DIR = (
    r"C:\Users\Edelios\AppData\Local\Temp\claude\C--Projet-wargameboard"
    r"\9ee87ebc-ac89-4941-8f6b-6ce7493718e9\scratchpad\errata_raw"
)
PARSED_PATH = os.path.join(IN_DIR, "errata_parsed.json")
DB_PATH = r"C:\Users\Edelios\Documents\wargame_board.sqlite"
REPORT_PATH = r"C:\Projet\wargameboard\local_assets\wh40k_reference\faction_pack_errata_report.md"

SLUG_FACTION = {
    "adepta_sororitas": "Adepta Sororitas",
    "adeptus_custodes": "Adeptus Custodes",
    "adeptus_mechanicus": "Adeptus Mechanicus",
    "aeldari": "Aeldari",
    "astra_militarum": "Astra Militarum",
    "black_templars": "Black Templars",
    "blood_angels": "Blood Angels",
    "chaos_daemons": "Chaos Daemons",
    "chaos_knights": "Chaos Knights",
    "chaos_space_marines": "Chaos Space Marines",
    "dark_angels": "Dark Angels",
    "death_guard": "Death Guard",
    "drukhari": "Drukhari",
    "emperor_s_children": None,  # pas de faction correspondante en base
    "genestealer_cults": "Genestealer Cults",
    "grey_knights": "Grey Knights",
    "imperia_agents": "Agents de l'Imperium",
    "imperia_knights": "Imperial Knights",
    "leagues_of_votann": "Leagues of Votann",
    "necrons": "Necrons",
    "orks": "Orks",
    "space_marines": "Space Marines (Adeptus Astartes)",
    "space_wolves": "Space Wolves",
    "tau_empire": "T'au Empire",
    "thousand_sons": "Thousand Sons",
    "tyranids": "Tyranids",
    "world_eaters": "World Eaters",
}

MIN_NAME_LEN = 3
SIMPLE_SUBST_RE = re.compile(
    r'^Remplacez\s+(.+?)\s+par\s+["“]?([^".”]+)["”.]?\.?$', re.IGNORECASE
)
KEYWORD_ADD_RE = re.compile(r'^Ajoutez\s+(?:le mot-clé\s+)?["“]([^"”]+)["”]\.?$', re.IGNORECASE)


def slug_to_faction(slug):
    base = slug.split("-")[0]
    return SLUG_FACTION.get(base)


def clean_ability_key(section):
    s = re.sub(r"(?i)^(aptitude|section)\s+", "", section).strip(" :\u0007")
    return s


def find_datasheets(cur, faction_id, names):
    cur.execute("select id, name from datasheets where faction_id=?", (faction_id,))
    candidates = cur.fetchall()
    matched = []
    unmatched = []
    for name in names:
        if len(name) < MIN_NAME_LEN or name.isdigit() or name in ("?",):
            unmatched.append(name)
            continue
        m = best_match(name, candidates)
        if m and m["score"] >= 0.7 and not m["ambiguous"]:
            matched.append((name, m["id"], m["name"], m["score"]))
        else:
            unmatched.append(name)
    return matched, unmatched


def find_ability_for_datasheets(cur, datasheet_ids, section_key):
    """Cherche une aptitude liee a AU MOINS UNE des fiches donnees dont
    le nom matche section_key, et renvoie aussi l'ensemble COMPLET des
    fiches liees a cette aptitude (pour verifier l'exclusivite)."""
    placeholders = ",".join("?" * len(datasheet_ids))
    cur.execute(
        f"""
        select distinct a.id, a.name
        from datasheet_ability_links dal
        join abilities a on dal.ability_id = a.id
        where dal.datasheet_id in ({placeholders})
        """,
        datasheet_ids,
    )
    abilities = cur.fetchall()
    key_norm = norm_string(section_key)
    best = None
    best_score = 0.0
    for aid, aname in abilities:
        score = 1.0 if norm_string(aname) == key_norm else 0.0
        if score == 0.0 and key_norm and key_norm in norm_string(aname):
            score = 0.8
        if score > best_score:
            best_score, best = score, (aid, aname)
    if best is None or best_score < 0.8:
        return None
    aid, aname = best
    cur.execute("select distinct datasheet_id from datasheet_ability_links where ability_id=?", (aid,))
    all_linked = {r[0] for r in cur.fetchall()}
    return {"id": aid, "name": aname, "linked_datasheets": all_linked}


def main():
    apply = "--apply" in sys.argv
    only = sys.argv[sys.argv.index("--only") + 1] if "--only" in sys.argv else None

    with open(PARSED_PATH, encoding="utf-8") as f:
        parsed = json.load(f)

    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()

    if apply:
        backup = DB_PATH + ".bak-faction-errata-" + datetime.now().strftime("%Y%m%d-%H%M%S")
        shutil.copy2(DB_PATH, backup)
        print("Backup:", backup)

    report = ["# Rapport d'application des errata de faction pack (texte de regles)", ""]
    totals = {"applied_full": 0, "applied_substr": 0, "applied_keyword": 0, "skipped": 0}

    for slug, data in sorted(parsed.items()):
        if slug == "sample_sororitas":
            continue
        if only and only not in slug:
            continue
        faction_name = slug_to_faction(slug)
        if faction_name is None:
            report.append(f"## {slug} (faction non presente en base, ignore)\n")
            continue
        cur.execute("select id from factions where name=?", (faction_name,))
        row = cur.fetchone()
        if row is None:
            report.append(f"## {faction_name}\n\nIGNORE : faction introuvable en base.\n")
            continue
        faction_id = row[0]

        report.append(f"## {faction_name}")
        changes = data["datasheet_changes"]
        report.append(f"{len(changes)} changements de fiches trouves dans l'errata.\n")

        for ch in changes:
            names = ch["unit_names"]
            section = ch["section"]
            action = ch["action"]
            new_text = ch["new_text"]

            if not names or section == "?":
                report.append(f"- IGNORE (cible/section peu fiable) : {names} / {section} / {action[:60]}")
                totals["skipped"] += 1
                continue

            matched, unmatched = find_datasheets(cur, faction_id, names)
            if not matched:
                report.append(f"- IGNORE (aucune fiche matchee) : {names} / {section}")
                totals["skipped"] += 1
                continue
            datasheet_ids = [m[1] for m in matched]
            matched_names = ", ".join(f"{m[0]}->{m[2]}" for m in matched)

            keyword_m = KEYWORD_ADD_RE.match(action)
            if keyword_m:
                kw = keyword_m.group(1).strip()
                cur.execute("select id from keywords where lower(name)=lower(?)", (kw,))
                kwrow = cur.fetchone()
                if kwrow is None:
                    # Mot-cle genuinement nouveau introduit par cette mise
                    # a jour (ex. CHASSIS) : creation sans risque, un
                    # mot-cle est une simple etiquette, pas un texte de
                    # regle a interpreter.
                    kw_id = "kw-" + re.sub(r"[^a-z0-9]+", "-", kw.lower()).strip("-")
                    if apply:
                        cur.execute(
                            "insert into keywords (id, name, is_core) values (?,?,0) "
                            "on conflict(id) do nothing",
                            (kw_id, kw),
                        )
                    report.append(f"  (mot-cle '{kw}' nouveau, cree en base)")
                else:
                    kw_id = kwrow[0]
                added_for = []
                for did in datasheet_ids:
                    cur.execute(
                        "select 1 from datasheet_keyword_links where datasheet_id=? and keyword_id=?",
                        (did, kw_id),
                    )
                    if cur.fetchone():
                        continue
                    added_for.append(did)
                    if apply:
                        cur.execute(
                            "insert into datasheet_keyword_links (id, datasheet_id, keyword_id) values (?,?,?)",
                            (f"dkl-errata-{did}-{kw_id}", did, kw_id),
                        )
                report.append(f"- MOT-CLE '{kw}' ajoute a : {matched_names} ({len(added_for)} fiche(s))")
                totals["applied_keyword"] += 1
                continue

            ability = find_ability_for_datasheets(cur, datasheet_ids, clean_ability_key(section))
            if ability is None:
                report.append(f"- IGNORE (aptitude '{section}' non trouvee) : {matched_names}")
                totals["skipped"] += 1
                continue

            extra_linked = ability["linked_datasheets"] - set(datasheet_ids)
            if extra_linked:
                report.append(
                    f"- IGNORE (aptitude '{ability['name']}' partagee avec {len(extra_linked)} "
                    f"autre(s) fiche(s) non citee(s) par l'errata - trop risque) : {matched_names}"
                )
                totals["skipped"] += 1
                continue

            if new_text:
                if apply:
                    cur.execute("update abilities set description=? where id=?", (new_text, ability["id"]))
                report.append(
                    f"- APPLIQUE (reecriture complete) '{ability['name']}' sur {matched_names} : "
                    f"{new_text[:100]}{'...' if len(new_text) > 100 else ''}"
                )
                totals["applied_full"] += 1
                continue

            subst = SIMPLE_SUBST_RE.match(action)
            if subst:
                old_val, new_val = subst.group(1).strip(' "“”'), subst.group(2).strip(' "“”')
                cur.execute("select description from abilities where id=?", (ability["id"],))
                current = cur.fetchone()[0] or ""
                if current.count(old_val) == 1:
                    updated = current.replace(old_val, new_val)
                    if apply:
                        cur.execute("update abilities set description=? where id=?", (updated, ability["id"]))
                    report.append(
                        f"- APPLIQUE (substitution) '{old_val}' -> '{new_val}' sur '{ability['name']}' "
                        f"({matched_names})"
                    )
                    totals["applied_substr"] += 1
                else:
                    report.append(
                        f"- IGNORE (substitution '{old_val}'->'{new_val}' : trouve {current.count(old_val)} "
                        f"fois, pas exactement 1) sur '{ability['name']}' ({matched_names})"
                    )
                    totals["skipped"] += 1
                continue

            report.append(f"- IGNORE (action non automatisee) : {action[:80]} sur '{ability['name']}' ({matched_names})")
            totals["skipped"] += 1

        report.append("")

    if apply:
        con.commit()
    con.close()

    report.insert(2, f"**Mode** : {'APPLICATION' if apply else 'DRY-RUN'}")
    report.insert(
        3,
        f"**Totaux** : {totals['applied_full']} reecritures completes, "
        f"{totals['applied_substr']} substitutions simples, "
        f"{totals['applied_keyword']} ajouts de mot-cle, "
        f"{totals['skipped']} ignores (a verifier manuellement dans le rapport ci-dessous).\n",
    )

    with open(REPORT_PATH, "w", encoding="utf-8") as fh:
        fh.write("\n".join(report))
    print("Rapport:", REPORT_PATH)
    print(totals)


if __name__ == "__main__":
    main()
