#!/usr/bin/env bash
# builds an airdrop/download zip of the kit on your Desktop.
# usage:  bash scripts/make-zip.sh
set -uo pipefail
KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STAGE="$(mktemp -d)/claude-team-kit"
OUT="$HOME/Desktop/claude-team-kit.zip"

mkdir -p "$STAGE"
rsync -a --exclude='.git' --exclude='.DS_Store' --exclude='node_modules' "$KIT/" "$STAGE/"
chmod +x "$STAGE/install.sh" "$STAGE/START HERE.command" "$STAGE/brain/setup-brain.sh" "$STAGE/scripts/make-zip.sh" 2>/dev/null

rm -f "$OUT"
( cd "$(dirname "$STAGE")" && zip -qr "$OUT" "claude-team-kit" )
rm -rf "$(dirname "$STAGE")"

echo "✓ built: $OUT  ($(du -h "$OUT" | cut -f1))"
echo "  edit team.config first, then share this zip → devs unzip → double-click 'START HERE'."
