---
name: gco-requirements-analysis
description: Strategic analysis of requirements using business frameworks (JTBD, Kano, Porter, VRIO, SWOT, RICE). Use after requirements-development to prioritize and assess strategic impact. Triggers on "analyze requirements", "prioritize features", "strategic analysis", or when the Project Manager begins Phase 2 of the idea-to-roadmap workflow.
---

**IMPORTANT - Model Selection:** This skill requires **Sonnet or Opus** model.

Strategic analysis frameworks (JTBD, Kano, RICE, SWOT, VRIO) require deep reasoning to identify implications, balance competing priorities, and make nuanced judgments.

**Cost vs Value:** Strategic analysis is high-leverage work. The cost difference between models is negligible compared to the cost of poor prioritization decisions or missed requirements that waste implementation time.

---

# Requirements Analysis

Analyze requirements using strategic business frameworks to prioritize and assess impact.

## When to Use

- After Phase 1 (requirements-development) completes
- When prioritizing a backlog of requirements
- Assessing strategic fit of proposed features
- Phase 2 of the idea-to-roadmap workflow

## Input

`.haunt/plans/requirements-document.md` (from Phase 1)

## Output Location

`.haunt/plans/requirements-analysis.md`

## Reference Index

| When You Need | Read This |
|---------------|-----------|
| **Framework definitions and scoring guides** | `references/framework-reference.md` |
| **Standard analysis document format** | `references/standard-template.md` |
| **Deep mode strategic analysis format** | `references/deep-mode-template.md` |

## Core Workflow

### Step 1: Feature Clarification

⛔ **CONSULTATION GATE:** Before starting, READ `references/framework-reference.md` for JTBD and Kano guidance.

Summarize the feature using foundational frameworks:

#### Jobs To Be Done (JTBD)
> "When [situation], I want to [motivation], so I can [expected outcome]."

Identify:
- **Functional job:** What task is being accomplished?
- **Emotional job:** How does the user want to feel?
- **Social job:** How does the user want to be perceived?

#### Kano Model Classification

| Category | Description | Mark One |
|----------|-------------|----------|
| **Basic** | Expected, causes dissatisfaction if missing | [ ] |
| **Performance** | More is better, linear satisfaction | [ ] |
| **Delighter** | Unexpected, disproportionate satisfaction | [ ] |

### Step 2: Context Mapping

Assess which Business Model Canvas elements this feature affects:

| Element | Impact (High/Med/Low/None) | Notes |
|---------|----------------------------|-------|
| Value Proposition | | |
| Customer Segments | | |
| Channels | | |
| Customer Relationships | | |
| Revenue Streams | | |
| Key Resources | | |
| Key Activities | | |
| Key Partnerships | | |
| Cost Structure | | |

### Step 3: Value Chain Mapping

⛔ **CONSULTATION GATE:** Before Porter's analysis, READ `references/framework-reference.md` for Value Chain guidance.

Assess impact on primary and support activities using Porter's Value Chain.

**Primary Activities:**
| Activity | Impact | How |
|----------|--------|-----|
| Inbound Logistics | | |
| Operations | | |
| Outbound Logistics | | |
| Marketing & Sales | | |
| Service | | |

**Support Activities:**
| Activity | Impact | How |
|----------|--------|-----|
| Infrastructure | | |
| Human Resources | | |
| Technology Development | | |
| Procurement | | |

### Step 4: Strategic Analysis

⛔ **CONSULTATION GATE:** Before VRIO and SWOT, READ `references/framework-reference.md` for detailed assessment criteria.

#### VRIO Framework

| Criterion | Assessment | Evidence |
|-----------|------------|----------|
| **Valuable** | Yes/No | Does it reduce costs or increase revenue? |
| **Rare** | Yes/No | Do few competitors have this? |
| **Inimitable** | Yes/No | Is it hard to copy? |
| **Organized** | Yes/No | Can we exploit this effectively? |

