#!/usr/bin/env python3
"""
Download mushroom images from iNaturalist for Boscdex model training.

Uses the iNaturalist Open Data API to download research-grade observations
filtered to Catalonia (place_id=7525) or broader Spain (place_id=6774).

Requirements:
    pip install pyinaturalist requests tqdm pillow

Usage:
    python download_inat.py --species-csv species_list.csv --output-dir ./dataset
    python download_inat.py --species-csv species_list.csv --output-dir ./dataset --place-id 7525
"""

import argparse
import csv
import os
import time
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

try:
    from pyinaturalist import get_observations
    from tqdm import tqdm
    import requests
    from PIL import Image
    from io import BytesIO
except ImportError:
    print("Required packages not found. Install with:")
    print("  pip install pyinaturalist requests tqdm pillow")
    exit(1)

# iNaturalist place IDs
PLACE_CATALONIA = 7525
PLACE_SPAIN = 6774
PLACE_EUROPE = 97393

# Image settings
TARGET_SIZE = (256, 256)
MIN_IMAGE_SIZE = (100, 100)


def download_image(url: str, output_path: Path) -> bool:
    """Download and resize a single image from iNaturalist."""
    try:
        response = requests.get(url, timeout=15)
        response.raise_for_status()

        img = Image.open(BytesIO(response.content))

        # Skip too-small images
        if img.size[0] < MIN_IMAGE_SIZE[0] or img.size[1] < MIN_IMAGE_SIZE[1]:
            return False

        # Convert to RGB if needed (remove alpha channel)
        if img.mode != 'RGB':
            img = img.convert('RGB')

        # Resize maintaining aspect ratio, then center-crop
        img.thumbnail((TARGET_SIZE[0] * 2, TARGET_SIZE[1] * 2), Image.LANCZOS)
        width, height = img.size
        left = (width - TARGET_SIZE[0]) // 2
        top = (height - TARGET_SIZE[1]) // 2
        right = left + TARGET_SIZE[0]
        bottom = top + TARGET_SIZE[1]
        img = img.crop((left, top, right, bottom))

        img.save(output_path, 'JPEG', quality=90)
        return True
    except Exception as e:
        return False


def fetch_species_images(
    taxon_name: str,
    taxon_id: int,
    output_dir: Path,
    target_count: int = 300,
    place_id: int = PLACE_CATALONIA,
):
    """Fetch and download images for a single species."""
    species_dir = output_dir / taxon_name.lower().replace(' ', '_')
    species_dir.mkdir(parents=True, exist_ok=True)

    existing = len(list(species_dir.glob('*.jpg')))
    if existing >= target_count:
        print(f"  ✓ {taxon_name}: already has {existing}/{target_count} images")
        return existing

    needed = target_count - existing
    print(f"  ↓ {taxon_name}: need {needed} more images (have {existing})")

    # Try Catalonia first, then Spain, then Europe
    places_to_try = [place_id, PLACE_SPAIN, PLACE_EUROPE]
    downloaded = existing

    for pid in places_to_try:
        if downloaded >= target_count:
            break

        page = 1
        per_page = 200

        while downloaded < target_count:
            try:
                observations = get_observations(
                    taxon_id=taxon_id,
                    place_id=pid,
                    quality_grade='research',
                    photos=True,
                    per_page=per_page,
                    page=page,
                )
            except Exception as e:
                print(f"    API error for {taxon_name} (place={pid}): {e}")
                break

            results = observations.get('results', [])
            if not results:
                break

            for obs in results:
                if downloaded >= target_count:
                    break

                for photo in obs.get('photos', []):
                    if downloaded >= target_count:
                        break

                    # Get medium-sized photo URL
                    url = photo.get('url', '')
                    if not url:
                        continue
                    # Replace 'square' with 'medium' for better resolution
                    url = url.replace('/square.', '/medium.')

                    photo_id = photo.get('id', f'unknown_{downloaded}')
                    output_path = species_dir / f"{photo_id}.jpg"

                    if output_path.exists():
                        continue

                    if download_image(url, output_path):
                        downloaded += 1

            page += 1
            # Rate limiting: be respectful to iNaturalist API
            time.sleep(1.0)

    print(f"  ✓ {taxon_name}: {downloaded}/{target_count} images")
    return downloaded


def main():
    parser = argparse.ArgumentParser(
        description='Download iNaturalist mushroom images for Boscdex training'
    )
    parser.add_argument(
        '--species-csv', type=str, required=True,
        help='Path to species_list.csv with columns: species_id, scientific_name, catalan_name, inat_taxon_id, edibility, target_image_count'
    )
    parser.add_argument(
        '--output-dir', type=str, default='./dataset',
        help='Output directory for downloaded images'
    )
    parser.add_argument(
        '--place-id', type=int, default=PLACE_CATALONIA,
        help=f'iNaturalist place ID (default: {PLACE_CATALONIA} = Catalonia)'
    )
    args = parser.parse_args()

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Read species list
    species = []
    with open(args.species_csv, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            species.append(row)

    print(f"\n🍄 Boscdex Dataset Downloader")
    print(f"   Target species: {len(species)}")
    print(f"   Output: {output_dir.absolute()}")
    print(f"   Place ID: {args.place_id}\n")

    total_downloaded = 0
    for sp in species:
        count = fetch_species_images(
            taxon_name=sp['scientific_name'],
            taxon_id=int(sp['inat_taxon_id']),
            output_dir=output_dir,
            target_count=int(sp['target_image_count']),
            place_id=args.place_id,
        )
        total_downloaded += count

    print(f"\n✅ Done! Total images: {total_downloaded}")
    print(f"   Dataset location: {output_dir.absolute()}")


if __name__ == '__main__':
    main()
