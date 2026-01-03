---
name: gco-seer
description: "DEPRECATED - Do not use. See .haunt/deprecated/gco-seer.md for history."
---

# ⚠️ DEPRECATED: gco-seer Agent

**Deprecated as of REQ-325 (2026-01-05)**

This agent was built on an incorrect assumption about Claude Code's `--agent` flag.

## The Problem

The `tools:` field in agent YAML is **documentation only** - it does NOT grant tool access.
When running `claude --agent gco-seer`, the agent does NOT get the Task tool.

## The Solution

Use the `haunt` shell alias instead:

```bash
# Add to your ~/.bashrc or ~/.zshrc:
alias haunt='claude --dangerously-skip-permissions'

# Then use:
haunt
/seance "your idea"
```

This runs the main Claude Code session (which HAS Task tool) and loads the
gco-orchestrator skill via the `/seance` command.

## Why This Works

| Approach | Task Tool | Agent Spawning |
|----------|-----------|----------------|
| `claude --agent gco-seer` | ❌ No | ❌ Broken |
| `haunt` → `/seance` | ✅ Yes | ✅ Works |

The main Claude Code session has access to ALL tools including Task.
The `/seance` command loads the orchestration workflow as a skill.

## Full History

See `.haunt/deprecated/gco-seer.md` for the original agent content and detailed explanation.
