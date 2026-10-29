#!/usr/bin/env python3
"""
Fetch free-licensed (CC0, CC-BY, CC-BY-SA) botanical reference photos from iNaturalist
and Wikimedia Commons for all 75 cataloged species in Boscdex.

Features:
- Uses verified Kingdom Fungi (taxon_id=47170) iNaturalist taxon IDs from species_list.csv
- Tier 1: Mycologist-curated taxon_photos on the exact iNaturalist species taxon
- Tier 2: Top-voted research-grade observations (order_by=votes) with Kingdom Fungi verification
- Tier 3: Wikimedia Commons bitmap photograph search (excluding illustrations, microscopy, maps)
- Strict deduplication (seen_photo_ids + MD5 file hashes) so no two species ever share a photo

Requirements:
  Python 3 (standard library: urllib, json, csv, hashlib, re, subprocess)
  macOS 'sips' command line tool for high-quality resizing and compression.

Usage:
  python3 tools/dataset/fetch_reference_photos.py
"""

import csv
import hashlib
import json
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

# Paths relative to boscdex/ directory
SCRIPT_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = SCRIPT_DIR.parent.parent
CSV_PATH = SCRIPT_DIR / "species_list.csv"
OUTPUT_DIR = PROJECT_ROOT / "assets" / "images" / "reference"
ATTRIBUTIONS_JSON = OUTPUT_DIR / "attributions.json"
ATTRIBUTIONS_MD = OUTPUT_DIR / "ATTRIBUTIONS.md"

ALLOWED_LICENSES = {"cc0", "pd", "cc-by", "cc-by-sa"}
FUNGI_KINGDOM_ID = 47170

HEADERS = {
    "User-Agent": "BoscdexBotanicalReferenceFetcher/2.0 (https://github.com/jorbush/boscdex; bot@boscdex.org)"
}

# Species to purge and re-fetch (empty when all 75 have been visually verified)
FORCE_REFRESH_SPECIES: set[str] = set()

# Blacklisted photo IDs from previous runs (corrupted taxa, illustrations, hands/fingers, lab slips, top-only views)
BLACKLISTED_PHOTO_IDS = {
    "541704469", "26383183", "437600506", "184719942", "667054384",
    "58769256", "608749761", "454369623", "164975679", "483373653",
    "237334862", "422321857", "263529501", "6868364", "701122865",
    "15223153", "54545340", "48569919", "351988052", "48162367",
    "220581174", "323011552", "748904857", "743902482", "751449110",
    "755572813", "109866645", "755059898", "752528698", "731554993",
    "749095796", "756044994", "752137351", "755879250", "619794259",
    "721136790", "756109449", "756262609", "749049477", "199562353",
    "238411867", "196605717", "10420482", "28636536", "237357256",
    "49567769", "80319735", "80319816", "80319843",
}

WIKIMEDIA_REJECT_KEYWORDS = (
    "illustration", "drawing", "plate", "curtis", "bresadola", "iconographia",
    "spore", "microscop", "asci", "basidia", "cystidia", "map", "distribution",
    "stamp", "logo", "icon", "herbarium", "holotype", "lectotype", "dish",
    "cooked", "soup", "recipe", "market", "basket",
)


def http_get_json(url: str, timeout: int = 20) -> dict | None:
    """Safe HTTP GET returning parsed JSON."""
    req = urllib.request.Request(url, headers=HEADERS)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except Exception as e:
        print(f"    [!] HTTP error fetching {url[:80]}...: {e}", file=sys.stderr)
        return None


def file_md5(path: Path) -> str:
    """Compute MD5 hex digest of a file."""
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def is_fungi_taxon(taxon_obj: dict | None) -> bool:
    """Verify that an iNaturalist taxon object belongs to Kingdom Fungi (47170)."""
    if not taxon_obj:
        return False
    if (taxon_obj.get("iconic_taxon_name") or "").lower() == "fungi":
        return True
    ancestor_ids = taxon_obj.get("ancestor_ids") or []
    return FUNGI_KINGDOM_ID in ancestor_ids


