---
description: CRITICAL - All Haunt framework changes must update deployable source, not just local environment
globs:
  - "**/*.md"
  - "**/*.sh"
---

# Haunt Framework Change Protocol

## The Rule

**When modifying ANY Haunt framework asset, ALWAYS update the SOURCE in `Haunt/` FIRST, then deploy.**

## Source Directories (Edit These)

| Asset | Source Location | Deploy To |
|-------|-----------------|-----------|
| Agents | `Haunt/agents/` | `~/.claude/agents/` |
| Skills | `Haunt/skills/gco-*/` | `~/.claude/skills/` |
| Rules | `Haunt/rules/` | `~/.claude/rules/` |
| Commands | `Haunt/commands/` | `~/.claude/commands/` |
| Scripts | `Haunt/scripts/` | N/A (run from source) |

## Non-Negotiable

⛔ **NEVER edit `~/.claude/` or `.claude/` directly** → Edit `Haunt/` source, then deploy

⛔ **NEVER deploy GCO assets to project `.claude/`** → Deploy ONLY to global `~/.claude/`

## Remember

The `Haunt/` directory IS the framework. Everything else is just a deployed copy.
