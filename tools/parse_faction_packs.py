# -*- coding: utf-8 -*-
"""Parse les Faction Pack PDF anglais (11e ed., dossier "à jour") et
extrait les fiches d'unités completes (stats, armes, mots-cles) qu'on y
trouve, quelle que soit la section (Datasheets / Imperial Armour
Datasheets / Legends Datasheets) : on se base sur la presence d'un
header de statline "M T SV W LD OC" comme avec l'ancien parseur FR.

Sortie : un JSON par PDF dans parsed_json/, liste de fiches avec :
  name, models: [{name, M, T, SV, W, LD, OC}], invul,
  keywords: [...], faction_keywords: [...],
  ranged_weapons / melee_weapons: [{name, range, attacks, skill, s, ap, d, keywords}]
"""
import glob
import json
import os
import re
import sys

from pypdf import PdfReader

PDF_DIR = r"C:/Projet/wargameboard/local_assets/wh40k_reference/PDFS/à jour"
OUT_DIR = r"C:/Projet/wargameboard/local_assets/wh40k_reference/parsed_json"
os.makedirs(OUT_DIR, exist_ok=True)

STAT_HDR = re.compile(r"^M\s+T\s+SV\s+W\s+LD\s+OC\s*$", re.IGNORECASE)
# ex: `6" 4 3+ 4 6+ 1` optionnel nom de modele en tete de ligne
STAT_VAL = re.compile(
    r'^(?:([A-Za-zÀ-ÿ\'\-\s]{2,30}?)\s+)?'
    r'([\d]+"|N/A)\s+(\d+)\s+(\d\+)\s+(\d+)\s+(\d\+?)\s+(\d+)\s*$'
)
RANGED_HDR = re.compile(r"^RANGED WEAPONS\s+RANGE\s+A\s+BS\s+S\s+AP\s+D")
MELEE_HDR = re.compile(r"^MELEE WEAPONS\s+RANGE\s+A\s+WS\s+S\s+AP\s+D")
WEAPON_ROW = re.compile(
    r'^(.+?)\s+(Melee|[\d]+")\s+([\dD\+\-]+)\s+(\d\+|N/A)\s+([\dD\+\-]+)\s+(-?\d+)\s+([\dD\+\-]+)\s*$'
)
KEYWORDS_LINE = re.compile(r"^KEYWORDS\s*:\s*(.*)$", re.IGNORECASE)
FACTION_KEYWORDS_LINE = re.compile(r"^FACTION KEYWORDS\s*:\s*(.*)$", re.IGNORECASE)
ABILITIES_HDR = re.compile(r"^ABILITIES\s*$", re.IGNORECASE)
UNIT_COMPO_HDR = re.compile(r"^UNIT COMPOSITION\s*$", re.IGNORECASE)
WARGEAR_HDR = re.compile(r"^WARGEAR (OPTIONS|ABILITIES)\s*$", re.IGNORECASE)
INVUL = re.compile(r"^INVULNERABLE SAVE\s*(\d\+)", re.IGNORECASE)


def is_heading(line):
    l = line.strip()
    if not (3 <= len(l) <= 60):
        return False
    letters = [c for c in l if c.isalpha()]
    if len(letters) < 3:
        return False
    # tout en majuscules (tolère chiffres/ponctuation)
    return all(c.upper() == c for c in letters)


def clean_kw_list(raw):
    parts = re.split(r"[;,]", raw)
    return [p.strip().strip(".") for p in parts if p.strip()]


def parse_weapon_line(line):
    # isole les mots-clés entre crochets
    kw = []
    m_kw = re.findall(r"\[([^\]]+)\]", line)
    for grp in m_kw:
        kw.extend([k.strip() for k in grp.split(",")])
    stripped = re.sub(r"\[[^\]]+\]", "", line).strip()
    m = WEAPON_ROW.match(stripped)
    if not m:
        return None
    name, rng, a, skill, s, ap, d = m.groups()
    return {
        "name": name.strip(" –—-"),
        "range": rng,
        "attacks": a,
        "skill": skill,
        "strength": s,
        "ap": ap,
        "damage": d,
        "keywords": kw,
    }


