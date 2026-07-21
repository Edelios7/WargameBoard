# -*- coding: utf-8 -*-
"""Convertit un JSON de référence v2 (local_assets/wh40k_reference/units_md_v2/*.json,
produit par local_assets/wh40k_reference/parse_datasheets_v2.py) vers le
format d'import JSON de l'application (voir lib/services/catalog_import_service.dart).

Contrairement à convert_reference_to_import.py (qui convertit les fichiers
v1, sans profils d'armes ni texte d'aptitudes), ce script inclut :
  - les profils d'armes complets (portée/A/CT-CC/F/PA/D),
  - le texte complet des aptitudes (au lieu du nom seul).

L'import global (CatalogImportService.importJson) est transactionnel :
un seul profil d'arme invalide ferait échouer TOUT le document. On est
donc volontairement défensif ici — toute entrée qui ne convertit pas
proprement est journalisée et ignorée plutôt que de faire planter
l'import complet.

Usage :
  python tools/convert_reference_v2_to_import.py <ref.json> [<sortie.json>]

Sans argument de sortie, écrit à côté du fichier source dans
local_assets/wh40k_reference/import_json_v2/ (dossier local-only).
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


def parse_int(value):
    if value is None:
        return None
    match = re.search(r"-?\d+", str(value))
    return int(match.group()) if match else None


def parse_range(value):
    if value is None:
        return None
    if "Mêlée" in value or "Melee" in value:
        return 0
    return parse_int(value)


def parse_skill(value):
    if value is None:
        return None
    if value.strip().upper() in ("N/A", "-", ""):
        return None
    return parse_int(value)


def convert(ref_path: Path, out_path: Path, warnings: list) -> dict:
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

    def ability_id(name: str, description: str = "") -> str:
        aid = f"ab-{slugify(name)}"
        existing = abilities.get(aid)
        if existing is None:
            abilities[aid] = {"id": aid, "name": name, "description": description}
        elif description and not existing["description"]:
            existing["description"] = description
        return aid

    def weapon_id_and_profile(entry: dict, is_melee: bool, unit_name: str):
        name = entry["name"].strip()
        if not name:
            return None
        wid = f"wp-{slugify(name)}"
        weapon = weapons.setdefault(
            wid, {"id": wid, "name": name, "isMelee": is_melee, "profiles": []}
        )

        rng = parse_range(entry.get("range"))
        strength = parse_int(entry.get("strength"))
        ap = parse_int(entry.get("ap"))
        attacks = (entry.get("attacks") or "").strip()
        damage = (entry.get("damage") or "").strip()
        skill = parse_skill(entry.get("skill"))

        if rng is None or strength is None or ap is None or not attacks or not damage:
            warnings.append(
                f"{unit_name}: profil ignoré pour '{name}' (données incomplètes: "
                f"range={entry.get('range')!r} A={attacks!r} skill={entry.get('skill')!r} "
                f"S={entry.get('strength')!r} PA={entry.get('ap')!r} D={damage!r})"
            )
            return wid

        profile = {
            "range": rng,
            "attacks": attacks,
            "strength": strength,
            "armorPenetration": -abs(ap) if ap > 0 else ap,
            "damage": damage,
        }
        if is_melee:
            profile["weaponSkill"] = skill
        else:
            profile["ballisticSkill"] = skill

        # Évite les doublons de profil identique si la même arme
        # réapparaît sur plusieurs fiches avec les mêmes valeurs.
        if profile not in weapon["profiles"]:
            weapon["profiles"].append(profile)
        return wid

    for unit in data["units"]:
        name = unit["name"].strip()
        if not name or "�" in name:
            warnings.append(f"Fiche ignorée (nom corrompu/illisible): {name!r}")
            continue

        unit_keywords = [k.strip() for k in unit.get("keywords") or [] if k.strip()]
        keyword_ids = [keyword_id(k) for k in unit_keywords if "�" not in k]

        ability_ids = []
        for ref_name in unit.get("base_abilities_ref") or []:
            if ref_name and "�" not in ref_name:
                ability_ids.append(ability_id(ref_name))
        for ref_name in unit.get("faction_abilities_ref") or []:
            if ref_name and "�" not in ref_name:
                ability_ids.append(ability_id(ref_name))
        for entry in unit.get("abilities") or []:
            aname = (entry.get("name") or "").strip()
            adesc = (entry.get("description") or "").strip()
            if aname and "�" not in aname and "�" not in adesc:
                ability_ids.append(ability_id(aname, adesc))

        weapon_ids = []
        for entry in unit.get("ranged_weapons") or []:
            if "�" in entry.get("name", ""):
                continue
            wid = weapon_id_and_profile(entry, is_melee=False, unit_name=name)
            if wid:
                weapon_ids.append(wid)
        for entry in unit.get("melee_weapons") or []:
            if "�" in entry.get("name", ""):
                continue
            wid = weapon_id_and_profile(entry, is_melee=True, unit_name=name)
            if wid:
                weapon_ids.append(wid)

        models = []
        for stat in unit.get("models") or []:
            profile = {
                "name": name,
                "movement": parse_int(stat.get("M")),
                "toughness": parse_int(stat.get("E")),
                "save": parse_int(stat.get("SV")),
                "wounds": parse_int(stat.get("PV")),
                "leadership": parse_int(stat.get("CD")),
                "objectiveControl": parse_int(stat.get("CO")),
            }
            if None in profile.values():
                warnings.append(f"{name}: profil de modèle incomplet ignoré ({stat})")
                continue
            models.append(profile)

        if not models:
            warnings.append(f"{name}: aucune fiche de profil valide, unité ignorée")
            continue

        if "Personnage" in unit_keywords:
            role = "Personnage"
        elif "Ligne" in unit_keywords:
            role = "Ligne"
        else:
            role = "Autre"

        datasheets.append(
            {
                "id": f"ds-{faction_slug}-{slugify(name)}",
                "name": name,
                "factionId": faction_id,
                "battlefieldRole": role,
                "unitType": unit_keywords[0] if unit_keywords else "Autre",
                "keywordIds": sorted(set(keyword_ids)),
                "abilityIds": sorted(set(ability_ids)),
                "weaponIds": sorted(set(weapon_ids)),
                "models": models,
            }
        )

    # CatalogImportService remplace TOUS les profils existants d'une arme
    # par ceux du document importé (voir _importWeapons). Une même arme
    # (même nom -> même id) apparaît souvent dans plusieurs fichiers de
    # faction ; si sur UNE fiche son extraction a échoué (profil vide) et
    # que ce fichier est importé après un autre où elle avait un profil
    # valide, l'import écraserait le bon profil avec rien. On omet donc du
    # document les armes qui n'ont ici aucun profil valide : le lien
    # datasheet -> arme reste (weaponIds la référence toujours), seule
    # l'écriture destructive de la table weapons/profils est évitée. Si
    # aucune fiche, dans aucune faction, ne fournit jamais de profil valide
    # pour cette arme, elle n'existera simplement pas en base — préférable
    # à un profil vide qui s'afficherait comme cassé dans le catalogue.
    complete_weapons = [w for w in weapons.values() if w["profiles"]]
    skipped_weapons = len(weapons) - len(complete_weapons)
    if skipped_weapons:
        warnings.append(
            f"{skipped_weapons} arme(s) omise(s) du document (aucun profil "
            "valide dans cette faction) pour ne pas écraser un profil "
            "valide importé par une autre faction : "
            f"{', '.join(sorted(w['name'] for w in weapons.values() if not w['profiles']))}"
        )

    document = {
        "factions": [
            {"id": faction_id, "gameSystemId": GAME_SYSTEM_ID, "name": faction_name}
        ],
        "keywords": sorted(keywords.values(), key=lambda k: k["id"]),
        "abilities": sorted(abilities.values(), key=lambda a: a["id"]),
        "weapons": sorted(complete_weapons, key=lambda w: w["id"]),
        "datasheets": datasheets,
    }

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(
        json.dumps(document, ensure_ascii=False, indent=1), encoding="utf-8"
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
            ref_path.parent.parent / "import_json_v2" / f"{ref_path.stem}.json"
        )

    warnings: list[str] = []
    document = convert(ref_path, out_path, warnings)
    n_profiles = sum(len(w["profiles"]) for w in document["weapons"])
    print(
        f"{out_path} : "
        f"{len(document['datasheets'])} datasheets, "
        f"{len(document['weapons'])} armes ({n_profiles} profils), "
        f"{len(document['keywords'])} mots-clés, "
        f"{len(document['abilities'])} aptitudes, "
        f"{len(warnings)} avertissements"
    )
    for w in warnings[:30]:
        print("  !", w)
    if len(warnings) > 30:
        print(f"  ... et {len(warnings) - 30} de plus")


if __name__ == "__main__":
    main()
