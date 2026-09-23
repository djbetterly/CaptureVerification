#!/bin/bash

# ============================================================
# Capture Verification Release Script
#
# Usage: ./build_release.sh <version> [release_notes_file]
# Example: ./build_release.sh 2.0
#          ./build_release.sh 2.0 notes.md
#
# This script does the ENTIRE release, end to end:
# 1. Staples the notarization ticket to the app
# 2. Builds the DMG with custom background
# 3. Signs the DMG with Sparkle
# 4. Writes appcast.xml (with your release notes)
# 5. Creates the GitHub release and uploads the DMG
# 6. Commits & pushes appcast.xml  (this is what "sets the current build")
#
# Prerequisites:
# - This script lives inside a clone of the CaptureVerification (release) repo
# - Notarized app exported into the ./dist subfolder next to this script
# - create-dmg installed        (brew install create-dmg)
# - GitHub CLI installed & auth'd (brew install gh && gh auth login)
# - Sparkle keys generated
# ============================================================

set -e

# --- CONFIGURATION ---
# Everything lives in ONE folder: the clone of the CaptureVerification (release) repo,
# which is wherever THIS script sits. No hardcoded paths — move the folder anywhere and
# it still works. Export your notarized app into the ./dist subfolder before running.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$SCRIPT_DIR"                 # appcast.xml lives here (this folder is the repo clone)
DIST_DIR="${SCRIPT_DIR}/dist"          # you export the .app here; the DMG is built here too
BACKGROUND="${SCRIPT_DIR}/background.png"
APP_NAME="Capture Verification"
GITHUB_USER="djbetterly"
GITHUB_REPO="CaptureVerification"
REPO_SLUG="${GITHUB_USER}/${GITHUB_REPO}"

mkdir -p "$DIST_DIR"

# Set PUBLISH_RELEASE=0 to create the GitHub release as a draft instead of publishing it.
PUBLISH_RELEASE="${PUBLISH_RELEASE:-1}"

# Sparkle sign_update tool
SPARKLE_SIGN=$(find ~/Library/Developer/Xcode/DerivedData -path "*/sparkle/Sparkle/bin/sign_update" -type f 2>/dev/null | head -1)

# --- VALIDATE ARGS ---
VERSION="$1"
NOTES_ARG="$2"
if [ -z "$VERSION" ]; then
    echo "Usage: ./build_release.sh <version> [release_notes_file]"
    echo "Example: ./build_release.sh 2.0"
    exit 1
fi

# --- VALIDATE TOOLS UP FRONT (fail fast, before we build anything) ---
if ! command -v create-dmg >/dev/null 2>&1; then
    echo "❌ create-dmg not found. Install it:  brew install create-dmg"
    exit 1
fi
if ! command -v gh >/dev/null 2>&1; then
    echo "❌ GitHub CLI (gh) not found. Install it:  brew install gh"
    exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
    echo "❌ GitHub CLI is not authenticated. Run:  gh auth login"
    exit 1
fi

echo ""
echo "🚀 Building Capture Verification v${VERSION}"
echo "================================================"

# --- RESOLVE RELEASE NOTES ---
# Priority: explicit file arg  >  RELEASE_NOTES.md next to the script  >  generated stub
if [ -n "$NOTES_ARG" ] && [ -f "$NOTES_ARG" ]; then
    RELEASE_NOTES_FILE="$NOTES_ARG"
elif [ -f "${SCRIPT_DIR}/RELEASE_NOTES.md" ]; then
    RELEASE_NOTES_FILE="${SCRIPT_DIR}/RELEASE_NOTES.md"
else
    RELEASE_NOTES_FILE="$(mktemp)"
    printf "## Capture Verification v%s\n\nSee commit history for details.\n" "$VERSION" > "$RELEASE_NOTES_FILE"
    echo "ℹ️  No release notes provided — using a generated stub."
    echo "   (Pass a file:  ./build_release.sh ${VERSION} notes.md, or drop a RELEASE_NOTES.md next to this script.)"
fi
NOTES_CONTENT=$(cat "$RELEASE_NOTES_FILE")

# The notes must be for THIS version. RELEASE_NOTES.md is easy to leave untouched from the
# previous release, and the script used to ship it silently: 4.2 and 4.2.1 both went out
# with 4.1's text in the Sparkle dialog and on the GitHub release page. Refuse unless the
# notes mention the version being released (set FORCE_NOTES=1 to override, knowingly).
if ! grep -q -F "$VERSION" "$RELEASE_NOTES_FILE"; then
    if [ "${FORCE_NOTES:-0}" != "1" ]; then
        echo "❌ Release notes in $RELEASE_NOTES_FILE do not mention version $VERSION."
        echo "   First line: $(head -n 1 "$RELEASE_NOTES_FILE")"
        echo "   Update RELEASE_NOTES.md for $VERSION (or pass a notes file), or set FORCE_NOTES=1 to ship them anyway."
        exit 1
    fi
    echo "⚠️  FORCE_NOTES=1: shipping notes that do not mention $VERSION."
