---
name: gco-requirements-development
description: Transform ideas into formal requirements. Phase 1 of idea-to-roadmap workflow.
---

# Requirements Development

**Output:** `.haunt/plans/requirements-document.md`

## Step 1: Understanding Checkpoint (Required)

Before writing requirements, confirm with user:

```
**What I heard:** [1-2 sentence summary]
**Scope:** [bullets]
**Assumptions:** [bullets]

Review each step, or run through to roadmap?
```

Wait for confirmation.

## Step 2: Apply 14-Dimension Rubric

| # | Dimension | Key Questions |
|---|-----------|---------------|
| 1 | Introduction | Purpose? Scope? Audience? |
| 2 | Goals | Business goals? User goals? Metrics? |
| 3 | User Stories | Who? What? Why? |
| 4 | Functional | What MUST system do? |
| 5 | Non-Functional | Performance? Security? Usability? |
| 6 | Technical | Platform? Stack? Integrations? |
| 7 | Design | UI/UX? Accessibility? |
| 8 | Testing | Strategy? Acceptance criteria? |
| 9 | Deployment | Process? Release criteria? |
| 10 | Maintenance | Support? SLAs? |
| 11 | Future | Out-of-scope for later? |
| 12 | Training | User/admin training needs? |
| 13 | Stakeholders | Who approves? Who owns? |
| 14 | Change Mgmt | How are changes handled? |

Not all apply to every feature.

## Step 3: Write Requirements

```markdown
### REQ-XXX: [Action-oriented title]

**Priority:** MUST | SHOULD | MAY
**Description:** The system SHALL [specific, testable behavior].
**Acceptance Criteria:**
- [ ] [Condition 1]
- [ ] [Condition 2]
**Dependencies:** Depends on: [X] | Blocks: [Y]
**Complexity:** S | M | L | XL
```

## Step 4: Map Dependencies

```
REQ-001 (Foundation)
    ├──► REQ-002
    └──► REQ-003
              └──► REQ-004
```

## Step 5: Check Existing Roadmap

- Continue REQ numbering from existing
- Note dependencies on existing items
- Flag conflicts with in-progress work

## Complexity Sizing

| Size | Duration | Characteristics |
|------|----------|-----------------|
| S | 1-4 hrs | Single file, clear scope |
| M | 4-8 hrs | 2-3 files, some complexity |
| L/XL | >1 week | **Must be broken down** |

## Quality Checklist

- [ ] Understanding confirmed with user
- [ ] Applicable dimensions addressed
- [ ] Requirements atomic and testable
- [ ] Dependencies mapped
- [ ] Complexity estimated
- [ ] Existing roadmap checked
