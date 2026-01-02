# Framework Reference Guide

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

## Detailed Framework Guidance

### Jobs To Be Done (JTBD)

**Format:**
> "When [situation], I want to [motivation], so I can [expected outcome]."

**Identify Three Job Types:**
- **Functional job:** What task is being accomplished?
- **Emotional job:** How does the user want to feel?
- **Social job:** How does the user want to be perceived?

**Example:**
- Functional: "Complete purchase quickly without friction"
- Emotional: "Feel confident my payment is secure"
- Social: "Appear tech-savvy and efficient"

### Kano Model

**Three Categories:**

| Category | Description | Example |
|----------|-------------|---------|
| **Basic** | Expected, causes dissatisfaction if missing | Password reset link, error messages |
| **Performance** | More is better, linear satisfaction | Faster load times, more filter options |
| **Delighter** | Unexpected, disproportionate satisfaction | AI suggestions, gamification |

**Classification Guide:**
- If users EXPECT it → Basic
- If users value MORE of it → Performance
- If users DON'T EXPECT it but love it → Delighter

### RICE Scoring

**Formula:** `RICE = (Reach × Impact × Confidence) / Effort`

**Component Definitions:**
- **Reach:** How many users affected per quarter? (number, e.g., 1000)
- **Impact:** Minimal (0.25), Low (0.5), Medium (1), High (2), Massive (3)
- **Confidence:** Low (50%), Medium (80%), High (100%)
- **Effort:** Person-weeks (e.g., 2 = 2 weeks of dev work)

**Example Calculation:**
- Reach: 500 users/quarter
- Impact: High (2)
- Confidence: High (100% = 1.0)
- Effort: 4 person-weeks
- **RICE:** (500 × 2 × 1.0) / 4 = **250**

### VRIO Framework

**Four Criteria:**

| Criterion | Question | If Yes → |
|-----------|----------|----------|
| **Valuable** | Does it reduce costs or increase revenue? | Continue |
| **Rare** | Do few competitors have this? | Continue |
| **Inimitable** | Is it hard to copy? | Continue |
| **Organized** | Can we exploit this effectively? | Sustained Advantage |

**Competitive Implications:**
- All NO → Competitive Disadvantage
- V only → Competitive Parity
- V + R → Temporary Advantage
- V + R + I + O → **Sustained Advantage**

### SWOT Analysis

**2x2 Matrix:**

| | Helpful | Harmful |
|---|---------|---------|
| **Internal** | Strengths | Weaknesses |
| **External** | Opportunities | Threats |

**Example Questions:**
- Strengths: What do we do well? What unique resources do we have?
- Weaknesses: What could we improve? What resources are we lacking?
- Opportunities: What trends could we capitalize on? What gaps exist in the market?
- Threats: What obstacles do we face? What are competitors doing?

### Impact/Effort Matrix

**Visual Quadrant Model:**

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

**Prioritization:**
1. **Quick Wins:** High impact, low effort → Do immediately
2. **Major Projects:** High impact, high effort → Plan carefully, allocate resources
3. **Fill-ins:** Low impact, low effort → Do when time permits
4. **Thankless Tasks:** Low impact, high effort → Question if worth doing

### Balanced Scorecard

**Four Perspectives:**

| Perspective | Focus | Example Metrics |
|-------------|-------|-----------------|
| **Financial** | Revenue, profit, cost | ARR growth, gross margin |
| **Customer** | Satisfaction, retention | NPS, churn rate, CAC |
| **Internal Process** | Efficiency, quality | Cycle time, defect rate |
| **Learning & Growth** | Innovation, capabilities | Training hours, new skills |

**Use for:** Communicating holistic impact to executives beyond just revenue

### PESTEL Analysis

**Six External Factors:**

| Factor | Questions to Ask |
|--------|------------------|
| **Political** | How do regulations, policies, or political stability affect this? |
| **Economic** | How do economic conditions (inflation, interest rates) impact this? |
| **Social** | What demographic or cultural trends are relevant? |
| **Technological** | What tech trends or disruptions matter? |
| **Environmental** | Are there sustainability or environmental considerations? |
| **Legal** | What laws, compliance, or legal risks apply? |

**Note:** Only include factors with High or Medium relevance. Skip None/Low factors to reduce noise.

### Porter's Value Chain

**Two Activity Categories:**

**Primary Activities (directly create value):**
- Inbound Logistics: Receiving, storing inputs
- Operations: Transforming inputs to outputs
- Outbound Logistics: Delivering outputs to customers
- Marketing & Sales: Attracting and selling to customers
- Service: Supporting customers after purchase

**Support Activities (enable primary activities):**
- Infrastructure: Management, planning, finance
- Human Resources: Recruiting, training, retaining
- Technology Development: R&D, process improvement
- Procurement: Purchasing inputs and resources

**Use for:** Identifying where feature impacts operational value creation

## Framework Selection Guide

**For Every Feature:**
- JTBD (always)
- Kano (always)
- RICE (always for prioritization)

**When Strategic Alignment Matters:**
- Business Model Canvas
- Porter's Value Chain
- Balanced Scorecard

**When Competitive Positioning Matters:**
- VRIO
- SWOT
- PESTEL (if external factors significant)

**When Visualizing Priorities:**
- Impact/Effort Matrix
