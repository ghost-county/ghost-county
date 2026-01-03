# Completion Checklist (Slim Reference)

## Before Marking ANY Requirement 🟢

**Quick Checklist:**
1. All tasks `- [x]` (not `- [ ]`)
2. Completion criteria verified (output "✓ [criterion] - VERIFIED" for each)
3. Tests passing: `bash Haunt/scripts/haunt-run.sh test`
   - Frontend: BOTH `npm test` AND `npx playwright test` pass
   - Backend: `npm test` or `pytest tests/` pass
4. All files in "Files:" section updated
5. Self-assessment: "Would I demo this to my CTO?" → YES with confidence

## Iterative Refinement by Size

| Size | Passes Required |
|------|-----------------|
| XS | 1-pass (Initial implementation) |
| S | 2-pass (Initial → Refinement) |
| M | 3-pass (Initial → Refinement → Enhancement) |

## Code Review Decision

- **XS/S:** Self-validation sufficient → mark 🟢 directly
- **M/SPLIT:** Spawn Code Reviewer → wait for verdict

## When to Invoke Full Skill

For detailed checklists, testing requirements, iterative refinement passes, and professional standards:

**Invoke:** `gco-completion` skill

## Non-Negotiable

- NEVER mark 🟢 with failing tests
- NEVER mark M/SPLIT 🟢 without Code Reviewer approval
- NEVER mark 🟢 if you wouldn't confidently demo it to your CTO
