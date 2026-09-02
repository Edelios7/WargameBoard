# -*- coding: utf-8 -*-
"""Parse le texte d'errata extrait par extract_faction_pack_updates.py en
une liste structuree de changements : {faction, unit_names, section,
action, new_text}.

v2 : la premiere version capturait le texte de remplacement jusqu'a une
heuristique de "nouvelle ligne cible" peu fiable, ce qui faisait deraper
la capture d'un bloc sur le suivant des qu'un format imbrique (nom
d'unite seul, puis plusieurs puces "▪Aptitude X - Remplacez par : ...")
apparaissait (constate sur T'au Empire). Cette version s'appuie plutot
sur un signal fiable et quasi-systematique du format des faction packs :
tout texte de remplacement complet est cite entre guillemets francais
courbes ("..."), donc la capture s'arrete des qu'une ligne contient le
guillemet fermant, plutot que de deviner ou commence le bloc suivant.

Usage: python parse_faction_pack_updates.py
Ecrit errata_parsed.json dans le meme dossier que le texte source.
"""
import glob
import json
import os
import re

IN_DIR = (
    r"C:\Users\Edelios\AppData\Local\Temp\claude\C--Projet-wargameboard"
    r"\9ee87ebc-ac89-4941-8f6b-6ce7493718e9\scratchpad\errata_raw"
)
OUT_PATH = os.path.join(IN_DIR, "errata_parsed.json")

FULL_REPLACE_RE = re.compile(
    r"^(Remplacez par\s*:|Remplacez le profil par\s*:|Remplacez le premier paragraphe par\s*:|"
    r"Ajoutez la section .* suivante\s*:)$",
    re.IGNORECASE,
)
ACTION_START_RE = re.compile(
    r"^(Remplacez|Ajoutez|Retirez|Supprimez)\b", re.IGNORECASE
)
# Seul "▪"/"•" marque une vraie puce dans ces documents : un "-" seul en
# tete de ligne est presque toujours une valeur de PA negative dans un
# tableau de profil d'arme ("-2"), jamais une puce - les confondre
# coupait la capture d'un profil d'arme en plein milieu du tableau.
BULLET_RE = re.compile(r"^[▪•]\s*(.+?)\s*-\s*(Remplacez.+|Ajoutez.+|Retirez.+)$")
# Variante ou la puce ne porte que le nom de l'aptitude, l'action
# (Remplacez par : / Remplacez le profil par :) venant sur la ligne
# suivante plutot qu'apres un tiret sur la meme ligne.
BULLET_NAME_ONLY_RE = re.compile(r"^[▪•]\s*(.+)$")


def clean(line):
    return line.strip().replace("\u2009", " ").replace("\xa0", " ")


CLOSING_QUOTE_RE = re.compile(r"(?<!\d)\u201d\s*$")


def has_closing_quote(line):
    # Le guillemet francais fermant courbe (\u201d) sert AUSSI de symbole
    # pouces pour une distance en plein milieu d'une phrase ("a 8\u201d ou
    # moins de cette unite...") - une vraie fin de citation, elle,
    # n'apparait qu'en toute fin de ligne et n'est jamais precedee d'un
    # chiffre (une distance se lit toujours "<nombre>\u201d", jamais juste
    # "\u201d" seul en fin de ligne sauf a la toute derniere phrase citee).
    return bool(CLOSING_QUOTE_RE.search(line))


def capture_quoted_block(lines, i, n):
    """A partir de i (premiere ligne APRES le marqueur d'action), avale
    des lignes jusqu'a rencontrer une ligne contenant le guillemet
    fermant (fin de citation), ou jusqu'a un signal fort de nouveau bloc
    (une ligne qui EST elle-meme une puce/target suivie d'une action) si
    aucun guillemet n'apparait (texte non cite, plus rare)."""
    collected = []
    while i < n:
        line = lines[i]
        collected.append(line)
        i += 1
        if has_closing_quote(line):
            return collected, i
        # Filet de securite si le bloc n'est jamais cite entre
        # guillemets : on s'arrete des qu'on rencontre une nouvelle
        # puce ou un nouveau bloc plat, plutot que de tout avaler.
        if i < n and (
            BULLET_RE.match(lines[i])
            # Une puce "nom seul" ne signale un NOUVEAU bloc que si une
            # ligne d'action suit vraiment juste apres - sinon c'est un
            # simple item de liste a puces DANS le texte en cours de
            # citation (ex. deux "▪..." qui font partie de la MEME
            # aptitude reecrite), qu'il ne faut surtout pas couper.
            or (
                BULLET_NAME_ONLY_RE.match(lines[i])
                and i + 1 < n
                and ACTION_START_RE.match(lines[i + 1])
            )
            or _looks_like_flat_target(lines, i, n)
            or _looks_like_bare_parent(lines, i, n)
        ):
            return collected, i
    return collected, i


def _looks_like_flat_target(lines, i, n):
    return (
        i + 1 < n
        and len(lines[i]) < 100
        and not lines[i].endswith((".", ":"))
        and not has_closing_quote(lines[i])
        and ACTION_START_RE.match(lines[i + 1])
    )


