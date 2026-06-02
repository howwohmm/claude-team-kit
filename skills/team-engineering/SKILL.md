---
name: team-engineering
description: The team's engineering playbook - how to scope, plan, build, review, and debug work with Claude. Use when starting any non-trivial task, deciding how much process a task needs, planning a feature, debugging something broken, or reviewing code before merge. Trigger on "how should I approach", "plan this", "is this ready to ship", "why is this broken", "review my diff", or any feature/bug/refactor of real size.
---

# team engineering playbook

The shared way this team works with Claude. Apply the right level - don't over-process small work, don't under-plan big work.

## 1. scale-adaptive plan / build / review
Pick the tier by real size:

| tier | when | flow |
|---|---|---|
| **Quick** | bug fix, refactor, prototype, <2h | straight to code |
| **Standard** | feature, enhancement, 2-8h | short written plan → build → self-review |
| **Full** | new product/subsystem, >8h | Research → Plan → Build → Review |

Research is **mandatory** for Full. Bad research compounds: a 10-minute miss can cost a 10-week refactor. Don't skip it to "save time."

## 2. specs as source code
The plan/design doc is the primary artifact; code is regenerable from it.
- Standard+ work: save the plan to `specs/` or `docs/` before building.
- Change behavior → update the spec first, then the code.
- In review, read the spec against the diff - does the code still match intent?

## 3. the leverage ladder (debugging / improvement)
When something's broken or slow, fix at the **lowest level that addresses the root cause**, not the symptom:

| # | lever | ask |
|---|---|---|
| 12 | context | does the agent know what it needs? is junk bloating the window? |
| 11 | model | right model for the cost/speed/quality trade-off? |
| 10 | prompt | are the instructions concrete and followable? |
| 9 | tools | right tools, right form (MCP vs CLI vs internal)? |
| 8 | observability | can you see what's happening? are logs clear? |
| 7 | types | is typing enforced? are type errors surfaced? |
| 6 | docs | can the agent navigate the docs? are they current? |
| 5 | tests | real tests or theatre? are mocks hiding bugs? |
| 4 | architecture | is the codebase agentically intuitive? |
| 3 | plans | can the agent finish without asking a human? |
| 2 | templates | does the agent know what good output looks like? |
| 1 | workflows | how does work flow between agents? |

Higher number = local patch. Lower = systemic. When the root cause is systemic, fix it there.

## 4. context is code
CLAUDE.md, skills, prompts are source - version them, fix them when wrong, refactor when bloated. "One agent, one purpose, one prompt." Don't drown context in irrelevant history.

## 5. before you say "done"
Run it. Show the output. Tests pass = paste the result. Skipped a step = say so. Evidence before assertions - never claim green you didn't see.

## 6. guardrails
- No secrets/keys/.env in commits, ever.
- Confirm before destructive or outward-facing actions (force-push, delete, deploy, send).
- Small PRs, conventional commits, tests with behavior changes.
