# claude-team-kit

**Get your whole team on Claude Code in an afternoon - without managing a single API key.**

One file you edit once. One command each dev runs. Five minutes later they're working with the same standards, the same tools, and the same playbook as everyone else on the team.

---

## the problem this kills

Right now, every dev sets up Claude their own way. Different tools, different rules, no shared memory of how your team actually works. New hires lose a day fiddling with config. Output quality swings person to person. And the moment someone hardcodes an API key into a dotfile, you've got a secret leak waiting to happen.

Multiply that by every engineer, every onboarding, every laptop. It adds up fast.

## how it works

Two layers, so it's reusable forever - not a one-off.

1. **You set the team layer once.** Open `team.config`, fill in your company, stack, three standards, and flip on the tools you want. Done.
2. **Each dev runs one command.** It installs Claude Code, asks three quick questions (name, role, GitHub), and wires everything to your config.
3. **They log in with their own Claude account.** First run opens a browser, they sign in once, and they're working. You never touch, store, or distribute a key.

That's the whole thing. `git clone` or a double-clicked zip - either path, same result.

## what each dev gets, out of the box

- **Your standards, enforced.** Commit style, PR size, test discipline, no-secrets - loaded into every session, held to automatically.
- **The right process for the task.** Quick fix → straight to code. Feature → plan first. Big build → research, plan, review. No more over-engineering a typo or shipping a subsystem off the cuff.
- **Tools already wired.** Live docs lookup, a browser for QA, GitHub - plus anything else you toggle on.
- **Memory that persists.** A private local brain per dev, so nobody re-explains the codebase twice.
- **The team playbook**, as a skill Claude reaches for when the work gets real.

## why it's safe to roll out

- **No keys, anywhere.** Devs use their own Claude subscription, so the kit stores and ships zero secrets. Nothing to leak.
- **Re-runnable.** Running setup again won't break anything - it backs up an existing config before writing.
- **Nothing hardcoded.** Every company-specific detail lives in `team.config`. The same kit works for the next team by editing one file.

One honest caveat: it's macOS-first (Homebrew + zsh). Linux works with a small tweak to the install step - not a rewrite.

---

## set it up (admin, once)

1. Edit **`team.config`** - company, stack, your three standards, and the MCP / plugin / brain toggles.
2. *(Optional)* Deepen `templates/CLAUDE.md.template` and `skills/team-engineering/SKILL.md` with your real conventions.
3. Ship it:
   - **GitHub:** push to a private repo → devs `git clone` and run `bash install.sh`.
   - **Zip:** run `bash scripts/make-zip.sh` → share `~/Desktop/claude-team-kit.zip` → devs unzip and double-click **START HERE**.

## what a dev does

- **From repo:** `git clone … && cd claude-team-kit && bash install.sh`
- **From zip:** unzip → double-click **START HERE**

Onboarding a whole batch at once? Skip the prompts:

```bash
DEV_NAME="Jane Doe" DEV_ROLE="backend eng" DEV_GITHUB="janedoe" bash install.sh
```

## before you run it - good to know

A few honest heads-ups so nothing surprises you:

- **macOS-first.** The installer assumes Homebrew + zsh. On Linux it works with one tweak (swap the `brew` step for your package manager) - not a rewrite.
- **It installs missing tools for you.** If you don't have them, it runs the *official* installers for Homebrew, Node, bun, and Claude Code (`curl … | bash` / `npm i -g`). That's remote code from those vendors - standard, but know it's happening.
- **Each dev needs their own Claude Pro/Max.** First run opens a browser to log in once. The kit handles **no API keys** - nothing to distribute or leak.
- **Zip path + Gatekeeper:** macOS may flag `START HERE.command` as "unidentified developer." Right-click it → **Open** → **Open**, once. (Cloning from GitHub avoids this.)
- **It writes to `~/.claude/`.** Your existing `~/.claude/CLAUDE.md` is **backed up** (`.bak.<timestamp>`) before it's replaced. Same-named skills in `~/.claude/skills/` get overwritten - rename yours first if that matters.
- **`team.config` runs as a shell script.** Only run a `team.config` you trust (it's sourced during install). Don't paste one from a stranger.
- **The brain (optional)** may ask for an embeddings key on first run; the bootstrap step offers to set it up or skip - it won't block onboarding.

## what's inside

| path | what |
|---|---|
| `team.config` | the one file you edit |
| `install.sh` | idempotent macOS installer (own-subscription auth) |
| `templates/CLAUDE.md.template` | team identity + playbook, `{{placeholder}}`-driven |
| `skills/team-engineering` | the engineering playbook as an on-demand skill |
| `brain/setup-brain.sh` | per-dev private local brain |
| `guide/start-here.html` | the dev's welcome page |
| `BOOTSTRAP.md` | what Claude reads to self-verify + give the 60-second tour |
| `START HERE.command` | double-click installer for the zip path |
| `scripts/make-zip.sh` | builds the shareable zip |

Edit one file. Ship it. Watch the team get consistent.