fi

# --- FIND THE APP ---
echo ""
echo "📦 Step 1: Finding the app..."

APP_PATH=""
for location in \
    "${DIST_DIR}/${APP_NAME}.app" \
    "${SCRIPT_DIR}/${APP_NAME}.app" \
    "$HOME/Desktop/${APP_NAME}.app" \
    "$HOME/Downloads/${APP_NAME}.app"; do
    # Use find to handle glob
    found=$(find "$(dirname "$location")" -maxdepth 1 -name "${APP_NAME}.app" -type d 2>/dev/null | head -1)
    if [ -n "$found" ]; then
        APP_PATH="$found"
        break
    fi
done

if [ -z "$APP_PATH" ]; then
    echo "❌ Could not find '${APP_NAME}.app'"
    echo "   Export the notarized app from Xcode into:  ${DIST_DIR}"
    echo ""
    echo "   Or drag it here and press Enter:"
    read -r APP_PATH
    APP_PATH=$(echo "$APP_PATH" | sed "s/^ *//;s/ *$//;s/^'//;s/'$//;s/\\\\//g")
    if [ ! -d "$APP_PATH" ]; then
        echo "❌ Not found: $APP_PATH"
        exit 1
    fi
fi

echo "   ✅ Found: $APP_PATH"

# --- READ VERSIONS FROM APP BUNDLE ---
BUNDLE_VERSION=$(defaults read "${APP_PATH}/Contents/Info" CFBundleVersion 2>/dev/null || echo "")
MARKETING_VERSION=$(defaults read "${APP_PATH}/Contents/Info" CFBundleShortVersionString 2>/dev/null || echo "$VERSION")

if [ -z "$BUNDLE_VERSION" ]; then
    echo "⚠️  Could not read CFBundleVersion from app — falling back to VERSION arg"
    BUNDLE_VERSION="$VERSION"
fi

echo "   📦 Marketing version (CFBundleShortVersionString): $MARKETING_VERSION"
echo "   🔢 Build version     (CFBundleVersion):            $BUNDLE_VERSION"
echo "   🏷️  Release version   (argument):                   $VERSION"

if [ "$BUNDLE_VERSION" != "$VERSION" ]; then
    echo ""
    echo "   ⚠️  Note: Bundle version ($BUNDLE_VERSION) differs from release version ($VERSION)"
    echo "      The appcast will use $VERSION — consider updating Xcode to match."
fi

# --- STAPLE NOTARIZATION ---
echo ""
echo "📎 Step 2: Stapling notarization ticket..."

xcrun stapler staple "$APP_PATH"

echo "   ✅ Stapled"

# --- BUILD DMG ---
echo ""
echo "📀 Step 3: Building DMG..."

DMG_NAME="Capture_Verification_Installer-v${VERSION}.dmg"
DMG_PATH="${DIST_DIR}/${DMG_NAME}"

# Remove old DMG if exists
rm -f "$DMG_PATH"

if [ -f "$BACKGROUND" ]; then
    echo "   Using custom background: $BACKGROUND"
    create-dmg \
        --volname "${APP_NAME}" \
        --background "$BACKGROUND" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "${APP_NAME}.app" 165 245 \
        --app-drop-link 435 245 \
        --no-internet-enable \
        "$DMG_PATH" \
        "$APP_PATH" || true
else
    echo "   ⚠️  No background.png found, using default layout"
    create-dmg \
        --volname "${APP_NAME}" \
        --window-pos 200 120 \
        --window-size 600 400 \
        --icon-size 100 \
        --icon "${APP_NAME}.app" 165 245 \
        --app-drop-link 435 245 \
        --no-internet-enable \
        "$DMG_PATH" \
        "$APP_PATH" || true
fi

if [ ! -f "$DMG_PATH" ]; then
    echo "❌ DMG creation failed"
    exit 1
fi

echo "   ✅ DMG created: $DMG_PATH"

# --- SIGN WITH SPARKLE ---
echo ""
echo "🔐 Step 4: Signing DMG with Sparkle..."

if [ -z "$SPARKLE_SIGN" ]; then
    echo "❌ Could not find Sparkle sign_update tool"
    echo "   Build the project in Xcode first to download Sparkle"
    exit 1
fi

