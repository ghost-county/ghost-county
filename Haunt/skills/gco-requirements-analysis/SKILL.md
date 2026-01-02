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

## Creating the Analysis Document

⛔ **CONSULTATION GATE:** Before writing output, READ `references/standard-template.md` for complete document structure.

**Standard Analysis:**
- Use template in `references/standard-template.md`
- Output to: `.haunt/plans/requirements-analysis.md`
- Include all 7 steps above with filled tables

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
