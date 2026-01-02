# Standard Requirements Analysis Template

## Document Format

Use this template for standard (non-deep) requirements analysis output.

**File Location:** `.haunt/plans/requirements-analysis.md`

---

```markdown
# Requirements Analysis: [Feature Name]

**Created:** [Date]
**Author:** Project Manager Agent
**Input Document:** requirements-document.md
**Version:** 1.0

---

## 1. Feature Overview

### Summary
[Brief description of the feature - 2-3 sentences]

### Jobs To Be Done
- **Functional:** [What task is being accomplished]
- **Emotional:** [How the user wants to feel]
- **Social:** [How the user wants to be perceived]

### Kano Classification
[Basic / Performance / Delighter] - [Rationale for classification]

---

## 2. Business Context

### Business Model Canvas Impact

| Element | Impact | Notes |
|---------|--------|-------|
| **Value Proposition** | High/Medium/Low/None | [How feature affects value proposition] |
| **Customer Segments** | High/Medium/Low/None | [Which segments benefit] |
| **Channels** | High/Medium/Low/None | [Distribution impact] |
| **Customer Relationships** | High/Medium/Low/None | [Relationship type changes] |
| **Revenue Streams** | High/Medium/Low/None | [Revenue impact] |
| **Key Resources** | High/Medium/Low/None | [Resource requirements] |
| **Key Activities** | High/Medium/Low/None | [Activity changes] |
| **Key Partnerships** | High/Medium/Low/None | [Partnership needs] |
| **Cost Structure** | High/Medium/Low/None | [Cost implications] |

### Ecosystem Dependencies
- [Dependency 1]
- [Dependency 2]

---

## 3. Value Chain Analysis

### Primary Activities Impact

| Activity | Impact | How |
|----------|--------|-----|
| Inbound Logistics | High/Med/Low/None | [Specific impact] |
| Operations | High/Med/Low/None | [Specific impact] |
| Outbound Logistics | High/Med/Low/None | [Specific impact] |
| Marketing & Sales | High/Med/Low/None | [Specific impact] |
| Service | High/Med/Low/None | [Specific impact] |

**Summary:** [1-2 sentences on primary activities impact]

### Support Activities Impact

| Activity | Impact | How |
|----------|--------|-----|
| Infrastructure | High/Med/Low/None | [Specific impact] |
| Human Resources | High/Med/Low/None | [Specific impact] |
| Technology Development | High/Med/Low/None | [Specific impact] |
| Procurement | High/Med/Low/None | [Specific impact] |

**Summary:** [1-2 sentences on support activities impact]

---

## 4. Strategic Assessment

### VRIO Analysis

| Criterion | Assessment | Evidence |
|-----------|------------|----------|
| **Valuable** | Yes/No | [Does it reduce costs or increase revenue? How?] |
| **Rare** | Yes/No | [Do few competitors have this? Evidence?] |
| **Inimitable** | Yes/No | [Is it hard to copy? Why?] |
| **Organized** | Yes/No | [Can we exploit this effectively? Capability?] |

**Competitive Implication:**
- [ ] Competitive Disadvantage (not valuable)
- [ ] Competitive Parity (valuable but not rare)
- [ ] Temporary Advantage (valuable, rare, but imitable)
- [ ] Sustained Advantage (all four criteria met)

**Rationale:** [Explanation of competitive implication]

### SWOT Analysis

| | Helpful | Harmful |
|---|---------|---------|
| **Internal** | **Strengths:** | **Weaknesses:** |
| | - [Strength 1] | - [Weakness 1] |
| | - [Strength 2] | - [Weakness 2] |
| **External** | **Opportunities:** | **Threats:** |
| | - [Opportunity 1] | - [Threat 1] |
| | - [Opportunity 2] | - [Threat 2] |

### External Factors (PESTEL)

Only include factors with High or Medium relevance:

| Factor | Relevance | Consideration |
|--------|-----------|---------------|
| **Political** | High/Medium/Low/None | [If High/Med: specific considerations] |
| **Economic** | High/Medium/Low/None | [If High/Med: specific considerations] |
| **Social** | High/Medium/Low/None | [If High/Med: specific considerations] |
| **Technological** | High/Medium/Low/None | [If High/Med: specific considerations] |
| **Environmental** | High/Medium/Low/None | [If High/Med: specific considerations] |
| **Legal** | High/Medium/Low/None | [If High/Med: specific considerations] |

---

## 5. Prioritization

### RICE Scores

For each requirement or requirement group:

| Requirement | Reach | Impact | Confidence | Effort | RICE Score |
|-------------|-------|--------|------------|--------|------------|
| REQ-XXX | [number] | [0.25-3] | [50-100%] | [weeks] | [(R×I×C)/E] |
| REQ-YYY | [number] | [0.25-3] | [50-100%] | [weeks] | [(R×I×C)/E] |

**Scoring Guide:**
- **Reach:** How many users affected per quarter? (number)
- **Impact:** Minimal (0.25), Low (0.5), Medium (1), High (2), Massive (3)
- **Confidence:** Low (50%), Medium (80%), High (100%)
- **Effort:** Person-weeks (lower is better)

**Priority Order (by RICE score):**
1. [Highest RICE] - REQ-XXX
2. [Second] - REQ-YYY
3. [Third] - REQ-ZZZ

### Impact/Effort Matrix

**Placement:**

| Requirement | Impact | Effort | Quadrant |
|-------------|--------|--------|----------|
| REQ-XXX | High/Low | High/Low | [Quick Wins/Major Projects/Fill-ins/Thankless Tasks] |
| REQ-YYY | High/Low | High/Low | [Quadrant] |

**Visual:**
```
                    HIGH IMPACT
                         │
     [REQ-XXX]           │      [REQ-YYY]
     Quick Wins          │      Major Projects
                         │
    LOW EFFORT ──────────┼────────── HIGH EFFORT
                         │
                         │
     Fill-ins            │      Thankless Tasks
                         │
                    LOW IMPACT
