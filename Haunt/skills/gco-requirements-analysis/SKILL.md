------
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

## Process

### Step 1: Feature Clarification

Summarize the feature using foundational frameworks:

#### Jobs To Be Done (JTBD)
> "When [situation], I want to [motivation], so I can [expected outcome]."

Identify:
- **Functional job:** What task is being accomplished?
- **Emotional job:** How does the user want to feel?
- **Social job:** How does the user want to be perceived?

#### Kano Model Classification

| Category | Description | This Feature |
|----------|-------------|--------------|
| **Basic** | Expected, causes dissatisfaction if missing | [ ] |
| **Performance** | More is better, linear satisfaction | [ ] |
| **Delighter** | Unexpected, causes disproportionate satisfaction | [ ] |

### Step 2: Context Mapping

#### Business Model Canvas Impact

Assess which canvas elements this feature affects:

| Element | Impact | Notes |
|---------|--------|-------|
| **Value Proposition** | High/Medium/Low/None | |
| **Customer Segments** | High/Medium/Low/None | |
| **Channels** | High/Medium/Low/None | |
| **Customer Relationships** | High/Medium/Low/None | |
| **Revenue Streams** | High/Medium/Low/None | |
| **Key Resources** | High/Medium/Low/None | |
| **Key Activities** | High/Medium/Low/None | |
| **Key Partnerships** | High/Medium/Low/None | |
| **Cost Structure** | High/Medium/Low/None | |

### Step 3: Value Chain Mapping

#### Porter's Value Chain Analysis

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

Only include factors relevant to this feature:

| Factor | Relevance | Consideration |
|--------|-----------|---------------|
| **Political** | High/Medium/Low/None | |
| **Economic** | High/Medium/Low/None | |
| **Social** | High/Medium/Low/None | |
| **Technological** | High/Medium/Low/None | |
| **Environmental** | High/Medium/Low/None | |
| **Legal** | High/Medium/Low/None | |

### Step 5: Prioritization

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

**Placement:**
| Requirement | Impact | Effort | Quadrant |
|-------------|--------|--------|----------|
| REQ-XXX | High/Low | High/Low | |

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

## Analysis Document Template

```markdown
# Requirements Analysis: [Feature Name]

**Created:** [Date]
**Author:** Project Manager Agent
**Input Document:** requirements-document.md
**Version:** 1.0

---

## 1. Feature Overview

### Summary
[Brief description of the feature]

### Jobs To Be Done
- **Functional:** [Job]
- **Emotional:** [Job]
- **Social:** [Job]

### Kano Classification
[Basic / Performance / Delighter] - [Rationale]

---

## 2. Business Context

### Business Model Canvas Impact
[Table from Step 2]

### Ecosystem Dependencies
- [Dependency 1]
- [Dependency 2]

---

## 3. Value Chain Analysis

### Primary Activities Impact
[Summary of Porter's primary activities]

### Support Activities Impact
[Summary of Porter's support activities]

---

## 4. Strategic Assessment

### VRIO Analysis
[Table and competitive implication]

### SWOT Analysis
[Matrix from Step 4]

### External Factors (PESTEL)
[Relevant factors only]

---

## 5. Prioritization

### RICE Scores
[Table with scores]

### Impact/Effort Placement
[Matrix placement for each requirement]

### Cost-Benefit Summary
[Table]

---

## 6. Strategic Impact

### Balanced Scorecard
[Table from Step 6]

### Value Drivers
1. [Primary]
2. [Secondary]
3. [Tertiary]

### Risk Assessment
[Table of risks]

---

## 7. Recommendation

**Prioritization Decision:** [Yes / Yes with modifications / Defer / No]

**Rationale:**
[Explanation]

**Implementation Sequence:**
1. [First]
2. [Second]
3. [Third]

**Watch Items:**
- [Item requiring monitoring]
```

## Framework Quick Reference

| Framework | Purpose | When Most Useful |
|-----------|---------|------------------|
| **JTBD** | Understand user motivation | Always - foundational |
| **Kano** | Set expectations | Feature classification |
| **Business Model Canvas** | Strategic alignment | New capabilities |
| **Porter's Value Chain** | Operational impact | Process changes |
| **VRIO** | Competitive advantage | Differentiating features |
| **SWOT** | Internal/external fit | Risk assessment |
| **PESTEL** | External factors | Regulatory/market features |
| **RICE** | Quantitative priority | Backlog ordering |
| **Impact/Effort** | Quick visual priority | Resource allocation |
| **Balanced Scorecard** | Holistic impact | Executive communication |

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

