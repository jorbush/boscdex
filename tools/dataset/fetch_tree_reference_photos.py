#!/usr/bin/env python3
"""
Fetch free-licensed (CC-BY, CC-BY-SA) botanical reference photos from Wikimedia Commons
for all 5 indicator tree species cataloged in Boscdex:
- Pinus sylvestris (Pi roig)
- Pinus halepensis (Pi blanc)
- Quercus ilex (Alzina)
- Fagus sylvatica (Faig)
- Castanea sativa (Castanyer)
"""

import json
import subprocess
import urllib.request
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
OUTPUT_DIR = PROJECT_ROOT / "assets" / "images" / "reference"
ATTRIBUTIONS_JSON = OUTPUT_DIR / "attributions.json"
ATTRIBUTIONS_MD = OUTPUT_DIR / "ATTRIBUTIONS.md"

HEADERS = {
    "User-Agent": "BoscdexTreeBotanicalFetcher/1.0 (https://github.com/jorbush/boscdex; bot@boscdex.org)"
}

TREES = [
    {
        "species_id": "pinus_sylvestris",
        "scientific_name": "Pinus sylvestris",
        "catalan_name": "Pi roig",
        "photo_id": "wikimedia_pinus_sylvestris",
        "author": "Dominicus Johannes Bergsma",
        "license_code": "cc-by-sa",
        "license_name": "CC BY-SA 4.0",
        "attribution_text": "(c) Dominicus Johannes Bergsma, some rights reserved (CC BY-SA 4.0)",
        "source_url": "https://commons.wikimedia.org/wiki/File:Vliegden_(Pinus_sylvestris)_spiegelt_zich_in_een_heide_ven._Locatie,_natuurgebied_Delleboersterheide_%E2%80%93_Catspoele_01.jpg",
        "img_url": "https://upload.wikimedia.org/wikipedia/commons/1/1b/Vliegden_%28Pinus_sylvestris%29_spiegelt_zich_in_een_heide_ven._Locatie%2C_natuurgebied_Delleboersterheide_%E2%80%93_Catspoele_01.jpg",
    },
    {
        "species_id": "pinus_halepensis",
        "scientific_name": "Pinus halepensis",
        "catalan_name": "Pi blanc",
        "photo_id": "wikimedia_pinus_halepensis",
        "author": "Christian Ferrer",
        "license_code": "cc-by-sa",
        "license_name": "CC BY-SA 3.0",
        "attribution_text": "(c) Christian Ferrer, some rights reserved (CC BY-SA 3.0)",
        "source_url": "https://commons.wikimedia.org/wiki/File:Pinus_halepensis,_S%C3%A8te,_H%C3%A9rault_01.jpg",
        "img_url": "https://upload.wikimedia.org/wikipedia/commons/9/9d/Pinus_halepensis%2C_S%C3%A8te%2C_H%C3%A9rault_01.jpg",
    },
    {
        "species_id": "quercus_ilex",
        "scientific_name": "Quercus ilex",
        "catalan_name": "Alzina",
        "photo_id": "wikimedia_quercus_ilex",
        "author": "Archenzo",
        "license_code": "cc-by-sa",
        "license_name": "CC BY-SA 3.0",
        "attribution_text": "(c) Archenzo, some rights reserved (CC BY-SA 3.0)",
        "source_url": "https://commons.wikimedia.org/wiki/File:Quercus_ilex_Madonie.JPG",
        "img_url": "https://upload.wikimedia.org/wikipedia/commons/2/26/Quercus_ilex_Madonie.JPG",
    },
    {
        "species_id": "fagus_sylvatica",
        "scientific_name": "Fagus sylvatica",
        "catalan_name": "Faig",
        "photo_id": "wikimedia_fagus_sylvatica",
        "author": "Jean-Pol GRANDMONT",
        "license_code": "cc-by",
        "license_name": "CC BY 3.0",
        "attribution_text": "(c) Jean-Pol GRANDMONT, some rights reserved (CC BY 3.0)",
        "source_url": "https://commons.wikimedia.org/wiki/File:Fagus_sylvatica_JPG2a.jpg",
        "img_url": "https://upload.wikimedia.org/wikipedia/commons/4/45/Fagus_sylvatica_JPG2a.jpg",
    },
    {
        "species_id": "castanea_sativa",
        "scientific_name": "Castanea sativa",
        "catalan_name": "Castanyer",
        "photo_id": "wikimedia_castanea_sativa",
        "author": "Georg Slickers",
        "license_code": "cc-by-sa",
        "license_name": "CC BY-SA 4.0",
        "attribution_text": "(c) Georg Slickers, some rights reserved (CC BY-SA 4.0)",
        "source_url": "https://commons.wikimedia.org/wiki/File:Castanea_sativa_20050703_433.jpg",
        "img_url": "https://upload.wikimedia.org/wikipedia/commons/9/90/Castanea_sativa_20050703_433.jpg",
    },
]