```

### Cost-Benefit Summary

| Requirement | Estimated Cost | Expected Benefit | Ratio |
|-------------|----------------|------------------|-------|
| REQ-XXX | [$X or Y hours] | [Revenue/savings/value] | [Benefit/Cost] |
| REQ-YYY | [$X or Y hours] | [Revenue/savings/value] | [Benefit/Cost] |

---

## 6. Strategic Impact

### Balanced Scorecard

| Perspective | Impact | Specific Effects |
|-------------|--------|------------------|
| **Financial** | High/Medium/Low | [Revenue, profit, cost impacts] |
| **Customer** | High/Medium/Low | [Satisfaction, retention impacts] |
| **Internal Process** | High/Medium/Low | [Efficiency, quality impacts] |
| **Learning & Growth** | High/Medium/Low | [Innovation, capability impacts] |

### Critical Value Drivers

1. **Primary driver:** [Most important value this delivers]
2. **Secondary driver:** [Second most important value]
3. **Tertiary driver:** [Third most important value]

### Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| [Technical risk] | Critical/High/Medium/Low | [How to reduce/avoid] |
| [Market risk] | Critical/High/Medium/Low | [How to reduce/avoid] |
| [Resource risk] | Critical/High/Medium/Low | [How to reduce/avoid] |

**Critical Risks (Severity: Critical/High):**
- [Most severe risk with detailed mitigation]

---

## 7. Recommendation

**Prioritization Decision:** [Yes / Yes with modifications / Defer / No]

**Rationale:**
[2-3 paragraphs explaining the recommendation based on analysis. Address:
- Strategic value vs cost/risk trade-off
- Alignment with business objectives
- Readiness assessment (capability, capacity, timing)
- Key decision factors]

**Implementation Sequence:**
1. [First requirement/group - why first]
2. [Second requirement/group - why second]
3. [Third requirement/group - why third]

**Critical Dependencies:**
- [Dependency that must be resolved before starting]
- [Prerequisite work or approval needed]

**Key Risks to Monitor:**
- [Risk requiring attention during implementation]
- [Mitigation triggers - when to escalate]

**Watch Items:**
- [Item requiring monitoring during development]
- [Metrics to track for early warning signs]

---

## Quality Checklist

Before completing Phase 2:

- [ ] JTBD clearly articulated (functional, emotional, social)
- [ ] Kano classification justified with rationale
- [ ] Business model impact assessed (all 9 elements)
- [ ] Value chain position mapped (primary + support activities)
- [ ] VRIO analysis complete with competitive implication
- [ ] SWOT analysis complete (all 4 quadrants)
- [ ] RICE scores calculated for all requirements
- [ ] Impact/Effort placement determined
- [ ] Strategic risks identified with mitigation strategies
- [ ] Implementation sequence recommended with rationale

---

**Created:** YYYY-MM-DD
**Author:** Project Manager Agent
**Next Steps:** Proceed to Phase 3 (Roadmap Creation) if approved
```
