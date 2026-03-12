# Capture Verification

**Professional export verification for Capture One digital techs.**

Capture Verification ensures every RAW capture has a matching export, every backup drive is complete, and every file naming issue is caught — before you leave set.

[![macOS](https://img.shields.io/badge/macOS-14.0%2B-black?style=flat-square&logo=apple)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9-F05138?style=flat-square&logo=swift&logoColor=white)](https://swift.org)
[![License](https://img.shields.io/badge/License-Preview-blue?style=flat-square)]()

---

## Download

**[⬇ Download Capture Verification (DMG)](https://github.com/djbetterly/CaptureVerification/releases/latest)**

> Requires macOS 14.0 (Sonoma) or later. Universal binary — runs natively on Apple Silicon and Intel. Notarized by Apple.

---

## What It Does

Capture Verification solves a critical problem in professional photography workflows: **confirming that every capture was exported and backed up correctly.** On a busy shoot with thousands of files across multiple folders, manually checking is error-prone and time-consuming. This app automates the entire process in seconds.

### The Workflow

1. **Shoot** — Capture images in Capture One
2. **Export** — Process and export to Output folder
3. **Verify** — Drop the session folder into Capture Verification (or launch directly from Capture One)
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

### Ratings & Color Tags

Reads star ratings and color tags directly from Capture One's `.cos` settings files — no need for Capture One to be running.

- **Star ratings** (1-5) with per-folder and session-wide counts
- **Color tags** — Red, Orange, Yellow, Green, Blue, Pink, Purple with colored indicators
- Session summary in the app's Statistics section
- Full breakdown in the PDF report with star symbols and color-coded tag names
- Included in both full and summary-only reports

### Equipment Tracking

Automatically detects cameras and lenses used in each session from Capture One metadata.

- **Camera models** with masked serial numbers (e.g., "Canon EOS R5 Mark II • S/N: XXXXXXXX1892")
- **Lenses** listed by name (e.g., "RF28-70mm F2 L USM")
- EQUIPMENT section in PDF reports
- Toggleable in Report Customization — show or hide cameras and lenses independently

### Select Thumbnails

Preview images from your selects appear directly in the PDF report beneath each folder's details.

- 3 thumbnail previews from color-tagged selects (default: Green)
- Uses Capture One's cached `.cot` thumbnails — no RAW decoding, zero performance impact
- Aspect-fit rendering with dark letterboxing for portrait images
- Configurable color tag in Report Customization
- Toggle on/off in Report Customization

### Capture One Integration

Launch verification directly from Capture One without switching apps.

- **Scripts menu** — "Launch Capture Verification" auto-installed to Capture One's Scripts folder
- Automatically loads the current open session and starts verification
- Single-window architecture — no duplicate windows
- URL scheme: `captureverification://verify?path=/path/to/session`

### Menu Bar Quick Access

Verify sessions without opening the full app window.

- **Quick Verify...** (⌘⇧V) — Opens a folder picker directly from the menu bar
- **Show Capture Verification** — Bring the main window to front
- **Settings** — Quick access to Report Customization
- App stays active in the menu bar even when the window is closed

### PDF Reports

Professional, branded reports auto-saved to the session's Shoot Report folder.

- **Letterhead** — Company logo and contact info at the top of every report
- **SHOOT REPORT** header with large **PASS/FAIL** status badge
- **Production Details** — Digital Tech, Email, Photographer, Client, Notes
- **Equipment** — Cameras and lenses used with masked serial numbers
- **Key Metrics** — Captures, exports, match percentage, folder counts, total data size, naming warnings
- **Ratings & Color Tags** — Star and color breakdown with colored indicators
- **Select Thumbnails** — 3 preview images from color-tagged selects per folder
- **Folder Inventory** — Every folder with capture counts and file types
- **Detailed Results** — Per-folder breakdown with types (DNG, JPG), sizes, paths, missing files, naming warnings, and ratings
- **Backup Verification** — Drive status, match percentage, missing/extra file lists
- **Footer** — "Report generated by Capture Verification vX.X" with date/time on every page
- Auto-saved as `SessionName_ShootReport_timestamp.pdf`

### Summary-Only Reports

For when you just need the numbers without pass/fail judgment.

- Toggle **"Generate summary-only report"** on the welcome screen before verification
- Same letterhead and production details, but **no pass/fail badge**, no missing file lists, no warnings
- Clean folder inventory with counts, types, sizes, ratings, and thumbnails
- Equipment and backup drive summary without match/mismatch status
- Also available as **"Export Summary"** button on the results screen after any verification
- Auto-saved as `SessionName_Summary_timestamp.pdf`

### Verification Archive

Every verification is saved as an XML archive so reports can be regenerated at any time — even if the original shoot folder has been moved, renamed, or deleted.

- Archives stored in `~/Library/Application Support/CaptureVerification/archives/`
- Contains all folder results, file counts, sizes, types, naming anomalies, ratings, equipment, metadata, and backup data
- **Re-Export Report** button in session history regenerates a full PDF from the archive
- Archives are automatically cleaned up when history entries are deleted

### Session History

Searchable sidebar with every past verification.

- Pass/fail status, folder count, capture count, output count
- **Re-verify** — Re-run verification on any previous session
- **Open Report** — Open the original PDF directly
- **Re-Export Report** — Regenerate from archive if the original report file is gone
- Stores up to 100 sessions, persists across app restarts

### Company Settings & Report Customization

Brand your reports and control what's included.

- Company name, logo, tech name, email, phone, website
- Logo appears in the PDF letterhead alongside contact info
- Toggle cameras, lenses, and select thumbnails on/off in reports
- Configurable color tag for thumbnail selects
- Accessible from **Settings** (⌘,)

### Smart Metadata Entry

The Photographer and Client fields remember previously used values. Tech name and email have independent defaults.

- **Set as Default** button for tech name and email — persists across sessions, independent from Company Settings
- Dropdown suggestions for Photographer and Client from past entries — type to filter or click the arrow to browse
- Remove individual entries from the list
- Up to 20 recent values per field, most recent first
- Values saved automatically after each verification

### In-App Feedback

Submit bug reports, feature requests, and feedback without leaving the app.

- Collects system info automatically (macOS version, Mac model, chip)
- Attach screenshots directly
- Posts to GitHub Issues with auto-assigned labels
- Accessible from the welcome screen

### Auto-Updates

The app checks for updates automatically on launch using Sparkle.

- **Check for Updates** available in the app menu
- Signed updates distributed via GitHub Releases
- No manual downloading required for future versions

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

### From Capture One

1. Open a session in Capture One
2. Go to **Scripts menu → Launch Capture Verification**
3. The app launches with the session pre-loaded
4. Click through backup selection and verify

### From the Menu Bar

1. Click the Capture Verification icon in the menu bar
2. Select **Quick Verify...** (⌘⇧V)
3. Choose a session folder
4. Verification starts automatically

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
3. Grant file access permissions when prompted

---

## Version History

### v2.2 — Current Release

- Select thumbnails in PDF reports — 3 preview images from color-tagged selects per folder
- Configurable thumbnail color tag and toggle in Report Customization
- Capture One script integration — launch verification directly from Capture One's Scripts menu
- Menu bar Quick Verify (⌘⇧V) — folder picker from the menu bar
- Independent tech name/email defaults with "Set as Default" button
- Single-window architecture — no duplicate windows from URL scheme or script launches
- Removed App Sandbox for cleaner Developer ID distribution
- Fixed Sparkle version detection

### v2.1

- Ratings and color tag scanning from Capture One `.cos` files
- Equipment tracking — camera models and lenses with masked serial numbers
- Report Customization toggles for cameras and lenses
- Smart metadata entry with recent value suggestions for Photographer and Client
- PDF report footer with app version and timestamp on every page
- In-app feedback system posting directly to GitHub Issues
- Auto-update support via Sparkle
- App notarized with Apple Developer ID

### v2.0

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

Found a bug or have a feature request? Use the **Send Feedback** button in the app, or [open an issue](https://github.com/djbetterly/CaptureVerification/issues) directly.

---

*Built for digital techs who refuse to leave set without proof that every frame is accounted for.*