SIGN_OUTPUT=$("$SPARKLE_SIGN" "$DMG_PATH")
echo "   $SIGN_OUTPUT"

SIGNATURE=$(echo "$SIGN_OUTPUT" | grep -o 'sparkle:edSignature="[^"]*"' | sed 's/sparkle:edSignature="//;s/"//')
LENGTH=$(echo "$SIGN_OUTPUT" | grep -o 'length="[^"]*"' | sed 's/length="//;s/"//')

if [ -z "$SIGNATURE" ]; then
    echo "❌ Could not parse Sparkle signature"
    exit 1
fi

echo "   ✅ Signature: ${SIGNATURE:0:30}..."
echo "   ✅ Length: $LENGTH"

# --- UPDATE APPCAST ---
echo ""
echo "📝 Step 5: Updating appcast.xml..."

if [ ! -d "$REPO_DIR/.git" ]; then
    echo "❌ This folder is not a git clone of the release repo."
    echo "   The script must live inside a clone of https://github.com/${REPO_SLUG}"
    echo "   One-time setup:  git clone https://github.com/${REPO_SLUG}.git"
    echo "   then move this script (and background.png) into that folder."
    exit 1
fi

PUBDATE=$(date -R)
DMG_URL="https://github.com/${GITHUB_USER}/${GITHUB_REPO}/releases/download/v${VERSION}/${DMG_NAME}"

cat > "$REPO_DIR/appcast.xml" << XMLEOF
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title>Capture Verification Updates</title>
        <link>https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/appcast.xml</link>
        <description>Most recent updates for Capture Verification</description>
        <language>en</language>

        <item>
            <title>Version ${VERSION}</title>
            <sparkle:version>${BUNDLE_VERSION}</sparkle:version>
            <sparkle:shortVersionString>${VERSION}</sparkle:shortVersionString>
            <sparkle:minimumSystemVersion>14.0</sparkle:minimumSystemVersion>
            <description><![CDATA[
${NOTES_CONTENT}
            ]]></description>
            <pubDate>${PUBDATE}</pubDate>
            <enclosure
                url="${DMG_URL}"
                length="${LENGTH}"
                type="application/octet-stream"
                sparkle:edSignature="${SIGNATURE}"
            />
        </item>

    </channel>
</rss>
XMLEOF

echo "   ✅ appcast.xml updated at: $REPO_DIR/appcast.xml"

# --- CREATE GITHUB RELEASE + UPLOAD DMG ---
# Done BEFORE pushing the appcast so the enclosure URL is live the moment the appcast goes public.
echo ""
echo "🐙 Step 6: Creating GitHub release and uploading DMG..."

RELEASE_TITLE="Capture Verification v${VERSION}"
DRAFT_FLAG=""
if [ "$PUBLISH_RELEASE" != "1" ]; then
    DRAFT_FLAG="--draft"
    echo "   (PUBLISH_RELEASE=$PUBLISH_RELEASE — creating as a DRAFT)"
fi

if gh release view "v${VERSION}" --repo "$REPO_SLUG" >/dev/null 2>&1; then
    echo "   ℹ️  Release v${VERSION} already exists — updating notes and re-uploading DMG."
    gh release edit "v${VERSION}" --repo "$REPO_SLUG" \
        --title "$RELEASE_TITLE" --notes-file "$RELEASE_NOTES_FILE"
    gh release upload "v${VERSION}" "$DMG_PATH" --repo "$REPO_SLUG" --clobber
else
    gh release create "v${VERSION}" "$DMG_PATH" --repo "$REPO_SLUG" \
        --title "$RELEASE_TITLE" --notes-file "$RELEASE_NOTES_FILE" $DRAFT_FLAG
fi

echo "   ✅ GitHub release ready: https://github.com/${REPO_SLUG}/releases/tag/v${VERSION}"

# --- COMMIT & PUSH APPCAST (sets the current build) ---
echo ""
echo "📤 Step 7: Committing & pushing appcast.xml..."

(
    cd "$REPO_DIR"
    git add appcast.xml
    if git diff --cached --quiet; then
        echo "   ℹ️  appcast.xml unchanged — nothing to commit."
    else
        git commit -m "Update appcast for v${VERSION}"
        git push
        echo "   ✅ appcast.xml pushed — clients will now see v${VERSION}."
    fi
)

# --- DONE ---
echo ""
echo "================================================"
echo "🎉 Release v${VERSION} complete — fully automated!"
echo ""
echo "   DMG:     $DMG_PATH"
echo "   Release: https://github.com/${REPO_SLUG}/releases/tag/v${VERSION}"
echo "   Appcast: $REPO_DIR/appcast.xml (pushed to main)"
echo "================================================"
