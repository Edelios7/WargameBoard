# -*- coding: utf-8 -*-
"""Extrait la section "MISES A JOUR DE REGLES" (texte d'errata) de chaque
faction pack francais local (dossier 'mise a jour 22 07 2026'), du titre
"MISES A JOUR" jusqu'a "FAQ" (ou fin de document si pas de FAQ), et
l'ecrit en texte brut par faction pour etude/parsing ulterieur.

Usage: python extract_faction_pack_updates.py
"""
import glob
import json
import os

import fitz

PDF_DIR = r"C:\Projet\wargameboard\local_assets\wh40k_reference\PDFS\mise à jour 22 07 2026"
OUT_DIR = (
    r"C:\Users\Edelios\AppData\Local\Temp\claude\C--Projet-wargameboard"
    r"\9ee87ebc-ac89-4941-8f6b-6ce7493718e9\scratchpad\errata_raw"
)

SKIP = {"event_companion", "teams_event_companion", "universal_rules_updates", "dominatus_event_companion"}


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    paths = sorted(glob.glob(os.path.join(PDF_DIR, "fre_22-07_*.pdf")))
    index = {}
    for path in paths:
        base = os.path.basename(path)
        if any(s in base for s in SKIP):
            continue
        doc = fitz.open(path)
        pages_text = [page.get_text() for page in doc]
        full = "\n".join(pages_text)
        start = full.find("MISES À JOUR")
        if start == -1:
            start = full.find("MISES A JOUR")
        end = full.find("FAQ", start if start != -1 else 0)
        if start == -1:
            body = ""
        elif end == -1:
            body = full[start:]
        else:
            body = full[start:end]
        slug = (
            base.replace("fre_22-07_warhammer_40,000_faction_pack_", "")
            .replace("fre_22-07_warhammer_40000_faction_pack_", "")
            .replace(".pdf", "")
        )
        out_path = os.path.join(OUT_DIR, f"{slug}.txt")
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(body)
        index[slug] = {"source": base, "chars": len(body), "out": out_path}
        print(slug, len(body), "chars ->", out_path)

    with open(os.path.join(OUT_DIR, "_index.json"), "w", encoding="utf-8") as f:
        json.dump(index, f, ensure_ascii=False, indent=1)


if __name__ == "__main__":
    main()