When `--deep` flag is used, create an additional strategic analysis document with extended frameworks.

### Deep Mode Output Location

`.haunt/plans/REQ-XXX-strategic-analysis.md` (created AFTER roadmap, using first REQ number)

### Deep Mode Template

```markdown
# Strategic Analysis: [Feature Name]

**Requirement:** REQ-XXX
**Created:** YYYY-MM-DD
**Author:** Project Manager Agent
**Analysis Type:** Deep Strategic Assessment

---

## Executive Summary

[2-3 paragraphs summarizing strategic importance, key risks, and recommendation]

---

## Expanded SWOT Analysis

### Strengths
- [Internal capability that supports this feature]
- [Existing asset that provides advantage]
- [Team strength relevant to implementation]

### Weaknesses
- [Internal limitation to address]
- [Resource constraint]
- [Knowledge gap]

### Opportunities
- [Market opportunity this enables]
- [Strategic positioning benefit]
- [Revenue/growth potential]

### Threats
- [Competitive pressure]
- [Market risk]
- [Technical obsolescence risk]

---

## VRIO Competitive Analysis

| Criterion | Assessment | Evidence | Implications |
|-----------|------------|----------|--------------|
| **Valuable** | Yes/No | [How it impacts cost/revenue] | [Competitive impact] |
| **Rare** | Yes/No | [Competitor landscape] | [Differentiation potential] |
| **Inimitable** | Yes/No | [Barriers to copying] | [Sustainability] |
| **Organized** | Yes/No | [Our capability to execute] | [Exploitation readiness] |

**Competitive Implication:**
- [ ] Competitive Disadvantage (not valuable)
- [ ] Competitive Parity (valuable but not rare)
- [ ] Temporary Advantage (valuable, rare, but imitable)
- [ ] Sustained Advantage (all four criteria met)

**Rationale:** [Explanation of selection]

---

## Risk Assessment Matrix

| Risk | Probability | Impact | Severity | Mitigation Strategy |
|------|-------------|--------|----------|---------------------|
| [Technical risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Market risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Resource risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Integration risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |

**Critical Risks (Severity: Critical/High):**
1. [Highest severity risk with detailed mitigation plan]
2. [Second highest risk with mitigation plan]

**Risk Response Strategy:**
- **Avoid:** [Risks to avoid by changing approach]
- **Mitigate:** [Risks to reduce through controls]
- **Transfer:** [Risks to outsource or insure]
- **Accept:** [Acceptable risks with monitoring plan]

---

## Stakeholder Impact Analysis

| Stakeholder Group | Current State | Desired State | Impact Level | Engagement Strategy |
|-------------------|---------------|---------------|--------------|---------------------|
| [Group 1] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |
| [Group 2] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |
| [Group 3] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |

**Stakeholder Roles:**
- **Champions:** [Who will advocate for this, how to empower them]
- **Resisters:** [Who may oppose, why, how to address concerns]
- **Decision Makers:** [Who must approve, what they care about, approval criteria]
- **Implementers:** [Who will build this, what support they need]

**Communication Plan:**
- **Announcement:** [When and how to announce]
- **Updates:** [Frequency and channels for progress updates]
- **Feedback:** [How to collect and incorporate stakeholder feedback]

---

## Architectural Implications

### System Impact
- **Components Affected:** [List of systems/services that will change]
- **Integration Points:** [New or modified integrations with other systems]
- **Data Flow Changes:** [How data movement and processing changes]
- **API Changes:** [New or modified APIs, breaking changes]

### Technical Debt
- **Created:** [New technical debt this introduces]
- **Resolved:** [Existing technical debt this addresses]
- **Net Impact:** [Overall technical debt trajectory]

### Scalability Considerations
- **Performance:** [Impact on system performance, latency, throughput]
- **Capacity:** [Resource requirements - compute, storage, network]
- **Elasticity:** [Horizontal/vertical scaling characteristics]
- **Bottlenecks:** [Potential scaling bottlenecks to address]

### Migration & Rollback
- **Migration Strategy:** [How to move from current to new state]
- **Backward Compatibility:** [How to maintain compatibility during transition]
- **Rollback Plan:** [How to revert if issues arise]
- **Data Migration:** [Data migration requirements and approach]

### Technology Evaluation (if applicable)

**Options Considered:**

| Option | Pros | Cons | Fit Score (1-10) | Total Cost |
|--------|------|------|------------------|------------|
| [Technology A] | [Benefits] | [Drawbacks] | X/10 | $X or hours |
| [Technology B] | [Benefits] | [Drawbacks] | X/10 | $X or hours |
| [Technology C] | [Benefits] | [Drawbacks] | X/10 | $X or hours |

**Evaluation Criteria:**
- **Technical Fit:** [How well it solves the problem]
- **Team Familiarity:** [Learning curve considerations]
- **Community Support:** [Ecosystem maturity, documentation quality]
- **Long-term Viability:** [Vendor stability, project momentum]
- **Cost:** [Licensing, hosting, operational costs]

**Recommendation:** [Which technology and comprehensive rationale]

---


---

## Solution Design (Solutioning Phase)

This section provides the technical blueprint for implementation - answering HOW to build the feature.

### Component Architecture

**High-Level Design:**
```
[Component diagram using ASCII art or Mermaid reference]