def _looks_like_bare_parent(lines, i, n):
    """Ligne courte type "Nom d'unite" seule, suivie d'une puce (avec ou
    sans action inline) : marque le debut d'un nouveau bloc imbrique, ne
    doit jamais etre avalee dans le texte de remplacement en cours."""
    return (
        len(lines[i]) < 80
        and not lines[i].endswith((".", ":", "”", '"'))
        # Un vrai nom d'unite "parent" ne commence jamais lui-meme par une
        # puce : "▪[TOUCHES SOUTENUES 1]" suivi de "▪[TOUCHES FATALES]"
        # est une liste a puces DANS le texte en cours, pas un nom de
        # figurine suivi de son propre bloc imbrique.
        and not BULLET_NAME_ONLY_RE.match(lines[i])
        and i + 1 < n
        and (BULLET_RE.match(lines[i + 1]) or BULLET_NAME_ONLY_RE.match(lines[i + 1]))
    )


def strip_quotes(text):
    return text.strip().strip("\u201c\u201d\"").strip()


def split_target(line):
    line = line.rstrip(" :")
    parts = [p.strip() for p in line.split(",")]
    section_start = None
    for idx, p in enumerate(parts):
        if re.match(r"(?i)^(section|aptitude)\b", p):
            section_start = idx
            break
    if section_start is not None:
        name_parts = parts[:section_start]
        section = ", ".join(parts[section_start:])
    elif len(parts) >= 2 and len(parts[-1]) < 60:
        name_parts, section = parts[:-1], parts[-1]
    else:
        # Pas de virgule : format "<Nom> Aptitude <X>" ou "<Nom> aptitude <X>".
        m = re.match(r"(?i)^(.*?)\s+(aptitude\s+.+)$", line)
        if m:
            name_parts, section = [m.group(1)], m.group(2)
        else:
            name_parts, section = parts, "?"
    names = []
    for p in name_parts:
        names.extend(n.strip() for n in re.split(r"\bet\b", p) if n.strip())
    return [n for n in names if n], section.strip()


def parse_faction(text):
    lines = [clean(l) for l in text.splitlines()]
    lines = [l for l in lines if l]

    try:
        idx = next(i for i, l in enumerate(lines) if l.upper() == "FICHES TECHNIQUES")
    except StopIteration:
        idx = len(lines)
    army_lines = lines[:idx]
    ds_lines = lines[idx + 1 :] if idx < len(lines) else []

    changes = []
    pending_target = None
    i = 0
    n = len(ds_lines)
    while i < n:
        line = ds_lines[i]

        bullet = BULLET_RE.match(line)
        if bullet and pending_target:
            section = bullet.group(1).strip()
            action = bullet.group(2).strip()
            i += 1
            if FULL_REPLACE_RE.match(action):
                block, i = capture_quoted_block(ds_lines, i, n)
                changes.append(
                    {
                        "unit_names": pending_target,
                        "section": section,
                        "action": action,
                        "new_text": strip_quotes(" ".join(block)),
                    }
                )
            else:
                changes.append(
                    {"unit_names": pending_target, "section": section, "action": action, "new_text": None}
                )
            continue

        bullet_name_only = BULLET_NAME_ONLY_RE.match(line)
        if (
            bullet_name_only
            and pending_target
            and i + 1 < n
            and ACTION_START_RE.match(ds_lines[i + 1])
        ):
            section = bullet_name_only.group(1).strip()
            action = ds_lines[i + 1]
            i += 2
            if FULL_REPLACE_RE.match(action):
                block, i = capture_quoted_block(ds_lines, i, n)
                changes.append(
                    {
                        "unit_names": pending_target,
                        "section": section,
                        "action": action,
                        "new_text": strip_quotes(" ".join(block)),
                    }
                )
            else:
                changes.append(
                    {"unit_names": pending_target, "section": section, "action": action, "new_text": None}
                )
            continue

        if _looks_like_flat_target(ds_lines, i, n):
            names, section = split_target(line)
            action = ds_lines[i + 1]
            i += 2
            if FULL_REPLACE_RE.match(action):
                block, i = capture_quoted_block(ds_lines, i, n)
                changes.append(
                    {
                        "unit_names": names,
                        "section": section,
                        "action": action,
                        "new_text": strip_quotes(" ".join(block)),
                    }
                )
            else:
                changes.append({"unit_names": names, "section": section, "action": action, "new_text": None})
            pending_target = None
            continue

        if ACTION_START_RE.match(line) and pending_target:
            # One-liner rattache au dernier target connu (bloc imbrique
            # sans tiret, rare).
            changes.append(
                {"unit_names": pending_target, "section": "(suite)", "action": line, "new_text": None}
            )
            i += 1
            continue

        # Ligne "parent" nue : courte, sans ponctuation finale, et suivie
        # d'une puce -> nom(s) d'unite pour le bloc imbrique a venir.
        if (
            len(line) < 80
            and not line.endswith((".", ":", "\u201d", '"'))
            and i + 1 < n
            and (BULLET_RE.match(ds_lines[i + 1]) or BULLET_NAME_ONLY_RE.match(ds_lines[i + 1]))
        ):
            pending_target = [n.strip() for n in re.split(r",|\bet\b", line) if n.strip()]
        i += 1

    return {"army_rules_text": "\n".join(army_lines), "datasheet_changes": changes}


def main():
    result = {}
    for path in sorted(glob.glob(os.path.join(IN_DIR, "*.txt"))):
        slug = os.path.basename(path)[:-4]
        text = open(path, encoding="utf-8").read()
        result[slug] = parse_faction(text)
        print(slug, "->", len(result[slug]["datasheet_changes"]), "changements datasheets captures")

    with open(OUT_PATH, "w", encoding="utf-8") as f:
        json.dump(result, f, ensure_ascii=False, indent=1)
    print("Ecrit:", OUT_PATH)


if __name__ == "__main__":
    main()
