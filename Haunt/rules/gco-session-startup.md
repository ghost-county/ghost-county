# Session Startup Protocol

## 4-Step Assignment Lookup

When starting a session, check IN ORDER:

1. **Direct Assignment** - User explicitly assigned work in message → Proceed immediately
2. **Active Work** - CLAUDE.md lists work for your agent type → Proceed with that work
3. **Roadmap** - Use `bash Haunt/scripts/haunt-roadmap.sh list --agent=YourType` → Update to 🟡, proceed
4. **Ask PM** - No assignment found in 1-3 → STOP and ask "No assignment found. What should I work on?"

## Targeted File Access

Use grep/scripts instead of full file reads:

```bash
# Find assignment (JSON output):
bash Haunt/scripts/haunt-roadmap.sh list --agent=Dev-Backend

# Extract specific requirement:
bash Haunt/scripts/haunt-roadmap.sh get REQ-XXX

# Or direct grep:
grep -A 30 "REQ-XXX" .haunt/plans/roadmap.md
```

**Savings:** 98% token reduction (30 lines vs 1,647 lines)

## When to Invoke Full Skill

For complex scenarios (broken tests, multi-session features, story files, batch loading, Explore reconnaissance):

**Invoke:** `gco-session-startup` skill

## Non-Negotiable

- NEVER skip steps in the 4-step sequence
- NEVER read full roadmap when grep works
- NEVER start work without identifying REQ-XXX