Example:
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│   Frontend  │─────▶│  API Gateway │─────▶│   Backend   │
│  Component  │      │   (Auth)     │      │   Service   │
└─────────────┘      └──────────────┘      └─────────────┘
                            │
                            ▼
                     ┌──────────────┐
                     │   Database   │
                     └──────────────┘
```

**Component Responsibilities:**
- **[Component 1]:** [What it does, inputs/outputs, dependencies]
- **[Component 2]:** [What it does, inputs/outputs, dependencies]
- **[Component 3]:** [What it does, inputs/outputs, dependencies]

**Key Interactions:**
1. [Component A] → [Component B]: [What data flows, when, why]
2. [Component B] → [Component C]: [What data flows, when, why]

### API Contracts

**New Endpoints:**

```
POST /api/[resource]
Request: {
  "field1": "string",
  "field2": number
}
Response: {
  "id": "string",
  "created": "ISO8601"
}
Status Codes: 201 (Created), 400 (Bad Request), 401 (Unauthorized)
```

**Modified Endpoints:**
```
GET /api/[existing-resource]
Changes: Added query param ?filter=[value]
Breaking: No
```

**Contracts:**
- **Authentication:** [How auth is handled - JWT, session, API key?]
- **Rate Limiting:** [Limits imposed, enforcement mechanism]
- **Pagination:** [Cursor-based, offset-based, limits]
- **Error Format:** [Standardized error response structure]

### Data Model Design

**New Tables/Collections:**

```sql
CREATE TABLE [table_name] (
  id UUID PRIMARY KEY,
  [field1] VARCHAR(255) NOT NULL,
  [field2] INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT [constraint_name] ...
);
```

**Modified Tables:**
```sql
ALTER TABLE [existing_table]
ADD COLUMN [new_field] TYPE;
```

**Relationships:**
- [Table A] → [Table B]: One-to-Many via [foreign_key]
- [Table B] ← [Table C]: Many-to-Many via [junction_table]

**Indexes:**
- `CREATE INDEX idx_[name] ON [table]([columns])` - [Why this index]

**Data Migration:**
- Existing data handling: [Backfill strategy, transformation logic]
- Migration script location: `migrations/YYYY-MM-DD-[description].sql`

### State Management (for frontend features)

**State Shape:**
```typescript
interface [FeatureName]State {
  [field1]: Type;
  [field2]: Type;
  loading: boolean;
  error: string | null;
}
```

**State Location:**
- Context (React Context API)
- Store (Redux/Zustand/Jotai)
- URL (query params for filtering/pagination)
- Local Storage (user preferences)

**State Flow:**
1. [Action] → [State change] → [UI update]
2. [User interaction] → [API call] → [State update]

### Implementation Approach

**Development Sequence:**
1. **Foundation (Day 1-2):**
   - [Set up infrastructure/boilerplate]
   - [Create data models/migrations]
   - [Scaffold components]

2. **Core Functionality (Day 3-5):**
   - [Implement main logic]
   - [Wire up API endpoints]
   - [Connect frontend to backend]

3. **Validation & Testing (Day 6-7):**
   - [Write tests (unit, integration, e2e)]
   - [Manual testing scenarios]
   - [Edge case validation]

4. **Polish & Deploy (Day 8):**
   - [Error handling refinement]
   - [Performance optimization]
   - [Documentation]
   - [Deployment]

**Critical Path Items:**
- [Item that blocks other work]
- [Dependency that must complete first]

**Parallel Work Opportunities:**
- [Work that can happen simultaneously]
- [Independent components that can be built in parallel]

### Design Patterns

**Patterns to Use:**
- **[Pattern 1]:** [Why it fits this problem]
- **[Pattern 2]:** [What it enables]

**Patterns to Avoid:**
- **[Anti-pattern 1]:** [Why it's wrong for this context]
- **[Anti-pattern 2]:** [Better alternative]

### Testing Strategy

**Test Coverage:**
- **Unit Tests:** [What to test at unit level]
- **Integration Tests:** [What integrations to verify]
- **E2E Tests:** [User flows to automate]
- **Performance Tests:** [Load/stress test scenarios if applicable]

**Test Data:**
- [Fixtures/mocks needed]
- [Test database seeding approach]

**Coverage Target:** [X%] minimum

### Code Examples & References

**Similar Patterns in Codebase:**
- `path/to/file.ext:line` - [Description of similar implementation]
- `path/to/other.ext:line` - [Pattern to follow]

**External References:**
- [Library documentation URL]
- [Tutorial or guide that demonstrates approach]
- [Similar open source implementation to reference]


## Strategic Recommendation

**Decision:** Proceed / Proceed with Modifications / Defer / Do Not Proceed

**Rationale:**
[2-3 paragraphs explaining recommendation based on analysis above. Address:
- Strategic value vs cost/risk trade-off
- Alignment with business objectives
- Readiness assessment (capability, capacity, timing)
- Key decision factors that led to recommendation]

**Prerequisites (if Proceed or Proceed with Modifications):**
1. [What must be in place before starting - dependencies, approvals]
2. [Resource allocations needed]
3. [Technical prerequisites]

**Modifications (if Proceed with Modifications):**
1. [Scope adjustment to reduce risk]
2. [Phasing strategy to deliver incrementally]
3. [Additional validation/prototyping needed]

**Deferral Conditions (if Defer):**
- [Conditions that must be met to revisit]
- [Timeline for re-evaluation]

**Success Metrics:**
- **Leading Indicators:** [Early signals of success during development]
- **Lagging Indicators:** [Post-launch validation metrics]
- **Key Results:** [Specific, measurable outcomes within timeframe]

**Review Gates:**
- **Design Review:** [When to validate design, what to check]
- **Prototype Review:** [What to test/validate before full build]
- **Launch Readiness:** [Criteria for go-live decision]
- **Post-Launch:** [When to review outcomes, success criteria]

**Contingency Plans:**
- **If metrics don't meet targets:** [What to do]
- **If timeline slips:** [How to adjust scope or sequence]
- **If costs exceed estimates:** [Decision framework for continue/pivot/stop]

---

## Appendix: Framework References

**Frameworks Applied:**
- Jobs To Be Done (JTBD) - User motivation analysis
- Kano Model - Feature classification
- RICE Scoring - Quantitative prioritization
- SWOT Analysis - Internal/external factors
- VRIO Framework - Competitive advantage assessment
- Risk Matrix - Likelihood x Impact
- Stakeholder Analysis - Impact and engagement mapping

**Created:** YYYY-MM-DD
**Author:** Project Manager Agent
**Next Review:** [Date for re-assessment if deferred]
```

