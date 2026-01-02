# Deep Mode Strategic Analysis Template

## When to Use Deep Mode

Generate the strategic analysis document when:
- Feature is M-SPLIT sized (4+ hours, 8+ files, >300 lines)
- High strategic impact on value proposition
- Significant architectural changes required
- Multiple stakeholder groups affected
- Complex risk profile (3+ critical/high risks)
- Competitive differentiation opportunity
- Requires executive/leadership approval

## Document Format

**File Location:** `.haunt/plans/REQ-XXX-strategic-analysis.md`

**Generated AFTER:** Standard requirements-analysis.md complete AND roadmap created (use first REQ number)

---

```markdown
# Strategic Analysis: [Feature Name]

**Requirement:** REQ-XXX
**Created:** YYYY-MM-DD
**Author:** Project Manager Agent
**Analysis Type:** Deep Strategic Assessment

---

## Executive Summary

[2-3 paragraphs summarizing strategic importance, key risks, and recommendation]

**Key Points:**
- **Strategic Value:** [Primary benefit in one sentence]
- **Competitive Position:** [VRIO implication - Sustained Advantage / Temporary / Parity]
- **Critical Risks:** [1-2 highest severity risks]
- **Recommendation:** [Proceed / Proceed with Modifications / Defer / Do Not Proceed]

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
| **Rare** | Yes/No | [Competitor landscape - who has this?] | [Differentiation potential] |
| **Inimitable** | Yes/No | [Barriers to copying - patents, expertise, time?] | [Sustainability] |
| **Organized** | Yes/No | [Our capability to execute - resources, process?] | [Exploitation readiness] |

**Competitive Implication:**
- [ ] Competitive Disadvantage (not valuable)
- [ ] Competitive Parity (valuable but not rare)
- [ ] Temporary Advantage (valuable, rare, but imitable)
- [ ] Sustained Advantage (all four criteria met)

**Rationale:** [Detailed explanation of selection with evidence]

---

## Risk Assessment Matrix

| Risk | Probability | Impact | Severity | Mitigation Strategy |
|------|-------------|--------|----------|---------------------|
| [Technical risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Market risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Resource risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |
| [Integration risk] | High/Med/Low | High/Med/Low | Critical/High/Med/Low | [How to mitigate] |

**Severity Calculation:** Probability × Impact = Severity
- Critical: High Probability × High Impact
- High: (High × Medium) or (Medium × High)
- Medium: (Medium × Medium) or (Low × High)
- Low: Other combinations

**Critical Risks (Severity: Critical/High):**
1. [Highest severity risk with detailed mitigation plan including:
   - Early warning indicators
   - Trigger points for escalation
   - Contingency plan if mitigation fails]
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
| [Group 1 - e.g., End Users] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |
| [Group 2 - e.g., Internal Team] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |
| [Group 3 - e.g., Leadership] | [Current experience] | [Future experience] | High/Med/Low | [How to involve] |

**Stakeholder Roles:**
- **Champions:** [Who will advocate for this, how to empower them]
- **Resisters:** [Who may oppose, why, how to address concerns]
- **Decision Makers:** [Who must approve, what they care about, approval criteria]
- **Implementers:** [Who will build this, what support they need]

**Communication Plan:**
- **Announcement:** [When and how to announce - timing, channel, message]
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
- **Net Impact:** [Overall technical debt trajectory - increasing/decreasing/neutral]

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

---

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
- Risk Matrix - Likelihood × Impact
- Stakeholder Analysis - Impact and engagement mapping

**Created:** YYYY-MM-DD
**Author:** Project Manager Agent
**Next Review:** [Date for re-assessment if deferred]
```

---

## Deep Mode Workflow

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
