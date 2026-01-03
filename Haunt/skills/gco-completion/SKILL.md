---
name: gco-completion
description: Completion checklist ensuring professional-quality work before marking requirements complete. Invoke before marking any requirement 🟢.
---

# Completion Checklist

Before marking any requirement as 🟢 Complete, verify ALL of the following:

## Quick Checklist

### 1. All Tasks Checked Off
- Every `- [ ]` is now `- [x]`
- No tasks skipped or forgotten

### 2. Completion Criteria Met
- Read "Completion:" field in requirement
- Verify each criterion satisfied

### 3. Tests Passing (NON-NEGOTIABLE)

**CRITICAL:** Run verification script BEFORE marking complete.

```bash
bash Haunt/scripts/verify-tests.sh REQ-XXX <frontend|backend|infrastructure>
```

**Requirements:**
- Frontend: `npm test` AND `npx playwright test` = 0 failures
- Backend: `npm test` (or `pytest tests/`) = 0 failures
- Infrastructure: Manual verification documented

**NO EXCEPTIONS. If tests fail, work is NOT complete.**

### 4. Files Updated
- All files in "Files:" section modified/created
- Changes committed or ready to commit

### 5. Documentation Updated (if applicable)
- README updated if API changed
- Comments added for complex logic
- Type annotations complete

### 6. Security Review (if applicable)
- Check `.haunt/checklists/security-checklist.md` if code involves user input, auth, DB queries, API calls, file ops, env vars
- Fix any security issues found

### 7. Iterative Code Refinement

**Required passes by size:**
- XS: 1-pass (Initial)
- S: 2-pass (Initial → Refinement)
- M: 3-pass (Initial → Refinement → Enhancement)

⛔ **CONSULTATION GATE:** For detailed pass checklists (error handling, naming, testing, security, performance), READ `references/detailed-checklist.md`.

### 8. Code Review (Hybrid Workflow)

**XS/S Requirements:** Self-validation sufficient → mark 🟢 directly

**M/SPLIT Requirements:** Automatic code review REQUIRED → spawn Code Reviewer, wait for verdict

### 9. Professional Standards (FINAL GATE)

**The CTO Question:** "Would I demonstrate this code to my CTO/boss with confidence?"

If NO or "maybe with caveats" → work is NOT complete. Go back and fix it.

## Consultation Gates

⛔ **CONSULTATION GATE:** For detailed refinement pass checklists (Pass 1/2/3/4 items), READ `references/detailed-checklist.md`.

⛔ **CONSULTATION GATE:** For UI/UX validation checklist (8px grid, contrast, interactive states, keyboard nav, responsive), READ `references/detailed-checklist.md`.

⛔ **CONSULTATION GATE:** For professional standards reflection questions and accountability guidance, READ `references/detailed-checklist.md`.

## Completion Sequence

1. Verify all applicable items above
2. Answer the CTO Question (REQUIRED)
3. Update requirement status: 🟡 → 🟢
4. Update "Completion:" field with verification note
5. Notify PM (if present) for archival

## Prohibitions

- NEVER mark 🟢 without checking all tasks
- NEVER mark 🟢 with failing tests
- NEVER skip the checklist "because it's a small change"
- NEVER mark M/SPLIT 🟢 without Code Reviewer approval
- NEVER mark 🟢 if you wouldn't confidently demo it to your CTO
