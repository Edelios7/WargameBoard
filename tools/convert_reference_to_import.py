# -*- coding: utf-8 -*-
"""DÉPRÉCIÉ — ne pas utiliser. Remplacé par convert_reference_v2_to_import.py.

Le parseur source (parse_datasheets.py, v1) n'a aucun garde-fou pour
détecter la fin d'un tableau d'armes : une fois dans la section "armes", il
traite toute ligne de texte suivante comme un nom d'arme jusqu'à tomber sur
un en-tête connu. Quand du texte de règle apparaît avant l'en-tête
"APTITUDES" (mise en page à colonnes, extraction pypdf non linéaire), ce
texte est importé comme si c'était une arme (ex: une phrase entière de
règle spéciale devient un "nom d'arme" sans profil).

parse_datasheets_v2.py corrige ça (garde-fou RANGE_TOKEN : la ligne qui
suit un nom candidat doit ressembler à une vraie valeur de portée/Mêlée
avant d'être acceptée) et capture en plus les profils d'armes complets
(v1 ne gardait que les noms). Toute donnée déjà importée depuis ce
pipeline v1 doit être remplacée par un import v2 (voir
tools/bulk_import_v2_test.dart) — ne pas relancer ce script.

Usage :
  python tools/convert_reference_to_import.py <ref.json> [<sortie.json>]

Sans argument de sortie, écrit à côté du fichier source dans
local_assets/wh40k_reference/import_json/ (dossier local-only, jamais commité).

Les coûts en points ne figurent pas dans les PDF de règles d'armée
(Munitorum Field Manual séparé) : les datasheets sont importées sans coût,
à compléter par un import ultérieur (l'import est un upsert).
"""

import json
import re
import sys
import unicodedata
from pathlib import Path

GAME_SYSTEM_ID = "gs-w40k"


def slugify(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^a-zA-Z0-9]+", "-", text).strip("-").lower()
    return text or "x"


def parse_int(value: str) -> int | None:
    match = re.search(r"-?\d+", value or "")
    return int(match.group()) if match else None


def convert(ref_path: Path, out_path: Path) -> dict:
    data = json.loads(ref_path.read_text(encoding="utf-8"))
    faction_name = data["faction"]
    faction_slug = slugify(faction_name)
    faction_id = f"fac-{faction_slug}"

    keywords: dict[str, dict] = {}
    abilities: dict[str, dict] = {}
    weapons: dict[str, dict] = {}
    datasheets: list[dict] = []

    def keyword_id(name: str) -> str:
        kid = f"kw-{slugify(name)}"
        keywords.setdefault(kid, {"id": kid, "name": name})
        return kid

    def ability_id(name: str) -> str:
        aid = f"ab-{slugify(name)}"
        abilities.setdefault(
            aid, {"id": aid, "name": name, "description": ""}
        )
        return aid

    def weapon_id(name: str, is_melee: bool) -> str:
        wid = f"wp-{slugify(name)}"
        weapons.setdefault(
            wid, {"id": wid, "name": name, "isMelee": is_melee}
        )
        return wid

    for unit in data["units"]:
        name = unit["name"].strip()
        unit_keywords = [
            k.strip() for k in (unit.get("keywords") or "").split(",")
            if k.strip()
        ]

        keyword_ids = [keyword_id(k) for k in unit_keywords]

        ability_ids = []
        for apt in unit.get("aptitudes") or []:
            # "Base : Meneur, Frappe en Profondeur" -> noms individuels
            apt = re.sub(r"^(Base|Faction)\s*:\s*", "", apt.strip())
            for part in apt.split(","):
                part = part.strip()
                if part:
                    ability_ids.append(ability_id(part))

        weapon_ids = []
        for wname in unit.get("weapons_tir") or []:
            weapon_ids.append(weapon_id(wname.strip(), is_melee=False))
        for wname in unit.get("weapons_melee") or []:
            weapon_ids.append(weapon_id(wname.strip(), is_melee=True))

        models = []
        for stat in unit.get("stats") or []:
            profile = {
                "name": (stat.get("label") or "").strip() or name,
                "movement": parse_int(stat.get("M", "")),
                "toughness": parse_int(stat.get("E", "")),
                "save": parse_int(stat.get("SV", "")),
                "wounds": parse_int(stat.get("PV", "")),
                "leadership": parse_int(stat.get("CD", "")),
                "objectiveControl": parse_int(stat.get("CO", "")),
            }
            if None in profile.values():
                continue  # profil incomplet (parsing PDF raté) : on saute
            models.append(profile)

        if "Personnage" in unit_keywords:
            role = "Personnage"
        elif "Ligne" in unit_keywords:
            role = "Ligne"
        else:
            role = "Autre"

        datasheets.append({
            "id": f"ds-{faction_slug}-{slugify(name)}",
            "name": name,
            "factionId": faction_id,
            "battlefieldRole": role,
            "unitType": unit_keywords[0] if unit_keywords else "Autre",
            "keywordIds": sorted(set(keyword_ids)),
            "abilityIds": sorted(set(ability_ids)),
            "weaponIds": sorted(set(weapon_ids)),
            "models": models,
        })

    document = {
        "factions": [{
            "id": faction_id,
            "gameSystemId": GAME_SYSTEM_ID,
            "name": faction_name,
        }],
        "keywords": sorted(keywords.values(), key=lambda k: k["id"]),
        "abilities": sorted(abilities.values(), key=lambda a: a["id"]),
        "weapons": sorted(weapons.values(), key=lambda w: w["id"]),
        "datasheets": datasheets,
    }

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(
        json.dumps(document, ensure_ascii=False, indent=1),
        encoding="utf-8",
    )
    return document


def main() -> None:
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)

    ref_path = Path(sys.argv[1])
    if len(sys.argv) >= 3:
        out_path = Path(sys.argv[2])
    else:
        out_path = (
            ref_path.parent.parent / "import_json" / f"{ref_path.stem}.json"
        )

    document = convert(ref_path, out_path)
    print(
        f"{out_path} : "
        f"{len(document['datasheets'])} datasheets, "
        f"{len(document['weapons'])} armes, "
        f"{len(document['keywords'])} mots-clés, "
        f"{len(document['abilities'])} aptitudes"
    )


if __name__ == "__main__":
    main()
