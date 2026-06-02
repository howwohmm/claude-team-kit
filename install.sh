#!/usr/bin/env bash
# claude-team-kit - one-command dev onboarding (macOS).
# auth model: each dev's own Claude subscription (no API keys handled here).
# safe to re-run (idempotent).
set -uo pipefail
KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
say()  { printf "\n\033[1;36m›\033[0m %s\n" "$1"; }
ok()   { printf "  \033[1;32m✓\033[0m %s\n" "$1"; }
warn() { printf "  \033[1;33m!\033[0m %s\n" "$1"; }

# ── load team config ──────────────────────────────────────────────
[ -f "$KIT_DIR/team.config" ] || { echo "missing team.config next to install.sh"; exit 1; }
# shellcheck disable=SC1090
source "$KIT_DIR/team.config"

printf "\n  %s · %s - claude setup\n  ──────────────────────────────\n" "${COMPANY_NAME:-team}" "${TEAM_NAME:-}"
printf "  a few minutes and you're fully loaded.\n\n"

# ── 0. toolchain ──────────────────────────────────────────────────
if ! command -v brew >/dev/null 2>&1; then
  say "installing homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
  [ -x /usr/local/bin/brew ]    && eval "$(/usr/local/bin/brew shellenv)"
fi
ok "homebrew"
command -v node >/dev/null 2>&1 || { say "installing node…"; brew install node; }
ok "node ($(node -v 2>/dev/null))"
if [ "${ENABLE_BRAIN:-0}" = "1" ] && ! command -v bun >/dev/null 2>&1; then
  say "installing bun (for the brain)…"; curl -fsSL https://bun.sh/install | bash
fi
export PATH="$HOME/.bun/bin:$PATH"
command -v claude >/dev/null 2>&1 || { say "installing claude code…"; npm install -g @anthropic-ai/claude-code; }
ok "claude code ($(claude --version 2>/dev/null | head -1))"

# ── 1. person layer (who is this dev?) ────────────────────────────
# non-interactive: pre-set DEV_NAME / DEV_ROLE / DEV_GITHUB in env to skip prompts.
say "quick intro so claude knows who it's working with:"
[ -z "${DEV_NAME:-}" ]   && { printf "  your name: ";          read -r DEV_NAME; }
[ -z "${DEV_ROLE:-}" ]   && { printf "  your role (e.g. backend eng): "; read -r DEV_ROLE; }
[ -z "${DEV_GITHUB:-}" ] && { printf "  your github handle: @";  read -r DEV_GITHUB; }
DEV_NAME="${DEV_NAME:-a developer}"; DEV_ROLE="${DEV_ROLE:-engineer}"; DEV_GITHUB="@${DEV_GITHUB:-}"
export COMPANY_NAME TEAM_NAME STACK REPO_HINT STANDARD_1 STANDARD_2 STANDARD_3 DEV_NAME DEV_ROLE DEV_GITHUB

# ── 2. render CLAUDE.md from template ─────────────────────────────
mkdir -p "$CLAUDE_DIR/skills"
[ -f "$CLAUDE_DIR/CLAUDE.md" ] && cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak.$(date +%s)" 2>/dev/null
python3 - "$KIT_DIR/templates/CLAUDE.md.template" "$CLAUDE_DIR/CLAUDE.md" <<'PY'
import os, re, sys
src, dst = sys.argv[1], sys.argv[2]
text = open(src).read()
text = re.sub(r"\{\{(\w+)\}\}", lambda m: os.environ.get(m.group(1), m.group(0)), text)
open(dst, "w").write(text)
PY
ok "identity written for $DEV_NAME ($DEV_ROLE)"

# ── 3. settings ───────────────────────────────────────────────────
cat > "$CLAUDE_DIR/settings.json" <<JSON
{ "theme": "${DEFAULT_THEME:-dark}", "model": "${DEFAULT_MODEL:-claude-opus-4-8}", "includeCoAuthoredBy": false }
JSON
ok "settings (theme + model)"

# ── 4. skills ─────────────────────────────────────────────────────
cp -R "$KIT_DIR/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null && ok "team skills installed"

# ── 5. MCP tools (per team.config toggles) ────────────────────────
say "wiring tools…"
addmcp(){ claude mcp add "$@" >/dev/null 2>&1 && ok "tool: $1" || warn "skip/exists: $1"; }
[ "${MCP_CONTEXT7:-0}" = "1" ]   && addmcp context7   -- npx -y @upstash/context7-mcp@latest
[ "${MCP_PLAYWRIGHT:-0}" = "1" ] && addmcp playwright -- npx @playwright/mcp@latest
[ "${MCP_FIGMA:-0}" = "1" ]      && addmcp figma  --transport http https://mcp.figma.com/mcp
[ "${MCP_NOTION:-0}" = "1" ]     && addmcp notion --transport http https://mcp.notion.com/mcp
[ "${MCP_AUTOMATOR:-0}" = "1" ]  && addmcp automator -- npx -y @steipete/macos-automator-mcp@latest
[ "${MCP_GITMCP:-0}" = "1" ]     && { claude mcp add --transport sse gitmcp https://gitmcp.io/docs >/dev/null 2>&1 && ok "tool: gitmcp" || warn "skip/exists: gitmcp"; }

# ── 6. plugins (per team.config toggles) ──────────────────────────
say "adding plugins…"
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
inst(){ claude plugin install "$1" >/dev/null 2>&1 && ok "plugin: ${1%@*}" || warn "skip/exists: ${1%@*}"; }
[ "${PLUGIN_SUPERPOWERS:-0}" = "1" ] && inst superpowers@claude-plugins-official
[ "${PLUGIN_FRONTEND:-0}" = "1" ]    && inst frontend-design@claude-plugins-official
[ "${PLUGIN_GITHUB:-0}" = "1" ]      && inst github@claude-plugins-official

# ── 7. per-dev local brain (optional) ─────────────────────────────
if [ "${ENABLE_BRAIN:-0}" = "1" ]; then
  say "setting up your local memory…"
  bash "$KIT_DIR/brain/setup-brain.sh" || warn "brain needs a second pass - bootstrap finishes it"
fi

# ── 8. hand off to claude (own-subscription login) ────────────────
say "opening your welcome guide…"
open "$KIT_DIR/guide/start-here.html" 2>/dev/null || true
sleep 1
FIRST_MSG="hi - i'm $DEV_NAME, just onboarded via the team kit. read BOOTSTRAP.md in $KIT_DIR, confirm everything's wired, then give me the 60-second tour."
cat <<DONE

  ──────────────────────────────────────────────
  ✓ installed. starting claude…
  if it's your first time, it'll open a browser to log in
  with YOUR claude account - do that once and you're in.
  ──────────────────────────────────────────────

DONE
sleep 2
cd "$KIT_DIR"
exec claude "$FIRST_MSG"