**Competitive Implication:**
- [ ] Competitive Disadvantage (not valuable)
- [ ] Competitive Parity (valuable but not rare)
- [ ] Temporary Advantage (valuable, rare, but imitable)
- [ ] Sustained Advantage (all four criteria met)

#### SWOT Analysis

| | Helpful | Harmful |
|---|---------|---------|
| **Internal** | **Strengths:** | **Weaknesses:** |
| | - | - |
| **External** | **Opportunities:** | **Threats:** |
| | - | - |

#### PESTEL Considerations

Only include factors relevant to this feature (High/Medium relevance):

| Factor | Relevance | Consideration |
|--------|-----------|---------------|
| Political | High/Med/Low/None | |
| Economic | High/Med/Low/None | |
| Social | High/Med/Low/None | |
| Technological | High/Med/Low/None | |
| Environmental | High/Med/Low/None | |
| Legal | High/Med/Low/None | |

### Step 5: Prioritization

⛔ **CONSULTATION GATE:** Before scoring, READ `references/framework-reference.md` for RICE formula and Impact/Effort matrix.

#### RICE Scoring

For each requirement or requirement group:

| Requirement | Reach | Impact | Confidence | Effort | RICE Score |
|-------------|-------|--------|------------|--------|------------|
| REQ-XXX | | | | | |

**Scoring Guide:**
- **Reach:** How many users affected per quarter? (number)
- **Impact:** Minimal (0.25), Low (0.5), Medium (1), High (2), Massive (3)
- **Confidence:** Low (50%), Medium (80%), High (100%)
- **Effort:** Person-weeks (lower is better)

**Formula:** `RICE = (Reach × Impact × Confidence) / Effort`

#### Impact/Effort Matrix

**Placement:**
| Requirement | Impact | Effort | Quadrant |
|-------------|--------|--------|----------|
| REQ-XXX | High/Low | High/Low | |

**Visual Reference:**
```
                    HIGH IMPACT
                         │
         Quick Wins      │      Major Projects
         (Do First)      │      (Plan Carefully)
                         │
    LOW EFFORT ──────────┼────────── HIGH EFFORT
                         │
         Fill-ins        │      Thankless Tasks
         (Do Later)      │      (Avoid/Delegate)
                         │
                    LOW IMPACT
```

#### Cost-Benefit Summary

| Requirement | Estimated Cost | Expected Benefit | Ratio |
|-------------|----------------|------------------|-------|
| REQ-XXX | | | |

### Step 6: Strategic Impact Synthesis

#### Balanced Scorecard Mapping

| Perspective | Impact | Specific Effects |
|-------------|--------|------------------|
| **Financial** | High/Medium/Low | |
| **Customer** | High/Medium/Low | |
| **Internal Process** | High/Medium/Low | |
| **Learning & Growth** | High/Medium/Low | |

#### Critical Value Drivers

1. **Primary driver:** [Most important value this delivers]
2. **Secondary driver:** [Second most important]
3. **Tertiary driver:** [Third most important]

#### Strategic Risks

| Risk | Severity | Mitigation |
|------|----------|------------|
| [Risk 1] | Critical/High/Medium/Low | |
| [Risk 2] | Critical/High/Medium/Low | |

### Step 7: Implementation Recommendation

Based on the analysis:

```markdown
## Recommendation Summary

**Should this feature be prioritized?** Yes / Yes with modifications / Defer / No

**Rationale:** [2-3 sentences explaining the recommendation]

**Suggested Implementation Sequence:**
1. [First requirement/group - why first]
2. [Second requirement/group - why second]
3. [Third requirement/group - why third]

**Critical Dependencies:**
- [Dependency that must be resolved]

**Key Risks to Monitor:**
- [Risk requiring attention during implementation]
```

### Step 8: Solution Critique (MANDATORY)

⛔ **CRITICAL:** This step is MANDATORY for all requirements. Do NOT proceed to roadmap creation without completing the appropriate tier of critique.