def download_and_optimize(image_url: str, dest_path: Path) -> bool:
    """Download image to temp file and optimize using sips to 800px JPEG quality 82."""
    temp_file = dest_path.with_suffix(".tmp.jpg")
    req = urllib.request.Request(image_url, headers=HEADERS)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp, open(temp_file, "wb") as out_f:
            out_f.write(resp.read())

        cmd = [
            "sips",
            "-Z", "800",
            "-s", "format", "jpeg",
            "-s", "formatOptions", "82",
            str(temp_file),
            "--out", str(dest_path),
        ]
        result = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        if temp_file.exists():
            temp_file.unlink()

        return result.returncode == 0 and dest_path.exists() and dest_path.stat().st_size > 5000
    except Exception as e:
        print(f"    [!] Failed to download/optimize {image_url}: {e}", file=sys.stderr)
        if temp_file.exists():
            temp_file.unlink()
        return False


def extract_candidates_inaturalist(
    scientific_name: str,
    verified_taxon_id: int,
    seen_photo_ids: set[str],
) -> list[dict]:
    """Return ordered list of candidate open-licensed photos from iNaturalist (curated taxon_photos first, then top-voted research observations)."""
    candidates: list[dict] = []
    candidate_taxon_ids: list[int] = [verified_taxon_id]

    # Step 1: Fetch the exact taxon by verified_taxon_id
    taxon_data = http_get_json(f"https://api.inaturalist.org/v1/taxa/{verified_taxon_id}")
    taxon_objs = []
    if taxon_data and taxon_data.get("results"):
        t0 = taxon_data["results"][0]
        if is_fungi_taxon(t0) and t0.get("rank") in ("species", "subspecies", "variety"):
            taxon_objs.append(t0)

    # Also search by exact scientific name restricted to Kingdom Fungi (47170) & rank=species
    # in case iNaturalist has a synonym species taxon with additional curated photos
    search_url = (
        f"https://api.inaturalist.org/v1/taxa?q={urllib.parse.quote(scientific_name)}"
        f"&taxon_id={FUNGI_KINGDOM_ID}&rank=species"
    )
    search_data = http_get_json(search_url)
    if search_data and search_data.get("results"):
        for t in search_data["results"]:
            if (
                is_fungi_taxon(t)
                and t.get("rank") == "species"
                and t.get("name", "").strip().lower() == scientific_name.strip().lower()
            ):
                tid = t.get("id")
                if tid and tid not in candidate_taxon_ids:
                    candidate_taxon_ids.append(tid)
                if all(x.get("id") != tid for x in taxon_objs):
                    taxon_objs.append(t)

    # Tier 1: Curated taxon_photos on verified Fungi species taxon objects
    for tobj in taxon_objs:
        tid = tobj.get("id", verified_taxon_id)
        for tp in tobj.get("taxon_photos", []):
            photo = tp.get("photo") or {}
            pid = str(photo.get("id") or "")
            lic = (photo.get("license_code") or "").lower()
            if not pid or pid in BLACKLISTED_PHOTO_IDS or pid in seen_photo_ids:
                continue
            if lic in ALLOWED_LICENSES:
                norm_lic = "cc0" if lic == "pd" else lic
                url = photo.get("medium_url") or photo.get("url") or ""
                if url:
                    large_url = url.replace("/square.", "/large.").replace("/medium.", "/large.")
                    raw_attr = photo.get("attribution") or "iNaturalist Community"
                    if "uploaded by " in raw_attr.lower() and raw_attr.lower().startswith("no rights reserved"):
                        author = raw_attr.split("uploaded by ")[-1].strip()
                    else:
                        author = raw_attr.split(",")[0].replace("(c)", "").strip()
                    candidates.append({
                        "photo_id": photo.get("id"),
                        "license_code": norm_lic,
                        "attribution": raw_attr,
                        "author": author,
                        "source_url": f"https://www.inaturalist.org/taxa/{tid}",
                        "download_url": large_url,
                        "fallback_url": url.replace("/square.", "/medium."),
                        "tier": "inat_taxon_photo",
                    })

    # Tier 2: Top-voted research-grade observations for the verified taxon IDs
    for tid in candidate_taxon_ids:
        for order_param in ("&order_by=votes", ""):
            obs_url = (
                f"https://api.inaturalist.org/v1/observations?taxon_id={tid}"
                f"&quality_grade=research&photos=true&photo_license=cc0,cc-by,cc-by-sa"
                f"{order_param}&per_page=30"
            )
            obs_data = http_get_json(obs_url)
            if not obs_data or not obs_data.get("results"):
                continue

            for obs in obs_data["results"]:
                obs_taxon = obs.get("taxon") or {}
                if not is_fungi_taxon(obs_taxon):
                    continue
                obs_id = obs.get("id")
                user = obs.get("user") or {}
                user_name = user.get("name") or user.get("login") or "iNaturalist Community"

                for photo in obs.get("photos", []):
                    pid = str(photo.get("id") or "")
                    lic = (photo.get("license_code") or "").lower()
                    if not pid or pid in BLACKLISTED_PHOTO_IDS or pid in seen_photo_ids:
                        continue
                    if lic in ALLOWED_LICENSES:
                        raw_url = photo.get("url") or ""
                        if raw_url:
                            large_url = raw_url.replace("/square.", "/large.")
                            candidates.append({
                                "photo_id": photo.get("id"),
                                "license_code": lic,
                                "attribution": photo.get("attribution") or f"(c) {user_name}, {lic.upper()}",
                                "author": user_name,
                                "source_url": f"https://www.inaturalist.org/observations/{obs_id}",
                                "download_url": large_url,
                                "fallback_url": raw_url.replace("/square.", "/medium."),
                                "tier": "inat_obs_votes" if order_param else "inat_obs_recent",
                            })
            if len(candidates) >= 8:
                break

    return candidates


