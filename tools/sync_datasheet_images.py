# -*- coding: utf-8 -*-
"""Copie les photos d'unités déjà extraites des PDF officiels
(local_assets/wh40k_reference/units_md/images/) vers
local_assets/datasheets/<id>.<ext>, avec exactement le même id que celui
généré par convert_reference_to_import.py (donc que celui utilisé dans la
base importée). L'app les détecte automatiquement (voir
lib/core/utils/local_catalog_images.dart).

Usage : python tools/sync_datasheet_images.py
"""
import json
import shutil
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from convert_reference_to_import import slugify  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
REF_DIR = ROOT / "local_assets" / "wh40k_reference" / "units_md"
DEST = ROOT / "local_assets" / "datasheets"


def main() -> None:
    DEST.mkdir(parents=True, exist_ok=True)
    copied = 0
    missing = 0
    for jf in sorted(REF_DIR.glob("*.json")):
        data = json.loads(jf.read_text(encoding="utf-8"))
        faction_slug = slugify(data["faction"])
        for u in data["units"]:
            ds_id = f"ds-{faction_slug}-{slugify(u['name'])}"
            image = u.get("image")
            if not image:
                missing += 1
                continue
            src = REF_DIR / image
            if not src.exists():
                missing += 1
                continue
            ext = src.suffix.lstrip(".")
            dest = DEST / f"{ds_id}.{ext}"
            shutil.copy2(src, dest)
            copied += 1
    print(f"Copié {copied} photos vers {DEST} ({missing} unités sans photo)")


if __name__ == "__main__":
    main()
