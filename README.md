# Capture Verification

**Professional export verification for Capture One digital techs.**

Capture Verification ensures every RAW capture has a matching export, every backup drive is complete, and every file naming issue is caught — before you leave set.

[![macOS](https://img.shields.io/badge/macOS-14.0%2B-black?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![License](https://img.shields.io/badge/License-Preview-blue?style=flat-square)]()

---

## Download

**[⬇ Download Capture Verification (DMG)](https://github.com/djbetterly/CaptureVerification/releases/latest)**

> Requires macOS 14.0 (Sonoma) or later. Universal binary — runs natively on Apple Silicon and Intel.

---

## What It Does

Capture Verification solves a critical problem in professional photography workflows: **confirming that every capture was exported and backed up correctly.** On a busy shoot with thousands of files across multiple folders, manually checking is error-prone and time-consuming. This app automates the entire process in seconds.

### The Workflow

1. **Shoot** — Capture images in Capture One
2. **Export** — Process and export to Output folder
3. **Verify** — Drop the session folder into Capture Verification
4. **Confirm** — Get an instant pass/fail with a professional PDF report

---

## Features

### Export Verification

Compares every RAW file in your Capture folders against every export in your Output folders, matching by filename regardless of extension.

- Supports all major RAW formats: **ARW, CR3, NEF, RAF, DNG, EIP, IIQ, ORF, RW2, PEF, RAW**
- Supports output formats: **JPG, JPEG, TIFF, TIF, PSD, PNG**
- Handles sessions with multiple capture folders and subfolders
- Fuzzy name matching between capture and output directories (handles underscores, hyphens, spaces)
- Reports missing exports, extra files, and count mismatches per folder
- Tracks file sizes per folder and for the entire session

### Backup Drive Verification

Verify your session data against one or more backup drives simultaneously.

- File-level comparison of every file in the master session against each backup
- Match percentage per drive (e.g., 99.8% matched)
- Lists every missing and extra file with full relative paths
- Backup mismatches cause overall verification to **fail** — no silent data loss

### Naming Anomaly Detection

Catches file naming issues that indicate duplicates, re-processes, or workflow problems.

- **Duplicate suffixes** — Flags `Look_01_0004_1.eip` (tacked-on `_1`, `_2` suffixes)
- **Copy suffixes** — Catches `_copy`, `_dup`, `_v2`, `_backup`, `(1)` patterns
- **Pattern breaks** — Identifies files that don't match the dominant naming convention in a folder
- **Spaces in filenames** — Flags names with spaces that can cause issues in some workflows
- Warnings only — naming issues don't affect pass/fail, but are clearly surfaced in the app and PDF report

### PDF Reports

Professional, branded reports auto-saved to the session's Shoot Report folder.

- **Letterhead** — Company logo and contact info at the top of every report
- **SHOOT REPORT** header with large **PASS/FAIL** status badge
- **Production Details** — Digital Tech, Email, Photographer, Client, Notes
- **Key Metrics** — Captures, exports, match percentage, folder counts, total data size, naming warnings
- **Folder Inventory** — Every folder with capture counts and file types
- **Detailed Results** — Per-folder breakdown with types (DNG, JPG), sizes, paths, missing files, and naming warnings
- **Backup Verification** — Drive status, match percentage, missing/extra file lists
- Auto-saved as `SessionName_ShootReport_timestamp.pdf`

### Summary-Only Reports

For when you just need the numbers without pass/fail judgment.

- Toggle **"Generate summary-only report"** on the welcome screen before verification
- Same letterhead and production details, but **no pass/fail badge**, no missing file lists, no warnings
- Clean folder inventory with counts, types, and sizes
- Backup drive summary without match/mismatch status
- Also available as **"Export Summary"** button on the results screen after any verification
- Auto-saved as `SessionName_Summary_timestamp.pdf`

### Verification Archive

Every verification is saved as an XML archive so reports can be regenerated at any time — even if the original shoot folder has been moved, renamed, or deleted.

- Archives stored in `~/Library/Application Support/CaptureVerification/archives/`
- Contains all folder results, file counts, sizes, types, naming anomalies, metadata, and backup data
- **Re-Export Report** button in session history regenerates a full PDF from the archive
- Archives are automatically cleaned up when history entries are deleted

### Session History

Searchable sidebar with every past verification.

- Pass/fail status, folder count, capture count, output count
- **Re-verify** — Re-run verification on any previous session
- **Open Report** — Open the original PDF directly
- **Re-Export Report** — Regenerate from archive if the original report file is gone
- Stores up to 100 sessions, persists across app restarts

### Company Settings

Brand your reports with your company identity.

- Company name, logo, tech name, email, phone, website
- Logo appears in the PDF letterhead alongside contact info
- Tech Name and Email auto-populate the report metadata form
- Accessible from **Settings** (⌘,)

### Quarantine System

Automatically detects output files (JPGs, TIFFs) that were accidentally saved inside Capture folders and moves them to a quarantine directory, preventing false verification results.

---

## Session Folder Structure

Capture Verification works with standard Capture One session layouts:

```
Session_Name/
├── Capture/              ← RAW files organized in subfolders
│   ├── Look_01/
│   │   ├── Look_01_0001.arw
│   │   ├── Look_01_0002.arw
│   │   └── ...
│   └── Look_02/
├── Output/               ← Exported files in matching subfolders
│   ├── Look_01/
│   │   ├── Look_01_0001.jpg
│   │   ├── Look_01_0002.jpg
│   │   └── ...
│   └── Look_02/
└── Shoot Report/         ← Created automatically
    └── reports/
        └── SessionName_ShootReport_20260304_143012.pdf
```

The app also recognizes alternate folder names: **RAW**, **Captures**, **Export**, **Exports**, **Processed**.

---

## How to Use

### Basic Verification

1. Launch Capture Verification
2. Click **Select Session Folder** or drag a session folder onto the window
3. Optionally check **"Add Tech, Photographer & Client info to report"** and fill in details
4. Optionally check **"Generate summary-only report"** for a report without pass/fail
5. Click through the backup drive selection (skip if no backups to verify)
6. View results — the PDF report is auto-saved to `Shoot Report/reports/`

### With Backup Verification

1. Connect your backup drive(s)
2. Select your session folder
3. On the backup selection screen, add your backup drives
4. The app compares every file in your master Capture folder against each backup
5. Results show match percentage and any missing/extra files per drive

### Re-Exporting Reports

1. Find the session in the **History** sidebar
2. Click **Open Report** to view the existing PDF
3. If the original report is gone, click **Re-Export Report** to regenerate it from the saved archive
4. Use **Export Summary** on the results screen to generate a summary report at any time

---

## System Requirements

- **macOS 14.0** (Sonoma) or later
- Apple Silicon or Intel Mac
- No additional dependencies

---

## Installation

1. Download the DMG from the [Releases](https://github.com/djbetterly/CaptureVerification/releases) page
2. Open the DMG and drag **Capture Verification** to your Applications folder
3. On first launch, right-click → Open (or go to System Settings → Privacy & Security → Open Anyway)
4. Grant file access permissions when prompted

---

## Version History

### v2.0 — Current Release

- Naming anomaly detection with expandable warnings
- Backup drive verification with file-level comparison
- Summary-only report option (no pass/fail)
- XML archive system for offline report regeneration
- Session history with re-verify and re-export
- Professional PDF reports with letterhead, file types, sizes, and backup details
- Company settings with logo support
- Overall pass/fail now accounts for backup mismatches
- Improved folder detection (name-based matching with content analysis fallback)
- Error handling with user-visible alerts

### v1.0 — Initial Release

- Capture-to-export folder matching
- Basic text report generation
- Session history sidebar

---

## License

Preview build. See [LICENSE](LICENSE) for details.

---

## Feedback

Found a bug or have a feature request? [Open an issue](https://github.com/djbetterly/CaptureVerification/issues).

---

*Built for digital techs who refuse to leave set without proof that every frame is accounted for.*