def extract_candidates_wikimedia(
    scientific_name: str,
    seen_photo_ids: set[str],
) -> list[dict]:
    """Fallback search on Wikimedia Commons API filtering out illustrations, microscopy, and maps."""
    candidates: list[dict] = []
    query_url = (
        f"https://commons.wikimedia.org/w/api.php?action=query&format=json"
        f"&generator=search&gsrsearch={urllib.parse.quote(f'filetype:bitmap \"{scientific_name}\"')}"
        f"&gsrnamespace=6&gsrlimit=15&prop=imageinfo&iiprop=url|extmetadata"
    )
    data = http_get_json(query_url)
    if not data or "query" not in data or "pages" not in data["query"]:
        return candidates

    pages = data["query"]["pages"]
    for page_id, page in pages.items():
        pid = str(page_id)
        if pid in BLACKLISTED_PHOTO_IDS or pid in seen_photo_ids:
            continue

        title = page.get("title", "")
        title_lower = title.lower()
        if not any(title_lower.endswith(ext) for ext in (".jpg", ".jpeg", ".png")):
            continue
        if any(bad in title_lower for bad in WIKIMEDIA_REJECT_KEYWORDS):
            continue

        imageinfo = page.get("imageinfo", [])
        if not imageinfo:
            continue

        info = imageinfo[0]
        meta = info.get("extmetadata", {})
        desc_raw = meta.get("ImageDescription", {}).get("value", "")
        artist_raw = meta.get("Artist", {}).get("value", "Wikimedia Commons")
        categories_raw = meta.get("Categories", {}).get("value", "")
        combined_meta = f"{title_lower} {desc_raw.lower()} {artist_raw.lower()} {categories_raw.lower()}"
        if any(bad in combined_meta for bad in WIKIMEDIA_REJECT_KEYWORDS):
            continue

        license_short = meta.get("LicenseShortName", {}).get("value", "").lower()
        artist = re.sub(r"<[^>]+>", "", artist_raw).strip() or "Wikimedia Commons"

        if "cc0" in license_short or "public domain" in license_short or "pd-" in license_short:
            license_code = "cc0"
        elif "cc-by-sa" in license_short or "cc by-sa" in license_short:
            license_code = "cc-by-sa"
        elif "cc-by" in license_short or "cc by" in license_short:
            license_code = "cc-by"
        else:
            continue

        url = info.get("url")
        if url:
            candidates.append({
                "photo_id": int(page_id) if str(page_id).isdigit() else page_id,
                "license_code": license_code,
                "attribution": f"(c) {artist}, {license_short.upper()}",
                "author": artist,
                "source_url": info.get("descriptionurl") or f"https://commons.wikimedia.org/wiki/{urllib.parse.quote(title)}",
                "download_url": url,
                "fallback_url": url,
                "tier": "wikimedia",
            })

    return candidates


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    if not CSV_PATH.exists():
        print(f"Error: species CSV not found at {CSV_PATH}")
        sys.exit(1)

    species_list = []
    with open(CSV_PATH, "r", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            species_list.append(row)

    print("🌿 Boscdex Botanical Reference Photo Fetcher (v3 - Verified Kingdom Fungi + Curated Taxon Photos)")
    print(f"   Target catalog: {len(species_list)} species")
    print(f"   Force-refreshing: {len(FORCE_REFRESH_SPECIES)} species")
    print(f"   Destination: {OUTPUT_DIR}\n")

    # Load existing attributions
    attributions = {}
    if ATTRIBUTIONS_JSON.exists():
        try:
            with open(ATTRIBUTIONS_JSON, "r", encoding="utf-8") as f:
                loaded = json.load(f)
                if isinstance(loaded, list):
                    for item in loaded:
                        attributions[item["species_id"]] = item
                elif isinstance(loaded, dict):
                    attributions = loaded
        except Exception:
            pass

    # Purge force-refreshed species files and attributions first
    for sp_id in FORCE_REFRESH_SPECIES:
        p = OUTPUT_DIR / f"{sp_id}.jpg"
        if p.exists():
            p.unlink()
        attributions.pop(sp_id, None)

    # Track seen photo IDs and MD5 hashes across kept species to guarantee zero duplicates
    seen_photo_ids: set[str] = set()
    seen_md5_hashes: set[str] = set()

    for sp in species_list:
        sp_id = sp["species_id"]
        target_path = OUTPUT_DIR / f"{sp_id}.jpg"
        if target_path.exists() and sp_id in attributions and target_path.stat().st_size > 5000:
            pid = str(attributions[sp_id].get("photo_id") or "")
            md5 = file_md5(target_path)
            if pid in seen_photo_ids or md5 in seen_md5_hashes:
                print(f"   [!] Duplicate detected on kept species {sp_id}, scheduling re-fetch")
                target_path.unlink()
                attributions.pop(sp_id, None)
            else:
                seen_photo_ids.add(pid)
                seen_md5_hashes.add(md5)

    success_count = 0

    for idx, sp in enumerate(species_list, 1):
        sp_id = sp["species_id"]
        sci_name = sp["scientific_name"]
        cat_name = sp["catalan_name"]
        taxon_id = int(sp["inat_taxon_id"])
        target_path = OUTPUT_DIR / f"{sp_id}.jpg"

        print(f"[{idx}/{len(species_list)}] {cat_name} ({sci_name}, taxon_id={taxon_id})")

        # Skip if already downloaded and verified
        if target_path.exists() and sp_id in attributions and target_path.stat().st_size > 5000:
            lic = attributions[sp_id]["license_code"].upper()
            size_kb = target_path.stat().st_size // 1024
            print(f"   ✓ Verified kept photo ({size_kb} KB, {lic})")
            success_count += 1
            continue

        # Gather candidates from iNaturalist (Tier 1 & 2) + Wikimedia Commons (Tier 3)
        candidates = extract_candidates_inaturalist(sci_name, taxon_id, seen_photo_ids)
        if not candidates:
            print("   ℹ️ No iNaturalist candidates, trying Wikimedia Commons...")
            candidates = extract_candidates_wikimedia(sci_name, seen_photo_ids)

        downloaded_info = None
        for cand in candidates:
            pid_str = str(cand["photo_id"])
            if pid_str in seen_photo_ids or pid_str in BLACKLISTED_PHOTO_IDS:
                continue

            print(
                f"   ↓ Trying [{cand['tier']}] #{pid_str} ({cand['license_code'].upper()} by {cand['author'][:28]})..."
            )
            ok = download_and_optimize(cand["download_url"], target_path)
            if not ok and cand.get("fallback_url") and cand["fallback_url"] != cand["download_url"]:
                ok = download_and_optimize(cand["fallback_url"], target_path)

            if ok:
                md5 = file_md5(target_path)
                if md5 in seen_md5_hashes:
                    print(f"   [!] MD5 collision detected for #{pid_str}, skipping...")
                    target_path.unlink()
                    continue
                seen_photo_ids.add(pid_str)
                seen_md5_hashes.add(md5)
                downloaded_info = cand
                break

        # If iNaturalist candidates failed to download, try Wikimedia fallback
        if not downloaded_info:
            wm_candidates = extract_candidates_wikimedia(sci_name, seen_photo_ids)
            for cand in wm_candidates:
                pid_str = str(cand["photo_id"])
                if pid_str in seen_photo_ids or pid_str in BLACKLISTED_PHOTO_IDS:
                    continue
                print(
                    f"   ↓ Trying [wikimedia] #{pid_str} ({cand['license_code'].upper()} by {cand['author'][:28]})..."
                )
                if download_and_optimize(cand["download_url"], target_path):
                    md5 = file_md5(target_path)
                    if md5 in seen_md5_hashes:
                        target_path.unlink()
                        continue
                    seen_photo_ids.add(pid_str)
                    seen_md5_hashes.add(md5)
                    downloaded_info = cand
                    break

        if downloaded_info:
            size_kb = target_path.stat().st_size // 1024
            print(f"   ✅ Saved {sp_id}.jpg ({size_kb} KB, source={downloaded_info['tier']})")
            attributions[sp_id] = {
                "species_id": sp_id,
                "scientific_name": sci_name,
                "catalan_name": cat_name,
                "photo_id": downloaded_info["photo_id"],
                "author": downloaded_info["author"],
                "license_code": downloaded_info["license_code"],
                "license_name": {
                    "cc0": "CC0 1.0 (Public Domain)",
                    "cc-by": "CC BY 4.0",
                    "cc-by-sa": "CC BY-SA 4.0",
                }.get(downloaded_info["license_code"], downloaded_info["license_code"].upper()),
                "attribution_text": downloaded_info["attribution"],
                "source_url": downloaded_info["source_url"],
                "asset_path": f"assets/images/reference/{sp_id}.jpg",
            }
            success_count += 1
        else:
            print(f"   ❌ Failed to acquire open-licensed photo for {sp_id}")

        # Save ordered attributions JSON progressively
        ordered_list = [attributions[s["species_id"]] for s in species_list if s["species_id"] in attributions]
        with open(ATTRIBUTIONS_JSON, "w", encoding="utf-8") as f:
            json.dump(ordered_list, f, indent=2, ensure_ascii=False)

        time.sleep(0.4)

    # Write Markdown Attribution document
    print("\n📝 Generating ATTRIBUTIONS.md...")
    with open(ATTRIBUTIONS_MD, "w", encoding="utf-8") as f:
        f.write("# Botanical Reference Photo Attributions\n\n")
        f.write("All botanical reference photographs included in **Boscdex** are published under open Creative Commons licenses compatible with free open-source redistribution:\n")
        f.write("- **CC0 1.0** (Public Domain Dedication)\n")
        f.write("- **CC BY 4.0** (Creative Commons Attribution)\n")
        f.write("- **CC BY-SA 4.0** (Creative Commons Attribution-ShareAlike)\n\n")
        f.write("We deeply thank the naturalists, mycologists, and photographers of the [iNaturalist](https://www.inaturalist.org) and [Wikimedia Commons](https://commons.wikimedia.org) communities who generously share their high-quality observations.\n\n")
        f.write("| # | Species | Catalan Name | Photographer | License | Source |\n")
        f.write("|---|---|---|---|---|---|\n")

        for idx, sp in enumerate(species_list, 1):
            sp_id = sp["species_id"]
            if sp_id in attributions:
                attr = attributions[sp_id]
                author = attr["author"].replace("|", "\\|")
                lic = attr["license_name"]
                url = attr["source_url"]
                f.write(f"| {idx} | *{attr['scientific_name']}* | {attr['catalan_name']} | {author} | {lic} | [Photo #{attr['photo_id']}]({url}) |\n")
            else:
                f.write(f"| {idx} | *{sp['scientific_name']}* | {sp['catalan_name']} | *Pending* | - | - |\n")

    print(f"\n🎉 Finished! Successfully acquired {success_count}/{len(species_list)} botanical reference photos.")
    print(f"   Attributions saved to:\n     {ATTRIBUTIONS_JSON}\n     {ATTRIBUTIONS_MD}")


if __name__ == "__main__":
    main()
