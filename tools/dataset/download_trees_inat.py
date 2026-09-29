#!/usr/bin/env python3
"""
Downloads real indicator tree field photographs from iNaturalist Open Data API
to assemble a Golden Validation Set in test/assets/trees/ for automated regression testing.
"""

import csv
import json
import os
import sys
import time
import urllib.request
from pathlib import Path

PLACE_CATALUNYA = 61614
PLACE_SPAIN = 6774

SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CSV_PATH = SCRIPT_DIR / "tree_species_list.csv"
OUTPUT_DIR = PROJECT_ROOT / "test" / "assets" / "trees"


def fetch_tree_photos(taxon_id: int, target_count: int = 6):
    """Fetches high-quality photo URLs from iNaturalist."""
    places = [PLACE_CATALUNYA, PLACE_SPAIN]
    photo_urls = []

    for pid in places:
        if len(photo_urls) >= target_count:
            break
        url = (
            f"https://api.inaturalist.org/v1/observations?"
            f"taxon_id={taxon_id}&place_id={pid}&quality_grade=research&per_page=30"
        )
        req = urllib.request.Request(url, headers={"User-Agent": "BoscdexApp/1.0"})
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = json.loads(resp.read().decode())
                results = data.get("results", [])
                for obs in results:
                    for photo in obs.get("photos", []):
                        p_url = photo.get("url", "")
                        if p_url:
                            # Use medium or large image
                            med_url = p_url.replace("/square.", "/medium.")
                            if med_url not in photo_urls:
                                photo_urls.append(med_url)
                                if len(photo_urls) >= target_count:
                                    break
                    if len(photo_urls) >= target_count:
                        break
        except Exception as e:
            print(f"    Warning: API error for taxon {taxon_id} (place={pid}): {e}")

    return photo_urls


def download_photos(tree_id: str, photo_urls: list, out_dir: Path):
    """Downloads photos and saves them as test assets."""
    target_dir = out_dir / tree_id
    target_dir.mkdir(parents=True, exist_ok=True)

    downloaded = 0
    for idx, url in enumerate(photo_urls):
        file_path = target_dir / f"{tree_id}_{idx + 1}.jpg"
        if file_path.exists():
            downloaded += 1
            continue

        try:
            req = urllib.request.Request(url, headers={"User-Agent": "BoscdexApp/1.0"})
            with urllib.request.urlopen(req, timeout=15) as resp:
                content = resp.read()
                if len(content) > 5000:  # Valid image size
                    with open(file_path, "wb") as f:
                        f.write(content)
                    downloaded += 1
                    time.sleep(0.3)
        except Exception as e:
            print(f"    Error downloading {url}: {e}")

    return downloaded


import argparse


def main():
    parser = argparse.ArgumentParser(
        description="Download real Catalan indicator tree field photos from iNaturalist."
    )
    parser.add_argument(
        "--count",
        type=int,
        default=6,
        help="Target number of photos per species (default: 6 for golden set, 50 for training)",
    )
    parser.add_argument(
        "--output",
        type=str,
        default=str(OUTPUT_DIR),
        help="Output directory path",
    )
    args = parser.parse_args()

    out_dir = Path(args.output)
    print(
        f"🌲 Downloading Catalan Indicator Trees ({args.count} per species) to {out_dir}..."
    )
    out_dir.mkdir(parents=True, exist_ok=True)

    with open(CSV_PATH, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            tree_id = row["tree_id"]
            catalan_name = row["catalan_name"]
            taxon_id = int(row["inat_taxon_id"])

            print(
                f"  Fetching photos for {catalan_name} ({tree_id}, taxon={taxon_id})..."
            )
            urls = fetch_tree_photos(taxon_id, target_count=args.count)
            count = download_photos(tree_id, urls, out_dir)
            print(
                f"  ✓ {catalan_name}: {count} real field photos in {out_dir / tree_id}"
            )


if __name__ == "__main__":
    main()
