# claude-team-kit - spec

## goal
Generalize a one-off personal setup kit into a **reusable team onboarding template**: any engineering team edits one config and ships it; any dev runs one command and is fully set up in minutes.

## design principle: two layers
- **Team layer** (`team.config`, edited once): company, stack, standards, MCP/plugin/brain toggles, model/theme.
- **Person layer** (asked at install): name, role, GitHub handle → rendered into that dev's `~/.claude/CLAUDE.md`.

Templating: `{{PLACEHOLDER}}` tokens in `templates/CLAUDE.md.template`, filled by `install.sh` (python regex sub from env). Missing field → placeholder left visible + flagged by BOOTSTRAP.

## decisions (from ohm)
- **Auth:** each dev's own Claude subscription → installer handles **no API keys**; first `claude` run triggers browser login. Simplest, safest, no leak surface.
- **Scope:** configurable template **pre-filled with engineering defaults** (the agentic playbook) → works out of the box, still editable.
- **Brain:** **per-dev local** gbrain (PGLite) - private, no shared infra.
- **Delivery:** **both** - private GitHub repo (clone + `install.sh`) and `make-zip.sh` (zip → double-click `START HERE`).

## what's included by default
- MCPs ON: context7 (docs), playwright (QA), gitmcp. OFF (toggle): figma, notion, automator.
- Plugins ON: superpowers, frontend-design, github.
- Skill: `team-engineering` (scale-adaptive plan/build/review, leverage ladder, specs-as-code, verification).
- Per-dev local brain seeded with the rendered team context.

## what's intentionally NOT here
- No API keys / secrets anywhere (own-subscription model).
- No company-specific hardcoding (all via team.config).
- No personal/art skills from the source kit (this is an eng kit).

## success test
Fresh Mac + repo: edit `team.config`, `bash install.sh`, answer 3 prompts → within ~5 min the dev has Claude Code logged in, team standards + playbook loaded, tools wired, a working local brain, and a 60-second tour. Re-running is safe. Same kit works for a different company by editing only `team.config`.