Before creating the roadmap, challenge the proposed solution to ensure it's the simplest, most elegant approach. The depth of critique scales with requirement complexity:

#### Tier Selection

| Requirement Size | Critique Tier | Time Investment |
|------------------|---------------|-----------------|
| XS (30min-1hr, 1-2 files) | XS Tier | ~30 seconds |
| S (1-2hr, 2-4 files) | S/M Tier | 1-3 minutes |
| M (2-4hr, 4-8 files) | S/M Tier | 1-3 minutes |
| Greenfield / Multi-requirement feature | Greenfield Tier | Full deep review |

#### XS Tier: Quick Simplicity Check (~30 seconds)

For small, focused changes, ask:

```
Before proceeding: Is this the simplest solution? Could we solve this by modifying existing code instead of adding new? [YES/NO + 1 sentence]
```

**Example:**
> **Q:** Is this the simplest solution? Could we solve this by modifying existing code instead of adding new?
>
> **A:** YES. We can add a single parameter to the existing `formatDate()` function instead of creating a new `formatDateWithTimezone()` function.

#### S/M Tier: Standard Solution Critique (1-3 minutes)

For standard features and enhancements:

```
Solution Critique:
1. Problem being solved (1 sentence)
2. Simplest possible solution
3. One alternative we're NOT doing, and why
4. What can we eliminate?
```

**Example:**
> **Solution Critique:**
>
> 1. **Problem:** Users can't filter dashboard widgets by date range
> 2. **Simplest solution:** Add date range picker to existing filter bar, reuse current filter logic
> 3. **Alternative NOT doing:** Custom date range builder with presets - adds complexity, users want simple start/end dates
> 4. **Can eliminate:** "Smart date suggestions" feature - YAGNI, implement if users request it

#### Greenfield Tier: Full Solution Space Exploration

For new features, architectural changes, or multi-requirement work:

```
Full solution space exploration:
1. Problem statement and root cause analysis
2. 3+ alternative approaches with trade-offs
3. Why chosen approach is optimal
4. What's being deliberately excluded and why
5. Risks and assumptions being made
6. Dependencies that could change the approach
```

**Example:**
> **Full Solution Space Exploration:**
>
> 1. **Problem & Root Cause:** Users abandon checkout because payment form requires account creation. Root cause: We conflated identity (account) with transaction (payment).
>
> 2. **Alternative Approaches:**
>    - **Guest checkout with optional account:** Collect minimal info, offer account creation post-purchase
>      - Trade-offs: Best UX, more complex account linking, potential duplicate records
>    - **Social login only:** Use OAuth (Google/Apple) for instant accounts
>      - Trade-offs: Fast implementation, excludes users without social accounts (~15%)
>    - **Passwordless email-only:** Email magic link for identity
>      - Trade-offs: Simple, requires email verification before purchase (friction)
>
> 3. **Why Chosen Approach (Guest checkout):** Removes friction for 100% of users, optional account creation captures emails for marketing, account linking is one-time complexity cost
>
> 4. **Deliberately Excluded:** Phone number as identity method - adds SMS costs, international complications, not requested by users
>
> 5. **Risks & Assumptions:**
>    - Risk: Users create multiple accounts, fragment order history
>    - Mitigation: Email-based duplicate detection, account merging workflow
>    - Assumption: Guest checkout increases conversion more than marketing opt-ins decrease
>
> 6. **Dependencies:** Email service for order confirmations, analytics to measure conversion impact, account merging if duplicate detection triggers

#### Integration with Quality Checklist

Add solution critique completion to the quality checklist (see Quality Checklist section below).

## Creating the Analysis Document

⛔ **CONSULTATION GATE:** Before writing output, READ `references/standard-template.md` for complete document structure.

**Standard Analysis:**
- Use template in `references/standard-template.md`
- Output to: `.haunt/plans/requirements-analysis.md`
- Include all 8 steps above with filled tables (including Step 8: Solution Critique)

