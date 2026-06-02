#!/usr/bin/env bash
# double-click to set up Claude Code for this team.
# (if macOS says "unidentified developer": right-click → Open → Open.)
cd "$(dirname "$0")" || exit 1
xattr -dr com.apple.quarantine . 2>/dev/null || true
clear
exec bash ./install.sh
