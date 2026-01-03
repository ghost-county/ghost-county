# Orchestration Protocol (Slim Reference)

## Core Principle

**Orchestrators coordinate workflows. Specialists execute work.**

## Delegation Decision Tree

When user requests work:

1. **Is this orchestration?** (mode detection, prompts, coordination) → Execute directly
2. **Does this produce a deliverable?** (research doc, code, tests, analysis) → Spawn agent
3. **Does this require domain expertise?** (research, implementation, review) → Spawn agent

## When to Spawn (Always Delegate)

| Task Type | Spawn Agent |
|-----------|-------------|
| External research | gco-research |
| Codebase investigation (>10 files) | gco-research |
| Requirements analysis (JTBD, Kano, RICE) | gco-project-manager |
| Implementation (code, tests, config) | gco-dev-* |
| Code review | gco-code-reviewer |

## Tool Prohibitions

⛔ **Edit/Write tools** - NEVER use to modify source code → Spawn gco-dev-*

**Exception:** Roadmap/archival files (`.haunt/plans/`, `.haunt/completed/`)

## When to Invoke Full Skill

For detailed examples, anti-patterns, Explore agent guidance, and comprehensive workflows:

**Invoke:** `gco-orchestrator` skill

## Non-Negotiable

- If task produces deliverable → spawn agent
- If task needs expertise → spawn agent
- Default to spawning when in doubt