def download_and_optimize(item: dict) -> Path:
    species_id = item["species_id"]
    dest_path = OUTPUT_DIR / f"{species_id}.jpg"
    temp_raw = OUTPUT_DIR / f"temp_{species_id}_raw.jpg"

    print(f"[*] Downloading {species_id} from {item['img_url']}...")
    req = urllib.request.Request(item["img_url"], headers=HEADERS)
    with urllib.request.urlopen(req, timeout=30) as resp, open(temp_raw, "wb") as f:
        f.write(resp.read())

    # Optimize using sips to 800px max dimension, JPEG format, quality 85
    cmd = [
        "sips",
        "-s", "format", "jpeg",
        "-s", "formatOptions", "85",
        "--resampleHeightWidthMax", "800",
        str(temp_raw),
        "--out", str(dest_path),
    ]
    subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL)
    temp_raw.unlink(missing_ok=True)

    size_kb = dest_path.stat().st_size / 1024
    print(f"    [+] Saved {dest_path.name} ({size_kb:.1f} KB)")
    return dest_path


def update_attributions_json():
    with open(ATTRIBUTIONS_JSON, "r", encoding="utf-8") as f:
        data = json.load(f)

    # Filter out any existing entries for these trees to allow idempotency
    tree_ids = {t["species_id"] for t in TREES}
    updated = [item for item in data if item.get("species_id") not in tree_ids]

    for t in TREES:
        updated.append({
            "species_id": t["species_id"],
            "scientific_name": t["scientific_name"],
            "catalan_name": t["catalan_name"],
            "photo_id": t["photo_id"],
            "author": t["author"],
            "license_code": t["license_code"],
            "license_name": t["license_name"],
            "attribution_text": t["attribution_text"],
            "source_url": t["source_url"],
            "asset_path": f"assets/images/reference/{t['species_id']}.jpg",
        })

    with open(ATTRIBUTIONS_JSON, "w", encoding="utf-8") as f:
        json.dump(updated, f, indent=2, ensure_ascii=False)
    print(f"[*] Updated {ATTRIBUTIONS_JSON} (total {len(updated)} entries)")


def update_attributions_md():
    with open(ATTRIBUTIONS_MD, "r", encoding="utf-8") as f:
        content = f.read()

    # If section already exists, strip it
    header = "## Arbres Indicadors (Indicator Trees)"
    if header in content:
        content = content.split(header)[0].strip() + "\n\n"

    tree_table = [
        "## Arbres Indicadors (Indicator Trees)\n",
        "| # | Species | Catalan Name | Photographer | License | Source |",
        "|---|---|---|---|---|---|",
    ]

    for idx, t in enumerate(TREES, 1):
        line = f"| {idx} | *{t['scientific_name']}* | {t['catalan_name']} | {t['author']} | {t['license_name']} | [{t['photo_id']}]({t['source_url']}) |"
        tree_table.append(line)

    new_content = content.strip() + "\n\n" + "\n".join(tree_table) + "\n"
    with open(ATTRIBUTIONS_MD, "w", encoding="utf-8") as f:
        f.write(new_content)
    print(f"[*] Updated {ATTRIBUTIONS_MD}")


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    for tree in TREES:
        download_and_optimize(tree)
    update_attributions_json()
    update_attributions_md()
    print("[*] All 5 tree reference photos successfully processed and attributed!")


if __name__ == "__main__":
    main()