def parse_pdf(path):
    reader = PdfReader(path)
    pages = [p.extract_text() or "" for p in reader.pages]
    units = []
    current = None
    last_heading = None

    def flush():
        if current and (current["models"] or current["ranged_weapons"] or current["melee_weapons"]):
            units.append(current)

    for text in pages:
        lines = [l.strip() for l in text.splitlines() if l.strip()]
        if not lines:
            continue

        # repère les headings (noms d'unite potentiels) sur la page
        page_headings = [l for l in lines if is_heading(l) and not RANGED_HDR.match(l)
                          and not MELEE_HDR.match(l) and l not in ("ABILITIES", "UNIT COMPOSITION")]
        has_stat = any(STAT_HDR.match(l) for l in lines)
        has_weapons = any(RANGED_HDR.match(l) or MELEE_HDR.match(l) for l in lines)
        if not has_stat and not has_weapons:
            if page_headings:
                last_heading = page_headings[0]
            continue

        name = page_headings[0] if page_headings else last_heading
        if not name:
            continue
        if page_headings:
            last_heading = page_headings[0]

        if current is None or current["name"] != name.title():
            flush()
            current = {
                "name": name.title(),
                "models": [],
                "invul": None,
                "keywords": [],
                "faction_keywords": [],
                "ranged_weapons": [],
                "melee_weapons": [],
            }

        for i, l in enumerate(lines):
            if STAT_HDR.match(l):
                j = i + 1
                while j < len(lines):
                    m = STAT_VAL.match(lines[j])
                    if not m:
                        break
                    label, mv, t, sv, w, ld, oc = m.groups()
                    current["models"].append({
                        "name": (label or "").strip() or current["name"],
                        "M": mv, "T": int(t), "SV": sv, "W": int(w),
                        "LD": ld, "OC": int(oc),
                    })
                    j += 1
            m_inv = INVUL.match(l)
            if m_inv:
                current["invul"] = m_inv.group(1)
            m_kw = KEYWORDS_LINE.match(l)
            if m_kw:
                current["keywords"].extend(clean_kw_list(m_kw.group(1)))
            m_fkw = FACTION_KEYWORDS_LINE.match(l)
            if m_fkw and m_fkw.group(1).strip():
                current["faction_keywords"].extend(clean_kw_list(m_fkw.group(1)))

        section = None
        for l in lines:
            if RANGED_HDR.match(l):
                section = "ranged"
                continue
            if MELEE_HDR.match(l):
                section = "melee"
                continue
            if ABILITIES_HDR.match(l) or UNIT_COMPO_HDR.match(l) or WARGEAR_HDR.match(l) \
                    or KEYWORDS_LINE.match(l) or FACTION_KEYWORDS_LINE.match(l):
                section = None
                continue
            if section:
                w = parse_weapon_line(l)
                if w:
                    key = "ranged_weapons" if section == "ranged" else "melee_weapons"
                    if not any(existing["name"] == w["name"] for existing in current[key]):
                        current[key].append(w)

    flush()
    # dedupe des noms de modeles vides -> nom d'unite
    for u in units:
        seen_kw = []
        for k in u["keywords"]:
            if k not in seen_kw:
                seen_kw.append(k)
        u["keywords"] = seen_kw
    return units


def main():
    only = sys.argv[1] if len(sys.argv) > 1 else None
    total = 0
    for f in sorted(glob.glob(os.path.join(PDF_DIR, "*.pdf"))):
        base = os.path.splitext(os.path.basename(f))[0]
        if only and only not in base:
            continue
        try:
            units = parse_pdf(f)
        except Exception as e:
            print(f"ERROR {base}: {e}")
            continue
        out_path = os.path.join(OUT_DIR, base + ".json")
        with open(out_path, "w", encoding="utf-8") as fh:
            json.dump(units, fh, ensure_ascii=False, indent=2)
        print(f"{base}: {len(units)} fiches -> {os.path.basename(out_path)}")
        total += len(units)
    print("TOTAL:", total)


if __name__ == "__main__":
    main()