**Deep Mode Analysis (if --deep flag):**
- ALSO create extended analysis using `references/deep-mode-template.md`
- Output to: `.haunt/plans/REQ-XXX-strategic-analysis.md`
- Use first REQ number from roadmap
- See Deep Mode section below for triggers

## Quality Checklist

Before completing Phase 2:

- [ ] JTBD clearly articulated
- [ ] Kano classification justified
- [ ] Business model impact assessed
- [ ] Value chain position mapped
- [ ] VRIO analysis complete
- [ ] SWOT analysis complete
- [ ] RICE scores calculated
- [ ] Impact/Effort placement determined
- [ ] Strategic risks identified
- [ ] Implementation sequence recommended
- [ ] **Solution critique completed** (XS/S/M/Greenfield tier as appropriate)

## Deep Mode: Extended Strategic Analysis

⛔ **CONSULTATION GATE:** Before generating deep analysis, READ `references/deep-mode-template.md` for complete template.

### When to Generate Deep Analysis

Generate the strategic analysis document when:
- Feature is M-SPLIT sized (4+ hours, 8+ files, >300 lines)
- High strategic impact on value proposition
- Significant architectural changes required
- Multiple stakeholder groups affected
- Complex risk profile (3+ critical/high risks)
- Competitive differentiation opportunity
- Requires executive/leadership approval

### Deep Mode Output

**File:** `.haunt/plans/REQ-XXX-strategic-analysis.md` (created AFTER roadmap, using first REQ number)

**Template:** See `references/deep-mode-template.md`

**Includes:**
- Executive summary
- Expanded SWOT with detailed analysis
- VRIO competitive analysis with implications
- Risk assessment matrix with mitigation strategies
- Stakeholder impact analysis with engagement plan
- Architectural implications (system impact, technical debt, scalability)
- Technology evaluation (if applicable)
- Solution design (component architecture, API contracts, data model)
- Implementation approach (development sequence, design patterns)
- Testing strategy
- Strategic recommendation with success metrics

### Deep Mode Workflow

1. Complete standard Phase 2 (requirements-analysis.md)
2. Create REQ-XXX-strategic-analysis.md using deep mode template
3. Fill in all sections with detailed analysis
4. Reference strategic analysis in roadmap requirement notes:

```markdown
### ⚪ REQ-XXX: [Feature Title]

**Strategic Analysis:**
See `.haunt/plans/REQ-XXX-strategic-analysis.md` for:
- Competitive advantage assessment (VRIO: Sustained Advantage)
- Risk matrix with mitigation strategies
- Stakeholder impact analysis
- Architectural implications
```

## Handoff to Phase 3

After creating `requirements-analysis.md` (and `REQ-XXX-strategic-analysis.md` if --deep):

**If user selected review mode:**
> "I've completed the strategic analysis at `.haunt/plans/requirements-analysis.md`.
>
> **Key findings:**
> - RICE scores suggest [priority order]
> - Primary value driver: [driver]
> - Main risk: [risk]
>
> [IF --deep mode:]
> I've also created an extended strategic analysis at `.haunt/plans/REQ-XXX-strategic-analysis.md` with:
> - VRIO assessment: [result]
> - Critical risks: [count] identified with mitigation plans
> - Stakeholder impact: [summary]
>
> Please review and let me know if you'd like any changes before I create the roadmap."

**If user selected run-through mode:**
> Proceed directly to Phase 3 (roadmap-creation skill)

## Quick Reference: Frameworks

See `references/framework-reference.md` for:
- Framework selection guide
- Detailed scoring criteria
- Example calculations
- When to use each framework

**Essential Frameworks (always use):**
- JTBD (user motivation)
- Kano (feature classification)
- RICE (prioritization)

**Strategic Frameworks (use when applicable):**
- Business Model Canvas (strategic alignment)
- Porter's Value Chain (operational impact)
- VRIO (competitive advantage)
- SWOT (internal/external fit)
- PESTEL (external factors)
- Balanced Scorecard (holistic impact)
