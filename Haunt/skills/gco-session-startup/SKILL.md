---
name: gco-session-startup
description: Advanced session initialization guidance for complex scenarios. For basic startup protocol, see `.claude/rules/gco-session-startup.md`.
---

# Session Startup Skill

## Purpose

Advanced session initialization guidance for edge cases and complex scenarios.

**For standard startup protocol**, see `.claude/rules/gco-session-startup.md` (enforced automatically).

## When to Invoke

- Resuming work after extended context loss or session interruption
- Dealing with complex multi-session feature work
- Troubleshooting startup issues or broken test states
- Initialization appears unclear or ambiguous

## Context Management (SDK Integration)

### Automatic (SDK Handles)
- Context compaction (triggered approaching token limits)
- CLAUDE.md caching (60-minute TTL)
- Session continuity (summarization across context boundaries)

### Manual (You Handle)
- Assignment verification (Active Work or roadmap)
- Test validation (verify tests pass before starting)
- Agent memory usage (`recall_context()` for multi-session features)
- Broken state recovery (fix failing tests immediately)

## Quick Resolution Guide

### Tests Failing on Startup
1. Identify failing test(s): `pytest tests/ -v`
2. Review recent commits: `git diff HEAD~3..HEAD`
3. Fix tests BEFORE starting assigned work (non-negotiable)
4. Verify fix with full suite run

### No Clear Assignment
1. Verify checked ALL sources (Direct → Active Work → Roadmap)
2. If truly no assignment: STOP and ask PM explicitly
3. Include context: "Checked Active Work and roadmap, no assignments for [agent-type]"

### Multiple Potential Assignments
1. Check `Blocked by:` field - skip blocked items
2. Prefer items at top of current focus section
3. Check effort estimate - prefer S over M
4. If ambiguous: Ask PM which to prioritize

### Resuming Mid-Feature Work
1. Find feature in roadmap (should be 🟡 In Progress)
2. Verify branch matches assignment (see Branch Mismatch below)
3. Review unchecked tasks
4. Check `git diff` for uncommitted WIP
5. Check for story file (`.haunt/plans/stories/REQ-XXX-story.md`)
6. Use `recall_context("[agent-id]-[req-id]")` if complex
7. Continue from first unchecked task

### Branch Mismatch Scenarios
**On wrong feature branch:**
1. Identify current branch: `bash Haunt/scripts/haunt-git.sh branch-current`
2. Find correct branch: `bash Haunt/scripts/haunt-git.sh branch-for-req REQ-XXX`
3. If correct branch exists → Prompt to checkout
4. If no correct branch → Prompt to create or continue on main
5. Wait for user decision before proceeding

**On main but feature branch exists:**
1. Detect via `branch-for-req` command
2. Inform user: "Found branch feature/REQ-XXX-{slug} for this work"
3. Ask: "Checkout feature branch? [yes/no]"
4. If yes → `git checkout feature/REQ-XXX-{slug}`
5. If no → Continue on main (user may have reason)

**On feature branch for different requirement:**
1. Extract REQ from current branch name
2. Compare with assigned REQ-XXX
3. Inform user: "Currently on {current-branch} but assigned {REQ-XXX}"
4. Check if correct branch exists
5. Offer to switch or ask user preference

## Consultation Gates

⛔ **CONSULTATION GATE:** For detailed scenarios (sharded roadmaps, story file loading, Explore workflows, agent memory patterns, lessons-learned integration), READ `references/advanced-scenarios.md`.

## Reference Index

| When You Need | Read This |
|---------------|-----------|
| **Sharded roadmap loading** (batch files, token savings) | `references/advanced-scenarios.md` |
| **Story file workflows** (when to load, what to look for) | `references/advanced-scenarios.md` |
| **Explore reconnaissance** (decision gates, vs gco-research) | `references/advanced-scenarios.md` |
| **Agent memory patterns** (when to recall, when to skip) | `references/advanced-scenarios.md` |
| **Lessons-learned integration** (when to check, what to look for) | `references/advanced-scenarios.md` |

## Success Criteria

Advanced startup complete when:
- Edge case handled (broken tests fixed, ambiguous assignment resolved)
- Context restored for complex multi-session work (if applicable)
- Ready to proceed with clear assignment and stable foundation