### When to Generate Deep Analysis

Generate the strategic analysis document when:
- Feature is M-SPLIT sized (4+ hours, 8+ files, >300 lines)
- High strategic impact on value proposition
- Significant architectural changes required
- Multiple stakeholder groups affected
- Complex risk profile (3+ critical/high risks)
- Competitive differentiation opportunity
- Requires executive/leadership approval

### Deep Mode Workflow

1. Complete standard Phase 2 (requirements-analysis.md)
2. Create REQ-XXX-strategic-analysis.md using template above
3. Fill in all sections with detailed analysis
4. Reference strategic analysis in roadmap requirement notes:

```markdown
### ⚪ REQ-XXX: [Feature Title]

**Type:** Enhancement
**Reported:** YYYY-MM-DD
**Source:** Deep séance analysis

**Description:**
[Standard description]

**Strategic Analysis:**
See `.haunt/plans/REQ-XXX-strategic-analysis.md` for:
- Competitive advantage assessment (VRIO: Sustained Advantage)
- Risk matrix with mitigation strategies
- Stakeholder impact analysis
- Architectural implications

[Rest of standard requirement fields...]
```

## Handoff to Phase 3

After creating `requirements-analysis.md` (and `REQ-XXX-strategic-analysis.md` if --deep):

If user selected **review mode**:
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

If user selected **run-through mode**:
> Proceed directly to Phase 3 (roadmap-creation skill)
