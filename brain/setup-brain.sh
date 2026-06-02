#!/usr/bin/env bash
# per-dev local brain (gbrain) - private, on this machine, no shared infra.
set -uo pipefail
export PATH="$HOME/.bun/bin:$PATH"
ok()   { printf "  \033[1;32m✓\033[0m %s\n" "$1"; }
warn() { printf "  \033[1;33m!\033[0m %s\n" "$1"; }

if ! command -v gbrain >/dev/null 2>&1; then
  bun install -g gbrain >/dev/null 2>&1 || npm install -g gbrain >/dev/null 2>&1 || {
    warn "couldn't auto-install gbrain - bootstrap will retry"; exit 0; }
fi
ok "brain engine ($(gbrain --version 2>/dev/null | head -1))"

if [ ! -d "$HOME/.config/gbrain/brain.pglite" ]; then
  gbrain init --pglite >/dev/null 2>&1 && ok "local brain created" \
    || warn "brain init needs the bootstrap step (likely an embeddings key) - that's fine"
else
  ok "brain already exists"
fi

claude mcp add --transport stdio gbrain -- "$HOME/.bun/bin/gbrain" serve >/dev/null 2>&1 \
  && ok "brain connected to claude" || warn "brain connection exists/skipped"

# seed with this dev's rendered identity so it's never empty
[ -f "$HOME/.claude/CLAUDE.md" ] && gbrain put "team-context" < "$HOME/.claude/CLAUDE.md" >/dev/null 2>&1 \
  && ok "brain seeded with team context" || true
