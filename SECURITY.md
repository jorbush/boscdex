# Security & Botanical Safety Policy 🍄🛡️

## Supported Versions

We release patches and security/botanical safety updates for the current active release.

| Version | Supported          |
| ------- | ------------------ |
| 1.4.x   | :white_check_mark: |
| 1.3.x   | :x:                |
| < 1.3   | :x:                |

---

## 1. Reporting a Software Security Vulnerability

If you discover a software vulnerability in Boscdex (such as arbitrary code execution, SQL injection in local queries, or improper permission handling):

1. **Do not disclose publicly** in an open GitHub issue.
2. Please submit a private vulnerability report via **GitHub Security Advisories** on the repository, or contact the project maintainers directly via email.
3. Include clear reproduction steps and impact assessment.
4. We will acknowledge receipt within 48 hours and work towards a swift remediation and release.

---

## 2. Reporting a Critical Botanical Safety or Toxicity Issue ⚠️

Because Boscdex deals with wild mushrooms, including **lethal and severely toxic species**, accurate botanical data is a matter of life safety.

If you identify:
- A botanical misclassification in seed data or morphology keys,
- A missing or inaccurate dangerous lookalike alert (`ToxicTwinAlert`),
- An erroneous edibility tag or missing culinary toxicity warning (e.g. species toxic raw requiring prolonged boiling),
- An edge-case failure in `SafetyGateService` where a lethal taxon does not trigger immediate red alerts:

**Please report this immediately** as a High Priority Issue on GitHub tagged with `[BOTANICAL SAFETY]` or via a private advisory. Critical botanical errors will be prioritized for immediate hotfix deployment.

---

## 3. Privacy & Offline Architecture Guarantee

Boscdex is designed with a strict zero-cloud architecture:
- All computer vision machine learning runs **100% on-device** via embedded TensorFlow Lite / LiteRT models.
- All database operations are purely local in SQLite (`Drift`).
- GPS coordinates and field notes **never** leave your device.
- No third-party analytics or behavioral tracking SDKs are incorporated.
